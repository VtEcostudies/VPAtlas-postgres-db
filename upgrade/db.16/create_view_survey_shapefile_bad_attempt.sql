DROP VIEW IF EXISTS survey_shapefile;

CREATE VIEW 
	survey_shapefile AS
SELECT
  "mappedPoolId" AS "poolId",
  "mappedPoolStatus" AS "poolStatus",
  "mappedPoolLocation",
  
  "townName",
  "countyName",

  "surveyUserId",
  "surveyDate",
  "surveyTime",
  "surveyAcousticMonitor",
  "surveyHoboLogger",
  "surveyHoboData",
  "surveyCustomLogger",
  "surveyIceCover",
  "surveyWaterLevel",
  "surveySubmergedVeg",
  "surveyFloatingVeg",
  "surveyEmergentVeg",
  "surveyShrubs",
  "surveyTrees",
  "surveyPhysicalParametersNotes",
  "surveyAirTempF",
  "surveyHumidity",
  "surveyWindBeaufort",
  "surveyWeatherConditions",
  "surveyWeatherNotes",
  "surveySpermatophores",
  "surveyAmphibMacroNotes",
  "surveyEdgeVisualImpairment",
  "surveyInteriorVisualImpairment",
  "surveyGlobalId",
  "surveyObjectId",
  "surveyDataUrl",

  (SELECT json_agg(json_build_object(
    'surveyAmphibSurveyId', "surveyAmphibSurveyId",
    'surveyAmphibObsUser', (SELECT "username" FROM vpuser WHERE id="surveyAmphibObsId"),
    'surveyAmphibEdgeStart', "surveyAmphibEdgeStart",
    'surveyAmphibEdgeStop', "surveyAmphibEdgeStop",
    'surveyAmphibEdgeWOFR', "surveyAmphibEdgeWOFR",
    'surveyAmphibEdgeSPSA', "surveyAmphibEdgeSPSA",
    'surveyAmphibEdgeJESA', "surveyAmphibEdgeJESA",
    'surveyAmphibEdgeBLSA', "surveyAmphibEdgeBLSA",
    'surveyAmphibInteriorStart', "surveyAmphibInteriorStart",
    'surveyAmphibInteriorStop', "surveyAmphibInteriorStop",
    'surveyAmphibInteriorWOFR', "surveyAmphibInteriorWOFR",
    'surveyAmphibInteriorSPSA', "surveyAmphibInteriorSPSA",
    'surveyAmphibInteriorJESA', "surveyAmphibInteriorJESA",
    'surveyAmphibInteriorBLSA', "surveyAmphibInteriorBLSA",
    'surveyAmphibPolarizedGlasses', "surveyAmphibPolarizedGlasses"
    ))::text 
  FROM vpsurvey_amphib WHERE "surveyAmphibSurveyId"="surveyId") 
  AS "surveyAmphib",
  
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

  (SELECT json_agg(json_build_object(
    'surveyPhotoSpecies', "surveyPhotoSpecies",
    'surveyPhotoUrl', "surveyPhotoUrl"
    ))::text 
  FROM vpsurvey_photos WHERE "surveyPhotoSurveyId"="surveyId") 
  AS "surveyPhotos",
  
  "surveyYear"
  FROM vpsurvey
  INNER JOIN vpmapped ON "mappedPoolId"="surveyPoolId"
  INNER JOIN vpsurvey_macro ON "surveyMacroSurveyId"="surveyId"
  INNER JOIN vpsurvey_year ON "surveyYearSurveyId"="surveyId"
  INNER JOIN def_survey_type ON def_survey_type."surveyTypeId"=vpsurvey."surveyTypeId"
  INNER JOIN vptown ON "mappedTownId"="townId"
  INNER JOIN vpcounty ON "townCountyId"="govCountyId";

SELECT * FROM survey_shapefile;