#!/usr/bin/env bash
# Copyright The Phorepoc Authors
# SPDX-License-Identifier: BSD-2-Clause
#
# prebuild.sh -- the pdk's package.yml runs it in the toolchain container before the components: core's S^4 recipes
# (os/tools/phorepoc-s4/: Qt 4.8 host tools, Orbit (Hb) configure, Qt Mobility / extensions / homescreen configure, header
# exports, the Z: data lists). Qt 4.8 itself is the qt-symbian package's: this builds only the S^4 side.
set -eu
S4="${PHOREPOC_OS_ROOT:?}/tools/phorepoc-s4"
export PHOREPOC_S4=1 PHOREPOC_QT48=1 JOBS=${JOBS:-$(nproc)}
[ -d "$S4" ] || { echo "orbit-ui: core has no os/tools/phorepoc-s4 yet (the S^4 configure scripts still live in the private tree)"; exit 1; }
bash "$S4/build_qt_host.sh"
bash "$S4/hb_configure_symbian.sh" && python3 "$S4/hb_zdata.py"
for t in s4_exports.py s4_zdata.py; do python3 "$S4/$t"; done
