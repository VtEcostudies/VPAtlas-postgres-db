ALTER TABLE vpmapped DROP COLUMN IF EXISTS "mappedDateUnixSeconds";

SELECT "mappedPoolId",
"mappedLandownerInfo",
"mappedlocationInfoDirections",
"mappedComments"
from vpmapped where
"mappedLandownerInfo" like '%"%' OR
"mappedlocationInfoDirections" like '%"%' OR
"mappedComments" like '%"%';

UPDATE vpmapped SET
"mappedLandownerInfo" = replace("mappedLandownerInfo", '"',''''),
"mappedlocationInfoDirections" = replace("mappedlocationInfoDirections", '"',''''),
"mappedComments" = replace("mappedComments", '"','''');
