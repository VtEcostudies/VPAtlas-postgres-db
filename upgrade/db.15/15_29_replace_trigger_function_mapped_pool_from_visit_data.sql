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
		extant text; --poolId from vpmapped having
		pools text[]; --array of existing poolIds
		radius integer:=10; --locationUncertainty radius to look for extant pools by geometry
	BEGIN
		--NOTE: we expect the caller to have placed 'NEW*' in the field 'visitPoolId' if they
		--expect to create a new pool. The query by poolId is still valid.
		RAISE NOTICE 'insert_mapped_pool_from_visit_data() visitPoolId: %', NEW."visitPoolId";
		SELECT "mappedPoolId" FROM vpmapped WHERE "mappedPoolId"=NEW."visitPoolId" INTO extant;
		IF extant IS NULL THEN --poolId not found. Check for extant pools within radius of the incoming location.
			IF NEW."visitLocationUncertainty"::INT THEN
				radius := NEW."visitLocationUncertainty"::INT;
			END IF;
			SELECT vp_pools_at_point_within_radius(NEW."visitLatitude", NEW."visitLongitude", radius) INTO pools;
			extant := pools[1]; --arrays are 1-based
			NEW."visitPoolId" := extant;
		END IF;
		IF extant IS NULL THEN
			INSERT INTO vpmapped (
				"mappedPoolId",
				"mappedByUser",
				"mappedUserId",
				"mappedDateText",
				"mappedLatitude",
				"mappedLongitude",
				"mappedMethod",
				"mappedLocationUncertainty",
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
				NEW."visitLocationUncertainty",
				NEW."visitObserverUserName",
				'Potential') RETURNING "mappedPoolId" INTO NEW."visitPoolId";
		ELSE
			IF pools[1] IS NOT NULL THEN
				RAISE NOTICE 'Unable to INSERT New Mapped Pool. Pool % is within % meters of (%, %).',
					NEW."visitPoolId", radius, NEW."visitLatitude", NEW."visitLongitude";
			ELSE
				RAISE NOTICE 'Unable to INSERT New Mapped Pool % - it already exists.', NEW."visitPoolId";
			END IF;
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
