ALTER TYPE status_type ADD VALUE 'auto-gen';
ALTER TYPE status_type RENAME TO vp_user_status_type;
ALTER TYPE poolstatus RENAME TO vp_pool_status_type;
ALTER TYPE locationaccuracy RENAME TO vp_pool_mapped_location_accuracy_type;
ALTER TYPE confidence RENAME TO vp_pool_mapped_confidence_type;
--DROP TYPE vp_pool_mapped_location_accuracy_type; --FAILED. Used in vpmapped column "mappedLocationAccuracy"
--DROP TYPE vp_pool_mapped_confidence_type; --FAILED. Used in vpmapped column "mappedConfidence"

--Fix vpusers auto-gen users bug: merge users with same email having mixed case into single user
SELECT DISTINCT(LOWER(vpuser.email)) AS email_lower,
	(SELECT array_agg(id)
		AS user_ids FROM vpuser WHERE LOWER(dupes.email)=LOWER(vpuser.email))
FROM vpuser JOIN (
	SELECT LOWER(email) AS email, count(*)
	FROM vpuser
	GROUP BY LOWER(email)
	HAVING count(*) > 1
) AS dupes ON LOWER(dupes.email)=LOWER(vpuser.email);

CREATE OR REPLACE FUNCTION vp_merge_duplicate_emails()
	RETURNS integer
	LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	usr record; --loop iterator record
	cnt integer:=0;
BEGIN

ALTER TABLE vpmapped DISABLE TRIGGER ALL;
ALTER TABLE vpvisit DISABLE TRIGGER ALL;
ALTER TABLE vpsurvey DISABLE TRIGGER ALL;
ALTER TABLE vpsurvey_amphib DISABLE TRIGGER ALL;

--UPDATE vpsurvey SET "surveyUserEmail"=LOWER("surveyUserEmail");
--UPDATE vpsurvey_amphib SET "surveyAmphibObsEmail"=LOWER("surveyAmphibObsEmail");

	FOR usr IN
      SELECT DISTINCT(LOWER(vpuser.email)) AS eml,
      	(SELECT array_agg(id)
      		AS ids FROM vpuser WHERE LOWER(dupes.email)=LOWER(vpuser.email))
      FROM vpuser JOIN (
      	SELECT LOWER(email) AS email, count(*)
      	FROM vpuser
      	GROUP BY LOWER(email)
      	HAVING count(*) > 1
      ) AS dupes ON LOWER(dupes.email)=LOWER(vpuser.email)
    LOOP
      IF array_length(usr.ids, 1) = 2 THEN
        RAISE NOTICE 'Replacing user id % with % for %', usr.ids[2], usr.ids[1], usr.eml;

UPDATE vpmapped SET "mappedUserId"=usr.ids[1] WHERE "mappedUserId"=usr.ids[2];
UPDATE vpvisit SET "visitUserId"=usr.ids[1] WHERE "visitUserId"=usr.ids[2];
UPDATE vpsurvey SET "surveyUserId"=usr.ids[1] WHERE "surveyUserId"=usr.ids[2];
UPDATE vpsurvey_amphib SET "surveyAmphibObsId"=usr.ids[1] WHERE "surveyAmphibObsId"=usr.ids[2];
DELETE FROM vpuser WHERE "id"=usr.ids[2];
--UPDATE vpuser SET "email"=LOWER("email") WHERE "id"=usr.ids[1];

		cnt := cnt + 1;
      ELSE
        RAISE NOTICE 'Wrong number of ids % for %', array_length(usr.ids), usr.eml;
      END IF;
    END LOOP;

ALTER TABLE vpmapped ENABLE TRIGGER ALL;
ALTER TABLE vpvisit ENABLE TRIGGER ALL;
ALTER TABLE vpsurvey ENABLE TRIGGER ALL;
ALTER TABLE vpsurvey_amphib ENABLE TRIGGER ALL;

	RETURN cnt;
END;
$BODY$;

--select vp_merge_duplicate_emails();
