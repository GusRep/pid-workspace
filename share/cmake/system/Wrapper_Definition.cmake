#########################################################################################
#       This file is part of the program PID                                            #
#       Program description : build system supportting the PID methodology              #
#       Copyright (C) Robin Passama, LIRMM (Laboratoire d'Informatique de Robotique     #
#       et de Microelectronique de Montpellier). All Right reserved.                    #
#                                                                                       #
#       This software is free software: you can redistribute it and/or modify           #
#       it under the terms of the CeCILL-C license as published by                      #
#       the CEA CNRS INRIA, either version 1                                            #
#       of the License, or (at your option) any later version.                          #
#       This software is distributed in the hope that it will be useful,                #
#       but WITHOUT ANY WARRANTY; without even the implied warranty of                  #
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the                    #
#       CeCILL-C License for more details.                                              #
#                                                                                       #
#       You can find the complete license description on the official website           #
#       of the CeCILL licenses family (http://www.cecill.info/index.en.html)            #
#########################################################################################


##########################################################################################
############################ Guard for optimization of configuration process #############
##########################################################################################
if(WRAPPER_DEFINITION_INCLUDED)
  return()
endif()
set(WRAPPER_DEFINITION_INCLUDED TRUE)
##########################################################################################


list(APPEND CMAKE_MODULE_PATH ${WORKSPACE_DIR}/share/cmake/system/api)
list(APPEND CMAKE_MODULE_PATH ${WORKSPACE_DIR}/share/cmake/system/commands)

include(PID_Wrapper_API_Internal_Functions NO_POLICY_SCOPE)
include(External_Definition NO_POLICY_SCOPE) #to be able to interpret content of external package description files
include(Configuration_Definition NO_POLICY_SCOPE) #to be able to interpret content of external package description files
include(Package_Definition NO_POLICY_SCOPE) #to enable the use of get_PID_Platform_Info in find files

include(CMakeParseArguments)

#########################################################################################
######################## API to be used in wrapper description ##########################
#########################################################################################

#.rst:
#
# .. ifmode:: user
#
#  .. |PID_Wrapper| replace:: ``PID_Wrapper``
#  .. _PID_Wrapper:
#
#  PID_Wrapper
#  -----------
#
#   .. command:: PID_Wrapper(AUTHOR ... YEAR ... LICENSE ... DESCRIPTION ... [OPTIONS])
#
#   .. command:: declare_PID_Wrapper(AUTHOR ... YEAR ... LICENSE ... DESCRIPTION ... [OPTIONS])
#
#      Declare the current CMake project as a PID wrapper for a given external package with specific meta-information passed as parameter.
#
#     .. rubric:: Required parameters
#
#     :AUTHOR <name>: Defines the name of the reference author.
#
#     :YEAR <dates>: Reflects the lifetime of the wrapper, e.g. ``YYYY-ZZZZ`` where ``YYYY`` is the creation year and ``ZZZZ`` the latest modification date.
#
#     :LICENSE <license name>: The name of the license applying to the wrapper. This must match one of the existing license file in the ``licenses`` directory of the workspace. This license applies to the wrapper and not to the original project.
#
#     :DESCRIPTION <description>: A short description of the package usage and utility.
#
#     .. rubric:: Optional parameters
#
#     :INSTITUTION <institutions>: Define the institution(s) to which the reference author belongs.
#
#     :MAIL <e-mail>: E-mail of the reference author.
#
#     :ADDRESS <url>: The url of the wrapper's official repository. Must be set once the package is published.
#
#     :PUBLIC_ADDRESS <url>: Can be used to provide a public counterpart to the repository `ADDRESS`
#
#     :README <path relative to share folder>: Used to define a user-defined README file for the package.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - This function must be called in the root ``CMakeLists.txt`` file of the wrapper before any other call to the PID Wrapper API.
#        - It must be called **exactly once**.
#
#     .. admonition:: Effects
#        :class: important
#
#        Initialization of the wrapper's internal state. After this call the its content can be defined.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        PID_Wrapper(
#          AUTHOR Robin Passama
#          INSTITUTION LIRMM
#          YEAR 2013
#          LICENSE CeCILL-C
#          ADDRESS git@gite.lirmm.fr:passama/a-given-wrapper.git
#          DESCRIPTION "an example PID wrapper"
#        )
#

macro(PID_Wrapper)
  declare_PID_Wrapper(${ARGN})
endmacro(PID_Wrapper)

