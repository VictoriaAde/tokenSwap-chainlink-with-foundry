// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/IERC20.sol";
import {AggregatorV3Interface} from "lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/// @title TokenSwap
/// @notice A contract for swapping between ETH, LINK, and DAI using Chainlink price feeds
contract TokenSwap {
    // Define custom errors
    error InsufficientBalance();
    error SwapFailed();

    // Token addresses
    address public immutable ETH_ADDRESS;
    address public immutable USD_ADDRESS;
    address public immutable DAI_ADDRESS;

    // Chainlink price feed proxies
    AggregatorV3Interface public immutable DAI_USD_FEED;
    AggregatorV3Interface public immutable ETH_USD_FEED;

    constructor(
        address _ethAddress,
        address _daiAddress,
        address _usdAddress,
        address _daiusdFeed,
        address _ethusdFeed
    ) {
        ETH_ADDRESS = _ethAddress;
        DAI_ADDRESS = _daiAddress;
        USD_ADDRESS = _usdAddress;
        DAI_USD_FEED = AggregatorV3Interface(_daiusdFeed);
        ETH_USD_FEED = AggregatorV3Interface(_ethusdFeed);
    }

    /// @notice Swap ETH for LINK
    /// @param amountIn The amount of ETH to swap
    function swapETHForUSD(uint256 amountIn) external payable {
        require(msg.value == amountIn, "Incorrect ETH amount");
        uint256 amountOut = _getAmountOut(ETH_USD_FEED, amountIn);
        IERC20(ETH_ADDRESS).transfer(msg.sender, amountOut);
    }

    /// @notice Swap LINK for ETH
    /// @param amountIn The amount of LINK to swap
    function swapDAIForUSD(uint256 amountIn) external {
        IERC20(DAI_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
        uint256 amountOut = _getAmountOut(DAI_USD_FEED, amountIn);
        IERC20(USD_ADDRESS).transfer(msg.sender, amountOut);
    }

    /// @notice Internal function to calculate the amount out for a swap
    /// @param feed The Chainlink price feed proxy to use for the swap
    /// @param amountIn The amount of the base token to swap
    /// @return The amount of the quote token to receive
    function _getAmountOut(
        AggregatorV3Interface feed,
        uint256 amountIn
    ) internal view returns (uint256) {
        (, int256 priceIn, , , ) = feed.latestRoundData();
        require(priceIn > 0, "Price feed not available for base asset");
        return uint256(amountIn * uint256(priceIn));
    }
}
