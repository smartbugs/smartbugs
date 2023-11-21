The docker container created by these files bundles the version of eThor used for the experiments published in CCS with some minor patches applied:

## Changes
* support for EXTCODEHASH
* control flow reconstruction does not crash on the superfluous ANDs introduced by some versions of Solidity
* update souffle version (the last version SEGFAULTed on some inputs)

## Build

```
NIXPKGS_ALLOW_INSECURE=1 nix build --impure .
```

The `NIXPKGS_ALLOW_INSECURE=1` environment variable is needed, since the bundled version of z3 has `python2` as build dependency, which is marked insecure in nixpkgs.

(if you know how to use docker but don't have nix installed, the easiest way _might be_ to get a NixOS docker image and call `nix build` within)

After `nix build` returns, there should be a file `result` which is the image. 

Load it with

```
docker load -i result
Loaded image: ethor:ddj39dq9p5x7a3fskva810lzq5sdmv90 # the id might be different
```

## Run

You can run the eThor tool (as described by `--help`) with

```
docker run --rm -ti -v $PWD:/mnt/ ethor:ddj39dq9p5x7a3fskva810lzq5sdmv90 ethor
```

The cfg-reconstruction tool (with a simplified interface) is also contained in the image.

This call takes a contract, given as hex-encoding of it's bytecode `contract.hex` and outputs
a file `contract.json` which contains the reconstructed jump destinations.

```
docker run --rm -ti -v $PWD:/mnt/ ethor:ddj39dq9p5x7a3fskva810lzq5sdmv90 run-reconstruct contract.hex contract.json
```

Finally, there is also a tool that combines the two former tools. 

This tool has a slightly different interface than eThor. The first argument is
a single contract in hex encoding, the following parameters are passed to eThor.
The following parameters may not be passed: `--smt-out-dir`
`--no-output-query-result` (both are implied).

What the tool does is: reconstruct the control flow for the given contract,
generate a smt-file for it and then run z3 (parallely) on these file for each
query.

If one query return "sat", the contract is labelled insecure, otherwise if one
query returns or times out, the contract is labelled unknown, otherwise the
contract is labelled safe.

If the environment variable `Z3_TIMEOUT` is set (via docker) `z3` will be
aborted after the given time runs out.

If the `EARLY_EXIT_ON_SAT` is set to `YES`, the experiment will be aborted
after the first query is satisfied (as the contract will be labelled insecure
in any case).

```
# execute all queries
docker run --rm -ti -v $PWD:/mnt/ ethor:yqcrsvbdzhcjc8mnssfjl7fal1gx1wwp ethor-with-reconstruction 0x015a06a433353f8db634df4eddf0c109882a15ab.hex --prune-strategy=aggressive --predicate-inlining-strategy=linear --preanalysis

# abort on first sat and abort z3 after 30 seconds
docker run --rm -ti -v $PWD:/mnt/ -e TIMEOUT=30s -e EARLY_EXIT_ON_SAT=YES ethor:yqcrsvbdzhcjc8mnssfjl7fal1gx1wwp ethor-with-reconstruction 0x015a06a433353f8db634df4eddf0c109882a15ab.hex --prune-strategy=aggressive --predicate-inlining-strategy=linear --preanalysis
```
