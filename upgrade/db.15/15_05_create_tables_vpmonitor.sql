DROP VIEW IF EXISTS pool_stats;

DROP TABLE IF EXISTS vpsurvey_uploads; --log table
DROP TABLE IF EXISTS vpsurvey_amphib; --join table
DROP TABLE IF EXISTS vpsurvey_macro; --join table
DROP TABLE IF EXISTS vpsurvey_equipment_status; --join table
DROP TABLE IF EXISTS vpsurvey_photos; --join table
DROP TABLE IF EXISTS vpsurvey_year; --join table
DROP TABLE IF EXISTS vpsurvey; --primary table
DROP TABLE IF EXISTS def_survey_type;
DROP TABLE IF EXISTS def_beaufort_wind_scale;
DROP TABLE IF EXISTS def_survey_equipment_status;
DROP TABLE IF EXISTS def_survey_equipment;
DROP TABLE IF EXISTS def_survey_species;

/*
  Definition table for the types of surveys performed on monitored vernal pools.
*/
CREATE TABLE def_survey_type (
	"surveyTypeId" INTEGER UNIQUE NOT NULL PRIMARY KEY,
	"surveyTypeName" TEXT NOT NULL UNIQUE,
	"surveyTypeDesc" TEXT
);
INSERT INTO def_survey_type ("surveyTypeId", "surveyTypeName", "surveyTypeDesc") VALUES
(1, 'Equipment Setup', 'The first visit of the spring.'),
(2, 'Early Survey', 'Survey the vernal pool for life soon after it thaws.'),
(3, 'Late Survey', 'Survey the vernal pool a few weeks after the Early Survey / Visit 2.'),
(4, 'Fall Visit', 'Reset the data logger (HOBO, AudioMoth or other) in the fall.'),
(9, 'Additional/Supplemental', 'Any non-essential visit to gather data, anecdotal information, or check on equipment.');

/*
  Definition table for the beaufort scale of wind strength.
*/
CREATE TABLE def_beaufort_wind_scale (
  "beaufortWindForce" INTEGER UNIQUE NOT NULL PRIMARY KEY,
  "beaufortWindMphMin" INTEGER,
  "beaufortWindMphMax" INTEGER,
  "beaufortWindName" TEXT NOT NULL UNIQUE,
  "beaufortWindLandDesc" TEXT
);
INSERT INTO def_beaufort_wind_scale
	("beaufortWindForce", "beaufortWindMphMin", "beaufortWindMphMax", "beaufortWindName", "beaufortWindLandDesc") VALUES
(0, 0, 1, 'Calm', 'Calm. Smoke rises vertically.'),
(1, 1, 3, 'Light Air', 'Direction of wind shown by smoke drift, but not by wind vanes.'),
(2, 4, 7, 'Light Breeze', 'Wind felt on face. Leaves rustle. Ordinary vanes moved by wind.'),
(3, 8, 12, 'Gentle Breeze', 'Leaves and small twigs in constant motion. Wind extends light flag.'),
(4, 13, 18, 'Moderate Breeze', 'Raises dust and loose paper. Small branches are moved.'),
(5, 19, 24, 'Fresh Breeze', 'Small trees in leaf begin to sway. Crested wavelets form on inland waters.'),
(6, 25, 31, 'Strong Breeze', 'Large branches in motion. Whistling heard in telegraph wires. Umbrellas used with difficulty.'),
(7, 32, 38, 'Near Gale', 'Whole trees in motion. Inconvenience felt when walking against the wind.'),
(8, 39, 46, 'Gale', 'Breaks twigs off trees; generally impedes progress.'),
(9, 47, 54, 'Severe Gale', 'Slight structural damage occurs (chimney-pots and slates removed)'),
(10, 55, 63, 'Storm', 'Seldom experienced inland. Trees uprooted. Considerable structural damage occurs.'),
(11, 64, 72, 'Violent Storm', 'Very rarely experienced. Accompanied by wide-spread damage.'),
(12, 72, 83, 'Hurricane', 'See Saffir-Simpson Hurricane Scale');

