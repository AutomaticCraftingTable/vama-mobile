import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/auth_provider.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wypełnij wszystkie pola')),
        );
        return;
      }

      setState(() => _isLoading = true);
      try {
        await ApiService().createProfile(
          nickname: nicknameController.text,
          description: descriptionController.text,
        );

        setState(() {
          nickname = nicknameController.text;
          description = descriptionController.text;
          isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil został utworzony!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Błąd: ${e.toString()}')),
        );
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
        title: Text('Usuń profil?'),
        content: Text('Na pewno chcesz usunąć profil?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Anuluj')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Usuń')),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil usunięty')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd usuwania: ${e.toString()}')),
      );
    } finally {
      setState(() => _isDeleting = false);
    }
  }
  Future<void> _saveAccountSettings() async {
    if (_emailCtrl.text.isEmpty &&
        (_oldPassCtrl.text.isEmpty || _newPassCtrl.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wypełnij email lub oba поля hasła')),
      );
      return;
    }
    setState(() => _loadingAccount = true);
    try {
      await ApiService().changeAccountSettings(
        email: _emailCtrl.text,
        oldPassword: _oldPassCtrl.text,
        newPassword: _newPassCtrl.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ustawienia konta zaktualizowane!')),
      );
      _oldPassCtrl.clear();
      _newPassCtrl.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd: ${e.toString()}')),
      );
    } finally {
      setState(() => _loadingAccount = false);
    }
  }
  Future<void> _deleteAccount() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Usuń konto?'),
      content: Text('Na pewno chcesz usunąć konto na stałe?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Anuluj')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Usuń')),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Błąd usuwania konta: ${e.toString()}')),
    );
  } finally {
    setState(() => _isDeletingAccount = false);
  }
}
Future<void> _changeProfileSettings() async {
  if (nicknameController.text.isEmpty || descriptionController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Wypełnij wszystkie pola')),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profil został zaktualizowany!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Błąd: ${e.toString()}')),
    );
  } finally {
    setState(() {
      _isLoading = false; 
    });
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
        Column(
          children: [
            if (nickname == null) 
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: LightTheme.primary,
                ).copyWith(
                  foregroundColor: MaterialStateProperty.all(LightTheme.textPrimary),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                onPressed: _createProfile,
                child: Center(
                  child: Text('Utwórz profil'),
                ),
              ),
            if (nickname != null && !isEditing) 
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: LightTheme.primary,
                ).copyWith(
                  foregroundColor: MaterialStateProperty.all(LightTheme.textPrimary),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                onPressed: _createProfile,
                child: Center(
                  child: Text('Edytuj profil'),
                ),
              ),
            if (isEditing && nickname != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: LightTheme.primary,
                ).copyWith(
                  foregroundColor: MaterialStateProperty.all(LightTheme.textPrimary),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                onPressed: _changeProfileSettings,
                child: Center(
                  child: Text('Zapisz zmiany'),
                ),
              ),
          ],
        ),

        SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (nickname != null)
               ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: LightTheme.danger).copyWith(
                foregroundColor: MaterialStateProperty.all(LightTheme.textPrimary),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              ),
              onPressed: _isDeleting ? null : _deleteProfile,
              child: _isDeleting
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: LightTheme.textPrimary),
            )
                 : Text('Usuń profil'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: LightTheme.danger,
              ).copyWith(
                foregroundColor: MaterialStateProperty.all(LightTheme.secondary),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
              ),
              onPressed: _isDeletingAccount ? null : _deleteAccount,
              child: _isDeletingAccount
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: LightTheme.textPrimary,
                      ),
                    )
                  : Text('Usuń konto'),
            ),
          ],
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
