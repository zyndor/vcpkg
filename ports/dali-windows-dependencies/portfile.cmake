vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dalihub/windows-dependencies
    REF d2864fd3f074a5b9c4d81863dc1ee0721675eb4d
    SHA512 d86e237c2e563507c2aa7057e47d44da4314436d92d5e35282c7e857b2c37af1fee1a46cd71d7242247bca3984e9afa91286bb0126dfb58f5e92b0c1a2fa1961
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
