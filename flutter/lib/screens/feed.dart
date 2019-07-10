import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:unifesspa_ciencia/services/database_rest.dart';
import 'package:unifesspa_ciencia/screens/new_research_project.dart';
import 'package:unifesspa_ciencia/models/user.dart';

class AllProjectsTab extends StatefulWidget {
  @override
  _AllProjectsTabState createState() => _AllProjectsTabState();
}

class _AllProjectsTabState extends State<AllProjectsTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseREST.getResearchProjects(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var researchProjectsList = snapshot.data;

          return Scaffold(
              body: (ListView.builder(
            itemCount: researchProjectsList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Material(
                  borderRadius: new BorderRadius.circular(6.0),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                researchProjectsList[index]['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              new Text(
                                  researchProjectsList[index]['description']),
                              Divider() /*,
                              new Text("Orientador: "+researchProjectsList[index]['user_owner']['first_name '])*/
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class MyProjectTab extends StatefulWidget {
  final User user;
  MyProjectTab(this.user);
  @override
  _MyProjectTabState createState() => _MyProjectTabState(this.user);
}

class _MyProjectTabState extends State<MyProjectTab> {
  User user;
  _MyProjectTabState(this.user);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseREST.getMyResearchProjects(this.user.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var researchProjectsList = snapshot.data;

          return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NewResearchProject(this.user);
                  }));
                },
                child: Icon(Icons.add),
              ),
              body: (ListView.builder(
                itemCount: researchProjectsList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Material(
                      borderRadius: new BorderRadius.circular(6.0),
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    researchProjectsList[index]['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  new Text(researchProjectsList[index]
                                      ['description']),
                                  Divider() /*,
                              new Text("Orientador: "+researchProjectsList[index]['user_owner']['first_name '])*/
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class PerfilTab extends StatefulWidget {
  final User user;
  PerfilTab(this.user);
  @override
  _PerfilTabState createState() => _PerfilTabState(this.user);
}

class _PerfilTabState extends State<PerfilTab> {
  final User user;
  _PerfilTabState(this.user);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FeedPage extends StatefulWidget {
  final User user;
  FeedPage(this.user);
  @override
  _FeedPageState createState() => _FeedPageState(this.user);
}

class _FeedPageState extends State<FeedPage> {
  final User user;
  _FeedPageState(this.user);
  int _currentTabValue = 0;
  List<Widget> _tabsBottomWidgets;

  @override
  void initState() {
    super.initState();
    _tabsBottomWidgets = [
      new AllProjectsTab(),
      new MyProjectTab(this.user),
      new PerfilTab(this.user)
    ];
  }

  void _changeTab(value) {
    setState(() {
      _currentTabValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: <Widget>[Icon(Icons.help)],
          title: Text("Universidade Ciência"),
          centerTitle: true),
      body: _tabsBottomWidgets[_currentTabValue],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35,
        selectedFontSize: 17,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.fileSearchOutline),
            title: Text('Navegar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.accountCardDetailsOutline),
            title: Text('Meus Projetos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Perfil'),
          )
        ],
        currentIndex: _currentTabValue,
        onTap: _changeTab,
      ),
    );
  }
}
