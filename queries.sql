--Find camera settings behind a specific photo
SELECT "iso", "fstop", "shutter"
FROM "exif"
WHERE "photo_id" IN (
    SELECT "id"
    FROM "photos"
    WHERE "photo" = 'DSC0005'
);

--Find photos taken while on a trip to a country in a specific year
SELECT "photo"
FROM "photos"
WHERE "id" IN (
    SELECT "photo_id"
    FROM "travel_photos"
    WHERE "location_id" IN (
        SELECT "id"
        FROM "locations"
        WHERE "country" = 'Japan'
        AND "trip_date" LIKE '2025%'
    )
);

--Find which cameras were taken on a specific trip
SELECT *
FROM "cameras"
WHERE "id" IN (
    SELECT "camera_id"
    FROM "travel_photos"
    WHERE "location_id" IN (
        SELECT "id"
        FROM "locations"
        WHERE "trip" = "Lampang & Chiang Rai"
    )
);


--Insert a new trip, relevant location tags and dates
INSERT INTO "locations" ("trip", "city", "country", "trip_date")
VALUES
('South Korea grad trip', 'Incheon', 'South Korea', '2024-06-29'),
('South Korea grad trip', 'Seoul', 'South Korea', '2024-06-30'),
('South Korea grad trip', 'Busan', 'South Korea', '2024-06-30'),
('South Korea grad trip', 'Busan', 'South Korea', '2024-07-01'),
('South Korea grad trip', 'Seoul', 'South Korea', '2024-07-02');


