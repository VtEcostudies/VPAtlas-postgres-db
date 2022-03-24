-- Before INSERT on vpvisit, check for incoming visitPoolId in vpmapped. If non-extant, 
-- INSERT into vpmapped, which has as trigger to generate a new pool ID when incoming 
-- mappedPoolId is NEW*.
-- Return mappedPoolId from INSERT to be used downstream by vpvisit INSERT.

--DROP FUNCTION IF EXISTS insert_mapped_pool_from_visit_data();
CREATE OR REPLACE FUNCTION insert_mapped_pool_from_visit_data()
	RETURNS trigger
	LANGUAGE 'plpgsql'
	AS $BODY$
	DECLARE
		extant text;
	BEGIN
		RAISE NOTICE 'insert_mapped_pool_from_visit_data() visitPoolId: %', NEW."visitPoolId";
		SELECT "mappedPoolId" FROM vpmapped WHERE "mappedPoolId"=NEW."visitPoolId" INTO extant;
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
				NEW."visitPoolId",
				NEW."visitUserName",
				(SELECT id FROM vpuser WHERE username=NEW."visitUserName"),
				NEW."visitDate",
				NEW."visitLatitude",
				NEW."visitLongitude",
				'Visit',
				NEW."visitObserverUserName",
				'Potential') RETURNING "mappedPoolId" INTO NEW."visitPoolId";
		ELSE
			RAISE NOTICE 'Unable to INSERT New Mapped Pool % - it already exists.', NEW."visitPoolId";
		END IF;
		RETURN NEW;
END;
$BODY$;

ALTER FUNCTION insert_mapped_pool_from_visit_data()
    OWNER TO vpatlas;

--Create mapped pool from first visit data upload if mappedPool doesn't exist
DROP TRIGGER IF EXISTS trigger_before_insert_visit_insert_mapped_pool_from_visit_data ON vpvisit;
CREATE TRIGGER trigger_before_insert_visit_insert_mapped_pool_from_visit_data BEFORE INSERT ON vpvisit
  FOR EACH ROW EXECUTE PROCEDURE insert_mapped_pool_from_visit_data();
