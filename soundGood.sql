CREATE TYPE LESSONTYPE AS ENUM ('individual', 'group', 'ensemble');
CREATE TYPE LESSONLEVEL AS ENUM ('beginner', 'intermediate', 'advanced');

CREATE TABLE instrument (
 id INT NOT NULL,
 instrment_name VARCHAR(50),
 rented_price_per_month VARCHAR(10)
);

ALTER TABLE instrument ADD CONSTRAINT PK_instrument PRIMARY KEY (id);


CREATE TABLE instrument_stock (
 id INT NOT NULL,
 brand VARCHAR(50) NOT NULL,
 type VARCHAR(50) NOT NULL,
 quantity VARCHAR(10) NOT NULL,
 instrument_id INT NOT NULL
);

ALTER TABLE instrument_stock ADD CONSTRAINT PK_instrument_stock PRIMARY KEY (id);


CREATE TABLE rental_policy (
 id INT NOT NULL,
 max_rental_period VARCHAR(10),
 max_num_rental VARCHAR(10)
);

ALTER TABLE rental_policy ADD CONSTRAINT PK_rental_policy PRIMARY KEY (id);


CREATE TABLE lesson_discount (
 id INT NOT NULL,
 discount_rule VARCHAR(500),
 discount_rate FLOAT(10)
);

ALTER TABLE lesson_discount ADD CONSTRAINT PK_lesson_discount PRIMARY KEY (id);


CREATE TABLE lesson_price (
 id INT NOT NULL,
 type LESSONTYPE NOT NULL,
 level LESSONLEVEL NOT NULL,
 price_amount  VARCHAR(10) NOT NULL,
 start_time TIMESTAMP NOT NULL,
 end_time TIMESTAMP,
 lesson_discount_id INT NOT NULL
);

ALTER TABLE lesson_price ADD CONSTRAINT PK_lesson_price PRIMARY KEY (id);


CREATE TABLE person (
 id INT NOT NULL,
 person_number VARCHAR(12) NOT NULL,
 name VARCHAR(50) NOT NULL,
 email VARCHAR(50) NOT NULL,
 city VARCHAR(50),
 zip VARCHAR(5),
 street VARCHAR(100)
);

ALTER TABLE person ADD CONSTRAINT PK_person PRIMARY KEY (id);


CREATE TABLE phone (
 id INT NOT NULL,
 phone_no VARCHAR(12) NOT NULL
);

ALTER TABLE phone ADD CONSTRAINT PK_phone PRIMARY KEY (id);


CREATE TABLE student (
 id INT NOT NULL,
 person_id INT NOT NULL,
 contact_person_phone VARCHAR(12)
);

ALTER TABLE student ADD CONSTRAINT PK_student PRIMARY KEY (id);


CREATE TABLE instructor (
 id INT NOT NULL,
 instruments_taught VARCHAR(50) NOT NULL,
 person_id INT NOT NULL
);

ALTER TABLE instructor ADD CONSTRAINT PK_instructor PRIMARY KEY (id);


CREATE TABLE lesson_schedule (
 id INT NOT NULL,
 start_time  TIMESTAMP NOT NULL,
 end_time TIMESTAMP NOT NULL,
 instructor_id INT NOT NULL,
 lesson_price_id INT
);

ALTER TABLE lesson_schedule ADD CONSTRAINT PK_lesson_schedule PRIMARY KEY (id);


CREATE TABLE person_phone (
 person_id INT NOT NULL,
 phone_id INT NOT NULL
);

ALTER TABLE person_phone ADD CONSTRAINT PK_person_phone PRIMARY KEY (person_id,phone_id);


CREATE TABLE rental (
 id INT NOT NULL,
 start_date TIMESTAMP NOT NULL,
 end_date TIMESTAMP NOT NULL,
 instrument_id INT NOT NULL,
 student_id INT NOT NULL,
 rental_policy_id INT NOT NULL
);

ALTER TABLE rental ADD CONSTRAINT PK_rental PRIMARY KEY (id);


CREATE TABLE siblings (
 student_id INT NOT NULL,
 sibling_id INT NOT NULL
);

