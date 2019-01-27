-- Populate permission table
DO $$
    DECLARE
        perms text[] := ARRAY[
            'users.select.all',
            'users.select.self',
            'users.modify.self',
            'users.modify.all',
            'people.select.all',
            'people.select.self',
            'people.modify.self',
            'people.modify.all',
            'user_permissions.both.all',
            'user_permissions.select.self'
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
        OR (perm('users.select.self') AND session_user_get() = id)
    $$,
    insert_perm := $$ perm('users.modify.all') $$,
    delete_perm := $$ perm('users.modify.all') $$,
    update_perm := $$
        perm('users.modify.all')
        OR (perm('users.modify.all') AND NEW.id IS NULL)
    $$);

SELECT dascore_setup_table('user_permissions',
    select_perm := $$
        perm('user_permissions.both.all')
        OR (perm('user_permissions.select.self')
            AND ROW.id_user = session_user_get())
    $$,
    modify_perm := $$
        perm('user_permissions.both.all')
    $$);

SELECT dascore_setup_table('people',
    select_perm := $$
        perm('people.select.all')
        OR (perm('people.select.self') AND false) -- TODO
    $$,
    modify_perm := $$
        perm('people.modify.all')
        OR (perm('people.modify.self') AND false) -- TODO
    $$);
