CREATE OR REPLACE PROCEDURE vp_fix_bad_photo_urls_vpvisit()
LANGUAGE 'plpgsql'
AS $$
DECLARE
	rec record;
BEGIN
	FOR rec IN SELECT "visitId","visitPoolId","visitPoolPhoto" FROM vpvisit WHERE "visitPoolPhoto" LIKE '%fakepath%'
	LOOP
		RAISE NOTICE '% (%) %', rec."visitId", rec."visitPoolId", rec."visitPoolPhoto";
		UPDATE vpvisit 
			SET "visitPoolPhoto"='https://s3.amazonaws.com/vpatlas.photos/' || rec."visitPoolId" || '/' ||  rec."visitId" || '/Pool.1'
			WHERE "visitId"=rec."visitId";
	END LOOP;
	FOR rec IN SELECT "visitId","visitPoolId","visitWoodFrogPhoto" FROM vpvisit WHERE "visitWoodFrogPhoto" LIKE '%fakepath%'
	LOOP
		RAISE NOTICE '% (%) %', rec."visitId", rec."visitPoolId", rec."visitWoodFrogPhoto";
		UPDATE vpvisit 
			SET "visitWoodFrogPhoto"='https://s3.amazonaws.com/vpatlas.photos/' || rec."visitPoolId" || '/' ||  rec."visitId" || '/WoodFrog.1'
			WHERE "visitId"=rec."visitId";
	END LOOP;
	FOR rec IN 
		SELECT "visitId","visitPoolId","visitSpsPhoto" FROM vpvisit WHERE "visitSpsPhoto" LIKE '%fakepath%'
	LOOP
		RAISE NOTICE '% (%) %', rec."visitId", rec."visitPoolId", rec."visitSpsPhoto";
		UPDATE vpvisit 
			SET "visitSpsPhoto"='https://s3.amazonaws.com/vpatlas.photos/' || rec."visitPoolId" || '/' ||  rec."visitId" || '/Sps.1'
			WHERE "visitId"=rec."visitId";
	END LOOP;
	FOR rec IN 
		SELECT "visitId","visitPoolId","visitJesaPhoto" FROM vpvisit WHERE "visitJesaPhoto" LIKE '%fakepath%'
	LOOP
		RAISE NOTICE '% (%) %', rec."visitId", rec."visitPoolId", rec."visitJesaPhoto";
		UPDATE vpvisit 
			SET "visitJesaPhoto"='https://s3.amazonaws.com/vpatlas.photos/' || rec."visitPoolId" || '/' ||  rec."visitId" || '/Jesa.1'
			WHERE "visitId"=rec."visitId";
	END LOOP;
	FOR rec IN 
		SELECT "visitId","visitPoolId","visitBssaPhoto" FROM vpvisit WHERE "visitBssaPhoto" LIKE '%fakepath%'
	LOOP
		RAISE NOTICE '% (%) %', rec."visitId", rec."visitPoolId", rec."visitBssaPhoto";
		UPDATE vpvisit 
			SET "visitBssaPhoto"='https://s3.amazonaws.com/vpatlas.photos/' || rec."visitPoolId" || '/' ||  rec."visitId" || '/Bssa.1'
			WHERE "visitId"=rec."visitId";
	END LOOP;
	FOR rec IN 
		SELECT "visitId","visitPoolId","visitFingerNailClamsPhoto" FROM vpvisit WHERE "visitFingerNailClamsPhoto" LIKE '%fakepath%'
	LOOP
		RAISE NOTICE '% (%) %', rec."visitId", rec."visitPoolId", rec."visitFingerNailClamsPhoto";
		UPDATE vpvisit 
			SET "visitFingerNailClamsPhoto"='https://s3.amazonaws.com/vpatlas.photos/' || rec."visitPoolId" || '/' ||  rec."visitId" || '/FingerNailClams.1'
			WHERE "visitId"=rec."visitId";
	END LOOP;
	FOR rec IN 
		SELECT "visitId","visitPoolId","visitFairyShrimpPhoto" FROM vpvisit WHERE "visitFairyShrimpPhoto" LIKE '%fakepath%'
	LOOP
		RAISE NOTICE '% (%) %', rec."visitId", rec."visitPoolId", rec."visitFairyShrimpPhoto";
		UPDATE vpvisit 
			SET "visitFairyShrimpPhoto"='https://s3.amazonaws.com/vpatlas.photos/' || rec."visitPoolId" || '/' ||  rec."visitId" || '/FairyShrimp.1'
			WHERE "visitId"=rec."visitId";
	END LOOP;
	FOR rec IN 
		SELECT "visitId","visitPoolId","visitSpeciesOtherPhoto" FROM vpvisit WHERE "visitSpeciesOtherPhoto" LIKE '%fakepath%'
	LOOP
		RAISE NOTICE '% (%) %', rec."visitId", rec."visitPoolId", rec."visitSpeciesOtherPhoto";
		UPDATE vpvisit 
			SET "visitSpeciesOtherPhoto"='https://s3.amazonaws.com/vpatlas.photos/' || rec."visitPoolId" || '/' ||  rec."visitId" || '/SpeciesOther.1'
			WHERE "visitId"=rec."visitId";
	END LOOP;
END;
$$

--CALL vp_fix_bad_photo_urls_vpvisit();