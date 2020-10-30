'use strict';

var index = require('../controllers/index');
var Moozone = require('../controllers/Moozone');
var enroll = require('../controllers/enroll');

function initSessionVars() {
    return function(req, res, next) {
        if(!req.session.data) {
            req.session.data = {};
        }
        if(!req.session.data.messages || !req.session.data.messages.errors) {
            req.session.data.messages = {};
            req.session.data.messages.errors =  [];
        }
        next();
    }
}

module.exports = function(app){
    app.use(initSessionVars());
    app.get('/', index.get);
    app.post('/', index.post);
    app.get('/index', index.get);
    app.post('/index', index.post);
    app.get('/enroll', enroll.get);
    app.post('/enroll', enroll.post);
    app.get('/Moozone', Moozone.get);
    app.post('/Moozone', Moozone.post);
};

