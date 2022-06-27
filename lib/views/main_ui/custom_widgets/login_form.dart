import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_motivation/constants/elevated_button_style.dart';
import 'package:mobile_motivation/constants/font_constants.dart';
import 'package:mobile_motivation/services/auth/bloc/auth_bloc.dart';

// The following widget will build the text fields and text buttons
// necessary for the user to input information and to log in.
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  // Initializing the LoginForm means we must initialize
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
    // The LoginForm will be a Form with text fields and the login button
    return Card(
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header for the Form
            const Text(
              'Sign In',
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
            // Login Button:
            // An elevated button to login the user by triggering a
            // BLoC Event called AuthEventLogIn. It is decorated to
            // fit the theming of the app. BlocListener will listen to the
            // changes in the state and will handle dialogs if the Bloc
            // fails to output the AuthStateLoggedIn AuthState after the
            // AuthEventLogIn has been invoked.
            ElevatedButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(
                      AuthEventLogIn(
                        email,
                        password,
                      ),
                    );
              },
              style: style,
              child: const Text(
                'Log in',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
