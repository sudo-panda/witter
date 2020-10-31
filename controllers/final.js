'use strict';
function final(req, res) {
    var loggedIn = (req.session && req.session.data.typingResult === 1);
    var lastResult = req.session.data.lastResult;
        res.render('final', {
            title: 'Final-webpage',
            sid:req.sessionID,
            loggedIn: loggedIn,
            lastResult: lastResult
        });
        req.session.data = {};
}

module.exports = final;
