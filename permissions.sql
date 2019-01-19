-- Populate permission table
CREATE TYPE perm_decl AS (
    id integer,
    name text
);
DO $$
    DECLARE
        perms perm_decl[] := ARRAY[
            (1, 'users.select.all'),
            (2, 'users.select.self'),
            (3, 'users.modify.self'),
            (4, 'users.modify.all'),
            (5, 'people.select.all'),
            (6, 'people.select.self'),
            (7, 'people.modify.self'),
            (8, 'people.modify.all'),
            (9, 'user_permissions.both.all'),
            (10, 'user_permissions.select.self')
        ];
    BEGIN
        INSERT INTO permissions (id, name)
            SELECT * FROM unnest(perms)
            WHERE NOT EXISTS (SELECT FROM permissions WHERE permissions.id = id);
    END;
$$;

SELECT dascore_setup_table('users',
    select_perm := $$
        session_user_has_permission('users.select.all')
        OR (session_user_has_permission('users.select.self')
            AND session_user_get() = id)
    $$,
    insert_perm := $$ session_user_has_permission('users.modify.all') $$,
    delete_perm := $$ session_user_has_permission('users.modify.all') $$,
    update_perm := $$
        session_user_has_permission('users.modify.all')
        OR (session_user_has_permission('users.modify.all')
            AND new.id IS NULL)
    $$);

SELECT dascore_setup_table('user_permissions',
    select_perm := $$
        session_user_has_permission('user_permissions.both.all')
        OR (session_user_has_permission('user_permissions.select.self')
            AND ROW.id_user = session_user_get())
    $$,
    modify_perm := $$
        session_user_has_permission('user_permissions.both.all')
    $$);

SELECT dascore_setup_table('people',
    select_perm := $$
        session_user_has_permission('people.select.all')
        OR (session_user_has_permission('people.select.self')
            AND false) -- TODO
    $$,
    modify_perm := $$
        session_user_has_permission('people.modify.all')
        OR (session_user_has_permission('people.modify.self')
            AND false) -- TODO
    $$);
