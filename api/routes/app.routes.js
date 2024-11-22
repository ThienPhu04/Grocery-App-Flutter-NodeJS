const categoryController = require("../controllers/categories.controller");
const productsController = require("../controllers/products.controller");
const usersController = require("../controllers/users.controller");
const sliderController = require("../controllers/slider.controller");
const relatedProductController = require("../controllers/related-product.controller");
const cartController = require("../controllers/cart.controller");
const { authenticateToken } = require("../middleware/auth");
const express = require("express");
const router = express.Router();

// Create a new Category
router.post("/category", categoryController.create);

// Retrieve all Categories
router.get("/category", categoryController.findAll);

// Retrieve a single Category with id
router.get("/category/:id", categoryController.findOne);

// Update a Category with id
router.put("/category/:id", categoryController.update);

// Delete a Category with id
router.delete("/category/:id", categoryController.delete);

// Create a new Product
router.post("/product", productsController.create);

// Retrieve all Products
router.get("/product", productsController.findAll);

// Retrieve a single Product with id
router.get("/product/:id", productsController.findOne);

// Update a Product with id
router.put("/product/:id", productsController.update);

// Delete a Product with id
router.delete("/product/:id", productsController.delete);

// Register User
router.post("/register", usersController.register);

// Login User
router.post("/login", usersController.login);

// Create a new Slider
router.post("/slider", sliderController.create);

// Retrieve all Slider
router.get("/slider", sliderController.findAll);

// Retrieve a single Slider with id
router.get("/slider/:id", sliderController.findOne);

// Update a Slider with id
router.put("/slider/:id", sliderController.update);

// Delete a Slider with id
router.delete("/slider/:id", sliderController.delete);

// Create a new Related Product
router.post("/relatedProduct", relatedProductController.create);

// Delete a Related Product with id
router.delete("/relatedProduct/:id", relatedProductController.delete);

// Create a new Cart
router.post("/cart", [authenticateToken], cartController.create);

// Retrieve all Cart
router.get("/cart", [authenticateToken], cartController.findAll);

// Delete a Related Cart Item with id
router.delete("/cart", [authenticateToken], cartController.delete);

module.exports = router;