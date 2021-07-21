const oracledb = require('oracledb');
const { cns } = require('../config/index');

const getProductos = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const result = await conn.execute('SELECT * FROM PRODUCTO', [], {
    outFormat: oracledb.OUT_FORMAT_OBJECT,
  });
  res.status(200).json(result.rows);
};

const createProducto = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const { producto, precio, descripcion, cantidad } = req.body;
  const sql = await conn.execute(
    'CALL Insertar_Producto(:producto,:precio,:descripcion,:cantidad)',
    [producto, precio, descripcion, cantidad],
    { autoCommit: true }
  );
  if (sql) {
    res.json({
      message: 'Producto insertado con éxito',
    });
  }
  if (!sql) {
    res.json({
      message: 'Error de insertado',
    });
  }
};

const updateProducto = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const id = parseInt(req.params.id);
  const { producto, precio, descripcion, cantidad } = req.body;
  const sql = await conn.execute(
    'CALL ACTUALIZAR_PRODUCTO(:id,:producto,:precio,:descripcion,:cantidad)',
    [id, producto, precio, descripcion, cantidad],
    { autoCommit: true }
  );
  if (sql) {
    res.json({
      message: 'Producto modificado con éxito',
    });
  }
  if (!sql) {
    res.json({
      message: 'Error de modificación',
    });
  }
};

const deleteProducto = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const id = parseInt(req.params.id);
  const sql = await conn.execute('DELETE PRODUCTO WHERE ID = :id', [id], {
    autoCommit: true,
  });
  if (sql) {
    res.json({
      message: 'Producto eliminado con éxito',
    });
  }
  if (!sql) {
    res.json({
      message: 'Error al eliminar',
    });
  }
};

const getProductoMenosVendido = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const result = await conn.execute(
    'SELECT PRODUCTO_MENOS_VENDIDO FROM DUAL',
    [],
    {
      outFormat: oracledb.OUT_FORMAT_OBJECT,
    }
  );
  res.status(200).json(result.rows);
};
const getProductoMasVendido = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const result = await conn.execute(
    'SELECT PRODUCTO_MAS_VENDIDO FROM DUAL',
    [],
    {
      outFormat: oracledb.OUT_FORMAT_OBJECT,
    }
  );
  res.status(200).json(result.rows);
};

module.exports = {
  getProductos,
  createProducto,
  updateProducto,
  deleteProducto,
  getProductoMenosVendido,
  getProductoMasVendido,
};
