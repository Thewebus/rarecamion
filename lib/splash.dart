import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  Splash();

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
  }

  Widget _navigatetohome() {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
      child: Column(children: [
        Text(
          'RARECAMION',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        _navigatetohome()
      ]),
    )));
  }
}
