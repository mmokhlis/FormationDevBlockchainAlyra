var express = require("express");
var app = express();

app.get("/",(req, res) => {
    res.sendFile(__dirname+'/index.html')
    res.status(404).send("page introuvable")
}
);

app.get("/status", (req,res)=>{
    res.send("OK");
})
app.get("/:code",(req,res) => {
    //res.send(`vous avez saisi le code : ${req.params.code}`)
    res.render('code.ejs',{code: req.params.code,})
    console.log('code :'+req.params.code)
})

var port = "1337";
app.listen(port,()=>{
    console.log(" Express Node.js server running on port 1337")
})


// http.createServer(function(request, response){
//     response.writeHead(200,{
//         'Content-Type' : 'Text:plain'
//     });
//     response.write('Hello World !')
//     response.end();
//     console.log(`node js running on ${port}`);

// }).listen(port);