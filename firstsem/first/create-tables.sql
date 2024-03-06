-- ALTER USER postgres WITH PASSWORD 'qwe';

CREATE TABLE IF NOT EXISTS subjects (
    id serial NOT NULL,
    name varchar(64) NOT NULL,

    CONSTRAINT subject_pk PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS "groups" (
    id serial NOT NULL,
    name varchar(64) NOT NULL,
    g_date date NOT NULL,

    CONSTRAINT groups_pk PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS people (
    id serial NOT NULL,
    first_name varchar(32) NOT NULL,
    last_name varchar(32) NOT NULL,
    pather_name varchar(32) NOT NULL,
    group_id integer,
    course integer,
    "type" char NOT NULL,

    CONSTRAINT people_pk PRIMARY KEY(id),
    CONSTRAINT fk_people_groups FOREIGN KEY(group_id)
      REFERENCES groups(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS marks (
    id serial NOT NULL,
    student_id integer NOT NULL,
    subject_id integer NOT NULL,
    teacher_id integer NOT NULL,
    year integer not null,
    value integer NOT NULL,

    CHECK(value BETWEEN 2 AND 5),

    CONSTRAINT marks_pk PRIMARY KEY(id),

    CONSTRAINT fk_marks_people1 FOREIGN KEY(student_id)
     REFERENCES people(id) ON DELETE CASCADE,
    CONSTRAINT fk_marks_people2 FOREIGN KEY(teacher_id)
     REFERENCES people(id) ON DELETE CASCADE,
    CONSTRAINT fk_marks_subjects FOREIGN KEY(subject_id)
     REFERENCES subjects(id) ON DELETE CASCADE
);

