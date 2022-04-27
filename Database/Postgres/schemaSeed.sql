COPY reviewTable
FROM '/Users/Dora/Downloads/reviews.csv'
DELIMITER ',' CSV HEADER;

COPY charReview
FROM '/Users/Dora/Downloads/characteristic_reviews.csv'
DELIMITER ',' CSV HEADER;

COPY chartable
FROM '/Users/Dora/Downloads/characteristics.csv'
DELIMITER ',' CSV HEADER;

COPY reviewPhotoTable
FROM '/Users/Dora/Downloads/reviews_photos.csv'
DELIMITER ',' CSV HEADER;

ALTER TABLE reviewTable ALTER COLUMN date SET DATA TYPE BIGINT USING date::bigint;
UPDATE reviewTable SET date=date/1000;
ALTER TABLE reviewTable ALTER column date TYPE timestamp without time zone using to_timestamp(date) AT TIME ZONE 'UTC';




-- SELECT ROW_NUMBER() OVER() row_number, json_object_agg(d.recommend, d.count) as recommend FROM (SELECT recommend, COUNT (recommend) FROM reviewTable WHERE product_id='65633' GROUP BY recommend) d;

SELECT ROW_NUMBER() OVER () row_number, json_object_agg(c.rating, c.count) as ratings FROM (SELECT rating, COUNT (rating) FROM reviewTable WHERE product_id='65633' GROUP BY rating) c;

-- SELECT ROW_NUMBER() OVER() row_num, json_object_agg(a.name, a.value) AS characteristic FROM (SELECT c.name, c.value FROM (SELECT b.name, json_build_object('id', b.characteristic_id, 'value', b.value) as value FROM (SELECT table1.name, table2.characteristic_id, table2.value FROM (SELECT DISTINCT c.name, c.characteristic_id FROM (SELECT * FROM characterTable WHERE product_id='65633') c) AS table1 INNER JOIN (SELECT b.characteristic_id, AVG(b.value) AS value FROM (SELECT * FROM characterTable WHERE product_id='65633') b GROUP BY b.characteristic_id) AS table2 ON table1.characteristic_id=table2.characteristic_id) b) c) a;

-- SELECT * FROM (SELECT r.review_id, r.product_id, r.rating, r.date, r.summary, r.body, r.recommend, r.reviewer_name, r.reviewer_email, r.response, r.helpfulness, coalesce(p.photos, '{}'::json) as photos FROM (SELECT * FROM reviewTable WHERE product_id='${id}') r LEFT JOIN (SELECT review_id, json_agg(json_build_object('id', photo_id, 'url', url)) as photos FROM reviewPhotoTable GROUP BY review_id) p ON r.review_id = p.review_id) AS foo ORDER BY ${sortBy(req.query.sort)} DESC LIMIT ${page * count};


-- SELECT p.product_id, r.ratings, rec.recommend, char.characteristic FROM (SELECT ROW_NUMBER()OVER(),product_id FROM (SELECT product_id FROM reviewTable WHERE product_id='2' LIMIT 1) product) p INNER JOIN (SELECT ROW_NUMBER() OVER () row_number, json_object_agg(c.rating, c.count) as ratings FROM (SELECT rating, COUNT (rating) FROM reviewTable WHERE product_id='2' GROUP BY rating) c) r ON r.row_number = p.row_number INNER JOIN (SELECT ROW_NUMBER() OVER() row_number, json_object_agg(d.recommend, d.count) as recommend FROM (SELECT recommend, COUNT (recommend) FROM reviewTable WHERE product_id='2' GROUP BY recommend) d) rec ON rec.row_number = r.row_number INNER JOIN (SELECT ROW_NUMBER() OVER() row_number, json_object_agg(a.name, a.value) AS characteristic FROM (SELECT c.name, c.value FROM (SELECT b.name, json_build_object('id', b.characteristic_id, 'value', b.value) as value FROM (SELECT table1.name, table2.characteristic_id, table2.value FROM (SELECT DISTINCT c.name, c.characteristic_id FROM (SELECT * FROM characteristic WHERE product_id='2') c) AS table1 INNER JOIN (SELECT b.characteristic_id, AVG(b.value) AS value FROM (SELECT * FROM characteristic WHERE product_id='2') b GROUP BY b.characteristic_id) AS table2 ON table1.characteristic_id=table2.characteristic_id) b) c) a) char ON char.row_number = rec.row_number;
-- 1296.599 ms
---------------------first revision-------------------------------------------------------------------
-- SELECT p.product_id, r.ratings, rec.recommend, char.characteristic FROM (SELECT ROW_NUMBER()OVER(),product_id FROM (SELECT product_id FROM reviewTable WHERE product_id='2' LIMIT 1) product) p INNER JOIN (SELECT ROW_NUMBER() OVER () row_number, json_object_agg(c.rating, c.count) as ratings FROM (SELECT rating, COUNT (rating) FROM reviewTable WHERE product_id='2' GROUP BY rating) c) r ON r.row_number = p.row_number INNER JOIN (SELECT ROW_NUMBER() OVER() row_number, json_object_agg(d.recommend, d.count) as recommend FROM (SELECT recommend, COUNT (recommend) FROM reviewTable WHERE product_id='2' GROUP BY recommend) d) rec ON rec.row_number = r.row_number INNER JOIN (SELECT ROW_NUMBER() OVER() row_number, json_object_agg(a.name, a.value) AS characteristic FROM (SELECT c.name, c.value FROM (SELECT b.name, json_build_object('id', b.characteristic_id, 'value', b.value) as value FROM (SELECT table1.name, table2.characteristic_id, table2.value FROM (SELECT DISTINCT c.name, c.characteristic_id FROM (SELECT name, characteristic_id FROM characteristic WHERE product_id='2') c) AS table1 INNER JOIN (SELECT b.characteristic_id, AVG(b.value) AS value FROM (SELECT characteristic_id, value FROM characteristic WHERE product_id='2') b GROUP BY b.characteristic_id) AS table2 ON table1.characteristic_id=table2.characteristic_id) b) c) a) char ON char.row_number = rec.row_number;


