-- DROP TABLE IF EXISTS vpvisit_photos;
CREATE TABLE IF NOT EXISTS vpvisit_photos
(
    "visitPhotoVisitId" integer NOT NULL,
    "visitPhotoSpecies" text  NOT NULL,
    "visitPhotoUrl" text NOT NULL,
    "visitPhotoName" text,
    CONSTRAINT "vpvisit_photos_unique_visitId_species_url" UNIQUE ("visitPhotoVisitId", "visitPhotoSpecies", "visitPhotoUrl"),
    CONSTRAINT "vpvisit_photos_visitPhotoVisitId_fkey" FOREIGN KEY ("visitPhotoVisitId")
        REFERENCES vpvisit ("visitId") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

ALTER TABLE IF EXISTS vpvisit_photos
    OWNER to vpatlas;