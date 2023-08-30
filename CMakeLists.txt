cmake_minimum_required(VERSION 3.7.2)

if(${CMAKE_VERSION} VERSION_LESS "3.12.0")
    project(rtltcpaccess)
else()
    project(rtltcpaccess C)
endif()

if(MINGW)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wl,--subsystem,windows -s")
endif(MINGW)

set(SRCs
    src/main.c
    src/rtl283xaccess.def
)

add_library(${PROJECT_NAME} SHARED ${SRCs})
set_source_files_properties(rtl283xaccess.def PROPERTIES HEADER_FILE_ONLY TRUE)
set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")
set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME "RTL283XACCESS")

target_link_libraries(${PROJECT_NAME} ws2_32)
