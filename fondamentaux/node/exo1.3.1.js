function chiffreCesar(str, decalage) {
let alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ';
let chiffre;
let cesar ="";
console.log(str);
let k = decalage;

if (decalage<0) decalage+=26;
if (decalage>26) decalage-=26;
for (let i = 0; i< str.length;i++){
    if(str[i]==" ") {cesar+= str[i];}
    else {
        indexCesar= (alphabet.indexOf(str[i])+ k)%26;
        cesar+= alphabet.charAt(indexCesar)
        
    }
}
return cesar;
}

console.log(chiffreCesar("ABCD",3));
console.log(chiffreCesar("XYZ",3));
console.log(chiffreCesar("ABC XYZ",3));

