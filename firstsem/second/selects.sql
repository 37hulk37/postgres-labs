SELECT * FROM groups g
ORDER BY g.g_date DESC, g.name;

SELECT count(*) FROM (SELECT count(*) AS num_subjects
               FROM subjects sbj
                        JOIN marks m ON sbj.id = m.subject_id
                        JOIN people p ON m.student_id = p.id
                        JOIN groups g ON g.id = p.group_id
               WHERE g.name = '1st'
               GROUP BY sbj.id
               HAVING count(g.id) > 0) as smpgns;

SELECT g.name, avg(m.value) AS avg_mark FROM groups g
    JOIN people p ON g.id = p.group_id
    JOIN marks m ON m.student_id = p.id
    WHERE p.type = 'S'
    GROUP BY g.name;

SELECT st.id, st.first_name, st.last_name, sbj.name
FROM subjects sbj
    LEFT JOIN marks ON sbj.id = marks.subject_id
    LEFT JOIN people st ON marks.student_id = st.id;