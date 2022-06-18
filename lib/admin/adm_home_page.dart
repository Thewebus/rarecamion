import 'package:flutter/material.dart';
import 'package:rarecamion/admin/adm_fournisseurs_page.dart';
import 'package:rarecamion/admin/adm_vehicules_page.dart';
import 'package:rarecamion/admin/adm_agents_page.dart';
import 'package:rarecamion/engines/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/redux/actions.dart';

class AdminHomePage extends StatefulWidget {
  final void Function() onInit;
  AdminHomePage({this.onInit});

  @override
  AdminHomePageState createState() => AdminHomePageState();
}

class AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;
  List _screens = [UsersList(), FournisseursPage(), RecordingsPage()];

  void initState() {
    super.initState();
    widget.onInit();
  }

  final _appBar = PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                /*leading:
                    state.user != null ? Icon(Icons.account_box) : Text(''),*/
                title: SizedBox(
                    child: state.user != null
                        ? Text(
                            state.user.username,
                          )
                        : Text('')),
                actions: [
                  Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: StoreConnector<AppState, VoidCallback>(
                          converter: (store) {
                        return () => store.dispatch(logoutUserAction);
                      }, builder: (_, callback) {
                        return state.user != null
                            ? IconButton(
                                icon: Icon(Icons.exit_to_app),
                                onPressed: callback)
                            : Text('');
                      }))
                ]);
          }));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar,
      body: Container(
          // width: 400,
          padding: const EdgeInsets.all(1),
          child: _screens[_currentIndex]),
      bottomNavigationBar: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (_, state) {
            return state.user != null
                ? NavigationBar(
                    destinations: const [
                      NavigationDestination(
                          icon: Icon(Icons.account_circle), label: 'Agents'),
                      NavigationDestination(
                          icon: Icon(Icons.handshake), label: 'Fournisseurs'),
                      NavigationDestination(
                          icon: Icon(Icons.search), label: 'Recherche'),
                    ],
                    onDestinationSelected: (int index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    selectedIndex: _currentIndex,
                  )
                : DeconnexionWidget();
          }),
    );
  }
}

class DeconnexionWidget extends StatelessWidget {
  const DeconnexionWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Vous êtes deconnecté(e) avec succès',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(height: 10),
          ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: Text('Aller à l\'accueil'))
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }
}
