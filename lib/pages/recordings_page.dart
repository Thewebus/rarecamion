import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/models/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          // return Text(json.encode(state.user));

          return Scaffold(
              appBar: AppBar(
                title: Text('RARE CAMION'),
              ),
              body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [
                        0.1,
                        0.2
                      ],
                          colors: const [
                        Colors.lightBlueAccent,
                        Colors.white
                      ])),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                      child: SingleChildScrollView(
                    child: Text(json.encode(state.user)),
                  ))));
        });
/*
    return Scaffold(
        appBar: AppBar(
          title: Text('RARE CAMION'),
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.1, 0.2],
                    colors: const [Colors.lightBlueAccent, Colors.white])),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
                child: SingleChildScrollView(
              child: Text('Recordings Page'),
            ))));
*/
  }
}
