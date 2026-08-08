require('dotenv').config();
const express = require('express');
const basicAuth = require('basic-auth');

const app = express();
const PORT = process.env.PORT || 3000;

// Basic Auth Middleware
function authMiddleware(req, res, next) {
  const user = basicAuth(req);

  const username = process.env.USERNAME;
  const password = process.env.PASSWORD;

  if (!user || user.name !== username || user.pass !== password) {
    res.set('WWW-Authenticate', 'Basic realm="Authentication Required"');
    return res.status(401).send('Access Denied');
  }

  next();
}

app.get('/', (req, res) => {
  res.send('How far?');
});

app.get('/secret', authMiddleware, (req, res) => {
  res.send(process.env.SECRET_MESSAGE);
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on http://0.0.0.0:${PORT}`);
});
