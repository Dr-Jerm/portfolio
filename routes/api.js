/*
 * Serve JSON to our AngularJS client
 */

 var portfolioData = require('../portfolioData.json');

exports.json = function (req, res) {
    var jsonReq = req.params.json;
    res.setHeader('Content-Type', 'application/json');

    if (jsonReq == 'portfolio') {
        res.json(portfolioData);
    } else if (portfolioData[jsonReq]) {
        res.json(portfolioData[jsonReq]);
    } else {
        res.status(404).send("Data not found");
    }
};