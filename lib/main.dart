import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_motivation/constants/routes.dart';
import 'package:mobile_motivation/helpers/loading/loading_screen.dart';
import 'package:mobile_motivation/models/preferences.dart';
import 'package:mobile_motivation/services/auth/authBloc/auth_bloc.dart';
import 'package:mobile_motivation/services/auth/firebase_auth_provider.dart';
import 'package:mobile_motivation/services/system/cubit/preferences_cubit.dart';
import 'package:mobile_motivation/services/system/preferences_service.dart';
import 'package:mobile_motivation/views/forgot_password_view.dart';
import 'package:mobile_motivation/views/login_view.dart';
import 'package:mobile_motivation/views/main_ui/home_view.dart';
import 'package:mobile_motivation/views/main_ui/settings_view.dart';
import 'package:mobile_motivation/views/register_view.dart';
import 'package:mobile_motivation/views/verify_email_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Since our program will handle asynchronous tasks, we need
  // to ensure that our Widgets are binded.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  Future<PreferencesCubit> buildBloc() async {
    final prefs = await SharedPreferences.getInstance();
    final service = MyPreferencesService(
      prefs,
    );

    return PreferencesCubit(
      service,
      service.get(),
    );
  }

  const MainApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PreferencesCubit>(
      future: buildBloc(),
      builder: (context, blocSnapshot) {
        if (blocSnapshot.hasData && blocSnapshot.data != null) {
          return BlocProvider(
            create: (_) => blocSnapshot.data!,
            child: BlocBuilder<PreferencesCubit, Preferences>(
              builder: (context, preferences) => MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                themeMode: preferences.themeMode,
                // BlocProvider provides the AuthBloc instance and has a child widget
                // which is the HomePage (since the widget must return a BlocBuilder).
                home: BlocProvider<AuthBloc>(
                  create: (context) => AuthBloc(
                    FirebaseAuthProvider(),
                  ),
                  child: const HomePage(),
                ),
                routes: {settingsRoute: (context) => const SettingsPage()},
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// HomePage will take whatever states are being produced by our AuthBloc
// and will go to the various views are associated with those states.
// HomePage will listen to any state changes of AuthBloc thoroughout
// the entire application as it uses a BlocBuilder.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // [add] indicates the event we are trying to push.
    // AuthBloc will emit a state for the depending on
    // the context of the application.

    // First, call the AuthEventInitialize
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment...',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const HomeView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
