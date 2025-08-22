const express = require('express');
const router = express.Router();

const checkoutController = require('../controllers/checkout');

router.post('/', checkoutController.checkout);
router.post('/webhook', checkoutController.webhook);

module.exports = router;
