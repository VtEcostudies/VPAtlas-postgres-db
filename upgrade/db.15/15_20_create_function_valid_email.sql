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

SELECT 'vicky@gmavt.net', valid_email('vicky@gmavt.net'), 'trash.com', valid_email('trash.com')