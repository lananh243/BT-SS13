use Bai4ss13;

-- 2
create table enrollments_history (
	history_id int primary key auto_increment,
    student_id int,
    foreign key(student_id) references students(student_id),
    course_id int,
    foreign key(course_id) references courses(course_id),
    action varchar(50),
    timestamp datetime default now()
) engine = 'MyISAM';

drop procedure Register_course;

-- 3
set autocommit = 0;
DELIMITER //
create procedure Register_course (
	p_student_name varchar(50),
    p_course_name varchar(100)
)
begin
	declare c_available_seats int;
    declare s_student_id int;
    declare c_course_id int;
    declare action_message varchar(150);
	start transaction;
    select available_seats, course_id into c_available_seats, c_course_id from courses c where c.course_name = p_course_name;
	select student_id into s_student_id from students s where s.student_name = p_student_name;
    
    if c_course_id = 0 then 
		rollback;
	else
		if c_available_seats > 0 then
			insert into enrollments(student_id, course_id)
			values(s_student_id, c_course_id);
			
			update courses
			set available_seats = available_seats - 1;
            
            insert into enrollments_history(student_id, course_id, action, timestamp)
            values(s_student_id, c_course_id,'Register', now());
            
            commit;
		else
			insert into enrollments_history(student_id, course_id, action, timestamp, warning)
            values(s_student_id, c_course_id,'Fail', now(), 'Đăng kí thất bại do hết chỗ');
            
            rollback;
		end if;
	end if;
end;
// DELIMITER //

-- 4

call Register_course('Nguyễn Văn b', 'Cơ sở dữ liệu');

-- 5
select * from students;
select * from courses;
select * from enrollments;
select * from enrollments_history;

