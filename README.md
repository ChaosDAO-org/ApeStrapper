# ApeStrapper Version 2.0 [![Github Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![License: MIT][license-badge]][license]
## About

  TBD
## Usage

Here's a list of the most frequently needed commands.

### Build

Build the contracts:

```
forge build
```

### Clean

Delete the build artifacts and cache directories:

```
forge clean
```

### Compile

Compile the contracts:

```
forge build
```

### Deploy

Deploy to Anvil:

```
forge script script/Foo.s.sol:FooScript --fork-url http://localhost:8545 \
 --broadcast --private-key $PRIVATE_KEY
```

Instead of passing a private key you can use the following:
1. install geth
2. create a file `pk` with your priv key
3. `geth account import pk` (choose pw)
4. `geth account list`
5. set envvar ETH_KEYSTORE to new keystore path
6. `shred -n 10 pk`

Credit: https://twitter.com/devtooligan/status/1523716952421584899

For instructions on how to deploy to a testnet or mainnet, check out the [Solidity Scripting tutorial](https://book.getfoundry.sh/tutorials/solidity-scripting.html).

### Format

Format the contracts with Prettier:

```
yarn prettier
```

### Gas Usage

Get a gas report:

```
 forge test --gas-report
```

### Lint

Lint the contracts:

```
yarn lint
```

### Test

Run the tests:

```
forge test
```
### Slither

Install and run slither static-analysis:
```
pip3 install slither-analyzer # Suggest installing a pyenv and using py3.9
slither src/ApeStrapper.sol  --solc-remaps @openzeppelin/=lib/openzeppelin-contracts/
```

## Notes

1. Foundry piggybacks off [git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to manage dependencies. There's a [guide](https://book.getfoundry.sh/projects/dependencies.html) about how to work with dependencies in the book.
2. You don't have to create a `.env` file, but filling in the environment variables may be useful when debugging and testing against a mainnet fork.

## Features

This template builds upon the frameworks and libraries mentioned above, so for details about their specific features, please consult their respective documentations.

For example, for Foundry, you can refer to the [Foundry Book](https://book.getfoundry.sh/). You might be in particular interested in reading the [Writing Tests](https://book.getfoundry.sh/forge/writing-tests.html) guide.

### Sensible Defaults

This template comes with sensible default configurations in the following files:

```text
├── .commitlintrc.yml
├── .editorconfig
├── .gitignore
├── .prettierignore
├── .prettierrc.yml
├── .solhintignore
├── .solhint.json
├── .yarnrc.yml
├── foundry.toml
└── remappings.txt
```

### GitHub Actions

This template comes with GitHub Actions pre-configured. Your contracts will be linted and tested on every push and pull
request made to the `main` branch.

You can edit the CI script in [.github/workflows/ci.yml](./.github/workflows/ci.yml).

### Conventional Commits

This template enforces the [Conventional Commits](https://www.conventionalcommits.org/) standard for git commit messages.
This is a lightweight convention that creates an explicit commit history, which makes it easier to write automated
tools on top of.

### Git Hooks

This template uses [Husky](https://github.com/typicode/husky) to run automated checks on commit messages, and [Lint Staged](https://github.com/okonet/lint-staged) to automatically format the code with Prettier when making a git commit.

## Writing Tests

To write a new test contract, you start by importing [PRBTest](https://github.com/paulrberg/prb-test) and inherit from it in your test contract. PRBTest comes with a
pre-instantiated [cheatcodes](https://book.getfoundry.sh/cheatcodes/) environment accessible via the `vm` property. You can also use [console.log](https://book.getfoundry.sh/faq?highlight=console.log#how-do-i-use-consolelog), whose logs you can see in the terminal output by adding the `-vvvv` flag.

This template comes with an example test contract [Foo.t.sol](./test/Foo.t.sol).

## Acknowledgements
- [paulrberg](https://github.com/paulrberg/foundry-template)
## Related Efforts

- [abigger87/femplate](https://github.com/abigger87/femplate)
- [cleanunicorn/ethereum-smartcontract-template](https://github.com/cleanunicorn/ethereum-smartcontract-template)
- [foundry-rs/forge-template](https://github.com/foundry-rs/forge-template)
- [FrankieIsLost/forge-template](https://github.com/FrankieIsLost/forge-template)


[gha]: https://github.com/paulrberg/foundry-template/actions
[gha-badge]: https://github.com/paulrberg/foundry-template/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

A Foundry-based template for developing Solidity smart contracts, with sensible defaults.

## What's Inside

- [Forge](https://github.com/foundry-rs/foundry/blob/master/forge): compile, test, fuzz, debug and deploy smart contracts
- [PRBTest](https://github.com/paulrberg/prb-test): modern collection of testing assertions and logging utilities
- [Forge Std](https://github.com/foundry-rs/forge-std): collection of helpful contracts and cheatcodes for testing
- [Solhint](https://github.com/protofire/solhint): code linter
- [Prettier Plugin Solidity](https://github.com/prettier-solidity/prettier-plugin-solidity): code formatter

## License

[MIT](./LICENSE.md) 
