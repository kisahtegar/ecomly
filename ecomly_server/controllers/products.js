const { Product } = require("../models/product");

/**
 * Get Products
 *
 * Retrieves products with optional filters such as category, criteria (new arrivals, popular),
 * and pagination. Excludes large fields (images, reviews, size) to optimize response size.
 *
 * @param {Object} req - Express request object, supports query params:
 *   - `page` (number): current page number for pagination.
 *   - `criteria` (string): filter type ("newArrivals" | "popular").
 *   - `category` (string): category ID to filter products.
 * @param {Object} res - Express response object, returns a list of products or error response.
 *
 * @returns {JSON} Various status codes (200 on success, 404 if none found, 500 on error)
 */
exports.getProducts = async function (req, res) {
  try {
    let products;
    const page = req.query.page || 1;
    const pageSize = 10;

    if (req.query.criteria) {
      let query = {};
      if (req.query.category) {
        query["category"] = req.query.category;
      }
      switch (req.query.criteria) {
        case "newArrivals": {
          const twoWeeksAgo = new Date();
          twoWeeksAgo.setDate(twoWeeksAgo.getDate() - 14);
          query["dateAdded"] = { $gte: twoWeeksAgo };
          break;
        }
        case "popular":
          query["rating"] = { $gte: 4.5 };
          break;
        default:
          break;
      }
      products = await Product.find(query)
        .select("-images -reviews -size")
        .skip((page - 1) * pageSize)
        .limit(pageSize);
    } else if (req.query.category) {
      products = await Product.find({ category: req.query.category })
        .select("-images -reviews -size")
        .skip((page - 1) * pageSize)
        .limit(pageSize);
    } else {
      products = await Product.find()
        .select("-images -reviews -size")
        .skip((page - 1) * pageSize)
        .limit(pageSize);
    }

    if (!products) {
      return res.status(404).json({ message: "Products not found" });
    }
    return res.json(products);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Search Products
 *
 * Provides text-based search for products with optional category and gender/age filters,
 * including pagination. Uses MongoDB text indexes for efficient searching.
 *
 * @param {Object} req - Express request object, supports query params:
 *   - `q` (string): search term for text search.
 *   - `page` (number): current page number for pagination.
 *   - `category` (string): filter by category ID.
 *   - `genderAgeCategory` (string): filter by gender/age group.
 * @param {Object} res - Express response object, returns search results or error response.
 *
 * @returns {JSON} Various status codes (200 on success, 500 on error)
 */
exports.searchProducts = async function (req, res) {
  try {
    const searchTerm = req.query.q;

    const page = req.query.page || 1;
    const pageSize = 10;

    // const simpleTextSearch = name: {$regex: searchTerm, $options: 'i'};
    // const indexedTextSearch = $text: {
    //   $search: searchTerm,
    //   $language: 'english', // Specify the language for stemming rules
    //   $caseSensitive: false, // Make the search case-insensitive
    // };

    let query = {};
    if (req.query.category) {
      query = { category: req.query.category };
      if (req.query.genderAgeCategory) {
        query["genderAgeCategory"] = req.query.genderAgeCategory.toLowerCase();
      }
    } else if (req.query.genderAgeCategory) {
      query = { genderAgeCategory: req.query.genderAgeCategory.toLowerCase() };
    }
    if (searchTerm) {
      query = {
        ...query,
        $text: {
          $search: searchTerm,
          $language: "english", // Specify the language for stemming rules
          $caseSensitive: false, // Make the search case-insensitive
        },
      };
    }
    const searchResults = await Product.find(query)
      .skip((page - 1) * pageSize)
      .limit(pageSize);

    return res.json(searchResults);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

/**
 * Get Product by ID
 *
 * Retrieves a single product by its ID. Excludes reviews for efficiency.
 *
 * @param {Object} req - Express request object, expects `id` in params.
 * @param {Object} res - Express response object, returns the product or error response.
 *
 * @returns {JSON} Various status codes (200 on success, 404 if not found, 500 on error)
 */
exports.getProductById = async function (req, res) {
  try {
    const product = await Product.findById(req.params.id).select("-reviews");
    if (!product) {
      return res.status(404).json({ message: "Product not found!" });
    }
    return res.json(product);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};
