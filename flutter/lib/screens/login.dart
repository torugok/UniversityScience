import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:unifesspa_ciencia/services/database_rest.dart';
import 'package:unifesspa_ciencia/screens/feed.dart';
import 'package:unifesspa_ciencia/screens/registration.dart';

import 'package:unifesspa_ciencia/models/user.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formKey = GlobalKey<FormState>();

  var _server = TextEditingController();

  var _email = TextEditingController();
  var _password = TextEditingController();

  SharedPreferences prefs;
  void ipPersistence() async {
    prefs = await SharedPreferences.getInstance();
    String server = prefs.getString('server');
    if (server == null) {
      server = "http://192.168.1.69:2020";
      prefs.setString("server", DatabaseREST.host);
    } else {
      DatabaseREST.host = server;
    }
    _server.text = DatabaseREST.host;
  }

  saveServer() async {
    await prefs.setString("server", _server.text);
    DatabaseREST.host = _server.text;
    return prefs;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ipPersistence();
  }

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
              'servidor',
              style: new TextStyle(fontSize: 16.0),
            ),
            TextFormField(
              controller: _server,
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
              obscureText: true,
              keyboardType: TextInputType.text,
              controller: _password,
            ),
            RaisedButton(
                child: Text("Entrar"),
                onPressed: () async {
                  await saveServer();

                  var response =
                      await DatabaseREST.loginUser(_email.text, _password.text);
                  var user = User.fromJson(response['data']);
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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return FeedPage(user);
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
