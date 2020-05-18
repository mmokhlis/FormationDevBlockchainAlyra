const crypto = require('crypto');
const crypto = require('crypto')

class Block {
    constructor(index, previousHash, timestimp, data , hash){
        this.index = index;
        this.previousHash = previousHash.toString();
        this.timestimp = timestimp; 
        this.data = data;
        this.hash = hash.toString();
    }
}
var calculateHash = (index, previousHash, timestamp, data) => {
    let datahash = Buffer.from(index+ previousHash+ timestamp+ data);
    return crypto.createHash('sha256').update(datahash).digest('hex').toString();
    return CryptoJS.SHA256(index + previousHash + timestamp + data).toString();
};
var getGenesisBlock = () => {
    return new Block(0, "0", 1465154705, "mon genesis block !", "816534932c2b7154836da6afc367695e6337db8a921823784c14378abed4f7d7");
};
var generateNextBlock = (blockData) => {
    var previousBlock = getLatestBlock();
    var nextIndex = previousBlock.index + 1;
    var nextTimestamp = new Date().getTime() / 1000;
    var nextHash = calculateHash(nextIndex, previousBlock.hash, nextTimestamp, blockData);
    return new Block(nextIndex, previousBlock.hash, nextTimestamp, blockData, nextHash);
};
var blockchain = [getGenesisBlock()];

var isValidNewBlock = (newBlock, previousBlock) => {
    if (previousBlock.index + 1 !== newBlock.index) {
        console.log('index invalide');
        return false;
    } else if (previousBlock.hash !== newBlock.previousHash) {
        console.log('previousHash invalide');
        return false;
    } else if (calculateHashForBlock(newBlock) !== newBlock.hash) {
        console.log(typeof (newBlock.hash) + ' ' + typeof calculateHashForBlock(newBlock));
        console.log('hash invalide: ' + calculateHashForBlock(newBlock) + ' ' + newBlock.hash);
        return false;
    }
    return true;
};

