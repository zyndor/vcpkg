vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dalihub/windows-dependencies
    REF e142a6f96f9ca7a4b0e52f79ca9841b4b9dd49ff
    SHA512 485a52c7381322786e2215a26156e4a6bc168a13abe5acff846035d6b7600043ada6d2bbb108e63e661e6a7727749e230ab04e5863f51f4d219eb2f4048f3b5f
    HEAD_REF vcpkg
)

set(VCPKG_BUILD_SHARED_LIBS OFF)

vcpkg_configure_cmake(
    SOURCE_PATH "${SOURCE_PATH}/build"
    PREFER_NINJA
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

#Install the license file.
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

vcpkg_fixup_cmake_targets(CONFIG_PATH share/${PORT} TARGET_PATH share/${PORT})

vcpkg_copy_pdbs()

# Copy the cmake configuration files to the 'installed' folder
file( COPY "${CURRENT_PACKAGES_DIR}/share" DESTINATION ${CURRENT_INSTALLED_DIR} )
