-- DROP FUNCTION IF EXISTS public.set_visit_user_id_from_visit_user_name();

CREATE OR REPLACE FUNCTION public.set_visit_user_id_from_visit_user_name()
    RETURNS trigger
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	obs_id integer;
BEGIN
	--Handle visitUserName with username or email input
	RAISE NOTICE 'set_visit_user_id_from_visit_user_name() visitUserName: % | visitUserId: %', NEW."visitUserName", NEW."visitUserId";
	NEW."visitUserName" := btrim(NEW."visitUserName", '\"'); --trim dbl-quotes from input
	NEW."visitUserId" := find_or_insert_user_from_ambig_user_email_input(NEW."visitUserName");
	IF NEW."visitUserId" IS NOT NULL THEN -- don't display emails publicly if we found a user by incoming email
		NEW."visitUserName" := SPLIT_PART(NEW."visitUserName", '@', 1);
		RAISE NOTICE 'Found user. Trimmed email to visitUserName %.', NEW."visitUserName";
	END IF;

	--Handle visitObserverUserName with username or email input
	RAISE NOTICE 'set_visit_user_id_from_visit_user_name() visitObserverUserName: %', NEW."visitObserverUserName";
	NEW."visitObserverUserName" := btrim(NEW."visitObserverUserName", '\"'); --trim dbl-quotes from input
	obs_id := find_or_insert_user_from_ambig_user_email_input(NEW."visitObserverUserName");
	IF obs_id IS NOT NULL THEN -- don't display emails publicly if we found a user by incoming email
		NEW."visitObserverUserName" := SPLIT_PART(NEW."visitObserverUserName", '@', 1);
		RAISE NOTICE 'Found observer. Trimmed email to visitOberverUserName %.', NEW."visitObserverUserName";
	END IF;

	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.set_visit_user_id_from_visit_user_name()
    OWNER TO vpatlas;

DROP TRIGGER IF EXISTS trigger_before_insert_set_visit_user_id_from_visit_user_name ON public.vpvisit;
CREATE TRIGGER trigger_before_insert_set_visit_user_id_from_visit_user_name
    BEFORE INSERT
    ON public.vpvisit
    FOR EACH ROW
    EXECUTE FUNCTION public.set_visit_user_id_from_visit_user_name();

DROP TRIGGER IF EXISTS trigger_before_update_set_visit_user_id_from_visit_user_name ON public.vpvisit;
CREATE TRIGGER trigger_before_update_set_visit_user_id_from_visit_user_name
    BEFORE UPDATE
    ON public.vpvisit
    FOR EACH ROW
    EXECUTE FUNCTION public.set_visit_user_id_from_visit_user_name();
