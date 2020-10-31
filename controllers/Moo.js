'use strict';

const functions = require("../resources/functions");

var typingDnaClient = global.typingDnaClient;

var moo = {
    /** GET verify page */
    get: function(req, res) {
        /** If there is no session data redirect to index */
        if(!req.session || !req.session.data || !req.session.data.internalUserId) {
            return res.redirect('index');
        }
        
        var messages = Object.assign({},req.session.data.messages);
        res.render('moo', {
            title: 'Verify user - TypingDNA',
            sid:req.sessionID,
            messages: messages
        });
    },

    /** POST verify page. */
    post: function(req, res) {
        /** If there is no session data redirect to index */
        if(!req.session || !req.session.data ||!req.session.data.internalUserId) {
            return res.redirect('index');
        }
        var typing_pattern = req.body.tp;
        var sessionData = req.session.data;

        /** Verify if post body contains the typing pattern, if not display error message. */
        if(!typing_pattern) {
            sessionData.messages.errors.push({param: 'userId', msg:"Post body doesn't contain typing pattern"});
            return  req.session.save(function(){
                res.redirect(303,'Moo');
            })
        }

        /** If the previous authentication failed, join the two typing patterns and send them both for a better accuracy. */
        if(sessionData.lastTp) {
            typing_pattern +=';'+ sessionData.lastTp;
        }

        /** Verify typing pattern(s) */
        typingDnaClient.verify(sessionData.internalUserId, typing_pattern, req.body.quality || 2, function(error, result) {
            sessionData.lastResult = result;
            if(error || result['statusCode'] !== 200) {
                sessionData.messages.errors.push({param: 'userId', msg:'Error checking typing pattern'});
                return  req.session.save(function(){
                    res.redirect(303,'Moo');
                })
            }

            /** If the result returns success 0 then there are no previous saved patterns */
            if(result['success'] === 0) {
                return  req.session.save(function(){
                    res.redirect(303, 'enroll');
                })
            }

            if(result['result'] === 0) {
                /** If result is 0 then the authentication failed, we store the typing pattern in a session variable and retry
                 * authentication with another text.
                 */
                sessionData.typingResult = 0;
                return  req.session.save(function(){
                    res.redirect('final');
                })
            }
            else {
                /** Typing pattern authentication succeeded, redirect to final. */
                return  req.session.save(function(){
                    res.redirect('index');
                })
            }
        })
    }
};

module.exports = moo;
