// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
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

contract GameTest is Test {
    GameNFT public game;
    MockUSDC public usdc;
    address public owner;
    address public player;
    address public agent;

    function setUp() public {
        owner = address(this);
        player = address(0x1);
        agent = address(0x2);
        
        usdc = new MockUSDC();
        game = new GameNFT(address(usdc), "https://api.example.com/nft/");
        
        // Fund player with USDC
        vm.startPrank(owner);
        usdc.transfer(player, 100 * 10**6); // Transfer 100 USDC to player
        vm.stopPrank();
    }

    function testInitialState() public {
        assertEq(game.name(), "GameNFT");
        assertEq(game.symbol(), "GNFT");
        assertEq(address(game.usdc()), address(usdc));
        assertEq(game.baseTokenURI(), "https://api.example.com/nft/");
    }

    function testAddAgent() public {
        game.addAgent(agent);
        assertTrue(game.isAgent(agent));
    }

    function testRemoveAgent() public {
        game.addAgent(agent);
        game.removeAgent(agent);
        assertFalse(game.isAgent(agent));
    }

    function testBuyNFT() public {
        vm.startPrank(player);
        usdc.approve(address(game), 10 * 10**6); // Approve 10 USDC
        game.buyNFT(1);
        vm.stopPrank();

        assertEq(game.balanceOf(player), 1);
        assertEq(game.totalSupply(), 1);
        assertEq(usdc.balanceOf(address(game)), 1 * 10**6); // 1 USDC
    }

    function testPlayGame() public {
        // First buy an NFT
        vm.startPrank(player);
        usdc.approve(address(game), 10 * 10**6);
        game.buyNFT(1);
        
        uint256 tokenId = game.tokenOfOwnerByIndex(player, 0);
        game.playGame(tokenId);
        vm.stopPrank();

        assertEq(game.balanceOf(player), 0);
        assertEq(game.totalSupply(), 0);
    }

    function testRewardFunctions() public {
        // Setup agent
        game.addAgent(agent);
        
        // Fund contract with USDC
        vm.startPrank(owner);
        usdc.approve(address(game), 1000 * 10**6);
        game.depositUSDC(1000 * 10**6);
        vm.stopPrank();

        vm.startPrank(agent);
        
        // Test reward1 (0.1x)
        uint256 initialBalance = usdc.balanceOf(agent);
        game.reward1(1);
        assertEq(usdc.balanceOf(agent) - initialBalance, 0.1 * 10**6);

        // Test reward2 (0.5x)
        initialBalance = usdc.balanceOf(agent);
        game.reward2(1);
        assertEq(usdc.balanceOf(agent) - initialBalance, 0.5 * 10**6);

        // Test reward3 (2x)
        initialBalance = usdc.balanceOf(agent);
        game.reward3(1);
        assertEq(usdc.balanceOf(agent) - initialBalance, 2 * 10**6);
        
        vm.stopPrank();
    }

    function testFailNonAgentReward() public {
        vm.startPrank(player);
        vm.expectRevert("Not an authorized agent");
        game.reward1(1);
        vm.stopPrank();
    }

    function testTokenURI() public {
        vm.startPrank(player);
        usdc.approve(address(game), 10 * 10**6);
        game.buyNFT(1);
        
        uint256 tokenId = game.tokenOfOwnerByIndex(player, 0);
        string memory expectedURI = string(abi.encodePacked("https://api.example.com/nft/", vm.toString(tokenId)));
        assertEq(game.tokenURI(tokenId), expectedURI);
        vm.stopPrank();
    }
}
