CREATE OR REPLACE FUNCTION public.insert_mapped_pool_from_survey_data()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
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
				(SELECT username FROM vpuser WHERE LOWER(email)=LOWER(NEW."surveyUserEmail")),
				(SELECT id FROM vpuser WHERE LOWER(email)=LOWER(NEW."surveyUserEmail")),
				NEW."surveyDate",
				NEW."surveyPoolLatitude",
				NEW."surveyPoolLongitude",
				'Survey',
				(SELECT username FROM vpuser WHERE LOWER(email)=LOWER(NEW."surveyUserEmail")),
				'Probable');
		END IF;
		RETURN NEW;
END;
$BODY$;