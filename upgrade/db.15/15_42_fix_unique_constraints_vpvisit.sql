DELETE FROM vpvisit WHERE "visitId" IN (
SELECT "maxVisitId" FROM (
	SELECT vv."visitPoolId", vv."visitDate", vv."visitUserName",
	max(vv."visitId") AS "maxVisitId"
	FROM vpvisit vv JOIN
		(SELECT "visitPoolId", "visitDate", "visitUserName", count(*)
		FROM "vpvisit"
		GROUP BY "visitPoolId", "visitDate", "visitUserName"
		HAVING count(*) > 1)
		AS dupes
	ON dupes."visitPoolId"=vv."visitPoolId"
	AND dupes."visitDate"=vv."visitDate"
	AND dupes."visitUserName"=vv."visitUserName"
	GROUP BY vv."visitPoolId", vv."visitDate", vv."visitUserName"
	) AS maxdupes
);

--DELETE FROM vpvisit WHERE "visitId" IN (SELECT "maxVisitId" FROM (SELECT vv."visitPoolId", vv."visitDate", vv."visitUserName", max(vv."visitId") AS "maxVisitId" FROM vpvisit vv JOIN (SELECT "visitPoolId", "visitDate", "visitUserName", count(*)	FROM "vpvisit" GROUP BY "visitPoolId", "visitDate", "visitUserName"	HAVING count(*) > 1) AS dupes ON dupes."visitPoolId"=vv."visitPoolId" AND dupes."visitDate"=vv."visitDate" AND dupes."visitUserName"=vv."visitUserName"	GROUP BY vv."visitPoolId", vv."visitDate", vv."visitUserName") AS maxdupes);

ALTER TABLE vpvisit DROP CONSTRAINT
"vpVisit_unique_visitPoolId_Date_UserName_GlobalId";
ALTER TABLE vpvisit ADD CONSTRAINT
"vpVisit_unique_visitPoolId_Date_UserName"
UNIQUE ("visitPoolId", "visitDate", "visitUserName");
