INSERT INTO users_current (username) VALUES
    ('tester1'),
    ('tester2');

INSERT INTO user_password_data VALUES
    -- PASSWORD: 1234567890
    (1, 'b9cb04496352c66db0290aaeb50e9160aca36de4163dc665f81271bcec26bf7b:c96f0e3fdae1e7935ad7ec7a955e53bf01e6277e4bccd91c039650fe6591469d'),
    -- PASSWORD: 0987654321
    (2, 'e9e5a7fbfe75732ffe065f5838b73f43002c9e4fcbd501b9bd47a7753e2c9f2a:dc88288ff6c51110ab3cc06958d52fbce14c218b9c51c6468f1657dd9bb8d4de');

INSERT INTO user_permissions_current (id_user, permission) VALUES
    (1, 'user_permissions.select.self'),
    (2, 'user_permissions.select.self'),
    (1, 'users.select.all'),
    (1, 'people.select.all'),
    (1, 'people.modify.all'),
    (1, 'user_password.select.all'),
    (1, 'user_password.modify.self');

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
