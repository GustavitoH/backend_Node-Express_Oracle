require('dotenv').config();

const config = {
  dev: process.env.NODE_ENV !== 'production',
  localport: process.env.LOCALPORT || 3000,
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  password: process.env.DB_PASSWORD,
  port: process.env.PORT,
  sid: process.env.SID,
};

module.exports = { config };
