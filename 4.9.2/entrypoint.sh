#!/bin/bash

# Generate the config only if it doesn't exist
if [[ ! -f "$BOOKIE_CONF" ]]; then
    {
        echo "journalDirectories=$BOOKIE_JOURNAL_DIR"
        echo "ledgerDirectories=$BOOKIE_LEDGER_DIR"
        echo "bookiePort=$BOOKIE_PORT"
        echo "advertisedAddress=$BOOKIE_ADVERTISE_ADDRESS"
        echo "httpServerEnabled=$BOOKIE_HTTP_SERVER_ENABLED"
        echo "metadataServiceUri=zk+hierarchical://$ZK_SERVERS/$ZK_CHROOT"
        echo "zkTimeout=$ZK_TIMEOUT"
        echo "zkEnableSecurity=$ZK_ENABLE_SECURITY"
    } >> "$BOOKIE_CONF"
fi

exec "$@"