-------------------Second Revision ----------q--------------------------------------------------------------
-- SELECT p.product_id, r.ratings, rec.recommend, char.characteristic FROM (SELECT ROW_NUMBER()OVER(),product_id FROM (SELECT product_id FROM reviewTable WHERE product_id='2' LIMIT 1) product) p INNER JOIN (SELECT ROW_NUMBER() OVER () row_number, json_object_agg(c.rating, c.count) as ratings FROM (SELECT rating, COUNT (rating) FROM reviewTable WHERE product_id='2' GROUP BY rating) c) r ON r.row_number = p.row_number INNER JOIN (SELECT ROW_NUMBER() OVER() row_number, json_object_agg(d.recommend, d.count) as recommend FROM (SELECT recommend, COUNT (recommend) FROM reviewTable WHERE product_id='2' GROUP BY recommend) d) rec ON rec.row_number = r.row_number INNER JOIN (SELECT ROW_NUMBER() OVER() row_number, json_object_agg(a.name, a.value) AS characteristic FROM (SELECT c.name, c.value FROM (SELECT b.name, json_build_object('id', b.characteristic_id, 'value', b.value) as value FROM (SELECT table1.name, table2.characteristic_id, table2.value FROM (SELECT name, characteristic_id FROM characteristic WHERE product_id='2' LIMIT 1) AS table1 INNER JOIN (SELECT characteristic_id, AVG(value) AS VALUE FROM characteristic WHERE product_id='2' GROUP BY characteristic_id) AS table2 ON table1.characteristic_id=table2.characteristic_id) b) c) a) char ON char.row_number = rec.row_number;

------------------Third Revision  SEE BELOW FORMATTED VERSION-----------------------------------------------
SELECT
  p.product_id,
  r.ratings,
  rec.recommended,
  char.characteristics
FROM
  (
        SELECT
          product_id
        FROM
          reviewTable
        WHERE
          product_id = '2' LIMIT 1
  )
  p,
  (
    SELECT
      json_object_agg(c.rating, c.count) as ratings
    FROM
      (
        SELECT
          rating,
          COUNT (rating)
        FROM
          reviewTable
        WHERE
          product_id = '2'
        GROUP BY
          rating
      )
      c
  )
  r,
  (
    SELECT
      json_object_agg(d.recommend, d.count) as recommended
    FROM
      (
        SELECT
          recommend,
          COUNT (recommend)
        FROM
          reviewTable
        WHERE
          product_id = '2'
        GROUP BY
          recommend
      )
      d
  )
  rec,
  (
    SELECT
      json_object_agg(a.name, a.value) AS characteristics
    FROM
      (
        SELECT
          c.name,
          c.value
        FROM
          (
            SELECT
              b.name,
              json_build_object('id', b.characteristic_id, 'value', b.value) as value
            FROM
              (
                SELECT
                  table1.name,
                  table2.characteristic_id,
                  table2.value
                FROM
                  (
                    SELECT
                      name,
                      characteristic_id
                    FROM
                      characteristic
                    WHERE
                      product_id = '2' LIMIT 1
                  )
                  AS table1
                  INNER JOIN
                    (
                      SELECT
                        characteristic_id,
                        AVG(value) AS VALUE
                      FROM
                        characteristic
                      WHERE
                        product_id = '2'
                      GROUP BY
                        characteristic_id
                    )
                    AS table2
                    ON table1.characteristic_id = table2.characteristic_id
              )
              b
          )
          c
      )
      a
  )
  char;




-- SELECT r.review_id, r.product_id, r.rating, r.date, r.summary, r.body, r.recommend, r.reviewer_name, r.reviewer_email, r.response, r.helpfulness, coalesce(p.photos, '[]'::json) as photos FROM (SELECT * FROM reviewTable WHERE product_id='2') r LEFT JOIN (SELECT review_id, json_agg(json_build_object('id', photo_id, 'url', url)) as photos FROM reviewPhotoTable GROUP BY review_id) p ON r.review_id = p.review_id ORDER BY helpfulness DESC LIMIT 10;

