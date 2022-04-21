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
  reviewer_email VARCHAR(50),
  response VARCHAR,
  helpfulness INT
);

CREATE TABLE IF NOT EXISTS reviewPhotoTable (
  photo_id INT NOT NULL PRIMARY KEY,
  review_id INT NOT NULL REFERENCES reviewTable,
  url VARCHAR
);


CREATE TABLE IF NOT EXISTS charReview (
  id INT NOT NULL PRIMARY KEY,
  characteristic_id INT NOT NULL REFERENCES characteristic,
  review_id INT NOT NULL REFERENCES reviewTable,
  value INT NOT NULL
);

CREATE TABLE IF NOT EXISTS charTable (
  id INT NOT NULL PRIMARY KEY,
  product_id INT NOT NULL,
  name VARCHAR NOT NULL
);
