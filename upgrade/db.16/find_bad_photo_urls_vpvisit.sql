select "visitId","visitUserName","visitPoolId", "createdAt","updatedAt",
"visitPoolPhoto","visitWoodFrogPhoto","visitSpsPhoto","visitJesaPhoto",
"visitBssaPhoto","visitFingerNailClamsPhoto","visitFairyShrimpPhoto"
from vpvisit 
where 
"visitPoolPhoto" like '%fakepath%'
OR "visitWoodFrogPhoto" like '%fakepath%'
OR "visitSpsPhoto" like '%fakepath%'
OR "visitJesaPhoto" like '%fakepath%'
OR "visitBssaPhoto" like '%fakepath%'
OR "visitFingerNailClamsPhoto" like '%fakepath%'
OR "visitFairyShrimpPhoto" like '%fakepath%'
OR "visitSpeciesOtherPhoto" like '%fakepath%'
;
