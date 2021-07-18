const { Router } = require('express');
const router = Router();

const {
  getProductos,
  createProducto,
  updateProducto,
} = require('../controller/productos.controller');

router.get('/productos', getProductos);
router.post('/productos', createProducto);
router.put('/productos/:id', updateProducto);

module.exports = router;
