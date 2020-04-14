const express = require('express');
const app = express();
const https = require('https')


const url = "https://blockchain.info/rawblock/";

// /block/000000000002de92d93fcb92eeb2be097af8570a70fa5a8c6df473626891c9d6

// 1 - route "/"
app.get("/", (req,res)=>{
    res.send(" Hello world")
})

// 2 - route "/block/:block"
app.get("/block/:block",(req,res,next)=>{
    let block = req.params.block;
    let jsonBlock = {};
    https.get(url+block, response=>{
        let result = "";
        response.on("data", data => {
            result+= data;
        })
        response.on("end",()=>{
            let jsonBlock = JSON.parse(result)
            let tabHash = []
            let hauteur = jsonBlock.height
            for (let i=0,j=jsonBlock.tx.length;i<j;i++){
                tabHash.push(jsonBlock.tx[i].hash)
            }
            res.render('infoblock.ejs',{block: block, hauteur : hauteur, date : new Date(jsonBlock.time*1000), tabHash : tabHash})
            
            console.log(block)
            console.log(jsonBlock)
            console.log(new Date(jsonBlock.time*1000))
            console.log(jsonBlock.height)
            console.log(tabHash)
        })
        
    })
})
var port = "1338";
app.listen(port,()=>{
    console.log(`listen on port : ${port}`)
})