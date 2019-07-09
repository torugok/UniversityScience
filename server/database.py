import sqlite3


class User:
    def __init__(self, id=None, first_name="", last_name="", university_registration="", research_projects_ids=[]):
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.university_registration = university_registration
        self.research_projects_ids = research_projects_ids

    def toMap(self):
        return {
            "id": self.id,
            "first_name": self.first_name,
            "last_name": self.last_name,
            "research_projects_ids": self.research_projects_ids
        }


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
    cursor.execute("""
    CREATE TABLE if not exists "research_projects" (
	"id"	INTEGER,
	"name"	TEXT NOT NULL,
	"description"	TEXT NOT NULL,
	"user_owner_id"	INTEGER NOT NULL,
	FOREIGN KEY("user_owner_id") REFERENCES "usuarios"("id"));
    """)
    cursor.execute("""
    create table IF NOT EXISTS users_projects(
    id INTEGER primary key,
    user_id integer NOT NULL references usuarios(id) on update cascade,
    research_project_id integer NOT NULL
    );
    """)


def create_user(first_name, last_name, email, password, phone, university_registration):
    con = connect_database()
    sql = f"""insert into usuarios(first_name,
                        last_name,
                        email,
                        password,
                        phone,
                        university_registration) 
                values( \"{first_name}\",
                    \"{last_name}\",
                    \"{email}\",
                    \"{password}\",
                    \"{phone}\",
                    \"{university_registration}\")"""

    cursor = con.cursor()
    cursor.execute(sql)
    con.commit()
    con.close()


def create_research_project(name, description, user_owner_id):
    con = connect_database()
    sql = f"""insert into research_projects(name,
                        description,
                        user_owner_id) 
                values( \"{name}\",
                    \"{description}\",
                    \"{user_owner_id}\")"""

    cursor = con.cursor()
    cursor.execute(sql)
    con.commit()
    con.close()


def login(email, password):
    sql = f"""select 
                    id, 
                    first_name, 
                    last_name, 
                    university_registration
                from usuarios 
                    where 
                    email = '{email}' and password = '{password}'"""
    print(sql)
    data = execute_select(sql)
    if len(data) > 0:
        return {
            "id": data[0][0],
            "first_name": data[0][1],
            "last_name": data[0][2],
            "university_registration": data[0][3]
        }
    else:
        return None


def get_all_users():
    rows = execute_select("""
        select 
            first_name,
            last_name,
            university_registration 
        from usuarios 
            where 1
    """)
    data = []
    for row in rows:
        data.append({
            "first_name": row[0],
            "last_name": row[1],
            "university_registration": row[2],
        })
    return data
