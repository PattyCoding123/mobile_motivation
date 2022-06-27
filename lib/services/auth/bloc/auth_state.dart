part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Wait just a moment...',
  });
}

// State of AuthState that indicates the application is uninitialzed.
class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

// State of AuthState that indicates the user is registering.
class AuthStateRegistering extends AuthState {
  final AuthError? exception;
  const AuthStateRegistering({
    required this.exception,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

// State of AuthState that indicates the user forgot their password.
class AuthStateForgotPassword extends AuthState {
  final AuthError? exception;
  final bool hasSentEmail;
  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

// State of AuthState that indicates the user is logged in.
class AuthStateLoggedIn extends AuthState with EquatableMixin {
  final Exception? exception;
  final AuthUser user;
  final QuoteModel? quote;
  final Stream<Iterable<CloudQuote>>? favQuotes;
  const AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
    this.exception,
    this.favQuotes,
    this.quote,
  }) : super(isLoading: isLoading);

  @override
  List<Object?> get props => [quote, favQuotes];
}

// State of AuthState that indicates the user must verify their email.
class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

// State of AuthState that indicates the user is logged out (meaning
// they should be in the log in screen/not in the notes view).
// Since internals can be different, we need to include EquatableMixin
// to differentiate the different states of AuthStateLoggedOut.
// This state will also determine the loading screen for logging in/out.
class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final AuthError? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [exception, isLoading];
}

extension GetUser on AuthState {
  AuthUser? get user {
    final cls = this;
    if (cls is AuthStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetQuoteOfTheDay on AuthState {
  QuoteModel? get quote {
    final cls = this;
    if (cls is AuthStateLoggedIn) {
      return cls.quote;
    } else {
      return null;
    }
  }
}

extension GetQuotes on AuthState {
  Stream<Iterable<CloudQuote>>? get favQuotes {
    final cls = this;
    if (cls is AuthStateLoggedIn) {
      return cls.favQuotes;
    } else {
      return null;
    }
  }
}
