import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_motivation/constants/elevated_button_style.dart';
import 'package:mobile_motivation/constants/font_constants.dart';
import 'package:mobile_motivation/services/auth/auth_errors.dart';
import 'package:mobile_motivation/services/auth/bloc/auth_bloc.dart';
import 'package:mobile_motivation/utilities/dialogs/error_dialog.dart';
import 'package:mobile_motivation/views/main_ui/custom_widgets/register_form.dart';

// The RegisterView will display a view with a background image,
// a form for users to enter account information, and buttons to register
// an account with the given information. If the user does register a valid
// account, they immediately be sent to the register view page. There is
// also another button that can be pressed to return the user back to
// the LoginView.
class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      // The BLoC listener is here listen for
      // any changes made to the state of AuthStateRegistering
      // which includes finding and emitting auth errors.
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is AuthErrorUnknown) {
            await showErrorDialog(
              context: context,
              title: 'Unknown Registration Error',
              text: 'Failed to register user',
            );
          } else if (state.exception != null) {
            await showErrorDialog(
              context: context,
              title: state.exception!.dialogTitle,
              text: state.exception!.dialogText,
            );
          }
        }
      },
      child: Scaffold(
        // For the body of the Scaffold, we need to include a
        // SingleChildScrollView to avoid overflowing render issues.
        body: SingleChildScrollView(
          // Use stack widget to display Form and ElevatedButtons over
          // a background image.
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Displays the background image asset when the RegisterView
              // is built.
              Image.asset(
                'assets/images/background_3.jpg',
                width: size.width,
                height: size.height,
                fit: BoxFit.fill,
              ),
              // Displays the Text Heading and RegisterForm widget all vertically
              // stacked and directly over the background image.
              Column(
                // Use MainAxisSize.min to avoid overreaching to the edges
                // of the phone/tablet screen.
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text Heading, which is a quote from Sir Francis Bacon.
                  const Text(
                    'Knowledge is Power\n- Sir Francis Bacon',
                    style: TextStyle(
                      fontFamily: courgetteFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Divider between the Text Heading and the
                  // RegisterForm widget
                  const SizedBox(
                    height: 30.0,
                  ),
                  // Display the contents of the RegisterForm widget.
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 0.0,
                    ),
                    child: RegisterForm(),
                  ),
                  // SizedBox widget that separates the Form widgets and the buttons
                  // for going back to the LoginView.
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Go Back to LoginView Button:
                  // An elevated button that, When button is pressed,
                  // initiates a BLoC event called AuthEventLogOut which
                  // tells the user to go back to the LoginView essentially.
                  ElevatedButton(
                    style: style,
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    },
                    child: const Text(
                      'Already registered? Login here!',
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
