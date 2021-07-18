const { Router } = require('express');
const router = Router();

const { getKardex } = require('../controller/kardex.controller');

router.get('/kardex', getKardex);

module.exports = router;
