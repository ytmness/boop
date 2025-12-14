import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/events_provider.dart';
import '../../providers/event_management_provider.dart';
import '../../../../shared/widgets/error_dialog.dart';

class EditEventScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EditEventScreen({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends ConsumerState<EditEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadEvent() async {
    final eventAsync = ref.read(eventByIdProvider(widget.eventId));
    await eventAsync.when(
      data: (event) {
        if (event != null) {
          _titleController.text = event.title;
          _descriptionController.text = event.description ?? '';
        }
      },
      loading: () {},
      error: (_, __) {},
    );
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    try {
      final eventService = ref.read(eventManagementServiceProvider);
      await eventService.updateEvent(
        eventId: widget.eventId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      ref.invalidate(eventByIdProvider(widget.eventId));

      if (mounted) {
        Navigator.pop(context);
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEvent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Editar evento'),
        trailing: _isLoading
            ? const CupertinoActivityIndicator()
            : CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _saveChanges,
                child: const Text(
                  'Guardar',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              CupertinoTextField(
                controller: _titleController,
                placeholder: 'Título',
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.secondarySystemBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CupertinoColors.separator,
                    width: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _descriptionController,
                placeholder: 'Descripción',
                maxLines: 10,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.secondarySystemBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CupertinoColors.separator,
                    width: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

