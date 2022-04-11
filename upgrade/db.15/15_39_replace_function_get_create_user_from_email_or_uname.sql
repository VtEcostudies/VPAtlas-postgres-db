-- FUNCTION: public.find_or_insert_user_from_ambig_user_email_input(text)

-- DROP FUNCTION IF EXISTS public.find_or_insert_user_from_ambig_user_email_input(text);

CREATE OR REPLACE FUNCTION public.find_or_insert_user_from_ambig_user_email_input(
	u_mixt text)
    RETURNS integer
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE e_mail text;
DECLARE u_id integer;
DECLARE u_name text;
DECLARE f_name text;
DECLARE l_name text;
BEGIN
	u_mixt := btrim(u_mixt, '\"'); --trim double-quotes from names

	IF valid_email(u_mixt) THEN --validate email format
		e_mail := u_mixt; --MUST set this value to setup INSERT, below, on user NOT found here
		u_id = (SELECT "id" FROM vpuser WHERE LOWER("email")=LOWER(e_mail)); --look for user by email
	END IF;

	IF u_id IS NOT NULL THEN --found user with email
		RAISE NOTICE 'FOUND user id % with email %', u_id, e_mail;
	ELSE --look for user by username
		u_id = (SELECT "id" FROM vpuser WHERE "username"=u_mixt);
		IF u_id>0 THEN
			RAISE NOTICE 'FOUND user id % with username %', u_id, u_mixt;
		ELSE
			RAISE NOTICE 'user NOT found with username %', u_mixt;
		END IF;
	END IF;

	IF u_id IS NULL AND e_mail IS NOT NULL THEN --user NOT found with incoming email/username. create user.
		u_name := SPLIT_PART(e_mail, '@', 1);
		f_name := SPLIT_PART(e_mail, '@', 1);
		l_name := SPLIT_PART(e_mail, '@', 1);
		INSERT INTO vpuser (
			"username", "firstname", "lastname", "email", "hash", "userrole", "status"
		) VALUES (
			u_name, f_name, l_name, e_mail, '999999', 'user', "auto-gen"
		) RETURNING id INTO u_id;
		RAISE NOTICE 'INSERTED new user id % with username % and email %', u_id, u_name, e_mail;
	END IF;

	RETURN u_id;
END;
$BODY$;

ALTER FUNCTION public.find_or_insert_user_from_ambig_user_email_input(text)
    OWNER TO vpatlas;
