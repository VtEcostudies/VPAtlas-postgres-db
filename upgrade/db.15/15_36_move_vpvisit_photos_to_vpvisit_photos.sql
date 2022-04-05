select * from vpvisit_photos;
select
"visitPoolPhoto",
"visitWoodFrogPhoto",
"visitSpsPhoto",
"visitJesaPhoto",
"visitBssaPhoto",
"visitFairyShrimpPhoto",
"visitFingerNailClamsPhoto",
"visitSpeciesOtherPhoto"
from vpvisit
where "visitPoolPhoto" is not null;
