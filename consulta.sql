/*
 * Copyright (c) 2024 . All rights reserved.
 */

--Consulta para crear la tabla estudiantes

-- public.estudiantes definition

-- Drop table

-- DROP TABLE public.estudiantes;

CREATE TABLE public.estudiantes (
	id int4 NOT NULL,
	nombre varchar(50) DEFAULT NULL::character varying NULL,
	apellidos varchar(50) DEFAULT NULL::character varying NULL,
	CONSTRAINT estudiantes_pkey PRIMARY KEY (id)
);


--Consulta para crear la tabla solicitudes

-- public.solicitudes definition

-- Drop table

-- DROP TABLE public.solicitudes;

CREATE TABLE public.solicitudes (
	id int4 NOT NULL,
	id_estudiante int4 NULL,
	id_asignatura int4 NULL,
	id_convocatoria int4 NULL,
	estado_solicitud bool NULL,
	CONSTRAINT solicitudes_pkey PRIMARY KEY (id)
);

-- Table Triggers

create trigger solicitud_insertada after
insert
    on
    public.solicitudes for each row execute function insertar_alumno_ayudante();


-- public.solicitudes foreign keys

ALTER TABLE public.solicitudes ADD CONSTRAINT solicitudes_id_asignatura_fkey FOREIGN KEY (id_asignatura) REFERENCES public.asignaturas(id);
ALTER TABLE public.solicitudes ADD CONSTRAINT solicitudes_id_convocatoria_fkey FOREIGN KEY (id_convocatoria) REFERENCES public.convocatoria(id);
ALTER TABLE public.solicitudes ADD CONSTRAINT solicitudes_id_estudiante_fkey FOREIGN KEY (id_estudiante) REFERENCES public.estudiantes(id);


--Consulta para crear la tabla convocatoria

-- public.convocatoria definition

-- Drop table

-- DROP TABLE public.convocatoria;

CREATE TABLE public.convocatoria (
	id int4 NOT NULL,
	nombre varchar(50) DEFAULT NULL::character varying NULL,
	descripcion varchar(50) DEFAULT NULL::character varying NULL,
	curso_academico int4 NULL,
	fecha_inicio date NULL,
	fecha_fin date NULL,
	CONSTRAINT convocatoria_pkey PRIMARY KEY (id)
);

--Consulta para crear la tabla asignaturas

-- public.asignaturas definition

-- Drop table

-- DROP TABLE public.asignaturas;

CREATE TABLE public.asignaturas (
	id int4 NOT NULL,
	nombre varchar(50) DEFAULT NULL::character varying NULL,
	CONSTRAINT asignaturas_pkey PRIMARY KEY (id)
);

--Consulta para crear la tabla alumnosayudantes

-- public.alumnosayudantes definition

-- Drop table

-- DROP TABLE public.alumnosayudantes;

CREATE TABLE public.alumnosayudantes (
	id int4 NOT NULL,
	nombre varchar(50) DEFAULT NULL::character varying NULL,
	apellidos varchar(50) DEFAULT NULL::character varying NULL,
	solapin varchar(50) NULL,
	ano_academico int4 NULL,
	id_asignatura int4 NULL,
	id_estudiante int4 NULL,
	CONSTRAINT alumnosayudantes_pkey PRIMARY KEY (id)
);


-- public.alumnosayudantes foreign keys

ALTER TABLE public.alumnosayudantes ADD CONSTRAINT alumnosayudantes_id_asignatura_fkey FOREIGN KEY (id_asignatura) REFERENCES public.asignaturas(id);
ALTER TABLE public.alumnosayudantes ADD CONSTRAINT alumnosayudantes_id_estudiante_fkey FOREIGN KEY (id_estudiante) REFERENCES public.estudiantes(id);

--Funcion para llenar la tabla alumno ayudante

-- DROP FUNCTION public.insertar_alumno_ayudante();

CREATE OR REPLACE FUNCTION public.insertar_alumno_ayudante()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    nombre_estudiante varchar(50);
    apellidos_estudiante varchar(50);
    ano_academico_random int;
    solapin_random varchar(50);
BEGIN
    -- Obtener el nombre y apellidos del estudiante
    SELECT nombre, apellidos INTO nombre_estudiante, apellidos_estudiante
    FROM public.estudiantes
    WHERE id = NEW.id_estudiante;

    -- Generar un año académico aleatorio entre 3 y 5
    ano_academico_random := floor(random() * (5 - 3 + 1) + 3);

    -- Generar un solapin aleatorio
    solapin_random := 'BB' || lpad(floor(random() * 10000)::text, 4, '0');

    -- Verificar si el estado de la solicitud es verdadero
    IF NEW.estado_solicitud = TRUE THEN
        -- Insertar un nuevo registro en la tabla alumnosayudantes
        INSERT INTO public.alumnosayudantes (id, nombre, apellidos, solapin, ano_academico, id_asignatura, id_estudiante)
        VALUES (NEW.id, nombre_estudiante, apellidos_estudiante, solapin_random, ano_academico_random, NEW.id_asignatura, NEW.id_estudiante);
    END IF;

    -- Retornar NEW para indicar que el trigger se ejecutó con éxito
    RETURN NEW;
END;
$function$
;

SELECT public.insertar_alumno_ayudante();