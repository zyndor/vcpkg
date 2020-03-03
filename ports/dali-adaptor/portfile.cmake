vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dalihub/dali-adaptor
    REF 667d7c7513c32cc997478956a96e056ca814a3ee
    SHA512 f7752213cfd828112816f70c6ef681792da26c378d274ca32855efcde9da1f4cad7e7b2ad2c19918e72c91cb93faff1389850267be5d293535e8067a6f133f74
    HEAD_REF master
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
