async function main() {
	// address here is the location of the smart contract on the blockchain
	// abiArray is the instruction manual that functions the smart contract has
    const address = "0xd9145CCE52D386f254917e481eB44e9943F39138";
    const abiArray = [
	{
		"inputs": [],
		"name": "myUint",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "newUint",
				"type": "uint256"
			}
		],
		"name": "setMyUint",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
];
	// this will connect to the smart contract through it address and the Abi
    const contractInstance = new web3.eth.Contract(abiArray, address);

	// this read the data in the contract using the call()
    console.log(await contractInstance.methods.myUint().call());
	
	// this find your wallet to authorize chain
    let accounts = await web3.eth.getAccounts();
    
	// this change the data in the contract by updating the state using the send()
	let txtResult = await contractInstance.methods.setMyUint(36).send({from: accounts[0]});
    console.log(await contractInstance.methods.myUint().call());
    console.log(txtResult)

};


main()