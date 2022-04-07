SELECT * FROM vpsurvey_amphib WHERE (
"surveyAmphibEdgeWOFR"+
"surveyAmphibEdgeSPSA"+
"surveyAmphibEdgeJESA"+
"surveyAmphibEdgeBLSA"
) > 0;

SELECT * FROM vpsurvey_amphib WHERE (
"surveyAmphibInteriorWOFR"+
"surveyAmphibInteriorSPSA"+
"surveyAmphibInteriorJESA"+
"surveyAmphibInteriorBLSA"
) > 0;

ALTER TABLE vpsurvey_amphib DISABLE TRIGGER ALL;
UPDATE vpsurvey_amphib SET "surveyAmphibEdgeWOFR"=0 WHERE "surveyAmphibEdgeWOFR" IS NULL;
UPDATE vpsurvey_amphib SET "surveyAmphibEdgeSPSA"=0 WHERE "surveyAmphibEdgeSPSA" IS NULL;
UPDATE vpsurvey_amphib SET "surveyAmphibEdgeJESA"=0 WHERE "surveyAmphibEdgeJESA" IS NULL;
UPDATE vpsurvey_amphib SET "surveyAmphibEdgeBLSA"=0 WHERE "surveyAmphibEdgeBLSA" IS NULL;
UPDATE vpsurvey_amphib SET "surveyAmphibInteriorWOFR"=0 WHERE "surveyAmphibInteriorWOFR" IS NULL;
UPDATE vpsurvey_amphib SET "surveyAmphibInteriorSPSA"=0 WHERE "surveyAmphibInteriorSPSA" IS NULL;
UPDATE vpsurvey_amphib SET "surveyAmphibInteriorJESA"=0 WHERE "surveyAmphibInteriorJESA" IS NULL;
UPDATE vpsurvey_amphib SET "surveyAmphibInteriorBLSA"=0 WHERE "surveyAmphibInteriorBLSA" IS NULL;
UPDATE vpsurvey_amphib SET "surveyAmphibInteriorBLSA"=0 WHERE "surveyAmphibInteriorBLSA" IS NULL;
ALTER TABLE vpsurvey_amphib ENABLE TRIGGER ALL;

ALTER TABLE vpsurvey_amphib
ALTER COLUMN "surveyAmphibEdgeWOFR" SET NOT NULL,
ALTER COLUMN "surveyAmphibEdgeWOFR" SET DEFAULT 0,
ALTER COLUMN "surveyAmphibEdgeSPSA" SET NOT NULL,
ALTER COLUMN "surveyAmphibEdgeSPSA" SET DEFAULT 0,
ALTER COLUMN "surveyAmphibEdgeJESA" SET NOT NULL,
ALTER COLUMN "surveyAmphibEdgeJESA" SET DEFAULT 0,
ALTER COLUMN "surveyAmphibEdgeBLSA" SET NOT NULL,
ALTER COLUMN "surveyAmphibEdgeBLSA" SET DEFAULT 0,
ALTER COLUMN "surveyAmphibInteriorWOFR" SET NOT NULL,
ALTER COLUMN "surveyAmphibInteriorWOFR" SET DEFAULT 0,
ALTER COLUMN "surveyAmphibInteriorSPSA" SET NOT NULL,
ALTER COLUMN "surveyAmphibInteriorSPSA" SET DEFAULT 0,
ALTER COLUMN "surveyAmphibInteriorJESA" SET NOT NULL,
ALTER COLUMN "surveyAmphibInteriorJESA" SET DEFAULT 0,
ALTER COLUMN "surveyAmphibInteriorBLSA" SET NOT NULL,
ALTER COLUMN "surveyAmphibInteriorBLSA" SET DEFAULT 0;