/*
	Definition table for equipment status values.
*/
CREATE TABLE def_survey_equipment_status(
	"statusId" INTEGER NOT NULL PRIMARY KEY,
	"status" TEXT NOT NULL
);
INSERT INTO def_survey_equipment_status ("statusId", "status") VALUES
(0, 'Not yet set up'),
(1, 'Set up this visit'),
(2, 'Already set up'),
(10, 'Not yet collected'),
(11, 'Collected on this visit'),
(12, 'Already collected'),
(20, 'Not reconfigured'),
(21, 'Reconfigured and placed in original location'),
(22, 'Reconfigured and placed in new location'),
(30, 'Data not downloaded'),
(31, 'Data downloaded'),
(99, 'Never set up');

/*
	Definition table for survey equipment.
	Types of equipment available in 2021:
		- Acoustic Monitor
		- HOBO logger
		- AudioMoth
		- Custom Datalogger designed and built by volunteers
*/
CREATE TABLE def_survey_equipment (
	"equipmentId" INTEGER NOT NULL PRIMARY KEY,
	"equipmentType" TEXT NOT NULL, --eg. HOBO, AudioMoth, Acoustic Recorder
	"equipmentDataType" TEXT, --eg. temperature, audio, depth
	"equipmentDataFormat" TEXT, --eg. [csv], [csv, csv], [wav]
	"equipmentServiceIntervalMonths" INTEGER DEFAULT 12,
	CONSTRAINT def_survey_equipment_unique UNIQUE("equipmentType", "equipmentDataType")
);
INSERT INTO def_survey_equipment(
  "equipmentId", "equipmentType", "equipmentDataType", "equipmentDataFormat", "equipmentServiceIntervalMonths") VALUES
(0, 'HOBO logger', 'temperature', 'csv', 36),
(1, 'Acoustic Recorder', 'audio', 'wav', 12),
(2, 'AudioMoth', 'audio', 'wav', 12),
(3, 'Custom datalogger v1', 'temperature', 'csv', 12),
(4, 'Custom datalogger v1', 'pool depth', 'csv', 12),
(5, 'Custom datalogger v1', 'rainfall', 'csv', 12);

/*
	Primary table for Vernal Pool Monitoring Surveys.

	A vpsurvey is a single pool-monitoring (survey) event.
	To group surveys into a pool-monitoring season we create a join table,
	vpsurvey_year to associate surveys of a single pool done for one season/year.

  NOTES:
    'surveyUserId' refers to the user who entered data.
*/
create table vpsurvey (
	"surveyId" SERIAL UNIQUE NOT NULL PRIMARY KEY,
	"surveyGlobalId" uuid,
	"surveyPoolId" TEXT NOT NULL REFERENCES vpmapped("mappedPoolId"),
	"surveyTypeId" INTEGER NOT NULL REFERENCES def_survey_type("surveyTypeId"),
	"surveyUserEmail" TEXT NOT NULL, --DO NOT apply reference to email to allow user emails to change
	"surveyUserId" INTEGER REFERENCES vpuser(id), --see TRIGGER FUNCTION set_survey_user_id_from_survey_user_email()
	"surveyDate" DATE NOT NULL,
	"surveyTime" TIME NOT NULL,
	--"surveyTownId" INTEGER NOT NULL REFERENCES vptown("townId"),
	"surveyPoolLatitude" NUMERIC(11,8),
	"surveyPoolLongitude" NUMERIC(11,8),
	--"surveyPoolLocationGeo" geometry(Geometry, 4326), --leave these to vpmapped alone
	"surveyPoolBorderJson" jsonb,
	--"surveyPoolBorderGeo" geometry(Geometry, 4326), --leave these to vpmapped alone
	"surveyAcousticMonitor" TEXT,
	"surveyHoboLogger" TEXT,
	"surveyHoboData" TEXT,
	"surveyCustomLogger" TEXT,
	"surveyIceCover" INTEGER,
	"surveyWaterLevel" INTEGER,
	"surveySubmergedVeg" INTEGER,
	"surveyFloatingVeg" INTEGER,
	"surveyEmergentVeg" INTEGER,
	"surveyShrubs" INTEGER,
	"surveyTrees" INTEGER,
	"surveyPhysicalParametersNotes" TEXT,
	"surveyAirTempF" NUMERIC(5,2),
	"surveyHumidity" NUMERIC(5,2),
	"surveyWindBeaufort" INTEGER REFERENCES def_beaufort_wind_scale("beaufortWindForce"),
	"surveyWeatherConditions" TEXT,
	"surveyWeatherNotes" TEXT,
	"surveySpermatophores" BOOLEAN DEFAULT false,
	"surveyAmphibMacroNotes" TEXT,
	"surveyEdgeVisualImpairment" INTEGER,
	"surveyInteriorVisualImpairment" INTEGER,
	--"surveyPolarizedGlasses" BOOLEAN DEFAULT false,
	"surveyAmphibJson" jsonb,
	"surveyMacroJson" jsonb,
	"surveyYearJson" jsonb,
	"surveyPhotoJson" jsonb,
	"surveyGlobalId" uuid,
	"surveyObjectId" INTEGER,
	"surveyDataUrl" TEXT,
	"createdAt" TIMESTAMP DEFAULT NOW(),
	"updatedAt" TIMESTAMP DEFAULT NOW()
);

