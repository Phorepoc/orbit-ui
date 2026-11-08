#!/usr/bin/env bash
# Copyright The Phorepoc Authors
# SPDX-License-Identifier: BSD-2-Clause
#
# prebuild.sh -- the pdk's package.yml runs it in the toolchain container before the components: core's S^4 recipes
# (os/tools/phorepoc-s4/: Orbit's configure, Qt Mobility / Qt extensions / homescreensrv / homescreen configure, the header
# exports, the host tools, the Z: data lists). They need Qt 4.8 built first (os/tools/phorepoc-qt48/build_qt_sis.sh: qt-host,
# qt-symbian, qt-src in <build>/qt48); Qt itself is the qt-symbian package's, this builds only the S^4 side.
set -eu
S4="${PHOREPOC_OS_ROOT:?}/tools/phorepoc-s4"
export PHOREPOC_S4=1 PHOREPOC_QT48=1 JOBS=${JOBS:-$(nproc)}
[ -d "$S4" ] || { echo "orbit-ui: core has no os/tools/phorepoc-s4"; exit 1; }
if [ ! -f "${PHOREPOC_BUILD:?}/qt48/qt-symbian/bin/qmake" ]; then
  bash "${PHOREPOC_OS_ROOT}/tools/phorepoc-qt48/build_qt_sis.sh" fetch host configure configure_full mocables stage
fi
bash "$S4/hb_configure_symbian.sh"
python3 "$S4/hb_zdata.py"
bash "$S4/qtm_configure_symbian.sh"
bash "$S4/qte_configure_symbian.sh"
python3 "$S4/s4_exports.py"
bash "$S4/hsrv_configure_symbian.sh"
python3 "$S4/s4_exports.py"
bash "$S4/hs_configure_symbian.sh"
python3 "$S4/s4_exports.py"
bash "$S4/build_hb_host_tools.sh"
bash "$S4/build_servicedb.sh"
bash "$S4/build_translations.sh"
python3 "$S4/s4_zdata.py"
