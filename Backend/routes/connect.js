// untuk melakukan koneksi dengan mysql2
const mysql = require('mysql2');
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'flokemon'

})

connection.connect()
module.exports = connection;