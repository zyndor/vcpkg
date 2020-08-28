vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dalihub/dali-adaptor
    REF 4ac723855e96d822e2ec864b952da91bb0ab2bce
    SHA512 e0f3957f8bd280ff6dc4a9d20b7442c212c514d62092a57d135d98e0947fa700e9f820a05a66c00b7803de27b333bd4bfb875ad09ace193cec40afd9e3c1ce0c
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
