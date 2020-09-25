vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dalihub/dali-toolkit
    REF 666b4b2f13d2f417557180a8440c6686c5dbfe83
    SHA512 fd90a84dc080dff2f6e86f294b14aea94188d0d1d56a8ca6e68090ccf479754d39e2daea69165453ddc3b37c741abf277baef9b215668a5601ae9a3b8483bd14
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
