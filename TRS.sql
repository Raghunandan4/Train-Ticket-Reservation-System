/* Train Ticket Reservation System */
create table train (t_no integer primary key not null, t_name char(15) not null, t_type char not null, arr_time varchar(7), dept_time varchar(7));

insert into train values(12601, 'Sampark', 'p', '4:00pm', '4:03pm');
insert into train values(15781, 'Point Loads', 'g', '2:00am', '2:15pm');
insert into train values(11291, 'Shatabdi', 'p', '6:00am', '6:05am');
insert into train values(10394, 'Rajdhani', 'p', '8:40am', '9:00am');

select * from train ;


create table ticket (pnr_no bigint primary key not null, p_name char(15) not null, train_no integer not null, seat_no varchar(4), date_time date);

insert into ticket values(8602158775, 'ramlal', 12601, '30A', '2022-11-04');
insert into ticket values(4442227187, 'siddharth', 11291, '50B', '2022-11-04');
insert into ticket values(2522338701, 'babu rao', 10394, '112C', '2022-11-04');
insert into ticket values(3478844201, 'ashwini', 11291, '62A', '2022-11-04');

select * from ticket ;


create table t_user (username varchar(15) primary key not null, age integer, dob date, gender char, mobile_no bigint not null);

insert into t_user values('ramlal16', 42, '1980-06-12', 'm', 7466289756);
insert into t_user values('sid_95', 20, '2002-04-19', 'm', 1926549378);
insert into t_user values('babur2936', 36, '1985-12-10', 'm', 3642864529);
insert into t_user values('ashw1n12001', 26, '1996-02-06', 'f', 4268566329);

select * from t_user ;


create table payment (transaction_id varchar(20) primary key not null, username varchar(15) not null, card_no varchar(19) not null, bank_name char(10), amount integer not null);

insert into payment values('3CW4925C715314', 'ramlal16', '3762-7834-2753-8827', 'bob', 150);
insert into payment values('1RY82308WC6613', 'sid_95', '1863-7712-2384-8912', 'hdfc', 275);
insert into payment values('40S03358550824', 'babur2936', '2894-7325-1922-5033', 'kotakm', 130);
insert into payment values('137F84Y6531865', 'ashw1n12001', '2342-3478-9912-0429', 'icici', 260);

select * from payment ;


create table route (station_code varchar(4) primary key not null, stop_name varchar(20));

insert into route values('NDLS', 'Delhi junction');
insert into route values('MMCT', 'Mumbai Central');
insert into route values('PUNE', 'Pune junction');
insert into route values('BZA', 'Vijayawada junction');
insert into route values('MAO', 'Madgaon junction');
insert into route values('MAS', 'Chennai junction');
insert into route values('MYS', 'Mysuru junction');

select * from route ;


alter table ticket add t_name char(15);
select t_name from ticket ;

insert into ticket values(1975622938, 'rane', 20607, '10B', '2022-11-05', 'vande bharat');
select * from ticket ;

alter table train alter column t_name drop not null;

alter table t_user drop column age;
select * from t_user ; 

alter table route rename column stop_name to station_name;
select station_name from route ;

drop table route;

update payment set amount = 240 where transaction_id ='137F84Y6531865';
select amount from payment where transaction_id ='137F84Y6531865';

update train set t_name = 'Bangalore Mail' where t_no = 15781;
select t_name from train where t_no = 15781;

update train set dept_time = '8:55am' where t_no = 10394;
select dept_time from train where t_no = 10394;

update ticket set t_name = 'Sampark' where train_no = 12601;
update ticket set t_name = 'Shatabdi' where train_no = 11291;
update ticket set t_name = 'Bangalore Mail' where train_no = 15781;
update ticket set t_name = 'Rajdhani' where train_no = 10394;
select * from ticket;

select arr_time from train group by t_no;

select age from t_user group by age having age > 30;

select stop_name from route group by station_code;

select max(amount) as amount from payment;

select sum(amount) as total_amt from payment;

select * from train 
where exists (select * from ticket 
			 where train.t_no = ticket.pnr_no);

select mobile_no 
from t_user 
where username in ('ramlal16', 'babur2936');

select transaction_id 
from payment 
where bank_name not in ('icici');

select * from payment 
where amount between 100 and 160;

select t_name, t_no 
from train 
where t_name like '_a%';

select distinct t_type from train;

create view train_view as
select t_no, t_type
from train
where t_type = 'p';

select * from train_view ;

create view pay_view as
select transaction_id, username, amount
from payment
where amount > 200;

select * from pay_view ;

drop view train_view;

create trigger T1
on t_user
for update
as if (select age from inserted) < 19
print 'Please Update with proper Age'
rollback ;

update t_user
set age = 18
where username = 'sid_95' ;

drop trigger T1 ;

update t_user
set age = 18
where username = 'sid_95' ;
select * from t_user ;

update t_user
set dob = '2004-04-19'
where username = 'sid_95' ;
select * from t_user ;

explain analyse select * from ticket;

explain analyse select * from route where station_code like 'M%';

explain analyse select * from payment 
where amount < 170 order by transaction_id;

explain analyse select train.t_no, ticket.seat_no from train
inner join ticket on train.t_name = ticket.seat_no;

explain analyse select max(amount), min(amount), avg(amount) from payment;

explain analyse select station_code, stop_name from route
intersect
select station_code, stop_name from route

/* ~~(foreign key = pnr_no) for train~~ */

explain select * from train where t_no = 12601;
create index foreign_index on ticket(pnr_no);
explain select * from ticket where pnr_no = 8602158775;
drop index foreign_index;

/*~~(composite key = username, mobile_no) for t_user~~ */

explain select * from t_user where username = 'babur2936';
create index composite_index on t_user(mobile_no);
explain select * from t_user where username = 'babur2936';
drop index composite_index;

/* ~~(secondary key = username) for payment~~ */

explain select * from payment where username = 'ramlal';
create index secondary_index on payment(username);
explain select * from payment where username = 'ramlal';
drop index secondary_index;

begin transaction;
delete from train
where t_type = 'g';
select * from train;

rollback;
select * from train;

begin transaction;
update ticket set date_time = '2022-12-01'
where train_no = 10394;
select * from ticket;

begin transaction;
update route set stop_name = 'M.G.R Central'
where station_code = 'MAS';
select station_code, stop_name from route where station_code = 'MAS';

begin transaction;
delete from route
where station_code = 'MYS';
select station_code, stop_name from route where station_code = 'MYS';

rollback;
select * from route;
