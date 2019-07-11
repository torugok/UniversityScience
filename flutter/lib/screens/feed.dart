import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:unifesspa_ciencia/screens/login.dart';
import 'package:unifesspa_ciencia/services/database_rest.dart';
import 'package:unifesspa_ciencia/screens/new_research_project.dart';
import 'package:unifesspa_ciencia/models/user.dart';

class AllProjectsTab extends StatefulWidget {
  AllProjectsTab(this.user);
  final User user;
  @override
  _AllProjectsTabState createState() => _AllProjectsTabState(this.user);
}

class _AllProjectsTabState extends State<AllProjectsTab> {
  final User user;
  _AllProjectsTabState(this.user);
  Widget solicitarIf(usuarioInserido,
      {int userId = 0, int researchProjectId = 0}) {
    if (!usuarioInserido) {
      return RaisedButton(
        child: Text(
          "Solitar Participação",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.green,
        onPressed: () {
          DatabaseREST.requestParticiparPesquisa(userId, researchProjectId);
          setState(() {
            usuarioInserido = true;
          });
        },
      );
    } else
      return Container();
  }

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
              bool usuarioInserido = false;
              String usersInResearch = '';
              for (var item in researchProjectsList[index]
                  ['users_in_research']) {
                usersInResearch += item['first_name'] + " ; ";
                if (item['user_id'] == this.user.id &&
                        (item['status'] == 'APROVADO' ||
                    item['status'] == 'ADMINISTRADOR')) {
                  usuarioInserido = true;
                }
              }

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
                              Divider(),
                              new Text(
                                  researchProjectsList[index]['description']),
                              Divider(),
                              new Text(
                                "Participantes: " + usersInResearch,
                                style: TextStyle(fontSize: 15),
                              ),
                              Divider(),
                              solicitarIf(usuarioInserido,
                                  userId: this.user.id,
                                  researchProjectId: researchProjectsList[index]
                                      ['id'])
                              /*,
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
                  String usersInResearch = '';
                  for (var item in researchProjectsList[index]
                      ['users_in_research']) {
                    usersInResearch += item['first_name'] + " ; ";
                  }
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
                                  Divider(),
                                  new Text(researchProjectsList[index]
                                      ['description']),
                                  Divider(),
                                  new Text(
                                    "Participantes: " + usersInResearch,
                                    style: TextStyle(fontSize: 15),
                                  ), /*,
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
    return FutureBuilder(
      future: DatabaseREST.getUsersWaitingProjects(this.user.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var usersWaitingList = snapshot.data;
          return Scaffold(
            body: ListView.builder(
              itemCount: usersWaitingList.length,
              itemBuilder: (context, index) {
                return Card(
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    elevation: 8.0,
                    color: Colors.white,
                    child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        title: Text(
                          usersWaitingList[index]['user_first_name'],
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          usersWaitingList[index]['research_project_name'],
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                return showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Tem certeza disso?'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                                'Tem certeza que o "${usersWaitingList[index]['research_project_name']}" não será recusado no projeto de pesquisa?'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(
                                            'Excluir',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            //categoria.deleta();
                                            DatabaseREST.setStatusUser(
                                                usersWaitingList[index]
                                                    ['id_to_update'],
                                                usersWaitingList[index]
                                                    ['user_id'],
                                                "RECUSADO");
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.clear, color: Colors.red),
                            ),
                            IconButton(
                              onPressed: () {
                                DatabaseREST.setStatusUser(
                                    usersWaitingList[index]['id_to_update'],
                                    usersWaitingList[index]['user_id'],
                                    "APROVADO");
                                /*Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CategoriaCreateUpdaterWidget(
                                      categoria);
                                }));*/
                              },
                              icon:
                                  Icon(Icons.done_outline, color: Colors.green),
                            )
                          ],
                        )));
              },
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
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
      new AllProjectsTab(this.user),
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
      appBar: AppBar(actions: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text("FACEEL Ciência"),
                  centerTitle: true,
                ),
                body: LoginPage(),
              );
            }));
          },
        ),
        Icon(Icons.help)
      ], title: Text("Universidade Ciência"), centerTitle: true),
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
