import 'package:flutter/material.dart';
import 'package:mobile_motivation/data/quote_data.dart';
import 'package:mobile_motivation/services/auth/auth_service.dart';
import 'package:mobile_motivation/services/cloud/firebase_cloud_storage.dart';

class QOTDView extends StatefulWidget {
  const QOTDView({Key? key}) : super(key: key);

  @override
  State<QOTDView> createState() => _QOTDViewState();
}

class _QOTDViewState extends State<QOTDView> {
  late final FirebaseCloudStorage _quotesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _quotesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Our main quotes page will be a Scaffold widget whose body
    // is a centered stack widget.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            titleSpacing: size.width / 5,
            backgroundColor: Colors.black,
            title: const Text(
              'Here is your daily motivation!',
              style: TextStyle(
                fontFamily: 'Courgette',
                fontSize: 22.0,
              ),
            ),
            actions: [],
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(
                    Icons.note,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                )
              ],
            )),
        body: Center(
          // The stack widget will allow for overlapping the text in front
          // of a background image asset.
          child: Stack(
            children: <Widget>[
              // First, create the centered image asset.
              Center(
                child: Image.asset(
                  'assets/images/background.jpg',
                  width: size.width,
                  height: size.height,
                  fit: BoxFit.fill,
                ),
              ),
              const Quote(),
            ],
          ),
        ),
      ),
    );
  }
}
