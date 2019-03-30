-- People

CREATE TABLE IF NOT EXISTS people_current (
    id serial PRIMARY KEY,
    name text NOT NULL,
    birth_date date NOT NULL
);
SELECT version_table('people');

-- DASCore tables

CREATE TABLE IF NOT EXISTS users_current (
    id serial PRIMARY KEY,
    username text NOT NULL,
    id_person integer REFERENCES people_current
);
SELECT version_table('users');

CREATE TABLE IF NOT EXISTS permissions (
    name text PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS user_permissions_current (
    id_user integer REFERENCES users_current NOT NULL,
    permission text REFERENCES permissions NOT NULL,
    PRIMARY KEY (id_user, permission)
);
SELECT version_table('user_permissions');

-- Auth

CREATE TABLE IF NOT EXISTS user_passwords_data (
    id_user integer REFERENCES users_current,
    pw_hash text NOT NULL,
    PRIMARY KEY (id_user)
);

-- Food

CREATE TABLE IF NOT EXISTS food_current (
    id serial PRIMARY KEY,
    name text NOT NULL
);
SELECT version_table('food');

CREATE TABLE IF NOT EXISTS food_assignments_current (
    id_food integer REFERENCES food_current,
    day date,
    kind text, -- TODO: Naming? Another table?
    PRIMARY KEY (id_food, day, kind)
);
SELECT version_table('food_assignments');

CREATE TABLE IF NOT EXISTS diners_current (
    id_person integer REFERENCES people_current,
    account_balance money NOT NULL DEFAULT 0::money,
    PRIMARY KEY (id_person)
);
SELECT version_table('diners');

CREATE TABLE IF NOT EXISTS food_choice_current (
    id_diner integer REFERENCES diners_current,
    day date,
    kind text,
    PRIMARY KEY (id_diner, day, kind)
);
SELECT version_table('food_choice');
