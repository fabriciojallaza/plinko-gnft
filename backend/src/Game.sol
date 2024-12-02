// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GameNFT is ERC721Enumerable, Ownable {
    IERC20 public usdc;
    string public baseTokenURI;
    address[] public agents;

    uint256 public constant NFT_PRICE = 1 * 10**6; // 1 USDC (6 decimales)

    mapping(address => bool) public isAgent;

    constructor(
        address _usdc,
        string memory _baseTokenURI
    ) ERC721("GameNFT", "GNFT") Ownable(msg.sender) {
        usdc = IERC20(_usdc);
        baseTokenURI = _baseTokenURI;
    }

    modifier onlyAgent() {
        require(isAgent[msg.sender], "Not an authorized agent");
        _;
    }

    // Set base URI for NFT metadata
    function setBaseTokenURI(string memory _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    // Add agent
    function addAgent(address _agent) external onlyOwner {
        isAgent[_agent] = true;
        agents.push(_agent);
    }

    // Remove agent
    function removeAgent(address _agent) external onlyOwner {
        isAgent[_agent] = false;
    }

    // Buy NFTs
    function buyNFT(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        uint256 totalPrice = _amount * NFT_PRICE;
        require(usdc.transferFrom(msg.sender, address(this), totalPrice), "USDC transfer failed");

        for (uint256 i = 0; i < _amount; i++) {
            uint256 tokenId = totalSupply() + 1;
            _mint(msg.sender, tokenId);
        }
    }

    // Burn NFT to play the game
    function playGame(uint256 _tokenId) external {
        require(ownerOf(_tokenId) == msg.sender, "Not the NFT owner");
        _burn(_tokenId);
    }

    // Reward function 1: 0.1x per NFT
    function reward1(uint256 _amount) external onlyAgent {
        uint256 reward = (_amount * 10**5); // 0.1 USDC per NFT
        require(usdc.balanceOf(address(this)) >= reward, "Insufficient USDC in contract");
        require(usdc.transfer(msg.sender, reward), "USDC transfer failed");
    }

    // Reward function 2: 0.5x per NFT
    function reward2(uint256 _amount) external onlyAgent {
        uint256 reward = (_amount * 5 * 10**5); // 0.5 USDC per NFT
        require(usdc.balanceOf(address(this)) >= reward, "Insufficient USDC in contract");
        require(usdc.transfer(msg.sender, reward), "USDC transfer failed");
    }

    // Reward function 3: 2x per NFT
    function reward3(uint256 _amount) external onlyAgent {
        uint256 reward = (_amount * 2 * 10**6); // 2 USDC per NFT
        require(usdc.balanceOf(address(this)) >= reward, "Insufficient USDC in contract");
        require(usdc.transfer(msg.sender, reward), "USDC transfer failed");
    }

    // Deposit USDC into the contract
    function depositUSDC(uint256 _amount) external onlyOwner {
        require(usdc.transferFrom(msg.sender, address(this), _amount), "USDC transfer failed");
    }

    // Redeem USDC from the contract
    function redeemUSDC(uint256 _amount) external onlyOwner {
        require(usdc.balanceOf(address(this)) >= _amount, "Insufficient USDC in contract");
        require(usdc.transfer(msg.sender, _amount), "USDC transfer failed");
    }

    // Override tokenURI to use Whalepass
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return string.concat(baseTokenURI, Strings.toString(tokenId));
    }
}
