INSERT INTO people_current (name, birth_date) VALUES
    ('Tester 1', '2001-01-01'),
    ('Tester 2', '2002-02-02');

INSERT INTO users_current (id, username, id_person) VALUES
    (1, 'tester1', 1),
    (2, 'tester2', 2),
    (3, 'servterm', null);

INSERT INTO user_passwords_data VALUES
    -- PASSWORD: 1234567890
    (1, '736372797074000e0000000800000001b9956625cadd6f7f1384ac244753bc584a422dd866d38c64999af791115e7d1a84d56551ea3668fb6c4b3f52b0f38b44356226b23d21b3e1dc8e6f17b68599a99fd98cf6784c1fdb41c978feef72597b'),
    -- PASSWORD: 0987654321
    (2, '736372797074000e0000000800000001f4e54bfa5a0b93e49045ead906af835cc4a876cfab127b9f51f0b4f45c4c84046a4fe6b306ed578443f944c2c1b2f57d4248fe50aa839c4ff3592f58f3988fb11be190cb67318cf6e6416e622cd0ad29');

INSERT INTO user_permissions_current (id_user, permission) VALUES
    (1, 'user_permissions.select.self'),
    (2, 'user_permissions.select.self'),
    (1, 'users.select.all'),
    (1, 'users.modify.all'),
    (1, 'people.select.all'),
    (1, 'people.modify.all'),
    (1, 'user_passwords.select.all'),
    (1, 'user_passwords.modify.self'),
    (3, 'user_mifare_cards.select.access_key'),
    (1, 'diners.select.self'),
    (1, 'food.select'),
    (1, 'food_choice.select.self'),
    (1, 'food_assignments.select');

INSERT INTO diners_current (id_person, account_balance) VALUES
    (1, 100::money),
    (2, 200::money);

INSERT INTO food_current (name) VALUES
    ('Tofu s tofu alá tofu'),
    ('Babiččiny sušenky');

INSERT INTO food_assignments_current (day, kind, id_food) VALUES
    ('2019-04-21', 'main_course', 1),
    ('2019-04-21', 'dessert', 2);

SELECT session_user_set(1, 'secret');

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
GRANT ALL ON TABLE diners TO uptest;
GRANT ALL ON TABLE food TO uptest;
GRANT ALL ON TABLE food_assignments TO uptest;
GRANT ALL ON TABLE food_choice TO uptest;
