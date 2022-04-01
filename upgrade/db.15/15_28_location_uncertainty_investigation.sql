select distinct("mappedLocationUncertainty") from vpmapped;
select distinct("mappedLocationAccuracy") from vpmapped; --L,H,ML,M,MH,H,UNK
select distinct("mappedConfidence") from vpmapped; --L,H,ML,M,MH,H,UNK
select distinct("visitLocationUncertainty") from vpvisit;
select distinct("visitCertainty") from vpvisit;

select * from vpmapped where "mappedLocationUncertainty"='Pretty Sure'; --6 rows
select * from vpmapped where "mappedLocationUncertainty"='Not Sure'; --2 rows
select * from vpmapped where "mappedLocationUncertainty"='Certain'; -- rows
select * from vpmapped where "mappedLocationUncertainty"='Visited'; -- rows

select "mappedPoolId", "mappedMethod", "mappedLocationUncertainty", "visitLocationUncertainty" 
from vpmapped join vpvisit on "mappedPoolId"="visitPoolId"
where "mappedLocationUncertainty" != "visitLocationUncertainty" and "visitLocationUncertainty" != '';

select "visitPoolId","visitLocationUncertainty" from vpvisit 
	where "visitLocationUncertainty" not in ('10','50','100','>100');
select "mappedPoolId","mappedLocationUncertainty","mappedMethod","mappedPoolStatus" from vpmapped 
	where "mappedLocationUncertainty" not in ('10','50','100','>100');