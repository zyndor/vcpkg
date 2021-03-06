vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nothings/stb
    REF 052dce117ed989848a950308bd99eef55525dfb1
    SHA512 490be1e727ff77385ce6050c03774ee6819fb194ac38076be98635091ce5271851a9e5ac9763bea961758837735ed6fc680f4fee645acf419457460c403c9f20
    HEAD_REF master
)

file(GLOB HEADER_FILES ${SOURCE_PATH}/*.h)
file(COPY ${HEADER_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/include)

file(INSTALL ${SOURCE_PATH}/README.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/FindStb.cmake" DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake" DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
