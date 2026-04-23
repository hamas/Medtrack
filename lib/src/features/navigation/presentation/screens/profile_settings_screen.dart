import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';
import '../providers/settings_provider.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() =>
      ProfileSettingsScreenState();
}

class ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();
  final TextEditingController _insuranceController = TextEditingController();
  final TextEditingController _physicianController = TextEditingController();
  final TextEditingController _conditionsController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  
  String? _selectedBloodType;
  String? _selectedGender;
  DateTime? _selectedDOB;
  bool _initialized = false;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _initializeControllers(UserProfile profile) {
    if (_initialized) return;
    _nameController.text = profile.name;
    _emailController.text = profile.email ?? '';
    _phoneController.text = profile.phone ?? '';
    _emergencyContactController.text = profile.emergencyContact ?? '';
    _weightController.text = (profile.weight ?? 70.0).toStringAsFixed(0);
    _selectedGender = profile.gender;
    _insuranceController.text = profile.insuranceProvider ?? '';
    _physicianController.text = profile.primaryPhysician ?? '';
    _conditionsController.text = profile.medicalConditions.join(', ');
    _allergiesController.text = profile.allergies.join(', ');
    _selectedBloodType = profile.bloodType;
    
    // Height conversion
    if (profile.height != null) {
      final double totalInches = profile.height! / 2.54;
      final int feet = (totalInches / 12).floor();
      final int inches = (totalInches % 12).round();
      _feetController.text = feet.toString();
      _inchesController.text = inches.toString();
    } else {
      _feetController.text = '5';
      _inchesController.text = '8';
    }
    _initialized = true;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    _weightController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
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

    // Listen for global save trigger from MainScreen
    ref.listen(profileSaveTriggerProvider, (int? prev, int next) {
      if (next > 0) save();
    });

    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) {
        // Handled by MainScreen back button or hardware back
      },
      child: profileAsync.when(
        data: (UserProfile profile) => Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              _buildAvatarSection(),
              const SizedBox(height: 24),
              _buildTabBar(),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    _buildPersonalTab(),
                    _buildMedicalTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, StackTrace? _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(32),
        ),
        child: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.blueAccent.withValues(alpha: 0.15),
            border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
          ),
          labelColor: Colors.blueAccent,
          unselectedLabelColor: Colors.white38,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5),
          indicatorPadding: const EdgeInsets.all(4),
          tabs: const <Widget>[
            Tab(text: 'Personal Details'),
            Tab(text: 'Medical Details'),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        _buildFormCard(<Widget>[
          _buildField('Full Name', _nameController, Symbols.person_rounded, hint: 'John Doe'),
          _buildField('Email Address', _emailController, Symbols.mail_rounded, hint: 'example@medtrack.com', keyboardType: TextInputType.emailAddress),
          _buildField('Phone Number', _phoneController, Symbols.call_rounded, hint: '+1 234 567 890', keyboardType: TextInputType.phone),
          _buildGenderPicker(),
          Row(
            children: <Widget>[
              Expanded(child: _buildDOBPicker()),
              const SizedBox(width: 12),
              Expanded(child: _buildBloodTypePicker()),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(child: _buildWeightPicker()),
              const SizedBox(width: 12),
              Expanded(child: _buildHeightPicker()),
            ],
          ),
        ]),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildMedicalTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        _buildFormCard(<Widget>[
          _buildField('Conditions', _conditionsController, Symbols.medical_services_rounded, hint: 'e.g. Asthma, Hypertension'),
          _buildField('Allergies', _allergiesController, Symbols.warning_rounded, hint: 'e.g. Peanuts, Penicillin'),
          _buildField('Emergency Contact', _emergencyContactController, Symbols.e911_emergency_rounded, hint: 'Name or Phone number', keyboardType: TextInputType.phone),
          _buildField('Insurance Provider', _insuranceController, Symbols.shield_rounded, hint: 'e.g. Blue Cross'),
          _buildField('Primary Physician', _physicianController, Symbols.stethoscope_rounded, hint: 'Dr. Smith'),
        ]),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildAvatarSection() {
    final User? user = FirebaseAuth.instance.currentUser;
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10, width: 2),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
              ),
            ),
            if (_isUploading)
              const CircularProgressIndicator(color: Colors.blueAccent)
            else
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Symbols.photo_camera_rounded, color: Colors.white, size: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {TextInputType keyboardType = TextInputType.text, String? hint}) {
    const Color dulledGrey = Colors.white60; 
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white38, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: dulledGrey, fontWeight: FontWeight.w600, fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.03),
              prefixIcon: Icon(icon, color: Colors.white24, size: 18),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderPicker() {
    const Color dulledGrey = Colors.white60;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Gender', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white38, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showExpressiveBottomSheet(
            title: 'Select Gender',
            content: ListView(
              shrinkWrap: true,
              children: <String>['Male', 'Female', 'Rather not say']
                  .map((String value) => ListTile(
                        leading: Icon(
                          value == 'Male' ? Symbols.male_rounded : value == 'Female' ? Symbols.female_rounded : Symbols.person_rounded,
                          color: Colors.white38,
                        ),
                        title: Text(value, style: const TextStyle(color: dulledGrey, fontWeight: FontWeight.w600, fontSize: 13)),
                        trailing: _selectedGender == value ? const Icon(Symbols.check_circle_rounded, color: Colors.blueAccent) : null,
                        onTap: () {
                          setState(() => _selectedGender = value);
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: <Widget>[
                const Icon(Symbols.wc_rounded, color: Colors.white24, size: 18),
                const SizedBox(width: 12),
                Text(
                  _selectedGender ?? 'Select Gender',
                  style: const TextStyle(color: dulledGrey, fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const Spacer(),
                const Icon(Symbols.expand_more_rounded, color: Colors.white24, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBloodTypePicker() {
    const Color dulledGrey = Colors.white60;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Blood Type', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white38, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showExpressiveBottomSheet(
            title: 'Select Blood Type',
            content: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              padding: const EdgeInsets.all(16),
              children: <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                  .map((String value) => GestureDetector(
                        onTap: () {
                          setState(() => _selectedBloodType = value);
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _selectedBloodType == value ? Colors.blueAccent.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _selectedBloodType == value ? Colors.blueAccent : Colors.white10),
                          ),
                          child: Text(value, style: TextStyle(color: _selectedBloodType == value ? Colors.blueAccent : dulledGrey, fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      ))
                  .toList(),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: <Widget>[
                Text(
                  _selectedBloodType ?? 'Blood',
                  style: const TextStyle(color: dulledGrey, fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const Spacer(),
                const Icon(Symbols.expand_more_rounded, color: Colors.white24, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeightPicker() {
    const Color dulledGrey = Colors.white60;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Height', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white38, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showExpressiveBottomSheet(
            title: 'Select Height',
            content: SizedBox(
              height: 200,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 44,
                      scrollController: FixedExtentScrollController(initialItem: int.tryParse(_feetController.text) ?? 5),
                      onSelectedItemChanged: (int index) => setState(() => _feetController.text = index.toString()),
                      children: List<Widget>.generate(9, (int i) => Center(child: Text('$i ft', style: const TextStyle(color: dulledGrey, fontSize: 18)))),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 44,
                      scrollController: FixedExtentScrollController(initialItem: int.tryParse(_inchesController.text) ?? 8),
                      onSelectedItemChanged: (int index) => setState(() => _inchesController.text = index.toString()),
                      children: List<Widget>.generate(12, (int i) => Center(child: Text('$i in', style: const TextStyle(color: dulledGrey, fontSize: 18)))),
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: <Widget>[
                const Icon(Symbols.straighten_rounded, color: Colors.white24, size: 18),
                const SizedBox(width: 12),
                Text(
                  _feetController.text.isEmpty ? 'Select Height' : "${_feetController.text}' ${_inchesController.text}\"",
                  style: const TextStyle(color: dulledGrey, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightPicker() {
    const Color dulledGrey = Colors.white60;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Weight (kg)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white38, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showExpressiveBottomSheet(
            title: 'Select Weight',
            content: SizedBox(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 44,
                scrollController: FixedExtentScrollController(initialItem: (double.tryParse(_weightController.text) ?? 70).round()),
                onSelectedItemChanged: (int index) => setState(() => _weightController.text = index.toString()),
                children: List<Widget>.generate(201, (int i) => Center(child: Text('$i kg', style: const TextStyle(color: dulledGrey, fontSize: 18)))),
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: <Widget>[
                const Icon(Symbols.monitor_weight_rounded, color: Colors.white24, size: 18),
                const SizedBox(width: 12),
                Text(
                  _weightController.text.isEmpty ? 'Select Weight' : "${_weightController.text} kg",
                  style: const TextStyle(color: dulledGrey, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showExpressiveBottomSheet({required String title, required Widget content}) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: const Color(0xFF0F172A),
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -0.5)),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Symbols.close_rounded, color: Colors.white38),
                ),
              ],
            ),
            const SizedBox(height: 16),
            content,
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDOBPicker() {
    const Color dulledGrey = Colors.white60;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Date of Birth', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white38, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDOB ?? DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (BuildContext context, Widget? child) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white,
                    surface: Color(0xFF0F172A),
                    onSurface: Colors.white,
                  ),
                ),
                child: child!,
              ),
            );
            if (picked != null) setState(() => _selectedDOB = picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: <Widget>[
                const Icon(Symbols.calendar_today_rounded, color: Colors.white24, size: 18),
                const SizedBox(width: 12),
                Text(
                  _selectedDOB == null ? 'Select Date' : '${_selectedDOB!.day}/${_selectedDOB!.month}/${_selectedDOB!.year}',
                  style: const TextStyle(color: dulledGrey, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await showModalBottomSheet<XFile?>(
      context: context,
      useRootNavigator: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            const Text('Update Profile Picture', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildExpressiveOption(
                  icon: Symbols.photo_camera_rounded,
                  label: 'Camera',
                  onTap: () async {
                    final XFile? img = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
                    if (context.mounted) Navigator.pop(context, img);
                  },
                ),
                _buildExpressiveOption(
                  icon: Symbols.image_rounded,
                  label: 'Gallery',
                  onTap: () async {
                    final XFile? img = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
                    if (context.mounted) Navigator.pop(context, img);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );

    if (image != null) {
      if (!mounted) return;
      setState(() => _isUploading = true);
      try {
        final String uid = FirebaseAuth.instance.currentUser!.uid;
        final Reference refStorage = FirebaseStorage.instance.ref().child('avatars').child('$uid.jpg');
        await refStorage.putFile(File(image.path));
        final String url = await refStorage.getDownloadURL();
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

  Widget _buildExpressiveOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(icon, color: Colors.blueAccent, size: 32),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }

  Future<void> save() async {
    final UserProfile? current = ref.read(userProfileStateProvider).value;
    if (current == null) return;

    // Convert height (feet/inches) back to cm
    double? heightCm;
    if (_feetController.text.isNotEmpty || _inchesController.text.isNotEmpty) {
      final int feet = int.tryParse(_feetController.text) ?? 0;
      final int inches = int.tryParse(_inchesController.text) ?? 0;
      heightCm = ((feet * 12) + inches) * 2.54;
    }

    final UserProfile updated = current.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      emergencyContact: _emergencyContactController.text,
      age: _selectedDOB != null ? (DateTime.now().year - _selectedDOB!.year) : current.age,
      weight: double.tryParse(_weightController.text),
      height: heightCm,
      gender: _selectedGender,
      bloodType: _selectedBloodType,
      insuranceProvider: _insuranceController.text,
      primaryPhysician: _physicianController.text,
      medicalConditions: _conditionsController.text.split(',').map((String e) => e.trim()).where((String e) => e.isNotEmpty).toList(),
      allergies: _allergiesController.text.split(',').map((String e) => e.trim()).where((String e) => e.isNotEmpty).toList(),
    );

    try {
      if (current.uid == 'guest' || current.uid == 'hamas_lead_dev') {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Row(
               children: <Widget>[
                 Icon(Symbols.warning_rounded, color: Colors.orangeAccent, size: 20),
                 SizedBox(width: 12),
                 Text('Guest profiles cannot be saved to cloud.'),
               ],
             ),
           ),
         );
         context.pop();
         return;
      }

      await ref.read(userProfileStateProvider.notifier).updateProfile(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: <Widget>[
                Icon(Symbols.check_circle_rounded, color: Colors.greenAccent, size: 20),
                SizedBox(width: 12),
                Text('Profile updated successfully!'),
              ],
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: <Widget>[
                const Icon(Symbols.error_rounded, color: Colors.redAccent, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text('Save failed: $e')),
              ],
            ),
          ),
        );
      }
    }
  }
}
