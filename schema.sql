CREATE TABLE club_members (
    member_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    email varchar(255) NOT NULL,
    major varchar(100),
    join_date date NOT NULL
);