vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dalihub/windows-dependencies
    REF 8dc3e0c19bc570c453d1a7777b8be94f4b11bd29
    SHA512 f02fddb29efebd4d4277e42dc388ad74dd44dab37a16dd05314cb6333e86f9529f9a183664e9961f9f68c2253f055fc8ea2ed20b89c7d166c1fb48252f2845f3
    HEAD_REF master
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
