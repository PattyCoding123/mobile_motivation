import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_motivation/constants/elevated_button_style.dart';
import 'package:mobile_motivation/constants/font_constants.dart';
import 'package:mobile_motivation/services/auth/bloc/auth_bloc.dart';
import 'package:mobile_motivation/utilities/dialogs/password_reset_email_sent_dialog.dart';

// The following widget will build the text fields and text buttons
// necessary for the user to input information and to send an email
// which allows them to reset their password.
class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({Key? key}) : super(key: key);

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordForm();
}

class _ResetPasswordForm extends State<ResetPasswordForm> {
  late final TextEditingController _email;

  // Initializing the ResetPasswordForm means we must initialize
  // the text editing controllers.
  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  // Dispose text editing controllers after removing the widget.
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The ResetPasswordForm will be a Form with a text field and the
    // send password reset email button. It will be built around a BLoC
    // listener to check and make sure that an email has been sent in
    // which case it will allow erase the text in the text field.
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _email.clear();
            await showPasswordResetSentDialog(context);
          }
        }
      },
      child: Card(
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header for the Form
              const Text(
                'Password Reset',
                style: TextStyle(
                  fontFamily: courgetteFamily,
                  fontSize: 30,
                ),
              ),
              // Email TextField:
              // First TextField wrapped with a Padding widget to avoid
              // the field reaching all the way to the boundary of the
              // card. Included additional parameters for the TextField
              // widget such as removing suggestings and auto correct.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    // Input Decoration includes a hint text that is
                    // styled to fit with the theme of the app.
                    hintText: 'Enter your email here',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontFamily: courgetteFamily,
                    ),
                  ),
                ),
              ),

              // Send email Button:
              // An elevated button to register the user by triggering a
              // BLoC Event called AuthEventForgotPassword. It is decorated to
              // fit the theming of the app. BlocListener will listen to the
              // changes in the state and will handle dialogs.
              ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  context.read<AuthBloc>().add(
                        AuthEventForgotPassword(
                          email: email,
                        ),
                      );
                },
                style: style,
                child: const Text(
                  'Send me the password reset link',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
