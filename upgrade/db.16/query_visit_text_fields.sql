select 
"visitHabitatComment"
/*
"visitLocationComments",
"visitHabitatComment",
"visitSpeciesComments",
"visitWoodFrogNotes",
"visitSpsNotes",
"visitJesaNotes",
"visitBssaNotes",
"visitFairyShrimpNotes",
"visitFingerNailClamsNotes",
"visitSpeciesOtherNotes"
*/
from vpvisit
where
"visitHabitatComment" is not null
/*
"visitLocationComments" is not null or
"visitHabitatComment" is not null or
"visitSpeciesComments" is not null or
"visitWoodFrogNotes" is not null or
"visitSpsNotes" is not null or
"visitJesaNotes" is not null or
"visitBssaNotes" is not null or
"visitFairyShrimpNotes" is not null or
"visitFingerNailClamsNotes" is not null or
"visitSpeciesOtherNotes" is not null
*/