const oracledb = require('oracledb');
const { config } = require('../config/index');
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

const getEmployes = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const response = await conn.execute('SELECT * FROM PRODUCTO');
  res.status(200).json(response.rows);
};
module.exports = {
  getEmployes,
};
