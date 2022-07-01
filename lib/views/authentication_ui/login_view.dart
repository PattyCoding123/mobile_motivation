import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_motivation/constants/elevated_button_style.dart';
import 'package:mobile_motivation/constants/font_constants.dart';
import 'package:mobile_motivation/services/auth/authBloc/auth_bloc.dart';
import 'package:mobile_motivation/utilities/dialogs/error_dialog.dart';
import 'package:mobile_motivation/views/main_ui/custom_widgets/login_form.dart';

// The LoginView will display a view with a background image, a form
// for users to enter account information, and buttons to log in the user
// or to send them to another view that will allow them to reset their
// password or to register.
class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        // Any changes made to the AuthBloc states, including to
        // AuthStateLoggedOut, will be handled by the Bloc Listener.
        // Calling the AuthEventLogIn event will push an AuthStateLoggedOut
        // with a loading progress field either true or false depending on
        // whether the user has sucessfully logged in or not respectfully.
        if (state is AuthStateLoggedOut) {
          if (state.exception != null) {
            await showErrorDialog(
              context: context,
              title: state.exception!.dialogTitle,
              text: state.exception!.dialogText,
            );
          }
        }
      },
      child: Scaffold(
        // For the body of the Scaffold, we need to include a SingleChildScrollView
        // because there are so many text fields and buttons that we could
        // run into the issue of a overflowing render issue if we do
        // not allow the user to scroll.
        body: SingleChildScrollView(
          // Stack widget is utilized here in order to place the background
          // image behind the login forms and text buttons that the user
          // needs to interact with.
          child: Stack(
            // To align the widgets in the middle as much as possible, the
            // alignment is set to Alignment.center
            alignment: Alignment.center,
            children: <Widget>[
              // Displays the background image asset when the LoginView is built.
              Image.asset(
                'assets/images/background_3.jpg',
                width: size.width,
                height: size.height,
                fit: BoxFit.fill,
              ),
              // Displays the Text Heading and LoginForm widget all vertically
              // stacked and directly over the background image.
              Column(
                // Use MainAxisSize.min to avoid overreaching to the edges
                // of the phone/tablet screen.
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Text Heading for the LoginView
                  const Text(
                    'Log in and inspire yourself today',
                    style: TextStyle(
                      fontFamily: courgetteFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Divider between the Text Heading and the
                  // LoginForm widget
                  const SizedBox(
                    height: 30.0,
                  ),
                  // Display the contents of the LoginForm widget.
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 0.0,
                    ),
                    child: LoginForm(),
                  ),
                  // SizedBox widget that separates the Form widgets and the buttons
                  // for resetting a password or registering.
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Reset Password Button:
                  // An elevated button that initiates a BLoC event called
                  // AuthEventForgotPassword. It is also styled to fit
                  // the theming of the application.
                  ElevatedButton(
                    style: style,
                    onPressed: () {
                      // Add the AuthEventForgotPassword event so that AuthBloc
                      // sends the user to the ForgotPasswordView.
                      context.read<AuthBloc>().add(
                            const AuthEventForgotPassword(),
                          );
                    },
                    child: const Text(
                      'I forgot my password',
                      style: TextStyle(
                        fontFamily: courgetteFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Register Password Button:
                  // An elevated button that initiates a BLoC event called
                  // AuthEventForgotPassword. It is also styled to fit
                  // the theming of the application.
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    style: style,
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventShouldRegister(),
                          );
                    },
                    child: const Text(
                      'Not registered yet? Register here!',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
