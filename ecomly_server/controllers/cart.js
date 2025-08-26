const { default: mongoose } = require("mongoose");
const { User } = require("../models/user");
const { CartProduct } = require("../models/cart_product");
const { Product } = require("../models/product");

/**
 * Get User Cart
 *
 * Retrieves all cart items for a given user, attaching product details and availability status.
 *
 * @param {Object} req - Express request object, expects user `id` in params.
 * @param {Object} res - Express response object, returns user cart items.
 *
 * @returns {JSON} Various status codes (200 on success, 404 if user/cart not found, 500 on error)
 */
exports.getUserCart = async function (req, res) {
  try {
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ message: "User not found" });

    const cartProducts = await CartProduct.find({ _id: { $in: user.cart } });
    if (!cartProducts) {
      return res.status(404).json({ message: "Cart not found" });
    }
    const cart = [];
    for (const cartProduct of cartProducts) {
      const product = await Product.findById(cartProduct.product);
      if (!product) {
        cart.push({
          ...cartProduct._doc,
          productExists: false,
          productOutOfStock: false,
        });
      } else {
        cartProduct.productName = product.name;
        cartProduct.productImage = product.image;
        cartProduct.productPrice = product.price;
        if (product.countInStock < cartProduct.quantity) {
          cart.push({
            ...cartProduct._doc,
            productExists: true,
            productOutOfStock: true,
          });
        } else {
          cart.push({
            ...cartProduct._doc,
            productExists: true,
            productOutOfStock: false,
          });
        }
      }
    }
    return res.json(cart);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Get User Cart Count
 *
 * Returns the total number of products in a user's cart.
 *
 * @param {Object} req - Express request object, expects user `id` in params.
 * @param {Object} res - Express response object, returns numeric count.
 *
 * @returns {JSON} Various status codes (200 on success, 404 if user not found, 500 on error)
 */
exports.getUserCartCount = async function (req, res) {
  try {
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ message: "User not found" });

    return res.json(user.cart.length);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Get Cart Product By ID
 *
 * Retrieves a single cart product by its ID with updated product details and stock validation.
 *
 * @param {Object} req - Express request object, expects `cartProductId` in params.
 * @param {Object} res - Express response object, returns cart product details.
 *
 * @returns {JSON} Various status codes (200 on success, 404 if product/cart item not found, 500 on error)
 */
