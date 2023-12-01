SELECT
	date_part('month', lesson_schedule.start_time) AS month,
	COUNT(*) AS total,
	SUM(case when lesson_price.type = 'individual' then 1 else 0 end) AS Individual,
	SUM(case when lesson_price.type = 'group' then 1 else 0 end) AS Group,
	SUM(case when lesson_price.type = 'ensemble' then 1 else 0 end) AS Ensemble
FROM lesson_schedule
LEFT JOIN lesson_price ON lesson_schedule.lesson_price_id = lesson_price.id 
GROUP BY month
ORDER BY month;