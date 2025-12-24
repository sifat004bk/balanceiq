import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:dolfin_core/utils/snackbar_utils.dart';
import 'package:dolfin_ui_kit/theme/app_typography.dart';
import 'package:feature_auth/constants/auth_strings.dart';
import 'package:feature_auth/presentation/cubit/session/session_cubit.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  bool _isInitialized = false;
  String? _originalFullName;
  String? _originalEmail;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _initializeFields(dynamic user) {
    if (!_isInitialized && user != null) {
      _fullNameController.text = user.name ?? '';
      _usernameController.text = user.email?.split('@').first ?? '';
      _emailController.text = user.email ?? '';
      _originalFullName = user.name;
      _originalEmail = user.email;
      _isInitialized = true;
    }
  }


  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final fullName = _fullNameController.text.trim();
      final email = _emailController.text.trim();

      // Only update fields that changed
      context.read<SessionCubit>().updateProfile(
            fullName: fullName != _originalFullName ? fullName : null,
            email: email != _originalEmail ? email : null,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionCubit, SessionState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          SnackbarUtils.showSuccess(context, state.message);
          Navigator.pop(context, true);
        } else if (state is ProfileUpdateError) {
          SnackbarUtils.showError(context, state.message);
        }
      },
      builder: (context, state) {
        dynamic user;
        bool isLoading = false;

        if (state is Authenticated) {
          user = state.user;
        } else if (state is ProfileUpdating) {
          user = state.user;
          isLoading = true;
        } else if (state is ProfileUpdateError) {
          user = state.user;
        } else if (state is ProfileUpdateSuccess) {
          user = state.user;
        }

        if (user != null) {
          _initializeFields(user);
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                LucideIcons.arrowLeft,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              GetIt.I<AuthStrings>().profile.updateAccountDetails,
              style: AppTypography.titleXLargeSemiBold.copyWith(
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name Field
                  _buildInputField(
                    context,
                    label: GetIt.I<AuthStrings>().profile.fullName,
                    controller: _fullNameController,
                    icon: LucideIcons.user,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Email Field
                  _buildInputField(
                    context,
                    label: GetIt.I<AuthStrings>().profile.email,
                    controller: _emailController,
                    icon: LucideIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    helperText: 'Changing email will require verification',
                  ),
                  const SizedBox(height: 40),
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : Text(
                              GetIt.I<AuthStrings>().profile.saveChanges,
                              style: AppTypography.buttonMedium.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyMediumSemiBold.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).hintColor,
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            helperText: helperText,
            helperStyle: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
