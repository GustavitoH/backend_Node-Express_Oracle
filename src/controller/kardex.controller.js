const oracledb = require('oracledb');
const { cns } = require("../config/index")

const getKardex = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const response = await conn.execute('SELECT * FROM KARDEX');
  res.status(200).json(response.rows);
};

const createKardex = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const { producto, fecha, accion} = req.body;
  const response = await conn.execute(
  `execute kardex_insertar(${producto},${fecha},${accion});`
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

const updateKardex = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const id = parseInt(req.params.id);
  const { producto, fecha, accion} = req.body;
  const response = await conn.execute(0
    `execute kardex_update(${id},${producto},${fecha},${accion});`
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

const deleteKardex = async (req, res) => {
  const conn = await oracledb.getConnection(cns);
  const id = parseInt(req.params.id);
  const response = await conn.execute(
    `delete from kardex where id=${id}`
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
  getKardex,
  createKardex,
  updateKardex,
  deleteKardex,
};
