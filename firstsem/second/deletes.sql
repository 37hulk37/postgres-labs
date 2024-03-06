DELETE FROM people st
WHERE st.id NOT IN (
    SELECT st.id
    FROM people st
        JOIN marks m ON st.id = m.student_id
    WHERE st.type = 'S'
    GROUP BY st.id
    HAVING avg(m.value) > 4
);

DELETE FROM people st
WHERE st.id IN (
    SELECT st.id
    FROM people st
             JOIN groups g ON st.group_id = g.id
    WHERE g.id = 1
);

DO
$do$
    BEGIN
        DELETE FROM groups g
        WHERE g.id IN (
            WITH avg_mark_in_groups (id, avg_mark) AS (
                SELECT g2.id, avg(m.value)
                FROM people st
                         JOIN groups g2 on g2.id = st.group_id
                         JOIN marks m on m.student_id = st.id
                GROUP BY g2.id
                ORDER BY g2.id)

            SELECT id
            FROM avg_mark_in_groups
            WHERE avg_mark = (
                SELECT min(avg_mark)
                FROM avg_mark_in_groups
            ));
        COMMIT;
    END;
$do$;

CREATE PROCEDURE delete_group()
    LANGUAGE plpgsql
AS $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT count(sbj.id) AS num_sbj, sbj.id
             FROM subjects sbj
                  JOIN marks m ON sbj.id = m.subject_id
                  JOIN people p ON m.teacher_id = p.id
                  JOIN groups g ON g.id = p.group_id
             WHERE g.id = 3
             GROUP BY sbj.id
             HAVING count(*) = 3 LOOP

            IF EXISTS(SELECT count(g.id) AS num_sbj_in_g
                      FROM subjects sbj
                               JOIN marks m ON sbj.id = m.subject_id
                               JOIN people p ON m.student_id = p.id
                               JOIN groups g ON g.id = p.group_id
                      WHERE sbj.id = r.id
                      GROUP BY sbj.id
                      HAVING count(*) = 0) THEN

                ROLLBACK;
            END IF;

            DELETE FROM groups g
            WHERE g.id = 2;
        END LOOP;

    COMMIT;
END;
$$;

CALL delete_group();

SELECT * FROM groups;
