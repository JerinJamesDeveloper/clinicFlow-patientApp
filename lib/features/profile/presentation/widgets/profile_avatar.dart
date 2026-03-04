/// Profile Avatar Widget
/// 
/// Avatar widget with edit functionality.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/domain/entities/user_entity.dart';

/// Profile avatar with edit button
class ProfileAvatar extends StatelessWidget {
  /// User entity
  final UserEntity user;
  
  /// Avatar size
  final double size;
  
  /// Whether to show edit button
  final bool showEditButton;
  
  /// Edit callback
  final VoidCallback? onEdit;
  
  /// Whether avatar is loading
  final bool isLoading;

  const ProfileAvatar({
    super.key,
    required this.user,
    this.size = 100,
    this.showEditButton = true,
    this.onEdit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Avatar
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.1),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipOval(
            child: isLoading
                ? _buildLoadingIndicator()
                : user.avatarUrl != null
                    ? Image.network(
                        user.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildInitials(),
                        loadingBuilder: (_, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return _buildLoadingIndicator();
                        },
                      )
                    : _buildInitials(),
          ),
        ),
        
        // Edit button
        if (showEditButton)
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                width: size * 0.32,
                height: size * 0.32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 3,
                  ),
                  boxShadow: AppColors.lightShadow,
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: size * 0.16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        user.initials,
        style: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.35,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: SizedBox(
        width: size * 0.3,
        height: size * 0.3,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(AppColors.primary),
        ),
      ),
    );
  }
}

/// Avatar selection bottom sheet
class AvatarSelectionSheet extends StatelessWidget {
  /// Callback when camera is selected
  final VoidCallback? onCamera;
  
  /// Callback when gallery is selected
  final VoidCallback? onGallery;
  
  /// Callback when remove is selected
  final VoidCallback? onRemove;
  
  /// Whether user has an avatar
  final bool hasAvatar;

  const AvatarSelectionSheet({
    super.key,
    this.onCamera,
    this.onGallery,
    this.onRemove,
    this.hasAvatar = false,
  });

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onCamera,
    VoidCallback? onGallery,
    VoidCallback? onRemove,
    bool hasAvatar = false,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AvatarSelectionSheet(
        onCamera: onCamera,
        onGallery: onGallery,
        onRemove: onRemove,
        hasAvatar: hasAvatar,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Title
            Text(
              'Change Profile Photo',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Options
            _OptionTile(
              icon: Icons.camera_alt_outlined,
              label: 'Take Photo',
              onTap: () {
                Navigator.pop(context);
                onCamera?.call();
              },
            ),
            _OptionTile(
              icon: Icons.photo_library_outlined,
              label: 'Choose from Gallery',
              onTap: () {
                Navigator.pop(context);
                onGallery?.call();
              },
            ),
            if (hasAvatar)
              _OptionTile(
                icon: Icons.delete_outline,
                label: 'Remove Photo',
                isDestructive: true,
                onTap: () {
                  Navigator.pop(context);
                  onRemove?.call();
                },
              ),
            
            const SizedBox(height: 8),
            
            // Cancel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _OptionTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : null;
    
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(color: color),
      ),
      onTap: onTap,
    );
  }
}