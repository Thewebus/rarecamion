import 'package:flutter/material.dart';
import 'package:rarecamion/engines/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/redux/actions.dart';
import 'package:rarecamion/widgets/vehicule_item.dart';

class VehiculesPage extends StatefulWidget {
  final void Function() onInit;
  VehiculesPage({this.onInit});

  @override
  RecordingsPageState createState() => RecordingsPageState();
}

class RecordingsPageState extends State<VehiculesPage> {
  void initState() {
    super.initState();
    widget.onInit();
  }

  void _redirectUserToAddVehicule() {
    Future.delayed(Duration(milliseconds: 100), () {
      Navigator.pushReplacementNamed(context, '/addvehicule');
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
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.1, 0.2],
                  colors: const [Colors.white, Colors.white])),
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
                                    Container(
                                      height: 375,
                                      child: ListView.separated(
                                        itemCount: state.vehicules.length,
                                        itemBuilder: (context, i) =>
                                            VehiculeItem(
                                          vehicule: state.vehicules[i],
                                        ),
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        )
                      ])
                    : DeconnexionWidget();
              })),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        child: Container(
          height: 50,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (_, state) {
            return state.user != null
                ? FloatingActionButton(
                    hoverColor: Colors.white,
                    backgroundColor: Colors.blue[800],
                    onPressed: _redirectUserToAddVehicule,
                    tooltip: 'Ajouter nouveau véhicule ...',
                    child: Icon(Icons.add),
                  )
                : Text('');
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
