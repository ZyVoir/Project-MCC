var express = require('express');
var router = express.Router();
var pool = require('../routes/connect');


// untuk login
const login = (req, res) => {
    const email = req.body.email;
    const password = req.body.password;

    // mengecek apakah email ada atau tidak
    const query1 = "SELECT email FROM msuser WHERE email = ?";
    pool.query(query1, [email], (err, result1) => {
        if (err) throw err;
        else if (result1.length == 0) {
            // jka tidak ada email yang terdaftar pada db untuk login, maka return 404
            res.status(404).send("email not exist!");
            return;
        }else {
            // jika ada email nya , cek dengan password
            const query = "SELECT email,username, token, role FROM msuser WHERE email = ? AND userpassword = ?";
            pool.query(query, [email, password], (err1, result2) => {
                if (err1) throw err;
                else if (result2.length > 0) {
                    // jika ada, maka login berhasil dan lanjut
                    res.status(200).send(result2);
                    return;
                }
                // jika tidak , maka email ada tetapi password salah
                else res.status(400).send("incorrect input");
                return;
            })
        }
    })
}

// function untuk generate token bearer untuk dicek oleh middleware
function generateToken() {
    const stringSet = 'abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    let token = ''
    for (let i = 0; i < 10; i++) {
        let indexValue = Math.floor(Math.random() * stringSet.length)
        token += stringSet.charAt(indexValue)
    }

    return token
}

// untuk register
const register = (req, res) => {

    const email = req.body.email;
    const password = req.body.password;
    const username = req.body.username;

    const query1 = "SELECT email FROM msuser WHERE email = ?";
    // mengecek apakah email sudah teregister
    pool.query(query1, [email], (err, result1) => {
        if (err) throw err;
        else if (result1.length > 0) {
            // jika sudah ada email , maka tidak bisa melakukan register
            res.status(400).send("email exist!");
            return;
        }else {
            // jika email tidak ada, maka masukkan data ke db
            const query = "INSERT INTO msuser (email, username, userpassword, token, role) VALUES (?,?,?,?, 'user')";
            const token = generateToken();
            pool.query(query, [email,username, password,token], (err, result2) => {
                if (err) throw err;
                res.status(200).send(result2);
                return;
            })
        }
    })
}

const edituser = (req, res) => {
    const email = req.body.email;
    const oldpassword = req.body.oldpassword;
    const newpassword = req.body.newpassword;
    const username = req.body.username;
    const query = `SELECT username, email, userpassword FROM msuser WHERE email = ? AND userpassword = ?`

    pool.query(query, [email,oldpassword], (err1, results1) => {
        if (err1) throw err1;
        else if (results1.length > 0) {
            if (newpassword){
                const updateName = `UPDATE msuser SET username = ?, userpassword = ? WHERE email = ?;`;
                pool.query(updateName, [username, newpassword,email], (err2, nameResult) => {
                    if (err2) throw err2;
                    return res.status(200).send(nameResult);
                });
            }else {
                const updateName = `UPDATE msuser SET username = ? WHERE email = ?;`;
                pool.query(updateName, [username,email], (err2, nameResult) => {
                    if (err2) throw err2;
                    return res.status(200).send(nameResult);
                });
            }
        }
        else return res.status(400).send("incorrect password")
    });
};

const getUser = (req,res) =>{
    const token = req.params.token;
    const query = `SELECT email,username,token,role FROM msuser
WHERE token = '${token}';`
    pool.query(query,(error, result) =>{
        if (error) throw error;
        else res.status(200).send(result);
    })
}

const googleLogin = (req,res) =>{
    const email = req.body.email;
    const username = req.body.username;
    
    const query1 = "SELECT email,username,token,role FROM msuser WHERE email = ?";
    
    pool.query(query1, [email], (err1, result1) => {
        if (err1) throw err1;
        else if (result1.length > 0) {
            res.status(200).send(result1);
            return;
        }else {
            const query = "INSERT INTO msuser (email, username, token, role) VALUES (?,?,?, 'userGoogle');";
            const token = generateToken();
            pool.query(query, [email,username,token], (err2, result2) => {
                if (err2) throw err2;
                else {
                    pool.query(query1, [email], (err3,result3) =>{
                        if (err3) throw err3;
                        res.status(200).send(result3);
                    })
                    return;
                }
            })
        }
    })
}

module.exports = {
    login,
    register,
    edituser,
    getUser,
    googleLogin
}