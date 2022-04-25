const express = require("express");
const db = require("./controller.js");
const bodyParser = require("body-parser");
const app = express();
const port = 3000;
require("dotenv").config();

console.log("1process.env.PG_USER", process.env.PGUSER);
console.log("2process.env.PG_DB,", process.env.PGDATABASE);
console.log("3process.env.PG_ENDPOINT,", process.env.PGPORT);

app.use(bodyParser.json());

// app.get('/', (request, response)=>{
//   console.log(response);
// });

app.get("/reviews/meta", (req, res) => {
  let id = req.query.product_id;
  let queryStr = `SELECT p.product_id, r.ratings, rec.recommend, char.characteristic FROM (SELECT ROW_NUMBER()OVER(),product_id FROM (SELECT DISTINCT product_id FROM reviewTable WHERE product_id=${id}) product) p INNER JOIN (SELECT ROW_NUMBER() OVER () row_number, json_object_agg(c.rating, c.count) as ratings FROM (SELECT rating, COUNT (rating) FROM reviewTable WHERE product_id=${id} GROUP BY rating) c) r ON r.row_number = p.row_number INNER JOIN (SELECT ROW_NUMBER() OVER() row_number, json_object_agg(d.recommend, d.count) as recommend FROM (SELECT recommend, COUNT (recommend) FROM reviewTable WHERE product_id=${id} GROUP BY recommend) d) rec ON rec.row_number = r.row_number INNER JOIN (SELECT ROW_NUMBER() OVER() row_number, json_object_agg(a.name, a.value) AS characteristic FROM (SELECT c.name, c.value FROM (SELECT b.name, json_build_object('id', b.characteristic_id, 'value', b.value) as value FROM (SELECT table1.name, table2.characteristic_id, table2.value FROM (SELECT DISTINCT c.name, c.characteristic_id FROM (SELECT * FROM characteristic WHERE product_id=${id}) c) AS table1 INNER JOIN (SELECT b.characteristic_id, AVG(b.value) AS value FROM (SELECT * FROM characteristic WHERE product_id=${id}) b GROUP BY b.characteristic_id) AS table2 ON table1.characteristic_id=table2.characteristic_id) b) c) a) char ON char.row_number = rec.row_number;`;
  db.getReviews(queryStr)
    .then((response) => res.send(response.rows[0]))
    .catch((err) => console.log("err executing query", err.stack));
});

app.get("/reviews", (req, res) => {
  let id = req.query.product_id;
  let count = req.query.count || 5;
  let page = req.query.page || 1;
  let sortBy = (key) => {
    if (key === "helpful") {
      return "helpfulness";
    } else if (key === "newest") {
      return "date";
    } else {
      return "review_id";
    }
  };
  let queryStr = `SELECT * FROM (SELECT r.review_id, r.product_id, r.rating, r.date, r.summary, r.body, r.recommend, r.reviewer_name, r.reviewer_email, r.response, r.helpfulness, coalesce(p.photos, '[]'::json) as photos FROM (SELECT * FROM reviewTable WHERE product_id='${id}') r LEFT JOIN (SELECT review_id, json_agg(json_build_object('id', photo_id, 'url', url)) as photos FROM reviewPhotoTable GROUP BY review_id) p ON r.review_id = p.review_id) AS foo ORDER BY ${sortBy(
    req.query.sort
  )} DESC LIMIT ${page * count};`;

  db.getReviews(queryStr)
    .then((response) =>
      res.send({
        products: id,
        page: page,
        count: count,
        results: response.rows,
      })
    )
    .catch((err) => console.log("err executing query", err.stack));
});

app.post("/reviews", (req, res) => {
  let obj = req.body;
  console.log("--------------------------------------------");
  console.log("obj", obj);
  let {
    product_id,
    rating,
    summary,
    body,
    recommend,
    name,
    email,
    photos,
    characteristics,
  } = obj;
  if (photos.length === 0) {
    photos = ["null"];
  }

  let query1 = `INSERT INTO reviewTable (product_id, rating, date, summary, body, recommend, reviewer_name, reviewer_email) VALUES ('${product_id}', '${rating}', CURRENT_TIMESTAMP, '${summary}', '${body}', ${recommend}, '${name}', '${email}') RETURNING review_id;`;
  console.log(query1);
  db.postReview('begin')
    .then(res=>{
      return db.postReview(query1);
    })
    .then((reviewId)=>{
      console.log('reviewId-------', reviewId);
      review_id = reviewId["rows"][0].review_id;
      let toInsert = photos.map((url) => {
        return `(${review_id}, '${url}')`;
      });

      // console.log("toInsert", toInsert);

      let query2 = `INSERT INTO reviewPhotoTable (review_id, url) VALUES ${toInsert.join(
        ","
      )} RETURNING review_id;`;
      console.log('query2--------------------------', query2);
      return db.postReview(query2);
    })
    .then(reviewId => {
      console.log('reviewId-------query3', reviewId);
      review_id = reviewId["rows"][0].review_id;
      let query3 = 'INSERT INTO characteristic (review_id, product_id, characteristic_id, value, name) SELECT * FROM (';
      for (let key in characteristics) {
        let query = `(SELECT ${review_id}, ${product_id}, ${key}, ${characteristics[key]}, characteristic.name FROM characteristic WHERE characteristic.characteristic_id = ${key} LIMIT 1) UNION ALL `;
        query3 = query3.concat(query);
      }
      query3 = query3.slice(0, -11) + ') AS a;';
      console.log("=========================3=======", query3);
      return db.postReview(query3);
    })
    .then((res) => {
      console.log('333333333'.res);
      return db.postReview("commit");
    })
    .then((result) => {
      res.send("transaction completed");
    })
    .catch(err=>console.log(err));
});

app.put("/reviews/:review_id/helpful", (req, res) => {
  const id = req.params.review_id;
  let queryStr = `UPDATE reviewTable SET helpfulness = helpfulness + 1 WHERE review_id='${id}';`;
  db.getReviews(queryStr)
    .then((response) => res.json(response))
    .catch((err) => console.log("err executing query", err.stack));
});

app.put("/reviews/:review_id/report", (req, res) => {
  const id = req.params.review_id;
  let queryStr = `UPDATE reviewTable SET reported = NOT reported WHERE review_id = ${id};`;
  db.getReviews(queryStr)
    .then((response) => res.json(response))
    .catch((err) => console.log("err executing query", err.stack));
});

app.listen(port, () => {
  console.log(`App is running on port ${port}`);
});