macro(declare_PID_Wrapper)
set(oneValueArgs LICENSE ADDRESS MAIL PUBLIC_ADDRESS README)
set(multiValueArgs AUTHOR INSTITUTION YEAR DESCRIPTION)
cmake_parse_arguments(DECLARE_PID_WRAPPER "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
if(NOT DECLARE_PID_WRAPPER_AUTHOR)
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, an author name must be given using AUTHOR keyword.")
endif()
if(NOT DECLARE_PID_WRAPPER_YEAR)
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, a year or year interval must be given using YEAR keyword.")
endif()
if(NOT DECLARE_PID_WRAPPER_LICENSE)
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, a license type must be given using LICENSE keyword.")
endif()
if(NOT DECLARE_PID_WRAPPER_DESCRIPTION)
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, a (short) description of the wrapper must be given using DESCRIPTION keyword.")
endif()

if(DECLARE_PID_WRAPPER_UNPARSED_ARGUMENTS)
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, unknown arguments ${DECLARE_PID_WRAPPER_UNPARSED_ARGUMENTS}.")
endif()

if(NOT DECLARE_PID_WRAPPER_ADDRESS AND DECLARE_PID_WRAPPER_PUBLIC_ADDRESS)
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, the wrapper must have an adress if a public access adress is declared.")
endif()

declare_Wrapper(	"${DECLARE_PID_WRAPPER_AUTHOR}" "${DECLARE_PID_WRAPPER_INSTITUTION}" "${DECLARE_PID_WRAPPER_MAIL}"
			"${DECLARE_PID_WRAPPER_YEAR}" "${DECLARE_PID_WRAPPER_LICENSE}"
			"${DECLARE_PID_WRAPPER_ADDRESS}" "${DECLARE_PID_WRAPPER_PUBLIC_ADDRESS}"
		"${DECLARE_PID_WRAPPER_DESCRIPTION}" "${DECLARE_PID_WRAPPER_README}")
endmacro(declare_PID_Wrapper)

#.rst:
#
# .. ifmode:: user
#
#  .. |PID_Original_Project| replace:: ``PID_Original_Project``
#  .. _PID_Original_Project:
#
#  PID_Original_Project
#  --------------------
#
#   .. command:: PID_Original_Project(AUTHORS ... LICENSE ... URL ...)
#
#   .. command:: define_PID_Wrapper_Original_Project_Info(AUTHORS ... LICENSE ... URL ...)
#
#      Set the meta information about original project being wrapped by current project.
#
#     .. rubric:: Required parameters
#
#     :AUTHORS <string>: Defines who are the authors of the original project.
#
#     :LICENSE <string>: The license that applies to the original project content.
#
#     :URL <url>: this is the index URL of the original project.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - This function must be called in the root CMakeLists.txt file of the wrapper, after declare_PID_Wrapper.
#        - It must be called **exactly once**.
#
#     .. admonition:: Effects
#        :class: important
#
#        Sets the meta-information about original project.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#      PID_Original_Project(
#         AUTHORS "Boost.org contributors"
#         LICENSES "Boost license"
#         URL http://www.boost.org)
#
#
macro(PID_Original_Project)
  define_PID_Wrapper_Original_Project_Info(${ARGN})
endmacro(PID_Original_Project)

macro(define_PID_Wrapper_Original_Project_Info)
	set(oneValueArgs URL)
	set(multiValueArgs AUTHORS LICENSES)
	cmake_parse_arguments(DEFINE_WRAPPED_PROJECT "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
	if(NOT DEFINE_WRAPPED_PROJECT_AUTHORS)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, authors references must be given using AUTHOR keyword.")
	endif()
	if(NOT DEFINE_WRAPPED_PROJECT_LICENSES)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, a license description must be given using LICENSE keyword.")
	endif()
	if(NOT DEFINE_WRAPPED_PROJECT_URL)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, The URL of the original project must be given using URL keyword.")
	endif()
	define_Wrapped_Project("${DEFINE_WRAPPED_PROJECT_AUTHORS}" "${DEFINE_WRAPPED_PROJECT_LICENSES}"  "${DEFINE_WRAPPED_PROJECT_URL}")
endmacro(define_PID_Wrapper_Original_Project_Info)

#.rst:
#
# .. ifmode:: user
#
#  .. |PID_Wrapper_Author| replace:: ``PID_Wrapper_Author``
#  .. _PID_Wrapper_Author:
#
#  PID_Wrapper_Author
#  -------------------
#
#   .. command:: PID_Wrapper_Author(AUTHOR ... [INSTITUTION ...])
#
#   .. command:: add_PID_Wrapper_Author(AUTHOR ... [INSTITUTION ...])
#
#      Add an author to the list of authors of the wrapper.
#
#     .. rubric:: Required parameters
#
#     :[AUTHOR] <string>: Name of the author. The keyword AUTHOR can be avoided if the name is given as first argument.
#
#     .. rubric:: Optional parameters
#
#     :INSTITUTION <institutions>: the institution(s) to which the author belongs.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - This function must be called in the root CMakeLists.txt file of the package, after declare_PID_Wrapper and before build_PID_Wrapper.
#
#     .. admonition:: Effects
#        :class: important
#
#        Add another author to the list of authors of the wrapper.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        PID_Wrapper_Author(AUTHOR Another Writter INSTITUTION LIRMM)
#
#
macro(PID_Wrapper_Author)
  add_PID_Wrapper_Author(${ARGN})
endmacro(PID_Wrapper_Author)

macro(add_PID_Wrapper_Author)
set(multiValueArgs AUTHOR INSTITUTION)
cmake_parse_arguments(ADD_PID_WRAPPER_AUTHOR "" "" "${multiValueArgs}" ${ARGN} )
if(NOT ADD_PID_WRAPPER_AUTHOR_AUTHOR)
  if("${ARGV0}" STREQUAL "" OR "${ARGV0}" STREQUAL "INSTITUTION")
    finish_Progress(${GLOBAL_PROGRESS_VAR})
  	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, an author name must be given using AUTHOR keyword.")
  else()#of the first argument is directly the name of the author
    add_Author("${ARGV0}" "${ADD_PID_WRAPPER_AUTHOR_INSTITUTION}")
  endif()
else()
  add_Author("${ADD_PID_WRAPPER_AUTHOR_AUTHOR}" "${ADD_PID_WRAPPER_AUTHOR_INSTITUTION}")
endif()
endmacro(add_PID_Wrapper_Author)

#.rst:
#
# .. ifmode:: user
#
#  .. |PID_Wrapper_Category| replace:: ``PID_Wrapper_Category``
#  .. _PID_Wrapper_Category:
#
#  PID_Wrapper_Category
#  --------------------
#
#   .. command:: PID_Wrapper_Category(...)
#
#   .. command:: add_PID_Wrapper_Category(...)
#
#      Declare that the current wrapper generates external packages that belong to a given category.
#
#     .. rubric:: Required parameters
#
#     :<string>: Name of the category
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - This function must be called in the root CMakeLists.txt file of the wrapper, after declare_PID_Wrapper and before build_PID_Wrapper.
#
#     .. admonition:: Effects
#        :class: important
#
#        Register the wrapper has being member of the given (sub)category. This information will be added to the wrapper reference file when it is generated.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        PID_Wrapper_Category(example/packaging)
#

macro(PID_Wrapper_Category)
  add_PID_Wrapper_Category(${ARGN})
endmacro(PID_Wrapper_Category)

macro(add_PID_Wrapper_Category)
if(NOT ${ARGC} EQUAL 1)
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, the add_PID_Wrapper_Category command requires one string argument of the form <category>[/subcategory]*.")
endif()
add_Category("${ARGV0}")
endmacro(add_PID_Wrapper_Category)

#.rst:
#
# .. ifmode:: user
#
#  .. |PID_Wrapper_Option| replace:: ``PID_Wrapper_Option``
#  .. _PID_Wrapper_Option:
#
#  PID_Wrapper_Option
#  ------------------
#
#   .. command:: PID_Wrapper_Option(OPTION ... TYPE ... DEFAULT ... [DESCRIPTION ...])
#
#   .. command:: define_PID_Wrapper_User_Option(OPTION ... TYPE ... DEFAULT ... [DESCRIPTION ...])
#
#      Declare that the current wrapper generates external packages that belong to a given category.
#
#     .. rubric:: Required parameters
#
#     :[OPTION] <name>:  string defining the name of the user option. This name can then be used in deployment scripts. The option keyword can be omitted is name is given as first argument.
#     :TYPE <type of the cmake option>:  type of the option, to be chosen between: FILEPATH (File chooser dialog), PATH (Directory chooser dialog), STRING (Arbitrary string), BOOL.
#     :DEFAULT ...:  Default value for the option.
#
#     .. rubric:: Optional parameters
#
#     :DESCRIPTION <string>: a string describing what this option is acting on.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - This function must be called in the root CMakeLists.txt file of the wrapper, after declare_PID_Wrapper and before build_PID_Wrapper.
#
#     .. admonition:: Effects
#        :class: important
#
#        Register a new user option into the wrapper. This user option will be used only in deployment scripts.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        PID_Wrapper_Option(OPTION BUILD_WITH_CUDA_SUPPORT
#          TYPE BOOL DEFAULT OFF
#          DESCRIPTION "set to ON to enable CUDA support during build")
#

macro(PID_Wrapper_Option)
  define_PID_Wrapper_User_Option(${ARGN})
endmacro(PID_Wrapper_Option)

macro(define_PID_Wrapper_User_Option)
set(oneValueArgs OPTION TYPE DESCRIPTION)
set(multiValueArgs DEFAULT)
cmake_parse_arguments(DEFINE_PID_WRAPPER_USER_OPTION "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
if(NOT DEFINE_PID_WRAPPER_USER_OPTION_OPTION)
  if("${ARGV0}" STREQUAL "" OR "${ARGV0}" MATCHES "^TYPE|DESCRIPTION|DEFAULT$")
    finish_Progress(${GLOBAL_PROGRESS_VAR})
  	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, an option name must be given using OPTION keyword.")
  endif()
  set(option_name "${ARGV0}")
else()
  set(option_name "${DEFINE_PID_WRAPPER_USER_OPTION_OPTION}")
endif()

if(NOT DEFINE_PID_WRAPPER_USER_OPTION_TYPE)
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, the type of the option must be given using TYPE keyword. Choose amon followiung value: FILEPATH (File chooser dialog), PATH (Directory chooser dialog), STRING (Arbitrary string), BOOL.")
endif()
set_Wrapper_Option("${option_name}" "${DEFINE_PID_WRAPPER_USER_OPTION_TYPE}" "${DEFINE_PID_WRAPPER_USER_OPTION_DEFAULT}" "${DEFINE_PID_WRAPPER_USER_OPTION_DESCRIPTION}")
endmacro(define_PID_Wrapper_User_Option)

#.rst:
#
# .. ifmode:: user
#
#  .. |PID_Wrapper_Publishing| replace:: ``PID_Wrapper_Publishing``
#  .. _PID_Wrapper_Publishing:
#
#  PID_Wrapper_Publishing
#  ----------------------
#
#   .. command:: PID_Wrapper_Publishing(PROJECT ... GIT|FRAMEWORK ... [OPTIONS])
#
#   .. command:: declare_PID_Wrapper_Publishing(PROJECT ... GIT|FRAMEWORK ... [OPTIONS])
#
#      Declare that the current wrapper generates external packages that belong to a given category.
#
#     .. rubric:: Required parameters
#
#     :PROJECT <url>: This argument tells where to fing the official repository project page of the wrapper. This is used to reference the wrapper project into the static site.
#
#     .. rubric:: Optional parameters
#
#     :ALLOWED_PLATFORMS <list of platforms>: This argument limits the set of platforms used for CI, only platforms specified will be managed in the CI process. WARNING: Due to gitlab limitation (only one pipeline can be defined) only ONE platform is allowed at the moment.
#     :DESCRIPTION <string>: This is a long(er) description of the wrapper that will be used for its documentation in static site.
#     :PUBLISH_BINARIES:  If this argument is used then the wrapper will automatically publish new binary versions to the publication site.
#     :FRAMEWORK <name of the framework>:  If this argument is set, then it means that the wrapper belongs to a framework. It will so contribute to the framework site. You must use either this argument or GIT one.
#     :GIT <repository address>: This is the address of the lone static site repository for the wrapper. It is used to automatically clone/update the static site of the wrapper. With this option the wrapper will not contribute to a framework but will have its own isolated deployment. You must use either this argument or FRAMEWORK one.
#     :PAGE <url>:  This is the online URL of the static site index page. Must be used if you use the GIT argument.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - This function must be called in the root CMakeLists.txt of the package, after declare_PID_Wrapper and before build_PID_Wrapper.
#        - This function must be called it has to be called after any other following functions: add_PID_Wrapper_Author, add_PID_Wrapper_Category and define_PID_Wrapper_Original_Project_Info.
#
#     .. admonition:: Effects
#        :class: important
#
#        - Generate or update a static site for the project. This static site locally resides in a dedicated git repository. If the project belongs to no framework then it has its lone static site that can be found in <pid-workspace>/sites/packages/<wrapper name>. If it belongs to a framework, the framework repository can be found in <pid-workspace>/sites/frameworks/<framework name>. In this later case, the wrapper only contributes to its own related content not the overall content of the framework.
#        - Depending on options it can also deploy binaries for target platform into the static site repository (framework or lone static site).
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        PID_Wrapper_Publishing(
#          PROJECT https://gite.lirmm.fr/pid/boost
#          FRAMEWORK pid
#          DESCRIPTION boost is a PID wrapper for external project called Boost. Boost provides many libraries and templates to ease development in C++.
#          PUBLISH_BINARIES
#          ALLOWED_PLATFORMS x86_64_linux_abi11)
#

macro(PID_Wrapper_Publishing)
  declare_PID_Wrapper_Publishing(${ARGN})
endmacro(PID_Wrapper_Publishing)

macro(declare_PID_Wrapper_Publishing)
set(optionArgs PUBLISH_BINARIES)
set(oneValueArgs PROJECT FRAMEWORK GIT PAGE)
set(multiValueArgs DESCRIPTION ALLOWED_PLATFORMS)
cmake_parse_arguments(DECLARE_PID_WRAPPER_PUBLISHING "${optionArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

	#manage configuration of CI
if(DECLARE_PID_WRAPPER_PUBLISHING_ALLOWED_PLATFORMS)
	foreach(platform IN LISTS DECLARE_PID_WRAPPER_PUBLISHING_ALLOWED_PLATFORMS)
		allow_CI_For_Platform(${platform})
	endforeach()
	set(DO_CI TRUE)
else()
	set(DO_CI FALSE)
endif()

if(DECLARE_PID_WRAPPER_PUBLISHING_FRAMEWORK)
	if(NOT DECLARE_PID_WRAPPER_PUBLISHING_PROJECT)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, you must tell where to find the project page of the official package repository using PROJECT keyword.")
	endif()
	if(${PROJECT_NAME}_FRAMEWORK)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR: a framework (${${PROJECT_NAME}_FRAMEWORK}) has already been defined, cannot define a new one !")
		return()
	elseif(${PROJECT_NAME}_SITE_GIT_ADDRESS)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR: a static site (${${PROJECT_NAME}_SITE_GIT_ADDRESS}) has already been defined, cannot define a framework !")
		return()
	endif()
	init_Documentation_Info_Cache_Variables("${DECLARE_PID_WRAPPER_PUBLISHING_FRAMEWORK}" "${DECLARE_PID_WRAPPER_PUBLISHING_PROJECT}" "" "" "${DECLARE_PID_WRAPPER_PUBLISHING_DESCRIPTION}")
	set(PUBLISH_DOC TRUE)
elseif(DECLARE_PID_WRAPPER_PUBLISHING_GIT)
	if(NOT DECLARE_PID_WRAPPER_PUBLISHING_PROJECT)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, you must tell where to find the project page of the official package repository using PROJECT keyword.")
	endif()
	if(NOT DECLARE_PID_WRAPPER_PUBLISHING_PAGE)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, you must tell where to find the index page for the static site of the package (using PAGE keyword).")
	endif()
	if(${PROJECT_NAME}_FRAMEWORK)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR: a framework (${${PROJECT_NAME}_FRAMEWORK}) has already been defined, cannot define a static site !")
		return()
	elseif(${PROJECT_NAME}_SITE_GIT_ADDRESS)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR: a static site (${${PROJECT_NAME}_SITE_GIT_ADDRESS}) has already been defined, cannot define a new one !")
		return()
	endif()
	init_Documentation_Info_Cache_Variables("" "${DECLARE_PID_WRAPPER_PUBLISHING_PROJECT}" "${DECLARE_PID_WRAPPER_PUBLISHING_GIT}" "${DECLARE_PID_WRAPPER_PUBLISHING_PAGE}" "${DECLARE_PID_WRAPPER_PUBLISHING_DESCRIPTION}")
	set(PUBLISH_DOC TRUE)
else()
	set(PUBLISH_DOC FALSE)
endif()#otherwise there is no site contribution

#manage publication of binaries
if(DECLARE_PID_WRAPPER_PUBLISHING_PUBLISH_BINARIES)
	if(NOT PUBLISH_DOC)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : you cannot publish binaries of the project (using PUBLISH_BINARIES) if you do not publish package ${PROJECT_NAME} using a static site (either use FRAMEWORK or SITE keywords).")
	endif()
	if(NOT DO_CI)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : you cannot publish binaries of the project (using PUBLISH_BINARIES) if you do not allow any CI process for package ${PROJECT_NAME} (use ALLOWED_PLATFORMS to defines which platforms will be used in CI process).")
	endif()
	publish_Binaries(TRUE)
else()
	publish_Binaries(FALSE)
endif()
endmacro(declare_PID_Wrapper_Publishing)

#.rst:
#
# .. ifmode:: user
#
#  .. |build_PID_Wrapper| replace:: ``build_PID_Wrapper``
#  .. _build_PID_Wrapper:
#
#  build_PID_Wrapper
#  -----------------
#
#   .. command:: build_PID_Wrapper()
#
#      Configure the PID wrapper according to overall information.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        This function must be the last one called in the root CMakeList.txt file of the wrapper.
#
#     .. admonition:: Effects
#        :class: important
#
#        This function generates configuration files, manage the generation of the global build process and call CMakeLists.txt files of version folders contained in subfolder src.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        build_PID_Wrapper()
#
macro(build_PID_Wrapper)
if(${ARGC} GREATER 0)
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, the build_PID_Wrapper command requires no arguments.")
	return()
endif()
build_Wrapped_Project()
endmacro(build_PID_Wrapper)

########################################################################################
###############To be used in subfolders of the src folder ##############################
########################################################################################

#.rst:
#
# .. ifmode:: user
#
#  .. |PID_Wrapper_Version| replace:: ``PID_Wrapper_Version``
#  .. _PID_Wrapper_Version:
#
#  PID_Wrapper_Version
#  -------------------
#
#   .. command:: PID_Wrapper_Version(VERSION ... DEPLOY ... [OPTIONS])
#
#   .. command:: add_PID_Wrapper_Known_Version(VERSION ... DEPLOY ... [OPTIONS])
#
#      Declare a new version of the original project wrapped into PID system.
#
#     .. rubric:: Required parameters
#
#     :[VERSION] <version string>: tells which version of the external package is being wrapped. The version number must exactly match the name of the folder containing the CMakeLists.txt that does this call. The keyword version may be omitted is version is the first argument.
#     :DEPLOY <path to deploy script>: This is the path, relative to the current folder, to the deploy script used to build and install the external package version. Script must be a cmake module file.
#
#     .. rubric:: Optional parameters
#
#     :POSTINSTALL <path to install script>: This is the path, relative to the current folder, to the install script that will be run after external package version has been installed into the workspace, to perform additionnal configuration steps. Script is a cmake module file.
#     :COMPATIBILITY <version number>: define which previous version is compatible with this current version, if any. Compatible simply means that this current version can be used instead of the previous one without any restriction.
#     :SONAME <version number>: (useful on UNIX only) Specify which soname will be given by default to all shared libraries defined by the wrapper.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - This function must be the first one called in the CMakeList.txt file of a version folder.
#
#     .. admonition:: Effects
#        :class: important
#
#        Configure information about a specific version of the external package.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        PID_Wrapper_Version(VERSION 1.55.0 DEPLOY deploy.cmake
#            SONAME 1.55.0 #define the extension name to use for shared objects
#        )
#

macro(PID_Wrapper_Version)
  add_PID_Wrapper_Known_Version(${ARGN})
endmacro(PID_Wrapper_Version)

macro(add_PID_Wrapper_Known_Version)
set(optionArgs)
set(oneValueArgs VERSION DEPLOY COMPATIBILITY SONAME POSTINSTALL PREUSE)
set(multiValueArgs)
cmake_parse_arguments(ADD_PID_WRAPPER_KNOWN_VERSION "${optionArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
if(NOT ADD_PID_WRAPPER_KNOWN_VERSION_VERSION)
  if("${ARGV0}" STREQUAL "" OR "${ARGV0}" MATCHES "^DEPLOY|COMPATIBILITY|SONAME|POSTINSTALL|PREUSE$")
    finish_Progress(${GLOBAL_PROGRESS_VAR})
  	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, you must define the version number using the VERSION keyword.")
  endif()
  set(version ${ARGV0})
else()
  set(version ${ADD_PID_WRAPPER_KNOWN_VERSION_VERSION})
endif()
if(NOT ADD_PID_WRAPPER_KNOWN_VERSION_DEPLOY)
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, you must define the build script to use using the DEPLOY keyword.")
endif()

#verify the version information
if(NOT EXISTS ${CMAKE_SOURCE_DIR}/src/${version} OR NOT IS_DIRECTORY ${CMAKE_SOURCE_DIR}/src/${version})
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad version argument when calling add_PID_Wrapper_Known_Version, no folder \"${version}\" can be found in src folder !")
	return()
endif()
list(FIND ${PROJECT_NAME}_KNOWN_VERSIONS ${version} INDEX)
if(NOT INDEX EQUAL -1)
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad version argument when calling add_PID_Wrapper_Known_Version, version \"${version}\" is already registered !")
	return()
endif()
#verify the script information
set(script_file ${ADD_PID_WRAPPER_KNOWN_VERSION_DEPLOY})
get_filename_component(RES_EXTENSION ${script_file} EXT)
if(NOT RES_EXTENSION MATCHES ".*\\.cmake$")
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad version argument when calling add_PID_Wrapper_Known_Version, type of script file ${script_file} cannot be deduced from its extension only .cmake extensions supported")
	return()
endif()

if(NOT EXISTS ${CMAKE_SOURCE_DIR}/src/${version}/${script_file})
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : cannot find script file ${script_file} in folder src/${version}/.")
	return()
endif()

#manage post install script
set(post_install_script)
if(ADD_PID_WRAPPER_KNOWN_VERSION_POSTINSTALL)
	set(post_install_script ${ADD_PID_WRAPPER_KNOWN_VERSION_POSTINSTALL})
	get_filename_component(RES_EXTENSION ${post_install_script} EXT)
	if(NOT RES_EXTENSION MATCHES ".*\\.cmake$")
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : bad version argument when calling add_PID_Wrapper_Known_Version, type of script file ${post_install_script} cannot be deduced from its extension. Only .cmake extensions supported")
		return()
	endif()
	if(NOT EXISTS ${CMAKE_SOURCE_DIR}/src/${version}/${post_install_script})
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : cannot find post install script file ${post_install_script} in folder src/${version}/.")
		return()
	endif()
endif()

#manage pre use script
set(pre_use_script)
if(ADD_PID_WRAPPER_KNOWN_VERSION_PREUSE)
	set(pre_use_script ${ADD_PID_WRAPPER_KNOWN_VERSION_PREUSE})
	get_filename_component(RES_EXTENSION ${pre_use_script} EXT)
	if(NOT RES_EXTENSION MATCHES ".*\\.cmake$")
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : bad version argument when calling add_PID_Wrapper_Known_Version, type of script file ${pre_use_script} cannot be deduced from its extension. Only .cmake extensions supported")
		return()
	endif()
	if(NOT EXISTS ${CMAKE_SOURCE_DIR}/src/${version}/${pre_use_script})
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : cannot find post install script file ${pre_use_script} in folder src/${version}/.")
		return()
	endif()
endif()


if(ADD_PID_WRAPPER_KNOWN_VERSION_COMPATIBILITY)
	belongs_To_Known_Versions(PREVIOUS_VERSION_EXISTS ${ADD_PID_WRAPPER_KNOWN_VERSION_COMPATIBILITY})
	if(NOT PREVIOUS_VERSION_EXISTS)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : compatibility with previous version ${ADD_PID_WRAPPER_KNOWN_VERSION_COMPATIBILITY} is impossible since this version is not wrapped.")
		return()
	endif()
	set(compatible_with_version ${ADD_PID_WRAPPER_KNOWN_VERSION_COMPATIBILITY})
endif()
add_Known_Version("${version}" "${script_file}" "${compatible_with_version}" "${ADD_PID_WRAPPER_KNOWN_VERSION_SONAME}" "${post_install_script}" "${pre_use_script}")
endmacro(add_PID_Wrapper_Known_Version)

#.rst:
#
# .. ifmode:: user
#
#  .. |PID_Wrapper_Configuration| replace:: ``PID_Wrapper_Configuration``
#  .. _PID_Wrapper_Configuration:
#
#  PID_Wrapper_Configuration
#  -------------------------
#
#   .. command:: PID_Wrapper_Configuration(CONFIGURATION ... [PLATFORM ...])
#
#   .. command:: declare_PID_Wrapper_Platform_Configuration(CONFIGURATION ... [PLATFORM ...])
#
#      Declare a platform configuration constraint for the current version of the external project being described.
#
#     .. rubric:: Required parameters
#
#     :CONFIGURATION <list of configurations>: tells which version of the external package is being wrapped. The version number must exactly match the name of the folder containing the CMakeLists.txt that does this call.
#
#     .. rubric:: Optional parameters
#
#     :PLATFORM <platform name>: Use to apply the configuration constraints only to the target platform.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - This function must be called in the CMakeList.txt file of a version folder after add_PID_Wrapper_Known_Version.
#
#     .. admonition:: Effects
#        :class: important
#
#         - Configure the check of a set of platform configurations that will be perfomed when the given wrapper version is built.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        PID_Wrapper_Configuration(CONFIGURATION posix)
#
macro(PID_Wrapper_Configuration)
  declare_PID_Wrapper_Platform_Configuration(${ARGN})
endmacro(PID_Wrapper_Configuration)

macro(declare_PID_Wrapper_Platform_Configuration)
set(options)
set(oneValueArgs PLATFORM)
set(multiValueArgs CONFIGURATION OPTIONAL)
cmake_parse_arguments(DECLARE_PID_WRAPPER_PLATFORM "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
if(NOT DECLARE_PID_WRAPPER_PLATFORM_CONFIGURATION AND NOT DECLARE_PID_WRAPPER_PLATFORM_OPTIONAL)
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, declare_PID_Wrapper_Platform requires at least to define a required configuration using CONFIGURATION keyword or an optional configuration using OPTIONAL keyword.")
	return()
endif()
declare_Wrapped_Configuration("${DECLARE_PID_WRAPPER_PLATFORM_PLATFORM}" "${DECLARE_PID_WRAPPER_PLATFORM_CONFIGURATION}" "${DECLARE_PID_WRAPPER_PLATFORM_OPTIONAL}")
endmacro(declare_PID_Wrapper_Platform_Configuration)

#.rst:
#
# .. ifmode:: user
#
#  .. |PID_Wrapper_Dependency| replace:: ``PID_Wrapper_Dependency``
#  .. _PID_Wrapper_Dependency:
#
#  PID_Wrapper_Dependency
#  ----------------------
#
#   .. command:: PID_Wrapper_Dependency([PACKAGE] ... [[EXACT] VERSION ...]...)
#
#   .. command:: declare_PID_Wrapper_External_Dependency([PACKAGE] ... [[EXACT] VERSION ...]...)
#
#     Declare a dependency between the currently described version of the external package and another external package.
#
#     .. rubric:: Required parameters
#
#     :[PACKAGE] <string>: defines the unique identifier of the required package. The keyword PACKAGE may be omitted if name is the first argument.
#
#     .. rubric:: Optional parameters
#
#     :VERSION <version string>: dotted notation of a version, representing which version of the external package is required. May be use many times.
#     :EXACT: use to specify if the following version must be exac. May be used for earch VERSION specification.
#     :COMPONENTS <list of components>: Used to specify which components of the required external package will be used by local components. If not specified there will be no check for the presence of specific components in the required package.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - This function must be called in the CMakeList.txt file of a version folder after add_PID_Wrapper_Known_Version.
#
#     .. admonition:: Effects
#        :class: important
#
#         - Register the target package as a dependency of the current package.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        PID_Wrapper_Dependency (PACKAGE boost EXACT VERSION 1.55.0 EXACT VERSION 1.63.0 EXACT VERSION 1.64.0)
#
macro(PID_Wrapper_Dependency)
  declare_PID_Wrapper_External_Dependency(${ARGN})
endmacro(PID_Wrapper_Dependency)

macro(declare_PID_Wrapper_External_Dependency)
set(options )
set(oneValueArgs PACKAGE)
set(multiValueArgs) #known versions of the external package that can be used to build/run it
cmake_parse_arguments(DECLARE_PID_WRAPPER_DEPENDENCY "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
if(NOT DECLARE_PID_WRAPPER_DEPENDENCY_PACKAGE)
  if("${ARGV0}" STREQUAL "" OR "${ARGV0}" MATCHES "^EXACT|VERSION$")
    finish_Progress(${GLOBAL_PROGRESS_VAR})
  	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, declare_PID_Wrapper_External_Dependency requires to define the name of the dependency by using PACKAGE keyword.")
  	return()
  endif()
  set(package_name ${ARGV0})
  if(DECLARE_PID_WRAPPER_DEPENDENCY_UNPARSED_ARGUMENTS)
    list(REMOVE_ITEM DECLARE_PID_WRAPPER_DEPENDENCY_UNPARSED_ARGUMENTS "${package_name}")
  endif()
else()
  set(package_name ${DECLARE_PID_WRAPPER_DEPENDENCY_PACKAGE})
endif()
if(package_name STREQUAL PROJECT_NAME)
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, package ${package_name} cannot require itself !")
	return()
endif()
set(list_of_versions)
set(exact_versions)
if(DECLARE_PID_WRAPPER_DEPENDENCY_UNPARSED_ARGUMENTS)#there are still arguments to parse
  set(TO_PARSE "${DECLARE_PID_WRAPPER_DEPENDENCY_UNPARSED_ARGUMENTS}")
	set(RES_VERSION TRUE)
	while(TO_PARSE AND RES_VERSION)
		parse_Package_Dependency_Version_Arguments("${TO_PARSE}" RES_VERSION RES_EXACT TO_PARSE)
		if(RES_VERSION)
			list(APPEND list_of_versions ${RES_VERSION})
			if(RES_EXACT)
				list(APPEND exact_versions ${RES_VERSION})
			endif()
		elseif(RES_EXACT)
      finish_Progress(${GLOBAL_PROGRESS_VAR})
			message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments when declaring dependency to external package ${package_name}, you must use the EXACT keyword together with the VERSION keyword.")
			return()
		endif()
	endwhile()
endif()
set(list_of_components)
if(TO_PARSE) #there are still expression to parse
	set(oneValueArgs)
	set(options)
	set(multiValueArgs COMPONENTS)
	cmake_parse_arguments(DECLARE_PID_WRAPPER_DEPENDENCY_MORE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${TO_PARSE})
	if(DECLARE_PID_WRAPPER_DEPENDENCY_MORE_COMPONENTS)
		list(LENGTH DECLARE_PID_WRAPPER_DEPENDENCY_COMPONENTS SIZE)
		if(SIZE LESS 1)
      finish_Progress(${GLOBAL_PROGRESS_VAR})
			message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments when declaring dependency to external package ${package_name}, at least one component dependency must be defined when using the COMPONENTS keyword.")
			return()
		endif()
		set(list_of_components ${DECLARE_PID_WRAPPER_DEPENDENCY_MORE_COMPONENTS})
	else()
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] WARNING : when declaring dependency to external package ${package_name}, unknown arguments used ${DECLARE_PID_WRAPPER_DEPENDENCY_MORE_UNPARSED_ARGUMENTS}.")
	endif()
endif()

declare_Wrapped_External_Dependency("${package_name}" "${list_of_versions}" "${exact_versions}" "${list_of_components}")
endmacro(declare_PID_Wrapper_External_Dependency)

#.rst:
#
# .. ifmode:: user
#
#  .. |PID_Wrapper_Component| replace:: ``PID_Wrapper_Component``
#  .. _PID_Wrapper_Component:
#
#  PID_Wrapper_Component
#  ---------------------
#
#   .. command:: PID_Wrapper_Component([COMPONENT] ... [OPTIONS])
#
#   .. command:: declare_PID_Wrapper_Component([COMPONENT] ... [OPTIONS])
#
#     Declare a new component for the current version of the external package.
#
#     .. rubric:: Required parameters
#
#     :[COMPONENT] <string w/o withespaces>: defines the unique identifier of the component. The COMPONENT keyword may be omnitted if name if the first argument.
#
#     .. rubric:: Optional parameters
#
#     :C_STANDARD <number of standard>: This argument is followed by the version of the C language standard to be used to build this component. The values may be 90, 99 or 11.
#     :CXX_STANDARD <number of standard>: This argument is followed by the version of the C++ language standard to be used to build this component. The values may be 98, 11, 14 or 17. If not specified the version 98 is used.
#     :SONAME <version number>: This argument allows to set the SONAME to use for that specific library instead of the default one.
#     :DEFINITIONS <defs>: These are the preprocessor definitions used in the component’s interface.
#     :INCLUDES <folders>: These are the include folder to pass to any component using the current component. Path are interpreted relative to the installed external package version root folder.
#     :SHARED_LINKS <links>: These are shared link flags. Path are interpreted relative to the installed external package version root folder.
#     :STATIC_LINKS <links>: These are static link flags. Path are interpreted relative to the installed external package version root folder.
#     :OPTIONS <compile options>: These are compiler options to be used whenever a third party code use this component. This should be used only for options bound to compiler usage, not definitions or include directories.
#     :RUNTIME_RESOURCES <list of path>: This argument is followed by a list of path relative to the installed external package version root folder.
#     :EXPORT ...: list of components that are exported by the declared component. Each element has the pattern [<package name>/]<component_name>.
#     :DEPEND ...: list of components that the declared component depends on. Each element has the pattern [<package name>/]<component_name>.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - Must be called in the CMakeList.txt file of a version folder after add_PID_Wrapper_Known_Version and before any call to declare_PID_Wrapper_Component_Dependency applied to the same declared component.
#
#     .. admonition:: Effects
#        :class: important
#
#         - Define a component for the current external package version, which is mainly usefull to register all compilation options relative to a component.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        PID_Wrapper_Component(COMPONENT libyaml INCLUDES include SHARED_LINKS ${posix_LINK_OPTIONS} lib/libyaml-cpp)
#
macro(PID_Wrapper_Component)
  declare_PID_Wrapper_Component(${ARGN})
endmacro(PID_Wrapper_Component)

macro(declare_PID_Wrapper_Component)
set(oneValueArgs COMPONENT C_STANDARD CXX_STANDARD SONAME)
set(multiValueArgs INCLUDES SHARED_LINKS STATIC_LINKS DEFINITIONS OPTIONS RUNTIME_RESOURCES EXPORT DEPEND) #known versions of the external package that can be used to build/run it
cmake_parse_arguments(DECLARE_PID_WRAPPER_COMPONENT "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
if(NOT DECLARE_PID_WRAPPER_COMPONENT_COMPONENT)
  if("${ARGV0}" STREQUAL "" OR "${ARGV0}" MATCHES "^CXX_STANDARD|C_STANDARD|SONAME|INCLUDES|SHARED_LINKS|STATIC_LINKS|DEFINITIONS|OPTIONS|RUNTIME_RESOURCES$")
    finish_Progress(${GLOBAL_PROGRESS_VAR})
  	message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, declare_PID_Wrapper_Component requires to define the name of the component by using COMPONENT keyword.")
  	return()
  endif()
  set(component_name ${ARGV0})
else()
  set(component_name ${DECLARE_PID_WRAPPER_COMPONENT_COMPONENT})
endif()

declare_Wrapped_Component(${component_name}
  "${DECLARE_PID_WRAPPER_COMPONENT_SHARED_LINKS}"
  "${DECLARE_PID_WRAPPER_COMPONENT_SONAME}"
	"${DECLARE_PID_WRAPPER_COMPONENT_STATIC_LINKS}"
	"${DECLARE_PID_WRAPPER_COMPONENT_INCLUDES}"
	"${DECLARE_PID_WRAPPER_COMPONENT_DEFINITIONS}"
	"${DECLARE_PID_WRAPPER_COMPONENT_OPTIONS}"
	"${DECLARE_PID_WRAPPER_COMPONENT_C_STANDARD}"
	"${DECLARE_PID_WRAPPER_COMPONENT_CXX_STANDARD}"
	"${DECLARE_PID_WRAPPER_COMPONENT_RUNTIME_RESOURCES}")


#dealing with dependencies
if(DECLARE_PID_WRAPPER_COMPONENT_EXPORT)#exported dependencies
  foreach(dep IN LISTS DECLARE_PID_WRAPPER_COMPONENT_EXPORT)
    extract_Component_And_Package_From_Dependency_String(RES_COMP RES_PACK ${dep})
    if(RES_PACK)
      set(COMP_ARGS "${RES_COMP};PACKAGE;${RES_PACK}")
    else()
      set(COMP_ARGS ${RES_COMP})
    endif()
    declare_PID_Wrapper_Component_Dependency(COMPONENT ${component_name} EXPORT ${COMP_ARGS})
  endforeach()
endif()

if(DECLARE_PID_WRAPPER_COMPONENT_DEPEND)#non exported dependencies
  foreach(dep IN LISTS DECLARE_PID_WRAPPER_COMPONENT_DEPEND)
    extract_Component_And_Package_From_Dependency_String(RES_COMP RES_PACK ${dep})
    if(RES_PACK)
      set(COMP_ARGS "${RES_COMP};PACKAGE;${RES_PACK}")
    else()
      set(COMP_ARGS ${RES_COMP})
    endif()
    declare_PID_Wrapper_Component_Dependency(COMPONENT ${component_name} DEPEND ${COMP_ARGS})
    endforeach()
endif()

endmacro(declare_PID_Wrapper_Component)

#.rst:
#
# .. ifmode:: user
#
#  .. |PID_Wrapper_Component_Dependency| replace:: ``PID_Wrapper_Component_Dependency``
#  .. _PID_Wrapper_Component_Dependency:
#
#  PID_Wrapper_Component_Dependency
#  --------------------------------
#
#   .. command:: PID_Wrapper_Component_Dependency([COMPONENT] ... [OPTIONS])
#
#   .. command:: declare_PID_Wrapper_Component_Dependency([COMPONENT] ... [OPTIONS])
#
#     Declare a dependency for a component defined in the current version of the current external package.
#
#     .. rubric:: Required parameters
#
#     :[COMPONENT] <string w/o withespaces>: defines the unique identifier of the component for which a dependency is described. The keyword COMPONENT may be omitted if name is given as first argument.
#
#     .. rubric:: Optional parameters
#
#     :EXPORT: Tells whether the component exports the required dependency. Exporting means that the reference to the dependency is contained in its interface (header files). This can be only the case for libraries, not for applications.
#
#     :DEPEND: Tells whether the component depends on but do not export the required dependency. Exporting means that the reference to the dependency is contained in its interface (header files).
#
#     :[EXTERNAL] <dependency>: This is the name of the component whose component <name> depends on. EXTERNAL keyword may be omitted if EXPORT or DEPEND keyword are used.
#
#     :PACKAGE <name>: This is the name of the external package the dependency belongs to. This package must have been defined has a package dependency before this call. If this argument is not used, the dependency belongs to the current package (i.e. internal dependency).
#
#     :DEFINITIONS <definitions>:  List of definitions exported by the component. These definitions are supposed to be managed in the dependency's heaedr files, but are set by current component.
#
#     :INCLUDES <list of path>:  List of path to system include folders.
#
#     :LIBRARY_DIRS  <list of path>:   List of path to system libraries folders.
#
#     :SHARED_LINKS <list of link>:  List of shared system links.
#
#     :STATIC_LINKS  <list of link>:  List of static system links.
#
#     :OPTIONS  <list of options>:  List of compiler options to use when using a system library.
#
#     :RUNTIME_RESOURCES  <list of path>:  List of path to system runtime resource such as program for instance.
#
#     :C_STANDARD  <std number>: the C standard used by the dependency.
#
#     :CXX_STANDARD  <std number>: the C++ standard used by the dependency.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - Must be called in the CMakeList.txt file of a version folder after add_PID_Wrapper_Known_Version and after any call to declare_PID_Wrapper_Component applied to the same declared component.
#
#     .. admonition:: Effects
#        :class: important
#
#         -  Define and configure a dependency between a component in the current external package version and another component.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        PID_Wrapper_Component_Dependency(COMPONENT libyaml EXPORT EXTERNAL boost-headers PACKAGE boost)
#
macro(PID_Wrapper_Component_Dependency)
  declare_PID_Wrapper_Component_Dependency(${ARGN})
endmacro(PID_Wrapper_Component_Dependency)

macro(declare_PID_Wrapper_Component_Dependency)
set(target_component)
set(component_name)
set(options EXPORT DEPEND)
set(oneValueArgs COMPONENT EXTERNAL PACKAGE C_STANDARD CXX_STANDARD)
set(multiValueArgs INCLUDES LIBRARY_DIRS SHARED_LINKS STATIC_LINKS DEFINITIONS OPTIONS RUNTIME_RESOURCES)
cmake_parse_arguments(DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
if(NOT DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_COMPONENT)
  if(${ARGC} LESS 1 OR ${ARGV0} MATCHES "^EXPORT|DEPEND|EXTERNAL|PACKAGE|INCLUDES|LIBRARY_DIRS|SHARED_LINKS|STATIC_LINKS|DEFINITIONS|OPTIONS|C_STANDARD|CXX_STANDARD|RUNTIME_RESOURCES$")
    finish_Progress(${GLOBAL_PROGRESS_VAR})
    message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments, declare_PID_Wrapper_Component_Dependency requires to define the name of the declared component using the COMPONENT keyword or by giving the name as first argument.")
    return()
  endif()
  set(component_name ${ARGV0})
  if(DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_UNPARSED_ARGUMENTS)
    list(REMOVE_ITEM DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_UNPARSED_ARGUMENTS ${ARGV0})
  endif()
else()
  set(component_name ${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_COMPONENT})
endif()

if(DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_EXPORT AND DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_DEPEND)
  finish_Progress(${GLOBAL_PROGRESS_VAR})
  message(FATAL_ERROR "[PID] CRITICAL ERROR : bad arguments when calling declare_PID_Wrapper_Component_Dependency, EXPORT and DEPEND keywords cannot be used in same time.")
  return()
endif()

if(DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_EXPORT)
	set(exported TRUE)
else()
	set(exported FALSE)
endif()

if(DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_PACKAGE) #this is a dependency to another external package
	list(FIND ${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_DEPENDENCIES ${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_PACKAGE} INDEX)
	if(INDEX EQUAL -1)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : when calling declare_PID_Wrapper_Component_Dependency, the component ${component_name} depends on external package ${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_PACKAGE} that is not defined as a dependency of the current project.")
		return()
	endif()
	if(DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_EXTERNAL)

		declare_Wrapped_Component_Dependency_To_Explicit_Component(${component_name}
			${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_PACKAGE}
			${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_EXTERNAL}
			${exported}
			"${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_DEFINITIONS}"
		)
	else()#EXTERNAL keyword not used but it is optional
    if(DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_UNPARSED_ARGUMENTS
      AND (DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_EXPORT OR DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_DEPEND))

      list(GET DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_UNPARSED_ARGUMENTS 0 target_component)
      declare_Wrapped_Component_Dependency_To_Explicit_Component(${component_name}
  			${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_PACKAGE}
  			${target_component}
  			${exported}
  			"${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_DEFINITIONS}"
  		)
    else()
      declare_Wrapped_Component_Dependency_To_Implicit_Components(${component_name}
        ${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_PACKAGE} #everything exported by default
        "${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_INCLUDES}"
        "${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_SHARED_LINKS}"
        "${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_STATIC_LINKS}"
        "${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_DEFINITIONS}"
        "${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_OPTIONS}"
  			"${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_C_STANDARD}"
  			"${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_CXX_STANDARD}"
  			"${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_RUNTIME_RESOURCES}"
      )
    endif()
	endif()
else()#this is a dependency to another component defined in the same external package OR a dependency to system libraries
	if(DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_EXTERNAL) #if the signature contains EXTERNAL
    set(target_component ${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_EXTERNAL})
  else()
    if(DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_UNPARSED_ARGUMENTS
      AND (DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_EXPORT OR DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_DEPEND))

      list(GET DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_UNPARSED_ARGUMENTS 0 target_component)
    elseif(NOT DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_EXPORT AND NOT DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_DEPEND)
      #OK export or depends on nothing and no other info can help decide what the user wants
      finish_Progress(${GLOBAL_PROGRESS_VAR})
  		message(FATAL_ERROR "[PID] CRITICAL ERROR : when calling declare_PID_Wrapper_Component_Dependency, need to define the component used by ${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_COMPONENT}, by using the keyword EXTERNAL.")
  		return()
    endif()
	endif()
  if(target_component)
  	declare_Wrapped_Component_Internal_Dependency(${component_name}
  		${target_component}
  		${exported}
  		"${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_DEFINITIONS}"
  	)
  else()#no target component defined => it is a system dependency
    list(APPEND ALL_LINKS ${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_SHARED_LINKS} ${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_STATIC_LINKS})
    declare_Wrapped_Component_System_Dependency(${component_name}
      "${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_INCLUDES}"
      "${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_LIBRARY_DIRS}"
      "${ALL_LINKS}"
      "${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_DEFINITIONS}"
      "${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_OPTIONS}"
      "${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_C_STANDARD}"
      "${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_CXX_STANDARD}"
      "${DECLARE_PID_WRAPPER_COMPONENT_DEPENDENCY_RUNTIME_RESOURCES}"
    )
  endif()
endif()
endmacro(declare_PID_Wrapper_Component_Dependency)


#########################################################################################
######################## API to be used in deploy scripts ###############################
#########################################################################################

function(translate_Into_Options)
set(options)
set(oneValueArgs C_STANDARD CXX_STANDARD FLAGS)
set(multiValueArgs INCLUDES DEFINITIONS LIBRARY_DIRS)
cmake_parse_arguments(TRANSLATE_INTO_OPTION "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
if(NOT TRANSLATE_INTO_OPTION_FLAGS)
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : when calling translate_Into_Options, need to define the variable where to return flags by using the FLAGS keyword.")
	return()
endif()
set(result "")
if(TRANSLATE_INTO_OPTION_INCLUDES)
	foreach(an_include IN LISTS TRANSLATE_INTO_OPTION_INCLUDES)
		set(result "${result} -I${an_include}")
	endforeach()
endif()
if(TRANSLATE_INTO_OPTION_LIBRARY_DIRS)
	foreach(a_dir IN LISTS TRANSLATE_INTO_OPTION_LIBRARY_DIRS)
		set(result "${result} -L${a_dir}")
	endforeach()
endif()
if(TRANSLATE_INTO_OPTION_DEFINITIONS)
	foreach(a_def IN LISTS TRANSLATE_INTO_OPTION_DEFINITIONS)
		set(result "${result} -D${a_def}")
	endforeach()
endif()

if(TRANSLATE_INTO_OPTION_C_STANDARD OR TRANSLATE_INTO_OPTION_CXX_STANDARD)
	translate_Standard_Into_Option(RES_C_STD_OPT RES_CXX_STD_OPT "${TRANSLATE_INTO_OPTION_C_STANDARD}" "${TRANSLATE_INTO_OPTION_CXX_STANDARD}")
	if(RES_C_STD_OPT)
		set(result "${result} ${RES_C_STD_OPT}")
	endif()
	if(RES_CXX_STD_OPT)
		set(result "${result} ${RES_CXX_STD_OPT}")
	endif()
endif()
set(${TRANSLATE_INTO_OPTION_FLAGS} ${result} PARENT_SCOPE)
endfunction(translate_Into_Options)

#.rst:
#
# .. ifmode:: script
#
#  .. |get_External_Dependencies_Info| replace:: ``get_External_Dependencies_Info``
#  .. _get_External_Dependencies_Info:
#
#  get_External_Dependencies_Info
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
#   .. command:: get_External_Dependencies_Info([OPTIONS])
#
#     Allow to get info defined in description of the currenlty built version.
#
#     .. rubric:: Optional parameters
#
#     :PACKAGE <ext_package>: Target external package that is a dependency of the currently built package, for which we want specific information. Used as a filter to limit information to those relative to the dependency.
#     :ROOT <variable>: The variable passed as argument will be filled with the path to the dependency external package version. Must be used together with PACKAGE.
#     :OPTIONS <variable>: The variable passed as argument will be filled with compiler options for the external package version being built.
#     :INCLUDES <variable>: The variable passed as argument will be filled with include folders for the external package version being built.
#     :DEFINITIONS <variable>: The variable passed as argument will be filled with all definitions for the external package version being built.
#     :LINKS <variable>: The variable passed as argument will be filled with all path to librairies and linker options for the external package version being built.
#     :LIBRARY_DIRS <variable>: The variable passed as argument will be filled with all path to folders containing libraries.
#     :C_STANDARD <variable>: The variable passed as argument will be filled with the C language standard to use for the external package version, if any specified.
#     :CXX_STANDARD <variable>: The variable passed as argument will be filled with the CXX language standard to use for the external package version, if any specified.
#     :RESOURCES <variable>: The variable passed as argument will be filled with the runtime resources provided by external dependencies.
#     :FLAGS: option to get result of all preceeding arguments directly as compiler flags instead of CMake variables.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - Must be used in deploy scripts defined in a wrapper.
#
#     .. admonition:: Effects
#        :class: important
#
#         -  This function has no side effect but simply allow the wrapper build process to get some information about the package it is trying to build. Indeed, building an external package may require to have precise information about package description in order to use adequate compilation flags.
#
#     .. rubric:: Example
#
#     Example of deploy script used for the yaml-cpp wrapper:
#
#     .. code-block:: cmake
#
#        get_External_Dependencies_Info(INCLUDES all_includes)
#        execute_process(COMMAND ${CMAKE_COMMAND} -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${TARGET_INSTALL_DIR} -DBoost_INCLUDE_DIR=${all_includes} .. WORKING_DIRECTORY ${YAML_BUILD_DIR})
#
function(get_External_Dependencies_Info)
set(options FLAGS)
set(oneValueArgs PACKAGE ROOT C_STANDARD CXX_STANDARD OPTIONS INCLUDES DEFINITIONS LINKS LIBRARY_DIRS RESOURCES)
set(multiValueArgs)
cmake_parse_arguments(GET_EXTERNAL_DEPENDENCY_INFO "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

#build the version prefix using variables automatically configured in Build_PID_Wrapper script
#for cleaner description at next lines only
if(GET_EXTERNAL_DEPENDENCY_INFO_PACKAGE)
  set(prefix ${TARGET_EXTERNAL_PACKAGE}_KNOWN_VERSION_${TARGET_EXTERNAL_VERSION}_DEPENDENCY_${GET_EXTERNAL_DEPENDENCY_INFO_PACKAGE})
  set(dep_version ${${prefix}_VERSION_USED_FOR_BUILD})
  set(ext_package_root ${WORKSPACE_DIR}/external/${CURRENT_PLATFORM}/${GET_EXTERNAL_DEPENDENCY_INFO_PACKAGE}/${dep_version})
else()
  set(prefix ${TARGET_EXTERNAL_PACKAGE}_KNOWN_VERSION_${TARGET_EXTERNAL_VERSION})
endif()

if(GET_EXTERNAL_DEPENDENCY_INFO_ROOT)
	if(NOT GET_EXTERNAL_DEPENDENCY_INFO_PACKAGE)
    finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : when calling get_External_Dependency_Info, need to define the external package by using the keyword PACKAGE.")
		return()
	endif()
	set(${GET_EXTERNAL_DEPENDENCY_INFO_ROOT} ${ext_package_root} PARENT_SCOPE)
endif()

if(GET_EXTERNAL_DEPENDENCY_INFO_INCLUDES)
  if(GET_EXTERNAL_DEPENDENCY_INFO_FLAGS)
		translate_Into_Options(INCLUDES ${${prefix}_BUILD_INCLUDES} FLAGS RES_INCLUDES)
    if(RES_INCLUDES)
	    set(${GET_EXTERNAL_DEPENDENCY_INFO_INCLUDES} ${RES_INCLUDES} PARENT_SCOPE)
    else()
      set(${GET_EXTERNAL_DEPENDENCY_INFO_INCLUDES} "" PARENT_SCOPE)
    endif()
  else()
    if(${prefix}_BUILD_INCLUDES)
  	  set(${GET_EXTERNAL_DEPENDENCY_INFO_INCLUDES} ${${prefix}_BUILD_INCLUDES} PARENT_SCOPE)
    else()
      set(${GET_EXTERNAL_DEPENDENCY_INFO_INCLUDES} "" PARENT_SCOPE)
    endif()
	endif()
endif()

if(GET_EXTERNAL_DEPENDENCY_INFO_LIBRARY_DIRS)
	if(GET_EXTERNAL_DEPENDENCY_INFO_FLAGS)
		translate_Into_Options(LIBRARY_DIRS "${${prefix}_BUILD_LIB_DIRS}" FLAGS RES_LIB_DIRS)
    if(RES_LIB_DIRS)
	    set(${GET_EXTERNAL_DEPENDENCY_INFO_LIBRARY_DIRS} ${RES_LIB_DIRS} PARENT_SCOPE)
    else()
      set(${GET_EXTERNAL_DEPENDENCY_INFO_LIBRARY_DIRS} "" PARENT_SCOPE)
    endif()
  else()
    if(${prefix}_BUILD_LIB_DIRS)
	    set(${GET_EXTERNAL_DEPENDENCY_INFO_LIBRARY_DIRS} ${${prefix}_BUILD_LIB_DIRS} PARENT_SCOPE)
    else()
      set(${GET_EXTERNAL_DEPENDENCY_INFO_LIBRARY_DIRS} "" PARENT_SCOPE)
    endif()
	endif()
endif()

if(GET_EXTERNAL_DEPENDENCY_INFO_DEFINITIONS)
	if(GET_EXTERNAL_DEPENDENCY_INFO_FLAGS)
		translate_Into_Options(DEFINITIONS ${${prefix}_BUILD_DEFINITIONS} FLAGS RES_DEFS)
    if(RES_DEFS)
	    set(${GET_EXTERNAL_DEPENDENCY_INFO_DEFINITIONS} ${RES_DEFS} PARENT_SCOPE)
    else()
      set(${GET_EXTERNAL_DEPENDENCY_INFO_DEFINITIONS} "" PARENT_SCOPE)
    endif()
	else()
    if(${prefix}_BUILD_DEFINITIONS)
      set(${GET_EXTERNAL_DEPENDENCY_INFO_DEFINITIONS} ${${prefix}_BUILD_DEFINITIONS} PARENT_SCOPE)
    else()
      set(${GET_EXTERNAL_DEPENDENCY_INFO_DEFINITIONS} "" PARENT_SCOPE)
    endif()

	endif()
endif()

if(GET_EXTERNAL_DEPENDENCY_INFO_OPTIONS)
  if(${prefix}_BUILD_COMPILER_OPTIONS)
    set(${GET_EXTERNAL_DEPENDENCY_INFO_OPTIONS} ${${prefix}_BUILD_COMPILER_OPTIONS} PARENT_SCOPE)
  else()
    set(${GET_EXTERNAL_DEPENDENCY_INFO_OPTIONS} "" PARENT_SCOPE)
  endif()
endif()

if(GET_EXTERNAL_DEPENDENCY_INFO_C_STANDARD)
	if(GET_EXTERNAL_DEPENDENCY_INFO_FLAGS)
		translate_Into_Options(C_STANDARD ${${prefix}_BUILD_C_STANDARD} FLAGS RES_C_STD)
		set(${GET_EXTERNAL_DEPENDENCY_INFO_C_STANDARD} ${RES_C_STD} PARENT_SCOPE)
	else()
	  set(${GET_EXTERNAL_DEPENDENCY_INFO_C_STANDARD} ${${prefix}_BUILD_C_STANDARD} PARENT_SCOPE)
	endif()
endif()

if(GET_EXTERNAL_DEPENDENCY_INFO_CXX_STANDARD)
	if(GET_EXTERNAL_DEPENDENCY_INFO_FLAGS)
		translate_Into_Options(CXX_STANDARD ${${prefix}_BUILD_CXX_STANDARD} FLAGS RES_CXX_STD)
		set(${GET_EXTERNAL_DEPENDENCY_INFO_CXX_STANDARD} ${RES_CXX_STD} PARENT_SCOPE)
	else()
	  set(${GET_EXTERNAL_DEPENDENCY_INFO_CXX_STANDARD} ${${prefix}_BUILD_CXX_STANDARD} PARENT_SCOPE)
	endif()
endif()

if(GET_EXTERNAL_DEPENDENCY_INFO_LINKS)
  if(${prefix}_BUILD_LINKS)
    set(${GET_EXTERNAL_DEPENDENCY_INFO_LINKS} ${${prefix}_BUILD_LINKS} PARENT_SCOPE)
  else()
    set(${GET_EXTERNAL_DEPENDENCY_INFO_LINKS} "" PARENT_SCOPE)
  endif()
endif()

if(GET_EXTERNAL_DEPENDENCY_INFO_RESOURCES)
  if(${prefix}_BUILD_RUNTIME_RESOURCES)
    set(${GET_EXTERNAL_DEPENDENCY_INFO_RESOURCES} ${${prefix}_BUILD_RUNTIME_RESOURCES} PARENT_SCOPE)
  else()
    set(${GET_EXTERNAL_DEPENDENCY_INFO_RESOURCES} "" PARENT_SCOPE)
  endif()
endif()

endfunction(get_External_Dependencies_Info)

#.rst:
#
# .. ifmode:: script
#
#  .. |get_User_Option_Info| replace:: ``get_User_Option_Info``
#  .. _get_User_Option_Info:
#
#  get_User_Option_Info
#  ^^^^^^^^^^^^^^^^^^^^
#
#   .. command:: get_User_Option_Info(OPTION ... RESULT ...)
#
#     Allow to get info defined and set by user of the wrapper into deploy script when a wrapper version is built.
#
#     .. rubric:: Required parameters
#
#     :OPTION <variable>: Target option we need to get the value into the deploy script.
#     :RESULT <returned variable>: The variable passed as argument will be filled with the value of the target user option's value.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - Must be used in deploy scripts defined in a wrapper.
#
#     .. admonition:: Effects
#        :class: important
#
#         -  This function has no side effect but simply allow the wrapper build process to get some information about the package it is trying to build. Indeed, building an external package may require additional configuration from the user in order to use adequate compilation flags.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        get_User_Option_Info(OPTION BUILD_WITH_CUDA_SUPPORT RESULT using_cuda)
#        if(using_cuda)
#          build_process_using_CUDA(...)
#        else()
#          build_process_without_CUDA(...)
#        endif()
#
function(get_User_Option_Info)
set(oneValueArgs OPTION RESULT)
cmake_parse_arguments(GET_USER_OPTION_INFO "" "${oneValueArgs}" "" ${ARGN} )
if(NOT GET_USER_OPTION_INFO_OPTION)
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : when calling get_User_Option_Info, need to define the name of the option by using the keyword OPTION.")
	return()
endif()
if(NOT GET_USER_OPTION_INFO_RESULT)
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : when calling get_User_Option_Info, need to define the variable that will receive the value of the option by using the keyword RESULT.")
	return()
endif()
if(NOT ${TARGET_EXTERNAL_PACKAGE}_USER_OPTIONS)
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : when calling get_User_Option_Info, no user option is defined in the wrapper ${TARGET_EXTERNAL_PACKAGE}.")
	return()
endif()
list(FIND ${TARGET_EXTERNAL_PACKAGE}_USER_OPTIONS ${GET_USER_OPTION_INFO_OPTION} INDEX)
if(INDEX EQUAL -1)
  finish_Progress(${GLOBAL_PROGRESS_VAR})
	message(FATAL_ERROR "[PID] CRITICAL ERROR : when calling get_User_Option_Info, no user option with name ${GET_USER_OPTION_INFO_OPTION} is defined in the wrapper ${TARGET_EXTERNAL_PACKAGE}.")
	return()
endif()
set(${GET_USER_OPTION_INFO_RESULT} ${${TARGET_EXTERNAL_PACKAGE}_USER_OPTION_${GET_USER_OPTION_INFO_OPTION}_VALUE} PARENT_SCOPE)
endfunction(get_User_Option_Info)

#.rst:
#
# .. ifmode:: script
#
#  .. |get_Environment_Info| replace:: ``get_Environment_Info``
#  .. _get_Environment_Info:
#
#  get_Environment_Info
#  ^^^^^^^^^^^^^^^^^^^^
#
#   .. command:: get_Environment_Info([JOBS ...] [MAKE...])
#
#   .. command:: get_Environment_Info(C|CXX|ASM [RELEASE|DEBUG] [CFLAGS...] [COMPILER ...] [AR ...] [LINKER...] [RANLIB...])
#
#   .. command:: get_Environment_Info(MODULE|SHARED|STATIC|EXE LDFLAGS...)
#
#     Getting all options and flags (compiler in use, basic flags for each type of component, and so on) defined by the current environment, to be able to access them in the deploy script.
#
#     .. rubric:: Optional parameters
#
#     :C|CXX|ASM: Specifies the type of information to get.
#     :MODULE|SHARED|STATIC|EXE: Specifies the type of binary to link.
#     :RELEASE|DEBUG: Used to specify which kind of flags you want (RELEASE by default)
#     :CFLAGS ...: the output variable that contains the list of compilation flags used for specified compilation (e.g. C and DEBUG)
#     :LDFLAGS ...: the output variable that contains the list of linker flags used for specified compilation (e.g. SHARED)
#     :COMPILER <path>: the output variable that contains the path to the compiler used for specified compilation (e.g. C++ compiler)
#     :AR <path>: the output variable that contains the path to the ar tool.
#     :LINKER <path>: the output variable that contains the path to the linker.
#     :RANLIB <path>: the output variable that contains the path to the ranlib tool.
#     :JOBS flag: the output variable that contains the flag used for parallel build.
#     :MAKE <path>: the output variable that contains the path to the make tool.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - Must be used in deploy scripts defined in a wrapper.
#
#     .. admonition:: Effects
#        :class: important
#
#         -  This function has no side effect but simply allow the wrapper build process to get some information about the package it is trying to build.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        get_Environment_Info(MAKE make_tool JOBS jobs-flag
#                            CXX COMPILER compiler_used CFLAGS compile_flags
#                            SHARED LDFLAGS linker_flags)
#
#
function(get_Environment_Info)
  set(options MODULE SHARED STATIC EXE DEBUG RELEASE C CXX ASM) #used to define the context
  set(oneValueArgs COMPILER AR LINKER MAKE RANLIB JOBS JOBS_NUMBER OBJDUMP OBJCOPY NM) #returned values conditionned by options
  set(multiValueArgs CFLAGS LDFLAGS) #returned values conditionned by options
  cmake_parse_arguments(GET_ENVIRONMENT_INFO "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  #returning flag to use with make tool
  if(GET_ENVIRONMENT_INFO_JOBS)
    include(ProcessorCount)
    ProcessorCount(NUMBER_OF_JOBS)
    math(EXPR NUMBER_OF_JOBS "${NUMBER_OF_JOBS}+1")
    if(${NUMBER_OF_JOBS} GREATER 1)
    	set(${GET_ENVIRONMENT_INFO_JOBS} "-j${NUMBER_OF_JOBS}" PARENT_SCOPE)
    else()
    	set(${GET_ENVIRONMENT_INFO_JOBS} "" PARENT_SCOPE)
    endif()
  endif()

  if(GET_ENVIRONMENT_INFO_JOBS_NUMBER)
    include(ProcessorCount)
    ProcessorCount(NUMBER_OF_JOBS)
    math(EXPR NUMBER_OF_JOBS "${NUMBER_OF_JOBS}+1")
    if(${NUMBER_OF_JOBS} GREATER 1)
      set(${GET_ENVIRONMENT_INFO_JOBS_NUMBER} ${NUMBER_OF_JOBS} PARENT_SCOPE)
    endif()
  endif()

  #returning info about tools in use (usefull when crosscompiling for instance)
  if(GET_ENVIRONMENT_INFO_COMPILER)
    if(GET_ENVIRONMENT_INFO_C)
      set(${GET_ENVIRONMENT_INFO_COMPILER} ${CMAKE_C_COMPILER} PARENT_SCOPE)
    elseif(GET_ENVIRONMENT_INFO_CXX)
      set(${GET_ENVIRONMENT_INFO_COMPILER} ${CMAKE_CXX_COMPILER} PARENT_SCOPE)
    elseif(GET_ENVIRONMENT_INFO_ASM)
      set(${GET_ENVIRONMENT_INFO_COMPILER} ${CMAKE_ASM_COMPILER} PARENT_SCOPE)
    else()
      message(FATAL_ERROR "[PID] CRITICAL ERROR : When trying to get compiler in use you must specify the target language (C, CXX or ASM).")
    	return()
    endif()
  endif()
  if(GET_ENVIRONMENT_INFO_AR)
    set(${GET_ENVIRONMENT_INFO_AR} ${CMAKE_AR} PARENT_SCOPE)
  endif()
  if(GET_ENVIRONMENT_INFO_LINKER)
    set(${GET_ENVIRONMENT_INFO_LINKER} ${CMAKE_LINKER} PARENT_SCOPE)
  endif()
  if(GET_ENVIRONMENT_INFO_RANLIB)
    set(${GET_ENVIRONMENT_INFO_RANLIB} ${CMAKE_RANLIB} PARENT_SCOPE)
  endif()
  if(GET_ENVIRONMENT_INFO_MAKE)
    set(${GET_ENVIRONMENT_INFO_MAKE} ${CMAKE_MAKE_PROGRAM} PARENT_SCOPE)
  endif()
  if(GET_ENVIRONMENT_INFO_OBJDUMP)
    set(${GET_ENVIRONMENT_INFO_RANLIB} ${CMAKE_OBJDUMP} PARENT_SCOPE)
  endif()
  if(GET_ENVIRONMENT_INFO_OBJCOPY)
    set(${GET_ENVIRONMENT_INFO_MAKE} ${CMAKE_OBJCOPY} PARENT_SCOPE)
  endif()
  if(GET_ENVIRONMENT_INFO_NM)
    set(${GET_ENVIRONMENT_INFO_MAKE} ${CMAKE_NM} PARENT_SCOPE)
  endif()

  if(GET_ENVIRONMENT_INFO_CFLAGS)
    if(GET_ENVIRONMENT_INFO_C)
      set(list_of_flags ${CMAKE_C_FLAGS})
      set(is_cxx FALSE)
    elseif(GET_ENVIRONMENT_INFO_CXX)
      set(is_cxx TRUE)
      set(list_of_flags ${CMAKE_CXX_FLAGS})
    else()
      message(FATAL_ERROR "[PID] CRITICAL ERROR : When trying to get CFLAGS in use you must specify the target language (C, CXX).")
      return()
    endif()
    if(NOT GET_ENVIRONMENT_INFO_DEBUG OR GET_ENVIRONMENT_INFO_RELEASE)
      if(is_cxx)
        list(APPEND list_of_flags ${CMAKE_CXX_FLAGS_RELEASE})
      else()
        list(APPEND list_of_flags ${CMAKE_C_FLAGS_RELEASE})
      endif()
    else()
      if(is_cxx)
        list(APPEND list_of_flags ${CMAKE_CXX_FLAGS_DEBUG})
      else()
        list(APPEND list_of_flags ${CMAKE_C_FLAGS_DEBUG})
      endif()
    endif()
    fill_String_From_List(list_of_flags cflags_string)
    set(${GET_ENVIRONMENT_INFO_CFLAGS} "${cflags_string}" PARENT_SCOPE)
  endif() #end for c flags

  if(GET_ENVIRONMENT_INFO_LDFLAGS)#now flags for the linker
    if(GET_ENVIRONMENT_INFO_RELEASE OR NOT GET_ENVIRONMENT_INFO_DEBUG)
      set(suffix _RELEASE)
    else()
      set(suffix _DEBUG)
    endif()
    if(GET_ENVIRONMENT_INFO_MODULE)
      set(ldflags_list ${CMAKE_MODULE_LINKER_FLAGS})
      list(APPEND ldflags_list ${CMAKE_MODULE_LINKER_FLAGS${suffix}})
      fill_String_From_List(ldflags_list ldflags_string)
      set(${GET_ENVIRONMENT_INFO_LDFLAGS} "${ldflags_string}" PARENT_SCOPE)
    elseif(GET_ENVIRONMENT_INFO_SHARED)
      set(ldflags_list ${CMAKE_SHARED_LINKER_FLAGS})
      list(APPEND ldflags_list ${CMAKE_SHARED_LINKER_FLAGS${suffix}})
      fill_String_From_List(ldflags_list ldflags_string)
      set(${GET_ENVIRONMENT_INFO_LDFLAGS} "${ldflags_string}" PARENT_SCOPE)
    elseif(GET_ENVIRONMENT_INFO_STATIC)
      set(ldflags_list ${CMAKE_STATIC_LINKER_FLAGS})
      list(APPEND ldflags_list ${CMAKE_STATIC_LINKER_FLAGS${suffix}})
      fill_String_From_List(ldflags_list ldflags_string)
      set(${GET_ENVIRONMENT_INFO_LDFLAGS} "${ldflags_string}" PARENT_SCOPE)
    elseif(GET_ENVIRONMENT_INFO_EXE)
      set(ldflags_list ${CMAKE_EXE_LINKER_FLAGS})
      list(APPEND ldflags_list ${CMAKE_EXE_LINKER_FLAGS${suffix}})
      fill_String_From_List(ldflags_list ldflags_string)
      set(${GET_ENVIRONMENT_INFO_LDFLAGS} "${ldflags_string}" PARENT_SCOPE)
    else()
      message(FATAL_ERROR "[PID] CRITICAL ERROR : When trying to get LDFLAGS in use you must specify the kind of component you try to build (MODULE, SHARED, STATIC or EXE).")
    	return()
    endif()
  endif()
endfunction(get_Environment_Info)


#.rst:
# .. ifmode:: script
#
#  .. |get_Target_Platform_Info| replace:: ``get_Target_Platform_Info``
#  .. _get_Target_Platform_Info:
#
#  get_Target_Platform_Info
#  ^^^^^^^^^^^^^^^^^^^^^^^^
#
#  .. command:: get_Target_Platform_Info([OPTIONS])
#
#   Get information about the target platform. This can be used to configure the build accordingly.
#
#   .. rubric:: Optional parameters
#
#   All arguments are optional but at least one must be provided. All properties are retrieved for the target platform.
#
#   :NAME <VAR>: Output the name of the target platform in ``VAR``
#   :TYPE <VAR>: Ouptut the processor type in ``VAR``
#   :OS <VAR>: Output the OS name in ``VAR``
#   :ARCH <VAR>: Output the architecture in ``VAR``
#   :ABI <VAR>: Output the ABI in ``VAR``
#   :DISTRIBUTION <VAR>: Output the distribution in ``VAR``
#   :PYTHON <VAR>: Output the Python version in ``VAR``
#
#   .. admonition:: Effects
#     :class: important
#
#     After the call, the variables defined by the user will be set to the corresponding value. Then it can be used to control the configuration of the package.
#
#   .. rubric:: Example
#
#   .. code-block:: cmake
#
#      get_Target_Platform_Info(OS curr_os ARCH curr_proc ABI curr_abi TYPE curr_proc_type)
#      message("curr_os=${curr_os}")
#
function(get_Target_Platform_Info)
set(oneValueArgs NAME OS ARCH ABI TYPE PYTHON DISTRIBUTION VERSION)
cmake_parse_arguments(GET_TARGET_PLATFORM_INFO "" "${oneValueArgs}" "" ${ARGN} )
set(OK FALSE)
if(GET_TARGET_PLATFORM_INFO_NAME)
	set(OK TRUE)
	set(${GET_TARGET_PLATFORM_INFO_NAME} ${CURRENT_PLATFORM} PARENT_SCOPE)
endif()
if(GET_TARGET_PLATFORM_INFO_TYPE)
	set(OK TRUE)
	set(${GET_TARGET_PLATFORM_INFO_TYPE} ${CURRENT_PLATFORM_TYPE} PARENT_SCOPE)
endif()
if(GET_TARGET_PLATFORM_INFO_OS)
	set(OK TRUE)
	set(${GET_TARGET_PLATFORM_INFO_OS} ${CURRENT_PLATFORM_OS} PARENT_SCOPE)
endif()
if(GET_TARGET_PLATFORM_INFO_ARCH)
	set(OK TRUE)
	set(${GET_TARGET_PLATFORM_INFO_ARCH} ${CURRENT_PLATFORM_ARCH} PARENT_SCOPE)
endif()
if(GET_TARGET_PLATFORM_INFO_ABI)
	set(OK TRUE)
  if(CURRENT_PLATFORM_ABI STREQUAL "abi11")
    set(${GET_TARGET_PLATFORM_INFO_ABI} CXX11 PARENT_SCOPE)
  elseif(CURRENT_PLATFORM_ABI STREQUAL "abi98")
    set(${GET_TARGET_PLATFORM_INFO_ABI} CXX PARENT_SCOPE)
  endif()
endif()
if(GET_TARGET_PLATFORM_INFO_PYTHON)
		set(OK TRUE)
		set(${GET_TARGET_PLATFORM_INFO_PYTHON} ${CURRENT_PYTHON} PARENT_SCOPE)
endif()
if(GET_TARGET_PLATFORM_INFO_DISTRIBUTION)
		set(OK TRUE)
		set(${GET_TARGET_PLATFORM_INFO_DISTRIBUTION} ${CURRENT_DISTRIBUTION} PARENT_SCOPE)
endif()
if(GET_TARGET_PLATFORM_INFO_DISTRIBUTION_VERSION)
		set(OK TRUE)
		set(${GET_TARGET_PLATFORM_INFO_DISTRIBUTION_VERSION} ${CURRENT_DISTRIBUTION_VERSION} PARENT_SCOPE)
endif()
if(NOT OK)
	message("[PID] ERROR : you must use one or more of the NAME, TYPE, ARCH, OS or ABI keywords together with corresponding variables that will contain the resulting property of the current platform in use.")
endif()
endfunction(get_Target_Platform_Info)

#.rst:
#
# .. ifmode:: script
#
#  .. |install_External_Project| replace:: ``install_External_Project``
#  .. _install_External_Project:
#
#  install_External_Project
#  ^^^^^^^^^^^^^^^^^^^^^^^^
#
#   .. command:: install_External_Project(URL ... ARCHIVE|GIT_CLONE_COMMIT ... FOLDER ... PATH ... [OPTIONS])
#
#     Download and install the given archive and returns the path to the installed project.
#
#     .. rubric:: Required parameters
#
#     :URL <url>: The URL from where to download the archive.
#     :ARCHIVE|GIT_CLONE_COMMIT <string>: The name of the archive downloaded or the identifier of the commit to checkout to. Both keyword ARCHIVE and GIT_CLONE_COMMIT are exclusive.
#     :FOLDER <string>: The folder resulting from archive extraction.
#
#     .. rubric:: Optional parameters
#
#     :PATH <path>: the output variable that contains the path to the installed project, empty if project cannot be installed
#     :PROJECT <string>: the name of the project if you want to generate nice outputs about external package install process
#     :VERSION <version string>: the version of the external project that is installed, only usefull together with PROJECT keyword.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - Must be used in deploy scripts defined in a wrapper.
#
#     .. admonition:: Effects
#        :class: important
#
#         -  This function is used to download and install the archive of an external project.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        install_External_Project( PROJECT yaml-cpp
#                          VERSION 0.6.2
#                          URL https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.2.tar.gz
#                          ARCHIVE yaml-cpp-0.6.2.tar.gz
#                          FOLDER yaml-cpp-yaml-cpp-0.6.2)
#
#
function(install_External_Project)
  set(options) #used to define the context
  set(oneValueArgs PROJECT VERSION URL ARCHIVE GIT_CLONE_COMMIT FOLDER PATH)
  set(multiValueArgs)
  cmake_parse_arguments(INSTALL_EXTERNAL_PROJECT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
  if(NOT INSTALL_EXTERNAL_PROJECT_URL OR (NOT INSTALL_EXTERNAL_PROJECT_GIT_CLONE_COMMIT AND NOT INSTALL_EXTERNAL_PROJECT_ARCHIVE) OR NOT INSTALL_EXTERNAL_PROJECT_FOLDER)
    if(INSTALL_EXTERNAL_PROJECT_PATH)
      set(${INSTALL_EXTERNAL_PROJECT_PATH} PARENT_SCOPE)
    endif()
    set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
    message(FATAL_ERROR "[PID] CRITICAL ERROR : PATH, URL, ARCHIVE (or GIT_CLONE_COMMIT) and FOLDER arguments must be provided to install_External_Project.")
    return()
  endif()

  if(INSTALL_EXTERNAL_PROJECT_GIT_CLONE_COMMIT AND INSTALL_EXTERNAL_PROJECT_ARCHIVE)
    set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
    message(FATAL_ERROR "[PID] CRITICAL ERROR : ARCHIVE and GIT_CLONE_COMMIT arguments are exclusive.")
    return()
  endif()

  if(INSTALL_EXTERNAL_PROJECT_VERSION)
    set(version_str " version ${INSTALL_EXTERNAL_PROJECT_VERSION}")
  else()
    set(version_str)
  endif()
  #check that the build dir has not been deleted
  if(NOT EXISTS ${TARGET_BUILD_DIR})
    execute_process(COMMAND ${CMAKE_COMMAND} .. WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
  endif()

  if(INSTALL_EXTERNAL_PROJECT_ARCHIVE)
    if(NOT EXISTS ${TARGET_BUILD_DIR}/${INSTALL_EXTERNAL_PROJECT_ARCHIVE})
      if(INSTALL_EXTERNAL_PROJECT_PROJECT)
        message("[PID] INFO : Downloading ${INSTALL_EXTERNAL_PROJECT_PROJECT}${version_str} ...")
      endif()
      file(DOWNLOAD ${INSTALL_EXTERNAL_PROJECT_URL} ${TARGET_BUILD_DIR}/${INSTALL_EXTERNAL_PROJECT_ARCHIVE} SHOW_PROGRESS)
    endif()

    if(NOT EXISTS ${TARGET_BUILD_DIR}/${INSTALL_EXTERNAL_PROJECT_ARCHIVE})
      if(INSTALL_EXTERNAL_PROJECT_PROJECT)
        message("[PID] ERROR : During deployment of ${INSTALL_EXTERNAL_PROJECT_PROJECT}${version_str}, cannot download the archive.")
      endif()
      if(INSTALL_EXTERNAL_PROJECT_PATH)
        set(${INSTALL_EXTERNAL_PROJECT_PATH} PARENT_SCOPE)
      endif()
      set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
      return()
    endif()

    #cleaning the already extracted folder
    if(EXISTS ${TARGET_BUILD_DIR}/${INSTALL_EXTERNAL_PROJECT_FOLDER})
      file(REMOVE_RECURSE ${TARGET_BUILD_DIR}/${INSTALL_EXTERNAL_PROJECT_FOLDER})
    endif()

    if(INSTALL_EXTERNAL_PROJECT_PROJECT)
      message("[PID] INFO : Extracting ${INSTALL_EXTERNAL_PROJECT_PROJECT}${version_str} ...")
    endif()
    execute_process(
      COMMAND ${CMAKE_COMMAND} -E tar xf ${INSTALL_EXTERNAL_PROJECT_ARCHIVE}
      WORKING_DIRECTORY ${TARGET_BUILD_DIR}
    )
  elseif(INSTALL_EXTERNAL_PROJECT_GIT_CLONE_COMMIT)
    if(EXISTS ${TARGET_BUILD_DIR}/${INSTALL_EXTERNAL_PROJECT_FOLDER})
      file(REMOVE_RECURSE ${TARGET_BUILD_DIR}/${INSTALL_EXTERNAL_PROJECT_FOLDER})
    endif()

    if(INSTALL_EXTERNAL_PROJECT_PROJECT)
      message("[PID] INFO : Cloning ${INSTALL_EXTERNAL_PROJECT_PROJECT} with commit ${INSTALL_EXTERNAL_PROJECT_GIT_CLONE_COMMIT} ...")
    endif()
    execute_process(
      COMMAND git clone ${INSTALL_EXTERNAL_PROJECT_URL}
      WORKING_DIRECTORY ${TARGET_BUILD_DIR}
    )
    execute_process(
      COMMAND git checkout ${INSTALL_EXTERNAL_PROJECT_GIT_CLONE_COMMIT}
      WORKING_DIRECTORY ${TARGET_BUILD_DIR}/${INSTALL_EXTERNAL_PROJECT_FOLDER}
    )
  endif()

  #check that the extract went well
  if(NOT EXISTS ${TARGET_BUILD_DIR}/${INSTALL_EXTERNAL_PROJECT_FOLDER}
      OR NOT IS_DIRECTORY ${TARGET_BUILD_DIR}/${INSTALL_EXTERNAL_PROJECT_FOLDER})
    if(INSTALL_EXTERNAL_PROJECT_PROJECT)
      if(INSTALL_EXTERNAL_PROJECT_ARCHIVE)
        message("[PID] ERROR : during deployment of ${INSTALL_EXTERNAL_PROJECT_PROJECT}${version_str}, cannot extract the archive.")
      elseif(INSTALL_EXTERNAL_PROJECT_GIT_CLONE_COMMIT)
        message("[PID] ERROR : during cloning of ${INSTALL_EXTERNAL_PROJECT_PROJECT}, cannot extract the archive.")
      endif()
    endif()
    if(INSTALL_EXTERNAL_PROJECT_PATH)
      set(${INSTALL_EXTERNAL_PROJECT_PATH} PARENT_SCOPE)
    endif()
    set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
    return()
  endif()

  #simply resturn true at the end if required by the user
if(INSTALL_EXTERNAL_PROJECT_PATH)
  set(${INSTALL_EXTERNAL_PROJECT_PATH} ${TARGET_BUILD_DIR}/${INSTALL_EXTERNAL_PROJECT_FOLDER} PARENT_SCOPE)
endif()
endfunction(install_External_Project)


#.rst:
#
# .. ifmode:: script
#
#  .. |execute_OS_Command| replace:: ``execute_OS_Command``
#  .. _execute_OS_Command:
#
#  execute_OS_Command
#  ^^^^^^^^^^^^^^^^^^
#
#   .. command:: execute_OS_Command(...)
#
#      invoque a command of the operating system with adequate privileges.
#
#     .. rubric:: Required parameters
#
#     :...: the commands to be passed (do not use sudo !)
#
#     .. admonition:: Effects
#        :class: important
#
#        Execute the command with adequate privileges .
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        execute_OS_Command(apt-get install -y libgtk2.0-dev libgtkmm-2.4-dev)
#
macro(execute_OS_Command)
if(IN_CI_PROCESS)
  execute_process(COMMAND ${ARGN})
else()
  execute_process(COMMAND sudo ${ARGN})#need to have super user privileges except in CI where sudo is forbidden
endif()
endmacro(execute_OS_Command)

#.rst:
#
# .. ifmode:: script
#
#  .. |return_External_Project_Error| replace:: ``return_External_Project_Error``
#  .. _return_External_Project_Error:
#
#  return_External_Project_Error
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
#   .. command:: return_External_Project_Error()
#
#     Make the current wrapper script to return an error.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - Must be used in deploy scripts defined in a wrapper.
#
#     .. admonition:: Effects
#        :class: important
#
#         -  generates an error code for the current deploy script.
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#         return_External_Project_Error()
#
function(return_External_Project_Error)
  set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
endfunction(return_External_Project_Error)

#.rst:
#
# .. ifmode:: script
#
#  .. |build_B2_External_Project| replace:: ``build_B2_External_Project``
#  .. _build_B2_External_Project:
#
#  build_B2_External_Project
#  ^^^^^^^^^^^^^^^^^^^^^^^^^
#
#   .. command:: build_B2_External_Project(PROJECT ... FOLDER ... MODE ... [OPTIONS])
#
#     Configure, build and install an external project defined with Boost build.
#
#     .. rubric:: Required parameters
#
#     :PROJECT <string>: The name of the external project.
#     :FOLDER <string>: The name of the folder containing the project.
#     :MODE <Release|Debug>: The build mode.
#
#     .. rubric:: Optional parameters
#
#     :QUIET: if used then the output of this command will be silent.
#     :COMMENT <string>: A string to append to message to inform about special thing you are doing. Usefull if you intend to buildmultiple time the same external project with different options.
#     :DEFINITIONS <list of definitions>: the CMake definitions you need to provide to the cmake build script.
#     :WITH <list of libraries>: Libraries to be included in the build
#     :WITHOUT <list of libraries>: Libraries to be excluded from the build
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - Must be used in deploy scripts defined in a wrapper.
#
#     .. admonition:: Effects
#        :class: important
#
#         -  Build and install the external project into workspace install tree..
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#         build_B2_External_Project(PROJECT boost FOLDER boost_1_64_0 MODE Release)
#
function(build_B2_External_Project)
  if(ERROR_IN_SCRIPT)
    return()
  endif()
  set(options QUIET) #used to define the context
  set(oneValueArgs PROJECT FOLDER MODE COMMENT USER_JOBS)
  set(multiValueArgs DEFINITIONS INCLUDES LINKS WITH WITHOUT)
  cmake_parse_arguments(BUILD_B2_EXTERNAL_PROJECT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
  if(NOT BUILD_B2_EXTERNAL_PROJECT_PROJECT OR NOT BUILD_B2_EXTERNAL_PROJECT_FOLDER OR NOT BUILD_B2_EXTERNAL_PROJECT_MODE)
    message(FATAL_ERROR "[PID] CRITICAL ERROR : PROJECT, FOLDER and MODE arguments are mandatory when calling build_B2_External_Project.")
    return()
  endif()

  if(BUILD_B2_EXTERNAL_PROJECT_QUIET)
    set(OUTPUT_MODE OUTPUT_QUIET)
  endif()


  if(BUILD_B2_EXTERNAL_PROJECT_COMMENT)
    set(use_comment "(${BUILD_B2_EXTERNAL_PROJECT_COMMENT}) ")
  endif()

  #create the build folder inside the project folder
  set(project_dir ${TARGET_BUILD_DIR}/${BUILD_B2_EXTERNAL_PROJECT_FOLDER})
  if(NOT EXISTS ${project_dir})
    set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
    message("[PID] ERROR : when calling build_B2_External_Project  the build folder specified (${BUILD_B2_EXTERNAL_PROJECT_FOLDER}) does not exist.")
    return()
  endif()

  # preparing b2 invocation parameters
  #configure build mode (to get available parameters see https://boostorg.github.io/build/tutorial.html section "Feature reference")
  if(BUILD_B2_EXTERNAL_PROJECT_MODE STREQUAL Debug)
      set(ARGS_FOR_B2_BUILD "variant=debug")
  else()
      set(ARGS_FOR_B2_BUILD "variant=release")
  endif()
  # configure current platform
  set(ARGS_FOR_B2_BUILD "${ARGS_FOR_B2_BUILD} address-model=${CURRENT_PLATFORM_ARCH}")#address model is specified the same way in PID and b2
  set(ARGS_FOR_B2_BUILD "${ARGS_FOR_B2_BUILD} architecture=${CURRENT_PLATFORM_TYPE}")#processor architecture supported are "x86" and "arm" so PID uses same names than b2
  if(CURRENT_PLATFORM_OS STREQUAL macos)#we use a specific identifier in PID only for macos otherwise thay are the same than b2
    set(ARGS_FOR_B2_BUILD "${ARGS_FOR_B2_BUILD} target-os=darwin")#processor architecture
  else()
    set(ARGS_FOR_B2_BUILD "${ARGS_FOR_B2_BUILD} target-os=${CURRENT_PLATFORM_OS}")#processor architecture
  endif()
   #ABI definition is already in compile flags
  # configure toolchain
  if(CMAKE_COMPILER_IS_GNUCXX)
    set(ARGS_FOR_B2_BUILD "${ARGS_FOR_B2_BUILD} toolset=gcc")
    set(install_toolset "gcc")
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang" OR CMAKE_CXX_COMPILER_ID STREQUAL "clang")
    set(install_toolset "clang")
    set(ARGS_FOR_B2_BUILD "${ARGS_FOR_B2_BUILD} toolset=clang")
	else()# add new support for compiler or use CMake generic mechanism to do so for instance : CMAKE_CXX_COMPILER_ID STREQUAL "MSVC"
    set(ARGS_FOR_B2_BUILD "${ARGS_FOR_B2_BUILD} toolset=${CMAKE_CXX_COMPILER_ID}")
    set(install_toolset "${CMAKE_CXX_COMPILER_ID}")
	endif()
  #configure compilation flags
  get_Environment_Info(CXX RELEASE CFLAGS cxx_flags COMPILER cxx_compiler)
  get_Environment_Info(C RELEASE CFLAGS c_flags)

  if(c_flags)
    set(ARGS_FOR_B2_BUILD "${ARGS_FOR_B2_BUILD} cflags=\"${c_flags}\"")#need to use guillemet because pass "as is"
  endif()
  if(cxx_flags)
    set(ARGS_FOR_B2_BUILD "${ARGS_FOR_B2_BUILD} cxxflags=\"${cxx_flags}\"")#need to use guillemet because pass "as is"
  endif()

  if(BUILD_B2_EXTERNAL_PROJECT_LINKS)
    set(all_links)
    foreach(link IN LISTS BUILD_B2_EXTERNAL_PROJECT_LINKS)#specific includes (to manage dependencies)
      set(all_links "${all_links} ${link}")
    endforeach()
    set(ARGS_FOR_B2_BUILD "${ARGS_FOR_B2_BUILD} linkflags=\"${links}\"")#need to use guillemet because pass "as is"
  endif()

  if(BUILD_B2_EXTERNAL_PROJECT_DEFINITIONS)
    foreach(def IN LISTS BUILD_B2_EXTERNAL_PROJECT_DEFINITIONS)
      set(ARGS_FOR_B2_BUILD "${ARGS_FOR_B2_BUILD} define=${def}")#specific preprocessor definition
    endforeach()
  endif()
  if(BUILD_B2_EXTERNAL_PROJECT_INCLUDES)
    foreach(inc IN LISTS BUILD_B2_EXTERNAL_PROJECT_INCLUDES)#specific includes (to manage dependencies)
      set(ARGS_FOR_B2_BUILD "${ARGS_FOR_B2_BUILD} include=${inc}")
    endforeach()
  endif()
  if(BUILD_B2_EXTERNAL_PROJECT_WITH)
    foreach(lib IN LISTS BUILD_B2_EXTERNAL_PROJECT_WITH)#libraries to build
      set(ARGS_FOR_B2_BUILD "${ARGS_FOR_B2_BUILD} --with-${lib}")
    endforeach()
  endif()
  if(BUILD_B2_EXTERNAL_PROJECT_WITHOUT)
    foreach(lib IN LISTS BUILD_B2_EXTERNAL_PROJECT_WITHOUT)#libraries to exclude from build
      set(ARGS_FOR_B2_BUILD "${ARGS_FOR_B2_BUILD} --without-${lib}")
    endforeach()
  endif()

  if(CMAKE_HOST_WIN32)#on a window host path must be resolved
    separate_arguments(COMMAND_ARGS_AS_LIST WINDOWS_COMMAND "${ARGS_FOR_B2_BUILD}")
  else()#if not on wondows use a UNIX like command syntac
    separate_arguments(COMMAND_ARGS_AS_LIST UNIX_COMMAND "${ARGS_FOR_B2_BUILD}")#always from host perpective
  endif()

  message("[PID] INFO : Configuring ${BUILD_B2_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")
  execute_process(COMMAND ${project_dir}/bootstrap.sh WORKING_DIRECTORY ${project_dir} ${OUTPUT_MODE}  RESULT_VARIABLE result)
  if(NOT result EQUAL 0)#error at configuration time
    message("[PID] ERROR : cannot configure boost build project ${BUILD_B2_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")
    set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
    return()
  endif()

  #generating the jam file for boost build
  set(jamfile ${project_dir}/user-config.jam)
  set(TOOLSET_NAME ${install_toolset})
  set(TOOLSET_COMPILER_PATH ${cxx_compiler})
  if(CURRENT_PYTHON)
    set(PYTHON_TOOLSET "using python : ${CURRENT_PYTHON} : ${CURRENT_PYTHON_EXECUTABLE} ;")
  endif()
  configure_file( ${WORKSPACE_DIR}/share/patterns/wrappers/b2_pid_config.jam.in
                  ${jamfile}
                  @ONLY)


  if(ENABLE_PARALLEL_BUILD)#parallel build is allowed from CMake configuration
    get_Environment_Info(JOBS jobs)#get jobs flags from environment
    if(BUILD_B2_EXTERNAL_PROJECT_USER_JOBS)#the user may have put a restriction
      set(jobs -j${BUILD_B2_EXTERNAL_PROJECT_USER_JOBS})
    endif()
  endif()

  message("[PID] INFO : Building and installing ${BUILD_B2_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")
  execute_process(COMMAND ${project_dir}/b2 install ${jobs} --prefix=${TARGET_INSTALL_DIR} --user-config=${jamfile} ${COMMAND_ARGS_AS_LIST}
  WORKING_DIRECTORY ${project_dir} ${OUTPUT_MODE} RESULT_VARIABLE result ERROR_VARIABLE varerr)
  if(NOT result EQUAL 0
    AND NOT (varerr MATCHES "^link\\.jam: No such file or directory[ \t\n]*$"))#if the error is the one specified this is a normal situation (i.e. a BUG in previous version of b2, -> this message should be a warning)
    message("[PID] ERROR : cannot build and install boost build project ${BUILD_B2_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")
    set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
    return()
  endif()

  # Build systems may install libraries in a lib64 folder on some platforms
	# If it's the case, rename the folder to lib in order to have a unique wrapper description
	if(EXISTS ${TARGET_INSTALL_DIR}/lib64)
    file(RENAME ${TARGET_INSTALL_DIR}/lib64 ${TARGET_INSTALL_DIR}/lib)
  endif()
endfunction(build_B2_External_Project)


#.rst:
#
# .. ifmode:: script
#
#  .. |build_Autotools_External_Project| replace:: ``build_Autotools_External_Project``
#  .. _build_Autotools_External_Project:
#
#  build_Autotools_External_Project
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
#   .. command:: build_Autotools_External_Project(PROJECT ... FOLDER ... MODE ... [OPTIONS])
#
#     Configure, build and install an external project defined with GNU autotools.
#
#     .. rubric:: Required parameters
#
#     :PROJECT <string>: The name of the external project.
#     :FOLDER <string>: The name of the folder containing the project.
#     :MODE <Release|Debug>: The build mode.
#
#     .. rubric:: Optional parameters
#
#     :QUIET: if used then the output of this command will be silent.
#     :COMMENT <string>: A string to append to message to inform about special thing you are doing. Usefull if you intend to buildmultiple time the same external project with different options.
#     :DEFINITIONS <list of definitions>: the CMake definitions you need to provide to the cmake build script.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - Must be used in deploy scripts defined in a wrapper.
#
#     .. admonition:: Effects
#        :class: important
#
#         -  Build and install the external project into workspace install tree..
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#         build_Autotools_External_Project(PROJECT aproject FOLDER a_project_v12 MODE Release)
#
function(build_Autotools_External_Project)
  if(ERROR_IN_SCRIPT)
    return()
  endif()
  set(options QUIET) #used to define the context
  set(oneValueArgs PROJECT FOLDER MODE COMMENT USER_JOBS)
  set(multiValueArgs C_FLAGS CXX_FLAGS LD_FLAGS CPP_FLAGS OPTIONS)
  cmake_parse_arguments(BUILD_AUTOTOOLS_EXTERNAL_PROJECT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
  if(NOT BUILD_AUTOTOOLS_EXTERNAL_PROJECT_PROJECT OR NOT BUILD_AUTOTOOLS_EXTERNAL_PROJECT_FOLDER OR NOT BUILD_AUTOTOOLS_EXTERNAL_PROJECT_MODE)
    message(FATAL_ERROR "[PID] CRITICAL ERROR : PROJECT, FOLDER and MODE arguments are mandatory when calling build_Autotools_External_Project.")
    return()
  endif()

  get_GNU_Make_Program(MAKE_EXE ${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_PROJECT})

  if(BUILD_AUTOTOOLS_EXTERNAL_PROJECT_QUIET)
    # waf outputs its messages on cerr...
    set(OUTPUT_MODE OUTPUT_QUIET ERROR_QUIET)
  endif()

  if(BUILD_AUTOTOOLS_EXTERNAL_PROJECT_COMMENT)
    set(use_comment "(${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_COMMENT}) ")
  endif()

  #create the build folder inside the project folder
  set(project_dir ${TARGET_BUILD_DIR}/${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_FOLDER})
  if(NOT EXISTS ${project_dir})
    message(FATAL_ERROR "[PID] CRITICAL ERROR : when calling build_Autotools_External_Project the build folder specified (${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_FOLDER}) does not exist.")
    return()
  endif()

  message("[PID] INFO : Configuring ${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")

  # preparing autotools invocation parameters
  #put back environment variables in previosu state
  #configure compilation flags
  set(C_FLAGS_ENV ${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_C_FLAGS})
  set(CXX_FLAGS_ENV ${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_CXX_FLAGS})
  set(LD_FLAGS_ENV ${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_LD_FLAGS})
  set(CPP_FLAGS_ENV ${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_CPP_FLAGS})

  get_Environment_Info(CXX RELEASE CFLAGS cxx_flags COMPILER cxx_compiler LINKER ld_tool AR ar_tool)
  get_Environment_Info(SHARED LDFLAGS ld_flags)
  get_Environment_Info(C RELEASE CFLAGS c_flags COMPILER c_compiler)
  if(c_flags)
    set(APPEND C_FLAGS_ENV ${c_flags})
  endif()
  if(cxx_flags)
    list(APPEND CXX_FLAGS_ENV ${cxx_flags})
  endif()
  if(ld_flags)
    list(APPEND LD_FLAGS_ENV ${ld_flags})
  endif()

  if(C_FLAGS_ENV)
    fill_String_From_List(C_FLAGS_ENV C_FLAGS_ENV)#transform it back to a flags string
    set(TEMP_CFLAGS $ENV{CFLAGS})
    set(ENV{CFLAGS} "${C_FLAGS_ENV}")
  endif()
  if(CXX_FLAGS_ENV)
    fill_String_From_List(CXX_FLAGS_ENV CXX_FLAGS_ENV)#transform it back to a flags string
    set(TEMP_CXXFLAGS $ENV{CXXFLAGS})
    set(ENV{CXXFLAGS} "${CXX_FLAGS_ENV}")
  endif()
  if(LD_FLAGS_ENV)
    fill_String_From_List(LD_FLAGS_ENV LD_FLAGS_ENV)
    set(TEMP_LDFLAGS $ENV{LDFLAGS})
    set(ENV{LDFLAGS} "${LD_FLAGS_ENV}")
  endif()
  if(CPP_FLAGS_ENV)
    fill_String_From_List(CPP_FLAGS_ENV CPP_FLAGS_ENV)
    set(TEMP_CPPFLAGS $ENV{CPPFLAGS})
    set(ENV{CPPFLAGS} ${CPP_FLAGS_ENV})
  endif()
  get_filename_component(RES_CC ${c_compiler} REALPATH)
  get_filename_component(RES_CXX ${cxx_compiler} REALPATH)
  get_filename_component(RES_LD ${ld_tool} REALPATH)
  get_filename_component(RES_AR ${ar_tool} REALPATH)
  #prefer passing absolute real path (i.e. without symlink) to autoconf (may improve compiler detection)
  set(TEMP_FC $ENV{FC})
  set(ENV{FC} ${RES_FC})
  set(TEMP_CC $ENV{CC})
  set(ENV{CC} ${RES_CC})
  set(TEMP_CXX $ENV{CXX})
  set(ENV{CXX} ${RES_CXX})
  set(TEMP_LD $ENV{LD})
  set(ENV{LD} ${RES_LD})
  set(TEMP_AR $ENV{AR})
  set(ENV{AR} ${RES_AR})

  execute_process(COMMAND ./configure --prefix=${TARGET_INSTALL_DIR} ${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_OPTIONS}
                  WORKING_DIRECTORY ${project_dir} ${OUTPUT_MODE}
                  RESULT_VARIABLE result)
  #give back initial values to environment variables
  set(ENV{CFLAGS} ${TEMP_CFLAGS})
  set(ENV{CXXFLAGS} ${TEMP_CXXFLAGS})
  set(ENV{LDFLAGS} ${TEMP_LDFLAGS})
  set(ENV{CPPFLAGS} ${TEMP_CPPFLAGS})
  set(ENV{FC} ${TEMP_FC})
  set(ENV{CC} ${TEMP_CC})
  set(ENV{CXX} ${TEMP_CXX})
  set(ENV{LD} ${TEMP_LD})
  set(ENV{AR} ${TEMP_AR})

  if(NOT result EQUAL 0)#error at configuration time
    message("[PID] ERROR : cannot configure autotools project ${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")
    set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
    return()
  endif()

  if(ENABLE_PARALLEL_BUILD)#parallel build is allowed from CMake configuration
    get_Environment_Info(JOBS jobs)#get jobs flags from environment
    if(BUILD_AUTOTOOLS_EXTERNAL_PROJECT_USER_JOBS)#the user may have put a restriction
      set(jobs -j${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_USER_JOBS})
    endif()
  endif()

  message("[PID] INFO : Building ${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")
  execute_process(COMMAND ${MAKE_EXE} ${jobs} WORKING_DIRECTORY ${project_dir} ${OUTPUT_MODE} RESULT_VARIABLE result)#build
  if(NOT result EQUAL 0)#error at configuration time
    message("[PID] ERROR : cannot build autotools project ${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")
    set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
    return()
  endif()
  message("[PID] INFO : Installing ${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")
  execute_process(COMMAND ${MAKE_EXE} install WORKING_DIRECTORY ${project_dir} ${OUTPUT_MODE} RESULT_VARIABLE result)#install
  if(NOT result EQUAL 0)#error at configuration time
    message("[PID] ERROR : cannot install autotools project ${BUILD_AUTOTOOLS_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")
    set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
    return()
  endif()
  # Build systems may install libraries in a lib64 folder on some platforms
	# If it's the case, rename the folder to lib in order to have a unique wrapper description
	if(EXISTS ${TARGET_INSTALL_DIR}/lib64)
    file(RENAME ${TARGET_INSTALL_DIR}/lib64 ${TARGET_INSTALL_DIR}/lib)
  endif()
endfunction(build_Autotools_External_Project)

#.rst:
#
# .. ifmode:: script
#
#  .. |build_Waf_External_Project| replace:: ``build_Waf_External_Project``
#  .. _build_Waf_External_Project:
#
#  build_Waf_External_Project
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^
#
#   .. command:: build_Waf_External_Project(PROJECT ... FOLDER ... MODE ... [OPTIONS])
#
#     Configure, build and install an external project defined with python Waf tool.
#
#     .. rubric:: Required parameters
#
#     :PROJECT <string>: The name of the external project.
#     :FOLDER <string>: The name of the folder containing the project.
#     :MODE <Release|Debug>: The build mode.
#
#     .. rubric:: Optional parameters
#
#     :QUIET: if used then the output of this command will be silent.
#     :COMMENT <string>: A string to append to message to inform about special thing you are doing. Usefull if you intend to buildmultiple time the same external project with different options.
#     :DEFINITIONS <list of definitions>: the CMake definitions you need to provide to the cmake build script.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - Must be used in deploy scripts defined in a wrapper.
#
#     .. admonition:: Effects
#        :class: important
#
#         -  Build and install the external project into workspace install tree..
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#         build_Waf_External_Project(PROJECT aproject FOLDER a_project_v12 MODE Release)
#
function(build_Waf_External_Project)
  if(ERROR_IN_SCRIPT)
    return()
  endif()
  set(options QUIET) #used to define the context
  set(oneValueArgs PROJECT FOLDER MODE COMMENT USER_JOBS)
  set(multiValueArgs C_FLAGS CXX_FLAGS LD_FLAGS OPTIONS)
  cmake_parse_arguments(BUILD_WAF_EXTERNAL_PROJECT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
  if(NOT BUILD_WAF_EXTERNAL_PROJECT_PROJECT OR NOT BUILD_WAF_EXTERNAL_PROJECT_FOLDER OR NOT BUILD_WAF_EXTERNAL_PROJECT_MODE)
    message(FATAL_ERROR "[PID] CRITICAL ERROR : PROJECT, FOLDER and MODE arguments are mandatory when calling build_Waf_External_Project.")
    return()
  endif()

  if(BUILD_WAF_EXTERNAL_PROJECT_QUIET)
    # waf outputs its messages on cerr...
    set(OUTPUT_MODE OUTPUT_QUIET ERROR_QUIET)
  endif()

  if(BUILD_WAF_EXTERNAL_PROJECT_COMMENT)
    set(use_comment "(${BUILD_WAF_EXTERNAL_PROJECT_COMMENT}) ")
  endif()

  #create the build folder inside the project folder
  set(project_dir ${TARGET_BUILD_DIR}/${BUILD_WAF_EXTERNAL_PROJECT_FOLDER})
  if(NOT EXISTS ${project_dir})
    message(FATAL_ERROR "[PID] CRITICAL ERROR : when calling build_Waf_External_Project the build folder specified (${BUILD_WAF_EXTERNAL_PROJECT_FOLDER}) does not exist.")
    return()
  endif()

  message("[PID] INFO : Configuring, building and installing ${BUILD_WAF_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")

  # preparing b2 invocation parameters
  #configure build mode (to get available parameters see https://boostorg.github.io/build/tutorial.html section "Feature reference")
  if(BUILD_WAF_EXTERNAL_PROJECT_MODE STREQUAL Debug)
      set(ARGS_FOR_WAF_BUILD "variant=debug")
  else()
      set(ARGS_FOR_WAF_BUILD "variant=release")
  endif()
   #ABI definition is already in compile flags

  #configure compilation flags
  set(C_FLAGS_ENV ${BUILD_WAF_EXTERNAL_PROJECT_C_FLAGS})
  set(CXX_FLAGS_ENV ${BUILD_WAF_EXTERNAL_PROJECT_CXX_FLAGS})
  set(LD_FLAGS_ENV ${BUILD_WAF_EXTERNAL_PROJECT_LD_FLAGS})

  get_Environment_Info(CXX RELEASE CFLAGS cxx_flags COMPILER cxx_compiler LINKER ld_tool)
  get_Environment_Info(SHARED LDFLAGS ld_flags)
  get_Environment_Info(C RELEASE CFLAGS c_flags COMPILER c_compiler)

  if(c_flags)
    list(APPEND C_FLAGS_ENV ${c_flags})
  endif()
  if(cxx_flags)
    list(APPEND CXX_FLAGS_ENV ${cxx_flags})
  endif()
  if(ld_flags)
    list(APPEND LD_FLAGS_ENV ${ld_flags})
  endif()

  set(TEMP_LDFLAGS "$ENV{LDFLAGS}")
  set(TEMP_C "$ENV{CFLAGS}")
  set(TEMP_CXX "$ENV{CXXFLAGS}")
  set(TEMP_C_COMPILER "$ENV{CC}")
  set(TEMP_CXX_COMPILER "$ENV{CXX}")
  set(TEMP_LD "$ENV{LD}")

  fill_String_From_List(LD_FLAGS_ENV RES_STRING)
  set(ENV{LDFLAGS} ${RES_STRING})
  fill_String_From_List(C_FLAGS_ENV RES_STRING)
  set(ENV{CFLAGS} ${RES_STRING})
  fill_String_From_List(CXX_FLAGS_ENV RES_STRING)
  set(ENV{CXXFLAGS} "${RES_STRING}")
  set(ENV{CC} "${c_compiler}")
  set(ENV{CXX} "${cxx_compiler}")
  set(ENV{LD} "${ld_tool}")

  # Use user-defined number of jobs if defined
  if(ENABLE_PARALLEL_BUILD)#parallel build is allowed from CMake configuration
    get_Environment_Info(JOBS jobs)#get jobs flags from environment
    if(BUILD_WAF_EXTERNAL_PROJECT_USER_JOBS)#the user may have put a restriction
      set(jobs -j${BUILD_WAF_EXTERNAL_PROJECT_USER_JOBS})
    endif()
  endif()
  execute_process(COMMAND ${CURRENT_PYTHON_EXECUTABLE} waf distclean configure build install ${BUILD_WAF_EXTERNAL_PROJECT_OPTIONS} ${jobs} --prefix=${TARGET_INSTALL_DIR} ..
                  WORKING_DIRECTORY ${project_dir} ${OUTPUT_MODE}
                  RESULT_VARIABLE result)

  #put back environment variables in previosu state
  set(ENV{LDFLAGS} "${TEMP_LD}")
  set(ENV{CFLAGS} "${TEMP_C}")
  set(ENV{CXXFLAGS} "${TEMP_CXX}")
  set(ENV{CC} "${TEMP_C_COMPILER}")
  set(ENV{CXX} "${TEMP_CXX_COMPILER}")
  set(ENV{LD} "${TEMP_LD}")
  if(NOT result EQUAL 0)#error at configuration time
    message("[PID] ERROR : cannot configure/build/install Waf project ${BUILD_WAF_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")
    set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
    return()
  endif()

  # Build systems may install libraries in a lib64 folder on some platforms
	# If it's the case, rename the folder to lib in order to have a unique wrapper description
	if(EXISTS ${TARGET_INSTALL_DIR}/lib64)
    file(RENAME ${TARGET_INSTALL_DIR}/lib64 ${TARGET_INSTALL_DIR}/lib)
  endif()
endfunction(build_Waf_External_Project)

#.rst:
#
# .. ifmode:: script
#
#  .. |build_CMake_External_Project| replace:: ``build_CMake_External_Project``
#  .. _build_CMake_External_Project:
#
#  build_CMake_External_Project
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
#   .. command:: build_CMake_External_Project(URL ... ARCHIVE ... FOLDER ... PATH ... [OPTIONS])
#
#     Configure, build and install a Cmake external project.
#
#     .. rubric:: Required parameters
#
#     :PROJECT <string>: The name of the external project.
#     :FOLDER <string>: The name of the folder containing the project.
#     :Mode <Release|Debug>: The build mode.
#
#     .. rubric:: Optional parameters
#
#     :QUIET: if used then the output of this command will be silent.
#     :COMMENT <string>: A string to append to message to inform about special thing you are doing. Usefull if you intend to buildmultiple time the same external project with different options.
#     :DEFINITIONS <list of definitions>: the CMake definitions you need to provide to the cmake build script.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - Must be used in deploy scripts defined in a wrapper.
#
#     .. admonition:: Effects
#        :class: important
#
#         -  Build and install the external project into workspace install tree..
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        build_CMake_External_Project( PROJECT yaml-cpp FOLDER yaml-cpp-yaml-cpp-0.6.2 MODE Release
#                              DEFINITIONS BUILD_GMOCK=OFF BUILD_GTEST=OFF BUILD_SHARED_LIBS=ON YAML_CPP_BUILD_TESTS=OFF YAML_CPP_BUILD_TESTS=OFF YAML_CPP_BUILD_TOOLS=OFF YAML_CPP_BUILD_CONTRIB=OFF gtest_force_shared_crt=OFF
#                              COMMENT "shared libraries")
#
#
function(build_CMake_External_Project)
  if(ERROR_IN_SCRIPT)
    return()
  endif()
  set(options QUIET) #used to define the context
  set(oneValueArgs PROJECT FOLDER MODE USER_JOBS COMMENT)
  set(multiValueArgs DEFINITIONS)
  cmake_parse_arguments(BUILD_CMAKE_EXTERNAL_PROJECT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
  if(NOT BUILD_CMAKE_EXTERNAL_PROJECT_PROJECT OR NOT BUILD_CMAKE_EXTERNAL_PROJECT_FOLDER OR NOT BUILD_CMAKE_EXTERNAL_PROJECT_MODE)
    message(FATAL_ERROR "[PID] CRITICAL ERROR : PROJECT, FOLDER and MODE arguments are mandatory when calling build_CMake_External_Project.")
    return()
  endif()

  if(BUILD_CMAKE_EXTERNAL_PROJECT_QUIET)
    set(OUTPUT_MODE OUTPUT_QUIET)
  endif()

  if(BUILD_CMAKE_EXTERNAL_PROJECT_MODE STREQUAL Debug)
    set(TARGET_MODE Debug)
  else()
    set(TARGET_MODE Release)
  endif()
  #create the build folder inside the project folder
  set(project_build_dir ${TARGET_BUILD_DIR}/${BUILD_CMAKE_EXTERNAL_PROJECT_FOLDER}/build)
  if(NOT EXISTS ${project_build_dir})
    file(MAKE_DIRECTORY ${project_build_dir})#create the build dir
  else()#clean the build folder
    hard_Clean_Build_Folder(${project_build_dir})
  endif()

  set(calling_defs)
  #compute user defined CMake definitions => create the arguments of the command line with space separated arguments
  # this is to allow the usage of a list of list in CMake
  foreach(def IN LISTS BUILD_CMAKE_EXTERNAL_PROJECT_DEFINITIONS)
   # Managing list and variables
   if(def MATCHES "(.+)=(.+)") #if a cmake assignement (should be the case for any definition)
     if(DEFINED ${CMAKE_MATCH_2}) # if right-side of the assignement is a variable
       set(val ${${CMAKE_MATCH_2}}) #take the value of the variable
     else()
       set(val ${CMAKE_MATCH_2})
     endif()
     set(var ${CMAKE_MATCH_1})
     if(val #if val has a value OR if value of val is "FALSE"
        OR val MATCHES "FALSE|OFF"
        OR val EQUAL 0
        OR val MATCHES "NOTFOUND")#if VAL is not empty
        message("")
       set(calling_defs "${calling_defs} -D${var}=${val}")
     endif()
   else()#no setting this is a cmake specific argument
     set(calling_defs "${calling_defs} ${def}")
   endif()
  endforeach()
  if(CMAKE_HOST_WIN32)#on a window host path must be resolved
		separate_arguments(COMMAND_ARGS_AS_LIST WINDOWS_COMMAND "${calling_defs}")
	else()#if not on wondows use a UNIX like command syntac
		separate_arguments(COMMAND_ARGS_AS_LIST UNIX_COMMAND "${calling_defs}")#always from host perpective
	endif()

  if(BUILD_CMAKE_EXTERNAL_PROJECT_COMMENT)
    set(use_comment "(${BUILD_CMAKE_EXTERNAL_PROJECT_COMMENT}) ")
  endif()

  message("[PID] INFO : Configuring ${BUILD_CMAKE_EXTERNAL_PROJECT_PROJECT} ${use_comment}...")
  # pre-populate the cache with the cache file of the workspace containing build infos,
  # then populate with additionnal information
  execute_process(
    COMMAND ${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE=${TARGET_MODE}
                            -DCMAKE_INSTALL_PREFIX=${TARGET_INSTALL_DIR}
                            -DCMAKE_SKIP_INSTALL_RPATH=OFF
                            -DCMAKE_SKIP_RPATH=OFF
                            -DCMAKE_INSTALL_LIBDIR=lib
                            -DCMAKE_INSTALL_BINDIR=bin
                            -DCMAKE_INSTALL_INCLUDEDIR=include
                            -DDATAROOTDIR=share
                            -C ${WORKSPACE_DIR}/pid/Workspace_Build_Info.cmake
                            ${COMMAND_ARGS_AS_LIST}
                            ..
    WORKING_DIRECTORY ${project_build_dir}
    ${OUTPUT_MODE}
    RESULT_VARIABLE result)
  if(NOT result EQUAL 0)#error at configuration time
    message("[PID] ERROR : cannot configure CMake project ${BUILD_CMAKE_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")
    set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
    return()
  endif()
  #once configure, build it
  # Use user-defined number of jobs if defined
  get_Environment_Info(MAKE make_program)#get jobs flags from environment
  set(jnumber 1)
  if(ENABLE_PARALLEL_BUILD)#parallel build is allowed from CMake configuration
    get_Environment_Info(JOBS jobs JOBS_NUMBER jnumber)
    if(BUILD_CMAKE_EXTERNAL_PROJECT_USER_JOBS)#the user may have put a restriction
      set(jobs -j${BUILD_CMAKE_EXTERNAL_PROJECT_USER_JOBS})
    endif()
  endif()
  message("[PID] INFO : Building ${BUILD_CMAKE_EXTERNAL_PROJECT_PROJECT} ${use_comment}in ${TARGET_MODE} mode...")
  message("[PID] INFO : Building using ${jnumber} jobs ...")
  execute_process(
    COMMAND ${make_program} ${jobs} WORKING_DIRECTORY ${project_build_dir} ${OUTPUT_MODE}
    RESULT_VARIABLE result
  )
  if(NOT result EQUAL 0)#error at configuration time
    message("[PID] ERROR : cannot build CMake project ${BUILD_CMAKE_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")
    set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
    return()
  endif()

  message("[PID] INFO : Installing ${BUILD_CMAKE_EXTERNAL_PROJECT_PROJECT} ${use_comment}in ${TARGET_MODE} mode...")
  execute_process(
    COMMAND ${make_program} install WORKING_DIRECTORY ${project_build_dir} ${OUTPUT_MODE}
    RESULT_VARIABLE result
  )
  if(NOT result EQUAL 0)#error at configuration time
    message("[PID] ERROR : cannot install CMake project ${BUILD_CMAKE_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")
    set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
    return()
  endif()
endfunction(build_CMake_External_Project)

#.rst:
#
# .. ifmode:: script
#
#  .. |build_Bazel_External_Project| replace:: ``build_Bazel_External_Project``
#  .. _build_Bazel_External_Project:
#
#  build_Bazel_External_Project
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
#   .. command:: build_Bazel_External_Project(PROJECT ... FOLDER ... INSTALL_PATH ... MODE ... TARGET .. [OPTIONS])
#
#     Configure, build and install a Bazel (google build system) external project.
#
#     .. rubric:: Required parameters
#
#     :PROJECT <string>: The name of the external project.
#     :FOLDER <string>: The name of the folder containing the project.
#     :INSTALL_PATH <path>: The path where the components are supposed to be found
#     :MODE <Release|Debug>: The build mode.
#     :TARGET <string>: The name of the target being built.
#
#     .. rubric:: Optional parameters
#
#     :MIN_VERSION: minimum version of bazel tool to use.
#     :MAX_VERSION: maximum version of bazel tool to use.
#     :QUIET: if used then the output of this command will be silent.
#     :COMMENT <string>: A string to append to message to inform about special thing you are doing. Usefull if you intend to buildmultiple time the same external project with different options.
#     :DEFINITIONS <list of definitions>: the bazel definitions (environment variables) you need to provide to the cmake build script.
#
#     .. admonition:: Constraints
#        :class: warning
#
#        - Must be used in deploy scripts defined in a wrapper.
#
#     .. admonition:: Effects
#        :class: important
#
#         -  Build and install the external project into workspace install tree..
#
#     .. rubric:: Example
#
#     .. code-block:: cmake
#
#        build_Bazel_External_Project( PROJECT tensorflow FOLDER tensorflow-1.13.1 MODE Release
#                              COMMENT "shared libraries")
#
#
function(build_Bazel_External_Project)
  if(ERROR_IN_SCRIPT)
    return()
  endif()
  set(options QUIET) #used to define the context
  set(oneValueArgs PROJECT FOLDER MODE COMMENT MIN_VERSION MAX_VERSION INSTALL_PATH TARGET USER_JOBS)
  set(multiValueArgs DEFINITIONS)
  cmake_parse_arguments(BUILD_BAZEL_EXTERNAL_PROJECT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
  if(NOT BUILD_BAZEL_EXTERNAL_PROJECT_PROJECT
      OR NOT BUILD_BAZEL_EXTERNAL_PROJECT_FOLDER
      OR NOT BUILD_BAZEL_EXTERNAL_PROJECT_MODE
      OR NOT BUILD_BAZEL_EXTERNAL_PROJECT_TARGET)
    message(FATAL_ERROR "[PID] CRITICAL ERROR : PROJECT, FOLDER, TARGET and MODE arguments are mandatory when calling build_CMake_External_Project.")
    return()
  endif()

  if(BUILD_BAZEL_EXTERNAL_PROJECT_QUIET)
    set(OUTPUT_MODE OUTPUT_QUIET)
  endif()

  if(BUILD_BAZEL_EXTERNAL_PROJECT_MODE STREQUAL Debug)
    set(TARGET_MODE Debug)
  else()
    set(TARGET_MODE Release)
  endif()

  if(BUILD_BAZEL_EXTERNAL_PROJECT_COMMENT)
    set(use_comment "(${BUILD_BAZEL_EXTERNAL_PROJECT_COMMENT}) ")
  endif()

  if(BUILD_BAZEL_EXTERNAL_PROJECT_MIN_VERSION OR BUILD_BAZEL_EXTERNAL_PROJECT_MAX_VERSION)#a constraint on bazel version to use
    if(BUILD_BAZEL_EXTERNAL_PROJECT_MIN_VERSION AND BUILD_BAZEL_EXTERNAL_PROJECT_MAX_VERSION)
      if(NOT BUILD_BAZEL_EXTERNAL_PROJECT_MAX_VERSION VERSION_GREATER BUILD_BAZEL_EXTERNAL_PROJECT_MIN_VERSION)
        message(FATAL_ERROR "[PID] CRITICAL ERROR : MIN_VERSION specified is greater than MAX_VERSION constraint.")
        return()
      endif()
    endif()
    if(BUILD_BAZEL_EXTERNAL_PROJECT_MIN_VERSION)
      find_package(Bazel ${BUILD_BAZEL_EXTERNAL_PROJECT_MIN_VERSION})
    endif()
    if(BAZEL_FOUND)#a version has been found
      if(BUILD_BAZEL_EXTERNAL_PROJECT_MAX_VERSION) #but a max version constraint is defined
        if(BAZEL_VERSION VERSION_GREATER BUILD_BAZEL_EXTERNAL_PROJECT_MAX_VERSION)#does not fit the constraints
          message(FATAL_ERROR "[PID] CRITICAL ERROR : cannot find a bazel version compatible with MIN_VERSION and MAX_VERSION constraints.")
          return()
        endif()
      endif()
    elseif(BUILD_BAZEL_EXTERNAL_PROJECT_MAX_VERSION)#there is only a max version specified !!
      find_package(Bazel ${BUILD_BAZEL_EXTERNAL_PROJECT_MAX_VERSION} EXACT) #use exact to avoid using greater version number
      if(NOT BAZEL_FOUND)
        message(FATAL_ERROR "[PID] CRITICAL ERROR : cannot find a bazel version compatible with MIN_VERSION and MAX_VERSION constraints.")
        return()
      endif()
    endif()
  else()#no version constraint so code is supposed to work with any version of bazel
    find_package(Bazel)
    if(NOT BAZEL_FOUND)
      message(FATAL_ERROR "[PID] CRITICAL ERROR : cannot find bazel installed.")
      return()
    endif()

  endif()

  set(project_src_dir ${TARGET_BUILD_DIR}/${BUILD_BAZEL_EXTERNAL_PROJECT_FOLDER})
  string(REPLACE " " ";" CMAKE_CXX_FLAGS cxx_flags_list)
  foreach(flag IN LISTS cxx_flags_list)
    if(flag)
      list(APPEND bazel_build_arguments "--cxxopt ${flag}")#do not give build mode related options as they are already managed by bazel
    endif()
  endforeach()
  string(REPLACE " " ";" CMAKE_CXX_FLAGS c_flags_list)
  foreach(flag IN LISTS c_flags_list)
    if(flag)
      list(APPEND bazel_build_arguments "--conlyopt ${flag}")#do not give build mode related options as they are already managed by bazel
    endif()
  endforeach()

  if(TARGET_MODE STREQUAL Debug)
    list(APPEND bazel_build_arguments "--config=dbg")
  else()
    list(APPEND bazel_build_arguments "--config=opt")
  endif()

  #adding all arguments coming with the current target platform
  # list(APPEND bazel_arguments )
  # TODO look at possible available arguments to the bazel tool see https://docs.bazel.build/versions/master/user-manual.html

  if(ENABLE_PARALLEL_BUILD)#parallel build is allowed from CMake configuration
    get_Environment_Info(JOBS_NUMBER jobs)#get jobs number from environment
    if(BUILD_BAZEL_EXTERNAL_PROJECT_USER_JOBS)#the user may have set directly the number of jobs
      set(jobs ${BUILD_BAZEL_EXTERNAL_PROJECT_USER_JOBS})
    endif()
    if(NOT jobs EQUAL 0)
      set(jobs_opt "--jobs=${jobs}")
    endif()
  endif()

  if(NOT OUTPUT_MODE STREQUAL OUTPUT_QUIET)
    set(failure_report "--verbose_failures")
  endif()

  set(used_target ${BUILD_BAZEL_EXTERNAL_PROJECT_TARGET})
  message("[PID] INFO : Building ${BUILD_BAZEL_EXTERNAL_PROJECT_PROJECT} ${use_comment}in ${TARGET_MODE} mode...")
  execute_process(
    COMMAND ${BAZEL_EXECUTABLE} build
    ${failure_report} #getting info about failure
    ${jobs_opt} #set the adequate number of jobs
    --color no --curses yes #no need color, but nice output !
    ${bazel_build_arguments}
    ${BUILD_BAZEL_EXTERNAL_PROJECT_DEFINITIONS} #add specific definitions if any
    ${used_target} #give the target name as last argument
    WORKING_DIRECTORY ${project_src_dir} ${OUTPUT_MODE}
    RESULT_VARIABLE result
  )

  if(NOT result EQUAL 0)#error at configuration time
    message("[PID] ERROR : cannot build Bazel project ${BUILD_BAZEL_EXTERNAL_PROJECT_PROJECT} ${use_comment} ...")
    set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
    return()
  endif()

  if(BUILD_BAZEL_EXTERNAL_PROJECT_INSTALL_PATH)
    message("[PID] INFO : Installing ${BUILD_BAZEL_EXTERNAL_PROJECT_PROJECT} ${use_comment}in ${TARGET_MODE} mode...")
    #need to do this "by hand", binaries first
    set(bin_path ${project_src_dir}/${BUILD_BAZEL_EXTERNAL_PROJECT_INSTALL_PATH})
    get_filename_component(binary_name ${BUILD_BAZEL_EXTERNAL_PROJECT_INSTALL_PATH} NAME)
    if(NOT EXISTS ${bin_path})
      message("[PID] ERROR : cannot find binaries generated by Bazel project ${BUILD_BAZEL_EXTERNAL_PROJECT_PROJECT} ${use_comment} ... (missing is ${bin_path})")
      set(ERROR_IN_SCRIPT TRUE PARENT_SCOPE)
      return()
    endif()
    get_Link_Type(RES_TYPE ${binary_name})
    if(RES_TYPE STREQUAL "OPTION")#if an option it means it is not identified as a library => it is an executable in current context
      file(COPY ${bin_path} DESTINATION ${TARGET_INSTALL_DIR}/bin)
    else()
      file(COPY ${bin_path} DESTINATION ${TARGET_INSTALL_DIR}/lib)
    endif()
  endif()

  # Build systems may install libraries in a lib64 folder on some platforms
	# If it's the case, rename the folder to lib in order to have a unique wrapper description
	if(EXISTS ${TARGET_INSTALL_DIR}/lib64)
    file(RENAME ${TARGET_INSTALL_DIR}/lib64 ${TARGET_INSTALL_DIR}/lib)
  endif()
endfunction(build_Bazel_External_Project)
