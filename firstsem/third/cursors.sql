CREATE TEMP TABLE marks_stat(
    id serial,
    m_year integer,
    sbj_name varchar(64),
    avg_mark numeric,
    avg_mark_diff numeric
);

CREATE FUNCTION cursor(from_d integer, until_d integer)
    RETURNS TABLE(id integer, year integer, sbj_name varchar(64), avg_mark numeric, mark_avg_diff numeric)
AS $$
DECLARE
    c_cursor CURSOR FOR SELECT m.year, sbj.name, avg(m.value) FROM marks m
                    JOIN people st ON st.id = m.student_id
                    JOIN subjects sbj ON sbj.id = m.subject_id
                    WHERE m.year >= from_d AND m.year <= until_d
                    GROUP BY m.year, sbj.name;

    cur record;
    marks_avg numeric := 0;

BEGIN
    OPEN c_cursor;
    LOOP
        FETCH c_cursor INTO cur;
        exit when not found;

        marks_avg := @(marks_avg - cur.avg);

        INSERT INTO marks_stat(m_year, sbj_name, avg_mark, avg_mark_diff)
        VALUES(cur.year, cur.name, cur.avg, marks_avg);
    END LOOP;
    CLOSE c_cursor;

    return QUERY (SELECT * FROM marks_stat);
END;
$$
LANGUAGE 'plpgsql';

select cursor(2019, 2022);

DROP TABLE marks_stat;