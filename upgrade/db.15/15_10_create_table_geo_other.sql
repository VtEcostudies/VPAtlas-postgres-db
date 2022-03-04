-- DROP TABLE IF EXISTS geo_other;

CREATE TABLE IF NOT EXISTS geo_other
(
    "geoName" text PRIMARY KEY NOT NULL UNIQUE,
    "geoPolygon" geometry(Geometry,4326)
)
