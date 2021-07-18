const { Router } = require('express');
const router = Router();

const {
  getFactura,
  createFactura,
} = require('../controller/facturas.controller');

router.get('/facturas', getFactura);
router.post('/facturas', createFactura);

module.exports = router;
