--These changes are of unknown origin. It appears that we did not create numbered
--upgrade sql files for some of the required changes in the last development round.
--These are added here with unkonwn consequences.
ALTER TABLE vpvisit DROP COLUMN "visitTownName";
ALTER TABLE vpvisit DROP COLUMN "visitIdLegacy";

ALTER TABLE vpvisit drop constraint fk_pool_id;
ALTER TABLE vpvisit drop constraint fk_user_id;
ALTER TABLE vpvisit add constraint fk_vpvisit_vptown_id foreign key ("visitTownId") references vptown("townId");
ALTER TABLE vpvisit drop constraint fk_town_id;

--get visit Dupes for visitPoolId, visitDate and visitUserName
select "visitPoolId", "visitDate", "visitUserName", count(*)
from vpvisit
group by "visitPoolId", "visitDate", "visitUserName"
having count(*) > 1; --1 MLS566

ALTER TABLE vpvisit ADD CONSTRAINT "vpVisit_unique_visitPoolId_visitDate_visitUserName"
  UNIQUE("visitPoolId", "visitDate", "visitUserName");

-- DROP FUNCTION IF EXISTS set_mapped_pool_location_from_visit_lat_lon();
CREATE OR REPLACE FUNCTION set_mapped_pool_location_from_visit_lat_lon()
    RETURNS trigger
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
   method text := '';
	 count int := 0;
BEGIN
	SELECT "mappedMethod" FROM vpmapped WHERE "mappedPoolId"=NEW."visitPoolId" INTO method;
	SELECT count("visitId") FROM vpvisit WHERE "visitPoolId"=NEW."visitPoolId" INTO count;
	RAISE NOTICE 'set_mapped_pool_location_from_visit_lat_lon() | method=% | visit count=%', method, count;
	IF (method = 'Visit' AND count = 1) THEN
		RAISE NOTICE 'set_mapped_pool_location_from_visit_lat_lon() | Set mapped location from visit lat/lon | lat:% | lon:%', NEW."visitLatitude", NEW."visitLongitude";
		UPDATE vpmapped SET
			"mappedPoolLocation" = ST_GEOMFROMTEXT('POINT(' || NEW."visitLongitude" || ' ' ||  NEW."visitLatitude" || ')', 4326)
			--,"mappedLatitude" = NEW."visitLatitude"
			--,"mappedLongitude" = NEW."visitLongitude"
		WHERE "mappedPoolId"=NEW."visitPoolId";
	END IF;
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION set_mapped_pool_location_from_visit_lat_lon()
    OWNER TO vpatlas;

DROP TRIGGER IF EXISTS trigger_set_mapped_pool_location_after_update_vpvisit ON vpvisit;
CREATE TRIGGER trigger_set_mapped_pool_location_after_update_vpvisit
    AFTER UPDATE
    ON vpvisit
    FOR EACH ROW
    EXECUTE FUNCTION set_mapped_pool_location_from_visit_lat_lon();

--ALTER TABLE vpreview ADD CONSTRAINT vpreview_unique_pool_id_pool_locator UNIQUE ("reviewPoolId", "reviewPoolLocator");
--Don't do it the above way, yet. Let's just set all others to false on trigger
--in function, below, when a new review set the reviewPoolLocator flag.
--ALTER TABLE vpreview DROP CONSTRAINT vpreview_unique_pool_id_pool_locator;
--DROP FUNCTION IF EXISTS set_vpmapped_geolocation_from_vpvisit_coordinates();
CREATE OR REPLACE FUNCTION set_vpmapped_geolocation_from_vpvisit_coordinates()
    RETURNS trigger
		LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	visit record;
BEGIN
	IF NEW."reviewPoolLocator" THEN
		SELECT * FROM vpvisit WHERE "visitId"=NEW."reviewVisitId" INTO visit;
		RAISE NOTICE 'set_vpmapped_geolocation_from_vpvisit_coordinates() | Set geoLocation from vpvisit lat/lon for reviewId:% | visitId:% | poolId:% | lat:% | lon:%',
			NEW."reviewId", NEW."reviewVisitId", NEW."reviewPoolId", visit."visitLatitude", visit."visitLongitude";
		UPDATE vpmapped SET "mappedPoolLocation" = ST_GEOMFROMTEXT('POINT(' || visit."visitLongitude" || ' ' ||  visit."visitLatitude" || ')', 4326)
			WHERE "mappedPoolId"=NEW."reviewPoolId";
    --Only allow a single Visit's Review's Pool Locator flag to be set at once (a pseudo-uniqueness constraint)
    UPDATE vpreview SET "reviewPoolLocator"=false
      WHERE "reviewPoolId"=NEW."reviewPoolId" AND "reviewVisitId"!=NEW."reviewVisitId";
	END IF;
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION set_vpmapped_geolocation_from_vpvisit_coordinates()
    OWNER TO vpatlas;

DROP TRIGGER IF EXISTS trigger_after_insert_set_vpmapped_pool_location ON vpreview;
CREATE TRIGGER trigger_after_insert_set_vpmapped_pool_location
    AFTER INSERT
    ON vpreview
    FOR EACH ROW
    EXECUTE FUNCTION set_vpmapped_geolocation_from_vpvisit_coordinates();

DROP TRIGGER IF EXISTS trigger_after_update_set_vpmapped_pool_location ON vpreview;
CREATE TRIGGER trigger_after_update_set_vpmapped_pool_location
    AFTER UPDATE
    ON vpreview
    FOR EACH ROW
    EXECUTE FUNCTION set_vpmapped_geolocation_from_vpvisit_coordinates();
