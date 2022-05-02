# Aetlier Ratings and Reviews API

This is the backend service for Aerlier front-end project for the ratings and reviews part built in the REST API and PostgreSQL.
---
## Installation
***
$ npm install

start the postgrsql service in your terminal. You would crete the env file in the following format:

*PGUSER=YOUR_USER
*PG_DATABASE=reviews
*PGHOST=YOUR_HOST
*PGPORT=5432
*PGPASSWORD=YOUR_PASSWORD

To start the server
$npm run-srver-dev

---

# API Endpoints

-GET/REVIEWS
Retrieve a list of reviews for selected product.

| Parameter     | Type          |                                   Description                         |
| ------------- | ------------- | ----------------------------------------------------------------------|
| product_id    | Integer       | Required. Specify the product id you need to retrive                  |
| page          | Integer       | Optional. Specify the page of the result to be returned, default in 1 |
| count         | Integer       | Optional. Specify the countof the reviews to be returned, default in 5|
| sort          | String        | Optional. Select from "helpfulness", "relevant" and "date"            |

Response
Status 200 OK

{
  "product": "2",
  "page": 0,
  "count": 5,
  "results": [
    {
      "review_id": 5,
      "rating": 3,
      "summary": "I'm enjoying wearing these shades",
      "recommend": false,
      "response": null,
      "body": "Comfortable and practical.",
      "date": "2019-04-14T00:00:00.000Z",
      "reviewer_name": "shortandsweeet",
      "helpfulness": 5,
      "photos": [{
          "id": 1,
          "url": "urlplaceholder/review_5_photo_number_1.jpg"
        },
        {
          "id": 2,
          "url": "urlplaceholder/review_5_photo_number_2.jpg"
        },
        // ...
      ]
    },
    {
      "review_id": 3,
      "rating": 4,
      "summary": "I am liking these glasses",
      "recommend": false,
      "response": "Glad you're enjoying the product!",
      "body": "They are very dark. But that's good because I'm in very sunny spots",
      "date": "2019-06-23T00:00:00.000Z",
      "reviewer_name": "bigbrotherbenjamin",
      "helpfulness": 5,
      "photos": [],
    },
    // ...
  ]
}