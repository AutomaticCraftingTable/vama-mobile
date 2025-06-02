import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/%D1%81ustom_snack_bar.dart';
import 'package:vama_mobile/components/settings.items/danger_zone_section.dart';
import 'package:vama_mobile/components/settings.items/profile_action_buttons.dart';
import 'package:vama_mobile/provider/auth_provider.dart';
import 'package:vama_mobile/components/headers/header.dart';
import 'dart:io';
import 'package:vama_mobile/theme/light_theme.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool isEditing = false;

  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? nickname;
  String? description;
  File? profileImage;

  final _emailCtrl = TextEditingController();
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  bool _loadingAccount = false;

  bool _isDeletingAccount = false;

  bool _isLoading = false;

  void _createProfile() async {
  if (!isEditing && nickname == null) {
    setState(() => isEditing = true);
    return;
  }
  if (isEditing) {
    if (nicknameController.text.isEmpty || descriptionController.text.isEmpty) {
      showCustomSnackBar(context, 'Wypełnij wszystkie pola');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ApiService().createProfile(
        nickname: nicknameController.text,
        description: descriptionController.text,
      );

      final auth = Provider.of<AuthProvider>(context, listen: false);
      auth.setHasProfile(true);

      setState(() {
        nickname = nicknameController.text;
        description = descriptionController.text;
        isEditing = false;
      });

      showCustomSnackBar(context, 'Profil został utworzony!');
    } catch (e) {
      showCustomSnackBar(context, 'Błąd: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  } else {
    setState(() {
      isEditing = true;
      nicknameController.text = nickname ?? '';
      descriptionController.text = description ?? '';
    });
  }
}
bool _isDeleting = false;

void _deleteProfile() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Usuń profil?', style:TextStyle(color: LightTheme.primary),),
      content: const Text('Na pewno chcesz usunąć profil?', style:TextStyle(color: LightTheme.text)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Anuluj', style: TextStyle(color: LightTheme.primary))),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Usuń', style: TextStyle(color: LightTheme.danger))),
      ],
    ),
  );
  if (confirm != true) return;

  setState(() => _isDeleting = true);
  try {
    await ApiService().deleteProfile();
    setState(() {
      nickname = null;
      description = null;
      isEditing = false;
      nicknameController.clear();
      descriptionController.clear();
      profileImage = null;
    });
    showCustomSnackBar(context, 'Profil usunięty');
  } catch (e) {
    showCustomSnackBar(context, 'Błąd usuwania: ${e.toString()}');
  } finally {
    setState(() => _isDeleting = false);
  }
}

Future<void> _saveAccountSettings() async {
  if (_emailCtrl.text.isEmpty &&
      (_oldPassCtrl.text.isEmpty || _newPassCtrl.text.isEmpty)) {
    showCustomSnackBar(context, 'Wypełnij email lub oba pola hasła');
    return;
  }
  setState(() => _loadingAccount = true);
  try {
    await ApiService().changeAccountSettings(
      email: _emailCtrl.text,
      oldPassword: _oldPassCtrl.text,
      newPassword: _newPassCtrl.text,
    );
    showCustomSnackBar(context, 'Ustawienia konta zaktualizowane!');
    _oldPassCtrl.clear();
    _newPassCtrl.clear();
  } catch (e) {
    showCustomSnackBar(context, 'Błąd: ${e.toString()}');
  } finally {
    setState(() => _loadingAccount = false);
  }
}

Future<void> _deleteAccount() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Usuń konto?',style: TextStyle(color: LightTheme.primary)),
      content: const Text('Na pewno chcesz usunąć konto na stałe?', style: TextStyle(color: LightTheme.primary),),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Anuluj', style: TextStyle(color: LightTheme.primary))),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Usuń', style:TextStyle(color: LightTheme.danger))),
      ],
    ),
  );
  if (confirm != true) return;

  setState(() => _isDeletingAccount = true);
  try {
    await ApiService().deleteAccount();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logOut();
    Navigator.of(context).pushReplacementNamed('/home');
  } catch (e) {
    showCustomSnackBar(context, 'Błąd usuwania konta: ${e.toString()}');
  } finally {
    setState(() => _isDeletingAccount = false);
  }
}

Future<void> _changeProfileSettings() async {
  if (nicknameController.text.isEmpty || descriptionController.text.isEmpty) {
    showCustomSnackBar(context, 'Wypełnij wszystkie pola');
    return;
  }

  setState(() => _isLoading = true);
  try {
    await ApiService().changeProfileSettings(
      nickname: nicknameController.text,
      description: descriptionController.text,
    );

    setState(() {
      nickname = nicknameController.text;
      description = descriptionController.text;
      isEditing = false;
    });

    showCustomSnackBar(context, 'Profil został zaktualizowany!');
  } catch (e) {
    showCustomSnackBar(context, 'Błąd: ${e.toString()}');
  } finally {
    setState(() => _isLoading = false);
  }
}



 @override
