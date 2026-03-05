/// Home Item Widget
///
/// Displays a single home item in a list.
library;

import 'package:flutter/material.dart';

import '../../domain/entities/home_entity.dart';

/// Item widget for displaying a single home
class HomeItemWidget extends StatelessWidget {
  final HomeEntity home;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HomeItemWidget({
    super.key,
    required this.home,
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
          backgroundColor: home.isActive
              ? Colors.green.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
          child: Icon(
            home.isActive ? Icons.check : Icons.close,
            color: home.isActive ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(
          home.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            decoration: home.isActive
                ? null
                : TextDecoration.lineThrough,
          ),
        ),
        subtitle: home.description != null
            ? Text(
                home.description!,
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
