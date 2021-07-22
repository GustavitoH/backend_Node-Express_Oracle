const { Router } = require('express');
const router = Router();

const {
  getDetalle_Factura,
  createDetalle_Factura,
  getIdFactura,
} = require('../controller/detalle_facturas.controller');

router.get('/detallefacturas', getDetalle_Factura);
router.get('/detallefacturas/id', getIdFactura);
router.post('/detallefacturas', createDetalle_Factura);

module.exports = router;
