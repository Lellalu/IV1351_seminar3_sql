CREATE OR REPLACE VIEW sibling_counts AS
SELECT COUNT(siblings.student_id) AS num_of_siblings
FROM student
LEFT JOIN siblings on student.id = siblings.student_id
GROUP BY student.id
HAVING COUNT(siblings.student_id) <= 2;

SELECT sibling_counts.num_of_siblings AS "No of Siblings", COUNT(*) AS "No of Students"
FROM sibling_counts
GROUP BY sibling_counts.num_of_siblings
ORDER BY sibling_counts.num_of_siblings;