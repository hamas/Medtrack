import '../entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile> getUserProfile(String uid);
  Future<void> saveUserProfile(UserProfile profile);
  Stream<UserProfile> streamUserProfile(String uid);
}
