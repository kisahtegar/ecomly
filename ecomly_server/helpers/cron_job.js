const cron = require("node-cron");
const { Category } = require("../models/category");
const { Product } = require("../models/product");
const { CartProduct } = require("../models/cart_product");
const { default: mongoose } = require("mongoose");

/**
 * CRON Jobs Helper
 *
 * This contains scheduled background tasks for automated cleanup and maintenance.
 * Powered by `node-cron`, jobs are executed based on configured schedules.
 */

/**
 * Daily Category Cleanup (Every day at 00:00 (midnight))
 *
 * Description:
 * - Finds categories marked for deletion.
 * - Deletes them only if they no longer contain any products.
 *
 * Purpose:
 * - Keeps the database clean by removing unused categories.
 */
cron.schedule("0 0 * * *", async function () {
  try {
    const categoriesToBeDeleted = await Category.find({
      markedForDeletion: true,
    });

    for (const category of categoriesToBeDeleted) {
      const categoryProductsCount = await Product.countDocuments({
        category: category.id,
      });
      // Delete category only if no products remain
      if (categoryProductsCount < 1) await category.deleteOne();
    }
    console.log("CRON job completed at", new Date());
  } catch (error) {
    console.error("CRON job error:", error);
  }
});

/**
 * Reservation Release (Every 30 minutes)
 *
 * Description:
 * - Finds expired product reservations in `CartProduct`.
 * - Restores stock back to `Product.countInStock`.
 * - Marks cart products as unreserved.
 *
 * Purpose:
 * - Ensures inventory accuracy by reclaiming stock from abandoned/expired reservations.
 * - Prevents stock locking issues caused by inactive carts.
 *
 * Notes:
 * - Runs inside a MongoDB transaction for consistency.
 */
cron.schedule("*/30 * * * *", async function () {
  const session = await mongoose.startSession();
  session.startTransaction();

  try {
    console.log("Reservation Release CRON job started at", new Date());

    // Find expired reservations
    const expiredReservations = await CartProduct.find({
      reserved: true,
      reservationExpiry: { $lte: new Date() },
    }).session(session);

    for (const cartProduct of expiredReservations) {
      const product = await Product.findById(cartProduct.product).session(
        session
      );

      if (product) {
        // Restore stock back to product
        const updatedProduct = await Product.findByIdAndUpdate(
          product._id,
          { $inc: { countInStock: cartProduct.quantity } },
          { new: true, runValidators: true, session }
        );

        if (!updatedProduct) {
          console.error(
            "Error Occurred: Product update failed. Potential concurrency issue."
          );
          await session.abortTransaction();
          return;
        }
      }

      // Mark cart product as unreserved
      await CartProduct.findByIdAndUpdate(
        cartProduct._id,
        { reserved: false },
        { session }
      );
    }

    await session.commitTransaction();
    console.log("Reservation Release CRON job completed at", new Date());
  } catch (error) {
    console.error(error);
    await session.abortTransaction();

    // TODO(kisahtegar): `res` is undefined here. This might be throw an error if left.
    // You should remove `res.status` since this is not inside a route handler.
    // Instead, just log the error.
    return res.status(500).json({ type: error.name, message: error.message });
  } finally {
    await session.endSession();
  }
});
