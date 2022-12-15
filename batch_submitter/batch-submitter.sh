#!/bin/sh

set -e

RETRIES=${RETRIES:-40}

echo 1
#if [[ ! -z "$URL" ]]; then
    # get the addrs from the URL provided
    ADDRESSES=$(curl --fail --show-error --silent --retry-connrefused --retry $RETRIES --retry-delay 5 $URL)
echo $ADDRESSES
    # set the env
    export CTC_ADDRESS=$(echo $ADDRESSES | jq -r '.CanonicalTransactionChain')
    export SCC_ADDRESS=$(echo $ADDRESSES | jq -r '.StateCommitmentChain')
#fi
echo 2

# waits for l2geth to be up
curl --fail \
    --show-error \
    --silent \
    --retry-connrefused \
    --retry $RETRIES \
    --retry-delay 1 \
    --output /dev/null \
    $L2_ETH_RPC
echo 3

# go
exec ./batch-submitter "$@"
