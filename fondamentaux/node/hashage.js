const crypto = require('crypto')

function codeVerification(message){
    let data = Buffer.from(message)
    let hash = crypto.createHash('sha256').update(data)
    return hash.digest('hex')
}

function verifierCode(message,code){
    let data = Buffer.from(message)
    let hash = crypto.createHash('sha256').update(data)
    return ( code  == hash.digest('hex'))
}

function vanite(debut, message){
    let nonce = 0

    return nonce
}
function verifierVanite(debut, message, nonce){
    
    
    return true
}


let message = "Bonjour à tous"

console.log(`Le message est \'${message}\'. Le condensat est ${codeVerification(message)}`)

let code = "2bb9271671b868ac4862815f0ae58b0aa985f2e845cd7ffa06d14688bb1a6e9c"

// let code = codeVerification(message)
console.log(`Code de vérification :\' ${code}\', validité : ${verifierCode(message,code)}`)

// let debutHash = 'ab'
// console.log(`Un hash débutant par \'${debutHash}\' peut être obtenu en ajoutant ${vanite(debutHash,message)} au message`)