// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TokenSwap} from "../src/TokenSwap.sol";
import "../src/interface/IERC20.sol";

contract SwapTest is Test {
    //0x514910771AF9Ca656af840dff83E8264EcF986CA Link mainnet
    //0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 eth mainnet
    // 0x6B175474E89094C44Da98b954EedeAC495271d0F dai mainnet
    // address WETHAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    // address DAIAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address feedregistry = 0x47Fb2585D2C56Fe188D0E6ec628a38b74fCeeeDf;

    address LINKAddress = 0x514910771AF9Ca656af840dff83E8264EcF986CA;
    address DAIAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address WETHAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    IERC20 linkInterface;
    IERC20 wethInterface;
    IERC20 daiInterface;

    TokenSwap public swapContractAddress;

    address whaleAddr = 0x40ec5B33f54e0E8A33A975908C5BA1c14e5BbbDf;
    // address whaleAddrHasDAI = 0x40ec5B33f54e0E8A33A975908C5BA1c14e5BbbDf;
    // address whaleAddrHasZeroLink = 0x40ec5B33f54e0E8A33A975908C5BA1c14e5BbbDf;
    // address USDCAddr = 0xf584f8728b874a6a5c7a8d4d387c9aae9172d621;
    // address USDCddrHasEth = 0xf584f8728b874a6a5c7a8d4d387c9aae9172d621;
    // address USDCaddrHasZeroLink = 0xf584f8728b874a6a5c7a8d4d387c9aae9172d621;

    // address USDCHolder = 0xf584f8728b874a6a5c7a8d4d387c9aae9172d621;

    function setUp() public {
        linkInterface = IERC20(LINKAddress);
        wethInterface = IERC20(WETHAddress);
        daiInterface = IERC20(DAIAddress);

        swapContractAddress = new TokenSwap(
            WETHAddress,
            LINKAddress,
            DAIAddress,
            feedregistry
        );

        vm.startPrank(whaleAddr);
    }
    uint256 amt = 1e18;

    function testSwapEthForLink() public {
        uint256 initialBalance = wethInterface.balanceOf(msg.sender);
        console.log("initial balance: ", initialBalance);

        require(initialBalance > 0, "Insufficient LINK balance");
        wethInterface.approve(address(swapContractAddress), amt);
        swapContractAddress.swapEthForLink(amt);
        // wethInterface.approve(address(this), amt);
        // wethInterface.transferFrom(whaleAddr, address(this), amt);
    }
}
