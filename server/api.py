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


@app.route('/registrations/users', methods=['GET', 'POST'])
def registrations():
    all_users = db.get_all_users()
    return jsonify(
        all_users
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
            response_api("success", "Dados não conferem")
        )


@app.route('/register/user', methods=['GET', 'POST'])
def register_user():
    user = request.json
    try:
        db.create_user(user['first_name'], user['last_name'], user['email'],
                       user['password'], user['phone'], user['university_registration'])
        return response_api("success", "Inserido com sucesso.")
    except Exception as e:
        return Response(str(response_api("error", str(e))), status=403, mimetype='application/json')


@app.route('/register/research/project', methods=['GET', 'POST'])
def register_research_project():
    research_project = request.json
    try:
        db.create_research_project(
            research_project['name'], research_project['description'], research_project['user_owner_id'])
        return response_api("success", "Inserido com sucesso.")
    except Exception as e:
        return Response(str(response_api("error", str(e))), status=403, mimetype='application/json')


app.run(host='0.0.0.0', port=2020)
