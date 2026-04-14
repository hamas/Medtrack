// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GoogleSignIn is a singleton in v7.x
  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> initialize() async {
    // Required for google_sign_in v7+
    await _googleSignIn.initialize();
  }

  Future<UserCredential?> registerWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential?> loginWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Authenticate (Identify the user)
      // v7.x uses authenticate() instead of signIn()
      final googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) return null;

      // 2. Authorize (Obtain access to tokens)
      // We must explicitly request scopes to get an accessToken in v7+
      final authResult = await googleUser.authorizationClient.authorizeScopes([
        'email',
        'profile',
        'openid',
      ]);

      // 3. Get idToken for Firebase
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authResult.accessToken,
        idToken: idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
