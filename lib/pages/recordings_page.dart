import 'package:flutter/material.dart';
import 'package:rarecamion/models/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
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

  void _redirectUser() {
    Future.delayed(Duration(seconds: 1), () {
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
                title: SizedBox(
                    child: state.user != null
                        ? Text(state.user.username)
                        : Text('')),
                leading: Icon(Icons.store),
                actions: [
                  Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: state.user != null
                          ? IconButton(
                              icon: Icon(Icons.exit_to_app),
                              onPressed: () => print('pressed'))
                          : Text(''))
                ]);
          }));

  @override
  Widget build(BuildContext context) {
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
                return Column(children: [
                  Expanded(
                      child: SafeArea(
                          top: false,
                          bottom: false,
                          child: GridView.builder(
                              itemCount: state.recordings.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (context, i) => RecordingItem(
                                    item: state.recordings[i],
                                  ))))
                ]);
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: _redirectUser,
        tooltip: 'Ajouter un enregistrement',
        child: Icon(Icons.add),
      ),
    );
  }
}
/*
    
*/