import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_motivation/firebase_options.dart';
import 'package:mobile_motivation/services/auth/auth_provider.dart';
import 'package:mobile_motivation/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

// Implementation of methods from FirebaseAuth such that they work
// with out Auth Provider services. This class interacts directly
// with Firebase and is necessary to avoid doing direct calls
// in the main UI of the application.
class FirebaseAuthProvider implements AuthProvider {
  // Using the user that FirebaseAuth creates, return an AuthUser
  // with the isEmailVerified flag true or false
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  // Direct Firebase createUser method returns a user, so we must
  // return an AuthUser
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw Exception('User not logged in!');
      }
      // Handle Firebase's authentication exceptions by throwing
      // our own exceptions.
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // Direct Firebase logIn method returns a user, so we must
  // return an AuthUser.
  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw Exception('User not logged in!');
      }
      // Handle Firebase's authentication exceptions by throwing
      // our own exceptions.
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw Exception('User not logged in!');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw Exception('User not logged in!');
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
