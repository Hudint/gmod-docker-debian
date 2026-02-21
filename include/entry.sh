#!/bin/bash

set -e

echo "Starting Garry's Mod server setup..."
echo "Current UserID: $UID"

withRetries() {
    set +e
    local max_retries=$1
    shift
    
    local attempt=1
    while [ $attempt -le $max_retries ]; do
        echo "Attempt $attempt / $max_retries: $@"

        "$@"
        
        echo "Exit code: $?"

        if [ $? -eq 0 ]; then
            echo "Command succeeded!"
            return 0
        fi
        
        echo "Command failed. Retrying in 5 seconds..."
        attempt=$((attempt + 1))
        sleep 5
    done

    echo "ERROR: Command failed after $max_retries attempts!"
    set -e
    return 1
}

# Ensure required directories exist
mkdir -p "$(dirname "${MOUNTCFG}")"

# Update Garry's Mod
if [ -z "${GMOD_DISABLE_UPDATE}" ]; then
    echo "Updating Garry's Mod..."

    withRetries 5 ${DIR_STEAMCMD}/steamcmd.sh \
    +force_install_dir ${DIR_GMOD} \
    +login anonymous \
    +app_update ${GMODID} validate +quit
fi

# Update Garry's Mod
if [ -z "${GMOD_DISABLE_UPDATE}" ]; then
    echo "Updating Garry's Mod..."
    withRetries 5 ${DIR_STEAMCMD}/steamcmd.sh \
    +force_install_dir ${DIR_GMOD} \
    +login anonymous \
    +app_update ${GMODID} validate +quit
fi

# Update other game content
if [ -z "${GMOD_DISABLE_UPDATE_OTHERS}" ]; then
    echo "Updating CSS..."
    withRetries 5 ${DIR_STEAMCMD}/steamcmd.sh \
        +force_install_dir ${DIR_CSS} \
        +login anonymous \
        +app_update ${CSSID} validate +quit
    echo "Updating TF2..."
    withRetries 5 ${DIR_STEAMCMD}/steamcmd.sh \
        +force_install_dir ${DIR_TF2} \
        +login anonymous \
        +force_install_dir ${DIR_TF2} +app_update ${TF2ID} validate +quit
fi

# Mount other game content
echo "Configuring mount points..."
if [ -f "${MOUNTCFG}" ]; then
    # Create backup of existing mount.cfg
    cp "${MOUNTCFG}" "${MOUNTCFG}.bak"

    # Update mount points safely
    if ! grep -q '"cstrike"\s"'"${DIR_CSS}"'/cstrike"' "${MOUNTCFG}"; then
        echo "Adding CSS mount point..."
        sed -i.tmp '/"cstrike"/d' "${MOUNTCFG}"
        sed -i.tmp '/^\s*}/ i   "cstrike"       "'"${DIR_CSS}"'/cstrike"' "${MOUNTCFG}"
        rm -f "${MOUNTCFG}.tmp"
    fi

    if ! grep -q '"tf"\s"'"${DIR_TF2}"'/tf"' "${MOUNTCFG}"; then
        echo "Adding TF2 mount point..."
        sed -i.tmp '/"tf"/d' "${MOUNTCFG}"
        sed -i.tmp '/^\s*}/ i   "tf"    "'"${DIR_TF2}"'/tf"' "${MOUNTCFG}"
        rm -f "${MOUNTCFG}.tmp"
    fi
else
    echo "Creating new mount.cfg..."
    cp /include/mount.cfg "${MOUNTCFG}"
fi

# Ensure proper permissions after modifications
chmod 666 "${MOUNTCFG}"

# Start Server
ARGS="-steam_dir ${DIR_STEAMCMD} \
    -steamcmd_script /include/autoupdatescript.txt \
    -autoupdate \
    -debug \
    +hostname \"${GMOD_SERVERNAME}\" \
    +maxplayers ${GMOD_MAXPLAYERS} \
    +map ${GMOD_MAP} \
    +gamemode ${GMOD_GAMEMODE}"

if [ -n "${GMOD_WORKSHOP_COLLECTION}" ]; then
    ARGS="${ARGS} +host_workshop_collection ${GMOD_WORKSHOP_COLLECTION}"
fi

if [ -n "${GMOD_WORKSHOP_AUTHKEY}" ]; then
    ARGS="${ARGS} -authkey ${GMOD_WORKSHOP_AUTHKEY}"
fi

if [ -n "${GMOD_SV_PASSWORD}" ]; then
    ARGS="${ARGS} +sv_password ${GMOD_SV_PASSWORD}"
fi

if [ -n "${GMOD_RCON_PASSWORD}" ]; then
    ARGS="${ARGS} +rcon_password ${GMOD_RCON_PASSWORD}"
fi

if [ -n "${GMOD_GSLT}" ]; then
    ARGS="${ARGS} +sv_setsteamaccount ${GMOD_GSLT}"
fi

ARGS="${ARGS} -port ${GMOD_PORT} -clientport ${GMOD_CLIENT_PORT} ${GMOD_ADDITIONAL_ARGS}"

echo "Args: $ARGS"

exec ${DIR_GMOD}/srcds_run ${ARGS}