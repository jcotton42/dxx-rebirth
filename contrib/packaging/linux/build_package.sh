#!/bin/bash
set -x

# Grab latest linuxdeploy
curl -S -L -O https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage || exit 3
chmod a+x linuxdeploy-x86_64.AppImage

# And the AppRun
curl -s -L -O https://github.com/AppImage/AppImageKit/releases/download/continuous/AppRun-x86_64 || exit 3
chmod a+x AppRun-x86_64


build_appimage() {
    name="$1"

    appdir="${name}.appdir"

    ## Install
    # Copy resources into package dir
    mkdir "${appdir}"

    # Executable
    mkdir -p "${appdir}/usr/bin"
    cp "build/${name}/${name}" "${appdir}/usr/bin"

    # Icons
    mkdir -p "${appdir}/usr/share/pixmaps"
    cp "${name}/${name}.xpm" "${appdir}/usr/share/pixmaps"
    cp "${name}/${name}.xpm" "${appdir}/"

    mkdir -p "${appdir}/usr/share/icons/hicolor/128x128/apps/"
    cp "${name}/${name}.png" "${appdir}/usr/share/icons/hicolor/128x128/apps/"
    cp "${name}/${name}.png" "${appdir}/"

    # Menu item
    mkdir -p "${appdir}/usr/share/applications"
    cp "${name}/${name}.desktop" "${appdir}/usr/share/applications"
    cp "${name}/${name}.desktop" "${appdir}/"

    ## Package
    cp AppRun-x86_64 "${appdir}/AppRun"

    # Package!
    ./linuxdeploy-x86_64.AppImage --appdir "${appdir}" --output appimage

    rm -rf "${appdir}"
}

# Build each subunit
build_appimage "d1x-rebirth" "d1x-rebirth"
build_appimage "d2x-rebirth" "d2x-rebirth"

# Clean
rm -f linuxdeploy* AppRun*
