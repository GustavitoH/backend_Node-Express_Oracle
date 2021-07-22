const { Router } = require('express');
const router = Router();

const {
  getProductos,
  createProducto,
  updateProducto,
  deleteProducto,
  getProductoMenosVendido,
  getProductoMasVendido,
  getTotalProductos,
  getTotalVentas,
} = require('../controller/productos.controller');

router.get('/productos', getProductos);
router.get('/productos/menosvendidos', getProductoMenosVendido);
router.get('/productos/masvendidos', getProductoMasVendido);
router.get('/productos/total', getTotalProductos);
router.get('/productos/totalventas', getTotalVentas);
router.post('/productos', createProducto);
router.put('/productos/:id', updateProducto);
router.delete('/productos/:id', deleteProducto);

module.exports = router;
