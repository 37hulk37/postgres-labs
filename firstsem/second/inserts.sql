INSERT INTO groups (name, g_date)
VALUES ('1st', current_date);
INSERT INTO groups (name, g_date)
VALUES ('2nd', current_date);
INSERT INTO groups (name, g_date)
VALUES ('3rd', current_date);
INSERT INTO groups (name, g_date)
VALUES ('4th', current_date);
INSERT INTO groups (name, g_date)
VALUES ('5th', current_date);

--------------------------

INSERT INTO subjects (name)
VALUES ('math');
INSERT INTO subjects (name)
VALUES ('java');
INSERT INTO subjects (name)
VALUES ('kotlin');

--------------------------

INSERT INTO people (first_name, last_name, pather_name, group_id, type, course)
VALUES ('fname0', 'lname0', 'pname0', 1, 'S', 1);
INSERT INTO people (first_name, last_name, pather_name, group_id, type, course)
VALUES ('fname1', 'lname1', 'pname1', 1, 'S', 1);
INSERT INTO people (first_name, last_name, pather_name, group_id, type, course)
VALUES ('fname2', 'lname2', 'pname2', 1, 'S', 1);
INSERT INTO people (first_name, last_name, pather_name, group_id, type, course)
VALUES ('fname3', 'lname3', 'pname3', 1, 'S', 1);
INSERT INTO people (first_name, last_name, pather_name, group_id, type, course)
VALUES ('fname4', 'lname4', 'pname4', 2, 'S', 1);
INSERT INTO people (first_name, last_name, pather_name, group_id, type, course)
VALUES ('fname5', 'lname5', 'pname5', 2, 'S', 1);
INSERT INTO people (first_name, last_name, pather_name, group_id, type, course)
VALUES ('fname6', 'lname6', 'pname6', 3, 'S', 1);
INSERT INTO people (first_name, last_name, pather_name, group_id, type, course)
VALUES ('fname7', 'lname7', 'pname7', 3, 'S', 1);
INSERT INTO people (first_name, last_name, pather_name, group_id, type, course)
VALUES ('fname8', 'lname8', 'pname8', 3, 'S', 1);
INSERT INTO people (first_name, last_name, pather_name, group_id, type, course)
VALUES ('fname9', 'lname9', 'pname9', 4, 'S', 1);

INSERT INTO people (first_name, last_name, pather_name, type)
VALUES ('teacher', 'teacher', 'teacher',  'P');

INSERT INTO people (first_name, last_name, pather_name, type)
VALUES ('teacher2', 'teacher2', 'teacher2',  'P');

-------------------------------------------

INSERT INTO marks (student_id, subject_id, teacher_id, value, year)
VALUES (1, 1, 6, 5, 2021);
INSERT INTO marks (student_id, subject_id, teacher_id, value, year)
VALUES (1, 2, 6, 5, 2020);
INSERT INTO marks (student_id, subject_id, teacher_id, value, year)
VALUES (2, 1, 6, 5, 2023);
INSERT INTO marks (student_id, subject_id, teacher_id, value, year)
VALUES (2, 2, 6, 5, 2023);
INSERT INTO marks (student_id, subject_id, teacher_id, value, year)
VALUES (3, 1, 6, 5, 2023);
INSERT INTO marks (student_id, subject_id, teacher_id, value, year)
VALUES (3, 2, 6, 5, 2023);
INSERT INTO marks (student_id, subject_id, teacher_id, value, year)
VALUES (4, 1, 6, 5, 2023);
INSERT INTO marks (student_id, subject_id, teacher_id, value, year)
VALUES (7, 2, 6, 5, 2023);
INSERT INTO marks (student_id, subject_id, teacher_id, value, year)
VALUES (8, 2, 6, 5, 2023);
INSERT INTO marks (student_id, subject_id, teacher_id, value, year)
VALUES (9, 1, 6, 5, 2020);
INSERT INTO marks (student_id, subject_id, teacher_id, value, year)
VALUES (10, 2, 6, 5, 1990);

INSERT INTO marks (student_id, subject_id, teacher_id, value, year)
VALUES (11, 1, 12, 5, 2021);

-----------------------------------------------------------------

DO
$do$
    BEGIN
        WITH students_update (id, course) AS (
            SELECT id, course + 2
            FROM people st1
            ORDER BY id)
        UPDATE people st2
        SET course = stu.course
        FROM students_update stu
        WHERE stu.id = st2.id AND st2.type = 'S';

        COMMIT;
    END;
$do$;

DO
$do$
    BEGIN
        WITH students_update (id, course) AS (
            SELECT id, course + 1
            FROM people st1
            ORDER BY id)
        UPDATE people st2
        SET course = stu.course
        FROM students_update stu
        WHERE stu.id = st2.id;

        IF EXISTS(SELECT * FROM groups WHERE groups.name = '5th') THEN
            ROLLBACK;
        END IF;
        COMMIT;
    END;
$do$;

WITH students_update (id, course) AS (
    SELECT st1.id, st1.course + 1
    FROM people st1
        JOIN groups g ON st1.group_id = g.id
    ORDER BY id
)
UPDATE people st2
SET course = stu.course
FROM students_update stu
WHERE stu.id = st2.id;