Widget build(BuildContext context) {

  return Scaffold(
    body: Column(
      children: [
        const SizedBox(height: 25),
        const Header(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text('Aplikacja',style: TextStyle(fontWeight: FontWeight.bold,color: LightTheme.textDimmed)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tryb ciemny',style: TextStyle(fontWeight: FontWeight.bold,color: LightTheme.text)),
              Switch(
                value: isDarkMode,
                onChanged: (val) => setState(() => isDarkMode = val),
                activeColor: LightTheme.secondary,
                activeTrackColor: LightTheme.primary,
                inactiveThumbColor: LightTheme.primary,
                inactiveTrackColor: LightTheme.secondary,
              ),
            ],
          ),
          SizedBox(height: 20),

          if (isEditing) ...[
            GestureDetector(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: LightTheme.primary,
                backgroundImage: profileImage != null
                    ? FileImage(profileImage!)
                    : null,
                child: profileImage == null
                    ? Icon(Icons.camera_alt, color: LightTheme.secondary)
                    : null,
              ),
            ),
            SizedBox(height: 10),
            Text('Nick', style: TextStyle(fontWeight: FontWeight.bold,color: LightTheme.text)),

            TextField(
              controller: nicknameController,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: LightTheme.textSecondary),
                hintText: 'Wprowadź nickname',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            Text('Opis', style: TextStyle(fontWeight: FontWeight.bold,color: LightTheme.text)),

            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: LightTheme.textSecondary),
                hintText: 'Wprowadź opis',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),
          ],
          if (nickname != null && !isEditing) ...[
            Text('Profil',style: TextStyle(fontWeight: FontWeight.bold,color: LightTheme.textDimmed)),
            SizedBox(height: 10),
            CircleAvatar(
              radius: 50,
              backgroundColor: LightTheme.primary,
              backgroundImage: profileImage != null
                  ? FileImage(profileImage!)
                  : null,
              child: profileImage == null
                  ? Icon(Icons.person, color: LightTheme.secondary)
                  : null,
            ),
            SizedBox(height: 10),
            Text('Nick', style: TextStyle(fontWeight: FontWeight.bold,color: LightTheme.text)),
            Container(
              padding: EdgeInsets.all(10),
              color: LightTheme.secondary,
              width: double.infinity,
              child: Text(nickname!),
            ),
            SizedBox(height: 10),
            Text('Opis', style: TextStyle(fontWeight: FontWeight.bold,color: LightTheme.text)),
            Container(
              padding: EdgeInsets.all(10),
              color: LightTheme.secondary,
              width: double.infinity,
              child: Text(description!),
            ),
            SizedBox(height: 20),

            Text('Poczta', style: TextStyle(fontWeight: FontWeight.bold, color: LightTheme.text)),
            TextField(
              controller: _emailCtrl,
              decoration: InputDecoration(
                hintText: 'dude@gmail.com',
                filled: true,
                fillColor: LightTheme.secondary,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            SizedBox(height: 10),

            Text('Stare hasło', style: TextStyle(fontWeight: FontWeight.bold, color: LightTheme.text)),
            TextField(
              controller: _oldPassCtrl,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Wprowadź stare hasło',
                filled: true,
                fillColor: LightTheme.secondary,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            SizedBox(height: 10),

            Text('Nowe hasło', style: TextStyle(fontWeight: FontWeight.bold, color: LightTheme.text)),
            TextField(
              controller: _newPassCtrl,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Wprowadź nowe hasło',
                filled: true,
                fillColor: LightTheme.secondary,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _loadingAccount ? null : _saveAccountSettings,
              style: ElevatedButton.styleFrom(backgroundColor: LightTheme.primary).copyWith(
                foregroundColor: MaterialStateProperty.all(LightTheme.textPrimary),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              ),
              child: _loadingAccount
                  ? SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: LightTheme.textPrimary),
                    )
                  : Text('Zapisz ustawienia'),
            ),
            SizedBox(height: 20),
          ],

        ProfileActionButtons(
          nickname: nickname,
          isEditing: isEditing,
          onCreate: _createProfile,
          onEdit: _createProfile,
          onSave: _changeProfileSettings,
        ),

        SizedBox(height: 20),

        ProfileAccountButtons(
            hasProfile: nickname != null,
            isDeletingProfile: _isDeleting,
            onDeleteProfile: _deleteProfile,
            isDeletingAccount: _isDeletingAccount,
            onDeleteAccount: _deleteAccount,
          ),
            ],
           ),
          ),
        ),
      ]
    ),
  );
 }
}
