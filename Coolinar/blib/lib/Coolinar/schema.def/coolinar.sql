PRAGMA foreign_keys = ON;

--
-- Recipes table
-- 
-- left out fields: 
--     - ingredients
--     - users who creates it
--
create table recipes (
       id integer primary key autoincrement,
       name varchar(128) not null,
       desc text not null,
       img blob,
       thumbnail blob,
       when_created timestamp not null default current_timestamp,
       when_updated timestamp not null default current_timestamp
);

create table roles (
       id integer primary key autoincrement,
       role varchar(32) not null,
       desc text
);

create table users (
       id integer primary key autoincrement,
       name varchar(32),
       -- left out: address/user info, user stat
       pass varchar(32),
       r_id int references roles(id),
       when_created timestamp not null default current_timestamp,
       when_updated timestamp not null default current_timestamp
);


create table comments (
       id integer primary key  autoincrement,
       u_id int references users(id),
       r_id int references recipes(id),
       rate int,
       post text,
       when_posted timestamp not null default current_timestamp
);

--
-- TODO: multiple recipe authors support
--
create table recipe_author (
       r_id int references recipes(id),
       u_id int references users(id)
);

insert into roles(id, role) values(1, 'guest');
insert into roles(id, role) values(2, 'user' );
insert into roles(id, role) values(3, 'admin');

insert into users(name, pass, r_id) values( 'guest',  'guest',  2 );
insert into users(name, pass, r_id) values( 'guest1', 'guest1', 2 );

insert into recipes(name, desc) values( 'Бутерброд (с белым хлебом)', 'Берём буханку, отрезаем ломтик (не менее 3 см в ширину), намазываем масло, кладём сверху заготовленную котлету (см рецепт по приготовлению котлет по киевски)');
insert into recipes(name, desc) values( 'Чай', 'Греем воду (не менее 300 мл) до состояния кипения, устанавливаем покетик с чаем в кружку, таким образом чтобы нить с захватом оставалась вне кружки, наливаем в кружку подогретую воду. Не долеваем до бортика (края) кружки несколько сантиметорв. По желанию добовляем сахар, но не более двух ложек. Подождать несколько минут, пока температура воды понизится, а чай зварится.');
insert into recipes(name, desc) values( 'Хот-Дог', 'Очень долго рассказывать, но варим несколко минут сосиску, затем берём булку, разрезаем на две части (вдоль), кладём в неё упомянутую сосиску, льём сверху кетчуп');

--
-- Local Variables:
-- coding: utf-8
-- End:
-- 