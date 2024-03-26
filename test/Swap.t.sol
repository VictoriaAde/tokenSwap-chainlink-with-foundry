// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TokenSwap} from "../src/TokenSwap.sol";
import "../src/interface/IERC20.sol";

contract SwapTest is Test {
    address ETH_USD_FEED = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address DAI_USD_FEED = 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19;

    address USDAddress = 0xf08A50178dfcDe18524640EA6618a1f965821715;
    address DAIAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address WETHAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    IERC20 USDInterface;
    IERC20 wethInterface;
    IERC20 daiInterface;

    TokenSwap public swapContractAddress;

    address whaleAddr = 0x40ec5B33f54e0E8A33A975908C5BA1c14e5BbbDf;

    // address USDCHolder = 0xf584f8728b874a6a5c7a8d4d387c9aae9172d621;

    function setUp() public {
        USDInterface = IERC20(USDAddress);
        wethInterface = IERC20(WETHAddress);
        daiInterface = IERC20(DAIAddress);

        swapContractAddress = new TokenSwap(
            WETHAddress,
            USDAddress,
            DAIAddress,
            DAI_USD_FEED,
            ETH_USD_FEED
        );

        vm.startPrank(whaleAddr);
    }

    uint256 amt = 1e18;

    function testSwapETHForUSD() public {
        uint256 initialBalance = wethInterface.balanceOf(msg.sender);
        console.log("initial ETH balance: ", initialBalance);

        require(initialBalance > 0, "Insufficient Weth balance");
        wethInterface.approve(address(swapContractAddress), amt);
        swapContractAddress.swapETHForUSD(amt);
        // wethInterface.approve(address(this), amt);
        // wethInterface.transferFrom(whaleAddr, address(this), amt);
    }

    function testSwapDAIForUSD() public {
        uint256 initialBalance = daiInterface.balanceOf(msg.sender);
        console.log("initial DAI balance: ", initialBalance);

        require(initialBalance > 0, "Insufficient DAI balance");
        daiInterface.approve(address(swapContractAddress), amt);
        swapContractAddress.swapDAIForUSD(amt);
        // wethInterface.approve(address(this), amt);
        // wethInterface.transferFrom(whaleAddr, address(this), amt);
    }
}
