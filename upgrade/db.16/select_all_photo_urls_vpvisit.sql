SELECT "visitId","visitUserName","visitPoolId", "createdAt","updatedAt",
"visitPoolPhoto","visitWoodFrogPhoto","visitSpsPhoto","visitJesaPhoto",
"visitBssaPhoto","visitFingerNailClamsPhoto","visitFairyShrimpPhoto"
FROM vpvisit WHERE 
"visitPoolPhoto" IS NOT NULL OR
"visitWoodFrogPhoto" IS NOT NULL OR
"visitSpsPhoto" IS NOT NULL OR
"visitJesaPhoto" IS NOT NULL OR
"visitBssaPhoto" IS NOT NULL OR
"visitFingerNailClamsPhoto" IS NOT NULL OR
"visitFairyShrimpPhoto" IS NOT NULL OR 
"visitSpeciesOtherPhoto" IS NOT NULL
;
