import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseREST {
  static String host = "http://192.168.1.69:2020";
  static registerUser(String first_name, String last_name, String email,
      String password, String phone, String university_registration) async {
    var response = await http
        .post(Uri.encodeFull("http://192.168.1.69:2020/register/user"),
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
