import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:unifesspa_ciencia/services/database_rest.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  var _formKey = GlobalKey<FormState>();

  var _first_name = TextEditingController();
  var _last_name = TextEditingController();
  var _email = TextEditingController();
  var _password = TextEditingController();
  var _phone = TextEditingController();
  var _university_registration = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faça seu Registro"),
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
                    'Primeiro Nome',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    controller: _first_name,
                  ),
                  Text(
                    'Sobrenome',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    controller: _last_name,
                  ),
                  Text(
                    'email',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    controller: _email,
                  ),
                  Text(
                    'senha',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    controller: _password,
                  ),
                  Text(
                    'Telefone',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    controller: _phone,
                  ),
                  Text(
                    'Matrícula',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  TextFormField(
                    controller: _university_registration,
                  ),
                  RaisedButton(
                      child: Text("Salvar"),
                      onPressed: () async {
                        var response = await DatabaseREST.registerUser(
                            _first_name.text,
                            _last_name.text,
                            _email.text,
                            _password.text,
                            _phone.text,
                            _university_registration.text);
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
