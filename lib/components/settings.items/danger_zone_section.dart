import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/light_theme.dart';

class ProfileAccountButtons extends StatelessWidget {
  final bool hasProfile;
  final bool isDeletingProfile;
  final VoidCallback onDeleteProfile;
  final bool isDeletingAccount;
  final VoidCallback onDeleteAccount;

  const ProfileAccountButtons({
    Key? key,
    required this.hasProfile,
    required this.isDeletingProfile,
    required this.onDeleteProfile,
    required this.isDeletingAccount,
    required this.onDeleteAccount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasProfile)
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: LightTheme.danger).copyWith(
              foregroundColor: MaterialStateProperty.all(LightTheme.textPrimary),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            ),
            onPressed: isDeletingProfile ? null : onDeleteProfile,
            child: isDeletingProfile
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: LightTheme.textPrimary),
                  )
                : const Text('Usuń profil'),
          ),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: LightTheme.danger,
          ).copyWith(
            foregroundColor: MaterialStateProperty.all(LightTheme.secondary),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
          ),
          onPressed: isDeletingAccount ? null : onDeleteAccount,
          child: isDeletingAccount
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: LightTheme.textPrimary,
                  ),
                )
              : const Text('Usuń konto'),
        ),
      ],
    );
  }
}
