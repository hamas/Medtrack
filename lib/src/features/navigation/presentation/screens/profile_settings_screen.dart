import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
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
  final TextEditingController _conditionsController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  String? _selectedBloodType;
  bool _initialized = false;

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
    _conditionsController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<UserProfile> profileAsync = ref.watch(
      userProfileStateProvider,
    );

    // Ensure controllers are initialized when data arrives
    profileAsync.whenData(
      (UserProfile profile) => _initializeControllers(profile),
    );

    return profileAsync.when(
      data: (UserProfile profile) => SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.symmetric(horizontal: 16), // Standardized to 16
          children: <Widget>[
            const SizedBox(height: 20),
            _buildField(
                'Display Name',
                _nameController,
                Symbols.person_rounded,
              ),
              _buildField(
                'Email Address',
                _emailController,
                Symbols.mail_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildField(
                'Phone Number',
                _phoneController,
                Symbols.call_rounded,
                keyboardType: TextInputType.phone,
              ),
              _buildField(
                'Emergency Contact',
                _emergencyContactController,
                Symbols.e911_emergency_rounded,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              const _SectionTitle(title: 'HEALTH METRICS'),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _buildField(
                      'Age',
                      _ageController,
                      Symbols.event_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildBloodTypeDropdown()),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _buildField(
                      'Weight (kg)',
                      _weightController,
                      Symbols.monitor_weight_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildField(
                      'Height (cm)',
                      _heightController,
                      Symbols.height_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              _buildField(
                'Gender',
                _genderController,
                Symbols.wc_rounded,
              ),
              const SizedBox(height: 32),
              const _SectionTitle(title: 'MEDICAL HISTORY'),
              const SizedBox(height: 16),
              _buildField(
                'Conditions (comma separated)',
                _conditionsController,
                Symbols.medical_services_rounded,
                hint: 'e.g. Hypertension, Diabetes',
              ),
              _buildField(
                'Allergies (comma separated)',
                _allergiesController,
                Symbols.warning_rounded,
                hint: 'e.g. Peanuts, Penicillin',
              ),
              const SizedBox(height: 32),
              const _SectionTitle(title: 'PRIVACY & DOCUMENTATION'),
              const SizedBox(height: 16),
              _buildPrivacyTile(context),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _saveProfile,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, StackTrace? _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.white24, size: 20),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white10, fontSize: 13),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Blood Type',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBloodType,
                hint: const Text(
                  'Select',
                  style: TextStyle(color: Colors.white24, fontSize: 14),
                ),
                dropdownColor: const Color(0xFF1E293B),
                isExpanded: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (String? val) =>
                    setState(() => _selectedBloodType = val),
                items:
                    <String>[
                      'A+',
                      'A-',
                      'B+',
                      'B-',
                      'AB+',
                      'AB-',
                      'O+',
                      'O-',
                    ].map((String t) {
                      return DropdownMenuItem<String>(value: t, child: Text(t));
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }

  Widget _buildPrivacyTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: () => context.push('/policies'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: const Icon(Symbols.policy_rounded, color: Colors.white70),
        title: const Text(
          'App Policies',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: const Text(
          'Readme & Privacy Policy',
          style: TextStyle(color: Colors.white24, fontSize: 12),
        ),
        trailing: const Icon(
          Symbols.chevron_right_rounded,
          color: Colors.white24,
        ),
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
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Colors.white38,
        letterSpacing: 2,
      ),
    );
  }
}
