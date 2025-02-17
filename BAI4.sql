create database Bai4ss13;
use Bai4ss13;

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(50)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    available_seats INT NOT NULL
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
INSERT INTO students (student_name) VALUES ('Nguyễn Văn An'), ('Trần Thị Ba');

INSERT INTO courses (course_name, available_seats) VALUES 
('Lập trình C', 25), 
('Cơ sở dữ liệu', 22);

drop procedure Register_for_the_course;
-- 2
set autocommit = 0;
DELIMITER //
create procedure Register_for_the_course(
	p_student_name varchar(50),
    p_course_name varchar(100)
)
begin
	declare c_available_seats int;
    declare s_student_id int;
    declare c_course_id int;
	start transaction;
    select available_seats, course_id into c_available_seats, c_course_id  from courses c where c.course_name = p_course_name;
    select student_id into s_student_id from students s where s.student_name = p_student_name;

	if c_available_seats > 0 then
		insert into enrollments(student_id, course_id)
        values(s_student_id, c_course_id);
        
        update courses
        set available_seats = available_seats - 1;
        
        commit;
	else
		rollback;
	end if;
end;
// DELIMITER //

-- 3 
select * from students;
select * from courses;
select * from enrollments;
call Register_for_the_course('Nguyễn Văn An', 'Cơ sở dữ liệu');

