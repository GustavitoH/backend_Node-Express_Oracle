const oracledb = require('oracledb');
const { cns } = require('../config/index');

const getKardex = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const result = await conn.execute(
    'SELECT ID, PRODUCTO, FECHA, ACCION FROM KARDEX',
    [],
    {
      outFormat: oracledb.OUT_FORMAT_OBJECT,
    }
  );
  res.status(200).json(result.rows);
};

module.exports = {
  getKardex,
};
