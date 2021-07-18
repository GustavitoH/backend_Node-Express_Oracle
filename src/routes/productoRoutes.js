const { Router } = require('express');
const router = Router();

const {
  getProductos,
  createProducto,
  deleteProducto,
  updateProducto,
} = require('../controller/productos.controller');
const {
  getFactura,
  createFactura,
  updateFactura,
  deleteFactura,
} = require('../controller/facturas.controller');
const {
  getDetalle_Factura,
  createDetalle_Factura,
  updateDetalle_Factura,
  deleteDetalle_Factura,
} = require('../controller/detalle_facturas.controller');
const {
  getKardex,
  createKardex,
  updateKardex,
  deleteKardex,
} = require('../controller/kardex.controller');

router.get('/productos', getProductos);
router.post('/productos', createProducto);
router.put('/productos', updateProducto);
router.delete('/productos', deleteProducto);

router.get('/facturas', getFactura);
router.post('/facturas', createFactura);
router.put('/facturas', updateFactura);
router.delete('/facturas', deleteFactura);

router.get('/detalle_facturas', getDetalle_Factura);
router.post('/detalle_facturas', createDetalle_Factura);
router.put('/detalle_facturas', updateDetalle_Factura);
router.delete('/detalle_facturas', deleteDetalle_Factura);

router.get('/kardex', getKardex);
router.post('/kardex', createKardex);
router.put('/kardex', updateKardex);
router.delete('/kardex', deleteKardex);

module.exports = router;
