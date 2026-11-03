# Minimale benötigte CMake-Version.
cmake_minimum_required(VERSION 3.16)

# Projektname und verwendete Programmiersprache.
project(TintCollector VERSION 1.0.0 LANGUAGES CXX)

# Qt 6 benötigt mindestens C++17.
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Verarbeitet .qrc-Dateien automatisch.
set(CMAKE_AUTORCC ON)
set(QML_IMPORT_PATH "${CMAKE_CURRENT_SOURCE_DIR}" CACHE STRING "QML imports" FORCE)

# Qt Quick laden.
find_package(Qt6 REQUIRED COMPONENTS Quick Sql Widgets)

# Standardkonfiguration für Qt-Projekte.
qt_standard_project_setup()

# Anwendung und Quelldateien.
qt_add_executable(TintCollector
    main.cpp
    TintCollector.qrc
    src/cpp/clipboard.h src/cpp/clipboard.cpp
    src/cpp/colorgenerator.h src/cpp/colorgenerator.cpp
    src/cpp/imagecolorgenerator.h src/cpp/imagecolorgenerator.cpp
    src/cpp/database.h src/cpp/database.cpp
    src/cpp/model.h src/cpp/model.cpp
    src/cpp/palettemodel.h src/cpp/palettemodel.cpp
    src/cpp/colormodel.h src/cpp/colormodel.cpp
    src/cpp/paletteproxymodel.h src/cpp/paletteproxymodel.cpp
    src/cpp/generator.h src/cpp/generator.cpp
    src/cpp/notification.h src/cpp/notification.cpp
    src/cpp/exporter.h src/cpp/exporter.cpp
    App/AboutDialog.qml
)

# Qt Quick mit der Anwendung verknüpfen.
target_link_libraries(TintCollector
    PRIVATE Qt6::Quick Qt6::Sql Qt6::Widgets
)

# GUI-Anwendung unter Windows und App-Bundle unter macOS.
set_target_properties(TintCollector PROPERTIES
    WIN32_EXECUTABLE ON
    MACOSX_BUNDLE ON
)


if(EMSCRIPTEN)
    # GEÄNDERT: Datenbank direkt aus deinem Desktop-Build.
    set(database_file
        "${CMAKE_CURRENT_SOURCE_DIR}/build/Desktop_Qt_6_12_0_MinGW_64_bit_Debug/TintCollector.sqlite"
    )

    if(NOT EXISTS "${database_file}")
        message(FATAL_ERROR "Desktop-Datenbank nicht gefunden: ${database_file}")
    endif()

    message(STATUS "Verwendete Datenbank: ${database_file}")

    target_link_options(TintCollector PRIVATE
        "--bind"
        "-lidbfs.js"
        "SHELL:--pre-js \"${CMAKE_CURRENT_SOURCE_DIR}/database.js\""
        "SHELL:--preload-file \"${database_file}@/TintCollector.sqlite\""
    )

    set_property(TARGET TintCollector APPEND PROPERTY LINK_DEPENDS
        "${CMAKE_CURRENT_SOURCE_DIR}/database.js"
        "${database_file}"
    )
endif()
