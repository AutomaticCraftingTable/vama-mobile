import 'package:flutter/material.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/%D1%81ustom_snack_bar.dart';
import 'package:vama_mobile/components/bottom_panel/main_logged_in_layout.dart';
import 'package:vama_mobile/components/headers/header.dart';
import 'package:vama_mobile/theme/light_theme.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({Key? key}) : super(key: key);

  @override
  State<AddArticle> createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  final List<String> _tags = [];
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isEmpty) return;
    if (_tags.contains(trimmed)) return;
    setState(() {
      _tags.add(trimmed);
      _tagController.clear();
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _onPublishPressed() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ApiService().createArticle(
        title: title,
        body: body,
        tags: _tags,
      );

      showCustomSnackBar(context, "Artykuł został opublikowany!");
      Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
      builder: (context) => const MainLoggedInLayout(),
       ),
        (Route<dynamic> route) => false, 
      );
    } catch (e) {
      showCustomSnackBar(
        context,
        "Błąd podczas publikacji: ${e.toString()}",
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Tytuł',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: true,
                      fillColor: LightTheme.secondary,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    style: const TextStyle(fontSize: 16),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Pole nie może być puste';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _bodyController,
                    decoration: InputDecoration(
                      hintText: 'Artykuł zaczyna się tutaj...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: true,
                      fillColor: LightTheme.secondary,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 15,
                    maxLines: null,
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Pole nie może być puste';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    'Tagi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tagController,
                          decoration: InputDecoration(
                            hintText: 'Wpisz tag',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: true,
                            fillColor: LightTheme.secondary,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                            _addTag(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _addTag(_tagController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: LightTheme.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        child: const Text(
                          'Dodaj',
                          style: TextStyle(color: LightTheme.secondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (_tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: _tags
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              backgroundColor: LightTheme.accentLight,
                              onDeleted: () {
                                _removeTag(tag);
                              },
                            ),
                          )
                          .toList(),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _onPublishPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isSubmitting ? LightTheme.textDimmed : LightTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: LightTheme.secondary,
                      ),
                    )
                  : const Text(
                      'Opublikuj',
                      style: TextStyle(
                        color: LightTheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
