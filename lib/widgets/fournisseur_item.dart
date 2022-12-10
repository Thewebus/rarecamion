import 'package:flutter/material.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:rarecamion/models/fournisseur.dart';
import 'package:http/http.dart' as http;

class FournisseursItem extends StatefulWidget {
  final Fournisseur fournisseur;
  final int fIndex;
  const FournisseursItem({Key key, this.fournisseur, this.fIndex})
      : super(key: key);

  @override
  State<FournisseursItem> createState() => _FournisseursItemState();
}

class _FournisseursItemState extends State<FournisseursItem> {
  @override
  initState() {
    super.initState();
  }

  void _deleteFournisseur(int _fID) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    String infoFlash = '';
    String url = 'http://api.rarecamion.com/api/fournisseurs/$_fID';

    http.Response response =
        await http.delete(Uri.parse(url), headers: headers);

    if (response.statusCode != 200) {
      infoFlash = 'Impossible de supprimer le fournisseur !';
    } else {
      infoFlash = 'Suppression effectuée avec succès !';
    }
    _showSnack(infoFlash);
    // setState(() => null);
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
              Icons.handshake_outlined,
              color: Colors.blue,
              size: 30,
            ),
            Text('${widget.fournisseur.attributes.nomFournisseur}',
                style: TextStyle(fontSize: 14.0)),
          ],
        ),
        subtitle: Text(''),
        trailing: IconButton(
            iconSize: 25,
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: () async {
              if (await confirm(
                context,
                title: const Text('Confirmez '),
                content: Text(
                    'Voulez-vous vraiment SUPPRIMER ${widget.fournisseur.attributes.nomFournisseur} ?'),
                textOK: const Text('Oui'),
                textCancel: const Text('Non'),
              )) {
                return _deleteFournisseur(widget.fournisseur.id);
              } else
                return (print('pressedCancel'));
            }));
  }
}