-- ------------------------------------OPTIMIZATION---------------------------------------------------------------------------
with alllll as (
      SELECT
      r.product_id,
      r.rating,
      r.date,
      r.summary,
      r.body,
      r.recommend,
      r.reviewer_name,
      r.reviewer_email,
      r.response,
      r.helpfulness, r.review_id, rt.photo_id, rt.url
    FROM
      reviewTable r
    Left JOIN
      reviewPhotoTable rt
    ON
      r.review_id = rt.review_id
    WHERE
      r.product_id = '2'
)
SELECT
 review_id,
 rating,
 summary,
 recommend,
 response,
 body,
 date,
 reviewer_name,
 helpfulness,
coalesce(json_agg(json_build_object('id', photo_id, 'url', url))  FILTER (WHERE photo_id IS NOT NULL),  '[]'::json) as photos
FROM alllll
GROUP BY
 review_id,
 rating,
 summary,
 recommend,
 response,
 body,
 date,
 reviewer_name,
 helpfulness
 ORDER BY helpfulness DESC LIMIT 20;


-- INSERT INTO reviewTable (product_id, rating, date, summary, body, recommend, reviewer_name, reviewer_email) VALUES ('65632', '5', CURRENT_TIMESTAMP, 'last one', 'testing message', false, 'dfr', 'dog@gmail.com') RETURNING review_id;
-- -- Time: 1.466 ms

-- INSERT INTO reviewPhotoTable (review_id, url) VALUES (5775044, '255f45313') RETURNING review_id;
-- -- Time: 1.251 ms
-- INSERT INTO characteristic (review_id, product_id, characteristic_id, value, name) SELECT DISTINCT * FROM ((SELECT 5775044, 65632, 219370, 1, characteristic.name FROM characteristic WHERE characteristic.characteristic_id = 219370) UNION ALL (SELECT 5775044, 65632, 219371, 0, characteristic.name  FROM characteristic WHERE characteristic.characteristic_id = 219371)) AS a;
-- -- Time: 4778.921 ms (00:04.779)


-- INSERT INTO characteristic (review_id, product_id, characteristic_id, value, name) SELECT * FROM ((SELECT 5775044, 65632, 219370, 1, characteristic.name FROM characteristic WHERE characteristic.characteristic_id = 219370 LIMIT 1) UNION ALL (SELECT 5775044, 65632, 219371, 0, characteristic.name  FROM characteristic WHERE characteristic.characteristic_id = 219371 LIMIT 1)) AS a;
-- Time: 1.320 ms

-- CREATE INDEX review_photo ON reviewphototable(review_id)
-- -- CREATE INDEX product_charatcteristic ON characteristic(product_id);
-- CREATE INDEX recommend_review ON reviewTable(recommend);
-- CREATE INDEX rating_review ON reviewTable(rating);
-- UPDATE reviewTable
--    SET helpfulness = helpfulness + 1
-- WHERE review_id = `{id}`;



SELECT
  p.product_id,
  r.ratings,
  rec.recommend,
  char.characteristic
FROM
  (
        SELECT
          product_id
        FROM
          reviewTable
        WHERE
          product_id = '2' LIMIT 1
  )
  p,
  (
    SELECT
      json_object_agg(c.rating, c.count) as ratings
    FROM
      (
        SELECT
          rating,
          COUNT (rating)
        FROM
          reviewTable
        WHERE
          product_id = '2'
        GROUP BY
          rating
      )
      c
  )
  r,
  (
    SELECT
      json_object_agg(d.recommend, d.count) as recommend
    FROM
      (
        SELECT
          recommend,
          COUNT (recommend)
        FROM
          reviewTable
        WHERE
          product_id = '2'
        GROUP BY
          recommend
      )
      d
  )
  rec,
  (
    SELECT
      json_object_agg(a.name, a.value) AS characteristic
    FROM
      (
        SELECT
          c.name,
          c.value
        FROM
          (
            SELECT
              b.name,
              json_build_object('id', b.characteristic_id, 'value', b.value) as value
            FROM
              (
                SELECT
                  table1.name,
                  table2.characteristic_id,
                  table2.value
                FROM
                  (
                    SELECT
                      name,
                      characteristic_id
                    FROM
                      characteristic
                    WHERE
                      product_id = '2' LIMIT 1
                  )
                  AS table1
                  INNER JOIN
                    (
                      SELECT
                        characteristic_id,
                        AVG(value) AS VALUE
                      FROM
                        characteristic
                      WHERE
                        product_id = '2'
                      GROUP BY
                        characteristic_id
                    )
                    AS table2
                    ON table1.characteristic_id = table2.characteristic_id
              )
              b
          )
          c
      )
      a
  )
  char;




