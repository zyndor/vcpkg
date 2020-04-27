vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO vcebollada/windows-dependencies
    REF c2638baf5ff484f205f6e3ff2d384bf8e96e22fa
    SHA512 4369453a9c6756a10b4ce19f315dc929253dbf34a04cda0fdb2d70d25259d8f3ce6f93979f60960e10a51bec74d6d4ce7d6a3ca1417b8914efce19703a0abcce
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
