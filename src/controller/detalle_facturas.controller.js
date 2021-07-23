const oracledb = require('oracledb');
const { cns } = require('../config/index');

const getDetalle_Factura = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const result = await conn.execute('SELECT DE.ID_FACTURA, PR.PRODUCTO, DE.CANTIDAD, DE.PRECIOUNIT, DE.PRECIO FROM DETALLE_FACTURA DE INNER JOIN PRODUCTO PR ON PR.ID = DE.ID_PRODUCTO', [], {
    outFormat: oracledb.OUT_FORMAT_OBJECT,
  });
  res.status(200).json(result.rows);
};

const getIdFactura = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const result = await conn.execute(
    'SELECT ID FROM (SELECT ID FROM FACTURA ORDER BY ID DESC) WHERE rownum <= 1',
    [],
    {
      outFormat: oracledb.OUT_FORMAT_OBJECT,
    }
  );
  res.status(200).json(result.rows);
};

const createDetalle_Factura = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const { id_factura, id_producto, cantidad, preciounit, precio } = req.body;
  const sql = await conn.execute(
    'CALL Insertar_DetalleFactura(:id_factura,:id_producto,:cantidad,:preciounit, :precio)',
    [id_factura, id_producto, cantidad, preciounit, precio],
    { autoCommit: true }
  );
  if (sql) {
    res.json({
      message: 'Detalle de factura insertado con éxito',
    });
  }
  if (!sql) {
    res.json({
      message: 'Error de insertado',
    });
  }
};

module.exports = {
  getDetalle_Factura,
  getIdFactura,
  createDetalle_Factura,
};
