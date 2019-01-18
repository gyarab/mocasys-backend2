INSERT INTO people (name, birth_date) VALUES
	('Tester 1', '2001-01-01'),
	('Tester 2', '2002-02-02');

INSERT INTO users (username, id_person) VALUES
	('tester1', 1),
	('tester2', 2);

INSERT INTO user_permissions (id_user, id_permission) VALUES
	(1, 10),
	(2, 10),
	(1, 1);

DROP OWNED BY viewowner;
DROP ROLE IF EXISTS viewowner;
CREATE ROLE viewowner;

DROP OWNED BY uptest;
DROP ROLE IF EXISTS uptest;
CREATE ROLE uptest WITH LOGIN PASSWORD 'uptestpw';
GRANT USAGE ON SCHEMA public TO uptest;
GRANT ALL ON TABLE users TO uptest;
GRANT ALL ON TABLE users_current TO uptest;
GRANT ALL ON TABLE users_history TO uptest;
GRANT ALL ON TABLE people TO uptest;
GRANT ALL ON TABLE permissions TO uptest;
GRANT ALL ON TABLE user_permissions TO uptest;
