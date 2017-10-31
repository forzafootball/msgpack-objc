#----------------------------------------------------------------
# Generated CMake target import file for configuration "MinSizeRel".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "msgpackc" for configuration "MinSizeRel"
set_property(TARGET msgpackc APPEND PROPERTY IMPORTED_CONFIGURATIONS MINSIZEREL)
set_target_properties(msgpackc PROPERTIES
  IMPORTED_LOCATION_MINSIZEREL "${_IMPORT_PREFIX}/lib/libmsgpackc.2.0.0.dylib"
  IMPORTED_SONAME_MINSIZEREL "@rpath/libmsgpackc.2.dylib"
  )

list(APPEND _IMPORT_CHECK_TARGETS msgpackc )
list(APPEND _IMPORT_CHECK_FILES_FOR_msgpackc "${_IMPORT_PREFIX}/lib/libmsgpackc.2.0.0.dylib" )

# Import target "msgpackc-static" for configuration "MinSizeRel"
set_property(TARGET msgpackc-static APPEND PROPERTY IMPORTED_CONFIGURATIONS MINSIZEREL)
set_target_properties(msgpackc-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_MINSIZEREL "C"
  IMPORTED_LOCATION_MINSIZEREL "${_IMPORT_PREFIX}/lib/libmsgpackc.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS msgpackc-static )
list(APPEND _IMPORT_CHECK_FILES_FOR_msgpackc-static "${_IMPORT_PREFIX}/lib/libmsgpackc.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
