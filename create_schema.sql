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

CREATE TABLE IF NOT EXISTS user_mifare_cards_current (
    id_user integer REFERENCES users_current,
    card_id bytea PRIMARY KEY,
    access_key bytea NOT NULL,
    secret_key bytea NOT NULL
);
SELECT version_table('user_mifare_cards');

-- Food

CREATE TABLE IF NOT EXISTS food_current (
    id serial PRIMARY KEY,
    name text NOT NULL
);
SELECT version_table('food');

CREATE TABLE IF NOT EXISTS food_assignments_current (
    day date NOT NULL,
    kind text, -- TODO: Naming? Another table?
    option text DEFAULT '',
    id_food integer REFERENCES food_current,
    PRIMARY KEY (day, kind, option)
);
SELECT version_table('food_assignments');

CREATE TABLE IF NOT EXISTS diners_current (
    id_person integer NOT NULL REFERENCES people_current,
    PRIMARY KEY (id_person)
);
SELECT version_table('diners');

CREATE TABLE IF NOT EXISTS diner_transactions_current (
	id_diner integer NOT NULL REFERENCES diners_current,
	-- Positive for money added to the diner's balance, negative for expenses
	-- taken from the balance
	amount decimal NOT NULL,
	-- Not null if a food order caused the transaction
	cause_food_day date,
	PRIMARY KEY (id_diner),
	-- Transactions caused by food orders should always be expenses or free
	CHECK (NOT (cause_food_day IS NOT NULL AND (amount > 0)))
);
SELECT version_table('diner_transactions');

CREATE TABLE IF NOT EXISTS food_choice_current (
    id_diner integer REFERENCES diners_current,
    day date NOT NULL,
    kind text,
    option text,
	ordered boolean NOT NULL DEFAULT true,
    PRIMARY KEY (id_diner, day, kind),
    FOREIGN KEY (day, kind, option)
        REFERENCES food_assignments_current (day, kind, option),
	CHECK (option IS NOT NULL = ordered)
);
SELECT version_table('food_choice');
