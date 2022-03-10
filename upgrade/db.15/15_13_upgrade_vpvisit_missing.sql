-- FUNCTION: public.set_mapped_pool_location_from_visit_lat_lon()

-- DROP FUNCTION IF EXISTS public.set_mapped_pool_location_from_visit_lat_lon();

CREATE OR REPLACE FUNCTION set_mapped_pool_location_from_visit_lat_lon()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
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
