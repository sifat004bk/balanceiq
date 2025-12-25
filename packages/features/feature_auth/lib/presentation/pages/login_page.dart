import 'package:dolfin_core/utils/snackbar_utils.dart';
import 'package:feature_auth/presentation/widgets/login_form.dart';
import 'package:feature_auth/presentation/cubit/login/login_cubit.dart';
import 'package:feature_auth/presentation/cubit/session/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _hasShownErrorMessage = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    // Handle different argument types
    if (args != null) {
      if (args is Map<String, dynamic> && !_hasShownErrorMessage) {
        // Error message passed from auth interceptor (only show once)
        final errorMessage = args['errorMessage'] as String?;
        if (errorMessage != null) {
          _hasShownErrorMessage = true;
          // Show error message after frame is built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              SnackbarUtils.showError(context, errorMessage);
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Update global session
          context.read<SessionCubit>().updateUser(state.user);
          // Navigate to home when authenticated
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is LoginError) {
          // Show error message
          SnackbarUtils.showError(context, state.message);
        }
      },
      child: const PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}