ALTER TABLE vpsurvey DROP CONSTRAINT IF EXISTS "vpsurvey_unique_surveyPoolId_surveyTypeId_surveyDate";
ALTER TABLE vpsurvey ADD CONSTRAINT "vpsurvey_unique_surveyPoolId_surveyTypeId_surveyDate"
	UNIQUE("surveyPoolId","surveyTypeId","surveyDate");

/*
	Join table for surveys and survey seasons/years.

	NOTE: This table is necessary because surveys can be used in more than
	one survey season/year.
*/
CREATE TABLE vpsurvey_year (
	"surveyYear" INTEGER NOT NULL,
	"surveyYearSurveyId" INTEGER NOT NULL REFERENCES vpsurvey("surveyId") ON DELETE CASCADE
);
ALTER TABLE vpsurvey_year ADD CONSTRAINT "vpsurvey_year_unique_surveyId_surveyYear" UNIQUE("surveyYearSurveyId", "surveyYear");

/*
	Join table for vernal pool monitoring equipment status at surveys.

	NOTE: Some equipment status values require a date, when the equipment status
	change happened on a different date than the survey date.
*/
CREATE TABLE vpsurvey_equipment_status (
	"surveyEquipmentSurveyId" INTEGER NOT NULL REFERENCES vpsurvey("surveyId"),
	"surveyEquipmentId" INTEGER NOT NULL REFERENCES def_survey_equipment("equipmentId"),
	"surveyEquipmentStatusId" INTEGER NOT NULL REFERENCES def_survey_equipment_status("statusId"),
	"surveyEquipmentStatusDate" TIMESTAMP DEFAULT NULL,
	"createdAt" TIMESTAMP DEFAULT NOW(),
	"updatedAt" TIMESTAMP DEFAULT NOW()
);

CREATE TABLE vpsurvey_amphib (
		"surveyAmphibSurveyId" INTEGER NOT NULL REFERENCES vpsurvey("surveyId") ON DELETE CASCADE,
	"surveyAmphibObsEmail" TEXT NOT NULL, --do not reference vpuser("email") to allow users to change emails
	"surveyAmphibObsId" INTEGER REFERENCES vpuser(id), --db TRIGGER sets this from email on insert/update
	"surveyAmphibPolarizedGlasses" BOOLEAN DEFAULT false,
	"surveyAmphibEdgeStart" TIME,
	"surveyAmphibEdgeStop" TIME,
	"surveyAmphibEdgeWOFR" INTEGER,
	"surveyAmphibEdgeSPSA" INTEGER,
	"surveyAmphibEdgeJESA" INTEGER,
	"surveyAmphibEdgeBLSA" INTEGER,
	"surveyAmphibInteriorStart" TIME,
	"surveyAmphibInteriorStop" TIME,
	"surveyAmphibInteriorWOFR" INTEGER,
	"surveyAmphibInteriorSPSA" INTEGER,
	"surveyAmphibInteriorJESA" INTEGER,
	"surveyAmphibInteriorBLSA" INTEGER,
	"createdAt" TIMESTAMP DEFAULT NOW(),
	"updatedAt" TIMESTAMP DEFAULT NOW()
);

