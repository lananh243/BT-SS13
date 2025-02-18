create database bai1_ss13;
use bai1_ss13;

create table accounts (
	account_id int primary key auto_increment,
    account_name varchar(50),
    balance decimal(10, 2)
);

INSERT INTO accounts (account_name, balance) VALUES 

('Nguyễn Văn An', 1000.00),

('Trần Thị Bảy', 500.00);

-- 3
set autocommit = 0;
DELIMITER //
create procedure Stored_Procedure (
	from_account int,
    to_account int,
    amount decimal(10, 2)
)

begin
	declare log_message varchar(200);
	declare from_balance decimal;
	start transaction;
    if (select count(account_id) from accounts a where a.account_id = from_account) = 0
    or (select count(account_id) from accounts a where a.account_id = to_account) = 0
    then
		insert into accounts(log_message)
        values('Lỗi Tài khoản ko hợp lệ');
        rollback;
	else
	select balance into from_balance from accounts a where a.account_id = from_account;
    	if from_balance < amount then
	insert into accounts(log_message)
		values('Lỗi Số dư ko đủ');
		rollback;
   	else
	
	update accounts
    set balance = balance - amount
    where account_id = from_account;
    
    update accounts 
    set balance = balance + amount
    where account_id = to_account;
    
    commit;
	end if;
    	end if;
end;
// DELIMITER //

-- 4
select * from accounts;

call Stored_Procedure(2, 1, 500.00);



