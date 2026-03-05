/// Home List Widget
///
/// Displays a list of homes.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/home_entity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import 'home_item_widget.dart';

/// List widget for displaying homes
class HomeListWidget extends StatelessWidget {
  final List<HomeEntity> homes;
  final bool isOperating;

  const HomeListWidget({
    super.key,
    required this.homes,
    this.isOperating = false,
  });

  @override
  Widget build(BuildContext context) {
    if (homes.isEmpty) {
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
            context.read<HomeBloc>().add(
              const HomeRefreshRequested(),
            );
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: homes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = homes[index];
              return HomeItemWidget(
                home: item,
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

  void _onItemTap(BuildContext context, HomeEntity item) {
    // Navigate to detail page
    // context.push('/${RoutePaths.homes}/${item.id}');
  }

  void _onItemEdit(BuildContext context, HomeEntity item) {
    final nameController = TextEditingController(text: item.name);
    final descriptionController = TextEditingController(text: item.description ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Home'),
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
              context.read<HomeBloc>().add(
                HomeUpdateRequested(
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

  void _onItemDelete(BuildContext context, HomeEntity item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Home'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<HomeBloc>().add(
                HomeDeleteRequested(id: item.id),
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
