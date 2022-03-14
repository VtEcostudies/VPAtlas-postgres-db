--fix bug preventing deletion of users having aliases
ALTER TABLE vpuser_alias DROP CONSTRAINT "vpuser_alias_aliasUserId_fkey";
ALTER TABLE vpuser_alias ADD CONSTRAINT "vpuser_alias_aliasUserId_fkey" FOREIGN KEY ("aliasUserId")
        REFERENCES public.vpuser (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE;

--fix bug in alias array-to-table function on empy array
CREATE OR REPLACE FUNCTION set_vpuser_alias_rows_from_vpuser_array()
    RETURNS trigger
		LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	alias text;
BEGIN
	DELETE FROM vpuser_alias WHERE "aliasUserId"=NEW."id";
	RAISE NOTICE 'Alias Array %', NEW."alias";
	IF array_length(NEW.alias::TEXT[], 1) IS NOT NULL THEN
		FOR i IN array_lower(NEW.alias, 1) .. array_upper(NEW.alias, 1)
		LOOP
			RAISE NOTICE 'alias: %', NEW.alias[i];
			INSERT INTO vpuser_alias ("aliasUserId", "alias") VALUES (NEW."id", NEW.alias[i]);
		END LOOP;
	END IF;
	RETURN NEW;
END;
$BODY$;
