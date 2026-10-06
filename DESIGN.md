# Design Document

By Pimbuppha Pongtornpipat
edX username: pimbupphaP
GitHub username: pimbupphaP

Video: https://youtu.be/bX9B9_Nw9-0
Slides: https://docs.google.com/presentation/d/18Q6qJypw1YAxNXP7vozUUbXpOJ3FmtVzECJ2hQ231Mk/edit?usp=sharing


## Scope

The database for CS50 SQL includes all entities necessary to facilitate the process of searching and organizing travel photos within a larger pool of photos.

Included in the project’s scope are the following:
* Photos, including the file names of all photos taken (travel and non-travel)
* EXIF (Exchangeable Image File Format) data, including the metadata detailing the camera settings behind each photo
* Locations, including all trip names and each trip’s locations, countries, and travel dates
* Camera, including the cameras used to take photos

Out of scope are classifying non-travel photos by location or by other criteria.


## Functional Requirements

This database will support:
* Creating and updating a directory of all photos taken, travel locations, and cameras
* Viewing the EXIF metadata behind each photo
* Organizing and looking up travel photos based on photo file names, travel location tags, and cameras


## Representation

Entities are captured in SQLite tables with the following schema.

### Entities

The database includes the following entities:

#### Photos

The purpose of this table is to compile a complete directory of all photos taken, alongside the date and time it was taken.

* ‘id’, which specifies the unique ID for each photo. This column is an ‘INTEGER’ and has the ‘PRIMARY KEY’ constraint applied.
* ‘photo’, which is the file name of each photo assigned automatically by the camera. Different cameras may have different naming conventions. This column is a ‘TEXT’ as names may include both numbers and strings.
* ‘photo_date’, which is the date of which the photo was taken. This column is a ‘NUMERIC’ and formatted as ‘YYYY-MM-DD’.
* ‘photo_time’, which is the time of which the photo was taken. This column is a ‘NUMERIC’ and formatted as ‘HH:MM:SS’.

All columns in the ‘photos’ table have the ‘NOT NULL’ constraint applied. The 'photo' column was not given the 'UNIQUE' constraint as some cameras may reuse file names. For example, when a camera reaches file 'DSC9999', the camera may restart the file-naming conventions and the next file will be 'DSC0001'.

#### EXIF

Metadata could be readily extracted from the EXIF file of each photo, which provides details such as date, time, and camera settings. The purpose of this table is to see the camera settings behind each photo.

* ‘id’, which specifies the unique ID for each EXIF file. This column is an ‘INTEGER’ and has the ‘PRIMARY KEY’ constraint applied.
* ‘photo_id’, which specifies the ID of an individual photo. This column is an ‘INTEGER’ and is a ‘FOREIGN KEY’ referencing the ‘id’ column in the ‘photos’ table.
* ‘size’, which is the file size of the raw photo, measured in megabytes. This column is a ‘NUMERIC’ as this will involve decimal numbers.
* ‘iso’, which is the ISO setting of the raw photo. ISO is the camera setting related to light sensitivity, which influences the brightness of a photo. This column is an ‘INTEGER’ as ISO is notated in whole numbers.
* ‘fstop’, which is the f-stop setting of the raw photo. F-stop represents the aperture size of the camera, which affects the depth of field of the photo. This column is a ‘TEXT’ as f-stop is notated starting with “f/” and followed by a number, such as “f/4.0”.
* ‘shutter’, which is the shutter speed setting of the raw photo. Shutter speed indicates the duration of time that the camera’s shutter is open to light, which impacts brightness and how motion is captured in a photo. This column is a ‘TEXT’ as shutter speed is measured in seconds or a fraction of a second, which is notated with a forward slash, such as “1/200” means one-two-hundredths of a second.

All columns in the ‘exif’ table have the ‘NOT NULL’ constraint applied.

#### Locations

Memorable travel photos and unremarkable everyday photos could get mixed up if not sorted properly. The purpose of this table is to set up tags ready to organize travel photos by the entire trip as a whole, by city, by country, or by trip date.

* ‘id’, which specifies the unique ID for each travel location. This column is an ‘INTEGER’ and has the ‘PRIMARY KEY’ constraint applied.
* ‘trip’, which is the name of a trip. This column is a ‘TEXT’ as it is a name field.
* ‘city’, which is the name of a city visited. This column is a ‘TEXT’ as it is a name field.
* ‘country’, which is the country visited. This column is a ‘TEXT’ as it is a name field.
* ‘trip_date’, which is the date of which a location in the trip was visited. This column is a ‘NUMERIC’ and formatted as ‘YYYY-MM-DD’.

