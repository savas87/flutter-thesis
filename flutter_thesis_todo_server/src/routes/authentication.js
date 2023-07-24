const express = require('express');
const controllers = require("../controllers");
const router = express.Router();

router.post('/register', controllers.authentication.register);
router.post('/login', controllers.authentication.login);
router.post('/logout', controllers.authentication.logout);

module.exports = router;