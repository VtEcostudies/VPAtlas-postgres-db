-- add uuid column to vpvisit for S123 uploads
ALTER TABLE vpvisit ADD COLUMN "visitGlobalId" uuid;

-- add column polarized glasses to vpsurvey_amphib
ALTER TABLE vpsurvey_amphib ADD COLUMN "surveyAmphibPolarizedGlasses" boolean DEFAULT false;

-- remove column polarized glasses from vpsurvey
ALTER TABLE vpsurvey DROP COLUMN "surveyPolarizedGlasses";
ALTER TABLE vpsurvey ADD COLUMN "surveyPhotoJson" jsonb;
-- add uuid column to vpsurvey for S123 uploads
ALTER TABLE vpsurvey ADD COLUMN "surveyGlobalId" uuid;

--tell vpmapped it can delete its dependent surveys
ALTER TABLE vpsurvey DROP CONSTRAINT "vpsurvey_surveyPoolId_fkey";
ALTER TABLE vpsurvey ADD CONSTRAINT "vpsurvey_surveyPoolId_fkey"
	FOREIGN KEY ("surveyPoolId")
		REFERENCES public.vpmapped ("mappedPoolId") MATCH SIMPLE
		ON UPDATE NO ACTION
		ON DELETE CASCADE;
--tell vpsurvey it can delete dependent amphibs
ALTER TABLE vpsurvey_amphib DROP CONSTRAINT "vpsurvey_amphib_surveyAmphibSurveyId_fkey";
ALTER TABLE vpsurvey_amphib ADD CONSTRAINT "vpsurvey_amphib_surveyAmphibSurveyId_fkey" FOREIGN KEY ("surveyAmphibSurveyId")
	REFERENCES vpsurvey ("surveyId") MATCH SIMPLE
	ON DELETE CASCADE;
--tell vpsurvey it can delete dependent macros
ALTER TABLE vpsurvey_macro DROP CONSTRAINT "vpsurvey_macro_surveyMacroSurveyId_fkey";
ALTER TABLE vpsurvey_macro ADD CONSTRAINT "vpsurvey_macro_surveyMacroSurveyId_fkey" FOREIGN KEY ("surveyMacroSurveyId")
	REFERENCES vpsurvey ("surveyId") MATCH SIMPLE
	ON DELETE CASCADE;
--tell vpsurvey it can delete dependent photos
ALTER TABLE vpsurvey_photos DROP CONSTRAINT "vpsurvey_photos_surveyPhotoSurveyId_fkey";
ALTER TABLE vpsurvey_photos ADD CONSTRAINT "vpsurvey_photos_surveyPhotoSurveyId_fkey" FOREIGN KEY ("surveyPhotoSurveyId")
	REFERENCES vpsurvey ("surveyId") MATCH SIMPLE
	ON DELETE CASCADE;
--tell vpsurvey it can delete dependent years
ALTER TABLE vpsurvey_year DROP CONSTRAINT "vpsurvey_year_surveyYearSurveyId_fkey";
ALTER TABLE vpsurvey_year ADD CONSTRAINT "vpsurvey_year_surveyYearSurveyId_fkey" FOREIGN KEY ("surveyYearSurveyId")
	REFERENCES vpsurvey ("surveyId") MATCH SIMPLE
	ON DELETE CASCADE;
