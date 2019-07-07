import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(UniversityApp());

class DatabaseREST {
  static String host = "http://192.168.1.69:2020";
  static registerUser(String first_name, String last_name, String email,
      String password, String phone, String university_registration) async {
    var response =
        await http.post(Uri.encodeFull("http://192.168.1.69:2020/register/user"),
            body: json.encode({
              "first_name": first_name,
              "last_name": last_name,
              "email": email,
              "password": password,
              "phone": phone,
              "university_registration": university_registration,
            }),
            headers: {
          "content-type": "application/json",
          "accept": "application/json",
        });

    return json.decode(response.body);
  }

  static loginUser(String email, String password) async {
    var response =
        await http.post(Uri.encodeFull("http://192.168.1.69:2020/login/user"),
            body: json.encode({
              "email": email,
              "password": password,
            }),
            headers: {
          "content-type": "application/json",
          "accept": "application/json",
        });
    try {
      var body = json.decode(response.body);
      return body;
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }
}

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formKey = GlobalKey<FormState>();

  var _email = TextEditingController();
  var _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
            Center(
                child: Text(
              "Login",
              style: TextStyle(fontSize: 20),
            )),
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
              obscureText: true,
              keyboardType: TextInputType.text,
              controller: _password,
            ),
            RaisedButton(
                child: Text("Entrar"),
                onPressed: () async {
                  var response =
                      await DatabaseREST.loginUser(_email.text, _password.text);
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
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
                  } else {
                     Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FeedPage();
                  }));
                  }
                }),
            RaisedButton(
                child: Text("Registrar"),
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RegistrationPage();
                  }));
                })
          ]),
        ));
  }
}

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

class UniversityApp extends StatefulWidget {
  @override
  _UniversityAppState createState() => _UniversityAppState();
}

class _UniversityAppState extends State<UniversityApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("FACEEL Ciência"),
          centerTitle: true,
        ),
        body: LoginPage(),
      ),
    );
  }
}
