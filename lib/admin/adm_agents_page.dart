import 'package:flutter/material.dart';
import 'package:rarecamion/engines/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/widgets/user_item.dart';

class UsersList extends StatefulWidget {
  UsersList();

  @override
  UsersListState createState() => UsersListState();
}

class UsersListState extends State<UsersList> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bool _isLoggedIn = true;
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.1, 0.2],
                  colors: const [Colors.lightBlueAccent, Colors.white])),
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
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Text('AGENTS',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1),
                                    SizedBox(height: 20),
                                    Container(
                                      height: 430,
                                      child: ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: state.usersList.length,
                                          itemBuilder: (context, i) => UserItem(
                                                user: state.usersList[i],
                                              ),
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const Divider()),
                                    ),
                                  ],
                                ),
                              )),
                        )
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
