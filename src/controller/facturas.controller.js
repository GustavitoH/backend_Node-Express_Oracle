const oracledb = require('oracledb');
const { cns } = require("../config/index")

const getFactura = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const response = await conn.execute('SELECT * FROM FACTURA');
  res.status(200).json(response.rows);
};

const createFactura = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const { cliente, fecha, subtotal, total} = req.body;
  const response = await conn.execute(
  `execute factura_insertar(${cliente},${fecha},${subtotal},${total});`
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

const updateFactura = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const id = parseInt(req.params.id);
  const { cliente, fecha, subtotal, total} = req.body;
  const response = await conn.execute(
    `execute producto_update(${id},${cliente},${fecha},${subtotal},${total});`
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

const deleteFactura = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const id = parseInt(req.params.id);
  const response = await conn.execute(
    `delete from factura where id=${id}`
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
  getFactura,
  createFactura,
  updateFactura,
  deleteFactura,
};
