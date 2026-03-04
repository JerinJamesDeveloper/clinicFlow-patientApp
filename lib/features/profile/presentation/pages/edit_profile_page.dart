/// Edit Profile Page
/// 
/// Page for editing user profile information.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_avatar.dart';

/// Edit profile page
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  
  bool _hasChanges = false;
  bool _autoValidate = false;
  UserEntity? _originalUser;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final state = context.read<ProfileBloc>().state;
    final user = _getUserFromState(state);
    
    _originalUser = user;
    
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    
    _firstNameController.addListener(_checkForChanges);
    _lastNameController.addListener(_checkForChanges);
    _phoneController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final hasChanges = _firstNameController.text != (_originalUser?.firstName ?? '') ||
        _lastNameController.text != (_originalUser?.lastName ?? '') ||
        _phoneController.text != (_originalUser?.phoneNumber ?? '');
    
    if (hasChanges != _hasChanges) {
      setState(() => _hasChanges = hasChanges);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  UserEntity? _getUserFromState(ProfileState state) {
    if (state is ProfileLoaded) return state.user;
    if (state is ProfileUpdating) return state.user;
    if (state is ProfileUpdateSuccess) return state.user;
    if (state is ProfileError) return state.user;
    return null;
  }

  void _onSave() {
    setState(() => _autoValidate = true);
    
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProfileBloc>().add(
        ProfileUpdateRequested(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNumber: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _handleBack(context),
        ),
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final isLoading = state is ProfileUpdating;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: (_hasChanges && !isLoading) ? _onSave : null,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            AppSnackBar.showSuccess(context, state.message);
            context.pop();
          } else if (state is ProfileError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final user = _getUserFromState(state);
          
          if (user == null) {
            return const LoadingWidget();
          }

          final isLoading = state is ProfileUpdating;
          
          // Get field errors
          Map<String, String> fieldErrors = {};
          if (state is ProfileError && state.hasFieldErrors) {
            for (final entry in state.fieldErrors!.entries) {
              fieldErrors[entry.key] = entry.value.first;
            }
          }

          return LoadingOverlay(
            isLoading: isLoading,
            message: 'Saving...',
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  children: [
                    // Avatar
                    ProfileAvatar(
                      user: user,
                      size: 100,
                      onEdit: () => _showAvatarOptions(context, user),
                      isLoading: isLoading &&
                          state is ProfileUpdating &&
                          state.updateType == ProfileUpdateType.avatar,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // First Name
                    AppTextField(
                      controller: _firstNameController,
                      focusNode: _firstNameFocus,
                      label: 'First Name',
                      hint: 'Enter your first name',
                      prefixIcon: Icons.person_outline,
                      errorText: fieldErrors['firstName'],
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => _lastNameFocus.requestFocus(),
                      validator: (v) => Validators.name(v, fieldName: 'First name'),
                      enabled: !isLoading,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Last Name
                    AppTextField(
                      controller: _lastNameController,
                      focusNode: _lastNameFocus,
                      label: 'Last Name',
                      hint: 'Enter your last name',
                      prefixIcon: Icons.person_outline,
                      errorText: fieldErrors['lastName'],
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => _phoneFocus.requestFocus(),
                      validator: (v) => Validators.name(v, fieldName: 'Last name'),
                      enabled: !isLoading,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Email (read-only)
                    AppTextField(
                      label: 'Email',
                      initialValue: user.email,
                      prefixIcon: Icons.email_outlined,
                      enabled: false,
                      suffix: user.isEmailVerified
                          ? const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.verified,
                                color: AppColors.success,
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Phone
                    PhoneTextField(
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      label: 'Phone Number (Optional)',
                      hint: 'Enter your phone number',
                      errorText: fieldErrors['phoneNumber'],
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _onSave(),
                      validator: Validators.phoneOptional,
                      enabled: !isLoading,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Save Button
                    AppButton(
                      text: 'Save Changes',
                      onPressed: _hasChanges ? _onSave : null,
                      isLoading: isLoading,
                      isDisabled: !_hasChanges,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Cancel Button
                    AppButton(
                      text: 'Cancel',
                      variant: AppButtonVariant.outlined,
                      onPressed: () => _handleBack(context),
                      isDisabled: isLoading,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleBack(BuildContext context) {
    if (_hasChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text(
            'You have unsaved changes. Are you sure you want to discard them?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep Editing'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
    } else {
      context.pop();
    }
  }

  void _showAvatarOptions(BuildContext context, UserEntity user) {
    AvatarSelectionSheet.show(
      context,
      hasAvatar: user.avatarUrl != null,
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
}