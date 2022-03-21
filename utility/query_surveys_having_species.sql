select "surveyDate", "surveyId", "surveyPoolId", "surveyTypeId", "surveyUserEmail",
("surveyMacroTotalFASH"+"surveyMacroTotalCDFY")::INT AS "sumMacros", 0 as "sumAmphibs"
from vpsurvey
INNER join vpsurvey_macro ON "surveyId"="surveyMacroSurveyId"
WHERE ("surveyMacroTotalFASH" + "surveyMacroTotalCDFY") > 0
UNION
select "surveyDate", "surveyId", "surveyPoolId", "surveyTypeId", "surveyAmphibObsEmail", 
0 as "sumMacros",
("surveyAmphibEdgeWOFR"+"surveyAmphibEdgeSPSA"+"surveyAmphibEdgeJESA"+"surveyAmphibEdgeBLSA"+"surveyAmphibInteriorWOFR"+"surveyAmphibInteriorSPSA"+"surveyAmphibInteriorJESA"+"surveyAmphibInteriorBLSA")::INT
AS "sumAmphibs"
from vpsurvey
INNER join vpsurvey_amphib ON "surveyId"="surveyAmphibSurveyId"
WHERE ("surveyAmphibEdgeWOFR"+"surveyAmphibEdgeSPSA"+"surveyAmphibEdgeJESA"+"surveyAmphibEdgeBLSA"+"surveyAmphibInteriorWOFR"+"surveyAmphibInteriorSPSA"+"surveyAmphibInteriorJESA"+"surveyAmphibInteriorBLSA")::INT > 0

order by "surveyDate" desc, "surveyPoolId" asc,"surveyId" desc