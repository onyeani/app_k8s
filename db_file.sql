/* 
What follows is the SQL code for a simple app's db.
The app is a simple HTML form that tries to get feedback from the user.
Whatever the user imputs in the form is sent to the db.

I deployed this app using 2 docker containers.
The first container (which is the webserver) is based on webdevops/php-apache-dev 
docker image.
The second container is based on mariadb docker image.
 */

-- Drop DB if it already exists
DROP DATABASE IF EXISTS reviews;

-- Create database called reviews
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

-- Finally we create a user 'review_site' with password 'password'
-- and grant user full access to the database created above.
-- The % sign is a wildcard. Since we are connecting from outside the 
-- container, I used that wildcard to allow user connect from anywhere.
-- It's not good practice, but I just did that to allow me test my code.
-- Will do the right thing later when I can find time.
GRANT ALL ON reviews.* to 'review_site'@'%' IDENTIFIED BY 'password';
