import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_motivation/constants/elevated_button_style.dart';
import 'package:mobile_motivation/constants/font_constants.dart';
import 'package:mobile_motivation/services/auth/bloc/auth_bloc.dart';
import 'package:mobile_motivation/utilities/dialogs/error_dialog.dart';
import 'package:mobile_motivation/views/main_ui/custom_widgets/reset_password_form.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.exception != null) {
            // Generic error message to help protect user's account information.
            await showErrorDialog(
              context: context,
              title: 'Password Reset Error',
              text:
                  'We could not process your request. Please make sure that you are a registered user. If not, please register an account.',
            );
          }
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
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
                  // Text Heading, which is a quote from Sir Francis Bacon.
                  const Text(
                    'Reset your password ...',
                    style: TextStyle(
                      fontFamily: courgetteFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Divider between the Text Heading and the
                  // ResetPasswordForm widget
                  const SizedBox(
                    height: 30.0,
                  ),
                  // Display the contents of the RegisterForm widget.
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 0.0,
                    ),
                    child: ResetPasswordForm(),
                  ),
                  // Divider between the ResetPasswordForm and the
                  // Send back to login screen button.
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    style: style,
                    onPressed: () {
                      // Add AuthEventLogOut event to go back to the login screen.
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    },
                    child: const Text(
                      'Back to login page',
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
