// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Provides the global instance of the FirebaseService
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

// Reactively provides the current Firebase Auth user state
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Enable offline persistence immediately for the backup requirement
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Setup Cloud Messaging handlers
    await _setupMessaging();
    _initialized = true;
  }

  Future<void> _setupMessaging() async {
    // Request permissions for high priority alerts
    await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
  }

  void _showLocalNotification(RemoteMessage message) {
    // Relying on the underlying flutter_local_notifications plugin
    // injected natively or configured earlier in NotificationManager
    final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();
    
    // We construct a generalized local display logic based on FCM payload
    if (message.notification != null) {
      localNotifications.show(
        message.notification.hashCode,
        message.notification!.title,
        message.notification!.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_medical_alerts',
            'Medical Alerts',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  }

  // --- Authentication Scaffold ---

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential?> createAccount(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // The user canceled the sign-in

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
