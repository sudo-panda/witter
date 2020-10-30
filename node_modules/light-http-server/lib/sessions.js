/**
 * Created by Stefan on 9/19/2017
 */

'use strict';

var crypto = require('crypto');
var sessions={}
    , timeout;

function ownProp(o,p){return Object.prototype.hasOwnProperty.call(o,p)}

function lookupOrCreate(req,opts){
    var id,session;
    opts=opts || {};
    id=idFromRequest(req, opts);
    req.sessionID = id;

    if(ownProp(sessions, id)){
        session=sessions[id]}
    else{
        session=new Session(id,opts);
        sessions[id]=session}
    session.expiration=(+new Date)+session.lifetime * 1000;
    if(!timeout)
        timeout=setTimeout(cleanup, 60000);

    return session
}

function cleanup(){var id, now, next;
    now = +new Date;
    next=Infinity;
    timeout=null;
    for(id in sessions) if(ownProp(sessions,id)){
        if(sessions[id].expiration < now){
            delete sessions[id]}
        else next = next<sessions[id].expiration ? next : sessions[id].expiration}
    if(next<Infinity)
        timeout=setTimeout(cleanup,next - (+new Date) + 1000)
}

function idFromRequest(req,opts){var m;
    if(req.headers.cookie
        && (m = /connect.sid=([^ ,;]*)/.exec(req.headers.cookie))
        && ownProp(sessions,m[1])){
        return m[1]}

    if(opts.sessionID) return opts.sessionID;
    return crypto.createHash('sha256').update(randomString(64)+opts.secret).digest('hex');
}

function Session(id,opts){
    this.id=id;
    this.data={};
    this.path=opts.path||'/';
    this.domain=opts.domain;
    if(opts.lifetime) {
        this.persistent = 'persistent' in opts ? opts.persistent : true;
        this.lifetime=opts.lifetime}
    else {
        this.persistent=false;
        this.lifetime=86400
    }
    if(opts.secret) {
        this.secret = opts.secret
    }

}

function randomString(bits){var chars,rand,i,ret;
    chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    ret='';
    while(bits > 0){
        rand=Math.floor(Math.random()*0x100000000); // 32-bit integer
        for(i=26; i>0 && bits>0; i-=6, bits-=6) ret+=chars[0x3F & rand >>> i]}
    return ret
}

Session.prototype.getSetCookieHeaderValue=function(){var parts;
    parts=['connect.sid='+this.id];
    if(this.path) parts.push('path='+this.path);
    if(this.domain) parts.push('domain='+this.domain);
    if(this.persistent) parts.push('expires='+dateCookieString(this.expiration));
    return parts.join('; ')};

function dateCookieString(ms){var d,wdy,mon;
    d=new Date(ms);
    wdy=['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
    mon=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return wdy[d.getUTCDay()]+', '+pad(d.getUTCDate())+'-'+mon[d.getUTCMonth()]+'-'+d.getUTCFullYear()
        +' '+pad(d.getUTCHours())+':'+pad(d.getUTCMinutes())+':'+pad(d.getUTCSeconds())+' GMT'}

function pad(n){return n>9 ? ''+n : '0'+n}

Session.prototype.destroy = function(){
    delete sessions[this.id]
};

Session.prototype.save = function(callback){
    callback && callback();
};

module.exports.lookupOrCreate=lookupOrCreate;

module.exports.sessionRoot=sessions;
