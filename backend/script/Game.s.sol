// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/Game.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockUSDC is ERC20 {
    constructor() ERC20("Mock USDC", "USDC") {
        _mint(msg.sender, 1000000 * 10**6); // Mint 1M USDC
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }
}

contract GameScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy Mock USDC
        MockUSDC usdc = new MockUSDC();

        // Deploy Game contract
        string memory baseURI = "https://api.example.com/nft";
        GameNFT game = new GameNFT(address(usdc), baseURI);

        // Add some initial configuration
        game.addAgent(vm.addr(deployerPrivateKey));
        
        // Approve USDC spending and deposit initial liquidity
        uint256 initialLiquidity = 10000 * 10**6; // 10,000 USDC
        usdc.approve(address(game), initialLiquidity);
        game.depositUSDC(initialLiquidity);

        vm.stopBroadcast();

        console.log("Game deployed at:", address(game));
        console.log("USDC deployed at:", address(usdc));
    }
}