import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_motivation/constants/elevated_button_style.dart';
import 'package:mobile_motivation/constants/font_constants.dart';
import 'package:mobile_motivation/services/auth/bloc/auth_bloc.dart';

// The following view is responsible for displaying a message to the user
// that they must continue by verifying their account. This will pop
// up right after a user successfully registers an account, or they logged
// into an unverified account.
class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // To avoid overflowing render issues, we will use a SingleChildScrollView
      // widget.
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Displays the background image asset when the View is built.
            Image.asset(
              'assets/images/background_3.jpg',
              width: size.width,
              height: size.height,
              fit: BoxFit.fill,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // The two Text widgets display messages regarding
                // verification. They are both wrapped around padding to
                // prevent them from overreaching to the ends of the screens
                // horizontally.
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "We've sent you an email verification. Please open it to verify your account.",
                    style: TextStyle(
                      fontFamily: courgetteFamily,
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "If you haven't received a verification email yet, press the button below",
                    style: TextStyle(
                      fontFamily: courgetteFamily,
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Send email verification button:
                // An elevated button that will initiate a BLoC event
                // called AuthEventSendEmailVerification. It is also
                // styled to fit the theming of the map.
                ElevatedButton(
                  style: style,
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventSendEmailVerification(),
                        );
                  },
                  child: const Text(
                    'Send email verification',
                  ),
                ),
                // SizedBox widget to create some space between the
                // two elevated buttons.
                const SizedBox(
                  height: 10.0,
                ),
                // Go back to login screen button:
                // Another elevated button that will initiate a BLoC event
                // called AuthEventLogOut which essentially returns the user
                // back to the login screen. It is also styled to fit the
                // theming of the app.
                ElevatedButton(
                  style: style,
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  },
                  child: const Text(
                    'Go back to login screen',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