ALTER TABLE vpsurvey_amphib DROP CONSTRAINT IF EXISTS "vpsurvey_amphib_unique_surveyId_observerEmail";
ALTER TABLE vpsurvey_amphib ADD CONSTRAINT "vpsurvey_amphib_unique_surveyId_observerEmail"
	UNIQUE("surveyAmphibSurveyId","surveyAmphibObsEmail");

CREATE TABLE vpsurvey_macro (
	"surveyMacroSurveyId" INTEGER NOT NULL REFERENCES vpsurvey("surveyId") ON DELETE CASCADE,
	--"surveyMacroObsEmail" TEXT NOT NULL, --do not reference vpuser("email") to allow users to change emails
	--"surveyMacroObsId" INTEGER REFERENCES vpuser(id), --db TRIGGER sets this from email on insert/update
	"surveyMacroNorthFASH" INTEGER,
	"surveyMacroEastFASH" INTEGER,
	"surveyMacroSouthFASH" INTEGER,
	"surveyMacroWestFASH" INTEGER,
	"surveyMacroTotalFASH" INTEGER,
	"surveyMacroNorthCDFY" INTEGER,
	"surveyMacroEastCDFY" INTEGER,
	"surveyMacroSouthCDFY" INTEGER,
	"surveyMacroWestCDFY" INTEGER,
	"surveyMacroTotalCDFY" INTEGER,
	"createdAt" TIMESTAMP DEFAULT NOW(),
	"updatedAt" TIMESTAMP DEFAULT NOW()
);

ALTER TABLE vpsurvey_macro DROP CONSTRAINT IF EXISTS "vpsurvey_macro_unique_surveyId";
ALTER TABLE vpsurvey_macro ADD CONSTRAINT "vpsurvey_macro_unique_surveyId"
	UNIQUE("surveyMacroSurveyId");

/*
  Definition table for photographable vernal pool indicator species.
*/
CREATE TABLE def_survey_species (
  "surveySpeciesAbbrev" TEXT NOT NULL UNIQUE,
  "surveySpeciesCommon" TEXT NOT NULL UNIQUE,
  "surveySpeciesScientific" TEXT NOT NULL UNIQUE
);
INSERT INTO def_survey_species ("surveySpeciesAbbrev", "surveySpeciesCommon", "surveySpeciesScientific") VALUES
('WOFR','Wood Frog', 'Lithobates sylvaticus'),
('SPSA','Spotted Salamander','Ambystoma maculatum'),
('JESA','Jefferson Salamander','Ambystoma jeffersonianum'),
('BLSA','Blue-spotted Salamander','Ambystoma laterale'),
('FASH','FairyShrimp','Eubranchipus bundyi'),
('CDFY','Caddisfly','Trichoptera'),
('POOL','Vernal Pool','Poolus vernale'),
('UNKNOWN','Unknown Species','Speciei incognitus');

/*
  Join table for survey photos by surveyId and species
*/
CREATE TABLE vpsurvey_photos (
  "surveyPhotoSurveyId" INTEGER NOT NULL REFERENCES vpsurvey("surveyId") ON DELETE CASCADE,
  "surveyPhotoSpecies" TEXT NOT NULL REFERENCES def_survey_species("surveySpeciesAbbrev"),
  "surveyPhotoUrl" TEXT NOT NULL,
  "surveyPhotoName" TEXT
);

ALTER TABLE vpsurvey_photos ADD CONSTRAINT "vpsurvey_photos_unique_surveyId_species_url"
	UNIQUE("surveyPhotoSurveyId","surveyPhotoSpecies","surveyPhotoUrl");

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON vpsurvey
  FOR EACH ROW EXECUTE PROCEDURE set_updated_at();
CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON vpsurvey_amphib
  FOR EACH ROW EXECUTE PROCEDURE set_updated_at();
CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON vpsurvey_macro
  FOR EACH ROW EXECUTE PROCEDURE set_updated_at();
CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON vpsurvey_equipment_status
  FOR EACH ROW EXECUTE PROCEDURE set_updated_at();

