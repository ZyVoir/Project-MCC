var express = require('express');
var router = express.Router();
const {protect} = require("../middleware/authMiddleware");
var con = require('./connect')

// untuk dapatin list semua pokemon yang ada di db
router.get('/getAll', protect, function (req, res) {

    const query = "SELECT * FROM mspokemon"

    con.query(query, (err, result) => {
        if (err) throw err;
        res.send(result)
    })
});

// buat ambil 1 pokemon tertentu
router.get('/get-pokemon/:pokemonid', protect, (req, res) => {
    const pokemonid = req.params.pokemonid
    const query = `SELECT * FROM mspokemon WHERE pokemonid = ${pokemonid}`
    con.query(query, (err, result) => {
        if (err) throw err;
        res.send(result)
    })
})


//insert pokemon
router.post('/insert-new-pokemon', protect, (req, res) => {
    const data = req.body;

    const query1 = `SELECT * FROM mspokemon WHERE PokemonID = ${data.PokemonID}`;

    con.query(query1, (error1, result1) => {
        if (error1) throw error1;
        if (result1.length > 0) {
            // jika id yang diberikan waktu insert telah ada di DB, maka insert pokemon digagalkan
            res.status(400).send("ID already exist");
            return;
        }
        else {
            // akan masuk sini jika id tidak ada di DB
            // pengecekan untuk melihat apakah elemen sekunder pokemon null atau tidak
            if (data.PokemonType_Secondary.localeCompare("NULL") == 0) {
                const query = `INSERT INTO mspokemon(PokemonID,PokemonName,PokemonImage_Link,PokemonType_Primary,PokemonDescription,PokemonHeight_ft,PokemonHeight_in,PokemonWeight_lbs,PokemonPrice_Dollar) VALUES ('${data.PokemonID}','${data.PokemonName}', '${data.PokemonImage_Link}', '${data.PokemonType_Primary}', '${data.PokemonDescription}', '${data.PokemonHeight_ft}', '${data.PokemonHeight_in}', '${data.PokemonWeight_lbs}', '${data.PokemonPrice_Dollar}');`
                console.log("if");
                con.query(query, (err, result) => {
                    if (err) throw err;
                    res.status(200).send(result)
                })
            }
            else {
                const query = `INSERT INTO mspokemon VALUES ('${data.PokemonID}','${data.PokemonName}', '${data.PokemonImage_Link}', '${data.PokemonType_Primary}', '${data.PokemonType_Secondary}', '${data.PokemonDescription}', '${data.PokemonHeight_ft}', '${data.PokemonHeight_in}', '${data.PokemonWeight_lbs}', '${data.PokemonPrice_Dollar}');`;
                console.log("else");
                con.query(query, (err, result) => {
                    if (err) throw err;
                    res.status(200).send(result)
                })
            }
        }
    })
})

//update pokemon
router.post('/update-pokemon',protect, (req, res) => {
    const data = req.body
    // pengecekan untuk melihat apakah elemen sekunder pokemon null atau tidak
    if (data.PokemonType_Secondary.localeCompare("NULL") == 0) {
        const query = `UPDATE mspokemon SET PokemonName = '${data.PokemonName}', PokemonImage_Link = '${data.PokemonImage_Link}',PokemonType_Primary = '${data.PokemonType_Primary}', PokemonType_Secondary = NULL, PokemonDescription = '${data.PokemonDescription}', PokemonHeight_ft =  ${data.PokemonHeight_ft}, PokemonHeight_in =  ${data.PokemonHeight_in},  PokemonWeight_lbs = ${data.PokemonWeight_lbs}, PokemonPrice_Dollar =  ${data.PokemonPrice_Dollar} WHERE PokemonID = ${data.PokemonID}`;
        con.query(query, (err, result) => {
            if (err) throw err;
            res.send(result)
        })
    } else {
        const query = `UPDATE mspokemon SET PokemonName = '${data.PokemonName}', PokemonImage_Link = '${data.PokemonImage_Link}',PokemonType_Primary = '${data.PokemonType_Primary}', PokemonType_Secondary = '${data.PokemonType_Secondary}', PokemonDescription = '${data.PokemonDescription}', PokemonHeight_ft =  ${data.PokemonHeight_ft}, PokemonHeight_in =  ${data.PokemonHeight_in},  PokemonWeight_lbs = ${data.PokemonWeight_lbs}, PokemonPrice_Dollar =  ${data.PokemonPrice_Dollar} WHERE PokemonID = ${data.PokemonID}`;
        con.query(query, (err, result) => {
            if (err) throw err;
            res.send(result)
        })
    }
})

