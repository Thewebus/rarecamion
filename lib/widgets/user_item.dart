import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:rarecamion/models/user.dart';
import 'package:http/http.dart' as http;

class UserItem extends StatefulWidget {
  final User user;
  const UserItem({Key key, this.user}) : super(key: key);

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  initState() {
    super.initState();

    _fetchToggleValue().then((value) {
      setState(() {
        _toggleValue = value;
      });
    });
  }

  bool _toggleValue = true;

  Future<bool> _fetchToggleValue() async {
    bool _toggleValue = widget.user.confirmed;

    return _toggleValue;
  }

  void _toggleUser(int _userID, bool _toggle) async {
    _toggle ? _toggle = false : _toggle = true;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    String infoFlash = '';

    String url = 'http://api.rarecamion.com/api/users/$_userID';
    String jsonReq = jsonEncode({"confirmed": "$_toggle"});

    http.Response response =
        await http.put(Uri.parse(url), headers: headers, body: jsonReq);

    if (response.statusCode != 200) {
      infoFlash =
          'Action impossible: vérifiez votre connexion et réessayer SVP !';
    } else {
      infoFlash = 'Opération effectuée avec succès !';

      setState(() {
        _toggleValue = _toggle;
      });
    }
    _showSnack(infoFlash);
  }

  void _showSnack(String message) {
    final snackbar = SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.green),
          textAlign: TextAlign.center,
        ),
        duration: Duration(milliseconds: 1500));

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () => () {},
        tileColor: Colors.blueAccent,
        title: Row(
          children: [
            Icon(
              Icons.account_box,
              color: Colors.blue,
              size: 20,
            ),
            Text('${widget.user.username}', style: TextStyle(fontSize: 16.0)),
          ],
        ),
        subtitle:
            Text('${widget.user.email}', style: TextStyle(fontSize: 12.0)),
        trailing: _toggleValue
            ? IconButton(
                iconSize: 30,
                icon: Icon(Icons.adjust),
                color: Colors.green,
                onPressed: () async {
                  if (await confirm(
                    context,
                    title: const Text('Confirmez '),
                    content: Text(
                        'Voulez-vous vraiment DÉSACTIVER l\'utilisateur ${widget.user.username} ?'),
                    textOK: const Text('Oui'),
                    textCancel: const Text('Non'),
                  )) {
                    return _toggleUser(widget.user.id, _toggleValue);
                  } else
                    return (print('pressedCancel'));
                })
            : IconButton(
                iconSize: 30,
                icon: Icon(Icons.adjust),
                color: Colors.grey[400],
                onPressed: () async {
                  if (await confirm(
                    context,
                    title: const Text('Confirmez '),
                    content: Text(
                        'Voulez-vous vraiment RE ACTIVER l\'utilisateur ${widget.user.username} ?'),
                    textOK: const Text('Oui'),
                    textCancel: const Text('Non'),
                  )) {
                    return _toggleUser(widget.user.id, _toggleValue);
                  } else
                    return (print('pressedCancel'));
                }));
  }
}
