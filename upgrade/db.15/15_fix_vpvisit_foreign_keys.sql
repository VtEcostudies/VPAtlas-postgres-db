alter table vpvisit drop constraint fk_pool_id;
alter table vpvisit drop constraint fk_user_id;
alter table vpvisit add constraint fk_vpvisit_vptown_id foreign key ("visitTownId") references vptown("townId");
alter table vpvisit drop constraint fk_town_id;

--get visit Dupes for visitPoolId, visitDate and visitUserName
select "visitPoolId", "visitDate", "visitUserName", count(*)
from vpvisit
group by "visitPoolId", "visitDate", "visitUserName"
having count(*) > 1; --1 MLS566

ALTER TABLE vpvisit ADD CONSTRAINT "vpVisit_unique_visitPoolId_visitDate_visitUserName"
  UNIQUE("visitPoolId", "visitDate", "visitUserName");
