import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserProfile> profileAsync = ref.watch(userProfileStateProvider);
    final User? authUser = FirebaseAuth.instance.currentUser;

    return profileAsync.when(
      data: (UserProfile profile) => _buildContent(context, profile, authUser),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object e, StackTrace? _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildContent(BuildContext context, UserProfile profile, User? authUser) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: <Widget>[
        const SizedBox(height: 20),
        
        // Header Section
        _buildHeader(profile, authUser),
        const SizedBox(height: 24),

        // Bento Grid for Stats
        _buildBentoStats(profile),
        const SizedBox(height: 16),

        // Medical Info Section
        _buildSectionHeader('MEDICAL PROFILE'),
        const SizedBox(height: 8),
        _buildMedicalCard(profile),
        const SizedBox(height: 16),

        // Achievements & Streaks
        _buildSectionHeader('YOUR ACHIEVEMENTS'),
        const SizedBox(height: 8),
        _buildProgressCard(profile),
        const SizedBox(height: 32),

        // Edit Button
        _buildEditButton(context),
        const SizedBox(height: 120),
      ],
    );
  }

  Widget _buildHeader(UserProfile profile, User? user) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomRight,
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
            if (profile.equippedBadgeId != null)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Symbols.verified_rounded, color: Colors.white, size: 16),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          profile.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          profile.email ?? user?.email ?? 'No email set',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white38,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildBentoStats(UserProfile profile) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: <Widget>[
        _buildStatCard('Blood', profile.bloodType ?? '--', Symbols.bloodtype_rounded, Colors.redAccent),
        _buildStatCard('Weight', '${profile.weight ?? '--'} kg', Symbols.monitor_weight_rounded, Colors.blueAccent),
        _buildStatCard('Height', '${profile.height ?? '--'} cm', Symbols.height_rounded, Colors.greenAccent),
        _buildStatCard('Age', '${profile.age ?? '--'} yrs', Symbols.event_rounded, Colors.orangeAccent),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.white38, fontWeight: FontWeight.w600),
          ),
        ],
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
          _buildInfoRow(Symbols.medical_services_rounded, 'Conditions', 
            profile.medicalConditions.isEmpty ? 'No conditions listed' : profile.medicalConditions.join(', ')),
          const Divider(height: 32, color: Colors.white10),
          _buildInfoRow(Symbols.warning_rounded, 'Allergies', 
            profile.allergies.isEmpty ? 'No allergies reported' : profile.allergies.join(', ')),
          const Divider(height: 32, color: Colors.white10),
          _buildInfoRow(Symbols.e911_emergency_rounded, 'Emergency Contact', profile.emergencyContact ?? 'Not set'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: <Widget>[
        Icon(icon, color: Colors.white24, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.white38, fontWeight: FontWeight.w600)),
              Text(value, style: const TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(UserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Colors.blueAccent.withValues(alpha: 0.1), Colors.purpleAccent.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildProgressStat('Streak', '${profile.currentStreak}', Symbols.local_fire_department_rounded, Colors.orange),
          _buildProgressStat('Badges', '${profile.earnedBadges.length}', Symbols.emoji_events_rounded, Colors.amber),
          _buildProgressStat('Record', '${profile.longestStreak}', Symbols.military_tech_rounded, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: <Widget>[
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white38, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
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

  Widget _buildEditButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => context.push('/profile-settings/edit'),
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        side: const BorderSide(color: Colors.white10),
      ),
      icon: const Icon(Symbols.edit_rounded, size: 20),
      label: const Text('Edit Health Profile', style: TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}
