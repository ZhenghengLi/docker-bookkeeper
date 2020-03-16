#!/bin/bash

# Generate the config only if it doesn't exist
if [[ ! -f "$BOOKIE_CONF" ]]; then
    {
        echo "journalDirectories=$BOOKIE_JOURNAL_DIR"
        echo "ledgerDirectories=$BOOKIE_LEDGER_DIR"
        echo "zkServers=$ZK_SERVERS"
        echo "metadataServiceUri=zk+hierarchical://$ZK_SERVERS/$ZK_CHROOT"
    } >> "$BOOKIE_CONF"

    # optional parameters
    # if [[ -n $ZOO_4LW_COMMANDS_WHITELIST ]]; then
    #     echo "4lw.commands.whitelist=$ZOO_4LW_COMMANDS_WHITELIST" >> "$BOOKIE_CONF"
    # fi

fi

exec "$@"
