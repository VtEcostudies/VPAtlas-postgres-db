select "visitDate", "visitPoolId", "visitId", "townName", "countyName", "biophysicalName", "mappedLatitude", "mappedLongitude", COALESCE(
"visitWoodFrogAdults"+
"visitWoodFrogLarvae"+
"visitWoodFrogEgg"
,0) AS WOFR_count, COALESCE(
"visitSpsAdults"+
"visitSpsLarvae"+
"visitSpsEgg" 
,0) AS SPSA_count, COALESCE(
"visitJesaAdults"+
"visitJesaLarvae"+
"visitJesaEgg" 
,0) AS JESA_count, COALESCE(
"visitBssaAdults"+
"visitBssaLarvae"+
"visitBssaEgg" 
,0) AS BLSA_count, 
COALESCE("visitFairyShrimp",0) ,
COALESCE("visitFingerNailClams",0)
FROM vpvisit
INNER JOIN vpmapped ON "mappedPoolId"="visitPoolId"
INNER JOIN vptown ON "mappedTownId"="townId"
INNER JOIN geo_town ON ST_Within("mappedPoolLocation", "geoTownPolygon") AND "mappedTownId"="geoTownId"
INNER JOIN vpcounty ON "townCountyId"="govCountyId"
INNER JOIN geo_county ON  ST_Within("mappedPoolLocation", geo_county."geoPolygon") AND "countyId"=geo_county."geoId"
INNER JOIN geo_biophysical ON ST_Within("mappedPoolLocation", geo_biophysical."geoPolygon")
INNER JOIN vpbiophysical ON "biophysicalId"=geo_biophysical."geoId"
WHERE ((
"visitWoodFrogAdults"+
"visitWoodFrogLarvae"+
"visitWoodFrogEgg"
) > 0 OR (
"visitSpsAdults"+
"visitSpsLarvae"+
"visitSpsEgg" 
) > 0 OR (
"visitJesaAdults"+
"visitJesaLarvae"+
"visitJesaEgg" 
) > 0 OR (
"visitBssaAdults"+
"visitBssaLarvae"+
"visitBssaEgg" 
) > 0
OR "visitFairyShrimp" > 0
OR "visitFingerNailClams" > 0
) 
AND (
	LOWER("townName") LIKE '%stock%'
	OR LOWER("countyName") LIKE '%sex%'
	--AND LOWER("biophysicalName") LIKE '%aconic%'
	)
ORDER BY "visitDate" DESC, "visitPoolId" ASC,"visitId" DESC