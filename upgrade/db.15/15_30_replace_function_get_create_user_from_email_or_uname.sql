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
		u_id = (SELECT "id" FROM vpuser WHERE "email"=e_mail); --look for user by email
	END IF;

	IF u_id IS NOT NULL THEN --found user with email
		RAISE NOTICE 'FOUND user id % with email %', u_id, e_mail;
	ELSE --look for user by username
		u_id = (SELECT "id" FROM vpuser WHERE "username"=u_mixt);
		IF u_id>0 THEN
			RAISE NOTICE 'FOUND user id % with username %', u_id, u_mixt;
		ELSE
			RAISE NOTICE 'user NOT found with username %', u_mixt;
/*
			--DON'T DO THIS. There is no uniqueness constraint on fname, lname. This can find the wrong user.
			f_name := SPLIT_PART(u_mixt, ' ', 1);
			l_name := SPLIT_PART(u_mixt, ' ', 2);
			u_id = (SELECT "id" FROM vpuser WHERE "firstname"=f_name AND "lastname"=l_name);
			IF u_id>0 THEN
				RAISE NOTICE 'FOUND user id % with firstname % and lastname %', u_id, f_name, l_name;
			ELSE
				RAISE NOTICE 'user NOT found with firstname % and lastname %', f_name, l_name;
			END IF;
*/
		END IF;
	END IF;

	IF u_id IS NULL AND e_mail IS NOT NULL THEN --user NOT found with incoming email/username. create user.
		u_name := SPLIT_PART(e_mail, '@', 1);
		f_name := SPLIT_PART(e_mail, '@', 1);
		l_name := SPLIT_PART(e_mail, '@', 1);
		INSERT INTO vpuser (
			"username", "firstname", "lastname", "middleName", "email", "hash", "userrole"
		) VALUES (
			u_name, f_name, l_name, 'auto-gen', e_mail, '999999', 'user'
		) RETURNING id INTO u_id;
		RAISE NOTICE 'INSERTED new user id % with username % and email %', u_id, u_name, e_mail;
	END IF;

	RETURN u_id;
END;
$BODY$;

ALTER FUNCTION public.find_or_insert_user_from_ambig_user_email_input(text)
    OWNER TO vpatlas;
