// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
// A simple token sale contract where users can buy ERC20 tokens by sending ETH.

// Key Components
// IERC20 Interface
// Defines transfer() (to send tokens) and decimals() (to handle token precision).
// Used to interact with an external ERC20 token contract.

// State Variables
// tokenPriceInWei: Price per token (default: 1 ETH).
// token: Address of the ERC20 token being sold.

// Constructor
// Takes the address of an ERC20 token (_token) and stores it.
// purchase() Function

// Requires user sends ≥ tokenPriceInWei.
// Calculates:
// tokensToTransfer = msg.value / tokenPriceInWei (how many tokens to send).
// remainder = msg.value % tokenPriceInWei (leftover ETH to refund).
// Transfers tokens to buyer (scaled by decimals() for precision).
// Refunds excess ETH (if any).

// Key Mechanics
// ETH → Tokens: Users send ETH, receive tokens at a fixed rate.
// Precision Handling: Uses decimals() to avoid floating-point issues (e.g., 18 decimals for most ERC20s).

// Refunds: Returns excess ETH if msg.value isn’t a multiple of tokenPriceInWei.
// Potential Issues (if not fixed)
// No approve/transferFrom: Assumes the TokenSale contract already holds the tokens (or is the owner).
// No reentrancy protection: Uses transfer() (safe), but consider SafeERC20 for robustness.
// No access control: Anyone can call purchase() (may need onlyOwner for admin functions).

// Gas Optimizations (if requested)
// Cache token.decimals() in a variable to avoid repeated calls.
// Use msg.value / tokenPriceInWei only once (store in memory).


interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function decimals() external view returns (uint8);
}

contract TokenSale {
    uint256 public tokenPriceInWei = 1 ether;
    IERC20 public token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function purchase() public payable {
        require(msg.value >= tokenPriceInWei, "Not enough money sent");
        uint256 tokensToTransfer = msg.value / tokenPriceInWei;
        uint256 remainder = msg.value % tokenPriceInWei; // More gas-efficient
        require(
            token.transfer(
                msg.sender,
                tokensToTransfer * (10 ** token.decimals())
            ),
            "Transfer failed"
        );
        payable(msg.sender).transfer(remainder);
    }
}