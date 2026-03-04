/// Profile Page
/// 
/// Main profile page displaying user information and settings.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_stats_section.dart';

/// Profile page
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    context.read<ProfileBloc>().add(const ProfileLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: _handleProfileState,
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const LoadingWidget(message: 'Loading profile...');
          }

          if (state is ProfileError && state.user == null) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: _loadProfile,
            );
          }

          // Get user from various states
          final user = _getUserFromState(state);
          if (user == null) {
            return const LoadingWidget();
          }

          final isUpdating = state is ProfileUpdating;
          final completionPercentage = state is ProfileLoaded
              ? state.completionPercentage
              : 100;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileBloc>().add(const ProfileRefreshRequested());
            },
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 60,
                  floating: true,
                  pinned: true,
                  title: const Text('Profile'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => context.push('/profile/edit'),
                    ),
                  ],
                ),

                // Profile Header
                SliverToBoxAdapter(
                  child: ProfileHeader(
                    user: user,
                    isAvatarLoading: isUpdating &&
                        (state as ProfileUpdating).updateType ==
                            ProfileUpdateType.avatar,
                    completionPercentage: completionPercentage,
                    onAvatarEdit: () => _showAvatarOptions(context),
                  ),
                ),

                // Stats
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ProfileStatsSection(
                      stats: [
                        ProfileStatData(
                          value: '24',
                          label: 'Posts',
                          onTap: () {},
                        ),
                        ProfileStatData(
                          value: '1.2K',
                          label: 'Followers',
                          onTap: () {},
                        ),
                        ProfileStatData(
                          value: '348',
                          label: 'Following',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),

                // Member Since
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Center(
                      child: MemberSinceBadge(joinDate: user.createdAt),
                    ),
                  ),
                ),

                // Account Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ProfileMenuSection(
                      title: 'Account',
                      items: [
                        ProfileMenuItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          subtitle: 'Update your personal information',
                          onTap: () => context.push('/profile/edit'),
                        ),
                        ProfileMenuItem(
                          icon: Icons.lock_outline,
                          title: 'Change Password',
                          subtitle: 'Update your password',
                          onTap: () => context.push('/settings/change-password'),
                        ),
                        ProfileMenuItem(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (user.isEmailVerified)
                                const Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: AppColors.success,
                                ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.chevron_right,
                                color: AppColors.grey400,
                                size: 20,
                              ),
                            ],
                          ),
                          onTap: () {
                            if (!user.isEmailVerified) {
                              _showVerifyEmailDialog(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Preferences Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ProfileMenuSection(
                      title: 'Preferences',
                      items: [
                        ProfileMenuItem(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          subtitle: 'Manage notification settings',
                          onTap: () => context.push('/notifications'),
                        ),
                        ProfileMenuItem(
                          icon: Icons.language_outlined,
                          title: 'Language',
                          subtitle: 'English',
                          onTap: () {
                            AppSnackBar.showInfo(
                              context,
                              'Language settings coming soon',
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.dark_mode_outlined,
                          title: 'Appearance',
                          subtitle: 'Theme settings',
                          onTap: () {
                            AppSnackBar.showInfo(
                              context,
                              'Theme settings coming soon',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Support Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ProfileMenuSection(
                      title: 'Support',
                      items: [
                        ProfileMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help Center',
                          onTap: () {
                            AppSnackBar.showInfo(context, 'Help Center');
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () {
                            AppSnackBar.showInfo(context, 'Privacy Policy');
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.description_outlined,
                          title: 'Terms of Service',
                          onTap: () {
                            AppSnackBar.showInfo(context, 'Terms of Service');
                          },
                        ),
                        ProfileInfoMenuItem(
                          icon: Icons.info_outline,
                          title: 'App Version',
                          value: '1.0.0',
                        ),
                      ],
                    ),
                  ),
                ),

                // Logout Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ProfileMenuSection(
                      items: [
                        ProfileMenuItem(
                          icon: Icons.logout_rounded,
                          title: 'Log Out',
                          isDestructive: true,
                          showChevron: false,
                          onTap: () => _showLogoutDialog(context),
                        ),
                      ],
                    ),
                  ),
                ),

                // Delete Account
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () => _showDeleteAccountDialog(context),
                        child: Text(
                          'Delete Account',
                          style: TextStyle(
                            color: AppColors.error.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  dynamic _getUserFromState(ProfileState state) {
    if (state is ProfileLoaded) return state.user;
    if (state is ProfileUpdating) return state.user;
    if (state is ProfileUpdateSuccess) return state.user;
    if (state is ProfileError) return state.user;
    return null;
  }

  void _handleProfileState(BuildContext context, ProfileState state) {
    if (state is ProfileUpdateSuccess) {
      AppSnackBar.showSuccess(context, state.message);
    } else if (state is ProfileError) {
      AppSnackBar.showError(context, state.message);
    } else if (state is ProfileAccountDeleted) {
      context.read<AuthBloc>().add(const AuthLogoutRequested());
      context.go('/login');
    }
  }

  void _showAvatarOptions(BuildContext context) {
    AvatarSelectionSheet.show(
      context,
      hasAvatar: _getUserFromState(context.read<ProfileBloc>().state)
              ?.avatarUrl !=
          null,
      onCamera: () {
        // TODO: Implement camera
        AppSnackBar.showInfo(context, 'Camera - Coming soon');
      },
      onGallery: () {
        // TODO: Implement gallery
        AppSnackBar.showInfo(context, 'Gallery - Coming soon');
      },
      onRemove: () {
        context.read<ProfileBloc>().add(const ProfileAvatarRemoveRequested());
      },
    );
  }

  void _showVerifyEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify Email'),
        content: const Text(
          'Would you like to resend the verification email?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(
                    const AuthResendVerificationRequested(),
                  );
              AppSnackBar.showSuccess(context, 'Verification email sent!');
            },
            child: const Text('Resend'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This action cannot be undone. All your data will be permanently deleted.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Enter your password',
                hintText: 'Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text.isNotEmpty) {
                Navigator.pop(context);
                context.read<ProfileBloc>().add(
                      ProfileDeleteAccountRequested(
                        password: passwordController.text,
                      ),
                    );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}