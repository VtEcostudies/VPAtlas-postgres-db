DROP VIEW IF EXISTS mapped_shapefile;
/*
IMPORTANT: Do not alter the queried name of columns to be used as WHERE CLAUSE parameters.
ALTERNATIVELY: query the same column twice, once with its original name.
IMPORTANT: Text fields can have bad characters that crash pgsql2shp without an error message.
	If it's crashing and there's no explanation, try leaving out text fields before trying other fixes.
*/
CREATE OR REPLACE VIEW public.mapped_shapefile
AS
SELECT
  "mappedPoolId" AS "poolId",
  "mappedPoolStatus" AS "poolStatus",
  CONCAT('https://vpatlas.org/pools/list?poolId=',"mappedPoolId",'&zoomFilter=false') AS "poolUrl",
  "townName",
  "countyName",
  vpmapped.*
  FROM vpmapped
  LEFT JOIN vptown on "mappedTownId"="townId"
  LEFT JOIN vpcounty ON "townCountyId"="govCountyId";

select * from mapped_shapefile;