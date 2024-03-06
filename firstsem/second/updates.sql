UPDATE people st
SET group_id = 5
WHERE st.group_id = 2;

DO
$do$
    BEGIN
        UPDATE marks
        SET subject_id = 1
        WHERE subject_id = 3;

        DELETE FROM subjects
        WHERE id = 3;

        COMMIT;
    END;
$do$;

DO
$do$
    DECLARE
        num_professor_sbj int;
    BEGIN
        UPDATE marks
        SET subject_id = 1
        WHERE subject_id = 2;

        DELETE FROM subjects
        WHERE id = 2;

        SELECT p.id, count(sbj.id) into num_professor_sbj
        FROM marks m
                 JOIN subjects sbj ON m.subject_id = sbj.id
                 JOIN people p ON m.teacher_id = p.id
        WHERE p.id = 11 AND p.type = 'P'
        GROUP BY p.id;

        IF num_professor_sbj = 1 THEN
            ROLLBACK;
        END IF;

        COMMIT;
    END;
$do$;
