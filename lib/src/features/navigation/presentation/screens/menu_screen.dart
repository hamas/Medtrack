import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/widgets/shared_ui.dart';
import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';
import '../providers/settings_provider.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? authUser = Firebase.apps.isNotEmpty
        ? FirebaseAuth.instance.currentUser
        : null;
    final AsyncValue<UserProfile> userProfileAsync = ref.watch(
      userProfileStateProvider,
    );

    return Stack(
      children: <Widget>[
        ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            20,
            16,
            120, // Padding for bottom nav + footer
          ),
          children: <Widget>[
            // --- Profile Header ---
            userProfileAsync.when(
              data: (UserProfile profile) =>
                  _ProfileHeader(user: authUser, profile: profile),
              loading: () => _ProfileHeader(
                user: authUser,
                profile: UserProfile(
                  uid: authUser?.uid ?? 'loading',
                  name: authUser?.displayName ?? 'Hamas',
                ),
                isLoading: true,
              ),
              error: (Object e, StackTrace? _) => const _ProfileHeader(
                user: null,
                profile: UserProfile(uid: 'error', name: 'Hamas'),
              ),
            ),

            const SizedBox(height: 24),

            // --- Navigation Options ---
            GlassActionTile(
              icon: Symbols.person_rounded,
              title: 'Profile Settings',
              subtitle: 'Personal details & Health metrics',
              color: Colors.blueAccent,
              onTap: () => context.push('/profile/edit'),
            ),
            GlassActionTile(
              icon: Symbols.notifications_active_rounded,
              title: 'Notifications',
              subtitle: 'Reminders & Health tips',
              color: Colors.pinkAccent,
              onTap: () => context.push('/notifications'),
            ),
            GlassActionTile(
              icon: Symbols.emoji_events_rounded,
              title: 'Achievements',
              subtitle: 'Heatmap & Earned Badges',
              color: Colors.amberAccent,
              onTap: () => context.push('/menu/achievements'),
            ),
            GlassActionTile(
              icon: Symbols.security_rounded,
              title: 'Security',
              subtitle: 'Biometrics & Cloud Sync',
              color: Colors.tealAccent,
              onTap: () => context.push('/menu/security'),
            ),
            GlassActionTile(
              icon: Symbols.policy_rounded,
              title: 'Policies',
              subtitle: 'Privacy, Terms & Documentation',
              color: Colors.purpleAccent,
              onTap: () => context.push('/menu/policies'),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 100, // Above bottom nav
          child: Center(
            child: Text(
              'Developed by Hamas ❤️',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.4),
                letterSpacing: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends ConsumerWidget {
  const _ProfileHeader({
    required this.user,
    required this.profile,
    this.isLoading = false,
  });
  final User? user;
  final UserProfile profile;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final String? localAvatarPath = ref.watch(customAvatarPathProvider);
    ImageProvider avatarImage;
    if (localAvatarPath != null &&
        localAvatarPath.isNotEmpty &&
        File(localAvatarPath).existsSync()) {
      avatarImage = FileImage(File(localAvatarPath));
    } else if (user?.photoURL != null && user!.photoURL!.isNotEmpty) {
      avatarImage = NetworkImage(user!.photoURL!);
    } else {
      avatarImage = const AssetImage('assets/images/default_avatar.png');
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              backgroundImage: avatarImage,
              child: isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white24,
                    )
                  : null,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user?.displayName ?? profile.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              if (user?.email != null || profile.email != null) ...<Widget>[
                const SizedBox(height: 2),
                Text(
                  user?.email ?? profile.email!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white38,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
