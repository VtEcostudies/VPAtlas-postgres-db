-- FUNCTION: public.set_visit_user_id_from_visit_user_name()

-- DROP FUNCTION IF EXISTS public.set_visit_user_id_from_visit_user_name();

CREATE OR REPLACE FUNCTION public.set_visit_user_id_from_visit_user_name()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	u_name text;
	o_name text;
	usr_id integer;
	obs_id integer;
BEGIN
	--Handle visitUserName input. Strip quotes and try to locate VPAtlas user from raw input which could be an email.
	--If raw input not found/inserted, parse username from possible email prefix if email was used as username.
	RAISE NOTICE 'set_visit_user_id_from_visit_user_name() visitUserName: % | visitUserId: %', NEW."visitUserName", NEW."visitUserId";
	u_name := btrim(NEW."visitUserName", '\"'); --trim dbl-quotes from input
	--First try to locate user from possible email as username
	IF valid_email(u_name) THEN --validate email format
		usr_id := (SELECT "id" FROM vpuser WHERE LOWER("email")=LOWER(u_name)); --look for user by email
	END IF;
	IF usr_id IS NOT NULL THEN -- matched username to email address
		NEW."visitUserId" := usr_id; --set visitUserId to found user
		RAISE NOTICE 'Matched visitUserName % to email address % having userId %.', u_name, u_name, usr_id;
		u_name := (SELECT "username" FROM vpuser WHERE id=usr_id); -- set visitUserName to found user
	ELSE --user not found from raw input. truncate possible email to username and try again.
		u_name := SPLIT_PART(u_name, '@', 1); --truncate email username to prefix
		usr_id := find_or_insert_user_from_ambig_user_email_input(u_name); --try again with just username
	END IF;
	IF NEW."visitUserName" != u_name THEN --flag an altered incoming username
		RAISE NOTICE 'Altered incoming visitUserName % to %.', NEW."visitUserName", u_name;
	END IF;
	NEW."visitUserName" := u_name;
	NEW."visitUserId" := usr_id;

	--Handle visitObserverUserName input. Strip quotes and parse username from email prefix if email was used as username
	RAISE NOTICE 'set_visit_user_id_from_visit_user_name() visitObserverUserName: %', NEW."visitObserverUserName";
	o_name := btrim(NEW."visitObserverUserName", '\"'); --trim dbl-quotes from input
	IF valid_email(o_name) THEN --validate email format
		obs_id := (SELECT "id" FROM vpuser WHERE LOWER("email")=LOWER(o_name)); --look for user by email
	END IF;
	IF obs_id IS NOT NULL THEN -- found/inserted user by raw username which could be an email
		NEW."visitObserverUserId" := obs_id;
		RAISE NOTICE 'Matched visitObserverUserName % to email address % having userId %.', o_name, o_name, obs_id;
		o_name := (SELECT "username" FROM vpuser WHERE id=obs_id); -- set visitObserverUserName to found user
	ELSE --user not found from raw input. truncate possible email to username and try again.
		o_name := SPLIT_PART(o_name, '@', 1); --truncate email username to prefix
		obs_id := find_or_insert_user_from_ambig_user_email_input(o_name); --try again with just username
	END IF;
	IF NEW."visitObserverUserName" != o_name THEN --flag an altered incoming username
		RAISE NOTICE 'Altered incoming visitObserverUserName % to %.', NEW."visitObserverUserName", o_name;
	END IF;
	NEW."visitObserverUserName" := o_name;
	NEW."visitObserverUserId" := obs_id;

	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.set_visit_user_id_from_visit_user_name()
    OWNER TO vpatlas;
