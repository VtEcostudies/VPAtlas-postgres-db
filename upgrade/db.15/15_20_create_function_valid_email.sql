--Function to validate incoming email format before trying to use it to find or
--automatically register missing users
--DROP FUNCTION IF EXISTS valid_email(text);
CREATE OR REPLACE FUNCTION valid_email(e_mail text)
	RETURNS BOOLEAN
	LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	IF (e_mail ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$')
	THEN RETURN 1;
	ELSE RETURN 0;
	END IF;
END;
$BODY$;
