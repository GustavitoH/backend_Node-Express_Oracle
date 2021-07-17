const jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
  try {
    const token = req.headers.authorization.split(' ')[1];
    const decoded = jwt.verify(token, 'secretpassw');
    req.usuarioAuth = decoded;
    next();
  } catch (error) {
    return res.status(401).json({
      msg: 'Autenticación fallida',
      ...error,
    });
  }
};
