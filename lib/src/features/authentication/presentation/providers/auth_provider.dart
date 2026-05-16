import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
Stream<User?> authState(Ref ref) {
  if (Firebase.apps.isEmpty) {
    return Stream<User?>.value(null);
  }
  return FirebaseAuth.instance.authStateChanges();
}

@riverpod
String? currentUid(Ref ref) {
  return ref.watch(authStateProvider).value?.uid;
}
