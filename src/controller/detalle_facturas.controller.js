const oracledb = require('oracledb');
const { cns } = require("../config/index")

const getDetalle_Factura = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const response = await conn.execute('SELECT * FROM DETALLE_FACTURA');
  res.status(200).json(response.rows);
};

const createDetalle_Factura = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const { id_factura ,id_producto, cantidad, preciounit, precio} = req.body;
  const response = await conn.execute(
  `execute detalle_factura_insertar(${id_factura}, ${id_producto},${cantidad},${preciounit},${precio});`
  );
  if (response) {
    res.json({
      message: 'Guardado con éxito',
    });
  }
  if (!response) {
    res.json({
      message: 'Guardado no realizado',
    });
  }
};

const updateDetalle_Factura = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const { id_factura ,id_producto, cantidad, preciounit, precio} = req.body;
  const response = await conn.execute(
    `execute detalle_factura_update(${id_factura},${id_producto},${cantidad},${preciounit},${precio});`
  );
  if (response) {
    res.json({
      message: 'Actualización exitosa',
    });
  }
  if (!response) {
    res.json({
      message: 'Actualización no realizada',
    });
  }
};

const deleteDetalle_Factura = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const { id_factura } = req.body;
  const response = await conn.execute(
    `delete from detalle_factura where id_factura=${id_factura}`
  );
  if (response) {
    res.json({
      message: 'Eliminación exitosa',
      estado: true,
    });
  }
  if (!response) {
    res.json({
      message: 'Eliminación no realizada',
      estado: false,
    });
  }
};


module.exports = {
  getDetalle_Factura,
  createDetalle_Factura,
  updateDetalle_Factura,
  deleteDetalle_Factura,
};
