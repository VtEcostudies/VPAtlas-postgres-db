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

--Create a function and triggers to convert user/observer email into user/observer id.
--Search for user by email, then by username. Failing to find a user having a valid email
--create a new user with the email contents. INSERT 'auto-gen' into the "middleName"
--field to find these later.
--DROP FUNCTION IF EXISTS find_or_insert_user_from_ambig_user_email_input(text);
CREATE OR REPLACE FUNCTION find_or_insert_user_from_ambig_user_email_input(u_mixt text)
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
			f_name := SPLIT_PART(u_mixt, ' ', 1);
			l_name := SPLIT_PART(u_mixt, ' ', 2);
			u_id = (SELECT "id" FROM vpuser WHERE "firstname"=f_name AND "lastname"=l_name);
			IF u_id>0 THEN
				RAISE NOTICE 'FOUND user id % with firstname % and lastname %', u_id, f_name, l_name;
			ELSE
				RAISE NOTICE 'user NOT found with firstname % and lastname %', f_name, l_name;
			END IF;
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

ALTER FUNCTION find_or_insert_user_from_ambig_user_email_input(text)
    OWNER TO vpatlas;

--DROP FUNCTION IF EXISTS set_survey_user_amphib_id_from_survey_amphib_obs_email();
CREATE OR REPLACE FUNCTION set_survey_user_amphib_id_from_survey_amphib_obs_email()
	RETURNS trigger
	LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RAISE NOTICE 'set_survey_user_amphib_id_from_survey_amphib_obs_email() email:% | userId:%', NEW."surveyAmphibObsEmail", NEW."surveyAmphibObsId";
	NEW."surveyAmphibObsEmail" := btrim(NEW."surveyAmphibObsEmail", '\"'); --trim dbl-quotes from input
	NEW."surveyAmphibObsId" := find_or_insert_user_from_ambig_user_email_input(NEW."surveyAmphibObsEmail");
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION set_survey_user_amphib_id_from_survey_amphib_obs_email()
    OWNER TO vpatlas;

DROP TRIGGER IF EXISTS trigger_before_insert_set_survey_user_amphib_id_from_survey_amphib_obs_email ON vpsurvey_amphib;
CREATE TRIGGER trigger_before_insert_set_survey_user_amphib_id_from_survey_amphib_obs_email BEFORE INSERT ON vpsurvey_amphib
  FOR EACH ROW EXECUTE PROCEDURE set_survey_user_amphib_id_from_survey_amphib_obs_email();
DROP TRIGGER IF EXISTS trigger_before_update_set_survey_user_amphib_id_from_survey_amphib_obs_email ON vpsurvey_amphib;
CREATE TRIGGER trigger_before_update_set_survey_user_amphib_id_from_survey_amphib_obs_email BEFORE UPDATE ON vpsurvey_amphib
  FOR EACH ROW EXECUTE PROCEDURE set_survey_user_amphib_id_from_survey_amphib_obs_email();

UPDATE vpsurvey_amphib SET "surveyAmphibObsEmail"="surveyAmphibObsEmail"; --this bumps the BEFORE UPDATE TRIGGER above

--REPLACE function to convert surveyUserEmail into surveyUserId with new call to
--find_or_insert_user_from_ambig_user_email_input(e_mail text)
--DROP FUNCTION IF EXISTS set_survey_user_id_from_survey_user_email();
CREATE OR REPLACE FUNCTION set_survey_user_id_from_survey_user_email()
    RETURNS trigger
		LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	RAISE NOTICE 'set_survey_user_id_from_survey_user_email() email:% | userId:%', NEW."surveyUserEmail", NEW."surveyUserId";
	NEW."surveyUserEmail" := btrim(NEW."surveyUserEmail", '\"'); --trim dbl-quotes from input
	NEW."surveyUserId" := find_or_insert_user_from_ambig_user_email_input(NEW."surveyUserEmail");
	RETURN NEW;
END;
$BODY$;
