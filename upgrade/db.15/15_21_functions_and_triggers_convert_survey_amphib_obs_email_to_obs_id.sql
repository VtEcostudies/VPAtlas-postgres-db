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

--Now create a function and triggers to convert surveyAmphibObsEmail into surveyAmphibObsId
--DROP FUNCTION IF EXISTS set_survey_user_amphib_id_from_survey_amphib_obs_email();
CREATE OR REPLACE FUNCTION set_survey_user_amphib_id_from_survey_amphib_obs_email()
    RETURNS trigger
		LANGUAGE 'plpgsql'
AS $BODY$
DECLARE u_id integer;
DECLARE u_name text;
DECLARE e_mail text;
BEGIN
	NEW."surveyAmphibObsEmail" := btrim(NEW."surveyAmphibObsEmail", '\"'); --trim dbl-quotes from names

	IF valid_email(NEW."surveyAmphibObsEmail") THEN --validate email format
		e_mail := NEW."surveyAmphibObsEmail";
	END IF;

	IF e_mail IS NOT NULL THEN
		u_id = (SELECT "id" FROM vpuser WHERE "email"=e_mail); --look for user by email
	END IF;

	IF u_id IS NULL THEN
		u_id = (SELECT "id" FROM vpuser WHERE "username"=u_name); --look for user by username
		IF u_id>0 THEN
			RAISE NOTICE 'FOUND user id % with username %', u_id, u_name;
		END IF;
	ELSE
		RAISE NOTICE 'FOUND user id % with email %', u_id, e_mail;
	END IF;

	IF u_id IS NULL AND e_mail IS NOT NULL THEN --user NOT found with incoming email/username. create user.
		u_name := SPLIT_PART(e_mail, '@', 1);
		INSERT INTO vpuser (
			"username", "firstname", "lastname", "email", "hash", "userrole"
		) VALUES (
			u_name, u_name, 'auto-gen', e_mail, '999999', 'user'
		) RETURNING id into u_id;
		RAISE NOTICE 'INSERTED new user id % with username % and email %', u_id, u_name, e_mail;
	END IF;
	
	NEW."surveyAmphibObsId" = u_id;
	
	RAISE NOTICE 'set_survey_user_amphib_id_from_survey_amphib_obs_email() email:% | userId:%', e_mail, NEW."surveyAmphibObsId";
	RAISE NOTICE 'raw email %', NEW."surveyAmphibObsEmail";
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
