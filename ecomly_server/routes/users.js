const express = require("express");
const router = express.Router();

const usersController = require("../controllers/users");
const cartController = require("../controllers/cart");
const wishlistsController = require("../controllers/wishlists");

// Users
router.get("/", usersController.getUsers);
router.get("/:id", usersController.getUserById);
router.put("/:id", usersController.updateUser);
router.get("/:id/paymentProfile", usersController.getPaymentProfile);

// Cart
router.get("/:id/cart", cartController.getUserCart);
router.get("/:id/cart/count", cartController.getUserCartCount);
router.post("/:id/cart", cartController.addToCart);
router.put("/:id/cart/:cartProductId", cartController.modifyProductQuantity);
router.get("/:userId/cart/:cartProductId", cartController.getCartProductById);
router.delete("/:userId/cart/:cartProductId", cartController.removeFromCart);

// Wishlists
router.get("/:id/wishlist", wishlistsController.getUserWishlist);
router.post("/:id/wishlist", wishlistsController.addToWishlist);
router.delete("/:id/wishlist/:productId", wishlistsController.removeFromWishlist);

module.exports = router;
