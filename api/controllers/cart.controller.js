const cartService = require("../services/cart.service");

// Create and Save a new Cart
exports.create = (req, res, next) => {
    var model = {
        userId: req.user.userId,
        products: req.body.products
    }

    cartService.addCart(model, (error, results) => {
        if (error) {
            return next(error);
        } else {
            return res.status(200).send({
                message: "Success",
                data: results
            });
        }
    });
}

// Retrieve all Cart from the database.
exports.findAll = (req, res, next) => {
    cartService.getCart({ userId: req.user.userId }, (error, results) => {
        if (error) {
            return next(error);
        } else {
            return res.status(200).send({
                message: "Success",
                data: results
            });
        }
    });
}

// Delete a Cart Item with the specified id in the request
exports.delete = (req, res, next) => {
    var model = {
        userId: req.user.userId,
        productId: req.body.productId,
        qty: req.body.qty
    }

    cartService.removeCartItem(model, (error, results) => {
        if (error) {
            return next(error);
        } else {
            return res.status(200).send({
                message: "Success",
                data: results
            });
        }
    });
}