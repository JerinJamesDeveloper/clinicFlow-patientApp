/// Appointments Item Widget
///
/// Displays a single appointments item in a list.
library;

import 'package:flutter/material.dart';

import '../../domain/entities/appointments_entity.dart';

/// Item widget for displaying a single appointments
class AppointmentsItemWidget extends StatelessWidget {
  final AppointmentsEntity appointments;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AppointmentsItemWidget({
    super.key,
    required this.appointments,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: appointments.isActive
              ? Colors.green.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
          child: Icon(
            appointments.isActive ? Icons.check : Icons.close,
            color: appointments.isActive ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(
          appointments.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            decoration: appointments.isActive
                ? null
                : TextDecoration.lineThrough,
          ),
        ),
        subtitle: appointments.description != null
            ? Text(
                appointments.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEdit?.call();
                break;
              case 'delete':
                onDelete?.call();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
