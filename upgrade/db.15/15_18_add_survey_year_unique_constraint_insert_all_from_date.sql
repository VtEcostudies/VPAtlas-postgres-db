ALTER TABLE vpsurvey_year ADD CONSTRAINT "vpsurvey_year_unique_surveyId_surveyYear" UNIQUE("surveyYearSurveyId", "surveyYear");

INSERT INTO vpsurvey_year 
("surveyYearSurveyId", "surveyYear")
SELECT "surveyId", EXTRACT(YEAR FROM "surveyDate")
FROM vpsurvey
ON CONFLICT ON CONSTRAINT "vpsurvey_year_unique_surveyId_surveyYear" DO NOTHING;
