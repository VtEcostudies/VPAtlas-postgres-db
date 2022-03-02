ALTER TABLE vpmapped DISABLE TRIGGER trigger_before_insert_set_mapped_user_id_from_mapped_by_user;
ALTER TABLE vpmapped DISABLE TRIGGER trigger_before_update_set_mapped_user_id_from_mapped_by_user;

update vpmapped set "mappedTownId"="geoTownId" from geo_town
where ST_WITHIN("mappedPoolLocation", "geoTownPolygon");

ALTER TABLE vpmapped ENABLE TRIGGER trigger_before_insert_set_mapped_user_id_from_mapped_by_user;
ALTER TABLE vpmapped ENABLE TRIGGER trigger_before_update_set_mapped_user_id_from_mapped_by_user;
