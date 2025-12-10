import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../../widgets/blurred_video_background.dart';
import 'glass_bottom_nav_bar.dart';
import '../../../routes/route_names.dart';
import '../../../features/events/screens/events_hub_screen.dart';
import '../../../features/events/providers/events_provider.dart';
import '../../../shared/widgets/event_card.dart';
import '../../../shared/widgets/profile_avatar.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../features/profile/providers/profile_provider.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/events/providers/event_management_provider.dart';
import '../../../features/profile/services/storage_service.dart';
import '../../../shared/components/inputs/glass_text_field.dart';
import '../../../shared/components/glass/glass_container.dart';
import '../../../shared/widgets/error_dialog.dart';
import '../../../core/branding/branding.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

/// Scaffold principal con sistema de tabs y navegación fluida estilo VisionOS
class MainTabScaffold extends StatefulWidget {
  const MainTabScaffold({super.key});

  @override
  State<MainTabScaffold> createState() => _MainTabScaffoldState();
}

class _MainTabScaffoldState extends State<MainTabScaffold>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final List<Widget> _screens;
  late final AnimationController _transitionController;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _screens = [
      const _TabContentWrapper(child: EventsHubContent()),
      const _TabContentWrapper(child: SearchContent()),
      const _TabContentWrapper(
          child: CreateEventContent()), // Tab de crear evento
      const _TabContentWrapper(child: ActivityFeedContent()),
      const _TabContentWrapper(child: ProfileContent()),
    ];
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    // Todos los tabs usan la misma transición fluida
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });

      _transitionController.forward(from: 0.0).then((_) {
        _transitionController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlurredVideoBackground(
      child: CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            children: [
              // Contenido con transiciones suaves
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.05, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  key: ValueKey<int>(_currentIndex),
                  child: _screens[_currentIndex],
                ),
              ),

              // Bottom Navigation Bar siempre visible
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: GlassBottomNavBar(
                  currentIndex: _currentIndex,
                  onTap: _onNavTap,
                  items: const [
                    BottomNavItem(
                      icon: CupertinoIcons.home,
                      activeIcon: CupertinoIcons.house_fill,
                      label: 'Inicio',
                    ),
                    BottomNavItem(
                      icon: CupertinoIcons.search,
                      activeIcon: CupertinoIcons.search,
                      label: 'Buscar',
                    ),
                    BottomNavItem(
                      icon: CupertinoIcons.add_circled,
                      activeIcon: CupertinoIcons.add_circled_solid,
                      label: 'Crear',
                    ),
                    BottomNavItem(
                      icon: CupertinoIcons.bell,
                      activeIcon: CupertinoIcons.bell_fill,
                      label: 'Actividad',
                    ),
                    BottomNavItem(
                      icon: CupertinoIcons.person,
                      activeIcon: CupertinoIcons.person_fill,
                      label: 'Perfil',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Wrapper para el contenido de cada tab que maneja el padding inferior
class _TabContentWrapper extends StatelessWidget {
  final Widget child;

  const _TabContentWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 120 +
            MediaQuery.of(context)
                .padding
                .bottom, // Aumentado para evitar overflow
      ),
      child: child,
    );
  }
}

/// Contenido del tab de eventos sin el bottom nav bar
class EventsHubContent extends StatelessWidget {
  const EventsHubContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const EventsHubScreenContent();
  }
}

/// Contenido de búsqueda sin el scaffold duplicado
class SearchContent extends ConsumerStatefulWidget {
  const SearchContent({super.key});

  @override
  ConsumerState<SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends ConsumerState<SearchContent> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = _searchQuery.isEmpty
        ? null
        : ref.watch(searchEventsProvider(_searchQuery));

    return Column(
      children: [
        // Barra de búsqueda
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: CupertinoSearchTextField(
            controller: _searchController,
            placeholder: 'Buscar eventos, personas, comunidades...',
            onSubmitted: (value) {
              setState(() => _searchQuery = value);
            },
          ),
        ),
        // Resultados
        Expanded(
          child: _searchQuery.isEmpty
              ? const Center(
                  child: Text('Ingresa un término de búsqueda'),
                )
              : searchResults!.when(
                  data: (events) => events.isEmpty
                      ? const Center(
                          child: Text('No se encontraron resultados'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return EventCard(
                              event: event,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.eventDetailPath(event.id),
                                );
                              },
                            );
                          },
                        ),
                  loading: () => const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                  error: (error, stack) => Center(
                    child: Text('Error: $error'),
                  ),
                ),
        ),
      ],
    );
  }
}

