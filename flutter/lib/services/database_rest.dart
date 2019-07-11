import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class DatabaseREST {
  static const String host = "http://192.168.1.69:2020";
  static registerUser(String firstName, String lastName, String email,
      String password, String phone, String universityRegistration) async {
    var response =
        await http.post(Uri.encodeFull(DatabaseREST.host + "/register/user"),
            body: json.encode({
              "first_name": firstName,
              "last_name": lastName,
              "email": email,
              "password": password,
              "phone": phone,
              "university_registration": universityRegistration,
            }),
            headers: {
          "content-type": "application/json",
          "accept": "application/json",
        }).catchError((e) {
      return '{ "status" : "error", "message":"Sem conexão"}';
    });

    return json.decode(response.body);
  }

  //TODO: Retirar esse userOwnerId e transferi-lo para a tabela de relação dos usuarios com os projetos, adicionando permissão
  static registerResearchProject(
      String name, String description, int userOwnerId) async {
    try {
      var response = await http.post(
          Uri.encodeFull(DatabaseREST.host + "/register/research/project"),
          body: json.encode({
            "name": name,
            "description": description,
            "user_owner_id": userOwnerId
          }),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          });

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  static getUserById(userId) async {
    var response =
        await http.get(DatabaseREST.host + '/registrations/users/$userId');
    return jsonDecode(response.body);
  }

  static loginUser(String email, String password) async {
    try {
      var response =
          await http.post(Uri.encodeFull(DatabaseREST.host + "/login/user"),
              body: json.encode({
                "email": email,
                "password": password,
              }),
              headers: {
            "content-type": "application/json",
            "accept": "application/json",
          });

      var body = json.decode(response.body);
      return body;
    } catch (e) {
      if (e is SocketException)
        return {"status": "error", "message": "Sem conexão"};
      else
        return {"status": "error", "message": e.toString()};
    }
  }

  static getResearchProjects({int pagination = 0}) async {
    try {
      var response = await http
          .get(DatabaseREST.host + '/registrations/research_projects');
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": "errei"};
    }
  }

  static getMyResearchProjects(int userId) async {
    try {
      var response = await http
          .get(DatabaseREST.host + '/registrations/my_projects/$userId');
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": "errei"};
    }
  }

  static getUsersWaitingProjects(int userId) async {
    try {
      var response = await http
          .get(DatabaseREST.host + '/research_projects/waiting/$userId');
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": "errei"};
    }
  }

  static setStatusUser(int id, int userId, String status) async {
    try {
      var response =
          await http.post(Uri.encodeFull(DatabaseREST.host + "/edit/status/user"),
              body: json.encode({
                "id": id,
                "user_id": userId,
                "status" : status
                }),
              headers: {
            "content-type": "application/json",
            "accept": "application/json",
          });

      var body = json.decode(response.body);
      return body;
    } catch (e) {
      if (e is SocketException)
        return {"status": "error", "message": "Sem conexão"};
      else
        return {"status": "error", "message": e.toString()};
    }
  }

  static requestParticiparPesquisa(int userId, int researchProjectId) async {
    try {
      var response =
          await http.post(Uri.encodeFull(DatabaseREST.host + "/request/participation/project"),
              body: json.encode({
                "user_id": userId,
                "research_project_id" : researchProjectId
                }),
              headers: {
            "content-type": "application/json",
            "accept": "application/json",
          });

      var body = json.decode(response.body);
      return body;
    } catch (e) {
      if (e is SocketException)
        return {"status": "error", "message": "Sem conexão"};
      else
        return {"status": "error", "message": e.toString()};
    }
  }

}
