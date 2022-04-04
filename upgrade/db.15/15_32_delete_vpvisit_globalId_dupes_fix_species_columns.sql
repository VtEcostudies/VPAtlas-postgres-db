--To get a SUM of visit species counts, we have to use COALESCE, because any null wrecks an integer sum.
--While that does work, we should FIX VALUES FOR ALL COUNT COLUMNS, THEN CONSTRAIN NOT NULL AND DEFAULT 0.

--But to do that, we have to be able to update vpvisit. When I tried, I found visit duplicates (because the
--'set user id' trigger revealed them) and needed to fix those. In theory, those arose from incomplete trigger
--code in this development system. However, here we remove visitGlobalId duplicates:

SELECT "visitGlobalId", count(*)
FROM vpvisit
GROUP BY "visitGlobalId"
HAVING count(*) > 1 AND "visitGlobalId" IS NOT NULL;

/*
DELETE FROM vpvisit WHERE "visitId" IN (
	SELECT "visitId" FROM (
		SELECT vpvisit."visitPoolId", vpvisit."visitId", "visitUserName" FROM vpvisit
		JOIN (
			SELECT "visitPoolId", "visitGlobalId", count(*)
			FROM vpvisit
			GROUP BY "visitPoolId", "visitGlobalId"
			HAVING count(*) > 1 AND "visitGlobalId" IS NOT NULL
			) AS dupes --a named subquery behaves like a table
		ON dupes."visitGlobalId"=vpvisit."visitGlobalId"
		WHERE "visitUserName" LIKE '%@%'
	) AS delts --a named subquery behaves like a table
);
*/

ALTER TABLE vpvisit DISABLE TRIGGER ALL;
UPDATE vpvisit SET "visitWoodFrogAdults"=0 WHERE "visitWoodFrogAdults" IS NULL;
UPDATE vpvisit SET "visitWoodFrogLarvae"=0 WHERE "visitWoodFrogLarvae" IS NULL;
UPDATE vpvisit SET "visitWoodFrogEgg"=0 WHERE "visitWoodFrogEgg" IS NULL;
UPDATE vpvisit SET "visitSpsAdults"=0 WHERE "visitSpsAdults" IS NULL;
UPDATE vpvisit SET "visitSpsLarvae"=0 WHERE "visitSpsLarvae" IS NULL;
UPDATE vpvisit SET "visitSpsEgg"=0 WHERE "visitSpsEgg" IS NULL;
UPDATE vpvisit SET "visitJesaAdults"=0 WHERE "visitJesaAdults" IS NULL;
UPDATE vpvisit SET "visitJesaLarvae"=0 WHERE "visitJesaLarvae" IS NULL;
UPDATE vpvisit SET "visitJesaEgg"=0 WHERE "visitJesaEgg" IS NULL;
UPDATE vpvisit SET "visitBssaAdults"=0 WHERE "visitBssaAdults" IS NULL;
UPDATE vpvisit SET "visitBssaLarvae"=0 WHERE "visitBssaLarvae" IS NULL;
UPDATE vpvisit SET "visitBssaEgg"=0 WHERE "visitBssaEgg" IS NULL;
UPDATE vpvisit SET "visitFairyShrimp"=0 WHERE "visitFairyShrimp" IS NULL;
UPDATE vpvisit SET "visitFingerNailClams"=0 WHERE "visitFingerNailClams" IS NULL;
UPDATE vpvisit SET "visitSpeciesOtherCount"=0 WHERE "visitSpeciesOtherCount" IS NULL;
ALTER TABLE vpvisit ENABLE TRIGGER ALL;

