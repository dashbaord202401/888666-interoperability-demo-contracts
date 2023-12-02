#!/bin/bash
source .env
forge build

# Check if no arguments are provided
if [ "$#" -eq 0 ]; then
    echo "Error: Either 'full-deploy' or '--network' followed by a network name is required."
    exit 1
fi

# Check for 'full-deploy'
if [ "$1" == "full-deploy" ]; then
    if [ "$#" -gt 1 ]; then
        echo "Error: 'full-deploy' cannot be used with other arguments."
        exit 1
    fi
    # Perform the full-deploy actions here
    echo "Performing full deploy..."
    forge script script/deployFaucets.s.sol:Deploy --broadcast --rpc-url $MUMBAI_RPC
    #forge script script/deployFaucets.s.sol:Deploy --broadcast --rpc-url $SEPOLIA_RPC
    
    exit 0
fi

# Check for '--network'
if [ "$1" == "--network" ]; then
    if [ "$#" -lt 2 ]; then
        echo "Error: '--network' requires a network name (e.g., mainnet, goerli, etc.)."
        exit 1
    fi
    # Use the network specified in $2
    NETWORK="$2"
    echo "Deploying to network: $NETWORK"
    forge script script/deployFaucets.s.sol:Deploy --broadcast --rpc-url $NETWORK
    exit 0
fi

echo "Error: Invalid arguments."
exit 1
