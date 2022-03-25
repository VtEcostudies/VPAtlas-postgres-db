ALTER TABLE vpmapped DROP COLUMN IF EXISTS "mappedDateUnixSeconds";

/*
SELECT "mappedPoolId",
"mappedLandownerInfo",
"mappedlocationInfoDirections",
"mappedComments"
from vpmapped where
"mappedLandownerInfo" like '%"%' OR
"mappedlocationInfoDirections" like '%"%' OR
"mappedComments" like '%"%';
*/

ALTER TABLE vpmapped DISABLE TRIGGER ALL;

UPDATE vpmapped SET
"mappedLandownerInfo" = replace("mappedLandownerInfo", '"',''''),
"mappedlocationInfoDirections" = replace("mappedlocationInfoDirections", '"',''''),
"mappedComments" = replace("mappedComments", '"','''');

ALTER TABLE vpmapped ENABLE TRIGGER ALL;
