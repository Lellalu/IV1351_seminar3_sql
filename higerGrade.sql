DROP MATERIALIZED VIEW IF EXISTS student_lesson_weekly CASCADE;
	
CREATE MATERIALIZED VIEW student_lesson_weekly AS
SELECT lesson_id, student_id, start_time, end_time,lesson_price_id 
FROM student_lesson_schedule 
LEFT JOIN lesson_schedule ON
lesson_schedule.id = student_lesson_schedule.lesson_id
WHERE date_part('week', current_date) = date_part('week', lesson_schedule.end_time);

CREATE TABLE IF NOT EXISTS past_lessons (
    lesson_id varchar(10) NOT NULL,
    lesson_type varchar(50) NOT NULL,
    genre VARCHAR(50),
	instrument VARCHAR(50),
	lesson_price VARCHAR(50) NOT NULL,
	name VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL
);

INSERT INTO past_lessons (lesson_id, lesson_type, genre, instrument, lesson_price, name, email)
SELECT
	student_lesson_weekly.lesson_id,
	lesson_price.type,
	lesson_genre.genre,
	lesson_instrument.taught_instrument,
	CASE
		WHEN siblings.sibling_id is not null THEN CAST(lesson_price.price_amount AS INT) * lesson_discount.discount_rate
		ELSE CAST(lesson_price.price_amount AS INT)
	END AS price,
	person.name,
	person.email
FROM student_lesson_weekly
LEFT JOIN lesson_genre ON
student_lesson_weekly.lesson_id = lesson_genre.lesson_id
LEFT JOIN lesson_price ON
student_lesson_weekly.lesson_price_id = lesson_price.id
LEFT JOIN lesson_instrument ON
student_lesson_weekly.lesson_id = lesson_instrument.lesson_id
LEFT JOIN student ON
student_lesson_weekly.student_id = student.id
LEFT JOIN person ON
student.person_id = person.id
LEFT JOIN siblings ON
student.id = siblings.student_id
,lesson_discount;

SELECT *
FROM past_lessons;