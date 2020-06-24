vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dalihub/windows-dependencies
    REF a4dff34856897384f88b1e1a3138f74ba370ae93
    SHA512 a8c5081f62601bad0259ead161e05c53d3bdffa744e63f5235974c4fd9fcf4f87b07f2b30b0252c7290d4b39c85e86e58d00485dc4ef786cf8d1b122efc56acc
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
