CREATE VIEW professors_view_statistics AS
    SELECT sbj.name, p.last_name, avg(m.value) AS avg_mark
    FROM people p
        RIGHT JOIN marks m on p.id = m.teacher_id
        INNER JOIN subjects sbj ON m.subject_id = sbj.id
    WHERE m.teacher_id = p.id
        AND p.type = 'P'
    GROUP BY sbj.name, p.last_name;

SELECT * FROM professors_view_statistics;


CREATE VIEW marks_view_statistics AS
SELECT m.year, avg(m.value) AS avg_mark
FROM marks m
GROUP BY m.year;

SELECT * FROM marks_view_statistics;
