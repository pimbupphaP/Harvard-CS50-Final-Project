--CREATE TABLES
--'photos' table: a complete directory of all photos taken
CREATE TABLE "photos" (
    "id" INTEGER NOT NULL,
    "photo" TEXT NOT NULL,
    "photo_date" NUMERIC NOT NULL,
    "photo_time" NUMERIC NOT NULL,
    PRIMARY KEY ("id")
);
--.import --csv --skip 1 test-photos.csv photos
--SELECT * FROM "photos";


--'exif' table: metadata of each photo
CREATE TABLE "exif" (
    "id" INTEGER NOT NULL,
    "photo_id" INTEGER NOT NULL,
    "size" NUMERIC NOT NULL,
    "iso" INTEGER NOT NULL,
    "fstop" TEXT NOT NULL,
    "shutter" TEXT NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("photo_id") REFERENCES "photos"("id")
);
--.import --csv --skip 1 test-exif.csv exif
--SELECT * FROM "exif";


--'locations' table: a list of all trip locations and dates
CREATE TABLE "locations" (
    "id" INTEGER NOT NULL,
    "trip" TEXT NOT NULL,
    "city" TEXT DEFAULT NULL,
    "country" TEXT NOT NULL,
    "trip_date" NUMERIC NOT NULL,
    PRIMARY KEY ("id")
);
--.import --csv --skip 1 test-locations.csv locations
--SELECT * FROM "locations";


--'cameras' table: a list of all cameras used
CREATE TABLE "cameras" (
    "id" INTEGER NOT NULL,
    "camera" TEXT NOT NULL,
    "maker" TEXT NOT NULL,
    PRIMARY KEY ("id")
);
--.import --csv --skip 1 test-cameras.csv cameras
--SELECT * FROM "cameras";


--'travel_photos' table: a narrowed directory of travel photos only to show which photos belong to which trip location and taken with which camera
CREATE TABLE "travel_photos" (
    "id" INTEGER NOT NULL,
    "photo_id" INTEGER NOT NULL,
    "location_id" INTEGER NOT NULL,
    "camera_id" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("photo_id") REFERENCES "photos"("id"),
    FOREIGN KEY ("location_id") REFERENCES "locations"("id"),
    FOREIGN KEY ("camera_id") REFERENCES "cameras"("id")
);
--.import --csv --skip 1 test-travelphotos.csv travel_photos
--SELECT * FROM "travel_photos";


--CREATE INDEXES
CREATE INDEX "photo_index" ON "photos"("photo");
CREATE INDEX "exif_index" ON "exif"("photo_id");
CREATE INDEX "travel_index" ON "travel_photos"("photo_id");


--CREATE VIEWS
--'photo_exif' view: join 'photos' and 'exif' tables to see all metadata of each photo in the same table
CREATE VIEW "photo_exif" AS
SELECT * FROM "photos"
JOIN "exif" ON "exif"."photo_id" = "photos"."id";

--'travel_list" view: join 'locations' and 'photos' data via 'travel_photos' table to include travel photos only (i.e. exclude non-trip photos) alongside trip information
CREATE VIEW "travel_list" AS
SELECT "photo_id", "trip", "city", "country" FROM "travel_photos"
JOIN "locations" ON "locations"."id" = "travel_photos"."location_id"
JOIN "photos" ON "photos"."id" = "travel_photos"."photo_id";
