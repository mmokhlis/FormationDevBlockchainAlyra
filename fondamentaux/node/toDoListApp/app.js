/* liste des routes 
 /todo
 /todo/add
 /todo/delete/:id*/

var express = require("express");
var session = require("cookie-session");
var bodyParser = require("body-parser");
var urlencodedParser = bodyParser.urlencoded({ extended: false });

var app = express();

app.use(session({ secret : 'topsecret'}))

/* S'il n'y a pas de todolist dans la session,
on en crée une vide sous forme d'array avant la suite */
.use((req,res, next)=> {
    if(typeof(req.session.todolist)== 'undefined'){
        req.session.todolist = [];
    }
    next();
})


.get('/todo',(req, res) =>{
    res.render('todo.ejs',{todolist:req.session.todolist});
})

/* On ajoute un élément à la todolist */
.post('/todo/ajouter/', urlencodedParser, function(req, res) {
    if (req.body.newtodo != '') {
        req.session.todolist.push(req.body.newtodo);
    }
    res.redirect('/todo');
})
/* Supprime un élément de la todolist */
.get('/todo/supprimer/:id', function(req, res) {
    if (req.params.id != '') {
        req.session.todolist.splice(req.params.id, 1);
    }
    res.redirect('/todo');
})

/* On redirige vers la todolist si la page demandée n'est pas trouvée */
.use(function(req, res, next){
    res.redirect('/todo');
})

.listen(3000);