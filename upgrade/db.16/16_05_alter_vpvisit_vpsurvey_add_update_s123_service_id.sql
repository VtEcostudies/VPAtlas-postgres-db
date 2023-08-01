
ALTER TABLE vpvisit ADD COLUMN "visitServiceId" TEXT;
--ALTER TABLE vpvisit ALTER COLUMN "visitServiceId" TYPE TEXT USING "visitServiceId"::text;

--select "surveyDataUrl",* from vpsurvey where "surveyDataUrl" is not null;
--ALTER TABLE vpsurvey RENAME COLUMN "visitDataUrl" TO "surveyServiceId"; --visitDataUrl was unused in vpsurvey. convert it.
--ALTER TABLE vpsurvey ALTER COLUMN "surveyServiceId" TYPE TEXT USING "surveyServiceId"::text;
ALTER TABLE vpsurvey ADD COLUMN "surveyServiceId" TEXT;

SELECT "surveyId" FROM vpsurvey WHERE "surveyGlobalId" IS NOT NULL;

ALTER TABLE vpsurvey DISABLE TRIGGER ALL;
UPDATE vpsurvey SET "surveyServiceId"='service_e4f2a9746905471a9bb0d7a2d3d2c2a1'; --WHERE "surveyGlobalId" is not null;
ALTER TABLE vpsurvey ENABLE TRIGGER ALL;

SELECT "surveyServiceId" FROM vpsurvey WHERE "surveyServiceId" IS NOT NULL;

---

SELECT "visitId" FROM vpvisit WHERE "visitGlobalId" IS NOT NULL;

ALTER TABLE vpvisit DISABLE TRIGGER ALL;
UPDATE vpvisit SET "visitServiceId"='service_b9c42b1cd7994b3a80ff4a57806b96b9' WHERE "visitGlobalId" IS NOT NULL;
ALTER TABLE vpvisit ENABLE TRIGGER ALL;

SELECT "visitServiceId" FROM vpvisit WHERE "visitServiceId" IS NOT NULL;