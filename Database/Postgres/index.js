const {Pool, Client} = require('pg');
require('dotenv').config();

console.log( 'process.env.PG_USER',  process.env.PGUSER);
console.log('process.env.PG_DB,', process.env.PGDATABASE)
console.log('process.env.PG_ENDPOINT,', process.env.PGPORT)

const credentials = {
  user: process.env.PGUSER,
  host: process.env.PGHOST,
  dbname: process.env.PGDATABASE,
  password: process.env.PG_PASS,
  port: process.env.PGPORT,
};


const pool = new Pool(credentials);


async function poolDemo() {
  const pool = new Pool(credentials);
  const now = await pool.query('SELECT NOW()');
  await pool.end();
  return now;
}

async function clientDemo() {
  const client = new Client(credentials);
  await client.connect();
  const now = await client.query('SELECT NOW()');
  // console.log('now', now);
  await client.end();
  return now;
}

(async()=> {
  const poolResult = await poolDemo();
  console.log('Time with client' + poolResult.rows[0]['now']);
  const clientResult = await clientDemo();
  console.log('Time with client' + clientResult.rows[0]['now']);
})();

// pool.connect((err, client, release) => {
//   if (err) {
//     return console.error('Error acquiring client', err.stack);
//   }
//   client.query('SELECT NOW()', (err, result) => {
//     release();
//     if (err) {
//       return console.error('Error executing query', err.stack);
//     }
//     console.log(result.rows);
//   });
// });

// const client = new Client(credentials);
// client.connect();

// client.query('SELECT NOW()', (err, res)=> {
//   if (err) {
//     console.log(err);
//   } else {
//     console.log('client connection is built');
//   }
//   client.end();
// });

module.exports = pool;
