import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_motivation/services/auth/auth_exceptions.dart';
import 'package:mobile_motivation/services/auth/bloc/auth_bloc.dart';
import 'package:mobile_motivation/services/auth/bloc/auth_event.dart';
import 'package:mobile_motivation/services/auth/bloc/auth_state.dart';
import 'package:mobile_motivation/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        // Any changes made to the AuthBloc states, including to
        // AuthStateLoggedOut, will be handled by the Bloc Listener.
        // Calling the AuthEventLogIn event will push an AuthStateLoggedOut
        // with a loading progress field either true or false depending on
        // whether the user has sucessfully logged in or not respectfully.
        if (state is AuthStateLoggedOut) {
          if (state.exception is AuthErrorUserNotFound) {
            await showErrorDialog(
              context,
              const AuthErrorUserNotFound().dialogText,
            );
          } else if (state.exception is AuthErrorWrongPassword) {
            // Generic error message to protect user's account information.
            await showErrorDialog(
              context,
              const AuthErrorWrongPassword().dialogText,
            );
          } else if (state.exception is AuthErrorUnknown) {
            await showErrorDialog(
              context,
              const AuthErrorUnknown().dialogText,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        // Column will display widgets vertically
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Please log into your account in order to interact with your notes!',
              ),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(hintText: 'Enter your email here'),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:
                    const InputDecoration(hintText: 'Enter your password here'),
              ),
              // BlocListener will listen to the changes in the state and will
              // handle dialogs if the Bloc fails to output the AuthStateLoggedIn
              // AuthState after the AuthEventLogIn has been invoked.
              TextButton(
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
                child: const Text('Log in'),
              ),
              TextButton(
                onPressed: () {
                  // Add the AuthEventForgotPassword event so that AuthBloc
                  // sends the user to the ForgotPasswordView.
                  context.read<AuthBloc>().add(
                        const AuthEventForgotPassword(),
                      );
                },
                child: const Text('I forgot my password'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: const Text('Not registered yet? Register here!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
