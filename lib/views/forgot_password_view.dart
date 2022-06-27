import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_motivation/constants/font_constants.dart';
import 'package:mobile_motivation/services/auth/bloc/auth_bloc.dart';
import 'package:mobile_motivation/utilities/dialogs/error_dialog.dart';
import 'package:mobile_motivation/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          } else if (state.exception != null) {
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'If you forgot your password, simply enter your email and press the button so that we can send you an email to reset your password',
                    style: TextStyle(
                      fontFamily: courgetteFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autofocus: true,
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Your email address...',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final email = _controller.text;

                      // Add AuthEventForgotPassword event with an email
                      // which will trigger a loading screen while the AuthBloc
                      // tells Firebase to send a reset password email.
                      context.read<AuthBloc>().add(
                            AuthEventForgotPassword(email: email),
                          );
                    },
                    child: const Text('Send me a password reset link'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add AuthEventLogOut event to go back to the login screen.
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    },
                    child: const Text('Back to login page'),
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
