CREATE VIEW 
	survey_amphib_safe AS
SELECT 
    "surveyAmphibSurveyId",
    "surveyAmphibObsId",
    "surveyAmphibEdgeStart",
    "surveyAmphibEdgeStop",
    "surveyAmphibEdgeWOFR",
    "surveyAmphibEdgeSPSA",
    "surveyAmphibEdgeJESA",
    "surveyAmphibEdgeBLSA",
    "surveyAmphibInteriorStart",
    "surveyAmphibInteriorStop",
    "surveyAmphibInteriorWOFR",
    "surveyAmphibInteriorSPSA",
    "surveyAmphibInteriorJESA",
    "surveyAmphibInteriorBLSA",
    "surveyAmphibPolarizedGlasses",
    "createdAt" AS "surveyAmphibCreatedAt",
    "updatedAt" AS "surveyAmphibUpdatedAt"
FROM
	vpsurvey_amphib;

--select * from survey_amphib_safe where "surveyAmphibSurveyId"=281;