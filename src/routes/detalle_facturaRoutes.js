const { Router } = require('express');
const router = Router();

const {
  getDetalle_Factura,
  createDetalle_Factura,
} = require('../controller/detalle_facturas.controller');

router.get('/detallefacturas', getDetalle_Factura);
router.post('/detallefacturas', createDetalle_Factura);

module.exports = router;
