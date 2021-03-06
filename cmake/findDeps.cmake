function(find_deps package url)
    find_package(${package} QUIET)
    if (${package}_FOUND)
        message(STATUS "${PROJECT_NAME} found package ${package}")
    elseif(TARGET ${package})
        if(NOT ${package}_INCLUDE_DIRS STREQUAL "")
            message(STATUS "${PROJECT_NAME} found ${package}_INCLUDE_DIRS")
        elseif(EXISTS ${CMAKE_SOURCE_DIR}/lib/${package})
            message(STATUS 
                "${PROJECT_NAME} found ${package} in ${CMAKE_SOURCE_DIR}/lib/")
            set(${package}_INCLUDE_DIRS
                ${CMAKE_SOURCE_DIR}/lib/${package}/include PARENT_SCOPE)
        else()
            message(SEND_ERROR "${PROJECT_NAME} could't find ${package} TARGET")
        endif()
    else()
        if(NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/lib/${package})
            message(STATUS "${PROJECT_NAME} did not find ${package}")
            file(MAKE_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/lib)
            execute_process(COMMAND 
                git clone ${url} ${CMAKE_CURRENT_LIST_DIR}/lib/${package})
        endif()
        message(STATUS "${PROJECT_NAME} is using local lib/${package}")
        add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/lib/${package})
        set(${package}_INCLUDE_DIRS 
            ${CMAKE_CURRENT_LIST_DIR}/lib/${package}/include PARENT_SCOPE)
    endif()
endfunction()