exports.getCartProductById = async function (req, res) {
  try {
    const cartProduct = await CartProduct.findById(req.params.cartProductId);
    if (!cartProduct) {
      return res.status(404).json({ message: "Cart Product not found!" });
    }

    let cartProductData;

    const product = await Product.findById(cartProduct.product);

    const currentCartProductData = {
      id: cartProduct._id,
      product: cartProduct.product,
      quantity: cartProduct.quantity,
      selectedSize: cartProduct.selectedSize,
      selectedColour: cartProduct.selectedColour,
      productName: cartProduct.productName,
      productImage: cartProduct.productImage,
      productPrice: cartProduct.productPrice,
    };

    if (!product) {
      cartProductData = {
        ...currentCartProductData,
        productExists: false,
        productOutOfStock: false,
      };
    } else {
      currentCartProductData["productName"] = product.name;
      currentCartProductData["productImage"] = product.image;
      currentCartProductData["productPrice"] = product.price;
      if (
        !cartProduct.reserved &&
        product.countInStock < cartProduct.quantity
      ) {
        cartProductData = {
          ...currentCartProductData,
          productExists: true,
          productOutOfStock: true,
        };
      } else {
        cartProductData = {
          ...currentCartProductData,
          productExists: true,
          productOutOfStock: false,
        };
      }
    }
    return res.json(cartProductData);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Add To Cart
 *
 * Adds a product to a user's cart or increments quantity if it already exists. Handles stock validation
 * and updates product inventory with transactional safety.
 *
 * @param {Object} req - Express request object, expects user `id` in params and product details in body.
 * @param {Object} res - Express response object, returns added/updated cart product.
 *
 * @returns {JSON} Various status codes (201 on success, 400 if out of stock, 404 if user/product not found, 500 on error)
 */
exports.addToCart = async function (req, res) {
  const session = await mongoose.startSession();
  session.startTransaction();
  try {
    const { productId } = req.body;
    const user = await User.findById(req.params.id);
    if (!user) {
      await session.abortTransaction();
      return res.status(404).json({ message: "User not found" });
    }

    const userCartProducts = await CartProduct.find({
      _id: { $in: user.cart },
    });
    const existingCartItem = userCartProducts.find(
      (item) =>
        item.product.equals(new mongoose.Types.ObjectId(`${productId}`)) &&
        item.selectedSize === req.body.selectedSize &&
        item.selectedColour === req.body.selectedColour
    );

    const product = await Product.findById(productId).session(session);
    if (!product) {
      await session.abortTransaction();
      return res.status(404).json({ message: "Product not found" });
    }
    if (existingCartItem) {
      let condition = product.countInStock >= existingCartItem.quantity + 1;
      if (existingCartItem.reserved) {
        condition = product.countInStock >= 1;
      }
      if (condition) {
        existingCartItem.quantity += 1;
        await existingCartItem.save({ session });

        await Product.findOneAndUpdate(
          { _id: productId },
          { $inc: { countInStock: -1 } }
        ).session(session);

        await session.commitTransaction();
        return res.status(200).end();
      }
      await session.abortTransaction();
      return res.status(400).json({ message: "Out of stock" });
    }
    const { quantity, selectedSize, selectedColour } = req.body;
    const cartProduct = await new CartProduct({
      quantity,
      selectedSize,
      selectedColour,
      product: productId,
      productName: product.name,
      productImage: product.image,
      productPrice: product.price,
    }).save({ session });

    if (!cartProduct) {
      await session.abortTransaction();
      return res
        .status(500)
        .json({ message: "The product could not added to your cart." });
    }

    user.cart.push(cartProduct.id);
    await user.save({ session });

    const updatedProduct = await Product.findOneAndUpdate(
      { _id: productId, countInStock: { $gte: cartProduct.quantity } },
      { $inc: { countInStock: -cartProduct.quantity } },
      { new: true, session }
    );

    if (!updatedProduct) {
      await session.abortTransaction();
      return res
        .status(400)
        .json({ message: "Insufficient stock or concurrency issue" });
    }

    await session.commitTransaction();
    return res.status(201).json(cartProduct);
  } catch (error) {
    console.error(error);
    await session.abortTransaction();
    return res.status(500).json({ type: error.name, message: error.message });
  } finally {
    await session.endSession();
  }
};

/**
 * Modify Product Quantity
 *
 * Updates the quantity of a specific cart product while ensuring stock availability.
 *
 * @param {Object} req - Express request object, expects user `id` and `cartProductId` in params, new `quantity` in body.
 * @param {Object} res - Express response object, returns updated cart product.
 *
 * @returns {JSON} Various status codes (200 on success, 400 if insufficient stock, 404 if user/product not found, 500 on error)
 */
exports.modifyProductQuantity = async function (req, res) {
  try {
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ message: "User not found" });

    const { quantity } = req.body;

    let cartProduct = await CartProduct.findById(req.params.cartProductId);
    if (!cartProduct) {
      return res.status(404).json({ message: "Product not found" });
    }

    const actualProduct = await Product.findById(cartProduct.product);
    if (!actualProduct) {
      return res.status(404).json({ message: "Product does not exist" });
    }

    if (quantity > actualProduct.countInStock) {
      return res
        .status(400)
        .json({ message: "Insufficient stock for the requested quantity" });
    }

    cartProduct = await CartProduct.findByIdAndUpdate(
      req.params.cartProductId,
      { quantity },
      { new: true }
    );

    if (!cartProduct) {
      return res.status(404).json({ message: "Product not found" });
    }
    return res.json(cartProduct);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Remove From Cart
 *
 * Removes a product from a user's cart, restoring stock if applicable, with transactional consistency.
 *
 * @param {Object} req - Express request object, expects user `id` and `cartProductId` in params.
 * @param {Object} res - Express response object, returns no content on success.
 *
 * @returns {JSON} Various status codes (204 on success, 400 if product not in cart, 404 if user/cart item not found, 500 on error)
 */
exports.removeFromCart = async function (req, res) {
  const session = await mongoose.startSession();
  session.startTransaction();
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      await session.abortTransaction();
      return res.status(404).json({ message: "User not found" });
    }

    if (!user.cart.includes(req.params.cartProductId)) {
      await session.abortTransaction();
      return res.status(400).json({ message: "Product not in your cart" });
    }

    const cartItemToRemove = await CartProduct.findById(
      req.params.cartProductId
    );
    if (!cartItemToRemove) {
      await session.abortTransaction();
      return res.status(404).json({ message: "Cart Item not found" });
    }

    if (cartItemToRemove.reserved) {
      const updatedProduct = await Product.findOneAndUpdate(
        { _id: cartItemToRemove.product },
        { $inc: { countInStock: cartItemToRemove.quantity } },
        { new: true, session }
      );
      if (!updatedProduct) {
        await session.abortTransaction();
        return res.status(500).json({ message: "Internal Server Error" });
      }
    }

    user.cart.pull(cartItemToRemove.id);
    await user.save({ session });

    const cartProduct = await CartProduct.findByIdAndDelete(
      cartItemToRemove.id
    ).session(session);

    if (!cartProduct) {
      return res.status(500).json({ message: "Internal Server Error" });
    }
    await session.commitTransaction();
    return res.status(204).end();
  } catch (error) {
    console.error(error);
    await session.abortTransaction();
    return res.status(500).json({ type: error.name, message: error.message });
  } finally {
    await session.endSession();
  }
};
