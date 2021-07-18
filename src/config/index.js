require('dotenv').config();
const oracledb = require('oracledb');

const config = {
  dev: process.env.NODE_ENV !== 'production',
  localport: process.env.LOCALPORT || 3000,
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  password: process.env.DB_PASSWORD,
  port: process.env.PORT,
  sid: process.env.SID,
};

try {
  oracledb.initOracleClient({ libDir: 'C:\\oracle\\instantclient_19_11' });
} catch (err) {
  console.error(err);
  process.exit(1);
}
const cns = {
  user: config.user,
  password: config.password,
  connectString:
    '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=' +
    config.host +
    ')(Port=' +
    config.port +
    '))(CONNECT_DATA=(SID=' +
    config.sid +
    ')))',
};

module.exports = { config, cns };
