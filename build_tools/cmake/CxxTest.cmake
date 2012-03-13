FIND_PROGRAM(CXXTESTGEN
    NAMES cxxtestgen
    PATHS ./cxxtest/bin/
          /usr/bin
          /bin
          )

IF(NOT CXXTESTGEN)
    MESSAGE(FATAL_ERROR "Unable to find 'cxxtestgen'")
ENDIF(NOT CXXTESTGEN)

FUNCTION(cxx_test target source)
    STRING(REGEX REPLACE "hpp$" "cpp" CPP_FILE_NAME ${source})
    MESSAGE(${CPP_FILE_NAME})
    SET(CPP_FULL_NAME "${CMAKE_CURRENT_BINARY_DIR}/${CPP_FILE_NAME}")
    ADD_CUSTOM_COMMAND(
        OUTPUT "${CPP_FULL_NAME}"
        COMMAND ${CXXTESTGEN} --runner=ErrorPrinter --output "${CPP_FULL_NAME}" "${source}"
        DEPENDS "${source}"
    )
    ADD_EXECUTABLE(${target} ${CPP_FULL_NAME})
    SET_TARGET_PROPERTIES(${target} PROPERTIES COMPILE_FLAGS "-Wno-effc++")
    ADD_TEST(${target} ${RUNTIME_OUTPUT_DIRECTORY}/${target})
ENDFUNCTION(cxx_test)
