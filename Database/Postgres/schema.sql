CREATE TABLE IF NOT EXISTS reviewTable (
  review_id INT PRIMARY KEY,
  product_id INT NOT NULL,
  rating INT,
  date DATE,
  summary VARCHAR,
  body VARCHAR,
  recommend BOOLEAN,
  reported BOOLEAN,
  reviewer_name VARCHAR(30),
  characteristic_id INT,
  reviewer_email VARCHAR(30),
  response VARCHAR,
  helpfulness INT
);

CREATE TABLE IF NOT EXISTS reviewPhotoTable (
  photo_id INT NOT NULL ,
  url VARCHAR
);

CREATE TABLE IF NOT EXISTS characteristic (
  characteristic_id INT NOT NULL,
  product_id INT NOT NULL,
  name VARCHAR,
  value INT
);
