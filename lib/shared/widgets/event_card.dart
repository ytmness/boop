import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del evento
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: event.imageUrl != null && event.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: event.imageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 200,
                        color: CupertinoColors.systemGrey5,
                        child: const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        color: CupertinoColors.systemGrey5,
                        child: const Icon(
                          CupertinoIcons.photo,
                          size: 50,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                    )
                  : Container(
                      height: 200,
                      color: CupertinoColors.systemGrey5,
                      child: const Icon(
                        CupertinoIcons.calendar,
                        size: 50,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.calendar,
                        size: 16,
                        color: CupertinoColors.secondaryLabel,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${dateFormat.format(event.startTime)} • ${timeFormat.format(event.startTime)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                    ],
                  ),
                  if (event.city != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.location,
                          size: 16,
                          color: CupertinoColors.secondaryLabel,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.city!,
                          style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (event.isPast) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Finalizado',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

