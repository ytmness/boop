import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui';
import '../providers/event_management_provider.dart';
import '../../profile/services/storage_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../shared/widgets/error_dialog.dart';
import '../../../shared/components/inputs/glass_text_field.dart';
import '../../../shared/components/glass/glass_container.dart';
import '../../../shared/widgets/blurred_video_background.dart';
import '../../../core/branding/branding.dart';
import '../../../routes/route_names.dart';
import 'package:intl/intl.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateController = TextEditingController();
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
    _dateController.dispose();
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
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
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
                _dateController.text = dateFormat.format(newDate);
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
        // Generar un ID temporal para el evento
        final tempEventId = DateTime.now().millisecondsSinceEpoch.toString();
        imageUrl = await storageService.uploadEventImage(
          tempEventId,
          _selectedImage!,
        );
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
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.manageEventPath(event.id),
          (route) => route.settings.name == RouteNames.eventsHub,
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(context, title: 'Error', message: e.toString());
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

    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          BlurredVideoBackground(
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Header glass sin BackdropFilter para evitar tintes morados
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white.withOpacity(0.25),
                        border: Border(
                          bottom: BorderSide(
                            color: CupertinoColors.white.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        Branding.spacingM,
                        Branding.spacingM,
                        Branding.spacingM,
                        Branding.spacingM,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  Branding.radiusSmall,
                                ),
                                color: isDark
                                    ? CupertinoColors.white.withOpacity(0.1)
                                    : CupertinoColors.black.withOpacity(0.05),
                              ),
                              child: Icon(
                                CupertinoIcons.chevron_left,
                                color: isDark
                                    ? CupertinoColors.white
                                    : CupertinoColors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: Branding.spacingM),
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
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    // Contenido del formulario
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          // Selector de imagen sin padding para centrado perfecto
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Branding.spacingM,
                                vertical: Branding.spacingM,
                              ),
                              child: Center(
                                child: FractionallySizedBox(
                                  widthFactor: 0.9,
                                  child: AspectRatio(
                                    aspectRatio: 2 / 3, // Proporción 2:3
                                    child: GestureDetector(
                                      onTap: _pickImage,
                                      child: GlassContainer(
                                        padding: EdgeInsets.zero,
                                        borderRadius: 20.0,
                                        child: _selectedImage != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Image.file(
                                                  _selectedImage!,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              )
                                            : Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .camera_fill,
                                                      size: 60,
                                                      color:
                                                          CupertinoColors.white,
                                                    ),
                                                    const SizedBox(
                                                      height: Branding.spacingS,
                                                    ),
                                                    Text(
                                                      'Toca para agregar imagen',
                                                      style: TextStyle(
                                                        fontSize: Branding
                                                            .fontSizeSubhead,
                                                        color: CupertinoColors
                                                            .white,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Campos de entrada con padding
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(
                              Branding.spacingM,
                              0,
                              Branding.spacingM,
                              Branding.spacingM,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: Branding.spacingL),
                                  // Título
                                  GlassTextField(
                                    controller: _titleController,
                                    placeholder: 'Título del evento *',
                                    prefix: Icon(
                                      CupertinoIcons.textformat,
                                      color: CupertinoColors.white,
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
                                      color: CupertinoColors.white,
                                    ),
                                  ),
                                  const SizedBox(height: Branding.spacingM),
                                  // Fecha y hora
                                  GlassTextField(
                                    controller: _dateController,
                                    placeholder: 'Fecha y hora de inicio *',
                                    enabled: false,
                                    onTap: _selectStartTime,
                                    prefix: Icon(
                                      CupertinoIcons.calendar,
                                      color: CupertinoColors.white,
                                    ),
                                  ),
                                  const SizedBox(height: Branding.spacingM),
                                  // Ciudad
                                  GlassTextField(
                                    controller: _cityController,
                                    placeholder: 'Ciudad',
                                    prefix: Icon(
                                      CupertinoIcons.paperplane_fill,
                                      color: CupertinoColors.white,
                                    ),
                                  ),
                                  const SizedBox(height: Branding.spacingM),
                                  // Dirección
                                  GlassTextField(
                                    controller: _addressController,
                                    placeholder: 'Dirección',
                                    prefix: Icon(
                                      CupertinoIcons.map_pin,
                                      color: CupertinoColors.white,
                                    ),
                                  ),
                                  const SizedBox(height: Branding.spacingL),
                                  // Switch público
                                  GlassCard(
                                    borderRadius: Branding.radiusMedium,
                                    padding: const EdgeInsets.all(
                                      Branding.spacingM,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.globe,
                                          color: CupertinoColors.white,
                                        ),
                                        const SizedBox(
                                          width: Branding.spacingM,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Evento público',
                                            style: TextStyle(
                                              fontSize: Branding.fontSizeBody,
                                              fontWeight: Branding.weightMedium,
                                              color: CupertinoColors.white,
                                            ),
                                          ),
                                        ),
                                        CupertinoSwitch(
                                          value: _isPublic,
                                          onChanged: (value) {
                                            setState(() => _isPublic = value);
                                          },
                                          activeColor: Branding.primaryPurple,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: Branding.spacingXL),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Botón completamente fuera del BlurredVideoBackground
          SafeArea(
            child: Positioned(
              top: Branding.spacingM,
              right: Branding.spacingM,
              child: _isLoading
                  ? const CupertinoActivityIndicator()
                  : Container(
                      // Test: Botón completamente rojo fuera del BlurredVideoBackground
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: Branding.spacingM,
                        vertical: Branding.spacingS,
                      ),
                      child: GestureDetector(
                        onTap: _saveEvent,
                        child: const Text(
                          'Guardar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget reutilizable para el botón "Guardar" con estilo glass
/// Aislado completamente del contexto de renderizado para evitar tintes morados
class GuardarButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GuardarButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Versión completamente opaca para bloquear cualquier color del fondo
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: CupertinoColors.white.withOpacity(0.3),
            width: 1.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            // Fondo completamente opaco ROJO para verificar si es problema de renderizado
            decoration: BoxDecoration(
              color: Colors.red, // Color rojo completamente opaco para test
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Branding.spacingM,
              vertical: Branding.spacingS,
            ),
            child: Center(
              child: Text(
                'Guardar',
                style: TextStyle(
                  fontSize: Branding.fontSizeHeadline,
                  fontWeight: Branding.weightSemibold,
                  color: Colors.black87, // Texto oscuro sobre fondo claro
                  shadows: [],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
