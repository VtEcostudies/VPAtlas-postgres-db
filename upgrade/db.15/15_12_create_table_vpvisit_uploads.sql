
CREATE TABLE vpvisit_uploads (
	"visitUploadId" SERIAL UNIQUE,
	"visitUpload_fieldname" TEXT NOT NULL,
	"visitUpload_mimetype" TEXT NOT NULL,
	"visitUpload_path" TEXT NOT NULL,
	"visitUpload_size" INTEGER,
	"visitUploadType" TEXT, --INSERT or UPDATE
	"visitUploadSuccess" BOOLEAN,
	"visitUploadVisitId" jsonb[],
	"visitUploadError" TEXT,
	"visitUploadDetail" TEXT,
	"visitUploadRowCount" INTEGER
);
