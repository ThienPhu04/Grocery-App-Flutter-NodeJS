const { relatedProduct } = require("../models/related-products.model");
const { product } = require("../models/product.model");

async function addRelatedProduct(params, callback) {
    if (!params.product) {
        return callback({
            message: "Product ID Required"
        });
    }

    if (!params.relatedProduct) {
        return callback({
            message: "Related Product ID Required"
        });
    }

    const relatedProductModel = new relatedProduct(params);
    relatedProductModel.save()
        .then(async (response) => {
            await product.findOneAndUpdate(
                {
                    _id: params.product
                },
                {
                    $addToSet: {
                        "relatedProducts": relatedProductModel
                    }
                }
            );
            return callback(null, response);
        }).catch((error) => {
            return callback(error);
        });
}

async function removeRelatedProduct(params, callback) {
    const id = params.id;

    relatedProduct.findByIdAndRemove(id).then((response) => {
        if (!response) {
            return callback({
                message: "Product ID Not Found"
            });
        } else {
            return callback(null, response);
        }
    }).catch((error) => {
        return callback(error);
    });
}

module.exports = {
    addRelatedProduct,
    removeRelatedProduct
}