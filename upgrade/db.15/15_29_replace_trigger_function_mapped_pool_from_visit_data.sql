--DROP FUNCTION IF EXISTS vp_pools_at_point_within_radius(lat numeric, lon numeric, rad integer);
CREATE OR REPLACE FUNCTION vp_pools_at_point_within_radius(lat numeric, lon numeric, rad integer)
	RETURNS text[]
	LANGUAGE 'plpgsql'
AS $BODY$
DECLARE pools text[];
BEGIN
--convert geometry to 5186, in meters, to use meters of radius
SELECT
	ARRAY_AGG("mappedPoolId") FROM vpmapped WHERE ST_DWITHIN(
	ST_Transform("mappedPoolLocation", 5186),
	ST_Transform(ST_SetSRID(ST_Point(lon, lat), 4386), 5186), --circle center
	rad) --circle radius in meters
INTO pools;
RETURN pools;
END;
$BODY$;

select vp_pools_at_point_within_radius(43.80005,-72.98838,100);

--DROP FUNCTION IF EXISTS vp_check_pools_within_radius(lat numeric, lon numeric, rad integer);
CREATE OR REPLACE FUNCTION vp_check_pools_within_radius(lat numeric, lon numeric, rad integer)
	RETURNS BOOLEAN
	LANGUAGE 'plpgsql'
AS $BODY$
DECLARE pools text[];
BEGIN
	SELECT vp_pools_at_point_within_radius(lat, lon, rad) INTO pools;
	IF array_length(pools, 1) > 0 THEN
		RETURN true;
	ELSE
		RETURN false;
	END IF;
END;
$BODY$;

select vp_check_pools_within_radius(43.80005,-72.98838,50);

--DROP FUNCTION IF EXISTS vp_pools_at_point_within_radius(point geometry, rad integer);
CREATE OR REPLACE FUNCTION vp_pools_at_point_within_radius(point geometry, rad integer)
	RETURNS text[]
	LANGUAGE 'plpgsql'
AS $BODY$
DECLARE pools text[];
BEGIN
--convert geometry to 5186, in meters, to use meters of radius
SELECT
	ARRAY_AGG("mappedPoolId") FROM vpmapped WHERE ST_DWITHIN(
	ST_Transform("mappedPoolLocation", 5186),
	ST_Transform(ST_SetSRID(point, 4386), 5186), --circle center
	rad) --circle radius in meters
INTO pools;
--RAISE NOTICE 'vp_pools_at_point_within_radius: %', pools;
RETURN pools;
END;
$BODY$;

--DROP FUNCTION IF EXISTS vp_check_pools_within_radius(point geometry, rad integer);
CREATE OR REPLACE FUNCTION vp_check_pools_within_radius(point geometry, rad integer)
	RETURNS BOOLEAN
	LANGUAGE 'plpgsql'
AS $BODY$
DECLARE pools text[];
BEGIN
	SELECT vp_pools_at_point_within_radius(point, rad) INTO pools;
	--RAISE NOTICE 'vp_check_pools_within_radius -> vp_pools_at_point_within_radius: %', pools;
	IF array_length(pools, 1) > 0 THEN
		RETURN true;
	ELSE
		RETURN false;
	END IF;
END;
$BODY$;

--DROP FUNCTION IF EXISTS vp_check_all_pools_proximity(rad integer, lim integer);
CREATE OR REPLACE FUNCTION vp_check_all_pools_proximity(rad integer, lim integer default 10000)
	RETURNS text[]
	LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	pool record; --loop iterator record
	pools text[]; --array of poolIds found for each point sampled
	proxp text[]; --array of poolIds that had proximate pools
BEGIN
	FOR pool IN SELECT "mappedPoolId", "mappedPoolLocation"
		from vpmapped LIMIT lim
    LOOP
		SELECT vp_pools_at_point_within_radius(pool."mappedPoolLocation", rad) INTO pools;
		SELECT array_remove(pools, pool."mappedPoolId") INTO pools; --remove self from list
		IF array_length(pools, 1) > 0 THEN
			RAISE NOTICE '% is within % meters of %', pool."mappedPoolId", rad, pools;
			proxp := proxp || pool."mappedPoolId";
		END IF;
    END LOOP;
	RETURN proxp;
END;
$BODY$;

select vp_check_all_pools_proximity(20, 100);

--create an index on poolLocation geometry to speed queries on that
CREATE INDEX IF NOT EXISTS mapped_pool_location_index ON vpmapped USING GIST ("mappedPoolLocation");
--VACUUM ANALYZE vpmapped("mappedPoolLocation");

--Attempt to create a check constraint on vpmapped by location and status. Many extant
--pools violate this constraint so it could not be added.
/*
ALTER TABLE vpmapped ADD CONSTRAINT "vpmapped_pool_location"
	CHECK (vp_check_pools_within_radius("mappedLatitude", "mappedLongitude", 20)=false
		  AND "mappedPoolStatus" NOT IN ('Eliminated','Duplicate'));
*/

--Whoa, back up. Find pools that are verbatim duplicates
SELECT "mappedLatitude","mappedLongitude", "mappedPoolStatus", COUNT(*)
FROM vpmapped
GROUP BY "mappedLatitude","mappedLongitude", "mappedPoolStatus"
HAVING COUNT(*) > 1;
