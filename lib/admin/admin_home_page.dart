import 'package:flutter/material.dart';
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
  void initState() {
    super.initState();
    widget.onInit();
  }

  void _redirectToUsersPage() {
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/adminUsersList');
    });
  }

  final _appBar = PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return AppBar(
                centerTitle: true,
                /*leading:
                    state.user != null ? Icon(Icons.account_box) : Text(''),*/
                title: SizedBox(
                    child: state.user != null
                        ? Text(state.user.username)
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
    // bool _isLoggedIn = true;
    return Scaffold(
      appBar: _appBar,
      body: Container(

          //padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (_, state) {
                return state.user != null
                    ? Row(children: [
                        Expanded(
                          child: SafeArea(
                              top: false,
                              bottom: false,
                              child: Center(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            print('_redirectToUsersPage');

                                            this._redirectToUsersPage();
                                          },
                                          child: Card(
                                            color: Color.fromARGB(
                                                255, 240, 40, 15),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text('UTILISATEURS',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255))),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print('onTap');
                                          },
                                          child: Card(
                                            color: Color.fromARGB(
                                                255, 240, 40, 15),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text('ENREGISTREMENTS',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255))),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ])
                    : Center(
                        child: Column(
                          children: [
                            Text(
                              'Vous êtes deconnecté(e) avec succès',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, '/login'),
                                child: Text('Aller à l\'accueil'))
                          ],
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                      );
              })),
    );
  }
}
