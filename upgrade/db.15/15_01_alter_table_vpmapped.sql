
ALTER TABLE vpmapped ALTER COLUMN "mappedPoolStatus" SET DEFAULT 'Potential';
ALTER TABLE vpmapped ALTER COLUMN "mappedPoolLocation" TYPE GEOMETRY(Geometry, 4326);
ALTER TABLE vpmapped ALTER COLUMN "mappedPoolBorder" TYPE GEOMETRY(Geometry, 4326);

--Update vpmapped geolocation with original mapped data
UPDATE vpmapped SET
	"mappedPoolLocation" = ST_GeomFromText('POINT(' || "mappedLongitude" || ' ' || "mappedLatitude" || ')');

--Update vpmapped geolocation with the most recent visit data
UPDATE vpmapped SET
	"mappedpoolLocation" = ST_GeomFromText('POINT(' || "visitLongitude" || ' ' || "visitLatitude" || ')')
FROM vpvisit
WHERE "mappedPoolId"="visitPoolId"
AND "visitLongitude"::INTEGER != 0
AND "visitLatitude"::INTEGER != 0
AND "visitId" IN (
	SELECT MAX("visitId") AS "maxVisitId" FROM vpvisit
	GROUP BY "visitPoolId"
);

--Test query to show that MAX("visitId") Grouped By "visitPoolId" gets the latest visit to a pool
/*
SELECT "cntVisitId","maxVisitId","visitId","visitPoolId"
FROM vpvisit LEFT JOIN (
	SELECT MAX("visitId") AS "maxVisitId", COUNT("visitId") AS "cntVisitId"
	FROM vpvisit
	GROUP BY "visitPoolId"
) as max
ON vpvisit."visitId"="maxVisitId"
ORDER BY "visitPoolId";
*/

--somehow, updatedAt trigger was missing from vpmapped?
CREATE TRIGGER trigger_updated_at
    BEFORE UPDATE
    ON vpmapped
    FOR EACH ROW
    EXECUTE PROCEDURE public.set_updated_at();

--fix a bug in create mapped pool where mappedMethod is incorrect
--select * from vpmapped where "mappedMethod"='Visited';
UPDATE vpmapped SET "mappedMethod"='Visit' WHERE "mappedMethod"='Visited';

--create a data type for mappedMethod to avoid future problems
CREATE TYPE vp_mapped_method AS ENUM ('Aerial', 'Known', 'Visit');
ALTER TYPE vp_mapped_method OWNER TO vpatlas;
ALTER TABLE vpmapped ALTER COLUMN "mappedMethod" TYPE vp_mapped_method USING "mappedMethod"::vp_mapped_method;
