vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dalihub/dali-adaptor
    REF f063848fc7a2a9a5218106881f156000161c69b7
    SHA512 801507fea7c452a92deeb24032f13182c333746d9b56e2ca19c3c8a16070f9df921b9e76b74ba689b03a4266e962d376ca7aabab4c9b8e5a6f09c201dbf4eef4
    HEAD_REF vcpkg
    PATCHES
	001-VCPKG-makefile.patch
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
  set(VCPKG_BUILD_SHARED_LIBS ON)
else()
  set(VCPKG_BUILD_SHARED_LIBS OFF)
endif()

set( ADAPTOR_OPTIONS
       -DPROFILE_LCASE=windows
       -DENABLE_PKG_CONFIGURE=OFF
       -DENABLE_LINK_TEST=OFF
       -DINSTALL_CMAKE_MODULES=ON
       -DSET_VCPKG_INSTALL_PREFIX=ON
)

vcpkg_configure_cmake(
    SOURCE_PATH "${SOURCE_PATH}/build/tizen"
    PREFER_NINJA
    OPTIONS ${ADAPTOR_OPTIONS}
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

#Install the license file.
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

vcpkg_fixup_cmake_targets(CONFIG_PATH share/${PORT} TARGET_PATH share/${PORT})

vcpkg_copy_pdbs()

# Copy the cmake configuration files to the 'installed' folder
file( COPY "${CURRENT_PACKAGES_DIR}/share" DESTINATION ${CURRENT_INSTALLED_DIR} )

vcpkg_test_cmake(PACKAGE_NAME dali-adaptor MODULE)
