const { unlink } = require("fs/promises");
const multer = require("multer");
const path = require("path");

const ALLOWED_EXTENSIONS = {
  "image/png": "png",
  "image/jpeg": "jpeg",
  "image/jpg": "jpg",
};

/**
 * Multer storage configuration:
 * - Saves files in `public/uploads`.
 * - Renames files by removing spaces & extension, then appending timestamp.
 */
const storage = multer.diskStorage({
  destination: function (_, __, cb) {
    cb(null, "public/uploads");
  },
  filename: function (_, file, cb) {
    const filename = file.originalname
      .replace(" ", "-")
      .replace(/\.png|\.jpg|\.jpeg/gi, ""); // regex for safety
    const extension = ALLOWED_EXTENSIONS[file.mimetype];
    cb(null, `${filename}-${Date.now()}.${extension}`);
  },
});

/**
 * Multer middleware for handling image uploads.
 *
 * - Limits file size to 5MB.
 * - Restricts uploads to allowed MIME types only.
 *
 * @example
 * // Express route
 * router.post("/upload", upload.single("image"), (req, res) => {
 *   res.json({ file: req.file });
 * });
 */
exports.upload = multer({
  storage: storage,
  limits: { fileSize: 1024 * 1024 * 5 }, // 5MB
  fileFilter: (_, file, cb) => {
    const isValid = ALLOWED_EXTENSIONS[file.mimetype];
    let uploadError = new Error(
      `Invalid image type\n${file.mimetype} is not allowed`
    );
    if (!isValid) return cb(uploadError);
    return cb(null, true);
  },
});

/**
 * Delete images from the `public/uploads` folder.
 *
 * @async
 * @function deleteImages
 * @param {string[]} imageUrls - Array of image URLs/paths to delete.
 * @param {string} continueOnErrorName - File system error code to ignore (e.g., "ENOENT").
 * @returns {Promise<void>} Resolves when deletion is complete.
 *
 * @example
 * await deleteImages(
 *   ["/uploads/img1.png", "/uploads/img2.png"],
 *   "ENOENT" // Ignore "file not found" errors
 * );
 */
exports.deleteImages = async function (imageUrls, continueOnErrorName) {
  await Promise.all(
    imageUrls.map(async (imageUrl) => {
      const imagePath = path.resolve(
        __dirname,
        "..",
        "public",
        "uploads",
        path.basename(imageUrl)
      );
      try {
        await unlink(imagePath);
      } catch (error) {
        if (error.code === continueOnErrorName) {
          console.error(`Continuing with the next image: ${error.message}`);
        } else {
          console.error(`Error deleting image: ${error.message}`);
          throw error;
        }
      }
    })
  );
};
