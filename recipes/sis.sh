#!/usr/bin/env bash
# Copyright The Phorepoc Authors
# SPDX-License-Identifier: BSD-2-Clause
#
# sis.sh -- the pdk's package.yml runs it after the components: $PHOREPOC_BUILD/sis/orbit-ui-x32.sis, package "Orbit".
# It carries the S^4 set's images and data (the Z: data lists the S^4 build writes, $PHOREPOC_BUILD/qt48/*-zdata.txt), the shell
# description file that makes Orbit appear in Settings -> Device -> UI shell, its start list, and the licences and the source offer
# (\resource\phe\orbit\licences\). It depends on the "Qt" package of qt-symbian.
# Data the installer may not write is left out: \sys\install\ (the software component registry's provisioning database --
# an installed package registers itself) is system-protected.
set -eu
REPO=$(cd "$(dirname "$0")/.." && pwd)
B="${PHOREPOC_BUILD:?}"
KEYS=$(sed -n 's/^COMPONENTS_x32="\(.*\)"/\1/p' "$REPO/package.conf")
SKIP=$(sed -n 's/^SKIP_DATA_x32="\(.*\)"$/\1/p' "$REPO/package.conf")
FILES=()
CENREP=""
for z in "$B"/qt48/*-zdata.txt; do
  [ -f "$z" ] || continue
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    target=${line%%=*}; host=${line#*=}
    case "$target" in sys\\install\\*) continue ;; esac
    case " $SKIP " in *" $target "*) continue ;; esac
    # SWI writes only a package's own \private\<SID>\ folders: the CenRep files (\private\10202be9\) go in an embedded TYPE=SP
    # package of Central Repository, as the 2010 packages do (the image carries its ROM stub, CenRepStub.sis)
    case "$target" in
      private\\10202be9\\*) CENREP="$CENREP,$host=c:/private/10202be9/${target##*\\}"; continue ;;
      private\\200267af\\*) continue ;;
    esac
    FILES+=(--file "$host=!:/${target//\\//}")
  done < "$z"
done
for f in "$REPO"/LICENSES/* "$REPO/LICENSE" "$REPO/NOTICE" "$REPO/SOURCE-OFFER.txt"; do
  FILES+=(--file "$f=!:/resource/phe/orbit/licences/$(basename "$f")")
done
FILES+=(--file "$REPO/shell/orbit.txt=!:/resource/phe/shells/orbit.txt" --file "$REPO/shell/orbit.start=!:/resource/phe/shells/orbit.start")
mkdir -p "$B/sis"
# 0x2001E61C = the "Qt" package's identity (qt-symbian); Orbit's own is in Phorepoc's test range
PHOREPOC_S4=1 PHOREPOC_QT48=1 python3 "$PHOREPOC_PDK/tools/make_sis.py" $KEYS --unsigned --uid 0xE7015A10 \
  --version "${PHOREPOC_PACKAGE_VERSION:-1.0.0}" --name "Orbit" --vendor Phorepoc \
  --depends 0x2001E61C,4.8.0,Qt ${CENREP:+--embed "0x10202BE9,sp,1.0.0,Orbit settings$CENREP"} "${FILES[@]}" --out "$B/sis/orbit-ui-x32.sis"
