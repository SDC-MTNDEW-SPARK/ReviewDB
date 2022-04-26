-- SELECT *
-- FROM pg_stat_activity
-- WHERE datname = 'reviews';

-- SELECT
-- 	pg_terminate_backend (pg_stat_activity.pid)
-- FROM
-- 	pg_stat_activity
-- WHERE
-- 	pg_stat_activity.datname = 'reviews';

-- DROP DATABASE IF EXISTS reviews;

-- CREATE DATABASE reviews;

CREATE TABLE IF NOT EXISTS reviewTable (
  review_id SERIAL PRIMARY KEY,
  product_id INT NOT NULL,
  rating INT,
  date VARCHAR,
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
  photo_id SERIAL PRIMARY KEY,
  review_id INT NOT NULL REFERENCES reviewTable,
  url VARCHAR
);

CREATE TABLE IF NOT EXISTS charReview (
  id SERIAL PRIMARY KEY,
  characteristic_id INT NOT NULL,
  review_id INT NOT NULL REFERENCES reviewTable,
  value INT NOT NULL
);

CREATE TABLE IF NOT EXISTS charTable (
  id SERIAL PRIMARY KEY,
  product_id INT NOT NULL,
  name VARCHAR NOT NULL
);

CREATE TABLE IF NOT EXISTS characteristic(
  id SERIAL PRIMARY KEY,
  characteristic_id INT NOT NULL,
  product_id INT NOT NULL,
  review_id INT,
  name VARCHAR NOT NULL,
  value INT
);

INSERT INTO characteristic (product_id, characteristic_id, review_id, name, value)
SELECT chartable.product_id, filled_chars.characteristic_id, filled_chars.review_id, chartable.name,filled_chars.value
FROM chartable INNER JOIN
( SELECT * FROM charreview
  RIGHT JOIN (SELECT * FROM generate_series(1,3347679) characteristic_id) series
  USING (characteristic_id)
  ORDER BY characteristic_id ASC
) filled_chars
ON chartable.id = filled_chars.characteristic_id
ORDER BY filled_chars.characteristic_id;


-- INSERT INTO characteristic(characteristic_id, product_id, review_id, name, value) SELECT charreview.characteristic_id, chartable.product_id,charreview.review_id, chartable.name, charreview.value FROM charreview INNER JOIN chartable ON chartable.id = charreview.characteristic_id;

-- CREATE INDEX product_characteristic ON characteristic(product_id);

-- -- ALTER TABLE characteristic ADD FOREIGN KEY (review_id) REFERENCES reviewTable(review_id);


-- -- SELECT charreview.characteristic_id, charreview.review_id, charreview.value, chartable.product_id, chartable.name FROM charreview LEFT JOIN chartable ON chartable.id = charreview.characteristic_id WHERE chartable.product_id is NULL limit 100;

-- SELECT setval('reviewtable_review_id_seq', (SELECT MAX(review_id) FROM reviewTable)+1);
-- SELECT setval('reviewphototable_photo_id_seq', (SELECT MAX(photo_id) FROM reviewPhotoTable)+1);

-- INSERT INTO characteristic (review_id, product_id, characteristic_id, value, name)
-- SELECT DISTINCT '5774984', '65613', '219308',  3, characteristic.name FROM characteristic WHERE characteristic.characteristic_id = '219308' AND characteristic.product_id = '65613';
-- INSERT INTO characteristic (review_id, product_id, characteristic_id, value, name)
-- SELECT DISTINCT '5775026', '852921', '2855523',  2, characteristic.name FROM characteristic WHERE characteristic.characteristic_id = '2855523' AND characteristic.product_id = '852921';


-- INSERT INTO characteristic (review_id, product_id, characteristic_id, value, name)
-- SELECT DISTINCT * FROM ((SELECT 5774984, 65613, 219308,  3, characteristic.name FROM characteristic WHERE characteristic.characteristic_id = '219308' AND characteristic.product_id = '65613') union all (SELECT 5775026, 852921, 2855523,  2, characteristic.name FROM characteristic WHERE characteristic.characteristic_id = '2855523' AND characteristic.product_id = '852921')) AS Dis;