/// Contenido de actividad sin el scaffold duplicado
class ActivityFeedContent extends ConsumerWidget {
  const ActivityFeedContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            // TODO: Refrescar feed
          },
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: 'Actividad reciente'),
                SizedBox(height: 16),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'No hay actividad reciente',
                      style: TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Contenido de perfil sin el scaffold duplicado
class ProfileContent extends ConsumerWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final authService = ref.watch(authServiceProvider);
    final user = authService.currentUser;

    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return const Center(child: Text('Error al cargar perfil'));
        }

        return CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                ref.invalidate(currentProfileProvider);
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    ProfileAvatar(
                      imageUrl: profile.avatarUrl,
                      name: profile.name,
                      radius: 50,
                      showBorder: true,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile.name ?? 'Usuario',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        profile.bio!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.secondaryLabel,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (profile.city != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.location,
                            size: 16,
                            color: CupertinoColors.secondaryLabel,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            profile.city!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.secondaryLabel,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          user?.email != null
                              ? CupertinoIcons.mail
                              : CupertinoIcons.phone,
                          size: 16,
                          color: CupertinoColors.secondaryLabel,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user?.email ?? user?.phone ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ),
                        if (profile.isVerified) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            CupertinoIcons.check_mark_circled_solid,
                            size: 16,
                            color: CupertinoColors.systemGreen,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 32),
                    // TODO: Agregar secciones de configuración y comunidad
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CupertinoActivityIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}

/// Contenido de crear evento como tab (sin navegación hacia atrás)
class CreateEventContent extends ConsumerStatefulWidget {
  const CreateEventContent({super.key});

  @override
  ConsumerState<CreateEventContent> createState() => _CreateEventContentState();
}

