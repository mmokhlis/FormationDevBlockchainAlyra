    pragma solidity ^0.6.3;

    //pragma experimental ABIEncoderV2;

    

    contract MarketPlace {

        

        enum EtatDemande { OUVERTE, ENCOURS, FERMEE }

        

         struct Illustrateur {

            address adresseIllustrateur;

            uint reputation; //Pour représenter la réputation, nous allons associer chaque utilisateur à une valeur entière

            string nom ;//Un nom est aussi associé à l’adresse

            bool estMembre; // si il est membre ou pas

        }

        

        struct Demandeur {

            address adresseDemandeur;

            bool estInscrit;

        }

        

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

        

        mapping (address => Illustrateur) illustrateurs;

        address[] public illustrateursAccts;

        mapping (address => Demandeur) demandeurs;

        address[] public demandeursAccts;

        uint public indexDemande;

        Demande[] demandes;

        

        event DeposerRemuneration(address indexed _from,address indexed _to,uint _value );

        event PayerRemuneration(address indexed _to,address indexed _from,uint _value );

        

        modifier illustrateurInscrit(address addressIllustrateur){

            require(illustrateurs[addressIllustrateur].estMembre, "inscrivez vous");

            _;

        }


        modifier demandeurInscrit(address addressDemandeur){

            require(demandeurs[addressDemandeur].estInscrit, "inscrivez vous");

            _;

        }

        //Lorsqu’un nouveau participant rejoint la plateforme, il appelle la fonction inscription() qui lui donne une réputation de 1. Il

        function inscription(string calldata nom) external {

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

            demandeursAccts.push(msg.sender);

        }

        

        

        function ajouterDemande(uint _remuneration, uint _delai, string calldata _description, uint _reputationMinumum) 

        external payable demandeurInscrit(msg.sender){

            uint frais = _remuneration * 2/100;

            require(msg.value >= _remuneration + frais);
            
            Demande memory demande;

            demande.id = indexDemande;

            demande.remuneration = _remuneration;

            demande.delai = _delai;

            demande.description = _description;

            demande.reputationMinumum = _reputationMinumum;

            demande.etatDemande = EtatDemande.OUVERTE;

            demandes[indexDemande]= demande;
            
            indexDemande++;
            
            emit DeposerRemuneration(msg.sender,address(this), msg.value);

        }
       
        function getDemandes(uint _indexDemande) public view returns (uint, uint, uint, string memory, uint, EtatDemande){
            
            return(demandes[_indexDemande].id,demandes[indexDemande].remuneration,demandes[indexDemande].delai,
            demandes[indexDemande].description,demandes[indexDemande].reputationMinumum,demandes[indexDemande].etatDemande);    
        }
        
       
        ///----------------Mécanisme de contractualisation

    //Créer une fonction postuler() qui permet à un indépendant de proposer ses services. 

    //Il est alors ajouté à la liste des candidats.

    function postuler(uint idDemande) external illustrateurInscrit(msg.sender) {

        require(illustrateurs[msg.sender].reputation >= demandes[idDemande].reputationMinumum, 

        "vous n'avez pas la réputation qu'il faut");

        Illustrateur memory candidat;

        candidat = illustrateurs[msg.sender];

        demandes[idDemande].candidats[msg.sender] = candidat;

    }



    //Créer une fonction accepterOffre() qui permet à l’entreprise d’accepter un illustrateur. 

    //La demande est alors ENCOURS jusqu’à sa remise

    //enum EtatDemande { OUVERTE, ENCOURS, FERMEE } 

    //EtatDemande etatDemande  ;

    function accepterOffre(uint idDemande, address addressCandidat ) 

        external demandeurInscrit(msg.sender) illustrateurInscrit(addressCandidat) {

        require(demandes[idDemande].demandeur.adresseDemandeur == msg.sender,

        "vous n etes pas owner de cette demande");

        require(illustrateurs[addressCandidat].adresseIllustrateur == demandes[idDemande].candidats[addressCandidat].adresseIllustrateur,

        "illustrateur ne figure pas dans les candidats de cette demande");

        demandes[idDemande].candidatChoisi = illustrateurs[addressCandidat];

        demandes[idDemande].etatDemande = EtatDemande.ENCOURS;

    }



    //Ecrire une fonction livraison() qui permet à l’illustrateur de remettre le hash du lien où se trouve son travail. 

    //Les fonds sont alors automatiquement débloqués et peuvent être retirés par l’illustrateur. 

    //L’illustrateur gagne aussi un point de réputation

    function livraison(uint idDemande,string calldata lienLivraison) external payable illustrateurInscrit(msg.sender) {

        require(illustrateurs[msg.sender].adresseIllustrateur == demandes[idDemande].candidatChoisi.adresseIllustrateur,

        "vous n'etes pas le candidat choisi pour cette demande");

        bytes32 hashLienLivraison = keccak256(bytes(lienLivraison));

        demandes[idDemande].hashLienLivraison = hashLienLivraison;

        demandes[idDemande].etatDemande = EtatDemande.FERMEE;

        illustrateurs[msg.sender].reputation ++;

        

        msg.sender.transfer(demandes[idDemande].remuneration);

        emit PayerRemuneration(illustrateurs[msg.sender].adresseIllustrateur, msg.sender, demandes[idDemande-1].remuneration);

    }



    }