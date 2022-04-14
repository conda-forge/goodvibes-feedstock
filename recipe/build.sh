#!/bin/bash

set -euxo pipefail

mv "$SRC_DIR/goodvibes/share/symmetry.c" symmetry.c
mv "$SRC_DIR/goodvibes/share/LICENSE.txt" symmetry.LICENSE.txt
rm -rf "$SRC_DIR/goodvibes/share/"

"${PYTHON}" -m pip install . -vv

# workaround bug where SP_DIR in python 3.10 gets truncated to lib/python3.1/...
SITE_PACKAGES=$(${PYTHON} -c 'import site; print(site.getsitepackages()[0])')
mkdir "$SITE_PACKAGES/goodvibes/share"
if [[ $target_platform == linux* ]]; then
  "$CC" -shared -o "$SITE_PACKAGES/goodvibes/share/symmetry_linux.so" -fPIC symmetry.c
else
  "$CC" -dynamiclib symmetry.c -o "$SITE_PACKAGES/goodvibes/share/symmetry_mac.dylib" -current_version 1.0 -compatibility_version 1.0
fi
