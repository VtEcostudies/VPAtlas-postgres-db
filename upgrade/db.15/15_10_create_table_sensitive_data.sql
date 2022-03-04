-- DROP TABLE IF EXISTS vpsensitive_data;

CREATE TABLE IF NOT EXISTS vpsensitive_data
(
    "sensitivePoolId" text PRIMARY KEY NOT NULL UNIQUE,
    "sensitiveDataColumn" text NOT NULL,
    "sensitiveDataDesc" text,
    CONSTRAINT fk_mapped_pool_id FOREIGN KEY ("sensitivePoolId")
  		REFERENCES public.vpmapped ("mappedPoolId") MATCH SIMPLE
  		ON UPDATE NO ACTION
  		ON DELETE NO ACTION
)