class _CreateEventContentState extends ConsumerState<CreateEventContent> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime? _startTime;
  DateTime? _endTime;
  File? _selectedImage;
  bool _isPublic = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _selectStartTime() async {
    await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: _startTime ?? DateTime.now(),
            mode: CupertinoDatePickerMode.dateAndTime,
            minimumDate: DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _startTime = newDate;
              });
            },
          ),
        ),
      ),
    );
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startTime == null) {
      ErrorDialog.show(
        context,
        title: 'Error',
        message: 'Por favor selecciona una fecha y hora de inicio',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      final storageService = StorageService();
      String? imageUrl;

      if (_selectedImage != null) {
        final tempEventId = DateTime.now().millisecondsSinceEpoch.toString();
        imageUrl =
            await storageService.uploadEventImage(tempEventId, _selectedImage!);
      }

      final eventService = ref.read(eventManagementServiceProvider);
      final event = await eventService.createEvent(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        startTime: _startTime!,
        endTime: _endTime,
        city: _cityController.text.trim().isEmpty
            ? null
            : _cityController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        imageUrl: imageUrl,
        createdBy: user.id,
        isPublic: _isPublic,
      );

      if (mounted) {
        // Limpiar el formulario después de crear
        _titleController.clear();
        _descriptionController.clear();
        _cityController.clear();
        _addressController.clear();
        _selectedImage = null;
        _startTime = null;
        _endTime = null;
        _isPublic = false;

        // Navegar al evento creado
        Navigator.pushNamed(
          context,
          RouteNames.manageEventPath(event.id),
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Error',
          message: e.toString(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Form(
      key: _formKey,
      child: CustomScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // Asegurar que siempre sea scrolleable
        slivers: [
          // Header glass
          SliverToBoxAdapter(
            child: GlassContainer(
              borderRadius: 0,
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.fromLTRB(
                Branding.spacingM,
                Branding.spacingL,
                Branding.spacingM,
                Branding.spacingM,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Crear evento',
                      style: TextStyle(
                        fontSize: Branding.fontSizeTitle2,
                        fontWeight: Branding.weightBold,
                        color: isDark
                            ? CupertinoColors.white
                            : CupertinoColors.black,
                      ),
                    ),
                  ),
                  _isLoading
                      ? const CupertinoActivityIndicator()
                      : GestureDetector(
                          onTap: _saveEvent,
                          child: GlassContainer(
                            borderRadius: Branding.radiusMedium,
                            padding: const EdgeInsets.symmetric(
                              horizontal: Branding.spacingM,
                              vertical: Branding.spacingS,
                            ),
                            backgroundColor: Branding.primaryPurple
                                .withOpacity(isDark ? 0.3 : 0.2),
                            child: Text(
                              'Guardar',
                              style: TextStyle(
                                fontSize: Branding.fontSizeHeadline,
                                fontWeight: Branding.weightSemibold,
                                color: Branding.primaryPurple,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          // Contenido del formulario
          SliverPadding(
            padding: EdgeInsets.only(
              left: Branding.spacingM,
              right: Branding.spacingM,
              top: Branding.spacingM,
              bottom: 200 +
                  MediaQuery.of(context)
                      .padding
                      .bottom, // Padding extra grande para evitar overflow
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Selector de imagen glass
                  GestureDetector(
                    onTap: _pickImage,
                    child: GlassContainer(
                      height: 220,
                      borderRadius: Branding.radiusLarge,
                      padding: EdgeInsets.zero,
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(Branding.radiusLarge),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 220,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.photo,
                                  size: 48,
                                  color: isDark
                                      ? CupertinoColors.white.withOpacity(0.6)
                                      : CupertinoColors.black.withOpacity(0.5),
                                ),
                                const SizedBox(height: Branding.spacingS),
                                Text(
                                  'Toca para agregar imagen',
                                  style: TextStyle(
                                    fontSize: Branding.fontSizeBody,
                                    color: isDark
                                        ? CupertinoColors.white.withOpacity(0.6)
                                        : CupertinoColors.black
                                            .withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: Branding.spacingM),
                  // Título
                  GlassTextField(
                    controller: _titleController,
                    placeholder: 'Título del evento *',
                    prefix: Icon(
                      CupertinoIcons.textformat,
                      color: isDark
                          ? CupertinoColors.white.withOpacity(0.6)
                          : CupertinoColors.black.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: Branding.spacingM),
                  // Descripción
                  GlassTextField(
                    controller: _descriptionController,
                    placeholder: 'Descripción',
                    maxLines: 5,
                    minLines: 3,
                    prefix: Icon(
                      CupertinoIcons.text_alignleft,
                      color: isDark
                          ? CupertinoColors.white.withOpacity(0.6)
                          : CupertinoColors.black.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: Branding.spacingM),
                  // Fecha y hora
                  GestureDetector(
                    onTap: _selectStartTime,
                    child: GlassContainer(
                      padding: const EdgeInsets.all(Branding.spacingM),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.calendar,
                            color: isDark
                                ? CupertinoColors.white.withOpacity(0.6)
                                : CupertinoColors.black.withOpacity(0.5),
                          ),
                          const SizedBox(width: Branding.spacingM),
                          Expanded(
                            child: Text(
                              _startTime != null
                                  ? dateFormat.format(_startTime!)
                                  : 'Fecha y hora de inicio *',
                              style: TextStyle(
                                fontSize: Branding.fontSizeBody,
                                color: _startTime != null
                                    ? (isDark
                                        ? CupertinoColors.white
                                        : CupertinoColors.black)
                                    : (isDark
                                        ? CupertinoColors.white.withOpacity(0.5)
                                        : CupertinoColors.black
                                            .withOpacity(0.5)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Branding.spacingM),
                  // Ciudad
                  GlassTextField(
                    controller: _cityController,
                    placeholder: 'Ciudad',
                    prefix: Icon(
                      CupertinoIcons.location,
                      color: isDark
                          ? CupertinoColors.white.withOpacity(0.6)
                          : CupertinoColors.black.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: Branding.spacingM),
                  // Dirección
                  GlassTextField(
                    controller: _addressController,
                    placeholder: 'Dirección',
                    prefix: Icon(
                      CupertinoIcons.map_pin_ellipse,
                      color: isDark
                          ? CupertinoColors.white.withOpacity(0.6)
                          : CupertinoColors.black.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: Branding.spacingM),
                  // Switch público/privado
                  GlassContainer(
                    padding: const EdgeInsets.all(Branding.spacingM),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.globe,
                              color: isDark
                                  ? CupertinoColors.white.withOpacity(0.6)
                                  : CupertinoColors.black.withOpacity(0.5),
                            ),
                            const SizedBox(width: Branding.spacingM),
                            Text(
                              'Evento público',
                              style: TextStyle(
                                fontSize: Branding.fontSizeBody,
                                color: isDark
                                    ? CupertinoColors.white
                                    : CupertinoColors.black,
                              ),
                            ),
                          ],
                        ),
                        CupertinoSwitch(
                          value: _isPublic,
                          onChanged: (value) {
                            setState(() {
                              _isPublic = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
