ALTER TABLE vpsurvey DROP CONSTRAINT IF EXISTS "vpsurvey_unique_surveyPoolId_surveyTypeId_surveyDate";
ALTER TABLE vpsurvey DROP CONSTRAINT IF EXISTS "vpsurvey_unique_survey_PoolId_TypeId_Date_GlobalId";
ALTER TABLE vpsurvey ADD CONSTRAINT "vpsurvey_unique_survey_PoolId_TypeId_Date_GlobalId"
	UNIQUE ("surveyPoolId", "surveyTypeId", "surveyDate", "surveyGlobalId");
	
ALTER TABLE vpvisit DROP CONSTRAINT IF EXISTS "vpVisit_unique_visitPoolId_visitDate_visitUserName";
ALTER TABLE vpvisit DROP CONSTRAINT IF EXISTS "vpVisit_unique_visitPoolId_Date_UserName_GlobalId";
ALTER TABLE vpvisit ADD CONSTRAINT "vpVisit_unique_visitPoolId_Date_UserName_GlobalId"
	UNIQUE ("visitPoolId", "visitDate", "visitUserName", "visitGlobalId");