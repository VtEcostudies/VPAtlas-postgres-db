
ALTER TABLE vpsurvey_photos ADD CONSTRAINT "vpsurvey_photos_unique_surveyId_species_url"
	UNIQUE("surveyPhotoSurveyId","surveyPhotoSpecies","surveyPhotoUrl");

ALTER TABLE vpsurvey_photos ADD COLUMN "surveyPhotoName" TEXT;

INSERT INTO def_survey_species ("surveySpeciesAbbrev", "surveySpeciesCommon", "surveySpeciesScientific") VALUES
('UNKNOWN','Unknown Species','Speciei incognitus');