ALTER TABLE vpvisit ALTER COLUMN "visitWoodFrogAdults" SET NOT NULL;
ALTER TABLE vpvisit ALTER COLUMN "visitWoodFrogAdults" SET DEFAULT 0;
ALTER TABLE vpvisit ALTER COLUMN "visitWoodFrogLarvae" SET NOT NULL;
ALTER TABLE vpvisit ALTER COLUMN "visitWoodFrogLarvae" SET DEFAULT 0;
ALTER TABLE vpvisit ALTER COLUMN "visitWoodFrogEgg" SET NOT NULL;
ALTER TABLE vpvisit ALTER COLUMN "visitWoodFrogEgg" SET DEFAULT 0;
ALTER TABLE vpvisit ALTER COLUMN "visitSpsAdults" SET NOT NULL;
ALTER TABLE vpvisit ALTER COLUMN "visitSpsAdults" SET DEFAULT 0;
ALTER TABLE vpvisit ALTER COLUMN "visitSpsLarvae" SET NOT NULL;
ALTER TABLE vpvisit ALTER COLUMN "visitSpsLarvae" SET DEFAULT 0;
ALTER TABLE vpvisit ALTER COLUMN "visitSpsEgg" SET NOT NULL;
ALTER TABLE vpvisit ALTER COLUMN "visitSpsEgg" SET DEFAULT 0;
ALTER TABLE vpvisit ALTER COLUMN "visitJesaAdults" SET NOT NULL;
ALTER TABLE vpvisit ALTER COLUMN "visitJesaAdults" SET DEFAULT 0;
ALTER TABLE vpvisit ALTER COLUMN "visitJesaLarvae" SET NOT NULL;
ALTER TABLE vpvisit ALTER COLUMN "visitJesaLarvae" SET DEFAULT 0;
ALTER TABLE vpvisit ALTER COLUMN "visitJesaEgg" SET NOT NULL;
ALTER TABLE vpvisit ALTER COLUMN "visitJesaEgg" SET DEFAULT 0;
ALTER TABLE vpvisit ALTER COLUMN "visitBssaAdults" SET NOT NULL;
ALTER TABLE vpvisit ALTER COLUMN "visitBssaAdults" SET DEFAULT 0;
ALTER TABLE vpvisit ALTER COLUMN "visitBssaLarvae" SET NOT NULL;
ALTER TABLE vpvisit ALTER COLUMN "visitBssaLarvae" SET DEFAULT 0;
ALTER TABLE vpvisit ALTER COLUMN "visitBssaEgg" SET NOT NULL;
ALTER TABLE vpvisit ALTER COLUMN "visitBssaEgg" SET DEFAULT 0;
ALTER TABLE vpvisit ALTER COLUMN "visitFairyShrimp" SET NOT NULL;
ALTER TABLE vpvisit ALTER COLUMN "visitFairyShrimp" SET DEFAULT 0;
ALTER TABLE vpvisit ALTER COLUMN "visitFingerNailClams" SET NOT NULL;
ALTER TABLE vpvisit ALTER COLUMN "visitFingerNailClams" SET DEFAULT 0;
ALTER TABLE vpvisit ALTER COLUMN "visitSpeciesOtherCount" SET DEFAULT 0;

ALTER TABLE vpvisit ADD CONSTRAINT "unique_visitGlobalId" UNIQUE("visitGlobalId");

select * from vpvisit where "visitGlobalId"='22221c5c-4fcc-43ef-91bd-da7c8e320f56';
delete from vpvisit where "visitGlobalId"='22221c5c-4fcc-43ef-91bd-da7c8e320f56' and "visitUserName" like '%@%';
select * from vpvisit where "visitGlobalId"='c9a7a764-6205-4298-bb12-ea6183f6989f';
delete from vpvisit where "visitGlobalId"='c9a7a764-6205-4298-bb12-ea6183f6989f' and "visitUserName" like '%@%';


select "visitId",
"visitWoodFrogAdults",
"visitWoodFrogLarvae",
"visitWoodFrogEgg",
"visitSpsAdults",
"visitSpsLarvae",
"visitSpsEgg",
"visitJesaAdults",
"visitJesaLarvae",
"visitJesaEgg",
"visitBssaAdults",
"visitBssaLarvae",
"visitBssaEgg",
"visitFairyShrimp",
"visitFingerNailClams",
"visitSpeciesOtherCount"
from vpvisit where
(
"visitWoodFrogAdults" IS NULL OR
"visitWoodFrogLarvae" IS NULL OR
"visitWoodFrogEgg" IS NULL OR
"visitSpsAdults" IS NULL OR
"visitSpsLarvae" IS NULL OR
"visitSpsEgg" IS NULL OR
"visitJesaAdults" IS NULL OR
"visitJesaLarvae" IS NULL OR
"visitJesaEgg" IS NULL OR
"visitBssaAdults" IS NULL OR
"visitBssaLarvae" IS NULL OR
"visitBssaEgg" IS NULL OR
"visitFairyShrimp" IS NULL OR
"visitFingerNailClams" IS NULL OR
"visitSpeciesOtherCount" IS NULL
);
