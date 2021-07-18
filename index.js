const express = require('express');
const { config } = require('./src/config/index');
const app = express();
var cors = require('cors');

app.use(cors());
app.use(express.json());
app.use(function (req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  // Request methods you wish to allow
  res.setHeader(
    'Access-Control-Allow-Methods',
    'GET, POST, OPTIONS, PUT, PATCH, DELETE'
  );
  // Request headers you wish to allow
  res.setHeader(
    'Access-Control-Allow-Headers',
    'X-Requested-With,content-type'
  );
  // Set to true if you need the website to include cookies in the requests sent
  // to the API (e.g. in case you use sessions)
  res.setHeader('Access-Control-Allow-Credentials', true);
  // Pass to next layer of middleware
  next();
});
app.use(express.urlencoded({ extended: true }));

// Routes
app.use(require('./src/routes/productoRoutes'));
app.use(require('./src/routes/facturaRoutes'));
app.use(require('./src/routes/detalle_facturaRoutes'));
app.use(require('./src/routes/kardexRoutes'));

app.listen(config.localport, function () {
  console.log(`Listening http://localhost:${config.localport}`);
});
