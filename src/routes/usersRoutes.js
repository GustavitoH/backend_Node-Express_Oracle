const { Router } = require('express');
const router = Router();

const { getEmployes } = require('../controller/users.controller');

router.get('/users', getEmployes);

module.exports = router;
