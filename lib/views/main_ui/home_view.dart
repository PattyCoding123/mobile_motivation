import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_motivation/constants/font_constants.dart';
import 'package:mobile_motivation/views/main_ui/show_quote_view.dart';
import 'package:mobile_motivation/enums/menu_action.dart';
import 'package:mobile_motivation/services/auth/bloc/auth_bloc.dart';
import 'package:mobile_motivation/services/cloud/cloud_quote.dart';
import 'package:mobile_motivation/utilities/dialogs/logout_dialog.dart';
import 'package:mobile_motivation/views/main_ui/quotes_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    context.read<AuthBloc>().add(const AuthEventFetchQuote());
    context.read<AuthBloc>().add(const AuthEventGetFavoriteQuotes());
    // _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quoteOfTheDay = context.watch<AuthBloc>().state.quote;

    Size size = MediaQuery.of(context).size;

    // Our main quotes page will be a Scaffold widget whose body
    // is a centered stack widget.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            titleSpacing: 0.0,
            backgroundColor: Colors.black,
            title: const Center(
              child: Text(
                'Here is your daily motivation!',
                style: TextStyle(
                  fontFamily: courgetteFamily,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              // PopupMenuBotton action that currently contains logout option
              PopupMenuButton<MenuAction>(
                // On selected deals with whataever PopupMenuItem was selected!
                onSelected: (value) async {
                  // Use a switch to deal with the PopupMenuItems!
                  switch (value) {
                    case MenuAction.logout:
                      final shouldLogout = await showLogOutDialog(context);
                      if (shouldLogout) {
                        if (!mounted) return;
                        context.read<AuthBloc>().add(const AuthEventLogOut());
                      }
                  }
                },
                // test
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem<MenuAction>(
                      value: MenuAction.logout,
                      child: Text(
                        'Log out',
                        style: TextStyle(
                          fontFamily: courgetteFamily,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ],
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(
                    Icons.description,
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
        body: TabBarView(
          children: [
            Center(
              // The stack widget will allow for overlapping the text in front
              // of a background image asset.
              child: Stack(
                children: <Widget>[
                  // First, create the centered image asset.
                  Center(
                    child: Image.asset(
                      'assets/images/background_2.jpg',
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.fill,
                    ),
                  ),
                  ShowQuoteView(
                    quoteOfTheDay: quoteOfTheDay,
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: context.watch<AuthBloc>().state.favQuotes,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      // The snapshot data for StreamBuilder contains all the quotes
                      // from the Cloud Firestore database that were placed in the
                      // stream via the allQuotes method in FirebaseCloudStorage.
                      final allQuotes = snapshot.data as Iterable<CloudQuote>;
                      // Return our NotesListView widget with allNotes as the
                      // notes parameter.
                      return QuotesListView(
                        quotes: allQuotes,
                        onDeleteQuote: (quote) async {
                          context.read<AuthBloc>().add(
                                AuthEventDeleteQuote(
                                  quote,
                                ),
                              );
                        },
                        // On onTap, pass the current note as an argument
                        // to the BuildContext of createOrUpdateNoteView
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                  default:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
