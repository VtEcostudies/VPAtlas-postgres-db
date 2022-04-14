
DELETE FROM vpsurvey WHERE "surveyId" IN (
SELECT "maxSurveyId" FROM (
	SELECT vs."surveyPoolId", vs."surveyTypeId", vs."surveyUserEmail", vs."surveyDate", vs."surveyTime",
	max(vs."surveyId") AS "maxSurveyId"
	FROM vpsurvey vs JOIN
		(SELECT "surveyPoolId", "surveyTypeId", "surveyUserEmail", "surveyDate", "surveyTime", count(*)
		FROM "vpsurvey"
		GROUP BY "surveyPoolId", "surveyTypeId", "surveyUserEmail", "surveyDate", "surveyTime"
		HAVING count(*) > 1)
		AS dupes
	ON dupes."surveyPoolId"=vs."surveyPoolId"
	AND dupes."surveyTypeId"=vs."surveyTypeId"
	AND dupes."surveyUserEmail"=vs."surveyUserEmail"
	AND dupes."surveyDate"=vs."surveyDate"
	AND dupes."surveyTime"=vs."surveyTime"
	GROUP BY vs."surveyPoolId", vs."surveyTypeId", vs."surveyUserEmail", vs."surveyDate", vs."surveyTime"
	) AS maxdupes
);

ALTER TABLE vpsurvey DROP CONSTRAINT
"vpsurvey_unique_survey_PoolId_TypeId_Date_GlobalId";
ALTER TABLE vpsurvey ADD CONSTRAINT
"vpsurvey_unique_survey_PoolId_User_TypeId_Date_Time"
UNIQUE ("surveyPoolId", "surveyTypeId", "surveyUserEmail", "surveyDate", "surveyTime");
