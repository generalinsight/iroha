add_library(cpp_redis UNKNOWN IMPORTED)

find_path(cpp_redis_INCLUDE_DIR cpp_redis/cpp_redis)
mark_as_advanced(cpp_redis_INCLUDE_DIR)

find_library(cpp_redis_LIBRARY cpp_redis)
mark_as_advanced(cpp_redis_LIBRARY)

find_library(tacopie_LIBRARY tacopie)
mark_as_advanced(tacopie_LIBRARY)

find_package_handle_standard_args(cpp_redis DEFAULT_MSG
    cpp_redis_INCLUDE_DIR
    cpp_redis_LIBRARY
    tacopie_LIBRARY
    )

set(URL https://github.com/Cylix/cpp_redis.git)
set(VERSION f390eef447a62dcb6da288fb1e91f25f8a9b838c)
set_target_description(cpp_redis "C++ redis client" ${URL} ${VERSION})

iroha_get_lib_name(CPPREDISLIB cpp_redis STATIC)
iroha_get_lib_name(TACOPIELIB  tacopie   STATIC)

if (NOT cpp_redis_FOUND)
  externalproject_add(cylix_cpp_redis
      GIT_REPOSITORY ${URL}
      GIT_TAG        ${VERSION}
      BUILD_BYPRODUCTS
        ${EP_PREFIX}/src/cylix_cpp_redis-build/lib/${CPPREDISLIB}
        ${EP_PREFIX}/src/cylix_cpp_redis-build/lib/${TACOPIELIB}
      INSTALL_COMMAND "" # remove install step
      UPDATE_COMMAND "" # remove update step
      TEST_COMMAND "" # remove test step
      )
  externalproject_get_property(cylix_cpp_redis source_dir binary_dir)

  if(CMAKE_GENERATOR STREQUAL "Xcode")
    set(cpp_redis_LIBRARY ${binary_dir}/lib/${CMAKE_BUILD_TYPE}/${CPPREDISLIB})
    set(tacopie_LIBRARY   ${binary_dir}/lib/${CMAKE_BUILD_TYPE}/${TACOPIELIB})
  else ()
    set(cpp_redis_LIBRARY ${binary_dir}/lib/${CPPREDISLIB})
    set(tacopie_LIBRARY   ${binary_dir}/lib/${TACOPIELIB})
  endif ()

  set(cpp_redis_INCLUDE_DIRS "${source_dir}/tacopie/includes;${source_dir}/includes")
  foreach(include ${cpp_redis_INCLUDE_DIRS})
      file(MAKE_DIRECTORY ${include})
  endforeach()

  add_dependencies(cpp_redis cylix_cpp_redis)
endif ()

set_target_properties(cpp_redis PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${cpp_redis_INCLUDE_DIRS}"
    IMPORTED_LOCATION ${cpp_redis_LIBRARY}
    INTERFACE_LINK_LIBRARIES "${tacopie_LIBRARY}"
    )
