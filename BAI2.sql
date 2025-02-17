create database Bai2ss13;
use Bai2ss13;

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    price DECIMAL(10,2),
    stock INT NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT NOT NULL,
    total_price DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_name, price, stock) VALUES
('Laptop Dell', 1500.00, 10),
('iPhone 13', 1200.00, 8),
('Samsung TV', 800.00, 5),
('AirPods Pro', 250.00, 20),
('MacBook Air', 1300.00, 7);

-- 2
drop procedure order_processing;

set autocommit = 0;
DELIMITER //
create procedure order_processing(
	p_product_id int,
    p_quantity int
)
begin
	declare pro_stock decimal;
    declare message_text varchar(200);
    declare od_total_price varchar(50);
	start transaction;
    if (select count(product_id) from products where product_id = p_product_id ) = 0
    or (select count(order_id) from orders where quantity = p_quantity ) = 0
    then
		set message_text = 'Sản phẩm không tồn tại';
	else 
    select stock into pro_stock from employees where product_id = p_product_id ;
    
    select total_price into od_total_price from orders where quantity = p_quantity;
    
    if(pro_stock < p_quantity)
    then set message_text = 'Số lượng trong kho ko đủ';
    rollback;
    
    else
    insert into orders(product_id, quantity, total_price)
	values(p_product_id, p_quantity, od_total_price);
    
    update products
    set stock = stock - p_quantity where product_id = p_product_id;
    
    commit;
    end if;
    end if;
end;

// DELIMITER //
