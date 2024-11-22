const express = require("express");
const app = express();
const cors = require("cors")
const mongoose = require("mongoose");
const { MONGO_DB_CONFIG } = require("./config/app.config");
const errors = require("./middleware/errors.js");
const ip = require("ip");
// const auth = require("./middleware/auth");
// const { unless } = require("express-unless");
const swaggerUi = require("swagger-ui-express"), swaggerDocument = require("./swagger.json");

// connect to mongodb

/**
 * With useNewUrlParser: The underlying MongoDB driver has deprecated their current connection string parser.
 * Because this is a major change, they added the useNewUrlParser flag to allow users to fall back to the old parser if they find a bug in the new parser.
 * You should set useNewUrlParser: true unless that prevents you from connecting.
 *
 * With useUnifiedTopology, the MongoDB driver sends a heartbeat every heartbeatFrequencyMS to check on the status of the connection.
 * A heartbeat is subject to serverSelectionTimeoutMS , so the MongoDB driver will retry failed heartbeats for up to 30 seconds by default.
 */
mongoose.Promise = global.Promise;
mongoose.connect(MONGO_DB_CONFIG.DB, {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(
    () => {
        console.log("Database connected");
    },
    (error) => {
        console.log("Database can't be connected: " + error);
    }
);

app.use(express.json());
app.use(cors());
app.use("/uploads", express.static("uploads"));

// // initialize JWT Authentication
// auth.authenticationToken.unless = unless;
// app.use(
//     auth.authenticationToken.unless({
//         path: [
//             { url: "/api/login", methods: ["POST"] },
//             { url: "/api/resgistration", methods: ["POST"] }
//         ]
//     })
// );

// initialize routes
app.use("/api", require("./routes/app.routes"));

app.use(errors.errorHandler);

app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument));

// listen for requests
app.listen(process.env.port || 4000, function () {
    console.log("Ready to Go!");
    console.log("IP Address : ", ip.address());
});