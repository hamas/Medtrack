import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  bool _isUploading = false;

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _insuranceController;
  late TextEditingController _physicianController;
  late TextEditingController _conditionsController;
  late TextEditingController _allergiesController;
  String? _selectedBloodType;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    _emergencyContactController = TextEditingController();
    _insuranceController = TextEditingController();
    _physicianController = TextEditingController();
    _conditionsController = TextEditingController();
    _allergiesController = TextEditingController();
  }

  void _initializeData(UserProfile profile) {
    if (_initialized) return;
    _nameController.text = profile.name;
    _emailController.text = profile.email ?? '';
    _phoneController.text = profile.phone ?? '';
    _weightController.text = profile.weight?.toString() ?? '';
    _heightController.text = profile.height?.toString() ?? '';
    _ageController.text = profile.age?.toString() ?? '';
    _genderController.text = profile.gender ?? '';
    _emergencyContactController.text = profile.emergencyContact ?? '';
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
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _emergencyContactController.dispose();
    _insuranceController.dispose();
    _physicianController.dispose();
    _conditionsController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<UserProfile> profileAsync =
        ref.watch(userProfileStateProvider);
    final User? authUser = FirebaseAuth.instance.currentUser;

    return profileAsync.when(
      data: (UserProfile profile) {
        _initializeData(profile);
        return _buildContent(context, profile, authUser);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object e, StackTrace? _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildContent(
      BuildContext context, UserProfile profile, User? authUser) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: <Widget>[
        const SizedBox(height: 16),
        _buildHeader(context, profile, authUser),
        const SizedBox(height: 16),
        _buildBentoStats(profile),
        const SizedBox(height: 16),
        _buildMedicalCard(profile),
        const SizedBox(height: 24),
        _buildSectionHeader('YOUR ACHIEVEMENTS'),
        const SizedBox(height: 16),
        _buildProgressCard(profile),
        const SizedBox(height: 32),
        _buildActionButtons(),
        const SizedBox(height: 120),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, UserProfile profile, User? user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: <Widget>[
          _buildAvatar(user),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (_isEditing)
                  _buildInlineTextField(_nameController,
                      fontSize: 20, fontWeight: FontWeight.w900)
                else
                  Text(profile.name,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5)),
                const SizedBox(height: 4),
                _buildContactRow(
                    Symbols.mail_rounded,
                    _emailController,
                    (profile.email?.isNotEmpty ?? false)
                        ? profile.email!
                        : (user?.email ?? 'email@medtrack.com')),
                const SizedBox(height: 4),
                _buildContactRow(
                    Symbols.call_rounded,
                    _phoneController,
                    (profile.phone?.isNotEmpty ?? false)
                        ? profile.phone!
                        : '+1 000 000 0000'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(User? user) {
    return GestureDetector(
      onTap: _isEditing ? _pickImage : null,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10, width: 1.5)),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage('assets/images/default_avatar.png')
                      as ImageProvider,
            ),
          ),
          if (_isEditing)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.black45, shape: BoxShape.circle),
              child: _isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Symbols.photo_camera_rounded,
                      color: Colors.white, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildContactRow(
      IconData icon, TextEditingController controller, String displayValue) {
    return Row(
      children: <Widget>[
        Icon(icon, color: Colors.white24, size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: _isEditing
              ? _buildInlineTextField(controller,
                  fontSize: 13, color: Colors.white70)
              : Text(displayValue,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white38,
                      fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _buildBentoStats(UserProfile profile) {
    return Row(
      children: <Widget>[
        Expanded(
            child: _buildStatCard('Blood', _selectedBloodType ?? '--',
                Symbols.bloodtype_rounded, Colors.redAccent,
                isBlood: true)),
        const SizedBox(width: 8),
        Expanded(
            child: _buildStatCard('Weight', '${_weightController.text} kg',
                Symbols.monitor_weight_rounded, Colors.blueAccent,
                controller: _weightController, suffix: ' kg')),
        const SizedBox(width: 8),
        Expanded(
            child: _buildStatCard('Height', '${_heightController.text} cm',
                Symbols.height_rounded, Colors.greenAccent,
                controller: _heightController, suffix: ' cm')),
        const SizedBox(width: 8),
        Expanded(
            child: _buildStatCard('Age', '${_ageController.text} yrs',
                Symbols.event_rounded, Colors.orangeAccent,
                controller: _ageController, suffix: ' yrs')),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color,
      {TextEditingController? controller,
      String? suffix,
      bool isBlood = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 12),
          if (_isEditing)
            isBlood
                ? _buildBloodTypePicker()
                : _buildInlineTextField(controller!,
                    fontSize: 13, textAlign: TextAlign.center)
          else
            Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white38,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildBloodTypePicker() {
    return GestureDetector(
      onTap: () => _showBloodTypePicker(),
      child: Text(_selectedBloodType ?? '--',
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.blueAccent)),
    );
  }

  void _showBloodTypePicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
              .map((String t) => InkWell(
                    onTap: () {
                      setState(() => _selectedBloodType = t);
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _selectedBloodType == t
                            ? Colors.blueAccent
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(t,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildMedicalCard(UserProfile profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildInfoRow(Symbols.person_rounded, 'Gender', _genderController),
          const Divider(height: 32, color: Colors.white10),
          _buildInfoRow(Symbols.medical_services_rounded, 'Conditions',
              _conditionsController,
              hint: 'Comma separated'),
          const Divider(height: 32, color: Colors.white10),
          _buildInfoRow(
              Symbols.warning_rounded, 'Allergies', _allergiesController,
              hint: 'Comma separated'),
          const Divider(height: 32, color: Colors.white10),
          _buildInfoRow(Symbols.e911_emergency_rounded, 'Emergency Contact',
              _emergencyContactController),
          const Divider(height: 32, color: Colors.white10),
          _buildInfoRow(
              Symbols.shield_rounded, 'Insurance', _insuranceController),
          const Divider(height: 32, color: Colors.white10),
          _buildInfoRow(Symbols.stethoscope_rounded, 'Primary Physician',
              _physicianController),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, TextEditingController controller,
      {String? hint}) {
    return Row(
      children: <Widget>[
        Icon(icon, color: Colors.white24, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white38,
                      fontWeight: FontWeight.w600)),
              if (_isEditing)
                _buildInlineTextField(controller,
                    fontSize: 14, color: Colors.white70, hint: hint)
              else
                Text(controller.text.isEmpty ? 'Not set' : controller.text,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInlineTextField(TextEditingController controller,
      {double fontSize = 14,
      FontWeight fontWeight = FontWeight.w600,
      Color color = Colors.white,
      TextAlign textAlign = TextAlign.start,
      String? hint}) {
    return TextField(
      controller: controller,
      textAlign: textAlign,
      cursorColor: Colors.white,
      style:
          TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white10, fontSize: 12),
      ),
    );
  }

  Widget _buildProgressCard(UserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildProgressStat('Streak', '${profile.currentStreak}',
              Symbols.local_fire_department_rounded, Colors.orange),
          _buildProgressStat('Badges', '${profile.earnedBadges.length}',
              Symbols.emoji_events_rounded, Colors.amber),
          _buildProgressStat('Record', '${profile.longestStreak}',
              Symbols.military_tech_rounded, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildProgressStat(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: <Widget>[
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white)),
        Text(label,
            style: const TextStyle(
                fontSize: 10,
                color: Colors.white38,
                fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Center(
      child: Text(title,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.white38,
              letterSpacing: 2)),
    );
  }

  Widget _buildActionButtons() {
    if (_isEditing) {
      return Center(
        child: TextButton.icon(
          onPressed: _saveProfile,
          style: TextButton.styleFrom(
              foregroundColor: Colors.white38,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
          icon: const Icon(Symbols.check_circle_rounded, size: 14),
          label: const Text('Save Changes',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ),
      );
    }
    return Center(
      child: TextButton.icon(
        onPressed: () => setState(() => _isEditing = true),
        style: TextButton.styleFrom(
            foregroundColor: Colors.white38,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
        icon: const Icon(Symbols.edit_rounded, size: 14),
        label: const Text('Edit Profile',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
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
              leading:
                  const Icon(Symbols.photo_camera_rounded, color: Colors.white),
              title: const Text('Take Photo',
                  style: TextStyle(color: Colors.white)),
              onTap: () async {
                final XFile? img = await picker.pickImage(
                    source: ImageSource.camera, imageQuality: 50);
                navigator.pop(img);
              },
            ),
            ListTile(
              leading: const Icon(Symbols.image_rounded, color: Colors.white),
              title: const Text('Choose from Gallery',
                  style: TextStyle(color: Colors.white)),
              onTap: () async {
                final XFile? img = await picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 50);
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
        final Reference ref =
            FirebaseStorage.instance.ref().child('avatars').child('$uid.jpg');
        await ref.putFile(File(image.path));
        final String url = await ref.getDownloadURL();
        await FirebaseAuth.instance.currentUser!.updatePhotoURL(url);
        if (!mounted) return;
        setState(() {});
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isUploading = false);
        }
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
      medicalConditions: _conditionsController.text
          .split(',')
          .map((String e) => e.trim())
          .where((String e) => e.isNotEmpty)
          .toList(),
      allergies: _allergiesController.text
          .split(',')
          .map((String e) => e.trim())
          .where((String e) => e.isNotEmpty)
          .toList(),
    );

    await ref.read(userProfileStateProvider.notifier).updateProfile(updated);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green));
      setState(() => _isEditing = false);
    }
  }
}
