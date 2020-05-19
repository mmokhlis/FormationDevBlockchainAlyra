    pragma solidity ^0.6.3;
    pragma experimental ABIEncoderV2;
    
    //import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
    
    contract Defi2 {
        
        //mapping(address => uint) private balancesDemandeurs;
        
        //Mécanisme de réputation
        uint private indexDemande;
        struct Illustrateur {
            address adresseIllustrateur;
            uint reputation; //Pour représenter la réputation, nous allons associer chaque utilisateur à une valeur entière
            string nom ;//Un nom est aussi associé à l’adresse
            bool estMembre; // si il est membre ou pas
        }
        mapping (address => Illustrateur) illustrateurs;
        address[] public illustrateursAccts;
        
        modifier illustrateurInscrit{
            require(illustrateurs[msg.sender].estMembre, "inscrivez vous");
            _;
        }
        
        struct Demandeur {
            address adresseDemandeur;
            bool estInscrit;
        }
        mapping (address => Demandeur) demandeurs;
        address[] public demandeursAccts;
        modifier demandeurInscrit{
            require(demandeurs[msg.sender].estInscrit, "inscrivez vous");
            _;
        }
        //Lorsqu’un nouveau participant rejoint la plateforme, il appelle la fonction inscription() qui lui donne une réputation de 1. Il
        function inscription(string memory nom) public {
            // on verifie si il est membre ou pas 
            require(!(illustrateurs[msg.sender].estMembre), "vous êtes déja inscrit");
            illustrateurs[msg.sender].adresseIllustrateur = msg.sender;
            illustrateurs[msg.sender].reputation = 1;
            illustrateurs[msg.sender].nom = nom;
            illustrateurs[msg.sender].estMembre = true;
            illustrateursAccts.push(msg.sender);
        }
        function inscriptionDemandeur() external {
            require(!(demandeurs[msg.sender].estInscrit),"vous êtes déja inscrit");
            demandeurs[msg.sender].adresseDemandeur = msg.sender;
            demandeurs[msg.sender].estInscrit = true;
        }
        
        enum EtatDemande { OUVERTE, ENCOURS, FERMEE } 
        
        struct Demande {
          Demandeur demandeur;
          uint id; // id de la demande
          uint remuneration ;       // (en wei)
          uint delai ;              //seconds
          string description;       //(champ texte)
          uint reputationMinumum;   //Définir une réputation minimum pour pouvoir postuler
          Illustrateur candidatChoisi;
          bytes32 hashLienLivraison;
          mapping (address => Illustrateur) candidats;
          EtatDemande etatDemande  ;//Définir une réputation minimum pour pouvoir postuler
        }
        
        Demande [] demandes;
        
        function ajouterDemande(uint _remuneration, uint _delai, string memory _description, uint _reputationMinumum) public payable demandeurInscrit{
            require(msg.value >= _remuneration + (_remuneration * 2/100));
            indexDemande++;
            Demande memory demande;
            demande.id = indexDemande;
            demande.remuneration = _remuneration;
            demande.delai = _delai;
            demande.description = _description;
            demande.reputationMinumum = _reputationMinumum;
            demande.etatDemande = EtatDemande.OUVERTE;
            demandes[indexDemande-1]= demande;
            
        }
        ///----------------Mécanisme de contractualisation
    //Créer une fonction postuler() qui permet à un indépendant de proposer ses services. 
    //Il est alors ajouté à la liste des candidats.
    function postuler(uint idDemande) public illustrateurInscrit {
        require(illustrateurs[msg.sender].reputation >= demandes[idDemande-1].reputationMinumum, 
        "vous n'avez pas la réputation qu'il faut");
        Illustrateur memory candidat;
        candidat = illustrateurs[msg.sender];
        demandes[idDemande-1].candidats[msg.sender] = candidat;
    }

    //Créer une fonction accepterOffre() qui permet à l’entreprise d’accepter un illustrateur. 
    //La demande est alors ENCOURS jusqu’à sa remise
    //enum EtatDemande { OUVERTE, ENCOURS, FERMEE } 
    //EtatDemande etatDemande  ;
    function accepterOffre(uint idDemande, address addressCandidat ) public demandeurInscrit {
        require(demandes[idDemande-1].demandeur.adresseDemandeur == msg.sender,
        "vous n etes pas owner de cette demande");
        require(illustrateurs[addressCandidat].adresseIllustrateur == demandes[idDemande-1].candidats[addressCandidat].adresseIllustrateur,
        "illustrateur ne figure pas dans les candidats de cette demande");
        demandes[idDemande-1].candidatChoisi = illustrateurs[addressCandidat];
        demandes[idDemande-1].etatDemande = EtatDemande.ENCOURS;
    }

    //Ecrire une fonction livraison() qui permet à l’illustrateur de remettre le hash du lien où se trouve son travail. 
    //Les fonds sont alors automatiquement débloqués et peuvent être retirés par l’illustrateur. 
    //L’illustrateur gagne aussi un point de réputation
    function livraison(uint idDemande,string memory lienLivraison) public illustrateurInscrit {
        require(illustrateurs[msg.sender].adresseIllustrateur == demandes[idDemande-1].candidatChoisi.adresseIllustrateur,
        "vous n'etes pas le candidat choisi pour cette demande");
        bytes32 hashLienLivraison = keccak256(bytes(lienLivraison));
        demandes[idDemande-1].hashLienLivraison = hashLienLivraison;
        demandes[idDemande-1].etatDemande = EtatDemande.FERMEE;
        illustrateurs[msg.sender].reputation ++;
        
        msg.sender.transfer(demandes[idDemande-1].remuneration);
    }

        
    }