const pool = require('../Database/Postgres/index.js');

module.exports = {
  getReviews : (text, id) => pool.query(text, id),
  postReview : (text, id) => pool.query(text, id),

};