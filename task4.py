import psycopg2
import getpass

QUERY = """\
DROP MATERIALIZED VIEW IF EXISTS next_week_lessons CASCADE;

CREATE MATERIALIZED VIEW next_week_lessons AS
SELECT id, to_char(lesson_schedule.end_time, 'TMDay') AS day
FROM lesson_schedule
WHERE extract(week from cast(current_date as date))+1 = extract(week from lesson_schedule.end_time);

DROP MATERIALIZED VIEW IF EXISTS next_week_lessons_genre CASCADE;

CREATE MATERIALIZED VIEW next_week_lessons_genre AS
SELECT next_week_lessons.id, next_week_lessons.day, lesson_genre.genre
FROM next_week_lessons
INNER JOIN lesson_genre ON
	next_week_lessons.id = lesson_genre.lesson_id;
	
DROP MATERIALIZED VIEW IF EXISTS next_week_lessons_max_cap CASCADE;
	
CREATE MATERIALIZED VIEW next_week_lessons_max_cap AS
SELECT next_week_lessons_genre.id, next_week_lessons_genre.day, next_week_lessons_genre.genre, lesson_capacity.max
FROM next_week_lessons_genre
INNER JOIN lesson_capacity ON
	next_week_lessons_genre.id = lesson_capacity.lesson_id;
	
DROP MATERIALIZED VIEW IF EXISTS next_week_lessons_cap CASCADE;
	
CREATE MATERIALIZED VIEW next_week_lessons_cap AS
SELECT next_week_lessons_max_cap.id, next_week_lessons_max_cap.day, next_week_lessons_max_cap.genre, next_week_lessons_max_cap.max, student_lesson_schedule.student_id
FROM next_week_lessons_max_cap
LEFT JOIN student_lesson_schedule ON
	next_week_lessons_max_cap.id = student_lesson_schedule.lesson_id;

SELECT
	day,
	genre, 
	CASE
		WHEN CAST(max AS INT) - CAST(COUNT(*) AS INT) > 2 THEN 'Many Seats'
		WHEN CAST(max AS INT) - CAST(COUNT(*) AS INT) <= 0 THEN 'No Seats'
		ELSE '1 or 2 Seats'
	END AS "No of Free Seats"
FROM next_week_lessons_cap
GROUP BY day, genre, max;
"""

def main():
    user = "postgres"
    password = getpass.getpass(f"Please enter the password for {user}: ")

    conn = psycopg2.connect(
        host="localhost",
        database="soundgood",
        user=user,
        password=password)
    
    cur = conn.cursor()
    cur.execute(QUERY)
    result = cur.fetchall()
    print("The result is: ")
    print([desc[0] for desc in cur.description])
    for row in result:
        print(row)
    cur.close()
    conn.close()
    


if __name__ == "__main__":
    main()