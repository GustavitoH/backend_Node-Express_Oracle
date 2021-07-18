const oracledb = require('oracledb');
const { cns } = require('../config/index');

const getProductos = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const response = await conn.execute('SELECT * FROM PRODUCTO');
  res.status(200).json(response.rows);
};

const createProducto = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const { producto, precio, descripcion, cantidad } = req.body;
  const response = await conn.execute(
    `INSERT INTO (producto, precio, descripcion, cantidad) VALUES (${producto},${precio},${descripcion},${cantidad});`
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

const updateProducto = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const id = parseInt(req.params.id);
  const { producto, precio, descripcion, cantidad } = req.body;
  const response = await conn.execute(
    `execute producto_update(${id},${producto},${precio},${descripcion},${cantidad});`
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

const deleteProducto = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const id = parseInt(req.params.id);
  const response = await conn.execute(`delete from producto where id=${id}`);
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
  getProductos,
  createProducto,
  updateProducto,
  deleteProducto,
};
