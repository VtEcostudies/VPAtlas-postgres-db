--DROP TABLE geo_town;
create table geo_town (
	"geoTownId" integer NOT NULL,
	"geoTownPolygon" geometry(Geometry, 4326),
	CONSTRAINT geo_town_pkey PRIMARY KEY ("geoTownId"),
	CONSTRAINT fk_geo_town_id FOREIGN KEY ("geoTownId") REFERENCES vptown ("townId")
);

--NOTE: Somehow, on loading updates to vcgi town data, the SRID was changed on
--the geo_town table. This made trigges not work, etc. Here's what I had to do
--to fix it:
-- Query the tables' SRID settings:
SELECT Find_SRID('public', 'geo_town', 'geoTownPolygon');
SELECT Find_SRID('public', 'vpmapped', 'mappedPoolLocation');
--do the fix:
ALTER TABLE geo_town
  ALTER COLUMN "geoTownPolygon"
    TYPE geometry(Geometry, 4326)
    USING ST_SetSRID("geoTownPolygon", 4326);
--test the fix:

--TRUNCATE TABLE geo_town;

--Views that prevent ALTER TABLE vpmapped must be dropped and re-added.
--NOTE to self: don't use views to support API queries. It hampers developement speed.
/*
DROP VIEW "mappedGetOverview";
DROP VIEW "poolsGetOverview";
DROP VIEW "geojson_mapped";
DROP VIEW "geojson_visits";
SELECT UpdateGeometrySRID('vpmapped','poolLocation',4326); --this amounts to ALTER TABLE ALTER COLUMN...
*/

/*
--geo_town test query
select "mappedPoolId", "mappedPoolLocation"
from vpmapped
inner join geo_town ON ST_WITHIN("mappedPoolLocation", "geoTownPolygon")
inner join vptown ON "mappedTownId"="geoTownId"
WHERE "townName" IN ('Strafford', 'Norwich');
*/

--fill all vpmapped mappedTownIds from PostGIS towns!
ALTER TABLE vpmapped DISABLE TRIGGER ALL;
UPDATE vpmapped
SET "mappedTownId"="geoTownId"
FROM geo_town
WHERE ST_WITHIN("mappedPoolLocation", "geoTownPolygon");
ALTER TABLE vpmapped ENABLE TRIGGER ALL;

--create trigger function to set mappedPoolLocation, mappedTownId from lat/lon
--we set mappedPoolLocation from lat/lon because the UI doesn't send PostGIS geometry
--we set mappedTownId because a JOIN query to locate town from mappedPoolLocation is too slow
DROP FUNCTION IF EXISTS set_geometry_townid_from_pool_lat_lon();
CREATE OR REPLACE FUNCTION set_geometry_townid_from_pool_lat_lon()
    RETURNS trigger
		LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	--RAISE NOTICE 'set_geometry_townid_from_pool_lat_lon() | NEW.lat%, NEW.lon%, OLD.lat:%, OLD.lon:%',
	--	NEW."mappedLatitude",NEW."mappedLongitude",OLD."mappedLatitude",OLD."mappedLongitude";
	--NOTE: the comparisons below **FAIL** when OLD values are <NULL>, which is true on INSERT. Not nice, pg.
	IF (NEW."mappedLatitude" != OLD."mappedLatitude"
		OR NEW."mappedLongitude" != OLD."mappedLongitude"
		OR OLD."mappedLatitude" IS NULL
		OR OLD."mappedLongitude" IS NULL
	   ) THEN
		RAISE NOTICE 'set_geometry_townid_from_pool_lat_lon() | Set geoLocation from vpmapped lat/lon | lat:% | lon:%', NEW."mappedLatitude", NEW."mappedLongitude";
		NEW."mappedPoolLocation" = ST_GEOMFROMTEXT('POINT(' || NEW."mappedLongitude" || ' ' ||  NEW."mappedLatitude" || ')', 4326);
	END IF;
	NEW."mappedTownId" = (SELECT "geoTownId" FROM geo_town WHERE ST_WITHIN(NEW."mappedPoolLocation","geoTownPolygon"));

	IF NEW."mappedTownId" IS NULL THEN
		NEW."mappedTownId" = 0;
	END IF;

	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION set_geometry_townid_from_pool_lat_lon()
    OWNER TO vpatlas;

DROP TRIGGER IF EXISTS trigger_set_pool_locinfo_after_insert_vpmapped ON vpmapped;
DROP TRIGGER IF EXISTS trigger_set_pool_locinfo_before_insert_vpmapped ON vpmapped;
--create trigger on vpmapped to set mappedPoolLocation, mappedTownId from lat/lon on insert
CREATE TRIGGER trigger_set_pool_locinfo_before_insert_vpmapped
    BEFORE INSERT
    ON vpmapped
    FOR EACH ROW
    EXECUTE PROCEDURE set_geometry_townid_from_pool_lat_lon();

DROP TRIGGER IF EXISTS trigger_set_pool_locinfo_after_update_vpmapped ON vpmapped;
DROP TRIGGER IF EXISTS trigger_set_pool_locinfo_before_update_vpmapped ON vpmapped;
--create trigger on vpmapped to set mappedPoolLocation, mappedTownId from lat/lon on update
CREATE TRIGGER trigger_set_pool_locinfo_before_update_vpmapped
    BEFORE UPDATE
    ON vpmapped
    FOR EACH ROW
    EXECUTE PROCEDURE set_geometry_townid_from_pool_lat_lon();

--create function to let vpvisit lat/lon drive vpmapped geolocation when method is 'Visit' and there's only one visit
--
DROP FUNCTION IF EXISTS set_mapped_pool_location_from_visit_lat_lon();
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
--create trigger on vpvisit to set mappedPoolLocation from visit lat/lon on visit update
CREATE TRIGGER trigger_set_mapped_pool_location_after_update_vpvisit
    AFTER UPDATE
    ON vpvisit
    FOR EACH ROW
    EXECUTE PROCEDURE set_mapped_pool_location_from_visit_lat_lon();
