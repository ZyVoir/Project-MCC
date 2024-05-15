const express = require('express');
const { login, register, edituser, getUser, googleLogin } = require('../controller/userController');

var con = require('./connect')

const router = express.Router(); 

// function di userController
router.get('/getUser/:token', getUser)
router.post('/login', login)
router.post('/register', register)
router.post('/update-user', edituser)
router.post('/googleLogin', googleLogin)

module.exports = router;
