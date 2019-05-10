CREATE OR REPLACE FUNCTION user_mifare_cards_access_key_by_id(_id bytea)
RETURNS bytea
SECURITY DEFINER
LANGUAGE plpgsql AS $func$
BEGIN
    IF NOT perm('user_mifare_cards.select.access_key') THEN
        RAISE EXCEPTION
            'Permission denied on call to user_mifare_cards_access_key_by_id';
    END IF;
    RETURN (
        SELECT access_key FROM user_mifare_cards_current
        WHERE card_id = _id);
END;
$func$;

CREATE OR REPLACE FUNCTION diner_balance(_id integer) RETURNS decimal
LANGUAGE SQL AS $$
    SELECT SUM(amount) FROM diner_transactions
    WHERE id_diner = _id;
$$;
