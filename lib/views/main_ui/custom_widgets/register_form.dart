import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_motivation/constants/elevated_button_style.dart';
import 'package:mobile_motivation/constants/font_constants.dart';
import 'package:mobile_motivation/services/auth/bloc/auth_bloc.dart';

// The following widget will build the text fields and text buttons
// necessary for the user to input information and to register.
class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  // Initializing the RegisterForm means we must initialize
  // the text editing controllers.
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  // Dispose text editing controllers after removing the widget.
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The RegisterForm will be a Form with text fields and the register button
    return Card(
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header for the Form
            const Text(
              'Register',
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
            // Password TextField:
            // Second TextField wrapped with a Padding Widget. Features
            // almost all suggestions from the Email TextField with
            // an added feature of obscuring the text for security reasons.
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Enter your password here',
                  hintStyle: TextStyle(
                    fontSize: 20.0,
                    fontFamily: courgetteFamily,
                  ),
                ),
              ),
            ),
            // Register Button:
            // An elevated button to register the user by triggering a
            // BLoC Event called AuthEventRegister. It is decorated to
            // fit the theming of the app. BlocListener will listen to the
            // changes in the state and will handle dialogs.
            ElevatedButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(
                      AuthEventRegister(
                        email,
                        password,
                      ),
                    );
              },
              style: style,
              child: const Text(
                'Register',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
