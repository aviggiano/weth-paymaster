// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IPaymaster} from "@account-abstraction/contracts/interfaces/IPaymaster.sol";
import {UserOperation} from "@account-abstraction/contracts/interfaces/UserOperation.sol";
import {IEntryPoint} from "@account-abstraction/contracts/interfaces/IEntryPoint.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IWETH9} from "./interfaces/IWETH9.sol";

contract WETHPaymaster is ERC20, IWETH9, IPaymaster {
    IEntryPoint public immutable entryPoint;

    uint256 public constant COST_OF_POST = 15000;

    constructor(IEntryPoint _entryPoint) ERC20("WETHPaymaster", "WETHP") {
        entryPoint = _entryPoint;
    }

    function validatePaymasterUserOp(
        UserOperation calldata userOp,
        bytes32 /*userOpHash*/,
        uint256 requiredPreFund
    ) external view override returns (bytes memory context, uint256 deadline) {
        require(
            userOp.verificationGasLimit > COST_OF_POST,
            "TokenPaymaster: gas too low for postOp"
        );
        require(
            userOp.initCode.length == 0,
            "WETHPaymaster: UserOp not supported"
        );
        require(
            balanceOf(userOp.sender) >= requiredPreFund,
            "WETHPaymaster: no balance"
        );
        return (abi.encode(userOp.sender), 0);
    }

    function postOp(
        PostOpMode,
        bytes calldata context,
        uint256 actualGasCost
    ) external override {
        require(msg.sender == address(entryPoint));

        address sender = abi.decode(context, (address));
        uint256 charge = (actualGasCost + COST_OF_POST);
        _burn(sender, charge);
    }

    function addStake(uint32 unstakeDelaySec) external payable {
        entryPoint.addStake{value: msg.value}(unstakeDelaySec);
    }

    function getDeposit() public view returns (uint256) {
        return entryPoint.balanceOf(address(this));
    }

    function deposit() public payable {
        _mint(msg.sender, msg.value);
        entryPoint.depositTo{value: msg.value}(address(this));
    }

    function withdraw(uint256 amount) external {
        _burn(msg.sender, amount);
        entryPoint.withdrawTo(payable(msg.sender), amount);
    }

    fallback() external payable {
        deposit();
    }

    receive() external payable {
        deposit();
    }
}
