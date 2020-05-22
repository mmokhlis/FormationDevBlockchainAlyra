import React, { Component } from "react";
import MarketPlace from "./contracts/MarketPlace.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { indexDemande : 0, demandes: [], web3: null, accounts: null, contract: null };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = MarketPlaceContract.networks[networkId];
      const instance = new web3.eth.Contract(
        MarketPlaceContract.abi,
        deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance });
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };
loadData = async () => {
  const { accounts, contract } = this.state;

    // Stores a given values by default.
    await contract.methods.ajouterDemande(10, 3000, "Logo nouvelle gamme", 4).send({ from: accounts[0] });

    // Get the value from the contract to prove it worked.
    const response = await contract.methods.indexDemande.call();
    
    // Update state with the result.
    this.setState({ indexDemande: response });
    
    //For loop to retrieve each demande in an array of objects
    for(let i = 0; i <= this.state.indexDemande; i++) {
  
      const demande = await contract.methods.getDemandes().call();

      this.setState({demandes: [...this.state.demandes, {
        description: demande[i].description, 
        id:demande[i].id, 
        remuneration: demande[i].remuneration, 
        delais: demande[i].delais, 
        reputation: demande[i].reputation, 
        etat: demande[i].etat
        }]}
      )
      
    }
}
  // runExample = async () => {
  //   const { accounts, contract } = this.state;

  //   // Stores a given value, 5 by default.
  //   await contract.methods.set(5).send({ from: accounts[0] });

  //   // Get the value from the contract to prove it worked.
  //   const response = await contract.methods.get().call();

  //   // Update state with the result.
  //   this.setState({ storageValue: response });
  // };

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    const { demandes } = this.state;
    /*const createData = (description, id, remuneration, delais, reputation, etat) => {
      return { description, id, remuneration, delais, reputation, etat };
    }
    /*const {description, id, remuneration, delais, reputation, etat } = this.state.demandes[i];
    const rows = [
      for(let i = 0; i <= this.state.indexDemande; i++) {
        return createData(description, id, remuneration, delais, reputation, etat)
      } 
    ];*/
    
    return (
      <div className="App">
        <TableContainer component={Paper}>
      <Table aria-label="simple table">
        <TableHead>
          <TableRow>
            <TableCell>Description</TableCell>
            <TableCell align="right">ID</TableCell>
            <TableCell align="right">Rémunération</TableCell>
            <TableCell align="right">Délais</TableCell>
            <TableCell align="right">Réputation minimum</TableCell>
            <TableCell align="right">Etat de la demande</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {demandes.map((demande) => (
            <TableRow key={demande.description}>
              <TableCell component="th" scope="row">
                {demande.description}
              </TableCell>
              <TableCell align="right">{demande.id}</TableCell>
              <TableCell align="right">{demande.remuneration}</TableCell>
              <TableCell align="right">{demande.delais}</TableCell>
              <TableCell align="right">{demande.reputation}</TableCell>
              <TableCell align="right">{demande.etat}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>
      </div>
    );
  }
}
