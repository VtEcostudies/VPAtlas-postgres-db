SELECT * FROM vpsurvey_macro WHERE (
"surveyMacroNorthFASH"+
"surveyMacroEastFASH"+
"surveyMacroSouthFASH"+
"surveyMacroWestFASH"
) != "surveyMacroTotalFASH";

SELECT * FROM vpsurvey_macro WHERE (
"surveyMacroNorthCDFY"+
"surveyMacroEastCDFY"+
"surveyMacroSouthCDFY"+
"surveyMacroWestCDFY"
) != "surveyMacroTotalCDFY";

UPDATE vpsurvey_macro SET "surveyMacroNorthFASH"=0 WHERE "surveyMacroNorthFASH" IS NULL;
UPDATE vpsurvey_macro SET "surveyMacroEastFASH"=0 WHERE "surveyMacroEastFASH" IS NULL;
UPDATE vpsurvey_macro SET "surveyMacroSouthFASH"=0 WHERE "surveyMacroSouthFASH" IS NULL;
UPDATE vpsurvey_macro SET "surveyMacroWestFASH"=0 WHERE "surveyMacroWestFASH" IS NULL;
UPDATE vpsurvey_macro SET "surveyMacroTotalFASH"=0 WHERE "surveyMacroTotalFASH" IS NULL;
UPDATE vpsurvey_macro SET "surveyMacroNorthCDFY"=0 WHERE "surveyMacroNorthCDFY" IS NULL;
UPDATE vpsurvey_macro SET "surveyMacroEastCDFY"=0 WHERE "surveyMacroEastCDFY" IS NULL;
UPDATE vpsurvey_macro SET "surveyMacroSouthCDFY"=0 WHERE "surveyMacroSouthCDFY" IS NULL;
UPDATE vpsurvey_macro SET "surveyMacroWestCDFY"=0 WHERE "surveyMacroWestCDFY" IS NULL;
UPDATE vpsurvey_macro SET "surveyMacroWestCDFY"=0 WHERE "surveyMacroWestCDFY" IS NULL;
UPDATE vpsurvey_macro SET "surveyMacroTotalCDFY"=0 WHERE "surveyMacroTotalCDFY" IS NULL;

ALTER TABLE vpsurvey_macro
ALTER COLUMN "surveyMacroNorthFASH" SET NOT NULL,
ALTER COLUMN "surveyMacroNorthFASH" SET DEFAULT 0,
ALTER COLUMN "surveyMacroEastFASH" SET NOT NULL,
ALTER COLUMN "surveyMacroEastFASH" SET DEFAULT 0,
ALTER COLUMN "surveyMacroSouthFASH" SET NOT NULL,
ALTER COLUMN "surveyMacroSouthFASH" SET DEFAULT 0,
ALTER COLUMN "surveyMacroWestFASH" SET NOT NULL,
ALTER COLUMN "surveyMacroWestFASH" SET DEFAULT 0,
ALTER COLUMN "surveyMacroTotalFASH" SET NOT NULL,
ALTER COLUMN "surveyMacroTotalFASH" SET DEFAULT 0,
ALTER COLUMN "surveyMacroNorthCDFY" SET NOT NULL,
ALTER COLUMN "surveyMacroNorthCDFY" SET DEFAULT 0,
ALTER COLUMN "surveyMacroEastCDFY" SET NOT NULL,
ALTER COLUMN "surveyMacroEastCDFY" SET DEFAULT 0,
ALTER COLUMN "surveyMacroSouthCDFY" SET NOT NULL,
ALTER COLUMN "surveyMacroSouthCDFY" SET DEFAULT 0,
ALTER COLUMN "surveyMacroWestCDFY" SET NOT NULL,
ALTER COLUMN "surveyMacroWestCDFY" SET DEFAULT 0,
ALTER COLUMN "surveyMacroTotalCDFY" SET NOT NULL,
ALTER COLUMN "surveyMacroTotalCDFY" SET DEFAULT 0;
