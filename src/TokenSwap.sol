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
    address public immutable LINK_ADDRESS;
    // address public immutable DAI_ADDRESS;

    // Chainlink price feed proxies
    AggregatorV3Interface public immutable ETH_LINK_FEED;
    // AggregatorV3Interface public immutable ETH_DAI_FEED;
    AggregatorV3Interface public immutable LINK_ETH_FEED;
    // AggregatorV3Interface public immutable LINK_DAI_FEED;
    // AggregatorV3Interface public immutable DAI_ETH_FEED;
    // AggregatorV3Interface public immutable DAI_LINK_FEED;

    constructor(
        address _ethAddress,
        address _linkAddress,
        // address _daiAddress,
        address _ethLinkFeed,
        // address _ethDaiFeed,
        // address _linkDaiFeed,
        // address _daiEthFeed,
        // address _daiLinkFeed
        address _linkEthFeed
    ) {
        ETH_ADDRESS = _ethAddress;
        LINK_ADDRESS = _linkAddress;
        // DAI_ADDRESS = _daiAddress;
        ETH_LINK_FEED = AggregatorV3Interface(_ethLinkFeed);
        // ETH_DAI_FEED = AggregatorV3Interface(_ethDaiFeed);
        LINK_ETH_FEED = AggregatorV3Interface(_linkEthFeed);
        // LINK_DAI_FEED = AggregatorV3Interface(_linkDaiFeed);
        // DAI_ETH_FEED = AggregatorV3Interface(_daiEthFeed);
        // DAI_LINK_FEED = AggregatorV3Interface(_daiLinkFeed);
    }

    /// @notice Swap ETH for LINK
    /// @param amountIn The amount of ETH to swap
    function swapEthForLink(uint256 amountIn) external payable {
        require(msg.value == amountIn, "Incorrect ETH amount");
        uint256 amountOut = _getAmountOut(ETH_LINK_FEED, amountIn);
        IERC20(LINK_ADDRESS).transfer(msg.sender, amountOut);
    }

    /// @notice Swap ETH for DAI
    /// @param amountIn The amount of ETH to swap
    // function swapEthForDai(uint256 amountIn) external payable {
    //     require(msg.value == amountIn, "Incorrect ETH amount");
    //     uint256 amountOut = _getAmountOut(ETH_DAI_FEED, amountIn);
    //     IERC20(DAI_ADDRESS).transfer(msg.sender, amountOut);
    // }

    /// @notice Swap LINK for ETH
    /// @param amountIn The amount of LINK to swap
    function swapLinkForEth(uint256 amountIn) external {
        IERC20(LINK_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
        uint256 amountOut = _getAmountOut(LINK_ETH_FEED, amountIn);
        IERC20(ETH_ADDRESS).transfer(msg.sender, amountOut);
    }

    /// @notice Swap LINK for DAI
    /// @param amountIn The amount of LINK to swap
    // function swapLinkForDai(uint256 amountIn) external {
    //     IERC20(LINK_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
    //     uint256 amountOut = _getAmountOut(LINK_DAI_FEED, amountIn);
    //     IERC20(DAI_ADDRESS).transfer(msg.sender, amountOut);
    // }

    /// @notice Swap DAI for ETH
    /// @param amountIn The amount of DAI to swap
    // function swapDaiForEth(uint256 amountIn) external {
    //     IERC20(DAI_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
    //     uint256 amountOut = _getAmountOut(DAI_ETH_FEED, amountIn);
    //     IERC20(ETH_ADDRESS).transfer(msg.sender, amountOut);
    // }

    /// @notice Swap DAI for LINK
    /// @param amountIn The amount of DAI to swap
    // function swapDaiForLink(uint256 amountIn) external {
    //     IERC20(DAI_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
    //     uint256 amountOut = _getAmountOut(DAI_LINK_FEED, amountIn);
    //     IERC20(LINK_ADDRESS).transfer(msg.sender, amountOut);
    // }

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

// pragma solidity ^0.8.0;

// import "./interface/IERC20.sol";
// import {AggregatorV3Interface} from "lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
// import {FeedRegistryInterface} from "lib/chainlink/contracts/src/v0.8/interfaces/FeedRegistryInterface.sol";

// /// @title TokenSwap
// /// @notice A contract for swapping between ETH, LINK, and DAI using Chainlink price feeds
// contract TokenSwap {
//     // Define custom errors
//     error InsufficientBalance();
//     error SwapFailed();

//     // Feed Registry instance
//     FeedRegistryInterface private feedRegistry;

//     // Token addresses
//     address public immutable ETH_ADDRESS;
//     address public immutable LINK_ADDRESS;
//     address public immutable DAI_ADDRESS;

//     /// @notice Constructor to initialize the contract with token addresses and the Chainlink Feed Registry address
//     /// @param _ethAddress The address of the ETH token
//     /// @param _linkAddress The address of the LINK token
//     /// @param _daiAddress The address of the DAI token
//     /// @param _feedRegistry The address of the Chainlink Feed Registry
//     constructor(
//         address _ethAddress,
//         address _linkAddress,
//         address _daiAddress,
//         address _feedRegistry
//     ) {
//         ETH_ADDRESS = _ethAddress;
//         LINK_ADDRESS = _linkAddress;
//         DAI_ADDRESS = _daiAddress;
//         feedRegistry = FeedRegistryInterface(_feedRegistry);
//     }

//     /// @notice Swap ETH for LINK
//     /// @param amountIn The amount of ETH to swap
//     function swapEthForLink(uint256 amountIn) external {
//         IERC20(ETH_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
//         uint256 amountOut = _getAmountOut(ETH_ADDRESS, LINK_ADDRESS, amountIn);
//         IERC20(LINK_ADDRESS).transfer(msg.sender, amountOut);
//     }

//     /// @notice Swap ETH for DAI
//     /// @param amountIn The amount of ETH to swap
//     function swapEthForDai(uint256 amountIn) external {
//         IERC20(ETH_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
//         uint256 amountOut = _getAmountOut(ETH_ADDRESS, DAI_ADDRESS, amountIn);
//         IERC20(DAI_ADDRESS).transfer(msg.sender, amountOut);
//     }

//     /// @notice Swap LINK for ETH
//     /// @param amountIn The amount of LINK to swap
//     function swapLinkForEth(uint256 amountIn) external {
//         IERC20(LINK_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
//         uint256 amountOut = _getAmountOut(LINK_ADDRESS, ETH_ADDRESS, amountIn);
//         IERC20(ETH_ADDRESS).transfer(msg.sender, amountOut);
//     }

//     /// @notice Swap LINK for DAI
//     /// @param amountIn The amount of LINK to swap
//     function swapLinkForDai(uint256 amountIn) external {
//         IERC20(LINK_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
//         uint256 amountOut = _getAmountOut(LINK_ADDRESS, DAI_ADDRESS, amountIn);
//         IERC20(DAI_ADDRESS).transfer(msg.sender, amountOut);
//     }

//     /// @notice Swap DAI for ETH
//     /// @param amountIn The amount of DAI to swap
//     function swapDaiForEth(uint256 amountIn) external {
//         IERC20(DAI_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
//         uint256 amountOut = _getAmountOut(DAI_ADDRESS, ETH_ADDRESS, amountIn);
//         IERC20(ETH_ADDRESS).transfer(msg.sender, amountOut);
//     }

//     /// @notice Swap DAI for LINK
//     /// @param amountIn The amount of DAI to swap
//     function swapDaiForLink(uint256 amountIn) external {
//         IERC20(DAI_ADDRESS).transferFrom(msg.sender, address(this), amountIn);
//         uint256 amountOut = _getAmountOut(DAI_ADDRESS, LINK_ADDRESS, amountIn);
//         IERC20(LINK_ADDRESS).transfer(msg.sender, amountOut);
//     }

//     /// @notice Internal function to calculate the amount out for a swap
//     /// @param base The base token address
//     /// @param quote The quote token address
//     /// @param amountIn The amount of the base token to swap
//     /// @return The amount of the quote token to receive
//     function _getAmountOut(
//         address base,
//         address quote,
//         uint256 amountIn
//     ) internal view returns (uint256) {
//         (, int256 priceIn, , , ) = feedRegistry.latestRoundData(base, quote);
//         require(priceIn > 0, "Price feed not available for base asset");
//         return uint256(amountIn * uint256(priceIn));
//     }
// }

// //0x779877A7B0D9E8603169DdbD7836e478b4624789 Link sepolia
// //0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9 eth sepolia
// // 0x68194a729C2450ad26072b3D33ADaCbcef39D574 dai sepolia
// // 0x47Fb2585D2C56Fe188D0E6ec628a38b74fCeeeDf feed registry