ALTER TABLE siblings ADD CONSTRAINT PK_siblings PRIMARY KEY (student_id,sibling_id);


CREATE TABLE student_lesson_schedule (
 lesson_id INT NOT NULL,
 student_id INT NOT NULL
);

ALTER TABLE student_lesson_schedule ADD CONSTRAINT PK_student_lesson_schedule PRIMARY KEY (lesson_id,student_id);


CREATE TABLE lesson_capacity (
 id INT NOT NULL,
 max VARCHAR(10),
 min VARCHAR(10) NOT NULL,
 lesson_id INT NOT NULL
);

ALTER TABLE lesson_capacity ADD CONSTRAINT PK_lesson_capacity PRIMARY KEY (id);


CREATE TABLE lesson_genre (
 id INT NOT NULL,
 genre  VARCHAR(50) NOT NULL,
 lesson_id INT NOT NULL
);

ALTER TABLE lesson_genre ADD CONSTRAINT PK_lesson_genre PRIMARY KEY (id);


CREATE TABLE lesson_instrument (
 id INT NOT NULL,
 taught_instrument VARCHAR(50) NOT NULL,
 lesson_id INT NOT NULL
);

ALTER TABLE lesson_instrument ADD CONSTRAINT PK_lesson_instrument PRIMARY KEY (id);


ALTER TABLE instrument_stock ADD CONSTRAINT FK_instrument_stock_0 FOREIGN KEY (instrument_id) REFERENCES instrument (id);


ALTER TABLE lesson_price ADD CONSTRAINT FK_lesson_price_0 FOREIGN KEY (lesson_discount_id) REFERENCES lesson_discount (id);


ALTER TABLE student ADD CONSTRAINT FK_student_0 FOREIGN KEY (person_id) REFERENCES person (id);


ALTER TABLE instructor ADD CONSTRAINT FK_instructor_0 FOREIGN KEY (person_id) REFERENCES person (id);


ALTER TABLE lesson_schedule ADD CONSTRAINT FK_lesson_schedule_0 FOREIGN KEY (instructor_id) REFERENCES instructor (id);
ALTER TABLE lesson_schedule ADD CONSTRAINT FK_lesson_schedule_1 FOREIGN KEY (lesson_price_id) REFERENCES lesson_price (id);


ALTER TABLE person_phone ADD CONSTRAINT FK_person_phone_0 FOREIGN KEY (person_id) REFERENCES person (id);
ALTER TABLE person_phone ADD CONSTRAINT FK_person_phone_1 FOREIGN KEY (phone_id) REFERENCES phone (id);


ALTER TABLE rental ADD CONSTRAINT FK_rental_0 FOREIGN KEY (student_id) REFERENCES student (id);
ALTER TABLE rental ADD CONSTRAINT FK_rental_1 FOREIGN KEY (rental_policy_id) REFERENCES rental_policy (id);
ALTER TABLE rental ADD CONSTRAINT FK_rental_2 FOREIGN KEY (instrument_id) REFERENCES instrument (id);


ALTER TABLE siblings ADD CONSTRAINT FK_siblings_0 FOREIGN KEY (student_id) REFERENCES student (id);
ALTER TABLE siblings ADD CONSTRAINT FK_siblings_1 FOREIGN KEY (sibling_id) REFERENCES student (id);


ALTER TABLE student_lesson_schedule ADD CONSTRAINT FK_student_lesson_schedule_0 FOREIGN KEY (lesson_id) REFERENCES lesson_schedule (id);
ALTER TABLE student_lesson_schedule ADD CONSTRAINT FK_student_lesson_schedule_1 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE lesson_capacity ADD CONSTRAINT FK_lesson_capacity_0 FOREIGN KEY (lesson_id) REFERENCES lesson_schedule (id);


ALTER TABLE lesson_genre ADD CONSTRAINT FK_lesson_genre_0 FOREIGN KEY (lesson_id) REFERENCES lesson_schedule (id);


ALTER TABLE lesson_instrument ADD CONSTRAINT FK_lesson_instrument_0 FOREIGN KEY (lesson_id) REFERENCES lesson_schedule (id);


