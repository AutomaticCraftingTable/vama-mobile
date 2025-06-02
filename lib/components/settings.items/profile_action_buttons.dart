import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/light_theme.dart';

class ProfileActionButtons extends StatelessWidget {
  final String? nickname;
  final bool isEditing;
  final VoidCallback onCreate;
  final VoidCallback onEdit;
  final VoidCallback onSave;

  const ProfileActionButtons({
    Key? key,
    required this.nickname,
    required this.isEditing,
    required this.onCreate,
    required this.onEdit,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (nickname == null)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: LightTheme.primary,
            ).copyWith(
              foregroundColor: MaterialStateProperty.all(LightTheme.textPrimary),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            onPressed: onCreate,
            child: const Center(child: Text('Utwórz profil')),
          ),
        if (nickname != null && !isEditing)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: LightTheme.primary,
            ).copyWith(
              foregroundColor: MaterialStateProperty.all(LightTheme.textPrimary),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            onPressed: onEdit,
            child: const Center(child: Text('Edytuj profil')),
          ),
        if (isEditing && nickname != null)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: LightTheme.primary,
            ).copyWith(
              foregroundColor: MaterialStateProperty.all(LightTheme.textPrimary),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            onPressed: onSave,
            child: const Center(child: Text('Zapisz zmiany')),
          ),
      ],
    );
  }
}
