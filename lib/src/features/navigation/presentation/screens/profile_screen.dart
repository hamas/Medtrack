import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';
import '../../../medication_management/domain/entities/medicine.dart';
import '../../../medication_management/presentation/providers/all_medicines_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserProfile> profileAsync = ref.watch(
      userProfileStateProvider,
    );
    final User? authUser = FirebaseAuth.instance.currentUser;

    return profileAsync.when(
      data: (UserProfile profile) =>
          _buildContent(context, ref, profile, authUser),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object e, StackTrace? _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
    User? authUser,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: <Widget>[
        const SizedBox(height: 16),
        _buildHeader(context, profile, authUser),
        const SizedBox(height: 16),
        _buildEmergencyIdBanner(context, ref, profile),
        const SizedBox(height: 16),
        _buildBentoStats(profile),
        const SizedBox(height: 16),
        _buildMedicalCard(profile),
        const SizedBox(height: 24),
        _buildSectionHeader('YOUR ACHIEVEMENTS'),
        const SizedBox(height: 16),
        _buildProgressCard(profile),
        const SizedBox(height: 120),
      ],
    );
  }

  Widget _buildEmergencyIdBanner(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE11D48).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE11D48).withValues(alpha: 0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _showEmergencyIdModal(context, ref, profile),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE11D48),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Symbols.emergency_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Emergency Medical ID (ICE)',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Instant responder access to allergies & vitals',
                        style: TextStyle(fontSize: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Symbols.arrow_forward_ios_rounded,
                  color: Colors.white38,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEmergencyIdModal(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) {
    final List<Medicine> activeMeds =
        (ref.read(allMedicinesProvider).value ?? <Medicine>[])
            .where((Medicine m) => m.isActive)
            .toList();

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: const Color(0xFF0F172A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (BuildContext sheetCtx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetCtx).size.height * 0.88,
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE11D48).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Symbols.emergency_rounded,
                        color: Color(0xFFE11D48),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'EMERGENCY MEDICAL ID',
                            style: TextStyle(
                              color: Color(0xFFE11D48),
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            profile.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE11D48),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'BLOOD',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            profile.bloodType ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Critical Allergies
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Row(
                        children: <Widget>[
                          Icon(
                            Symbols.warning_amber_rounded,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'KNOWN ALLERGIES & ADVERSE REACTIONS',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.allergies.isEmpty
                            ? 'No known drug or environmental allergies recorded.'
                            : profile.allergies.join(', '),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Medical Conditions
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Row(
                        children: <Widget>[
                          Icon(
                            Symbols.medical_services_rounded,
                            color: Colors.blueAccent,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'CHRONIC CONDITIONS & DIAGNOSES',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.medicalConditions.isEmpty
                            ? 'No chronic conditions listed.'
                            : profile.medicalConditions.join(', '),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Emergency Contact & Physician
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'EMERGENCY CONTACT',
                              style: TextStyle(
                                color: Colors.white38,
                                fontWeight: FontWeight.w800,
                                fontSize: 9,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.emergencyContact ?? 'Not set',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            if (profile.emergencyContact != null &&
                                profile
                                    .emergencyContact!
                                    .isNotEmpty) ...<Widget>[
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: profile.emergencyContact!,
                                    ),
                                  );
                                  ScaffoldMessenger.of(sheetCtx).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Emergency contact copied to clipboard',
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(
                                  children: <Widget>[
                                    Icon(
                                      Symbols.content_copy_rounded,
                                      size: 12,
                                      color: Colors.blueAccent,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Copy Number',
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'PRIMARY PHYSICIAN',
                              style: TextStyle(
                                color: Colors.white38,
                                fontWeight: FontWeight.w800,
                                fontSize: 9,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.primaryPhysician ?? 'Not set',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Active Medications List
                const Text(
                  'CURRENT ACTIVE MEDICATIONS',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),

                if (activeMeds.isEmpty)
                  const Text(
                    'No active medications currently in cabinet.',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  )
                else
                  ...activeMeds.map((Medicine med) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Symbols.medication_rounded,
                            color: Colors.tealAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  med.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '${med.dosage} • ${med.intervalType.name.toUpperCase()} • ${med.remainingQuantity} units left',
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
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
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                _buildContactRow(
                  Symbols.mail_rounded,
                  (profile.email?.isNotEmpty ?? false)
                      ? profile.email!
                      : (user?.email ?? 'Not set'),
                ),
                const SizedBox(height: 4),
                _buildContactRow(
                  Symbols.call_rounded,
                  (profile.phone?.isNotEmpty ?? false)
                      ? profile.phone!
                      : '+1 000 000 0000',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(User? user) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white10, width: 1.5),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        backgroundImage: user?.photoURL != null
            ? NetworkImage(user!.photoURL!)
            : const AssetImage('assets/images/default_avatar.png')
                  as ImageProvider,
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String value) {
    return Row(
      children: <Widget>[
        Icon(icon, color: Colors.white24, size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white38,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBentoStats(UserProfile profile) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildStatCard(
            'Blood',
            profile.bloodType ?? '--',
            Symbols.bloodtype_rounded,
            Colors.redAccent,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            'Weight',
            '${profile.weight ?? '--'} kg',
            Symbols.monitor_weight_rounded,
            Colors.blueAccent,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            'Height',
            _formatHeight(profile),
            Symbols.straighten_rounded,
            Colors.greenAccent,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            'Age',
            '${profile.age ?? '--'} yrs',
            Symbols.event_rounded,
            Colors.orangeAccent,
          ),
        ),
      ],
    );
  }

  String _formatHeight(UserProfile profile) {
    if (profile.height == null) return '--';
    final double totalInches = profile.height! / 2.54;
    final int feet = (totalInches / 12).floor();
    final int inches = (totalInches % 12).round();
    return "$feet' $inches\"";
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
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
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white38,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
          _buildInfoRow(
            Symbols.person_rounded,
            'Gender',
            profile.gender ?? 'Not set',
          ),
          const Divider(height: 32, color: Colors.white10),
          _buildInfoRow(
            Symbols.medical_services_rounded,
            'Conditions',
            profile.medicalConditions.isEmpty
                ? 'None'
                : profile.medicalConditions.join(', '),
          ),
          const Divider(height: 32, color: Colors.white10),
          _buildInfoRow(
            Symbols.warning_rounded,
            'Allergies',
            profile.allergies.isEmpty ? 'None' : profile.allergies.join(', '),
          ),
          const Divider(height: 32, color: Colors.white10),
          _buildInfoRow(
            Symbols.e911_emergency_rounded,
            'Emergency Contact',
            profile.emergencyContact ?? 'Not set',
          ),
          const Divider(height: 32, color: Colors.white10),
          _buildInfoRow(
            Symbols.shield_rounded,
            'Insurance',
            profile.insuranceProvider ?? 'Not set',
          ),
          const Divider(height: 32, color: Colors.white10),
          _buildInfoRow(
            Symbols.stethoscope_rounded,
            'Primary Physician',
            profile.primaryPhysician ?? 'Not set',
          ),
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
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white38,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildProgressStat(
            'Streak',
            '${profile.currentStreak}',
            Symbols.local_fire_department_rounded,
            Colors.orange,
          ),
          _buildProgressStat(
            'Badges',
            '${profile.earnedBadges.length}',
            Symbols.emoji_events_rounded,
            Colors.amber,
          ),
          _buildProgressStat(
            'Record',
            '${profile.longestStreak}',
            Symbols.military_tech_rounded,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: <Widget>[
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white38,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.white38,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
