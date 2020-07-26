drop table orders cascade;

create table if not exists orders
(
	id varchar(50) not null,
	promocode_id int,
	constraint pk_orders primary key (id)
);

insert into orders (id, promocode_id) 
values
	('JAN-19569', '8'),
	('JAN-19570', '6'),
	('JAN-19571', null),
	('JAN-19572', null),
	('JAN-19573', '6'),
	('JAN-19574', '3'),
	('JAN-19575', '7'),
	('JAN-19576', '3'),
	('JAN-19577', '4'),
	('JAN-19578', '2'),
	('JAN-19579', '5'),
	('JAN-19580', '1'),
	('JAN-19581', '1'),
	('JAN-19582', '1'),
	('JAN-19583', '3');

select * from orders;

drop table promocodes cascade;

create table if not exists promocodes
(
	id int,
	name varchar(50),
	discount numeric(8,2),
	constraint pk_promocodes primary key (id)
);

 insert into promocodes (id, name, discount) 
 values
	('1', 'INST-4015', '200'),
	('2', 'REF-3010', '300'),
	('3', 'VLLG-02', '250'),
	('4', 'REF-3007', '300'),
	('5', 'REF-3015', '300'),
	('6', 'AFSHA-34', '250'),
	('7', 'REF-3005', '300'),
	('8', 'REF-3006', '300');
	
select * from promocodes;

select o.id, p.name, p.discount
from orders o
left join promocodes p
	on o.promocode_id = p.id;

--share of orders with promocodes
select 1.0*with_promocode/total_orders as share_with_promocode 
from 
(
	select 
		count(*) as total_orders,
		sum(case when name is null then 1 else 0 end) as no_promocode,
		count(name) as with_promocode
	from
	(
		select o.id, p.name, p.discount
		from orders o
		left join promocodes p
			on o.promocode_id = p.id
	) t1
) t2;

-- promocode with the greatest total spending
select 
	promocode_name,
	total_spending
from
(
	select 
		name as promocode_name,
		sum(discount) as total_spending,
		count(name) as times_used
	from
	(
		select o.id, p.name, p.discount
		from orders o
		left join promocodes p
			on o.promocode_id = p.id
	) t1
	group by 1
	having sum(discount) is not null
	order by 2 desc
) t2
limit 1;