The ‘id’, ‘trip’, ‘country’, and ‘trip_date’ columns have the ‘NOT NULL’ constraint applied. The ‘city’ column could be ‘NULL’ in the case of an unspecified location, such as photos taken while in transit between two locations or simply not knowing the name of a location.

#### Cameras

Cameras are not limited to just digital cameras, but could include other photo-taking devices as well such as mobile phone cameras. Multiple cameras could be used throughout the years or be used simultaneously, such as going on a trip with both a digital camera and a phone camera.

* ‘id’, which specifies the unique ID for each camera. This column is an ‘INTEGER’ and has the ‘PRIMARY KEY’ constraint applied.
* ‘camera’, which is the model of the camera taking the photo. This column is a ‘TEXT’ as it is a name field.
* ‘maker’, which is the maker or brand of the camera. This column is a ‘TEXT’ as it is a name field.

All columns in the ‘cameras’ table have the ‘NOT NULL’ constraint applied.

#### Travel Photos

Not every photo taken will be from a trip. The photos listed in the ‘travel_photos’ table are a selection from the pool of all photos in the ‘photos’ table. The purpose of this table is to have a narrowed directory of only travel photos and to link each travel photo to a trip location.

* ‘id’, which specifies the unique ID for each travel photo. This column is an ‘INTEGER’ and has the ‘PRIMARY KEY’ constraint applied.
* ‘photo_id’, which specifies the ID of an individual photo. This column is an ‘INTEGER’ and is a ‘FOREIGN KEY’ referencing the ‘id’ column in the ‘photos’ table.
* ‘location_id’, which specifies the ID of an individual travel location. This column is an ‘INTEGER’ and is a ‘FOREIGN KEY’ referencing the ‘id’ column in the ‘locations’ table.
* ‘camera_id’, which specifies the ID of an individual camera. This column is an ‘INTEGER’ and is a ‘FOREIGN KEY’ referencing the ‘id’ column in the ‘cameras’ table.

All columns in the ‘travel_photos’ table have the ‘NOT NULL’ constraint applied.


### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.

https://docs.google.com/drawings/d/1V9nGpFQjMH44DwzkO3KU0Jwn7-cNBRxn3d4T50yB_CM/edit?usp=sharing

As detailed by the diagram:
* Only one EXIF file is generated per photo and so a photo will have only one EXIF file.
* A camera can take one or many photos, whereas a photo can be taken by only one camera.
* A photo may or may not be classified as a travel photo, meaning a zero-or-one relationship: zero where a certain photo is not a travel photo, and one where a certain photo is a travel photo . However, a travel photo will always be a photo in a one-to-one relationship.
* A travel photo can be taken at only one location. At the same time, a location can have one or multiple travel photos.


## Optimizations

Queries in this database will very often require the use of photo names and photo ID assigned by SQL in the ‘photos’ table. It is thus imperative to create indexes to optimize these searches as there can be thousands of photos taken. Indexes are created on the ‘photo’ column of the ‘photos’ table (‘photo_index’) and the ‘photo_id’ column of the ‘exif’ (‘exif_index’) and ‘travel_photos’ (travel_index’) tables.

As the main objective of this project is to compile a list of travel photos while excluding non-travel photos, the ‘travel_list’ view was created to achieve this. This view joins the ‘locations’ and ‘photos’ tables, with data from the ‘travel_photos’ table acting as the reference link. Another useful view to have is the ‘photo_exif’ view, which joins the ‘photos’ and ‘exif’ tables to provide complete details behind each photo in the same table.


## Limitations

* Depending on the camera and its available settings, it may automatically and simultaneously save the same photo in multiple formats (e.g. RAW and JPEG) when the photo is taken. This leads to one photo having multiple files. However, for this project, we will assume all photos have only one image file format to avoid duplicating names of the same photo.
* Realistically, a complication is the date and time of a photo may not be accurate. For example, the date and time in a digital camera is manually set and does not automatically adapt to timezone changes (thus date and time is inaccurate travelling to a different timezone and the clock was not manually recalibrated), while a mobile phone camera automatically changes timezones upon connection with a mobile network. For the sake of simplicity, we will assume the date and times of all photos are timezone-accurate and thus could be ordered by date and time correctly.
* The ‘exif’ table currently lists only four basic metadata (size, ISO, F-stop, and shutter speed), but more advanced information could be extracted and added in if desired. However, this will take up more space and query run-time.

