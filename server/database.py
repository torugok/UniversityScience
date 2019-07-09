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
	"id"	INTEGER primary key,
	"name"	TEXT NOT NULL,
	"description"	TEXT NOT NULL,
	"user_owner_id"	INTEGER NOT NULL,
	FOREIGN KEY("user_owner_id") REFERENCES "usuarios"("id")
    );
    
    """)

    # cursor.execute(""""
   # CREATE UNIQUE INDEX if not exists "unique_name" ON "research_projects" (
   #     "name"
   # );""")

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

    sql_assoc = f"""insert into users_projects(user_id,
                        research_project_id) 
                values( \"{user_owner_id}\",
                    \"{cursor.lastrowid}\")"""

    cursor.execute(sql_assoc)

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


def get_all_research_projects():
    rows = execute_select("""
        select 
            research_projects.id,
            research_projects.name,
            research_projects.description,
            research_projects.user_owner_id
        from research_projects       
        where 1
    """)
    data = []

    for row in rows:
        users = execute_select(f"""
            select  users_projects.user_id,
                    usuarios.first_name,
                    usuarios.last_name,
                    usuarios.email,
                    usuarios.phone,
                    usuarios.university_registration
                from usuarios 
                inner join users_projects on 
                    usuarios.id = users_projects.user_id
                where 
                users_projects.research_project_id = {row[0]}
                """)
        users_in_research = []
        for user in users:
            users_in_research.append({
                "user_id": user[0],
                "first_name": user[1],
                "last_name": user[2],
                "email": user[3],
                "phone": user[4],
                "university_registration": user[5],
            })

        data.append({
            "id": row[0],
            "name": row[1],
            "description": row[2],
            "user_owner_id": row[3],
            "users_in_research": users_in_research})
    return data


def get_my_projects(user_id):
    rows = execute_select("""
        select 
            id,
            name,
            description,
            user_owner_id
        from research_projects 
            where 1
    """)
    data = []
    for row in rows:
        data.append({
            "id": row[0],
            "name": row[1],
            "description": row[2],
            "user_owner_id": row[3]
        })
    return data
