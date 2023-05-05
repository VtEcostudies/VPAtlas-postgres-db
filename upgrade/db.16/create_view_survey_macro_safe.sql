CREATE VIEW 
	survey_macro_safe AS
SELECT 
	"surveyMacroSurveyId",
    "surveyMacroNorthFASH",
    "surveyMacroEastFASH",
    "surveyMacroSouthFASH",
    "surveyMacroWestFASH",
    "surveyMacroTotalFASH",
    "surveyMacroNorthCDFY",
    "surveyMacroEastCDFY",
    "surveyMacroSouthCDFY",
    "surveyMacroWestCDFY",
    "surveyMacroTotalCDFY",
    "createdAt" AS "surveyMacroCreatedAt",
    "updatedAt" AS "surveyMacroUpdatedAt"
FROM
	vpsurvey_macro;

--SELECT * FROM survey_macro_safe WHERE "surveyMacroSurveyId"=570;