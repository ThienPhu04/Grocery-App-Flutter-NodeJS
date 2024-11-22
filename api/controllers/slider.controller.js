const sliderService = require("../services/sliders.service");
const upload = require("../middleware/slider.upload");

// Create and Save a new Slider
exports.create = (req, res, next) => {
    upload(req, res, function (err) {
        if (err) {
            next(err);
        } else {
            const path = req.file != undefined ? req.file.path.replace(/\\/g, "/") : "";

            var model = {
                sliderName: req.body.sliderName,
                sliderDescription: req.body.sliderDescription,
                sliderImage: path != "" ? "/" + path : ""
            };

            sliderService.createSlider(model, (error, result) => {
                if (error) {
                    return next(error);
                } else {
                    return res.status(200).send({
                        message: "Success",
                        data: result
                    });
                }
            });
        }
    });
}

// Retrieve all Sliders from the database.
exports.findAll = (req, res, next) => {
    var model = {
        sliderName: req.query.sliderName,
        pageSize: req.query.pageSize,
        page: req.query.page
    };

    sliderService.getSliders(model, (error, result) => {
        if (error) {
            return next(error);
        } else {
            return res.status(200).send({
                message: "Success",
                data: result
            });
        }
    });
};

// Find a single slider with an id
exports.findOne = (req, res, next) => {
    var model = {
        sliderId: req.params.id
    };

    sliderService.getSliderByID(model, (error, result) => {
        if (error) {
            return next(error);
        } else {
            return res.status(200).send({
                message: "Success",
                data: result
            });
        }
    });
};

// Update a Slider by the id in the request
exports.update = (req, res, next) => {
    upload(req, res, function (err) {
        if (err) {
            next(err);
        } else {
            const path = req.file != undefined ? req.file.path.replace(/\\/g, "/") : "";

            var model = {
                sliderId: req.params.id,
                sliderName: req.body.sliderName,
                sliderDescription: req.body.sliderDescription,
                sliderImage: path != "" ? "/" + path : ""
            };

            sliderService.updateSlider(model, (error, result) => {
                if (error) {
                    return next(error);
                } else {
                    return res.status(200).send({
                        message: "Success",
                        data: result
                    });
                }
            });
        }
    });
}

// Delete a Slider with the specified id in the request
exports.delete = (req, res, next) => {
    var model = {
        sliderId: req.params.id
    };

    sliderService.deleteSlider(model, (error, results) => {
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