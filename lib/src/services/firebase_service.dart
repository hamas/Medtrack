// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GoogleSignIn is a singleton in v7.x
  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> registerWithEmail(
    String email,
    String password,
  ) async {
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
    final googleUser = await _googleSignIn.authenticate();
    if (googleUser == null) return null;

    // In v7+, we get individual tokens via authentication or authorizationClient
    final googleAuth = googleUser.authentication;

    // For idToken, it's still on authentication
    final idToken = googleAuth.idToken;

    // For accessToken in v7+, we request it via authorizeScopes
    final authResult = await googleUser.authorizationClient.authorizeScopes([
      'email',
      'profile',
    ]);

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: authResult.accessToken,
      idToken: idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
