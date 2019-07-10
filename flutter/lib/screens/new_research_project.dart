import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:unifesspa_ciencia/services/database_rest.dart';

import 'package:unifesspa_ciencia/models/user.dart';

class NewResearchProject extends StatefulWidget {
  final User user;
  NewResearchProject(this.user);
  @override
  _NewResearchProjectState createState() => _NewResearchProjectState(this.user);
}

class _NewResearchProjectState extends State<NewResearchProject> {
  User user;
  _NewResearchProjectState(this.user);

  var _formKey = GlobalKey<FormState>();

  var _name = TextEditingController();
  var _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Projeto"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Nome',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    controller: _name,
                  ),
                  Text(
                    'Descrição',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    controller: _description,
                  ),
                  RaisedButton(
                      child: Text("Salvar"),
                      onPressed: () async {
                        var response =
                            await DatabaseREST.registerResearchProject(
                                _name.text, _description.text, this.user.id);
                        if (response['status'] == 'error') {
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Erro",
                            desc: response['message'],
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Ok",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                              )
                            ],
                          ).show();
                        } else {
                          Alert(
                            context: context,
                            type: AlertType.success,
                            title: "Sucesso",
                            desc: response['message'],
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Ok",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                              )
                            ],
                          ).show();
                        }
                      }),
                ]),
          )),
    );
  }
}
