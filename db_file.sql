/* 
What follows is the SQL code for a simple app's db.
The app is a simple HTML form that tries to get reviews from a user
Whatever the user imputs in the form is sent to the db.

I deployed this app using 2 docker containers.
The first container is based on a docker php:7.2-apache image and serves as the web server
The second container is based on a mariadb docker image.
I will do a more comprehensice documentation once i finish my work 
 */

-- Create database called reviews

DROP DATABASE IF EXISTS reviews;
CREATE DATABASE reviews;

-- Switch to the database just created
USE reviews;

-- Here we create one table with 3 fields
-- An ID field which is set to auto-increment
-- The reviewer's name is a text field with 100 character limit
-- A star rating. A numeric field with 1-5 TINYINT
-- Review details. Text field with a limit of approx 500 words
CREATE TABLE user_review (
  id MEDIUMINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  reviewer_name CHAR(100),
  star_rating TINYINT,
  details VARCHAR(4000)
  ); 

-- Finally we create a user named review_site with password 'johnny4U@'
-- and grant user full access to the database created above
-- The % sign is a wildcard. Since we are connecting from outside the 
-- container, I used that wildcard to allow user connect from anywhere
-- It's not good practice but i just did that to allow me test my code.
-- user@localhost creates errors.
-- Will do the right thing later when I can find time.
GRANT ALL ON reviews.* to 'review_site'@'%' IDENTIFIED BY 'password';
