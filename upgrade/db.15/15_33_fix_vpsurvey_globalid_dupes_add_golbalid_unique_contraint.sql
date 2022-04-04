SELECT "surveyGlobalId", count(*)
FROM vpsurvey
GROUP BY "surveyGlobalId"
HAVING count(*) > 1 AND "surveyGlobalId" IS NOT NULL

--select * from vpsurvey where "surveyGlobalId"='703ac831-de80-4e79-8627-21b1758569ba';
--delete from vpsurvey where "surveyId"=2809;

/*
DELETE FROM vpsurvey WHERE "surveyId" IN (
	SELECT "surveyId" FROM (
		SELECT vpsurvey."surveyPoolId", vpsurvey."surveyId", "surveyUserEmail" FROM vpsurvey
		JOIN (
			SELECT "surveyPoolId", "surveyGlobalId", count(*)
			FROM vpsurvey
			GROUP BY "surveyPoolId", "surveyGlobalId"
			HAVING count(*) > 1 AND "surveyGlobalId" IS NOT NULL
			) AS dupes --a named subquery behaves like a table
		ON dupes."surveyGlobalId"=vpsurvey."surveyGlobalId"
		WHERE "surveyUserEmail" LIKE '%@%'
	) AS delts --a named subquery behaves like a table
);
*/

ALTER TABLE vpsurvey ADD CONSTRAINT "unique_surveyGlobalId" UNIQUE("surveyGlobalId");
