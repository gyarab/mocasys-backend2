INSERT INTO users_current (username) VALUES
    ('tester1'),
    ('tester2');

INSERT INTO user_permissions_current (id_user, permission) VALUES
    (1, 'user_permissions.select.self'),
    (2, 'user_permissions.select.self'),
    (1, 'users.select.all'),
    (1, 'people.select.all'),
    (1, 'people.modify.all');

SELECT session_user_set(1);

INSERT INTO people (name, birth_date) VALUES
    ('Tester 1', '2001-01-01'),
    ('Tester 2', '2002-02-02');

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
