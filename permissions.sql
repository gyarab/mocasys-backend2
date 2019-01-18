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

ALTER TABLE users_current ENABLE ROW LEVEL SECURITY;
ALTER TABLE users_history ENABLE ROW LEVEL SECURITY;
SELECT table_clear_policies('users_current');
SELECT table_clear_policies('users_history');

-- TODO: Create a way for this common pattern to be abstracted
CREATE POLICY users_per_session_select ON users_current FOR SELECT USING (
    (session_user_has_permission('users.select.self')
		AND (id = session_user_get()))
	OR session_user_has_permission('users.select.all'));

CREATE POLICY users_per_session_update ON users_current FOR UPDATE USING (
    (session_user_has_permission('users.modify.self')
		AND (id = session_user_get()))
	OR session_user_has_permission('users.modify.all'));

CREATE POLICY users_per_session_select ON users_history FOR SELECT USING (
    (session_user_has_permission('users.select.self')
		AND (id = session_user_get()))
	OR session_user_has_permission('users.select.all'));

CREATE POLICY users_per_session_update ON users_history FOR UPDATE USING (
    (session_user_has_permission('users.modify.self')
		AND (id = session_user_get()))
	OR session_user_has_permission('users.modify.all'));

/*
ALTER TABLE people ENABLE ROW LEVEL SECURITY;
SELECT table_clear_policies('people');

CREATE POLICY people_per_session_select ON people FOR SELECT USING (
	(session_user_has_permission('people.select.self')
		AND (SELECT users.id FROM users WHERE id_person = people.id)
			= session_user_get())
	OR session_user_has_permission('people.select.all'));

CREATE POLICY people_per_session_update ON people FOR UPDATE USING (
	(session_user_has_permission('people.select.self')
		AND (SELECT users.id FROM users WHERE id_person = people.id)
			= session_user_get())
	OR session_user_has_permission('people.select.all'));


ALTER TABLE user_permissions ENABLE ROW LEVEL SECURITY;
SELECT table_clear_policies('user_permissions');

CREATE POLICY user_permissions_both ON user_permissions USING (
	session_user_has_permission('user_permissions.both.all'));

CREATE POLICY user_permissions_both ON user_permissions FOR SELECT USING (
	session_user_has_permission('user_permissions.select.self')
		AND (id_user = session_user_get()));
*/
