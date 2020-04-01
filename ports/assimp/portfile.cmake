vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO zyndor/assimp
    REF 87e2d3a54de9379675d0cf8899ebd1e2db750902
    SHA512 9ecf8e1ca0c8decc72944e35a0e346aeb97cec186a2c00bae8533e2809a6b07df40d318c6fd485ac08b0a2c2c2a6ab008ea32d4b91d13e08bac788dbe784dd8a
    HEAD_REF master
    PATCHES
        uninitialized-variable.patch
)

file(REMOVE ${SOURCE_PATH}/cmake-modules/FindZLIB.cmake)
file(REMOVE_RECURSE ${SOURCE_PATH}/contrib/zlib ${SOURCE_PATH}/contrib/gtest ${SOURCE_PATH}/contrib/rapidjson)

set(VCPKG_C_FLAGS "${VCPKG_C_FLAGS} -D_CRT_SECURE_NO_WARNINGS")
set(VCPKG_CXX_FLAGS "${VCPKG_CXX_FLAGS} -D_CRT_SECURE_NO_WARNINGS")

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
  set(VCPKG_BUILD_SHARED_LIBS ON)
else()
  set(VCPKG_BUILD_SHARED_LIBS OFF)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DASSIMP_BUILD_TESTS=OFF
            -DASSIMP_BUILD_ASSIMP_VIEW=OFF
            -DASSIMP_BUILD_ZLIB=OFF
            -DASSIMP_BUILD_SHARED_LIBS=${VCPKG_BUILD_SHARED_LIBS}
            -DASSIMP_BUILD_ASSIMP_TOOLS=OFF
            -DASSIMP_INSTALL_PDB=OFF
            #-DSYSTEM_IRRXML=ON # Wait for the built-in irrxml to synchronize with port irrlich, add dependencies and enable this macro
)

vcpkg_install_cmake()

FILE(GLOB lib_cmake_directories RELATIVE "${CURRENT_PACKAGES_DIR}" "${CURRENT_PACKAGES_DIR}/lib/cmake/assimp-*")
list(GET lib_cmake_directories 0 lib_cmake_directory)
vcpkg_fixup_cmake_targets(CONFIG_PATH "${lib_cmake_directory}")

vcpkg_copy_pdbs()

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

file(READ ${CURRENT_PACKAGES_DIR}/share/assimp/assimp-config.cmake ASSIMP_CONFIG)
string(REPLACE "get_filename_component(ASSIMP_ROOT_DIR \"\${_PREFIX}\" PATH)"
               "set(ASSIMP_ROOT_DIR \${_PREFIX})" ASSIMP_CONFIG ${ASSIMP_CONFIG})

if (NOT VCPKG_CMAKE_SYSTEM_NAME OR VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
  if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    string(REPLACE "set( ASSIMP_LIBRARIES \${ASSIMP_LIBRARIES})"
                   "set( ASSIMP_LIBRARIES optimized \${ASSIMP_LIBRARY_DIRS}/\${ASSIMP_LIBRARIES}.lib debug \${ASSIMP_LIBRARY_DIRS}/../debug/lib/\${ASSIMP_LIBRARIES}d.lib)" ASSIMP_CONFIG ${ASSIMP_CONFIG})
  else()
    string(REPLACE "set( ASSIMP_LIBRARIES \${ASSIMP_LIBRARIES})"
                   "set( ASSIMP_LIBRARIES optimized \${ASSIMP_LIBRARY_DIRS}/\${ASSIMP_LIBRARIES}.lib \${ASSIMP_LIBRARY_DIRS}/IrrXML.lib debug \${ASSIMP_LIBRARY_DIRS}/../debug/lib/\${ASSIMP_LIBRARIES}d.lib \${ASSIMP_LIBRARY_DIRS}/../debug/lib/IrrXMLd.lib)" ASSIMP_CONFIG ${ASSIMP_CONFIG})
  endif()
else()
  string(REPLACE "set( ASSIMP_LIBRARIES \${ASSIMP_LIBRARIES})"
                 "set( ASSIMP_LIBRARIES optimized \${ASSIMP_LIBRARY_DIRS}/lib\${ASSIMP_LIBRARIES}.a \${ASSIMP_LIBRARY_DIRS}/libIrrXML.a \${ASSIMP_LIBRARY_DIRS}/libz.a debug \${ASSIMP_LIBRARY_DIRS}/../debug/lib/lib\${ASSIMP_LIBRARIES}d.a \${ASSIMP_LIBRARY_DIRS}/../debug/lib/libIrrXMLd.a \${ASSIMP_LIBRARY_DIRS}/../debug/lib/libz.a)" ASSIMP_CONFIG ${ASSIMP_CONFIG})
endif()

file(WRITE ${CURRENT_PACKAGES_DIR}/share/assimp/assimp-config.cmake "${ASSIMP_CONFIG}")

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)