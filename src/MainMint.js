import { useState } from "react";
import { ethers, BigNumber } from 'ethers'; 
import tikiTrees from './TikiTrees.json';

//const { abi } = require ('./TikiTrees.json');
const tikiTreesAdress = "0x7a2112aF6a11628d6b3fA4AEb2f481Bf2B8dd82b";

const MainMint = ({ accounts, setAccounts }) => {
    const [mintAmount, setMintAmount] = useState(1);
    const isConnected = Boolean(accounts[0]);

    async function handleMint() {
        if (window.ethereum) {
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            const contract = new ethers.Contract(
                tikiTreesAdress,
                tikiTrees.abi,
                signer
            );
            try {
                const response = await contract.mint(BigNumber.from(mintAmount), {
                    value: ethers.utils.parseEther((0.005 * mintAmount).toString()),
                });
                console.log('response: ', response);
            } catch(err) {
                console.log("error", err)
            }
        }
    }

    const handleDecrement = () => {
        if (mintAmount <= 1) return;
        setMintAmount(mintAmount - 1);
    };

    const handleIncrement = () => {
        setMintAmount(mintAmount + 1);
    };

    return (
        <div>
            <h1>Mint Tiki Trees</h1>
            <p>Help us plant Mangroves</p>
            {isConnected ? (
                <div>
                    <div>
                        <button onClick={handleDecrement}>-</button>
                        <input type="number" value={mintAmount} />
                        <button onClick={handleIncrement}>+</button>
                    </div>
                    <button onClick={handleMint}>Mint Now</button>
                </div>
            ) : (
                <p>Please connect to mint</p>
            )}
        </div>
    );
};

export default MainMint;