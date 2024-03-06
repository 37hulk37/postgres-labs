CREATE OR REPLACE FUNCTION subject_statistics()
RETURNS TABLE(
    name varchar(64),
    avg_mark numeric(5)
             )
AS $$
BEGIN
    RETURN QUERY
    SELECT s.name, avg(m.value) as avg_mark FROM subjects s
        INNER JOIN marks m ON s.id = m.subject_id
        GROUP BY s.id;
END
$$ LANGUAGE plpgsql;

SELECT subject_statistics();

CREATE OR REPLACE FUNCTION avg_mark_in_groups("from" integer, until integer)
    RETURNS TABLE(
    id integer,
    avg_mark numeric(5)
)
AS $$
BEGIN
    RETURN QUERY (SELECT g.id, avg(m.value)
        FROM groups g
                 JOIN people st ON g.id = st.group_id
                 JOIN marks m ON m.student_id = st.id
        WHERE m.year >= "from" AND m.year <= until
        GROUP BY g.id);
END
$$ LANGUAGE plpgsql;

SELECT avg_mark_in_groups(2019, 2023);

CREATE OR REPLACE FUNCTION min_avg_mark_by_professor(professor_id integer)
RETURNS integer
AS $$
BEGIN
    RETURN (WITH avg_group_marks (id, avg_group_mark) AS (
                SELECT g.id, avg(m.value)
                FROM groups g
                       JOIN people st ON g.id = st.group_id
                       JOIN marks m ON m.student_id = st.id
                       JOIN people t ON m.teacher_id = t.id
                WHERE t.id = professor_id AND t.type = 'P'
                GROUP BY g.id)

            SELECT agm.id
            FROM avg_group_marks agm
            ORDER BY agm.avg_group_mark
            LIMIT 1
        );
END
$$ LANGUAGE plpgsql;

SELECT min_avg_mark_by_professor(11);