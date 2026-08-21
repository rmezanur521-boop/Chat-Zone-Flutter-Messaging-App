import 'package:chat_zone/core/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/profile_providers.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _bioController;
  late final TextEditingController _genderController;
  DateTime? _dateOfBirth;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final current = ref.read(myProfileProvider).asData?.value;
    _firstNameController =
        TextEditingController(text: current?.firstName ?? '');
    _lastNameController = TextEditingController(text: current?.lastName ?? '');
    _bioController = TextEditingController(text: current?.bio ?? '');
    _genderController = TextEditingController(text: current?.gender ?? '');
    _dateOfBirth = current?.dateOfBirth;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final success = await ref.read(myProfileProvider.notifier).update(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          bio: _bioController.text.trim(),
          gender: _genderController.text.trim(),
          dateOfBirth: _dateOfBirth,
        );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (success) {
      Navigator.of(context).pop();
    } else {
      AppSnackBar.error(context, 'Failed to update profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dobLabel = _dateOfBirth == null
        ? 'Not set'
        : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}';

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: _firstNameController,
                label: 'First name',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _lastNameController,
                label: 'Last name',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _genderController,
                label: 'Gender (optional)',
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _bioController,
                label: 'Bio (optional)',
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date of birth'),
                subtitle: Text(dobLabel),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: _pickDateOfBirth,
              ),
              const SizedBox(height: 28),
              AppButton(
                  label: 'Save Changes',
                  isLoading: _isSaving,
                  onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
