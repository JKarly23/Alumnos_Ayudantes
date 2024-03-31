import random
import psycopg2

dbname = 'postgres'
user = 'postgres'
password = '123456789'
host = 'localhost'
port = '5432'

conf = psycopg2.connect(
        dbname=dbname,
        user=user,
        password=password,
        host=host,
        port=port
    )


def llenar_estudiantes(cursor):
    nombres = [
    'Luis', 'Juan', 'María', 'Ana', 'Carlos', 'Laura', 'Pedro', 'Sofía', 'Miguel', 'Lucía',
    'José', 'Paula', 'David', 'Elena', 'Andrés', 'Isabel', 'Pablo', 'Valentina', 'Javier', 'Carmen',
    'Fernando', 'Rocío', 'Diego', 'Natalia', 'Gabriel', 'Alejandra', 'Francisco', 'Raquel', 'Daniel', 'Lorena']

    apellidos = [
    'García', 'Rodríguez', 'González', 'Fernández', 'López', 'Martínez', 'Sánchez', 'Pérez', 'Gómez', 'Martín',
    'Ruiz', 'Hernández', 'Jiménez', 'Díaz', 'Moreno', 'Álvarez', 'Muñoz', 'Romero', 'Alonso', 'Gutiérrez',
    'Navarro', 'Torres', 'Domínguez', 'Vázquez', 'Ramos', 'Gil', 'Ramírez', 'Serrano', 'Blanco', 'Suárez']
    id = 203

    for i in range(0, 200):
        nombre = random.choice(nombres)
        apellido = random.choice(apellidos)
        cursor.execute(f"INSERT INTO estudiantes (id, nombre, apellidos) VALUES ({id}, '{nombre}', '{apellido}')")
        id += 1

def llenar_asignaturas(cursor):
    nombres = ['Fisica','Matematica','ICI','PW','GPN',"SBD",'PE','Sistema Operativo','ED']
    id = 1
    for i in nombres:
        cursor.execute(f"INSERT INTO asignaturas (id,nombre) values ({id},'{i}')")
        id += 1
from datetime import date, timedelta

def llenar_convocatoria(cursor):
    nombres_convocatorias = [
        "Convocatoria Fisica",
        "Convocatoria Matemáticas",
        "Convocatoria ICI",
        "Convocatoria Programación Web",
        "Convocatoria GPN",
        "Convocatoria SBD",
        "Convocatoria Probabilidad Estadistica",
        "Convocatoria Sistemas Operativos",
        "Convocatoria ED",
    ]

    descripciones_convocatorias = [
        "Ayudantes en Fisica.",
        "Ayudantes en Matemáticas",
        "Ayudantes en ICI.",
        "Ayudantes en Programación Web",
        "Ayudantes en GPN.",
        "Ayudantes en SBD.",
        "Ayudantes en Probabilidad Estadistica",
        "Ayudantes en SO.",
        "Ayudantes en ED.",
    ]

    cursos_academicos = 2024


    fecha_inicio = [date.today() for _ in range(10)]
    fecha_fin = [(date.today() + timedelta(days=i)) for i in range(10)]
    id = 1

    for i in range(9):
        cursor.execute(f"INSERT INTO convocatoria (id,nombre,descripcion, curso_academico, fecha_inicio, fecha_fin) values ({id},'{nombres_convocatorias[i]}','{descripciones_convocatorias[i]}',{cursos_academicos},'{fecha_inicio[i]}','{fecha_fin[i]}')")
        id += 1

    print("Nombres:", nombres_convocatorias)
    print("Descripciones:", descripciones_convocatorias)
    print("Cursos Académicos:", cursos_academicos)
    print("Fechas de Inicio:", fecha_inicio)
    print("Fechas de Fin:", fecha_fin)


def llenar_solicitudes(cursor):
    asignaturas = ['Fisica', 'Matematica', 'ICI', 'PW', 'GPN', 'SBD', 'PE', 'Sistema Operativo', 'ED']
    id =1

    for _ in range(250):
        id_estudiante = random.randint(1, 402)
        id_asignatura = random.randint(1, len(asignaturas))
        id_convocatoria = id_asignatura
        estado_solicitud = random.choice([True, False])

        cursor.execute(f"INSERT INTO public.solicitudes (id,id_estudiante, id_asignatura, id_convocatoria, estado_solicitud) VALUES ({id},{id_estudiante},{id_asignatura}, {id_convocatoria}, {estado_solicitud})")

        id+=1
    pass


cursor = conf.cursor()
#llenar_estudiantes(cursor)
#llenar_asignaturas(cursor)
#llenar_convocatoria(cursor)
llenar_solicitudes(cursor)
cursor.execute("SELECT * FROM asignaturas")
conf.commit()
