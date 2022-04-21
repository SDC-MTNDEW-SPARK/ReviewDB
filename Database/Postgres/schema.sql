DROP DATABASE reviews IF EXISTS;
CREATE DATABASE reviews;
USE reviews;

CREATE TABLE reviewTable (
  review_id INT NOT NULL AUTO_INCREMENT,
  characteristic_id INT,
  product_id INT,
  photo_id INT,
  rating INT,
  summary TEXT(16383),
  recommend BOOLEAN,
  response VARCHAR,
  body VARCHAR,
  date DATE,
  reviewer_name VARCHAR(30),
  helpfulness INT,
  reviewer_name VARCHAR(30),
  reported BOOLEAN
)

CREATE TABLE reviewPhotoTable (
  photo_id INT,
  review_id INT,
  url VARCHAR,
)

CREATE TABLE characteristic (
  characteristic_id INT,
  product_id INT,
  review_id INT,
  name VARCHAR,
  value INT
)
