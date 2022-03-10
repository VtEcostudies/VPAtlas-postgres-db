-- add column polarized glasses to vpsurvey_amphib
ALTER TABLE vpsurvey_amphib ADD COLUMN "surveyAmphibPolarizedGlasses" boolean DEFAULT false;

-- remove column polarized glasses from vpsurvey
ALTER TABLE vpsurvey DROP COLUMN "surveyPolarizedGlasses";
ALTER TABLE vpsurvey ADD COLUMN "surveyPhotoJson" jsonb;
-- add uuid column to vpsurvey for S123 uploads
ALTER TABLE vpsurvey ADD COLUMN "surveyGlobalId" uuid;

-- add uuid column to vpvisit for S123 uploads
ALTER TABLE vpvisit ADD COLUMN "visitGlobalId" uuid;

-- add user email to vpmapped to handle users