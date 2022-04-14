select "townName", "mappedLandownerInfo", * from vpvisit 
join vpmapped on "mappedPoolId"="visitPoolId"
join vptown on "mappedTownId"="townId"
where "visitLocationComments"='Not for public release'
--where "visitLocationComments" like '%release%'
--and "townName"='Corinth'
--UPDATE vpmapped SET "mappedPoolStatus"='Probable'
INNER JOIN vpvisit ON "visitPoolId"="mappedPoolId"
WHERE "visitLocationComments"='Not for public release'
