-- add uuid and object4Id columns to vpvisit for S123 uploads
ALTER TABLE vpvisit ADD COLUMN IF NOT EXISTS "visitGlobalId" uuid;
ALTER TABLE vpvisit ADD COLUMN IF NOT EXISTS "visitObjectId" INTEGER;

-- add uuid and objectId columns to vpsurvey for S123 uploads
ALTER TABLE vpsurvey ADD COLUMN IF NOT EXISTS "surveyGlobalId" uuid;
ALTER TABLE vpsurvey ADD COLUMN IF NOT EXISTS "surveyObjectId" INTEGER;