CREATE TABLE vpsurvey_uploads (
	"surveyUploadId" SERIAL UNIQUE,
	"surveyUpload_fieldname" TEXT NOT NULL,
	"surveyUpload_mimetype" TEXT NOT NULL,
	"surveyUpload_path" TEXT NOT NULL,
	"surveyUpload_size" INTEGER,
	"surveyUploadType" TEXT, --INSERT or UPDATE
	"surveyUploadSuccess" BOOLEAN,
	"surveyUploadSurveyId" jsonb[],
	"surveyUploadError" TEXT,
	"surveyUploadDetail" TEXT,
	"surveyUploadRowCount" INTEGER
);

--REMOVE foreign key constraint on survey email. This allows users' emails to change.
--To handle this, we use column surveyUserId and a TRIGGER to set its value from matching email in vpuser.
ALTER TABLE vpsurvey DROP CONSTRAINT IF EXISTS "vpsurvey_surveyUserEmail_fkey";

--Now create a function and triggers to convert surveyUserEmail into surveyUserId
--DROP FUNCTION IF EXISTS set_survey_user_id_from_survey_user_email();
CREATE OR REPLACE FUNCTION set_survey_user_id_from_survey_user_email()
    RETURNS trigger
		LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	NEW."surveyUserId" = (SELECT "id" FROM vpuser WHERE "email"=NEW."surveyUserEmail");
	RAISE NOTICE 'set_survey_user_id_from_survey_user_email() email:% | userId:%', NEW."surveyUserEmail", NEW."surveyUserId";
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION set_survey_user_id_from_survey_user_email()
    OWNER TO vpatlas;

DROP TRIGGER IF EXISTS trigger_before_insert_set_survey_user_id_from_survey_user_email ON vpsurvey;
CREATE TRIGGER trigger_before_insert_set_survey_user_id_from_survey_user_email BEFORE INSERT ON vpsurvey
  FOR EACH ROW EXECUTE PROCEDURE set_survey_user_id_from_survey_user_email();
DROP TRIGGER IF EXISTS trigger_before_update_set_survey_user_id_from_survey_user_email ON vpsurvey;
CREATE TRIGGER trigger_before_update_set_survey_user_id_from_survey_user_email BEFORE UPDATE ON vpsurvey
  FOR EACH ROW EXECUTE PROCEDURE set_survey_user_id_from_survey_user_email();

UPDATE vpsurvey SET "surveyUserEmail"="surveyUserEmail"; --this bumps the BEFORE UPDATE TRIGGER above

--DROP FUNCTION IF EXISTS insert_vpsurvey_subtables_from_vpsurvey_jsonb();
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

ALTER FUNCTION insert_vpsurvey_subtables_from_vpsurvey_jsonb()
    OWNER TO vpatlas;

DROP TRIGGER IF EXISTS trigger_after_insert_vpsurvey_subtables_from_vpsurvey_jsonb ON vpsurvey;
CREATE TRIGGER trigger_after_insert_vpsurvey_subtables_from_vpsurvey_jsonb AFTER INSERT ON vpsurvey
  FOR EACH ROW EXECUTE PROCEDURE insert_vpsurvey_subtables_from_vpsurvey_jsonb();

DROP FUNCTION IF EXISTS update_vpsurvey_subtables_from_vpsurvey_jsonb();
--DROP FUNCTION IF EXISTS delete_vpsurvey_subtables_from_vpsurvey_jsonb();
CREATE OR REPLACE FUNCTION delete_vpsurvey_subtables_from_vpsurvey_jsonb()
    RETURNS trigger
		LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
