--Leave geometry in native 4326, degrees
select * from vpmapped where ST_PointInsideCircle("mappedPoolLocation",-72.98838,43.80005,0.0005);

--convert geometry to 5186, meters
select * from vpmapped where ST_DWITHIN(
	ST_Transform("mappedPoolLocation", 5186),
	ST_Transform(ST_SetSRID(ST_Point(-72.98838, 43.80005), 4386), 5186),
	50);

SELECT ST_Distance(
	ST_Transform(a."mappedPoolLocation", 5186),
	ST_Transform(b."mappedPoolLocation", 5186)
	) AS meters
FROM vpmapped a, vpmapped b
WHERE a."mappedPoolId"='NEW1085' 
AND b."mappedPoolId"='MLS1759';

SELECT ST_Distance(
	a."mappedPoolLocation"::geography,
	b."mappedPoolLocation"::geography
	) AS meters
FROM vpmapped a, vpmapped b
WHERE a."mappedPoolId"='NEW1085' 
AND b."mappedPoolId"='MLS1759';