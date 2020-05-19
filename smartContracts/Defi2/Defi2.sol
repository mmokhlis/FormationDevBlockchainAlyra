    pragma solidity ^0.6.3;
    pragma experimental ABIEncoderV2;
    
    //import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
    
    contract Defi2 {
        
        mapping(address => uint) private balancesDemandeurs;
        
        //Mécanisme de réputation
        struct Illustrateur {
            uint reputation; //Pour représenter la réputation, nous allons associer chaque utilisateur à une valeur entière
            string nom ;//Un nom est aussi associé à l’adresse
            bool estMembre; // si il est membre ou pas
        }
        mapping (address => Illustrateur) illustrateurs;
        address[] public illustrateursAccts;
        
        struct Demandeur {
            address adresseDemandeur;
            bool estInscrit;
        }
        mapping (address => Demandeur) demandeurs;
        address[] public demandeursAccts;
        //Lorsqu’un nouveau participant rejoint la plateforme, il appelle la fonction inscription() qui lui donne une réputation de 1. Il
        function inscription(string memory nom) public {
            // on verifie si il est membre ou pas 
            require(!(illustrateurs[msg.sender].estMembre), "vous êtes déja inscrit");
            illustrateurs[msg.sender].reputation = 1;
            illustrateurs[msg.sender].nom = nom;
            illustrateurs[msg.sender].estMembre = true;
            illustrateursAccts.push(msg.sender);
        }
        function inscriptionDemandeur() external {
            require(!(demandeurs[msg.sender].estInscrit),"vous êtes déja inscrit");
            demandeurs[msg.sender].estInscrit = true;
        }
        
        enum EtatDemande { OUVERTE, ENCOURS, FERMEE } 
        struct Demande {
          Demandeur demandeur;
          uint remuneration ;       // (en wei)
          uint delai ;              //seconds
          string description;       //(champ texte)
          uint reputationMinumum;   //Définir une réputation minimum pour pouvoir postuler
          mapping (address => Illustrateur) candidats;
          //Illustrateur [] candidats;//Une liste de candidats
          EtatDemande etatDemande  ;//Définir une réputation minimum pour pouvoir postuler
        }
        Demande [] demandes;
        function ajouterDemande(uint _remuneration, uint _delai, string memory _description, uint _reputationMinumum) public payable{
            require(msg.value >= _remuneration + (_remuneration * 2/100));
            require(demandeurs[msg.sender].estInscrit,"inscrivez vous!");
            Demande memory demande;
            demande.remuneration = _remuneration;
            demande.delai = _delai;
            demande.description = _description;
            demande.reputationMinumum = _reputationMinumum;
            demandes.push(demande);
            balancesDemandeurs[msg.sender] = msg.value;
        }
        function postuler(Demande memory demande) public returns(bool success) {
            require((illustrateurs[msg.sender].estMembre), "inscrivez vous");
            
            
            
        }
        
    }