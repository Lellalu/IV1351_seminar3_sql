SELECT lessons_of_instructor.instructor_id AS "Instructor Id", person.name AS name, lessons_of_instructor.count AS "No of Lessons"
FROM (
	SELECT lesson_schedule.instructor_id, COUNT(*)
	FROM lesson_schedule
	LEFT JOIN instructor ON lesson_schedule.instructor_id = instructor.id
	WHERE date_part('month', current_date) = date_part('month', lesson_schedule.end_time)
	GROUP BY lesson_schedule.instructor_id
	HAVING COUNT(*) > 3) AS lessons_of_instructor
LEFT JOIN instructor on lessons_of_instructor.instructor_id=instructor.id 
LEFT JOIN person on person.id = instructor.person_id;