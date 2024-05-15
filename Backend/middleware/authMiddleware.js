var express = require('express');
var pool = require('../routes/connect');

// middle ware untuk mengecek apakah authorized atau tidak
const protect = (req,res,next) =>{
    let token = "";
    // jika di mulai dari bearer, lanjut
    if (req.headers.authorization && req.headers.authorization.startsWith("Bearer")){
        token = req.headers.authorization.split(" ")[1];
        const query = `SELECT * FROM msuser where token = ?;`;
        pool.query(query, [token], (err,res)=>{
            if (err) throw err;
            else if (res.length > 0){
                // jika ada user dengan token yang di berikan pada header, lanjut 
                next();
            }else {
                // jika tidak, maka token bearer yang di passing tidak valid/ unauthorized
                res.status(401).send("Unauthorized!");
            }
        })
    }
    // jika token tidak diberikan ke header
    if (!token) {
        res.status(401).send("Missing token");
    }
}

module.exports = {protect};