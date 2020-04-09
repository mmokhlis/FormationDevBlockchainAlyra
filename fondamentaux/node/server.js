var http = require("http");
var port = "3000";

http.createServer(function(request, response){
    response.writeHead(200,{
        'Content-Type' : 'Text:plain'
    });
    response.write('Hello World !')
    response.end();
    console.log(`node js running on ${port}`);

}).listen(port);