const relatedProductServices = require("../services/related-products.service");

// Create and Save a new Related Product
exports.create = (req, res, next) => {
    relatedProductServices.addRelatedProduct(req.body, (error, results) => {
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

// Delete a Related Product with the specified id in the request
exports.delete = (req, res, next) => {
    var model = {
        id: req.params.id
    }

    relatedProductServices.removeRelatedProduct(model, (error, results) => {
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