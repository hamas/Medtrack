import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? authUser = FirebaseAuth.instance.currentUser;
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
            _MenuTile(
              icon: Symbols.person_rounded,
              title: 'Profile Settings',
              subtitle: 'Personal details & Health metrics',
              color: Colors.blueAccent,
              onTap: () => context.push('/profile-settings'),
            ),
            _MenuTile(
              icon: Symbols.notifications_active_rounded,
              title: 'Notifications',
              subtitle: 'Reminders & Health tips',
              color: Colors.pinkAccent,
              onTap: () => context.push('/notifications'),
            ),
            _MenuTile(
              icon: Symbols.emoji_events_rounded,
              title: 'Achievements',
              subtitle: 'Heatmap & Earned Badges',
              color: Colors.amberAccent,
              onTap: () => context.push('/achievements'),
            ),
            _MenuTile(
              icon: Symbols.security_rounded,
              title: 'Security',
              subtitle: 'Biometrics & Cloud Sync',
              color: Colors.tealAccent,
              onTap: () => context.push('/security'),
            ),
            _MenuTile(
              icon: Symbols.policy_rounded,
              title: 'Policies',
              subtitle: 'Privacy, Terms & Documentation',
              color: Colors.purpleAccent,
              onTap: () => context.push('/policies'),
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.user,
    required this.profile,
    this.isLoading = false,
  });
  final User? user;
  final UserProfile profile;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      // Changed to Row to move picture left and name right
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Cinematic Glow
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
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage('assets/images/default_avatar.png')
                        as ImageProvider,
              child: isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white24,
                    )
                  : null,
            ),
          ],
        ),
        const SizedBox(width: 16), // Gap of 16 between picture and name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
            children: <Widget>[
              Text(
                user?.displayName ?? profile.name,
                style: const TextStyle(
                  fontSize: 22, // Reduced by ~20% from 28
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

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 4,
        ), // Minimalist padding
        visualDensity: VisualDensity.compact,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white38,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: const Icon(
          Symbols.chevron_right_rounded,
          color: Colors.white10,
          size: 18,
        ),
      ),
    );
  }
}