amphibJson jsonb := NEW."surveyAmphibJson";
macroJson jsonb := NEW."surveyMacroJson";
yearJson jsonb := NEW."surveyYearJson";
photoJson jsonb := NEW."surveyPhotoJson";
BEGIN
	RAISE NOTICE 'DELETE_vpsurvey_subtables_from_vpsurvey_jsonb() surveyId:%', NEW."surveyId";
	RAISE NOTICE 'surveyPhotoJson: %', photoJson;
	RAISE NOTICE 'surveyYearJson->>surveyYear: %', yearJson->>'surveyYear';
	RAISE NOTICE 'surveyMacroJson: %', macroJson;
	RAISE NOTICE 'surveyAmphibJson.1: %', amphibJson->'1';
	RAISE NOTICE 'surveyAmphibJson.2: %', amphibJson->'2';
	DELETE FROM vpsurvey_photos WHERE "surveyPhotoSurveyId"=NEW."surveyId";
	DELETE FROM vpsurvey_year WHERE "surveyYearSurveyId"=NEW."surveyId";
	DELETE FROM vpsurvey_amphib WHERE "surveyAmphibSurveyId"=NEW."surveyId";
	DELETE FROM vpsurvey_macro WHERE "surveyMacroSurveyId"=NEW."surveyId";
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION delete_vpsurvey_subtables_from_vpsurvey_jsonb()
    OWNER TO vpatlas;

--For a wholesale update from a complete vpsurvey record, we delete subtables BEFORE UPDATE
DROP TRIGGER IF EXISTS trigger_before_update_vpsurvey_subtables_from_vpsurvey_jsonb ON vpsurvey;
CREATE TRIGGER trigger_before_update_vpsurvey_subtables_from_vpsurvey_jsonb BEFORE UPDATE ON vpsurvey
	FOR EACH ROW EXECUTE PROCEDURE delete_vpsurvey_subtables_from_vpsurvey_jsonb();

--For a wholesale update from a complete vpsurvey record, we insert subtables AFTER UPDATE
DROP TRIGGER IF EXISTS trigger_after_update_vpsurvey_subtables_from_vpsurvey_jsonb ON vpsurvey;
CREATE TRIGGER trigger_after_update_vpsurvey_subtables_from_vpsurvey_jsonb AFTER UPDATE ON vpsurvey
	FOR EACH ROW EXECUTE PROCEDURE insert_vpsurvey_subtables_from_vpsurvey_jsonb();

-- Add a mapped method value 'Survey' for the purpose, used below.
ALTER TYPE vp_mapped_method ADD VALUE IF NOT EXISTS 'Survey' AFTER 'Visit';

--DROP FUNCTION IF EXISTS insert_mapped_pool_from_survey_data();
CREATE OR REPLACE FUNCTION insert_mapped_pool_from_survey_data()
	RETURNS trigger
	LANGUAGE 'plpgsql'
	AS $BODY$
	DECLARE
		extant text;
	BEGIN
		RAISE NOTICE 'insert_mapped_pool_from_survey_data() surveyPoolId: %', NEW."surveyPoolId";
		SELECT "mappedPoolId" FROM vpmapped WHERE "mappedPoolId"=NEW."surveyPoolId" INTO extant;
		IF extant IS NULL THEN
			INSERT INTO vpmapped (
				"mappedPoolId",
				"mappedByUser",
				"mappedUserId",
				"mappedDateText",
				"mappedLatitude",
				"mappedLongitude",
				"mappedMethod",
				"mappedObserverUserName",
				"mappedPoolStatus")
				VALUES (
				NEW."surveyPoolId",
				(SELECT username FROM vpuser WHERE email=NEW."surveyUserEmail"),
				(SELECT id FROM vpuser WHERE email=NEW."surveyUserEmail"),
				NEW."surveyDate",
				NEW."surveyPoolLatitude",
				NEW."surveyPoolLongitude",
				'Survey',
				(SELECT username FROM vpuser WHERE email=NEW."surveyUserEmail"),
				'Confirmed');
		END IF;
		RETURN NEW;
END;
$BODY$;

ALTER FUNCTION insert_mapped_pool_from_survey_data()
    OWNER TO vpatlas;

--Create mapped pool from first survey data upload if mappedPool doesn't exist
DROP TRIGGER IF EXISTS trigger_before_insert_survey_insert_mapped_pool_from_survey_data ON vpsurvey;
CREATE TRIGGER trigger_before_insert_survey_insert_mapped_pool_from_survey_data BEFORE INSERT ON vpsurvey
  FOR EACH ROW EXECUTE PROCEDURE insert_mapped_pool_from_survey_data();
