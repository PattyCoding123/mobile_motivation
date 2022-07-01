import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile_motivation/models/quote_model.dart';
import 'package:mobile_motivation/services/api/api_exception.dart';
import 'package:mobile_motivation/services/api/api_provider.dart';
import 'package:mobile_motivation/services/auth/auth_errors.dart';
import 'package:mobile_motivation/services/auth/auth_provider.dart';
import 'package:mobile_motivation/services/auth/auth_user.dart';
import 'package:mobile_motivation/services/cloud/cloud_quote.dart';
import 'package:mobile_motivation/services/cloud/cloud_storage_exceptions.dart';
import 'package:mobile_motivation/services/cloud/firebase_cloud_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

// AuthBloc handles AuthEvents and what states should be emitted from
// certain AuthEvents. Each on<Event> is defined for each AuthEvent.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    // Should register event
    on<AuthEventShouldRegister>(
      (
        event,
        emit,
      ) {
        emit(
          const AuthStateRegistering(
            exception: null,
            isLoading: false,
          ),
        );
      },
    );

    // Forgot password event
    on<AuthEventForgotPassword>(
      (event, emit) async {
        // Initial state of AuthStateForgotPassword where user is idling
        // in the ForgotPasswordView.
        emit(
          const AuthStateForgotPassword(
            exception: null,
            hasSentEmail: false,
            isLoading: false,
          ),
        );

        final email = event.email;
        if (email == null) {
          return; // The user just wanted to go to the forgot-password screen.
        }

        // The user wants to actually send a forgot-password email.
        // Begin the loading screen.
        emit(
          const AuthStateForgotPassword(
            exception: null,
            hasSentEmail: false,
            isLoading: true,
          ),
        );

        // Try sending an email, we will emit either a success or failure
        // state depending on whether a password reset email was sent.
        bool didSendEmail;
        Exception? exception;
        try {
          await provider.sendPasswordReset(toEmail: email);
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          didSendEmail = false;
          exception = e;

          // Emit state with an error if password reset email failed to send.
          emit(
            AuthStateForgotPassword(
              exception: AuthError.fromFirebase(exception),
              hasSentEmail: didSendEmail,
              isLoading: false,
            ),
          );
        }

        // End the loading screen.
        emit(
          AuthStateForgotPassword(
            exception: null,
            hasSentEmail: didSendEmail,
            isLoading: false,
          ),
        );
      },
    );

    // Send email verification event
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        // Stay on whatever state we are at during the sendEmailVerification
        // event, which should be the AuthStateNeedsVerification state.
        emit(state);
      },
    );

    // Register event
    on<AuthEventRegister>(
      (
        event,
        emit,
      ) async {
        // Gather the email and password information from the event.
        final email = event.email;
        final password = event.password;

        // Try and create a new firebase user, and if done succesfully,
        // send an email verification to their email address.
        // Handle registration exception by emitting the Registering state
        // with an error from AuthError (FirebaseAuthExceptions)
        try {
          await provider.createUser(
            email: email,
            password: password,
          );
          await provider.sendEmailVerification();
          emit(
            const AuthStateNeedsVerification(
              isLoading: false,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateRegistering(
              exception: AuthError.fromFirebase(e),
              isLoading: false,
            ),
          );
        }
      },
    );

    // Initialize event
    on<AuthEventInitialize>(
      (
        event,
        emit,
      ) async {
        // Initialize the Firebase provider for the specified application
        // and device, and try to acquire the current user.
        await provider.initialize();
        final user = provider.currentUser;

        // Emit the AuthStateLoggedOut state if the user variable is null.
        if (user == null) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } else if (!user.isEmailVerified) {
          // Emit the AuthStateNeedsVerification state if the authenticated user
          // that is currently logged in with Firebase has still
          // not verified their account.
          emit(
            const AuthStateNeedsVerification(
              isLoading: false,
            ),
          );
        } else {
          // If the user is not null and verified, then retrieve
          // data from the API and Firestore database.

          // Get favorite quotes from firestore database
          final favQuotes = FirebaseCloudStorage().allQuotes(
            ownerUserId: user.id,
          );

          // Implement a try block in the case that we fail to retrieve data
          // from the API.
          try {
            // Get quote from the API!
            final quoteOfTheDay = await ApiProvider().fetchQuote();

            // Emit the AuthStateLoggedIn state with the quote of the day
            // and the user's favorite quotes.
            emit(
              AuthStateLoggedIn(
                user: user,
                isLoading: false,
                quote: quoteOfTheDay,
                favQuotes: favQuotes,
              ),
            );
          } on NetworkErrorAuthException catch (e) {
            // If there was an error with retrieving data from the API, emit
            // the AuthStateLoggedIn state but with only the user's favorite quotes.
            emit(
              AuthStateLoggedIn(
                user: user,
                isLoading: false,
                exception: e,
                quote: state.quote,
                favQuotes: favQuotes,
              ),
            );
          }
        }
      },
    );

    // Log in event
    on<AuthEventLogIn>(
      (
        event,
        emit,
      ) async {
        // Enable Loading screen to show that the authentication service
        // is trying to log in the user.
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
            loadingText: 'Please wait while we log you in...',
          ),
        );
        // AuthEventLogIn has an email and password member which we
        // will use to try and log in with the authentication service.
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(
            email: email,
            password: password,
          );
          if (!user.isEmailVerified) {
            // If user is not verified, then the AuthBloc will emit the
            // AuthStateLoggedOut state without any exception and no loading
            // indication which disables the loading screen, and then
            // it will emit the AuthStateNeedsVerification state.
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(
              const AuthStateNeedsVerification(
                isLoading: false,
              ),
            );
          } else {
            // If the user is verified, then the AuthBloc will emit
            // the AuthStateLoggedOut state with no exception or loading
            // indication which disables the loading screen, and then
            // it will emit the AuthStateLoggedIn state with the quote
            // from the API and the favorited quotes in Firestore database.
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );

            // Get favorite quotes from firestore database
            final favQuotes = FirebaseCloudStorage().allQuotes(
              ownerUserId: user.id,
            );

            // Nested try-catch block for getting the quote from
            // the API which might throw an exception in the case
            // we fail to retrieve data from the API!
            try {
              // Get quote from the API!
              final quoteOfTheDay = await ApiProvider().fetchQuote();

              // Emit the AuthStateLoggedIn state with the user's favorite
              // quotes and the quote of the day.
              emit(
                AuthStateLoggedIn(
                  user: user,
                  isLoading: false,
                  quote: quoteOfTheDay,
                  favQuotes: favQuotes,
                ),
              );
            } on NetworkErrorAuthException catch (e) {
              // If there was an error retrieving the quote from the API,
              // emit the AuthStateLoggedIn state with an exception
              // and only the user's favorite quotes.
              emit(
                AuthStateLoggedIn(
                  user: user,
                  isLoading: false,
                  exception: e,
                  quote: state.quote,
                  favQuotes: favQuotes,
                ),
              );
            }
          }
        } on Exception catch (e) {
          // On an exception, emit the AuthStateLoggedOut state
          // with no exception or loading indication.
          emit(
            AuthStateLoggedOut(
              exception: AuthError.fromFirebase(e),
              isLoading: false,
            ),
          );
        }
      },
    );

    // Log out event
    on<AuthEventLogOut>(
      (
        event,
        emit,
      ) async {
        try {
          // If user logs out successfully, emit the AuthStateLoggedOut state
          // with no exception and loading indicator as false.
          await provider.logOut();
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } on Exception catch (e) {
          // If user cannot log out, emit the AuthStateLoggedOut state with
          // an exception and loading indicator as false.
          emit(
            AuthStateLoggedOut(
              exception: AuthError.fromFirebase(e),
              isLoading: false,
            ),
          );
        }
      },
    );

    // [Note: No longer using for now]
    // Generate quote event. Only done if the user is logged in!
    // on<AuthEventFetchQuote>(
    //   (
    //     event,
    //     emit,
    //   ) async {
    //     final user = provider.currentUser;

    //     if (user == null) {
    //       emit(
    //         const AuthStateLoggedOut(exception: null, isLoading: false),
    //       );
    //     }

    //     try {
    //       emit(
    //         AuthStateLoggedIn(
    //           user: user!,
    //           quote: state.quote,
    //           favQuotes: state.favQuotes,
    //           isLoading: true,
    //         ),
    //       );

    //       final quoteOfTheDay = await ApiProvider().fetchQuote();

    //       emit(
    //         AuthStateLoggedIn(
    //           user: user,
    //           isLoading: false,
    //           quote: quoteOfTheDay,
    //           favQuotes: state.favQuotes,
    //         ),
    //       );
    //     } on NetworkErrorAuthException catch (e) {
    //       emit(
    //         AuthStateLoggedIn(
    //           user: user!,
    //           isLoading: false,
    //           exception: e,
    //           quote: state.quote,
    //           favQuotes: state.favQuotes,
    //         ),
    //       );
    //     }
    //   },
    // );

    // [Note: No longer using for now]
    // Handle retrieving notes from Cloud Firestore!
    // on<AuthEventGetFavoriteQuotes>(
    //   (
    //     event,
    //     emit,
    //   ) {
    //     final user = provider.currentUser;

    //     if (user == null) {
    //       emit(
    //         const AuthStateLoggedOut(
    //           exception: null,
    //           isLoading: false,
    //         ),
    //       );
    //     }

    //     emit(
    //       AuthStateLoggedIn(
    //         user: user,
    //         isLoading: false,
    //         quote: state.quote,
    //         favQuotes: favQuotes,
    //       ),
    //     );
    //   },
    // );

    // Handle favoriting a quote
    on<AuthEventAddFavoriteQuote>(
      (
        event,
        emit,
      ) async {
        final user = provider.currentUser;

        // If the current user is null, then immediately log out the user.
        if (user == null) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } else {
          // Since the favorite feature is only accessible for verified
          // users, we do not need to check the verification state. Instead,
          // call the createNewQuote method from our FirebaseCloudStorage
          // services class.
          await FirebaseCloudStorage().createNewQuote(
            ownerUserId: user.id,
            quote: event.quote,
          );

          // Emit the AuthStateLoggedIn state will all the current state data.
          emit(
            AuthStateLoggedIn(
              user: user,
              isLoading: false,
              quote: state.quote,
              favQuotes: state.favQuotes,
            ),
          );
        }
      },
    );

    // Handle deleting a quote.
    on<AuthEventDeleteQuote>(
      (event, emit) {
        final user = provider.currentUser;
        // If the current user is null, then immediately log out the user.
        if (user == null) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        }
        // Since the delete feature is only accessible for verified
        // users, we do not need to check the verification state. Instead,
        // call the deleteQuote method from our FirebaseCloudStorage
        // services class. It is in a try block because we could run into the
        // Firestore exception of failing to delete a quote.
        try {
          FirebaseCloudStorage().deleteQuote(
            documentId: event.favCloudQuote.documentId,
          );

          emit(
            AuthStateLoggedIn(
                user: user!,
                isLoading: false,
                quote: state.quote,
                favQuotes: state.favQuotes),
          );
        } on CloudStorageException catch (e) {
          // If an exception is thrown, just emit the AuthStateLoggedIn state
          // with all the state data and an exception.
          emit(
            AuthStateLoggedIn(
              user: user!,
              isLoading: false,
              quote: state.quote,
              favQuotes: state.favQuotes,
              exception: e,
            ),
          );
        }
      },
    );
  }
}
