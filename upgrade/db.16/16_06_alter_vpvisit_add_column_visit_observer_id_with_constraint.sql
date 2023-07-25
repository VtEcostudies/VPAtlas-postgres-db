ALTER TABLE vpvisit ADD COLUMN "visitObserverUserId" INTEGER;
ALTER TABLE vpvisit ADD CONSTRAINT fk_vpvisit_observer_id FOREIGN KEY ("visitObserverUserId") REFERENCES vpuser(id) MATCH SIMPLE;