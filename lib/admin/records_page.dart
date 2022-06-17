import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/engines/app_state.dart';
import 'package:rarecamion/widgets/vehicule_item.dart';
import 'package:search_page/search_page.dart';

class RecordingsPage extends StatefulWidget {
  RecordingsPage({Key key}) : super(key: key);

  @override
  State<RecordingsPage> createState() => _RecordingsPageState();
}

class _RecordingsPageState extends State<RecordingsPage> {
  //
  static List<Person> people = [
    Person('Mike', 'Barron', 64),
    Person('Todd', 'Black', 30),
    Person('Ahmad', 'Edwards', 55),
    Person('Anthony', 'Johnson', 67),
    Person('Annette', 'Brooks', 39),
  ];
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.1, 0.2],
                  colors: const [Colors.lightBlueAccent, Colors.white])),
          child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (_, state) {
                print(state.vehiculesAll);
                return state.vehiculesAll == null
                    ? Center(
                        child: Text('Vérifiez votre connexion !'),
                      )
                    : Row(children: [
                        Expanded(
                          child: SafeArea(
                              top: false,
                              bottom: false,
                              child: ListView.separated(
                                itemCount: state.vehiculesAll.length,
                                itemBuilder: (context, i) => VehiculeItem(
                                  vehicule: state.vehiculesAll[i],
                                ),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                              )),
                        )
                      ]);
              })),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Taper votre recherche ...',
        onPressed: () => showSearch(
          context: context,
          delegate: SearchPage<Person>(
            onQueryUpdate: (s) => print(s),
            items: people,
            searchLabel: 'Search people',
            suggestion: Center(
              child: Text('Rechercher par fournisseur, lieu ou date.'),
            ),
            failure: Center(
              child: Text('No person found :('),
            ),
            filter: (person) => [
              person.name,
              person.surname,
              person.age.toString(),
            ],
            builder: (person) => ListTile(
              title: Text(person.name),
              subtitle: Text(person.surname),
              trailing: Text('${person.age} yo'),
            ),
          ),
        ),
        child: Icon(Icons.search),
      ),
    );
  }
}

class Person {
  final String name, surname;
  final num age;

  Person(this.name, this.surname, this.age);
}
