--ALTER TABLE vpreview ADD CONSTRAINT vpreview_unique_pool_id_pool_locator UNIQUE ("reviewPoolId", "reviewPoolLocator");
--Don't do it this way, yet. Let's just set all others to false on trigger in function, below, of new one.
--ALTER TABLE vpreview DROP CONSTRAINT vpreview_unique_pool_id_pool_locator;

--get visit Dupes for visitPoolId, visitDate and visitUserName
select "visitPoolId", "visitDate", "visitUserName", count(*)
from vpvisit
group by "visitPoolId", "visitDate", "visitUserName"
having count(*) > 1; --1 MLS566

--UPDATE vpvisit SET "visitDate"='2018-09-28' WHERE "visitId"='1748';

ALTER TABLE vpvisit ADD CONSTRAINT "vpVisit_unique_visitPoolId_visitDate_visitUserName"
  UNIQUE("visitPoolId", "visitDate", "visitUserName");
