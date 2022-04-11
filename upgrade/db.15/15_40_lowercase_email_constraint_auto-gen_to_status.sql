--We can't create a UNIQUE CONSTRAINT on LOWER(email), but we can to this:
CREATE UNIQUE INDEX vpuser_lowercase_email_index ON vpuser(LOWER(email));

--move 'auto-gen' from middleName to status
SELECT * FROM vpuser WHERE "middleName"='auto-gen';
UPDATE vpuser SET status='auto-gen' WHERE "middleName"='auto-gen';
UPDATE vpuser SET "middleName"='' WHERE "middleName"='auto-gen';