// delete pokemon
router.delete('/delete-pokemon/',protect, (req, res) => {
    const pokemonId = req.body;
    const query = `DELETE FROM mspokemon WHERE PokemonID = ${pokemonId.PokemonID}`;
    con.query(query, (err, result) => {
        if (err) throw err;
        res.send(result)
        console.log("Success delete");
    })
})

// untuk mengambil pokemon yang dimiliki oleh user
router.get('/get-ownedpokemon/', protect, (req, res) => {
    const data = req.headers.authorization.split(" ")[1];
    const query = `SELECT PokemonID, OwnedPokemon FROM view_ownedpokemon
    WHERE token LIKE '${data}';`

    con.query(query, (err, result) => {
        if (err) throw err;
        res.send(result)
    })
})

// untuk mengambil transaction user
router.get('/get-transaction/',protect, (req, res) => {
    const data = req.headers.authorization.split(" ")[1];
    const query = `SELECT mp.PokemonID, mp.PokemonImage_Link, mp.PokemonName, mt.PokemonQuantity AS OwnedPokemon, (mt.PokemonQuantity * mp.PokemonPrice_Dollar) AS TotalSpend FROM mstransaction mt
JOIN mspokemon mp
ON mp.PokemonID = mt.PokemonID
JOIN msuser mu 
ON mu.Email = mt.Email
WHERE mu.token = '${data}'
ORDER BY TransactionID ASC;`;

    con.query(query, (err, result) => {
        if (err) throw err;
        res.send(result)
    })
})

// untuk mengambil wishlist user
router.get('/get-wishlist/', protect, (req,res)=>{
    const data = req.headers.authorization.split(" ")[1];
    const query =  `SELECT PokemonID FROM mswishlist mw JOIN msuser mu ON mu.Email = mw.Email WHERE mu.token = "${data}"`;
    con.query(query, (err,result)=>{
        if(err) throw err;
        else res.status(200).send(result);
    })

})

// untuk menambahkan wishlist user ke db
router.post('/create-transaction/',protect,(req,res) => {
    const email = req.body.email;
    const pokemonId = req.body.pokemonId;
    const PokemonQuantity = req.body.pokemonQuantity;
    const query = 'INSERT INTO mstransaction (Email,PokemonID,PokemonQuantity) VALUES (?, ?, ?);';
    con.query(query, [email, pokemonId, PokemonQuantity], (err, result)=>{
        if(err) throw err;
        else res.status(200).send("Created successfully");
    })
})

// untuk menghilangkan wishlist user ke db
router.post('/insert-wishlist/', protect, (req,res)=>{
    const email = req.body.email;
    const pokemonId = req.body.pokemonId;

    const query =`INSERT INTO mswishlist VALUES(?, ?)`;
    con.query(query,[email,pokemonId], (err,result)=>{
        if (err) throw err;
        else res.status(200).send(result);
    })
})

router.delete('/delete-wishlist', protect, (req,res)=>{
    const email = req.body.email;
    const pokemonId = req.body.pokemonId;
    const query = `DELETE FROM mswishlist WHERE Email = '${email}' AND PokemonID = ${pokemonId};`;
    con.query(query, (err,result)=>{
        if (err) throw err;
        else res.status(200).send(result);
    })
})

module.exports = router;
