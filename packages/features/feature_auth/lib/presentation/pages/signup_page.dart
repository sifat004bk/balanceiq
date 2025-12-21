import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../widgets/signup_body.dart';

import '../cubit/signup/signup_cubit.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      final username = _emailController.text.split('@').first;

      context.read<SignupCubit>().signupWithEmail(
            username: username,
            password: _passwordController.text,
            fullName: _nameController.text,
            email: _emailController.text,
          );
    }
  }

  void _handleGoogleSignUp() {
    context.read<SignupCubit>().signInGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupAuthenticated) {
          // Navigate to home when authenticated (auto-login after signup or OAuth)
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is SignupSuccess) {
          // Show success message and navigate to email verification
          SnackbarUtils.showSuccess(
            context,
            '${AppStrings.auth.accountCreated}! ${AppStrings.auth.pleaseLogin}',
            duration: const Duration(seconds: 5),
          );
          // Navigate to login page
          Navigator.pushReplacementNamed(
            context,
            '/login',
            arguments: state.email,
          );
        } else if (state is SignupError) {
          // Show error message
          SnackbarUtils.showError(
            context,
            state.message,
            duration: const Duration(seconds: 4),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SignUpBody(
            formKey: _formKey,
            nameController: _nameController,
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            isPasswordVisible: _isPasswordVisible,
            isConfirmPasswordVisible: _isConfirmPasswordVisible,
            onTogglePasswordVisibility: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            onToggleConfirmPasswordVisibility: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
            onSignUp: _handleSignUp,
            onGoogleSignUp: _handleGoogleSignUp,
            onLoginTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ),
      ),
    );
  }
}
