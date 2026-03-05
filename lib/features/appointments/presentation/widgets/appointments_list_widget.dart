/// Appointments List Widget
///
/// Displays a list of appointmentss.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/appointments_entity.dart';
import '../bloc/appointments_bloc.dart';
import '../bloc/appointments_event.dart';
import 'appointments_item_widget.dart';

/// List widget for displaying appointmentss
class AppointmentsListWidget extends StatelessWidget {
  final List<AppointmentsEntity> appointmentss;
  final bool isOperating;

  const AppointmentsListWidget({
    super.key,
    required this.appointmentss,
    this.isOperating = false,
  });

  @override
  Widget build(BuildContext context) {
    if (appointmentss.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No items yet'),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add one',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            context.read<AppointmentsBloc>().add(
              const AppointmentsRefreshRequested(),
            );
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: appointmentss.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = appointmentss[index];
              return AppointmentsItemWidget(
                appointments: item,
                onTap: () => _onItemTap(context, item),
                onEdit: () => _onItemEdit(context, item),
                onDelete: () => _onItemDelete(context, item),
              );
            },
          ),
        ),
        if (isOperating)
          Container(
            color: Colors.black26,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  void _onItemTap(BuildContext context, AppointmentsEntity item) {
    // Navigate to detail page
    // context.push('/${RoutePaths.appointmentss}/${item.id}');
  }

  void _onItemEdit(BuildContext context, AppointmentsEntity item) {
    final nameController = TextEditingController(text: item.name);
    final descriptionController = TextEditingController(text: item.description ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Appointments'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AppointmentsBloc>().add(
                AppointmentsUpdateRequested(
                  id: item.id,
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim().isEmpty
                      ? null
                      : descriptionController.text.trim(),
                ),
              );
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _onItemDelete(BuildContext context, AppointmentsEntity item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Appointments'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<AppointmentsBloc>().add(
                AppointmentsDeleteRequested(id: item.id),
              );
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
