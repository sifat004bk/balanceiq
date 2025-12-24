import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:dolfin_core/constants/core_strings.dart';
import 'package:feature_auth/constants/auth_strings.dart';
import 'package:get_it/get_it.dart';
import '../../cubit/session/session_cubit.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Show confirmation dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(GetIt.I<AuthStrings>().profile.logOut),
              content: Text(GetIt.I<AuthStrings>().profile.logOutConfirm),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(GetIt.I<CoreStrings>().common.cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Use SessionCubit for logout
                    context.read<SessionCubit>().logout();
                  },
                  child: Text(
                    'Log Out',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).cardColor,
          foregroundColor: Theme.of(context).colorScheme.error,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.logOut,
              size: 20,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
