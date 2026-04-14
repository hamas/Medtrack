import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> initialize() async {
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
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      
      final GoogleSignInClientAuthorization authResult = await googleUser.authorizationClient.authorizeScopes(<String>[
        'email',
        'profile',
        'openid',
      ]);

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

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
