const express = require("express");
const router = express.Router();

const usersController = require("../controllers/users");

router.get("/", usersController.getUsers);
router.get("/:id", usersController.getUserById);
router.put("/:id", usersController.updateUser);
router.get("/:id/paymentProfile", usersController.getPaymentProfile);

module.exports = router;
