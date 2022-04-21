const mongoose = require('mongoose');
const {Schema} = mongoose;

mongoose.connect('mongodb://localhost:27017/reviews', {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

const db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error'));
db.once('open', function(){
  console.log('Connected successfully');
});


const reviewSchema = new Schema({
  review_id: Number,
  product_id: Number,
  rating: Number,
  summary: String,
  recommend: Boolean,
  response: String,
  body: String,
  date: {type: Date, default: Date.now},
  reviewer_name: String,
  helpfulness: Number,
  email: String,
  photos: [{
    id: Number,
    url: String}],
  report: Number,
  ratings: {
    1 : Number,
    2 : Number,
    '3' : Number,
    '4' : Number,
    '5' : Number
  },
  recommend: {
    'true': Number,
    'false': Number
  },
  characteristic: [{
    id: Number,
    name: String,
    value: Number
  }]
});

const review = mongoose.model('review', reviewSchema);
