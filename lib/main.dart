import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_motivation/services/auth/bloc/auth_bloc.dart';
import 'package:mobile_motivation/services/auth/firebase_auth_provider.dart';

void main() async {
  // Since our program will handle asynchronous tasks, we need
  // to ensure that our Widgets are binded.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // BlocProvider provides the AuthBloc instance and has a child widget
      // which is the HomePage (since the widget must return a BlocBuilder).
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          FirebaseAuthProvider(),
        ),
        child: const HomePage(),
      ),
    ),
  );
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
    return Container();
  }
}
