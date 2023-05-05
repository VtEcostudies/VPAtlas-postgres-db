DROP VIEW IF EXISTS survey_shapefile;
/*
IMPORTANT: Do not alter the queried name of columns to be used as WHERE CLAUSE parameters.
ALTERNATIVELY: query the same column twice, once with its original name.
IMPORTANT: Text fields can have bad characters that crash pgsql2shp without an error message.
	If it's crashing and there's no explanation, try leaving out text fields before other fixes.
*/
CREATE VIEW 
	survey_shapefile AS
SELECT
"mappedPoolId",
"mappedPoolStatus",
"mappedPoolLocation",
CONCAT('https://vpatlas.org/pools/list?poolId=',"mappedPoolId",'&zoomFilter=false') AS "poolUrl",
CONCAT('https://vpatlas.org/survey/pool/',"mappedPoolId") AS "srvPoolUrl",
CONCAT('https://vpatlas.org/survey/view/',"surveyId") AS "surveyUrl",

"townName",
"countyName",

"surveyPoolId",
vpsurvey."surveyTypeId",
"surveyTypeName",
"surveyUserId",
"username",
"surveyDate",
"surveyTime",
"surveyAcousticMonitor",-- AS acousmon,
"surveyHoboLogger",-- AS hobologr,
"surveyHoboData",-- AS hobodata,
"surveyCustomLogger",-- AS custlogr,
"surveyIceCover" AS icecover,
"surveyWaterLevel" AS waterlvl,
"surveySubmergedVeg" AS submgveg,
"surveyFloatingVeg" AS floatlvl,
"surveyEmergentVeg" AS emergveg,
"surveyShrubs" AS shrubs,
"surveyTrees" AS trees,
"surveyPhysicalParametersNotes" AS physnote, --NOTE: this could become a problem if it allows bad characters
"surveyAirTempF" as airtempf,
"surveyHumidity" as humidity,
"surveyWindBeaufort" as windbeau,
"surveyWeatherConditions" as condtion,
"surveyWeatherNotes" as wthrnote,
"surveySpermatophores" as sprmafor,
"surveyAmphibMacroNotes" as fbmcnote, --NOTE: this could become a problem if it allows bad characters
"surveyEdgeVisualImpairment" as ejvismpr,
"surveyInteriorVisualImpairment" as ntvismpr,
"surveyGlobalId",-- as globalid,
"surveyObjectId",-- as objectid,
"surveyDataUrl",-- as dataurl,

"surveyAmphibJson"->'1'->>'surveyAmphibObsEmail' AS "1ObsEmail",
"surveyAmphibJson"->'1'->>'surveyAmphibObsId' AS "1ObsId",
"surveyAmphibJson"->'1'->>'surveyAmphibEdgeStart' AS "1EjStrt",
"surveyAmphibJson"->'1'->>'surveyAmphibEdgeStop' AS "1EjStop",
"surveyAmphibJson"->'1'->>'surveyAmphibEdgeWOFR' AS "1EjWOFR",
"surveyAmphibJson"->'1'->>'surveyAmphibEdgeSPSA' AS "1EjSPSA",
"surveyAmphibJson"->'1'->>'surveyAmphibEdgeJESA' AS "1EjJESA",
"surveyAmphibJson"->'1'->>'surveyAmphibEdgeBLSA' AS "1EjBLSA",
"surveyAmphibJson"->'1'->>'surveyAmphibInteriorStart' AS "1InStrt",
"surveyAmphibJson"->'1'->>'surveyAmphibInteriorStop' AS "1InStop",
"surveyAmphibJson"->'1'->>'surveyAmphibInteriorWOFR' AS "1InWOFR",
"surveyAmphibJson"->'1'->>'surveyAmphibInteriorSPSA' AS "1InSPSA",
"surveyAmphibJson"->'1'->>'surveyAmphibInteriorJESA' AS "1InJESA",
"surveyAmphibJson"->'1'->>'surveyAmphibInteriorBLSA' AS "1InBLSA",

"surveyAmphibJson"->'2'->>'surveyAmphibObsEmail' AS "2ObsEmail",
"surveyAmphibJson"->'2'->>'surveyAmphibObsId' AS "2ObsId",
"surveyAmphibJson"->'2'->>'surveyAmphibEdgeStart' AS "2EjStrt",
"surveyAmphibJson"->'2'->>'surveyAmphibEdgeStop' AS "2EjStop",
"surveyAmphibJson"->'2'->>'surveyAmphibEdgeWOFR' AS "2EjWOFR",
"surveyAmphibJson"->'2'->>'surveyAmphibEdgeSPSA' AS "2EjSPSA",
"surveyAmphibJson"->'2'->>'surveyAmphibEdgeJESA' AS "2EjJESA",
"surveyAmphibJson"->'2'->>'surveyAmphibEdgeBLSA' AS "2EjBLSA",
"surveyAmphibJson"->'2'->>'surveyAmphibInteriorStart' AS "2InStrt",
"surveyAmphibJson"->'2'->>'surveyAmphibInteriorStop' AS "2InStop",
"surveyAmphibJson"->'2'->>'surveyAmphibInteriorWOFR' AS "2InWOFR",
"surveyAmphibJson"->'2'->>'surveyAmphibInteriorSPSA' AS "2InSPSA",
"surveyAmphibJson"->'2'->>'surveyAmphibInteriorJESA' AS "2InJESA",
"surveyAmphibJson"->'2'->>'surveyAmphibInteriorBLSA' AS "2InBLSA",
"surveyAmphibJson",

"surveyMacroSurveyId",-- as macsvyid,
"surveyMacroNorthFASH",-- as macnfash,
"surveyMacroEastFASH",-- as macefash,
"surveyMacroSouthFASH",-- as macsfash,
"surveyMacroWestFASH",-- as macwfash,
"surveyMacroTotalFASH",-- as mactfash,
"surveyMacroNorthCDFY",-- as macncdfy,
"surveyMacroEastCDFY",-- as macecdfy,
"surveyMacroSouthCDFY",-- as macscdfy,
"surveyMacroWestCDFY",-- as macwcdfy,
"surveyMacroTotalCDFY",-- as mactcdfy,

"surveyYear"
FROM vpsurvey
INNER JOIN vpmapped ON "mappedPoolId"="surveyPoolId"
INNER JOIN vpsurvey_macro ON "surveyMacroSurveyId"="surveyId"
INNER JOIN vpsurvey_year ON "surveyYearSurveyId"="surveyId"
INNER JOIN def_survey_type ON def_survey_type."surveyTypeId"=vpsurvey."surveyTypeId"
LEFT JOIN vpuser ON "surveyUserEmail"="email"
LEFT JOIN vptown ON "mappedTownId"="townId"
LEFT JOIN vpcounty ON "townCountyId"="govCountyId";

--select * from survey_shapefile;