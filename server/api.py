from flask import Flask, jsonify, request, abort, Response
import database as db
import sqlite3
db.begin_database()

# ip local: 192.168.1.69
app = Flask(__name__)


# status pode ser: error ou success
def response_api(status, message, data={}):
    return {
        "status": status,
        "message": message,
        "data": data
    }


@app.route('/', methods=['GET', 'POST'])
def index():
    return "<h1>Bem vindo</h1>"


@app.route('/registrations/users/<user_id>', methods=['GET', 'POST'])
def registration_user(user_id):
    user = db.get_user(user_id)
    return jsonify(
        user
    )


@app.route('/registrations/users', methods=['GET', 'POST'])
def registrations():
    all_users = db.get_all_users()
    return jsonify(
        all_users
    )


@app.route('/registrations/research_projects', methods=['GET', 'POST'])
def registrations_research_projects():
    all_projects = db.get_all_research_projects()
    return jsonify(
        all_projects
    )


@app.route('/registrations/my_projects/<user_id>', methods=['GET', 'POST'])
def registrations_my_projects(user_id):
    all_projects = db.get_my_research_projects(user_id)
    return jsonify(
        all_projects
    )


@app.route('/login/user', methods=['GET', 'POST'])
def login_ser():
    user = request.json
    result_login = db.login(user['email'], user['password'])
    if result_login != None:
        return jsonify(
            response_api("success", "Logado com sucesso", result_login)
        )
    else:
        return jsonify(
            response_api("error", "Dados não conferem")
        )


@app.route('/register/user', methods=['GET', 'POST'])
def register_user():
    user = request.json
    try:
        db.create_user(user['first_name'], user['last_name'], user['email'],
                       user['password'], user['phone'], user['university_registration'])
        return response_api("success", "Inserido com sucesso.")
    except Exception as e:
        return jsonify(response_api("error", str(e)))


@app.route('/register/research/project', methods=['GET', 'POST'])
def register_research_project():
    research_project = request.json
    try:
        db.create_research_project(
            research_project['name'], research_project['description'], research_project['user_owner_id'])
        return jsonify(response_api("success", "Inserido com sucesso."))
    except sqlite3.IntegrityError as e:
        return jsonify(response_api("error", "Já existe um projeto com esse nome."))
    except Exception as e:
        return jsonify(response_api("error", str(e)))


@app.route('/edit/research/project', methods=['GET', 'POST'])
def edit_research_project():
    research_project_edited = request.json
    print(research_project_edited)
    db.edit_research_project(research_project_edited['id'], research_project_edited['name'],
                             research_project_edited['description'], research_project_edited['user_owner_id'])
    return jsonify(response_api("sucess", "Alterado com sucesso."))


@app.route('/research_projects/waiting/<user_id>', methods=['GET', 'POST'])
def get_users_waiting(user_id):
    waiting_users = db.get_waiting_users(user_id)
    return jsonify(waiting_users)


@app.route('/edit/status/user', methods=['GET', 'POST'])
def edit_status_user():
    requeste = request.json
    db.set_status_user(requeste['id'],requeste['user_id'],requeste['status'])
    return jsonify(response_api("sucess", "Alterado com sucesso."))

@app.route('/request/participation/project', methods=['GET', 'POST'])
def request_participation_project():
    requeste = request.json
    db.request_participation_project(requeste['user_id'],requeste['research_project_id'])
    return jsonify(response_api("sucess", "Requisitado com sucesso."))



app.run(host='0.0.0.0', port=3030)
