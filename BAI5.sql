create database b5ss13;

use b5ss13;
CREATE TABLE company_funds (
    fund_id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(15,2) NOT NULL -- Số dư quỹ công ty
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50) NOT NULL,   -- Tên nhân viên
    salary DECIMAL(10,2) NOT NULL    -- Lương nhân viên
);

CREATE TABLE payroll (
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,                      -- ID nhân viên (FK)
    salary DECIMAL(10,2) NOT NULL,   -- Lương được nhận
    pay_date DATE NOT NULL,          -- Ngày nhận lương
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);


INSERT INTO company_funds (balance) VALUES (50000.00);

INSERT INTO employees (emp_name, salary) VALUES
('Nguyễn Văn An', 5000.00),
('Trần Thị Bốn', 4000.00),
('Lê Văn Cường', 3500.00),
('Hoàng Thị Dung', 4500.00),
('Phạm Văn Em', 3800.00);


/*
1. tạo bảng transaction_log
2. tạo 1 procedure
input : employeeId
process 
1. Kiem tra employeeId có tồn tại ko
sai --> ghi log bảng transaction_log và rollback
đúng 
kiểm tra số dư của công ty (company_funds) > salary (employee -> employeeId)
- sai : ghi log bảng transaction_log và rollback
- đúng 
Trừ số dư của công ty (company_funds)
ghi dữ liệu ra paroll
ghi log trong bảng transaction_log

*/
-- 2
create table transaction_log (
	log_id int primary key auto_increment,
    log_message text not null,
    log_time timestamp default current_timestamp
) engine = 'MYISAM';

-- 3
alter table payroll add column last_pay_date date;
-- 4
drop procedure transfer_salaries_to_employee;
set autocommit = 0;
DELIMITER //
create procedure transfer_salaries_to_employee (p_emp_id int, fundID INT)
begin
declare com_balance decimal;
declare emp_salary decimal;
start transaction;
	if (select count(emp_id) from employees e where e.emp_id = p_emp_id) = 0 
		OR (select count(fund_id) from company_funds c where c.fund_id = fundID) = 0
		then
			insert into transaction_log(log_message)
			values('Mã nhân viên hoặc mã công ty ko tồn tại');
		rollback;
		if (select count(fund_id) from company_funds c where c.fund_id = fundID) = 0 then
			insert into transaction_log(log_message)
			values('Qũy không đủ tiền');
	else
    select balance into com_balance from company_funds where fund_id = fundID;
    select salary into emp_salary from employees where emp_id = p_emp_id;
    if com_balance > emp_salary then
		insert into transaction_log(log_message)
		values('Thanh toán lương thành công');
		rollback;
	else
    
    update company_funds
    set balance = balance - emp_salary where fund_id = fundID;
    
    insert into payroll(emp_id, salary, pay_date)
    values(p_emp_id, emp_salary, curdate());
    
    update payroll
    set last_pay_date = current_date();
    
    commit;
    end if;
    end if;
    end if;
end;

// DELIMITER //

select * from company_funds;
select * from employees;
select * from payroll;
select * from transaction_log;
call transfer_salaries_to_employee(2,1);
