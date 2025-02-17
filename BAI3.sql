create database Bai3ss13;
use Bai3ss13;

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

drop procedure transfer_salary_to_employees;
-- 2
set autocommit = 0;
DELIMITER //

create procedure transfer_salary_to_employees(p_emp_id int)
begin
	declare error_report varchar(200);
    declare emp_salary decimal;
    declare com_balance decimal;
    declare system_status int;
	start transaction;
    
    select salary into emp_salary from employees where emp_id = p_emp_id;
    select balance into com_balance from company_funds ;
    if emp_salary > com_balance
		then set error_report = 'Số dư quỹ ko đủ trả lương';
	rollback;
    else
    
    update company_funds
    set balance = balance - emp_salary;
    
    insert into payroll(emp_id, salary, pay_date, error_report)
    value(p_emp_id, emp_salary, curdate(), 'Lương đã đc trả');
    
    if system_status = 0 then
    set error_report = 'Hệ thống ngân hàng gặp lỗi';
    update company_funds
    set balance = balance + emp_salary;
    rollback;
    
    commit;
    end if;
    end if;
    
end;
// DELIMITER //

select * from company_funds;
select * from employees;
select * from payroll;

alter table payroll add column error_report varchar(255);
-- 3
call transfer_salary_to_employees(5);
