/*
SELECT "reviewPoolId",
"reviewId",
"reviewQADate",
"reviewQANotes"
from vpreview where
"reviewQANotes" like '%"%';
*/

ALTER TABLE vpreview DISABLE TRIGGER ALL;

UPDATE vpreview SET
"reviewQANotes" = replace("reviewQANotes", '"','''');

ALTER TABLE vpreview ENABLE TRIGGER ALL;
