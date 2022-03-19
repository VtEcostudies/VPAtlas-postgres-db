CREATE OR REPLACE FUNCTION insert_vpsurvey_subtables_from_vpsurvey_jsonb()
    RETURNS trigger
		LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	amphibJson jsonb := NEW."surveyAmphibJson";
	macroJson jsonb := NEW."surveyMacroJson";
	yearJson jsonb := NEW."surveyYearJson";
	photoJson jsonb := NEW."surveyPhotoJson";
	observer text;
	phibJson jsonb;
BEGIN
	RAISE NOTICE 'insert_vpsurvey_subtables_from_vpsurvey_jsonb() surveyId: %', NEW."surveyId";
	RAISE NOTICE 'surveyPhotoJson: %', photoJson;
	RAISE NOTICE 'surveyYearJson->>surveyYear: %', yearJson->>'surveyYear';
	RAISE NOTICE 'surveyMacroJson: %', macroJson;
	RAISE NOTICE 'surveyAmphibJson.1: %', amphibJson->'1';
	RAISE NOTICE 'surveyAmphibJson.2: %', amphibJson->'2';
	IF photoJson != '{}' THEN
		INSERT INTO vpsurvey_photos (
		"surveyPhotoSurveyId",
		"surveyPhotoSpecies",
		"surveyPhotoUrl",
		"surveyPhotoName"
		)
		VALUES (
		NEW."surveyId",
		(photoJson->>'surveyPhotoSpecies')::TEXT,
		(photoJson->>'surveyPhotoUrl')::TEXT,
		(photoJson->>'surveyPhotoName')::TEXT);
	END IF;
	IF yearJson->>'surveyYear' IS NOT NULL THEN
		INSERT INTO vpsurvey_year ("surveyYearSurveyId", "surveyYear")
			VALUES (NEW."surveyId", (yearJson->>'surveyYear')::INTEGER);
	ELSE
		INSERT INTO vpsurvey_year ("surveyYearSurveyId", "surveyYear")
			VALUES (NEW."surveyId", EXTRACT(YEAR FROM NEW."surveyDate"));
	END IF;
	IF macroJson != '{}' THEN
		INSERT INTO vpsurvey_macro (
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
		"surveyMacroTotalCDFY")
		VALUES (
		NEW."surveyId",
		(macroJson->>'surveyMacroNorthFASH')::INTEGER,
		(macroJson->>'surveyMacroEastFASH')::INTEGER,
		(macroJson->>'surveyMacroSouthFASH')::INTEGER,
		(macroJson->>'surveyMacroWestFASH')::INTEGER,
		(macroJson->>'surveyMacroTotalFASH')::INTEGER,
		(macroJson->>'surveyMacroNorthCDFY')::INTEGER,
		(macroJson->>'surveyMacroEastCDFY')::INTEGER,
		(macroJson->>'surveyMacroSouthCDFY')::INTEGER,
		(macroJson->>'surveyMacroWestCDFY')::INTEGER,
		(macroJson->>'surveyMacroTotalCDFY')::INTEGER
		);
	END IF;
	FOR observer, phibJson IN
		 SELECT * FROM jsonb_each(amphibJson)
	LOOP
		RAISE NOTICE 'observer:%, amphibJson:%', observer, phibJson;
		IF phibJson != '{}' THEN
			INSERT INTO vpsurvey_amphib (
			"surveyAmphibSurveyId",
			"surveyAmphibObsEmail",
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
			"surveyAmphibInteriorBLSA")
			VALUES (
			NEW."surveyId",
			(phibJson->'surveyAmphibObsEmail'),
			(SELECT "id" FROM "vpuser" where "email"=(phibJson->>'surveyAmphibObsEmail')),
			(phibJson->>'surveyAmphibEdgeStart')::TIME,
			(phibJson->>'surveyAmphibEdgeStop')::TIME,
			(phibJson->>'surveyAmphibEdgeWOFR')::INTEGER,
			(phibJson->>'surveyAmphibEdgeSPSA')::INTEGER,
			(phibJson->>'surveyAmphibEdgeJESA')::INTEGER,
			(phibJson->>'surveyAmphibEdgeBLSA')::INTEGER,
			(phibJson->>'surveyAmphibInteriorStart')::TIME,
			(phibJson->>'surveyAmphibInteriorStop')::TIME,
			(phibJson->>'surveyAmphibInteriorWOFR')::INTEGER,
			(phibJson->>'surveyAmphibInteriorSPSA')::INTEGER,
			(phibJson->>'surveyAmphibInteriorJESA')::INTEGER,
			(phibJson->>'surveyAmphibInteriorBLSA')::INTEGER
			);
			END IF;
		END LOOP;
	RETURN NEW;
END;
$BODY$;
