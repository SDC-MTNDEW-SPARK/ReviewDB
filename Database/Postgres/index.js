const {Pool, Client} = require('pg');

const credentials = {
  user: process.env.PG_USER,
  host: process.env.PG_ENDPOINT,
  dbname: process.env.PG_DB,
  password: process.env.PG_PASS,
  port: process.env.PG_PORT,
};


const pool = new Pool(credentials);
pool.query('SELECT NOW()', (err, res)=>{
  if (err) {
    console.log(err);
  } else {
    console.log('pool connection is built');
  }
  pool.end();
});


const client = new Client(credentials);
client.connect();

client.query('SELECT NOW()', (err, res)=> {
  if (err) {
    console.log(err);
  } else {
    console.log('client connection is built');
  }
  client.end();
});


