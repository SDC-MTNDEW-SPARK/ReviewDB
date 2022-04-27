import http from 'k6/http';
import {sleep} from 'k6';

// // Tested on different scenarios. #60 requests
// export let options = {
//   scenarios: {
//     constant_request_rate: {
//       executor: "constant-arrival-rate",
//       rate: 1,
//       timeUnit: '1s',
//       duration: '60s',
//       preAllocatedVUs: 100,
//       maxVUs: 100,
//     }
//   }
// };


// // Tested on different scenarios. #600 requests
// export let options = {
//   scenarios: {
//     constant_request_rate: {
//       executor: "constant-arrival-rate",
//       rate: 10,
//       timeUnit: '1s',
//       duration: '60s',
//       preAllocatedVUs: 100,
//       maxVUs: 100,
//     }
//   }
// };

// Tested on different scenarios. #6000 requests
// export let options = {
//   scenarios: {
//     constant_request_rate: {
//       executor: "constant-arrival-rate",
//       rate: 100,
//       timeUnit: '1s',
//       duration: '15s',
//       preAllocatedVUs: 100,
//       maxVUs: 100,
//     }
//   }
// };

// Tested on different scenarios. #60000 requests
export let options = {
  scenarios: {
    constant_request_rate: {
      executor: "constant-arrival-rate",
      rate: 100,
      timeUnit: '1s',
      duration: '60s',
      preAllocatedVUs: 100,
      maxVUs: 100,
    }
  }
};

// Stress Testing
// export const options = {
//   stages: [
//     { duration: '2m', target: 100 }, // below normal load
//     { duration: '5m', target: 150 }, // normal load
//     { duration: '2m', target: 200 }, // around the breaking point
//     { duration: '5m', target: 250 }, // beyond the breaking point
//     { duration: '10m', target: 0 }, // scale down Recovery stage.
//   ],
// };

// export default ()=>{
//   http.get(`http://localhost:3000/reviews/meta/?product_id=${Math.floor(Math.random() * 200)}`)
// };

// export default ()=>{
//   http.get('http://localhost:3000/reviews/meta/?product_id=115')
// };

export default ()=>{
  http.get(`http://localhost:3000/reviews/?product_id=${Math.floor(Math.random() * 999999)}&page=1&count=5`)
}

// export default function () {
//   const BASE_URL = 'https://test-api.k6.io'; // make sure this is not production

//   const responses = http.get(
//     `http://localhost:3000/reviews/meta/?product_id=${Math.floor(Math.random() * 999999)} & page=1&count=5`
//   );

//   sleep(1);
// }