create table planes (
    id serial primary key,
    type varchar(128) unique not null,
    produced_by varchar(128) not null,
    num_sells bigint not null
);

insert into planes(type, produced_by, num_sells)
values
    ('a320', 'Airbus', 63000),
    ('b737', 'Boeing', 8999),
    ('b787', 'Boeing', 900000),
    ('Tu 214', 'Tupolev', 100);