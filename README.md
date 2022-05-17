# Atelier Ratings and Reviews API

This is the backend service to support Atelier front-end commercial website for the ratings and reviews part built with RESTful API and PostgreSQL.

---
## Installation

```
$ npm install
```

Start the postgrsql service in your terminal. You would crete the env file in the following format:

```
PGUSER=YOUR_USER
PG_DATABASE=reviews
PGHOST=YOUR_HOST
PGPORT=5432
PGPASSWORD=YOUR_PASSWORD
```
To start the server, run

```
$npm run-srver-dev
```
---

# API Endpoints

## -GET/REVIEWS <br />

Retrieve a list of reviews for a selected product.

| Parameter     | Type          |                                   Description                         |
| ------------- | ------------- | ----------------------------------------------------------------------|
| product_id    | Integer       | Required. Specify the product id you need to retrive                  |
| page          | Integer       | Optional. Specify the page of the result to be returned, default in 1 |
| count         | Integer       | Optional. Specify the countof the reviews to be returned, default in 5|
| sort          | String        | Optional. Select from "helpfulness", "relevant" and "date"            |

### Response <br />
Status: 200 OK
```
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
```

## -GET/REVIEWS/META <br />

Retrieve review metadata for a given product

| Parameter     | Type          |                                   Description                         |
| ------------- | ------------- | ----------------------------------------------------------------------|
| product_id    | Integer       | Required. Specify the product id you need to retrive                  |

### Response <br />
Status: 200 OK
```
{
  "product_id": "2",
  "ratings": {
    2: 1,
    3: 1,
    4: 2,
    // ...
  },
  "recommended": {
    0: 5
    // ...
  },
  "characteristics": {
    "Size": {
      "id": 14,
      "value": "4.0000"
    },
    "Width": {
      "id": 15,
      "value": "3.5000"
    },
    "Comfort": {
      "id": 16,
      "value": "4.0000"
    },
    // ...
}
```


## -POST/REVIEWS <br />

Adds a review for the given product

| Parameter      | Type          |                                   Description                                                                  |
| -------------  | ------------- | ---------------------------------------------------------------------------------------------------------------
| product_id     | Integer       | Required. Specify the product id you need to post review for                                                   |
| rating         | Integer       | Required. Integer (1-5) indicating the review rating                                                           |
| summary        | Integer       | Optional. Summary text of the review                                                                           |
| body           | String        | Optional. Continue tesxt of the review                                                                         |
| recommend      | String        | Optional. 	Value indicating if the reviewer recommends the product                                             |
| name           | Integer       | Required. 	Username for question asker                                                                         |
| email          | Integer       | Required. Email address for question asker                                                                     |
| photos         | [text]        | Optional. Array of text urls that link to images to be shown                                                   |
| characteristics| Object        | Object of keys representing characteristic_id and values representing the review value for that characteristic.|                            


### Response <br />
Status: 201 Created
```
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
```
## -PUT/REVIEWS/REVIEW_ID/HELPFUL <br />
Updates a review to show it was found helpful


| Parameter     | Type          |                                   Description                         |
| ------------- | ------------- | ----------------------------------------------------------------------|
| review_id     |Integer        | Required. Specify the review id of the review to update               |

### Response <br />
Status: 204 No Content

## -PUT/REVIEWS/REVIEW_ID/REPORT <br />
Updates a review to show it was reported. 


| Parameter     | Type          |                                   Description                         |
| ------------- | ------------- | ----------------------------------------------------------------------|
| review_id     |Integer        | Required. Specify the review id of the review to update               |

### Response <br />
Status: 204 No Content
