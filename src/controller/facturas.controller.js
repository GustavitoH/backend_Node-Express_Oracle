const oracledb = require('oracledb');
const { cns } = require('../config/index');

const getFactura = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const result = await conn.execute('SELECT * FROM FACTURA ORDER BY ID', [], {
    outFormat: oracledb.OUT_FORMAT_OBJECT,
  });
  res.status(200).json(result.rows);
};

const createFactura = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const { cliente, subtotal, total } = req.body;
  const sql = await conn.execute(
    'CALL Insertar_Factura(:cliente,:subtotal,:total)',
    [cliente, subtotal, total],
    { autoCommit: true }
  );
  if (sql) {
    res.status(201).json({
      message: 'Factura insertada con éxito',
    });
  }
  if (!sql) {
    res.json({
      message: 'Error de insertado',
    });
  }
};

module.exports = {
  getFactura,
  createFactura,
};
