
CHANNEL_NAME="$1"
DELAY="$2"
MAX_RETRY="$3"
VERBOSE="$4"
: ${CHANNEL_NAME:="mychannel"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="true"}

export FABRIC_CFG_PATH=${PWD}configtx

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}

createChannelGenesisBlock() {
	which configtxgen
	if [ "$?" -ne 0 ]; then
		fatalln "configtxgen tool not found."
	fi
	set -x
	configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/${CHANNEL_NAME}.block -channelID $CHANNEL_NAME
	res=$?
	{ set +x; } 2>/dev/null
  verifyResult $res "Failed to generate channel configuration transaction..."
}
echo "Generating channel genesis block '${CHANNEL_NAME}.block'"
createChannelGenesisBlock

#configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block
#configtxgen -profile TwoOrgsOrdererGenesis -channelID $CHANNEL_NAME -outputBlock ./channel-artifacts/${CHANNEL_NAME}.block
