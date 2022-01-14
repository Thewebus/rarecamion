import 'package:flutter/material.dart';
import 'package:rarecamion/models/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/redux/actions.dart';
import 'package:rarecamion/widgets/recording_item.dart';

class RecordingsPage extends StatefulWidget {
  final void Function() onInit;
  RecordingsPage({this.onInit});

  @override
  RecordingsPageState createState() => RecordingsPageState();
}

class RecordingsPageState extends State<RecordingsPage> {
  void initState() {
    super.initState();
    widget.onInit();
  }

  void _redirectUserToAddVehicule() {
    Future.delayed(Duration(milliseconds: 500), () {
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
                  colors: const [Colors.lightBlueAccent, Colors.white])),
          //padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (_, state) {
                return Row(children: [
                  Expanded(
                    child: SafeArea(
                        top: false,
                        bottom: false,
                        child: ListView.separated(
                            itemCount: state.recordings.length,
                            itemBuilder: (context, i) => RecordingItem(
                                  item: state.recordings[i],
                                ),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider())),
                  )
                ]);
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: _redirectUserToAddVehicule,
        tooltip: 'Ajouter un enregistrement',
        child: Icon(Icons.add),
      ),
    );
  }
}
/*
    
*/