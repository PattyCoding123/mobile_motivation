// // Login Exceptions
// class UserNotFoundAuthException implements Exception {}

// class WrongPasswordAuthException implements Exception {}

// // =====================================================
// // =====================================================

// // Register Exceptions
// class WeakPasswordAuthException implements Exception {}

// class EmailAlreadyInUseAuthException implements Exception {}

// class InvalidEmailAuthException implements Exception {}

// // =====================================================
// // =====================================================

// // Generic Exceptions
// class GenericAuthException implements Exception {}

// class UserNotLoggedInAuthException implements Exception {}

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/material.dart' show immutable;

// Mapping of Strings (error codes) and the AuthErrors
const Map<String, AuthError> authErrorMapping = {
  // Login Exceptions
  'user-not-found': AuthErrorUserNotFound(),
  'wrong-password': AuthErrorWrongPassword(),

  // Registration Exceptions
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),

  // Operation and Recent Authentication Exceptions
  'operation-not-allowed': AuthErrorOperationNotAllowed(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),

  // No current user exception
  'no-current-user': AuthErrorNoCurrentUser(),

  // Password Reset Exceptions
  'firebase_auth/invalid-email': AuthErrorInvalidEmail(),
  'firebase_auth/user-not-found': AuthErrorUserNotFound(),
};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });

  // Either Return an AuthError from the authErrorMapping map or return
  // an AuthErrorUnknown instance if the error is not in the map.
  factory AuthError.fromFirebase(Exception? exception) {
    if (exception is FirebaseAuthException) {
      return authErrorMapping[exception.code.toLowerCase().trim()] ??
          const AuthErrorUnknown();
    } else {
      return const AuthErrorUnknown();
    }
  }
}

@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          dialogTitle: 'Auththentication Error',
          dialogText: 'Unknown authentication error',
        );
}

@immutable
// no-current-user
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogTitle: 'No current user',
          dialogText: 'No current user with this information was found!',
        );
}

// user has not logged in for awhile
// requires-recent-login
@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          dialogTitle: 'Requires recent login',
          dialogText:
              'You need to log out and log back in again in order to perform this operation',
        );
}

// email-password sign in is not enabled. Please enable this in project's
// authentication tab in Firebase console.
// operation-not-allowed
@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
          dialogTitle: 'Operation not allowed',
          dialogText: 'You cannot register using this method at this moment!',
        );
}

// user-not-found
@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogTitle: 'User not found',
          dialogText: 'The given user was not found on the server',
        );
}

// weak-password
@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          dialogTitle: 'Weak password',
          dialogText:
              'Please choose a stronger password consisting of more character!',
        );
}

// invalid-email
@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          dialogTitle: 'Invalid email',
          dialogText: 'Please make sure you are entering your email correctly!',
        );
}

// email-already-in-use
@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          dialogTitle: 'Email already in use',
          dialogText: 'Please choose another email to register with!',
        );
}

// wrong-password
@immutable
class AuthErrorWrongPassword extends AuthError {
  const AuthErrorWrongPassword()
      : super(
          dialogTitle: 'Wrong Email or Password',
          dialogText:
              'Please make sure you are entering your email and password correctly!',
        );
}
