ALTER TABLE vpmapped ENABLE TRIGGER ALL;
ALTER TABLE vpvisit ENABLE TRIGGER ALL;
ALTER TABLE vpreview ENABLE TRIGGER ALL;
ALTER TABLE vpsurvey ENABLE TRIGGER ALL;

SELECT "reviewPoolId", "reviewId", vpreview."updatedAt" 
FROM vpreview
INNER JOIN vpmapped ON "mappedPoolId"="reviewPoolId"
INNER JOIN vpvisit ON  "visitPoolId"="reviewPoolId"
WHERE vpmapped."updatedAt" > vpreview."updatedAt" OR
vpvisit."updatedAt" > vpreview."updatedAt";

ALTER TABLE vpreview DISABLE TRIGGER ALL;

UPDATE vpreview 
SET "updatedAt"=now() AT time zone 'utc'
FROM vpmapped
WHERE "mappedPoolId"="reviewPoolId" AND vpmapped."updatedAt" > vpreview."updatedAt";

UPDATE vpreview 
SET "updatedAt"=now() AT time zone 'utc'
FROM vpvisit
WHERE "visitPoolId"="reviewPoolId" AND vpvisit."updatedAt" > vpreview."updatedAt";

ALTER TABLE vpreview ENABLE TRIGGER ALL;