cmake_minimum_required(VERSION 3.10)
project(spot_detector LANGUAGES C)

add_library(spot_detector SHARED
  "spot_detector.c"
)

target_include_directories(spot_detector PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}"
)

set_target_properties(spot_detector PROPERTIES
  C_VISIBILITY_PRESET hidden
  VISIBILITY_INLINES_HIDDEN YES
)
