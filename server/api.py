from flask import Flask, jsonify, request, abort, Response
import database as db
import sqlite3
db.begin_database()

# ip local: 192.168.1.69
app = Flask(__name__)


# status pode ser: error ou success
def response_api(status, message):
    return {
        "status": status,
        "message": message
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
    logged = db.login(user['email'],user['password'])
    if logged:
        return jsonify(
        {"status":"success","message":"Logado com sucesso"}
        )
    else:
        return jsonify(
        {"status":"error","message":"Dados não conferem"}
        )

@app.route('/register/user', methods=['GET', 'POST'])
def register_user():
    user = request.json
    try:
        db.create_user(user['first_name'], user['last_name'], user['email'],
                       user['password'], user['phone'], user['university_registration'])
        return response_api("success", "Inserido com sucesso.")
    except Exception as e:
        return response_api("error", str(e))


app.run(host='0.0.0.0', port=2020)
