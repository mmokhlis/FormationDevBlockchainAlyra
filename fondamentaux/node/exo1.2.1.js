function fact(nbr1){
    var i , f = 1;
    for( i =1; i<=nbr1; i++ )
    {
        f = f*i;
        //f*=i;
    }
    return f;
}

function factRec(nbr){
    if (nbr == 0){
    return 1;
    }
    return nbr*factRec(nbr-1);

}
console.log(fact(5));
console.log(factRec(5));