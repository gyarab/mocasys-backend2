-- Populate permission table
DO $$
    DECLARE
        perms text[] := ARRAY[
            'users.select.all',
            'users.select.self',
            'users.modify.all',
            'users.modify.self',

            'people.select.all',
            'people.select.self',
            'people.modify.all',
            'people.modify.self',

            'user_permissions.both.all',
            'user_permissions.select.self',

            'user_passwords.select.all',
            'user_passwords.select.self',
            'user_passwords.modify.all',
            'user_passwords.modify.self',

            'user_mifare_cards.select',
            'user_mifare_cards.select.access_key',
            'user_mifare_cards.modify',

            'food.select',
            'food.modify',

            'food_assignments.select',
            'food_assignments.modify',

            'diners.select.all',
            'diners.select.self',
            'diners.modify.all',

            'food_choice.select.all',
            'food_choice.select.self',
            'food_choice.modify.all',
            'food_choice.modify.self'
        ];
    BEGIN
        INSERT INTO permissions (name)
            SELECT * FROM unnest(perms)
            WHERE NOT EXISTS (SELECT FROM permissions WHERE permissions.name = name);
    END;
$$;

-- A simple alias for session_user_has_permission() to make permission
-- expressions less long and ugly. It unfortunately needs to be global.
-- TODO: Better name?
CREATE OR REPLACE FUNCTION perm(perm_name text) RETURNS boolean
LANGUAGE SQL AS $$
    SELECT session_user_has_permission(perm_name)
$$;

SELECT dascore_setup_table('users',
    select_perm := $$
        perm('users.select.all')
        OR (perm('users.select.self') AND ROW.id = session_user_get())
    $$,
    modify_perm := $$
        perm('users.modify.all')
        OR (perm('users.modify.self') AND ROW.id = session_user_get())
    $$);

CREATE OR REPLACE FUNCTION session_person_get() RETURNS integer
LANGUAGE SQL AS $$
    -- TODO: For purposes of permissions, should we select from the combined
    -- view or the _current table?
    SELECT id_person FROM users WHERE id = session_user_get()
$$;

SELECT dascore_setup_table('user_permissions',
    select_perm := $$
        perm('user_permissions.both.all')
        OR (perm('user_permissions.select.self')
            AND ROW.id_user = session_user_get())
    $$,
    modify_perm := $$
        perm('user_permissions.both.all')
    $$);

SELECT dascore_setup_table_unversioned('user_passwords',
    select_perm := $$
        perm('user_passwords.select.all')
        OR (perm('user_passwords.select.self')
            AND ROW.id_user = session_user_get())
    $$,
    modify_perm := $$
        perm('user_passwords.modify.all')
        OR (perm('user_passwords.modify.self')
            AND ROW.id_user = session_user_get())
    $$
);

SELECT dascore_setup_table('user_mifare_cards',
    select_perm := $$ perm('user_mifare_cards.select') $$,
    modify_perm := $$ perm('user_mifare_cards.modify') $$);

SELECT dascore_setup_table('people',
    select_perm := $$
        perm('people.select.all')
        OR (perm('people.select.self') AND ROW.id = session_person_get())
    $$,
    modify_perm := $$
        perm('people.modify.all')
        OR (perm('people.modify.self') AND ROW.id = session_person_get())
    $$);

SELECT dascore_setup_table('food',
    select_perm := $$ perm('food.select') $$,
    modify_perm := $$ perm('food.modify') $$);

SELECT dascore_setup_table('food_assignments',
    select_perm := $$ perm('food_assignments.select') $$,
    modify_perm := $$ perm('food_assignments.modify') $$);

SELECT dascore_setup_table('diners',
    select_perm := $$
        perm('diners.select.all')
        OR (perm('diners.select.self')
            AND ROW.id_person = session_person_get())
    $$);

SELECT dascore_setup_table('food_choice',
    select_perm := $$
        perm('food_choice.select.all')
        OR (perm('food_choice.select.self')
            AND ROW.id_diner = session_person_get())
    $$,
    modify_perm := $$
        perm('food_choice.modify.all')
        OR (perm('food_choice.modify.self')
            AND ROW.id_diner = session_person_get()
            -- TODO: Allow choosing delay and separate change of meal and
            -- cancellation for the day.
            AND ROW.day >= current_date + '1 day'::interval)
    $$);
