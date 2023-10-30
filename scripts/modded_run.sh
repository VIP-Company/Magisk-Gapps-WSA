#!/bin/bash
#
# This file is part of MagiskOnWSALocal.
#
# MagiskOnWSALocal is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# MagiskOnWSALocal is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with MagiskOnWSALocal.  If not, see <https://www.gnu.org/licenses/>.
#
# Copyright (C) 2023 LSPosed Contributors
#

# DEBUG=--debug
# CUSTOM_MAGISK=--magisk-custom

if [ ! "$BASH_VERSION" ]; then
    echo "Please do not use sh to run this script, just execute it directly" 1>&2
    exit 1
fi
cd "$(dirname "$0")" || exit 1

./install_deps.sh || exit 1

WHIPTAIL=$(command -v whiptail 2>/dev/null)
DIALOG=$(command -v dialog 2>/dev/null)
DIALOG=${WHIPTAIL:-$DIALOG}
function Radiolist {
    declare -A o="$1"
    shift
    if ! $DIALOG --nocancel --radiolist "${o[title]}" 0 0 0 "$@" 3>&1 1>&2 2>&3; then
        echo "${o[default]}"
    fi
}

function YesNoBox {
    declare -A o="$1"
    shift
    $DIALOG --title "${o[title]}" --yesno "${o[text]}" 0 0
}
COMPRESS_OUTPUT="--compress"
COMPRESS_FORMAT="7z"
# For Alternate Release with Magisk Installed
#MAGISK_TRUE="magisk"
declare -A ARCH_MAP=(["x64"]="x64" ["arm64"]="arm64" ["x64 & arm64"]="x64 & arm64")
declare -A RELEASE_TYPE_MAP=(["retail"]="retail" ["release preview"]="RP" ["insider slow"]="WIS" ["insider fast"]="WIF")
declare -A MAGISK_VER_MAP=(["stable"]="stable" ["beta"]="beta" ["canary"]="canary" ["debug"]="debug")
declare -A GAPPS_BRAND_MAP=(["MindTheGapps"]="MindTheGapps" ["OpenGApps"]="OpenGApps")
declare -A GAPPS_VARIANT_MAP=(["none"]="none" ["super"]="super" ["stock"]="stock" ["full"]="full" ["mini"]="mini" ["micro"]="micro" ["nano"]="nano" ["pico"]="pico" ["tvstock"]="tvstock" ["tvmini"]="tvmini")
declare -A REMOVE_AMAZON_MAP=(["keep"]="keep" ["remove"]="remove")
declare -A ROOT_SOL_MAP=(["magisk"]="magisk" ["none"]="none")
#declare -A RELEASE_TYPE_MAP=(["retail"]="retail" ["release preview"]="RP" ["insider slow"]="WIS" ["insider fast"]="WIF")
COMMAND_LINE=(--arch "${ARCH_MAP[$ARCH]}" --release-type "${RELEASE_TYPE_MAP[$RELEASE_TYPE]}" --magisk-ver "${MAGISK_VER_MAP[$MAGISK_VER]}" --gapps-brand "${GAPPS_BRAND_MAP[$GAPPS_BRAND]}" --gapps-variant "${GAPPS_VARIANT_MAP[$GAPPS_VARIANT]}" "${REMOVE_AMAZON_MAP[$REMOVE_AMAZON]}" --root-sol "${ROOT_SOL_MAP[$ROOT_SOL]}" "$COMPRESS_OUTPUT" "$OFFLINE" "$DEBUG" "$CUSTOM_MAGISK" --compress-format "$COMPRESS_FORMAT")
echo "COMMAND_LINE=${COMMAND_LINE[*]}"
# if 2306 Error is fixed
chmod +x ./build.sh				   
./build.sh "${COMMAND_LINE[@]}"
# With trick to fix 2306
#chmod +x ./build_modded.sh				   
#./build_modded.sh "${COMMAND_LINE[@]}"
# Magisk Always True Command Line
#M_COMMAND_LINE=(--arch "${ARCH_MAP[$ARCH]}" --release-type "${RELEASE_TYPE_MAP[$RELEASE_TYPE]}" --magisk-ver "${MAGISK_VER_MAP[$MAGISK_VER]}" --gapps-brand "${GAPPS_BRAND_MAP[$GAPPS_BRAND]}" --gapps-variant "${GAPPS_VARIANT_MAP[$GAPPS_VARIANT]}" "${REMOVE_AMAZON_MAP[$REMOVE_AMAZON]}" --root-sol "$MAGISK_TRUE" "$COMPRESS_OUTPUT" "$OFFLINE" "$DEBUG" "$CUSTOM_MAGISK" --compress-format "$COMPRESS_FORMAT")
#echo "M_COMMAND_LINE=${M_COMMAND_LINE[*]}"
#chmod +x ./build.sh
#./build.sh "${M_COMMAND_LINE[@]}"
