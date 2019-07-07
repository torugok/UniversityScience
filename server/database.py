import sqlite3


def connect_database():
    conn = sqlite3.connect('science_university.db')
    return conn


def execute_select(sql):
    con = connect_database()
    cursor = con.cursor()
    cursor.execute(sql)
    rows = cursor.fetchall()
    con.close()
    return rows


def begin_database():
    connection = connect_database()
    cursor = connection.cursor()
    cursor.execute("""
    create table IF NOT EXISTS usuarios(
    id INTEGER primary key,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    phone TEXT,
    -- Matricula SIGAA
    university_registration TEXT NOT NULL UNIQUE
    );
    """)


def create_user(first_name, last_name, email, password, phone, university_registration):
    con = connect_database()
    sql = f"insert into usuarios(first_name,last_name,email,password,phone,university_registration) values( \"{first_name}\",\"{last_name}\",\"{email}\",\"{password}\",\"{phone}\",\"{university_registration}\")"
    cursor = con.cursor()
    cursor.execute(sql)
    con.commit()
    con.close()

def login(email,password):
    sql = f"select first_name,last_name,university_registration from usuarios where email='{email}' and password = '{password}'"
    print(sql)
    data = execute_select(sql)
    if len(data) > 0:
        return True
    else:
        return False


def get_all_users():
    rows = execute_select("""
    select first_name,last_name,university_registration from usuarios where 1
    """)
    data = []
    for row in rows:
        data.append({
            "first_name": row[0],
            "last_name": row[1],
            "university_registration": row[2],
        })
    return data
