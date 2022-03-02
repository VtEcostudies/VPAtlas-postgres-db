-- FUNCTION: public.set_updated_at()

-- DROP FUNCTION IF EXISTS public.set_updated_at();

CREATE OR REPLACE FUNCTION public.set_updated_at()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
   NEW."updatedAt" = now() AT TIME ZONE 'UTC'; 
   RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.set_updated_at()
    OWNER TO postgres;