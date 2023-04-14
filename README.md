# weth-paymaster

This repository is a sample implementation of `WETHPaymaster`, a trustless Paymaster built on top of ERC-4337: Account Abstraction Using Alt Mempool.

## Features

- Just like with Wrapped Ether, 1 `ETH` is always equal to 1 `WETHP`, deposited/withdrawn without relying in any oracles
- Unlike Wrapped Ether, you can pay for your AA User Operations
- Unlike the default Paymaster implementations, completely trustless

## Motivations

The default `BasePaymaster`, `VerifyingPaymaster` and `TokenPaymaster` implementations all assume a trusted `owner`, which can impose security issues for users. In addition, using a ERC-20 tokens to pay for transactions, such as USDC, also introduces a security risks related to price oracles, liquidity conditions, and speed of operational controls in case of extreme events.

`WETHPaymaster` aims to eliminate this reliance on a trusted parties by providing a secure solution for ERC-4337 accounts.

## How to use

1. deposit `ETH` and mint `WETHP`
2. transfer `WETHP` to your ERC-4337 account
3. use `WETHP` to pay for your UserOperations

## Considerations

- There is no `owner` associated with `WETHPaymaster`. As a result, it is necessary to first `addStake` to the `EntryPoint` so that the Paymaster can be accepted in the system as per the EIP-4337 requirements. This stake will be permanently locked in the `EntryPoint`, as there is no mechanism to differentiate between users who staked from the EntryPoint's perspective.
- `WETHPaymaster` does not support first-time account creation since it does not assume any trusted factory contract.

## Contribute

Please contribute to WETHP before we deploy it to all networks and distribute it as a public good to the Ethereum ecosystem.
