import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _insuranceController = TextEditingController();
  final TextEditingController _physicianController = TextEditingController();
  final TextEditingController _conditionsController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  String? _selectedBloodType;
  bool _initialized = false;
  bool _isUploading = false;

  void _initializeControllers(UserProfile profile) {
    if (_initialized) return;
    _nameController.text = profile.name;
    _emailController.text = profile.email ?? '';
    _phoneController.text = profile.phone ?? '';
    _emergencyContactController.text = profile.emergencyContact ?? '';
    _weightController.text = profile.weight?.toString() ?? '';
    _heightController.text = profile.height?.toString() ?? '';
    _ageController.text = profile.age?.toString() ?? '';
    _genderController.text = profile.gender ?? '';
    _insuranceController.text = profile.insuranceProvider ?? '';
    _physicianController.text = profile.primaryPhysician ?? '';
    _conditionsController.text = profile.medicalConditions.join(', ');
    _allergiesController.text = profile.allergies.join(', ');
    _selectedBloodType = profile.bloodType;
    _initialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _insuranceController.dispose();
    _physicianController.dispose();
    _conditionsController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<UserProfile> profileAsync = ref.watch(userProfileStateProvider);

    profileAsync.whenData((UserProfile profile) => _initializeControllers(profile));

    return profileAsync.when(
      data: (UserProfile profile) => Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              const SizedBox(height: 8),
              _buildAvatarSection(profile),
              const SizedBox(height: 32),
              
              _buildFormCard('BASIC INFORMATION', <Widget>[
                _buildField('Full Name', _nameController, Symbols.person_rounded),
                _buildField('Email Address', _emailController, Symbols.mail_rounded, keyboardType: TextInputType.emailAddress),
                _buildField('Phone Number', _phoneController, Symbols.call_rounded, keyboardType: TextInputType.phone),
                _buildField('Gender', _genderController, Symbols.wc_rounded),
              ]),

              _buildFormCard('HEALTH VITALS', <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: _buildField('Age', _ageController, Symbols.event_rounded, keyboardType: TextInputType.number)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildBloodTypeDropdown()),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: _buildField('Weight (kg)', _weightController, Symbols.monitor_weight_rounded, keyboardType: TextInputType.number)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildField('Height (cm)', _heightController, Symbols.height_rounded, keyboardType: TextInputType.number)),
                  ],
                ),
              ]),

              _buildFormCard('MEDICAL HISTORY', <Widget>[
                _buildField('Conditions', _conditionsController, Symbols.medical_services_rounded, hint: 'Comma separated'),
                _buildField('Allergies', _allergiesController, Symbols.warning_rounded, hint: 'Comma separated'),
              ]),

              _buildFormCard('PROFESSIONAL DETAILS', <Widget>[
                _buildField('Emergency Contact', _emergencyContactController, Symbols.e911_emergency_rounded, keyboardType: TextInputType.phone),
                _buildField('Insurance Provider', _insuranceController, Symbols.shield_rounded),
                _buildField('Primary Physician', _physicianController, Symbols.stethoscope_rounded),
              ]),

              const SizedBox(height: 16),
              _buildPrivacyTile(context),
              const SizedBox(height: 32),
              
              _buildSaveButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object e, StackTrace? _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildAvatarSection(UserProfile profile) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white10, width: 2),
                ),
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                ),
              ),
              if (_isUploading)
                const CircularProgressIndicator()
              else
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Symbols.photo_camera_rounded, color: Colors.white, size: 24),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Tap to change photo',
          style: TextStyle(fontSize: 12, color: Colors.white38, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildFormCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionTitle(title: title),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {TextInputType keyboardType = TextInputType.text, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white24, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.white24, size: 20),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white10, fontSize: 13),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.03),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Blood Type', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white24, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(20)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedBloodType,
              hint: const Text('Select', style: TextStyle(color: Colors.white24, fontSize: 14)),
              dropdownColor: const Color(0xFF1E293B),
              isExpanded: true,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              onChanged: (String? val) => setState(() => _selectedBloodType = val),
              items: <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].map((String t) => DropdownMenuItem<String>(value: t, child: Text(t))).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(colors: <Color>[Colors.blueAccent, Colors.purpleAccent]),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: const Text('Save Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final NavigatorState navigator = Navigator.of(context);
    final XFile? image = await showModalBottomSheet<XFile?>(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      builder: (BuildContext context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Symbols.photo_camera_rounded, color: Colors.white),
              title: const Text('Take Photo', style: TextStyle(color: Colors.white)),
              onTap: () async {
                final XFile? img = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
                navigator.pop(img);
              },
            ),
            ListTile(
              leading: const Icon(Symbols.image_rounded, color: Colors.white),
              title: const Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
              onTap: () async {
                final XFile? img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
                navigator.pop(img);
              },
            ),
          ],
        ),
      ),
    );

    if (image != null) {
      if (!mounted) return;
      setState(() => _isUploading = true);
      try {
        final String uid = FirebaseAuth.instance.currentUser!.uid;
        final Reference ref = FirebaseStorage.instance.ref().child('avatars').child('$uid.jpg');
        await ref.putFile(File(image.path));
        final String url = await ref.getDownloadURL();
        await FirebaseAuth.instance.currentUser!.updatePhotoURL(url);
        if (!mounted) return;
        setState(() {});
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      } finally {
        if (mounted) setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    final UserProfile? current = ref.read(userProfileStateProvider).value;
    if (current == null) return;

    final UserProfile updated = current.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      emergencyContact: _emergencyContactController.text,
      age: int.tryParse(_ageController.text),
      weight: double.tryParse(_weightController.text),
      height: double.tryParse(_heightController.text),
      gender: _genderController.text,
      bloodType: _selectedBloodType,
      insuranceProvider: _insuranceController.text,
      primaryPhysician: _physicianController.text,
      medicalConditions: _conditionsController.text.split(',').map((String e) => e.trim()).where((String e) => e.isNotEmpty).toList(),
      allergies: _allergiesController.text.split(',').map((String e) => e.trim()).where((String e) => e.isNotEmpty).toList(),
    );

    await ref.read(userProfileStateProvider.notifier).updateProfile(updated);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green));
      context.pop();
    }
  }

  Widget _buildPrivacyTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: () => context.push('/policies'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: const Icon(Symbols.policy_rounded, color: Colors.white70),
        title: const Text('App Policies', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: const Text('Readme & Privacy Policy', style: TextStyle(color: Colors.white24, fontSize: 12)),
        trailing: const Icon(Symbols.chevron_right_rounded, color: Colors.white24),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white38, letterSpacing: 2),
    );
  }
}
