ALTER TABLE vpreview ADD COLUMN IF NOT EXISTS "reviewPoolLocator" BOOLEAN;
ALTER TABLE vpreview DROP CONSTRAINT IF EXISTS vpreview_unique_pool_id_pool_locator;
ALTER TABLE vpreview ADD CONSTRAINT vpreview_unique_pool_id_pool_locator
  UNIQUE ("reviewPoolId", "reviewPoolLocator");

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
CREATE TRIGGER trigger_after_insert_set_vpmapped_pool_location AFTER INSERT ON vpreview
  FOR EACH ROW EXECUTE PROCEDURE set_vpmapped_geolocation_from_vpvisit_coordinates();
DROP TRIGGER IF EXISTS trigger_after_update_set_vpmapped_pool_location ON vpreview;
CREATE TRIGGER trigger_after_update_set_vpmapped_pool_location AFTER UPDATE ON vpreview
  FOR EACH ROW EXECUTE PROCEDURE set_vpmapped_geolocation_from_vpvisit_coordinates();
