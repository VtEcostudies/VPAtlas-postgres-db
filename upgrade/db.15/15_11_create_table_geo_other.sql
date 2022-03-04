CREATE TABLE IF NOT EXISTS geo_other
(
    "geoName" text PRIMARY KEY NOT NULL UNIQUE,
    "geoPolygon" geometry(Geometry,4326)
    --, CONSTRAINT geo_other_pkey PRIMARY KEY ("geoName")
)
