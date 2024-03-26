// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/IERC20.sol";
import {AggregatorV3Interface} from "lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {FeedRegistryInterface} from "lib/chainlink/contracts/src/v0.8/interfaces/FeedRegistryInterface.sol";

/// @title TokenSwap
/// @notice A contract for swapping between ETH, LINK, and DAI using Chainlink price feeds
contract TokenSwap {
    // Define custom errors
    error InsufficientBalance();
    error SwapFailed();

    // Feed Registry instance
    FeedRegistryInterface private feedRegistry;

    // Token addresses
    address public immutable ETH_ADDRESS;
    address public immutable LINK_ADDRESS;
    address public immutable DAI_ADDRESS;

    /// @notice Constructor to initialize the contract with token addresses and the Chainlink Feed Registry address
    /// @param _ethAddress The address of the ETH token
    /// @param _linkAddress The address of the LINK token
    /// @param _daiAddress The address of the DAI token
    /// @param _feedRegistry The address of the Chainlink Feed Registry
    constructor(
        address _ethAddress,
        address _linkAddress,
        address _daiAddress,
        address _feedRegistry
    ) {
        ETH_ADDRESS = _ethAddress;
        LINK_ADDRESS = _linkAddress;
        DAI_ADDRESS = _daiAddress;
        feedRegistry = FeedRegistryInterface(_feedRegistry);
    }

    /// @notice Swap ETH for LINK
    /// @param amountIn The amount of ETH to swap
    function swapEthForLink(uint256 amountIn) external payable {
        require(msg.value == amountIn, "Incorrect ETH amount");
        uint256 amountOut = _getAmountOut(ETH_ADDRESS, LINK_ADDRESS, amountIn);
        IERC20(LINK_ADDRESS).transfer(msg.sender, amountOut);
    }

    /// @notice Swap ETH for DAI
    /// @param amountIn The amount of ETH to swap
    function swapEthForDai(uint256 amountIn) external payable {
        require(msg.value == amountIn, "Incorrect ETH amount");
        uint256 amountOut = _getAmountOut(ETH_ADDRESS, DAI_ADDRESS, amountIn);
        IERC20(DAI_ADDRESS).transfer(msg.sender, amountOut);
    }

    /// @notice Swap LINK for ETH
    /// @param amountIn The amount of LINK to swap
    function swapLinkForEth(uint256 amountIn) external {
        IERC20(LINK_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
        uint256 amountOut = _getAmountOut(LINK_ADDRESS, ETH_ADDRESS, amountIn);
        payable(msg.sender).transfer(amountOut);
    }

    /// @notice Swap LINK for DAI
    /// @param amountIn The amount of LINK to swap
    function swapLinkForDai(uint256 amountIn) external {
        IERC20(LINK_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
        uint256 amountOut = _getAmountOut(LINK_ADDRESS, DAI_ADDRESS, amountIn);
        IERC20(DAI_ADDRESS).transfer(msg.sender, amountOut);
    }

    /// @notice Swap DAI for ETH
    /// @param amountIn The amount of DAI to swap
    function swapDaiForEth(uint256 amountIn) external {
        IERC20(DAI_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
        uint256 amountOut = _getAmountOut(DAI_ADDRESS, ETH_ADDRESS, amountIn);
        payable(msg.sender).transfer(amountOut);
    }

    /// @notice Swap DAI for LINK
    /// @param amountIn The amount of DAI to swap
    function swapDaiForLink(uint256 amountIn) external {
        IERC20(DAI_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
        uint256 amountOut = _getAmountOut(DAI_ADDRESS, LINK_ADDRESS, amountIn);
        IERC20(LINK_ADDRESS).transfer(msg.sender, amountOut);
    }

    /// @notice Internal function to calculate the amount out for a swap
    /// @param base The base token address
    /// @param quote The quote token address
    /// @param amountIn The amount of the base token to swap
    /// @return The amount of the quote token to receive
    function _getAmountOut(
        address base,
        address quote,
        uint256 amountIn
    ) internal view returns (uint256) {
        (, int256 priceIn, , , ) = feedRegistry.latestRoundData(base, quote);
        require(priceIn > 0, "Price feed not available for base asset");
        return uint256(amountIn * uint256(priceIn));
    }
}

// address private constant FEED_REGISTRY =
// 0x47Fb2585D2C56Fe188D0E6ec628a38b74fCeeeDf;

// address private constant ETH_ADDRESS =
//     0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
// address private constant LINK_ADDRESS =
//     0x1400DD26d3772928e0F92B4189808a29eC9C6A6a;
// address private constant DAI_ADDRESS =
//     0x6B175474E89094C44Da98b954EedeAC495271d0F;
