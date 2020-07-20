vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dalihub/dali-toolkit
    REF e64a636db1b2bdaf773d88cee87cd6a1a91ec3cd
    SHA512 ae406fb766abca59aa2d304ab8d3ed575b9933608ce447dc68ec296208963ad91f4f52fb90ec3e04d33f9068a469f16b58f58f31a5ae78e8e331fa58b6f510dd
    HEAD_REF vcpkg
    PATCHES
	001-VCPKG-makefile.patch
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
  set(VCPKG_BUILD_SHARED_LIBS ON)
else()
  set(VCPKG_BUILD_SHARED_LIBS OFF)
endif()

set( TOOLKIT_OPTIONS
       -DENABLE_PKG_CONFIGURE=OFF
       -DENABLE_LINK_TEST=OFF
       -DINSTALL_DOXYGEN_DOC=OFF
       -DCONFIGURE_AUTOMATED_TESTS=OFF
       -DINSTALL_CMAKE_MODULES=ON
       -DSET_VCPKG_INSTALL_PREFIX=ON
       -DVCPKG_INSTALLED_DIR=${CURRENT_INSTALLED_DIR}
)

vcpkg_configure_cmake(
    SOURCE_PATH "${SOURCE_PATH}/build/tizen"
    PREFER_NINJA
    OPTIONS ${TOOLKIT_OPTIONS}
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

#Install the license file.
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

vcpkg_fixup_cmake_targets(CONFIG_PATH share/${PORT} TARGET_PATH share/${PORT})

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

vcpkg_copy_pdbs()

# Copy the cmake configuration files to the 'installed' folder
file( COPY "${CURRENT_PACKAGES_DIR}/share" DESTINATION ${CURRENT_INSTALLED_DIR} )

vcpkg_test_cmake(PACKAGE_NAME dali-toolkit MODULE)
