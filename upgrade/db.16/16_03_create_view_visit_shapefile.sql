DROP VIEW IF EXISTS visit_shapefile;
/*
IMPORTANT: Do not alter the queried name of columns to be used as WHERE CLAUSE parameters.
ALTERNATIVELY: query the same column twice, once with its original name.
IMPORTANT: Text fields can have bad characters that crash pgsql2shp without an error message.
	If it's crashing and there's no explanation, try leaving out text fields before trying other fixes.
*/
CREATE OR REPLACE VIEW public.visit_shapefile
AS
SELECT
"mappedPoolId" AS "poolId",
"mappedPoolStatus" AS "poolStatus",
"mappedPoolLocation" AS "poolLocation",
"mappedPoolStatus",
CONCAT('https://vpatlas.org/pools/list?poolId=',"mappedPoolId",'&zoomFilter=false') AS "poolUrl",
CONCAT('https://vpatlas.org/visit/view/',"visitId") AS "visitUrl",
"townName",
"countyName",
"username", --pgsql2shp requires explicit inclusion of field names for WHERE clause
"visitId",
"visitUserName",
"visitUserId",
"visitPoolId",
"visitDate",
"visitLocatePool",
"visitCertainty",
"visitNavMethod",
"visitDirections",
--"visitLocationComments",
--regexp_replace("visitLocationComments", '[^a-zA-Z0-9 .]', '_', 'g') AS "visitLocationComments",
"visitCoordSource",
"visitVernalPool",
"visitPoolType",
"visitInletType",
"visitOutletType",
"visitForestUpland",
"visitForestCondition",
"visitHabitatAgriculture",
"visitHabitatLightDev",
"visitHabitatHeavyDev",
"visitHabitatPavedRd",
"visitHabitatDirtRd",
"visitHabitatPowerline",
"visitHabitatOther",
--"visitHabitatComment",
--even this fails. this column seems to be the bad one.
--regexp_replace("visitHabitatComment", '[^a-zA-Z0-9]', '_', 'g') AS "visitHabitatComment",
"visitMaxDepth",
"visitWaterLevelObs",
"visitHydroPeriod",
"visitMaxWidth",
"visitMaxLength",
"visitPoolTrees",
"visitPoolShrubs",
"visitPoolEmergents",
"visitPoolFloatingVeg",
"visitSubstrate",
"visitDisturbDumping",
"visitDisturbSiltation",
"visitDisturbVehicleRuts",
"visitDisturbRunoff",
"visitDisturbDitching",
"visitDisturbOther",
"visitWoodFrogAdults",
"visitWoodFrogLarvae",
"visitWoodFrogEgg",
"visitWoodFrogEggHow",
"visitSpsAdults",
"visitSpsLarvae",
"visitSpsEgg",
"visitSpsEggHow",
"visitJesaAdults",
"visitJesaLarvae",
"visitJesaEgg",
"visitJesaEggHow",
"visitBssaAdults",
"visitBssaLarvae",
"visitBssaEgg",
"visitBssaEggHow",
"visitFairyShrimp",
"visitFingerNailClams",
"visitSpeciesOther1",
"visitSpeciesOther2",
--"visitSpeciesComments",
--regexp_replace("visitSpeciesComments", '[^a-zA-Z0-9 .]', '_', 'g') AS "visitSpeciesComments",
"visitFish",
"visitFishCount",
"visitFishSizeSmall",
"visitFishSizeMedium",
"visitFishSizeLarge",
"visitPoolPhoto",
vpvisit."createdAt" AS "visitCreatedAt",
vpvisit."updatedAt" AS "visitUpdatedAt",
"visitPoolMapped",
"visitUserIsLandowner",
"visitLandownerPermission",
"visitLandowner"::text,
"visitTownId",
"visitFishSize",
"visitWoodFrogPhoto",
--"visitWoodFrogNotes",
--regexp_replace("visitWoodFrogNotes", '[^a-zA-Z0-9 .]', '_', 'g') AS "visitWoodFrogNotes",
"visitSpsPhoto",
--"visitSpsNotes",
--regexp_replace("visitSpsNotes", '[^a-zA-Z0-9 .]', '_', 'g') AS "visitSpsNotes",
"visitJesaPhoto",
--"visitJesaNotes",
--regexp_replace("visitJesaNotes", '[^a-zA-Z0-9 .]', '_', 'g') AS "visitJesaNotes",
"visitBssaPhoto",
--"visitBssaNotes",
--regexp_replace("visitBssaNotes", '[^a-zA-Z0-9 .]', '_', 'g') AS "visitBssaNotes",
"visitFairyShrimpPhoto",
--"visitFairyShrimpNotes",
--regexp_replace("visitFairyShrimpNotes", '[^a-zA-Z0-9 .]', '_', 'g') AS "visitFairyShrimpNotes",
"visitFingerNailClamsPhoto",
--"visitFingerNailClamsNotes",
--regexp_replace("visitFingerNailClamsNotes", '[^a-zA-Z0-9 .]', '_', 'g') AS "visitFingerNailClamsNotes",
"visitNavMethodOther",
"visitPoolTypeOther",
"visitSubstrateOther",
"visitSpeciesOtherName",
"visitSpeciesOtherCount",
"visitSpeciesOtherPhoto",
--"visitSpeciesOtherNotes",
--regexp_replace("visitSpeciesOtherNotes", '[^a-zA-Z0-9 .]', '_', 'g') AS "visitSpeciesOtherNotes",
"visitLocationUncertainty",
"visitObserverUserName",
"visitWoodFrogiNat",
"visitSpsiNat",
"visitJesaiNat",
"visitBssaiNat",
"visitFairyShrimpiNat",
"visitFingerNailClamsiNat",
"visitSpeciesOtheriNat",
"visitGlobalId",-- AS "globalId",
"visitObjectId",-- AS "objectId",
"visitDataUrl",-- AS "dataUrl"
"reviewId",
"reviewUserName",
"reviewUserId",
"reviewPoolId",
"reviewVisitIdLegacy",
"reviewVisitId",
"reviewQACode",
--"reviewQAAlt",
"reviewQAPerson",
"reviewQADate",
--"reviewQANotes",
"reviewPoolStatus",
"reviewPoolLocator"
FROM vpvisit
INNER JOIN vpmapped ON "visitPoolId"="mappedPoolId"
LEFT JOIN vptown ON "mappedTownId"="townId"
LEFT JOIN vpcounty ON "townCountyId"="govCountyId"
LEFT JOIN vpuser ON "visitUserId"=id
LEFT JOIN vpreview ON "visitId" = "reviewVisitId"
;

--select * from visit_shapefile;