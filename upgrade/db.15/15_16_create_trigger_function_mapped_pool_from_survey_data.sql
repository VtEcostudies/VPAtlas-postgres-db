
-- Add a mapped method value 'Survey' for the purpose, used below.
ALTER TYPE vp_mapped_method ADD VALUE IF NOT EXISTS 'Survey' AFTER 'Visit';

--DROP FUNCTION IF EXISTS insert_mapped_pool_from_survey_data();
CREATE OR REPLACE FUNCTION insert_mapped_pool_from_survey_data()
	RETURNS trigger
	LANGUAGE 'plpgsql'
	AS $BODY$
	DECLARE
		extant text;
	BEGIN
		RAISE NOTICE 'insert_mapped_pool_from_survey_data() surveyPoolId: %', NEW."surveyPoolId";
		SELECT "mappedPoolId" FROM vpmapped WHERE "mappedPoolId"=NEW."surveyPoolId" INTO extant;
		IF extant IS NULL THEN
			INSERT INTO vpmapped (
				"mappedPoolId",
				"mappedByUser",
				"mappedUserId",
				"mappedDateText",
				"mappedLatitude",
				"mappedLongitude",
				"mappedMethod",
				"mappedObserverUserName",
				"mappedPoolStatus")
				VALUES (
				NEW."surveyPoolId",
				(SELECT username FROM vpuser WHERE email=NEW."surveyUserEmail"),
				(SELECT id FROM vpuser WHERE email=NEW."surveyUserEmail"),
				NEW."surveyDate",
				NEW."surveyPoolLatitude",
				NEW."surveyPoolLongitude",
				'Survey',
				(SELECT username FROM vpuser WHERE email=NEW."surveyUserEmail"),
				'Confirmed');
		END IF;
		RETURN NEW;
END;
$BODY$;

ALTER FUNCTION insert_mapped_pool_from_survey_data()
    OWNER TO vpatlas;

--Create mapped pool from first survey data upload if mappedPool doesn't exist
DROP TRIGGER IF EXISTS trigger_before_insert_survey_insert_mapped_pool_from_survey_data ON vpsurvey;
CREATE TRIGGER trigger_before_insert_survey_insert_mapped_pool_from_survey_data BEFORE INSERT ON vpsurvey
  FOR EACH ROW EXECUTE PROCEDURE insert_mapped_pool_from_survey_data();
