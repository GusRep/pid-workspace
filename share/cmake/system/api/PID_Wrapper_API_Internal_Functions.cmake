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

########################################################################
############ inclusion of required macros and functions ################
########################################################################
include(External_Definition NO_POLICY_SCOPE) #to be able to interpret description of dependencies (external packages)
include(PID_Utils_Functions NO_POLICY_SCOPE)
include(PID_Git_Functions NO_POLICY_SCOPE)
include(PID_Version_Management_Functions NO_POLICY_SCOPE)
include(PID_Progress_Management_Functions NO_POLICY_SCOPE)
include(PID_Finding_Functions NO_POLICY_SCOPE)
include(PID_Deployment_Functions NO_POLICY_SCOPE)
include(PID_Platform_Management_Functions NO_POLICY_SCOPE)
include(PID_Documentation_Management_Functions NO_POLICY_SCOPE)
include(PID_Meta_Information_Management_Functions NO_POLICY_SCOPE)
include(PID_Continuous_Integration_Functions NO_POLICY_SCOPE)

################################################################################
############ description of functions implementing the wrapper API #############
################################################################################

#.rst:
#
# .. ifmode:: internal
#
#  .. |reconfigure_Wrapper_Build| replace:: ``reconfigure_Wrapper_Build``
#  .. _reconfigure_Wrapper_Build:
#
#  reconfigure_Wrapper_Build
#  -------------------------
#
#   .. command:: reconfigure_Wrapper_Build()
#
#     Reconfigure the currently built wrapper (i.e. launch cmake configuration).
#
function(reconfigure_Wrapper_Build package)
set(TARGET_BUILD_FOLDER ${WORKSPACE_DIR}/wrappers/${package}/build)
execute_process(COMMAND ${CMAKE_COMMAND} .. WORKING_DIRECTORY ${TARGET_BUILD_FOLDER})
endfunction(reconfigure_Wrapper_Build)

#.rst:
#
# .. ifmode:: internal
#
#  .. |reset_Wrapper_Description_Cached_Variables| replace:: ``reset_Wrapper_Description_Cached_Variables``
#  .. _reset_Wrapper_Description_Cached_Variables:
#
#  reset_Wrapper_Description_Cached_Variables
#  ------------------------------------------
#
#   .. command:: reset_Wrapper_Description_Cached_Variables()
#
#     Reset all cache variables of the currently built wrapper. Used to ensure consistency of wrapper description.
#
function(reset_Wrapper_Description_Cached_Variables)

#reset versions description
foreach(version IN LISTS ${PROJECT_NAME}_KNOWN_VERSIONS)
	#reset configurations
	foreach(config IN LISTS ${PROJECT_NAME}_KNOWN_VERSION_${version}_CONFIGURATIONS)
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_CONFIGURATION_${config} CACHE INTERNAL "")
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_CONFIGURATION_${config}_ARGS CACHE INTERNAL "")
	endforeach()
	set(${PROJECT_NAME}_KNOWN_VERSION_${version}_CONFIGURATIONS CACHE INTERNAL "")
	#reset package dependencies
	foreach(package IN LISTS ${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCIES)
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCY_${package}_VERSIONS CACHE INTERNAL "")
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCY_${package}_VERSIONS_EXACT CACHE INTERNAL "")
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCY_${package}_ALTERNATIVE_VERSION_USED CACHE INTERNAL "")
	endforeach()
	set(${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCIES CACHE INTERNAL "")

	#reset components
	foreach(component IN LISTS ${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENTS)

		#reset information local to the component
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SHARED_LINKS CACHE INTERNAL "")
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SONAME CACHE INTERNAL "")
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_STATIC_LINKS CACHE INTERNAL "")
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_INCLUDES CACHE INTERNAL "")
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEFINITIONS CACHE INTERNAL "")
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_OPTIONS CACHE INTERNAL "")
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_C_STANDARD CACHE INTERNAL "")
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_CXX_STANDARD CACHE INTERNAL "")
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_RUNTIME_RESOURCES CACHE INTERNAL "")

		#reset information related to system dependencies


		#reset information related to internal dependencies
		foreach(dependency IN LISTS ${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCIES)
			set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCY_${dependency}_DEFINITIONS CACHE INTERNAL "")
			set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCY_${dependency}_EXPORTED CACHE INTERNAL "")
		endforeach()
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCIES CACHE INTERNAL "")

		#reset information related to other external dependencies

		foreach(package IN LISTS ${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCIES)
			#reset component level dependencies first
			foreach(dependency IN LISTS ${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package})
				set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_${dependency}_DEFINITIONS CACHE INTERNAL "")
				set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_${dependency}_EXPORTED CACHE INTERNAL "")
			endforeach()
			set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package} CACHE INTERNAL "")

			#then reset direct package level dependencies of the component
			set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_INCLUDES CACHE INTERNAL "")
			set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_LIB_DIRS CACHE INTERNAL "")
			set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_SHARED CACHE INTERNAL "")
			set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_STATIC CACHE INTERNAL "")
			set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_DEFINITIONS CACHE INTERNAL "")
			set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_OPTIONS CACHE INTERNAL "")
			set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_C_STANDARD CACHE INTERNAL "")
			set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_CXX_STANDARD CACHE INTERNAL "")
			set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_RUNTIME_RESOURCES CACHE INTERNAL "")
		endforeach()
		set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCIES CACHE INTERNAL "")
	endforeach()
	set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENTS CACHE INTERNAL "")

	#reset current version general information
	set(${PROJECT_NAME}_KNOWN_VERSION_${version}_SONAME CACHE INTERNAL "")
	set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPATIBLE_WITH CACHE INTERNAL "")
	set(${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPLOY_SCRIPT CACHE INTERNAL "")
	set(${PROJECT_NAME}_KNOWN_VERSION_${version}_POST_INSTALL_SCRIPT CACHE INTERNAL "")
	set(${PROJECT_NAME}_KNOWN_VERSION_${version}_PRE_USE_SCRIPT CACHE INTERNAL "")

endforeach()
set(${PROJECT_NAME}_KNOWN_VERSIONS CACHE INTERNAL "")

#reset user options
foreach(opt IN LISTS ${PROJECT_NAME}_USER_OPTIONS)
	set(${PROJECT_NAME}_USER_OPTION_${opt}_TYPE CACHE INTERNAL "")
	set(${PROJECT_NAME}_USER_OPTION_${opt}_VALUE CACHE INTERNAL "")
endforeach()
set(${PROJECT_NAME}_USER_OPTIONS CACHE INTERNAL "")
endfunction(reset_Wrapper_Description_Cached_Variables)

#.rst:
#
# .. ifmode:: internal
#
#  .. |declare_Wrapper| replace:: ``declare_Wrapper``
#  .. _declare_Wrapper:
#
#  declare_Wrapper
#  ---------------
#
#   .. command:: declare_Wrapper(author institution mail year license address public_address description readme_file)
#
#     Declare the current CMake project has a PID external project wrapper. Internal counterpart of declare_PID_Wrapper.
#
#      :author: the name of the contact author.
#
#      :institution: the name of the contact author institution.
#
#      :year: the dates of project lifecyle.
#
#      :license: the name of the license applying to the wrapper's content.
#
#      :address: the url of the wrapper repository.
#
#      :public_address: the public counterpart (http) of address.
#
#      :description: description of the wrapper.
#
#      :readme_file: user defined  content of wrapper readme file.
#
macro(declare_Wrapper author institution mail year license address public_address description readme_file)
set(${PROJECT_NAME}_ROOT_DIR ${WORKSPACE_DIR}/wrappers/${PROJECT_NAME} CACHE INTERNAL "")
file(RELATIVE_PATH DIR_NAME ${CMAKE_SOURCE_DIR} ${CMAKE_BINARY_DIR})

#############################################################
############ Managing path into workspace ###################
#############################################################
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/share/cmake) # adding the cmake scripts files from the package
list(APPEND CMAKE_MODULE_PATH ${WORKSPACE_DIR}/share/cmake/find) # using common find modules of the workspace
list(APPEND CMAKE_MODULE_PATH ${WORKSPACE_DIR}/share/cmake/references) # using common find modules of the workspace
list(APPEND CMAKE_MODULE_PATH ${WORKSPACE_DIR}/share/cmake/platforms) # using platform check modules

#############################################################
############ Managing current platform ######################
#############################################################

if(CURRENT_PLATFORM AND NOT CURRENT_PLATFORM STREQUAL "")# a current platform is already defined
  #if any of the following variable changed, the cache of the CMake project needs to be regenerated from scratch
  set(TEMP_PLATFORM ${CURRENT_PLATFORM})
  set(TEMP_C_COMPILER ${CMAKE_C_COMPILER})
  set(TEMP_CXX_COMPILER ${CMAKE_CXX_COMPILER})
  set(TEMP_CMAKE_LINKER ${CMAKE_LINKER})
  set(TEMP_CMAKE_RANLIB ${CMAKE_RANLIB})
  set(TEMP_CMAKE_CXX_COMPILER_ID ${CMAKE_CXX_COMPILER_ID})
  set(TEMP_CMAKE_CXX_COMPILER_VERSION ${CMAKE_CXX_COMPILER_VERSION})
endif()

load_Current_Platform() #loading the current platform configuration

if(TEMP_PLATFORM) #check if any change occurred
  if( (NOT TEMP_PLATFORM STREQUAL CURRENT_PLATFORM) #the current platform has changed so we need to regenerate
      OR (NOT TEMP_C_COMPILER STREQUAL CMAKE_C_COMPILER)
      OR (NOT TEMP_CXX_COMPILER STREQUAL CMAKE_CXX_COMPILER)
      OR (NOT TEMP_CMAKE_LINKER STREQUAL CMAKE_LINKER)
      OR (NOT TEMP_CMAKE_RANLIB STREQUAL CMAKE_RANLIB)
      OR (NOT TEMP_CMAKE_CXX_COMPILER_ID STREQUAL CMAKE_CXX_COMPILER_ID)
      OR (NOT TEMP_CMAKE_CXX_COMPILER_VERSION STREQUAL CMAKE_CXX_COMPILER_VERSION)
    )
    message("[PID] INFO : cleaning the build folder after major environment change")
    hard_Clean_Wrapper(${PROJECT_NAME})
		reconfigure_Wrapper_Build(${PROJECT_NAME})
  endif()
endif()

set(CMAKE_BUILD_TYPE Release CACHE INTERNAL "")
set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-I")#to avoid the use of -isystem that may be not so well managed by some compilers
#############################################################
############ Managing build process #########################
#############################################################

if(DIR_NAME STREQUAL "build")

	  #################################################
	  ######## create global targets ##################
	  #################################################
		add_custom_target(build
	    ${CMAKE_COMMAND}	-DWORKSPACE_DIR=${WORKSPACE_DIR}
	           -DTARGET_EXTERNAL_PACKAGE=${PROJECT_NAME}
	           -DTARGET_EXTERNAL_VERSION=\${version}
					 	 -DTARGET_BUILD_MODE=\${mode}
					   -DGENERATE_BINARY_ARCHIVE=\${archive}
	           -DDO_NOT_EXECUTE_SCRIPT=\${skip_script}
					 	 -DUSE_SYSTEM_VARIANT=\${os_variant}
						 -P ${WORKSPACE_DIR}/share/cmake/system/commands/Build_PID_Wrapper.cmake
	    COMMENT "[PID] Building external package ${PROJECT_NAME} for platform ${CURRENT_PLATFORM} using environment ${CURRENT_ENVIRONMENT} ..."
	  )

		# adding an uninstall command (uninstall the whole installed version currently built)
		add_custom_target(uninstall
			${CMAKE_COMMAND}	-DWORKSPACE_DIR=${WORKSPACE_DIR}
	           -DTARGET_EXTERNAL_PACKAGE=${PROJECT_NAME}
	           -DTARGET_EXTERNAL_VERSION=\${version}
						 -P ${WORKSPACE_DIR}/share/cmake/system/commands/Uninstall_PID_Wrapper.cmake
			COMMAND ${CMAKE_COMMAND} -E  echo Uninstalling ${PROJECT_NAME} version ${${PROJECT_NAME}_VERSION}
			COMMENT "[PID] Uninstalling external package ${PROJECT_NAME} for platform ${CURRENT_PLATFORM} ..."
		)

		# reference file generation target
	  add_custom_target(referencing
	    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/share/ReferExternal${PROJECT_NAME}.cmake ${WORKSPACE_DIR}/share/cmake/references
	  	COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/share/Find${PROJECT_NAME}.cmake ${WORKSPACE_DIR}/share/cmake/find
	  	WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
	    COMMENT "[PID] installing references to the wrapped external package into the workspace..."
	  )

		# target used to create/replace version tags
	  add_custom_target(memorizing
			${CMAKE_COMMAND}	-DWORKSPACE_DIR=${WORKSPACE_DIR}
			-DCMAKE_SOURCE_DIR=${CMAKE_SOURCE_DIR}
			-DTARGET_EXTERNAL_PACKAGE=${PROJECT_NAME}
			-DTARGET_EXTERNAL_VERSION=\${version}
			-DREMOTE_ADDR=${address}
			-P ${WORKSPACE_DIR}/share/cmake/system/commands/Memorizing_PID_Wrapper_Version.cmake
	  	WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
	    COMMENT "[PID] memorizing new wrapper implementation ..."
	  )

  #################################################
  ######## Initializing cache variables ###########
  #################################################
  reset_Wrapper_Description_Cached_Variables()
	declare_Wrapper_Global_Cache_Options()
	reset_Documentation_Info()
	reset_CI_Variables()
	reset_Packages_Finding_Variables()
  init_PID_Version_Variable()
  init_Meta_Info_Cache_Variables("${author}" "${institution}" "${mail}" "${description}" "${year}" "${license}" "${address}" "${public_address}" "${readme_file}")
	check_For_Wrapper_Remote_Respositories()
	begin_Progress(${PROJECT_NAME} GLOBAL_PROGRESS_VAR) #managing the build from a global point of view
else()
  message("[PID] ERROR : please run cmake in the build folder of the wrapper ${PROJECT_NAME}.")
  return()
endif()
endmacro(declare_Wrapper)

#.rst:
#
# .. ifmode:: internal
#
#  .. |declare_Wrapper_Global_Cache_Options| replace:: ``declare_Wrapper_Global_Cache_Options``
#  .. _declare_Wrapper_Global_Cache_Options:
#
#  declare_Wrapper_Global_Cache_Options
#  ------------------------------------
#
#   .. command:: declare_Wrapper_Global_Cache_Options()
#
#     Declare configurable options for the currently built wrapper.
#
macro(declare_Wrapper_Global_Cache_Options)
option(ADDITIONNAL_DEBUG_INFO "Getting more info on debug mode or more PID messages (hidden by default)" OFF)
option(ENABLE_PARALLEL_BUILD "Package is built with optimum number of jobs with respect to system properties" ON)
endmacro(declare_Wrapper_Global_Cache_Options)

#.rst:
#
# .. ifmode:: internal
#
#  .. |set_Wrapper_Option| replace:: ``set_Wrapper_Option``
#  .. _set_Wrapper_Option:
#
#  set_Wrapper_Option
#  ------------------
#
#   .. command:: set_Wrapper_Option(name type default_value description)
#
#     Declare a user defined option for the currently built wrapper.
#
#      :name: the name of the option as it will appear in cmake gui.
#
#      :type: the type of the option as it will appear in cmake gui.
#
#      :default_value: the default value for the option (depends on type).
#
#      :description: the user readable description of the option as it will appear in cmake gui.
#
function(set_Wrapper_Option name type default_value description)
set(${name} ${default_value} CACHE ${type} "${description}")
set(${PROJECT_NAME}_USER_OPTIONS ${${PROJECT_NAME}_USER_OPTIONS} ${name} CACHE INTERNAL "")
set(${PROJECT_NAME}_USER_OPTION_${name}_TYPE ${type} CACHE INTERNAL "")
set(${PROJECT_NAME}_USER_OPTION_${name}_VALUE ${${name}} CACHE INTERNAL "")
message("[PID] INFO : Value of user option ${name} is \"${${PROJECT_NAME}_USER_OPTION_${name}_VALUE}\"")
endfunction(set_Wrapper_Option name type default_value)

#.rst:
#
# .. ifmode:: internal
#
#  .. |define_Wrapped_Project| replace:: ``define_Wrapped_Project``
#  .. _define_Wrapped_Project:
#
#  define_Wrapped_Project
#  ----------------------
#
#   .. command:: define_Wrapped_Project(authors_references licenses original_project_url)
#
#     Define the meta-data related to the wrapped external project, for the currently built wrapper.
#
#      :authors_references: the string explaining who are the original authors.
#
#      :licenses: the string explaining what licenses are used in original project.
#
#      :original_project_url: the url of the original project site.
#
function(define_Wrapped_Project authors_references licenses original_project_url)
set(${PROJECT_NAME}_WRAPPER_ORIGINAL_PROJECT_AUTHORS ${authors_references} CACHE INTERNAL "")
set(${PROJECT_NAME}_WRAPPER_ORIGINAL_PROJECT_LICENSES ${licenses} CACHE INTERNAL "")
set(${PROJECT_NAME}_WRAPPER_ORIGINAL_PROJECT_SITE ${original_project_url} CACHE INTERNAL "")
endfunction(define_Wrapped_Project)

#.rst:
#
# .. ifmode:: internal
#
#  .. |get_Wrapper_Site_Address| replace:: ``get_Wrapper_Site_Address``
#  .. _get_Wrapper_Site_Address:
#
#  get_Wrapper_Site_Address
#  ------------------------
#
#   .. command:: get_Wrapper_Site_Address(SITE_ADDRESS wrapper)
#
#     Get the root address of a wrapper static site page (either if it belongs to a framework or has its own lone static site)
#
#      :wrapper: the name of the wrapper.
#
#      :SITE_ADDRESS: the url of the wrapper static site.
#
function(get_Wrapper_Site_Address SITE_ADDRESS wrapper)
set(${SITE_ADDRESS} PARENT_SCOPE)
if(${wrapper}_FRAMEWORK) #package belongs to a framework
	if(EXISTS ${WORKSPACE_DIR}/share/cmake/references/ReferFramework${${wrapper}_FRAMEWORK}.cmake)
		include(${WORKSPACE_DIR}/share/cmake/references/ReferFramework${${wrapper}_FRAMEWORK}.cmake)
		set(${SITE_ADDRESS} ${${${wrapper}_FRAMEWORK}_FRAMEWORK_SITE}/packages/${wrapper} PARENT_SCOPE)
	endif()
elseif(${wrapper}_SITE_GIT_ADDRESS AND ${wrapper}_SITE_ROOT_PAGE)
	set(${SITE_ADDRESS} ${${wrapper}_SITE_ROOT_PAGE} PARENT_SCOPE)
endif()
endfunction(get_Wrapper_Site_Address)

#.rst:
#
# .. ifmode:: internal
#
#  .. |check_External_Version_Compatibility| replace:: ``check_External_Version_Compatibility``
#  .. _check_External_Version_Compatibility:
#
#  check_External_Version_Compatibility
#  ------------------------------------
#
#   .. command:: check_External_Version_Compatibility(IS_COMPATIBLE ref_version version_to_check)
#
#     Check, in the context of currently built external package wrapper, whether a given version of the external package is compatible with (i.e. can be used instead of) another one.
#
#      :ref_version: the reference version of the external project.
#
#      :version_to_check: the version whose compatibility is checked.
#
#      :IS_COMPATIBLE: the output variable that is TRUE if version_to_check is compatible with ref_version.
#
function(check_External_Version_Compatibility IS_COMPATIBLE ref_version version_to_check)
if(version_to_check VERSION_GREATER ref_version)#the version to check is greater to the reference version
	# so we need to check the compatibility constraints of that version => recursive call
	if(${PROJECT_NAME}_KNOWN_VERSION_${version_to_check}_COMPATIBLE_WITH) #the version to check is compatible with another version
		#check againt this version
		check_External_Version_Compatibility(IS_RECURSIVE_COMPATIBLE ${ref_version} ${${PROJECT_NAME}_KNOWN_VERSION_${version_to_check}_COMPATIBLE_WITH})
		set(${IS_COMPATIBLE} ${IS_RECURSIVE_COMPATIBLE} PARENT_SCOPE)
	else() #not compatible with a previous version and greater than current
			set(${IS_COMPATIBLE} FALSE PARENT_SCOPE)
	endif()
else()#the version to check is compatible as it target a version lower or equal to the reference version
	set(${IS_COMPATIBLE} TRUE PARENT_SCOPE)
endif()
endfunction(check_External_Version_Compatibility)

#.rst:
#
# .. ifmode:: internal
#
#  .. |generate_Wrapper_Find_File| replace:: ``generate_Wrapper_Find_File``
#  .. _generate_Wrapper_Find_File:
#
#  generate_Wrapper_Find_File
#  --------------------------
#
#   .. command:: generate_Wrapper_Find_File()
#
#     Generate the find file of the currently built wrapper.
#
function(generate_Wrapper_Find_File)
	set(FIND_FILE_KNOWN_VERSIONS ${${PROJECT_NAME}_KNOWN_VERSIONS})
	set(FIND_FILE_VERSIONS_COMPATIBLITY)
	# first step verifying that at least a version defines its compatiblity
	set(COMPATIBLE_VERSION_FOUND FALSE)
	foreach(version IN LISTS ${PROJECT_NAME}_KNOWN_VERSIONS)
		if(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPATIBLE_WITH)
			set(COMPATIBLE_VERSION_FOUND TRUE)
			break()
		endif()
	endforeach()
	# second step defines version compatibility at fine grain only if needed
	if(COMPATIBLE_VERSION_FOUND)
		foreach(version IN LISTS ${PROJECT_NAME}_KNOWN_VERSIONS)
			set(FIRST_INCOMPATIBLE_VERSION)
			set(COMPATIBLE_VERSION_FOUND FALSE)
			foreach(other_version IN LISTS ${PROJECT_NAME}_KNOWN_VERSIONS)
				if(other_version VERSION_GREATER version)#the version is greater than the currenlty managed one
					if(${PROJECT_NAME}_KNOWN_VERSION_${other_version}_COMPATIBLE_WITH)
						check_External_Version_Compatibility(IS_COMPATIBLE ${version} ${${PROJECT_NAME}_KNOWN_VERSION_${other_version}_COMPATIBLE_WITH})
						if(NOT IS_COMPATIBLE)#not compatible
							if(NOT FIRST_INCOMPATIBLE_VERSION)
								set(FIRST_INCOMPATIBLE_VERSION ${${PROJECT_NAME}_KNOWN_VERSION_${other_version}_COMPATIBLE_WITH}) #memorize the lower incompatible version with ${version}
							elseif(FIRST_INCOMPATIBLE_VERSION VERSION_GREATER ${${PROJECT_NAME}_KNOWN_VERSION_${other_version}_COMPATIBLE_WITH})
								set(FIRST_INCOMPATIBLE_VERSION ${${PROJECT_NAME}_KNOWN_VERSION_${other_version}_COMPATIBLE_WITH}) #memorize the lower incompatible version with ${version}
							endif()
						else()
							set(COMPATIBLE_VERSION_FOUND TRUE) #at least a compatible version has been found
						endif()
					else()#this other version is compatible with nothing
						if(NOT FIRST_INCOMPATIBLE_VERSION)
							set(FIRST_INCOMPATIBLE_VERSION ${other_version}) #memorize the lower incompatible version with ${version}
						elseif(FIRST_INCOMPATIBLE_VERSION VERSION_GREATER ${other_version})
							set(FIRST_INCOMPATIBLE_VERSION ${other_version}) #memorize the lower incompatible version with ${version}
						endif()
					endif()
				endif()
			endforeach()
			if(FIRST_INCOMPATIBLE_VERSION)#if there is a known incompatible version
				set(FIND_FILE_VERSIONS_COMPATIBLITY "${FIND_FILE_VERSIONS_COMPATIBLITY}\nset(${PROJECT_NAME}_PID_KNOWN_VERSION_${version}_GREATER_VERSIONS_COMPATIBLE_UP_TO ${FIRST_INCOMPATIBLE_VERSION} CACHE INTERNAL \"\")")
		  elseif(COMPATIBLE_VERSION_FOUND)#at least one compatible version has been found but no incompatible versions defined
				#we need to say that version are all compatible by specifying an "infinite version"
				set(FIND_FILE_VERSIONS_COMPATIBLITY "${FIND_FILE_VERSIONS_COMPATIBLITY}\nset(${PROJECT_NAME}_PID_KNOWN_VERSION_${version}_GREATER_VERSIONS_COMPATIBLE_UP_TO 100000.100000.100000 CACHE INTERNAL \"\")")
			endif()
		endforeach()
	endif()
	# generating/installing the generic cmake find file for the package
	configure_file(${WORKSPACE_DIR}/share/patterns/wrappers/FindExternalPackage.cmake.in ${CMAKE_BINARY_DIR}/share/Find${PROJECT_NAME}.cmake @ONLY)
	install(FILES ${CMAKE_BINARY_DIR}/share/Find${PROJECT_NAME}.cmake DESTINATION ${WORKSPACE_DIR}/share/cmake/find) #install in the worskpace cmake directory which contains cmake find modules
endfunction(generate_Wrapper_Find_File)

#.rst:
#
# .. ifmode:: internal
#
#  .. |generate_Wrapper_Build_File| replace:: ``generate_Wrapper_Build_File``
#  .. _generate_Wrapper_Build_File:
#
#  generate_Wrapper_Build_File
#  ---------------------------
#
#   .. command:: generate_Wrapper_Build_File(path_to_file)
#
#     Generate the cmake file of the currently built wrapper that constains information about its built content.
#
#      :path_to_file: the path to the file where build info is written.
#
function(generate_Wrapper_Build_File path_to_file)
#write info about versions
file(WRITE ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSIONS ${${PROJECT_NAME}_KNOWN_VERSIONS} CACHE INTERNAL \"\")\n")
foreach(version IN LISTS ${PROJECT_NAME}_KNOWN_VERSIONS)
	file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPLOY_SCRIPT ${${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPLOY_SCRIPT} CACHE INTERNAL \"\")\n")
	file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_POST_INSTALL_SCRIPT ${${PROJECT_NAME}_KNOWN_VERSION_${version}_POST_INSTALL_SCRIPT} CACHE INTERNAL \"\")\n")
	file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_PRE_USE_SCRIPT ${${PROJECT_NAME}_KNOWN_VERSION_${version}_PRE_USE_SCRIPT} CACHE INTERNAL \"\")\n")
	file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPATIBLE_WITH ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPATIBLE_WITH} CACHE INTERNAL \"\")\n")
	file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_SONAME \"${${PROJECT_NAME}_KNOWN_VERSION_${version}_SONAME}\" CACHE INTERNAL \"\")\n")

	#manage platform configuration description
	file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_CONFIGURATIONS ${${PROJECT_NAME}_KNOWN_VERSION_${version}_CONFIGURATIONS} CACHE INTERNAL \"\")\n")
	foreach(config IN LISTS ${PROJECT_NAME}_KNOWN_VERSION_${version}_CONFIGURATIONS)
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_CONFIGURATION_${config} ${${PROJECT_NAME}_KNOWN_VERSION_${version}_CONFIGURATION_${config}} CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_CONFIGURATION_${config}_ARGS ${${PROJECT_NAME}_KNOWN_VERSION_${version}_CONFIGURATION_${config}_ARGS} CACHE INTERNAL \"\")\n")
	endforeach()

	#manage package dependencies
	file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCIES ${${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCIES} CACHE INTERNAL \"\")\n")
	if(${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCIES)
		foreach(package IN LISTS ${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCIES)
			file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCY_${package}_VERSIONS ${${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCY_${package}_VERSIONS} CACHE INTERNAL \"\")\n")
			file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCY_${package}_VERSIONS_EXACT ${${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCY_${package}_VERSIONS_EXACT} CACHE INTERNAL \"\")\n")
			file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCY_${package}_ALTERNATIVE_VERSION_USED ${${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPENDENCY_${package}_ALTERNATIVE_VERSION_USED} CACHE INTERNAL \"\")\n")
		endforeach()
	endif()

	#manage components description
	file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENTS ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENTS} CACHE INTERNAL \"\")\n")
	foreach(component IN LISTS ${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENTS)
		#manage information local to the component
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SHARED_LINKS ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SHARED_LINKS} CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SONAME ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SONAME} CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_STATIC_LINKS ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_STATIC_LINKS} CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_INCLUDES ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_INCLUDES} CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEFINITIONS \"${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEFINITIONS}\" CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_OPTIONS ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_OPTIONS} CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_C_STANDARD ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_C_STANDARD} CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_CXX_STANDARD ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_CXX_STANDARD} CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_RUNTIME_RESOURCES ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_RUNTIME_RESOURCES} CACHE INTERNAL \"\")\n")

		#manage information related to system dependencies
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_INCLUDES ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_INCLUDES} CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_LIB_DIRS ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_LIB_DIRS} CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_DEFINITIONS \"${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_DEFINITIONS}\" CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_OPTIONS ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_OPTIONS} CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_LINKS ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_LINKS} CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_C_STANDARD ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_C_STANDARD} CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_CXX_STANDARD ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_CXX_STANDARD} CACHE INTERNAL \"\")\n")
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_RUNTIME_RESOURCES ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_RUNTIME_RESOURCES} CACHE INTERNAL \"\")\n")

		#manage information related to internal dependencies
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCIES ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCIES} CACHE INTERNAL \"\")\n")
		foreach(dependency IN LISTS ${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCIES)
			file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCY_${dependency}_DEFINITIONS \"${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCY_${dependency}_DEFINITIONS}\" CACHE INTERNAL \"\")\n")
			file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCY_${dependency}_EXPORTED ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCY_${dependency}_EXPORTED} CACHE INTERNAL \"\")\n")
		endforeach()

		#manage information related to other external dependencies
		file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCIES ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCIES} CACHE INTERNAL \"\")\n")
		foreach(package IN LISTS ${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCIES)
			#reset component level dependencies first
			file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package} ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}} CACHE INTERNAL \"\")\n")
			foreach(dependency IN LISTS ${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package})
				file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_${dependency}_DEFINITIONS \"${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_${dependency}_DEFINITIONS}\" CACHE INTERNAL \"\")\n")
				file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_${dependency}_EXPORTED ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_${dependency}_EXPORTED} CACHE INTERNAL \"\")\n")
			endforeach()

			#then reset direct package level dependencies of the component
			file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_INCLUDES ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_INCLUDES} CACHE INTERNAL \"\")\n")
			file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_SHARED ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_SHARED} CACHE INTERNAL \"\")\n")
			file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_STATIC ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_STATIC} CACHE INTERNAL \"\")\n")
			file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_DEFINITIONS \"${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_DEFINITIONS}\" CACHE INTERNAL \"\")\n")
			file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_OPTIONS ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_OPTIONS} CACHE INTERNAL \"\")\n")
			file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_C_STANDARD ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_C_STANDARD} CACHE INTERNAL \"\")\n")
			file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_CXX_STANDARD ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_CXX_STANDARD} CACHE INTERNAL \"\")\n")
			file(APPEND ${path_to_file} "set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_RUNTIME_RESOURCES ${${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_RUNTIME_RESOURCES} CACHE INTERNAL \"\")\n")
		endforeach()
	endforeach()
endforeach()

#writing options that can be useful to control the build process
file(APPEND ${path_to_file} "set(ENABLE_PARALLEL_BUILD ${ENABLE_PARALLEL_BUILD} CACHE INTERNAL \"\")\n")
file(APPEND ${path_to_file} "set(ADDITIONNAL_DEBUG_INFO ${ADDITIONNAL_DEBUG_INFO} CACHE INTERNAL \"\")\n")

#write version about user options
file(APPEND ${path_to_file} "set(${PROJECT_NAME}_USER_OPTIONS ${${PROJECT_NAME}_USER_OPTIONS} CACHE INTERNAL \"\")\n")
foreach(opt IN LISTS ${PROJECT_NAME}_USER_OPTIONS)
	file(APPEND ${path_to_file} "set(${PROJECT_NAME}_USER_OPTION_${opt}_TYPE ${${PROJECT_NAME}_USER_OPTION_${opt}_TYPE} CACHE INTERNAL \"\")\n")
	file(APPEND ${path_to_file} "set(${PROJECT_NAME}_USER_OPTION_${opt}_VALUE ${${PROJECT_NAME}_USER_OPTION_${opt}_VALUE} CACHE INTERNAL \"\")\n")
endforeach()

endfunction(generate_Wrapper_Build_File)

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_Wrapper_Documentation_Target| replace:: ``create_Wrapper_Documentation_Target``
#  .. _create_Wrapper_Documentation_Target:
#
#  create_Wrapper_Documentation_Target
#  -----------------------------------
#
#   .. command:: create_Wrapper_Documentation_Target()
#
#    Create a "site" target used to update the sattic site of the currentlt built external package wrapper.
#
function(create_Wrapper_Documentation_Target)
package_License_Is_Closed_Source(CLOSED ${PROJECT_NAME} TRUE)
get_Platform_Variables(BASENAME curr_platform_str)
set(INCLUDING_BINARIES FALSE)
if(NOT CLOSED)#check if project is closed source or not
	# management of binaries publication
	if(${PROJECT_NAME}_BINARIES_AUTOMATIC_PUBLISHING)
		set(INCLUDING_BINARIES TRUE)
	endif()
endif()
################################################################################
######## create global target from entire project description ##################
################################################################################
if(${PROJECT_NAME}_SITE_GIT_ADDRESS) #the publication of the static site is done within a lone static site

	add_custom_target(site
		COMMAND ${CMAKE_COMMAND} 	-DWORKSPACE_DIR=${WORKSPACE_DIR}
						-DIN_CI_PROCESS=${IN_CI_PROCESS}
						-DTARGET_PACKAGE=${PROJECT_NAME}
						-DKNOWN_VERSIONS="${${PROJECT_NAME}_KNOWN_VERSIONS}"
						-DTARGET_PLATFORM=${curr_platform_str}
						-DTARGET_INSTANCE=${CURRENT_PLATFORM_INSTANCE}
						-DCMAKE_COMMAND=${CMAKE_COMMAND}
						-DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}
						-DINCLUDES_INSTALLER=${INCLUDING_BINARIES}
						-DSYNCHRO=\${synchro}
						-DFORCED_UPDATE=\${force}
						-DSITE_GIT="${${PROJECT_NAME}_SITE_GIT_ADDRESS}"
						-DPACKAGE_PROJECT_URL="${${PROJECT_NAME}_PROJECT_PAGE}"
						-DPACKAGE_SITE_URL="${${PROJECT_NAME}_SITE_ROOT_PAGE}"
			 -P ${WORKSPACE_DIR}/share/cmake/system/commands/Build_PID_Site.cmake)
elseif(${PROJECT_NAME}_FRAMEWORK) #the publication of the static site is done with a framework
	add_custom_target(site
		COMMAND ${CMAKE_COMMAND} 	-DWORKSPACE_DIR=${WORKSPACE_DIR}
						-DIN_CI_PROCESS=${IN_CI_PROCESS}
						-DTARGET_PACKAGE=${PROJECT_NAME}
						-DKNOWN_VERSIONS="${${PROJECT_NAME}_KNOWN_VERSIONS}"
						-DTARGET_PLATFORM=${curr_platform_str}
						-DTARGET_INSTANCE=${CURRENT_PLATFORM_INSTANCE}
						-DCMAKE_COMMAND=${CMAKE_COMMAND}
						-DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}
						-DTARGET_FRAMEWORK=${${PROJECT_NAME}_FRAMEWORK}
						-DINCLUDES_INSTALLER=${INCLUDING_BINARIES}
						-DSYNCHRO=\${synchro}
						-DFORCED_UPDATE=\${force}
						-DPACKAGE_PROJECT_URL="${${PROJECT_NAME}_PROJECT_PAGE}"
			 -P ${WORKSPACE_DIR}/share/cmake/system/commands/Build_PID_Site.cmake
	)
endif()
endfunction(create_Wrapper_Documentation_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |build_Wrapped_Project| replace:: ``build_Wrapped_Project``
#  .. _build_Wrapped_Project:
#
#  build_Wrapped_Project
#  ---------------------
#
#   .. command:: build_Wrapped_Project()
#
#    Finalize the configuration of the current wrapper project and create adequate targets for building/installating it. Internal counterpart of build_PID_Wrapper function.
#
macro(build_Wrapped_Project)

#####################################################################################################################
######## recursion into version subdirectories to describe the content of the external package ######################
#####################################################################################################################

list_Version_Subdirectories(VERSIONS_DIRS ${CMAKE_SOURCE_DIR}/src)

foreach(version IN LISTS VERSIONS_DIRS)
 	add_subdirectory(src/${version})
endforeach()

################################################################################
######## generating CMake configuration files used by PID ######################
################################################################################
generate_Wrapper_Build_File(${CMAKE_BINARY_DIR}/Build${PROJECT_NAME}.cmake)
generate_Wrapper_Reference_File(${CMAKE_BINARY_DIR}/share/ReferExternal${PROJECT_NAME}.cmake)
generate_Wrapper_Readme_Files() # generating and putting into source directory the readme file used by gitlab
generate_Wrapper_License_File() # generating and putting into source directory the file containing license info about the package
generate_Wrapper_Find_File() # generating/installing the generic cmake find file for the external package
configure_Wrapper_Pages() #generate markdown pages for package web site
generate_Wrapper_CI_Config_File()#generating the CI config file for the wrapper
create_Wrapper_Documentation_Target() # create target for generating documentation

finish_Progress("${GLOBAL_PROGRESS_VAR}") #managing the build from a global point of view
endmacro(build_Wrapped_Project)

#.rst:
#
# .. ifmode:: internal
#
#  .. |belongs_To_Known_Versions| replace:: ``belongs_To_Known_Versions``
#  .. _belongs_To_Known_Versions:
#
#  belongs_To_Known_Versions
#  -------------------------
#
#   .. command:: belongs_To_Known_Versions(BELONGS_TO version)
#
#    Check whether a given version of the currently built wrapper belongs to already defined versions in this wrapper.
#
#      :version: the given external package version.
#
#      :BELONGS_TO: the output variable that is TRUE if version belongs to versions already defined in wrapper.
#
function(belongs_To_Known_Versions BELONGS_TO version)
	list(FIND ${PROJECT_NAME}_KNOWN_VERSIONS ${version} INDEX)
	if(INDEX EQUAL -1)
		set(${BELONGS_TO} FALSE PARENT_SCOPE)
	else()
		set(${BELONGS_TO} TRUE PARENT_SCOPE)
	endif()
endfunction(belongs_To_Known_Versions)

#.rst:
#
# .. ifmode:: internal
#
#  .. |add_Known_Version| replace:: ``add_Known_Version``
#  .. _add_Known_Version:
#
#  add_Known_Version
#  -----------------
#
#   .. command:: add_Known_Version(version deploy_file_name compatible_with_version so_name post_install_script)
#
#    Memorize a new known version of the external package in the context of currently built wrapper (the target version folder that can be found in src folder and contains the script used to build/install the project). Internal counterpart of add_PID_Wrapper_Known_Version.
#
#      :version: the given external package version.
#
#      :deploy_file_name: the path to the deployment script used to build/install the given version, relative to this version folder.
#
#      :compatible_with_version: the immediate previous version defined in the wrapper, with which the given version is compatible with. May be let empty if teh given version is not compatible with a previous one.
#
#      :so_name: the soname to use by default for all shared libraries of the version (may be empty of no soname used).
#
#      :post_install_script: the path to the post install script that must be executed anytime the given version is deployed, relative to this version folder in source tree.
#
#      :pre_use_script: the path to the pre use script that is executed anytime the given version is used by another package to perform additional configuration, relative to this version folder in source tree.
#
function(add_Known_Version version deploy_file_name compatible_with_version so_name post_install_script pre_use_script)
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
append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSIONS ${version})
set(${PROJECT_NAME}_KNOWN_VERSION_${version}_DEPLOY_SCRIPT ${deploy_file_name} CACHE INTERNAL "")
set(${PROJECT_NAME}_KNOWN_VERSION_${version}_POST_INSTALL_SCRIPT ${post_install_script} CACHE INTERNAL "")
set(${PROJECT_NAME}_KNOWN_VERSION_${version}_PRE_USE_SCRIPT ${post_install_script} CACHE INTERNAL "")
set(${PROJECT_NAME}_KNOWN_VERSION_${version}_SONAME "${so_name}" CACHE INTERNAL "")
if(compatible_with_version AND NOT compatible_with_version STREQUAL "")
	set(${PROJECT_NAME}_KNOWN_VERSION_${version}_COMPATIBLE_WITH ${compatible_with_version} CACHE INTERNAL "")
endif()
set(CURRENT_MANAGED_VERSION ${version} CACHE INTERNAL "")
endfunction(add_Known_Version)

#.rst:
#
# .. ifmode:: internal
#
#  .. |declare_Wrapped_Configuration| replace:: ``declare_Wrapped_Configuration``
#  .. _declare_Wrapped_Configuration:
#
#  declare_Wrapped_Configuration
#  -----------------------------
#
#   .. command:: declare_Wrapped_Configuration(platform configurations)
#
#    Declare a platform constraint for currenlty described version of the external package. Internal counterpart of declare_PID_Wrapper_Platform_Configuration.
#
#      :platform: the identifier of the platform.
#
#      :configurations: the list of configurations that must be validated by current platform.
#
#      :options: the list of configurations that may be validated or not by current platform.
#
function(declare_Wrapped_Configuration platform configurations options)
if(platform)# if a platform constraint applies
	foreach(config IN LISTS configurations)
		parse_System_Check_Constraints(CONFIG_NAME CONFIG_ARGS "${config}")#need to parse the configuration strings to extract arguments (if any)
		if(NOT CONFIG_NAME)
			finish_Progress(${GLOBAL_PROGRESS_VAR})
			message(FATAL_ERROR "[PID] CRITICAL ERROR : configuration check ${config} is ill formed.")
			return()
		elseif(NOT ${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATION_${CONFIG_NAME} # no other platform constraint already applies
			OR NOT ${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATION_${CONFIG_NAME} STREQUAL "all")#the configuration has no constraint
				append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATION_${CONFIG_NAME} "${platform}")
		endif()
		append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATIONS "${CONFIG_NAME}")# update the list of required configurations
		set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATION_${CONFIG_NAME}_ARGS "${CONFIG_ARGS}" CACHE INTERNAL "")

		if(platform STREQUAL CURRENT_PLATFORM)
			#check that the configuration applies to the current platform if the current platform is the target of this constraint
			set(${CONFIG_NAME}_AVAILABLE FALSE CACHE INTERNAL "")#even if configuration check with previous arguments was OK reset it to test with new arguments
			check_System_Configuration(RESULT_OK CONFIG_NAME CONSTRAINTS "${config}" Release)
			if(NOT RESULT_OK)
				finish_Progress(${GLOBAL_PROGRESS_VAR})
				message(FATAL_ERROR "[PID] CRITICAL ERROR : ${PROJECT_NAME} version ${CURRENT_MANAGED_VERSION} cannot satify configuration ${config}!")
				return()
			endif()
			set(${CONFIG_NAME}_AVAILABLE TRUE CACHE INTERNAL "")#this variable will be usable in deploy scripts
		endif()
	endforeach()

	#now dealing with options
	foreach(config IN LISTS options)
		if(platform STREQUAL CURRENT_PLATFORM)
			check_System_Configuration(RESULT_OK CONFIG_NAME CONSTRAINTS "${config}" Release)
			if(RESULT_OK)
				set(${CONFIG_NAME}_AVAILABLE TRUE CACHE INTERNAL "")#this variable will be usable in deploy scripts
			else()
				if(CONFIG_NAME)#can reset only if CONFIG_NAME has been extracted
					set(${CONFIG_NAME}_AVAILABLE FALSE CACHE INTERNAL "")#even if configuration check with previous arguments was OK reset it to test with new arguments
				else()
					finish_Progress(${GLOBAL_PROGRESS_VAR})
					message(FATAL_ERROR "[PID] CRITICAL ERROR : configuration check ${config} is ill formed.")
					return()
				endif()
			endif()

			if(${CONFIG_NAME}_AVAILABLE) #if available then it is considered as "used"
				append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATIONS "${CONFIG_NAME}")
				if(NOT ${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATION_${CONFIG_NAME} # no other platform constraint already applies
					OR NOT ${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATION_${CONFIG_NAME} STREQUAL "all")#the configuration has no constraint
						append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATION_${CONFIG_NAME} "${platform}")
						set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATION_${CONFIG_NAME}_ARGS "${CONSTRAINTS}" CACHE INTERNAL "")
				endif()
			endif()
		endif()
	endforeach()

else()#no platform constraint applies => this platform configuration is adequate for all platforms
	foreach(config IN LISTS configurations)
		parse_System_Check_Constraints(CONFIG_NAME CONFIG_ARGS "${config}")
		if(NOT CONFIG_NAME)
			finish_Progress(${GLOBAL_PROGRESS_VAR})
			message(FATAL_ERROR "[PID] CRITICAL ERROR : configuration check ${config} is ill formed.")
			return()
		endif()
		set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATION_${CONFIG_NAME} "all" CACHE INTERNAL "")
		#check that the configuration applies to the current platform anytime
		append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATIONS "${CONFIG_NAME}")# update the list of required configurations

		#now check the configuration immediately because it should work with any platform
		set(${CONFIG_NAME}_AVAILABLE FALSE CACHE INTERNAL "")#even if configuration check with previous arguments was OK reset it to test with new arguments
		check_System_Configuration(RESULT_OK CONFIG_NAME CONSTRAINTS "${config}" Release)
		if(NOT RESULT_OK)
			finish_Progress(${GLOBAL_PROGRESS_VAR})
			message(FATAL_ERROR "[PID] CRITICAL ERROR : ${PROJECT_NAME} version ${CURRENT_MANAGED_VERSION} cannot satify configuration ${config} with current platform!")
			return()
		endif()
		set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATION_${CONFIG_NAME}_ARGS "${CONFIG_ARGS}" CACHE INTERNAL "")
		set(${CONFIG_NAME}_AVAILABLE TRUE CACHE INTERNAL "")#this variable will be usable in deploy scripts
	endforeach()

	#now dealing with options
	foreach(config IN LISTS options)
		parse_System_Check_Constraints(CONFIG_NAME CONFIG_ARGS "${config}")
		if(NOT CONFIG_NAME)
			finish_Progress(${GLOBAL_PROGRESS_VAR})
			message(FATAL_ERROR "[PID] ERROR : configuration check ${config} is ill formed. Configuration being optional it is skipped automatically.")
			return()
		endif()
		check_System_Configuration(RESULT_OK CONFIG_NAME CONSTRAINTS "${config}" Release)
		if(RESULT_OK)
			set(${CONFIG_NAME}_AVAILABLE TRUE CACHE INTERNAL "")#this variable will be usable in deploy scripts
		else()
			if(CONFIG_NAME)#can reset only if CONFIG_NAME has been extracted
				set(${CONFIG_NAME}_AVAILABLE FALSE CACHE INTERNAL "")#even if configuration check with previous arguments was OK reset it to test with new arguments
			else()
				finish_Progress(${GLOBAL_PROGRESS_VAR})
				message(FATAL_ERROR "[PID] CRITICAL ERROR : configuration check ${config} is ill formed.")
				return()
			endif()
		endif()

		if(${CONFIG_NAME}_AVAILABLE) #if available then it is considered as used
			append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATIONS "${CONFIG_NAME}")
			if(NOT ${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATION_${CONFIG_NAME} # no other platform constraint already applies
				OR NOT ${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATION_${CONFIG_NAME} STREQUAL "all")#the configuration has no constraint
				set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATION_${CONFIG_NAME} "all" CACHE INTERNAL "")
				set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_CONFIGURATION_${CONFIG_NAME}_ARGS "${CONFIG_ARGS}" CACHE INTERNAL "")
			endif()
		endif()
	endforeach()
endif()
endfunction(declare_Wrapped_Configuration)

#.rst:
#
# .. ifmode:: internal
#
#  .. |add_External_Package_Dependency_To_Wrapper| replace:: ``add_External_Package_Dependency_To_Wrapper``
#  .. _add_External_Package_Dependency_To_Wrapper:
#
#  add_External_Package_Dependency_To_Wrapper
#  ------------------------------------------
#
#   .. command:: add_External_Package_Dependency_To_Wrapper(external_version dep_package list_of_versions exact_versions list_of_components)
#
#    Set the cache variables describing a dependency between a version a version of the external package and another external package.
#
#      :external_version: the given version of the currently described external package.
#
#      :dep_package: the name of external package that is the dependency.
#
#      :list_of_versions: the list of possible version for the dependency.
#
#      :exact_versions: the list of exact versions among possible ones for the dependency.
#
#      :list_of_components: the list of components that must exist in dependency.
#
function(add_External_Package_Dependency_To_Wrapper external_version dep_package list_of_versions exact_versions list_of_components)
	append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${external_version}_DEPENDENCIES ${dep_package})#dep package must be deployed in irder t use current project
	append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${external_version}_DEPENDENCY_${dep_package}_VERSIONS "${list_of_versions}")
	set(${PROJECT_NAME}_KNOWN_VERSION_${external_version}_DEPENDENCY_${dep_package}_VERSIONS_EXACT "${exact_versions}" CACHE INTERNAL "")
	append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${external_version}_DEPENDENCY_${dep_package}_COMPONENTS "${list_of_components}")
endfunction(add_External_Package_Dependency_To_Wrapper)

#.rst:
#
# .. ifmode:: internal
#
#  .. |declare_Wrapped_External_Dependency| replace:: ``declare_Wrapped_External_Dependency``
#  .. _declare_Wrapped_External_Dependency:
#
#  declare_Wrapped_External_Dependency
#  -----------------------------------
#
#   .. command:: declare_Wrapped_External_Dependency(external_version dep_package list_of_versions exact_versions list_of_components)
#
#    Define a dependency between the currenlty defined version of the external package and another external package. Internal counterpart of declare_PID_Wrapper_External_Dependency.
#
#      :dep_package: the name of external package that is the dependency.
#
#      :list_of_versions: the list of possible version for the dependency.
#
#      :exact_versions: the list of exact versions among possible ones for the dependency.
#
#      :list_of_components: the list of components that must exist in dependency.
#
function(declare_Wrapped_External_Dependency dep_package list_of_versions exact_versions list_of_components)
if(NOT CURRENT_MANAGED_VERSION)#may be necessary to avoid errors at first configuration
	return()
endif()
#directly put in cache the declaration of the dependency
add_External_Package_Dependency_To_Wrapper(${CURRENT_MANAGED_VERSION} ${dep_package} "${list_of_versions}" "${exact_versions}" "${list_of_components}")

### now finding external package dependencies as they are required to build the package
### 1) setting user cache variable. The goal is to given users the control "by-hand" on the version used for a given dependency ###
#1.A) preparing message coming with this user cache variable
if(NOT list_of_versions) # no version constraint specified
	set(message_str "Select version of dependency ${dep_package} to be used by entering either keyword ANY or a valid version number.")
else()#there are version specified
	fill_String_From_List(list_of_versions available_versions) #get available version as a string (used to print them)
	set(message_str "Select the version of dependency ${dep_package} to be used among versions: ${available_versions}.")
	list(LENGTH list_of_versions SIZE)
	list(GET list_of_versions 0 default_version) #by defaut this is the first element in the list that is taken
endif()
if(optional) #message for the optional dependency includes the possiiblity to input NONE
	set(message_str "${message_str} Or use NONE to avoid using this dependency.")
endif()
#1.B) creating the user cache entries
if(NOT list_of_versions) # no version constraint specified
	### setting default cache variable that user can directly manage "by-hand" ###
	if(optional)
		#set the cache option, NONE by default
		set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED "NONE" CACHE STRING "${message_str}")
	else()#dependency is not optional so any version can be used
		set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED "ANY" CACHE STRING "${message_str}")#no message since nothing to say to the user
	endif()
else()#there are version(s) specified
	if(optional)
		# since dependency is optional, we simply just do not use it by default to avoid unresolvable configuration
		set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED "NONE" CACHE STRING "${message_str}.")#initial value set to unused
	else() #version of a required dependency
		if(SIZE EQUAL 1)#no alternative a given version constraint must be satisfied
			set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED ${default_version} CACHE INTERNAL "" FORCE)#do not show the variable to the user
		else() #we can choose among many versions, use the first specified by default
			set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED ${default_version} CACHE STRING "${message_str}")
		endif()
	endif()
endif()

### 2) check and set the value of the user cache entry dependening on constraints coming from the build context (dependent build or classical build) #####
set(USE_EXACT FALSE)
set(chosen_version_for_selection)
# check if a version of this dependency is required by another package used in the current build process and memorize this version
get_Chosen_Version_In_Current_Process(REQUIRED_VERSION IS_EXACT IS_SYSTEM ${dep_package})
if(REQUIRED_VERSION) #the package is already used as a dependency in the current build process so we need to reuse the version already specified or use a compatible one instead
	if(list_of_versions) #list of possible versions is constrained
		#finding the best compatible version, if any (otherwise returned "version" variable is empty)
		find_Best_Compatible_Version(force_version TRUE ${dep_package} ${REQUIRED_VERSION} "${IS_EXACT}" "${IS_SYSTEM}" "${list_of_versions}" "${exact_versions}")
		if(NOT force_version)#the build context is a dependent build and no compatible version has been found
			if(optional)#hopefully the dependency is optional so we can deactivate it
				set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED "NONE" CACHE STRING "${message_str}" FORCE)
				message("[PID] WARNING : dependency ${dep_package} for package ${PROJECT_NAME} is optional and has been automatically deactivated as its version (${force_version}) is not compatible with version ${REQUIRED_VERSION} previously required by other packages.")
			else()#this is to ensure that on a dependent build an adequate version has been chosen from the list of possible versions
				finish_Progress(${GLOBAL_PROGRESS_VAR})
				message(FATAL_ERROR "[PID] CRITICAL ERROR : In ${PROJECT_NAME} dependency ${dep_package} is used in another package with version ${REQUIRED_VERSION}, but this version is not usable in this project that depends on versions : ${available_versions}.")
				return()
			endif()
		endif()
		if(IS_SYSTEM)
			set(chosen_version_for_selection "SYSTEM")#specific keyword to use to specify that the SYSTEM version is in use
		else()
			set(chosen_version_for_selection ${force_version})
		endif()
		#simply reset the description to first found
		if(SIZE EQUAL 1)#only one possible version => no more provide it to to user
			set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED ${chosen_version_for_selection} CACHE INTERNAL "" FORCE)
		else()#many possible versions now !!
			set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED ${chosen_version_for_selection} CACHE STRING "${message_str}" FORCE)
		endif()
	else()#no constraint on version => use the required one
		if(IS_SYSTEM)
			set(chosen_version_for_selection "SYSTEM")#specific keyword to use to specify that the SYSTEM version is in use
		else()
			set(chosen_version_for_selection ${REQUIRED_VERSION})
		endif()
		set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED ${chosen_version_for_selection} CACHE STRING "${message_str}" FORCE)#explicitlty set the dependency to the chosen version number
	endif()
	set(USE_EXACT ${IS_EXACT})

else()#classical build => perform only corrective actions if cache variable is no more compatible with user specifications
	if(NOT ${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED)#SPECIAL CASE: no value set by user (i.e. error of the user)!!
		if(optional)#hopefully the dependency is optional so we can force its deactivation
			set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED "NONE" CACHE STRING "${message_str}" FORCE)#explicitlty deactivate the optional dependency (corrective action)
			message("[PID] WARNING : dependency ${dep_package} for package ${PROJECT_NAME} is optional and has been automatically deactivated because no version was specified by the user.")
		elseif(list_of_possible_versions)#set if to default version
			if(SIZE EQUAL 1)#only one possible version => do not provide it to to user
				set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED ${default_version} CACHE INTERNAL "" FORCE)
			else()
				set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED ${default_version} CACHE STRING "${message_str}" FORCE)
			endif()
		else()#set if to ANY version
			set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED "ANY" CACHE STRING "${message_str}" FORCE)
		endif()

	else()#OK the variable has a value
		if(list_of_versions)#there is a constraint on usable versions
			if(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED STREQUAL "ANY")#the value in cache was previously ANY but user added a list of versions in the meantime
				if(SIZE EQUAL 1)#only one possible version => no more provide it to to user
					set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED ${default_version} CACHE INTERNAL "" FORCE)
				else()
					set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED ${default_version} CACHE STRING "${message_str}" FORCE)
				endif()
			else()#the value is a version, check if this version is allowed
				list(FIND list_of_versions ${${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED} INDEX)
				if(INDEX EQUAL -1 )#no possible version found -> bad input of the user
					#simply reset the description to first found
					if(SIZE EQUAL 1)#only one possible version => no more provide it to to user
						set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED ${default_version} CACHE INTERNAL "" FORCE)
					else()#many possible versions now !!
						set(${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED ${default_version} CACHE STRING "${message_str}" FORCE)
					endif()
				endif()
			endif()
		endif()
	endif()
	if(exact_versions)
		list(FIND exact_versions ${${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED} INDEX)
		if(NOT INDEX EQUAL -1 )
			set(USE_EXACT TRUE)
		endif()
	endif()
endif()
### 3) setting internal cache variable used to generate the use file and to resolve find operations
#now set the version used for build depending on what has been chosen
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_DEPENDENCY_${dep_package}_ALTERNATIVE_VERSION_USED ${${CURRENT_MANAGED_VERSION}_${dep_package}_ALTERNATIVE_VERSION_USED} CACHE INTERNAL "")#no version means any version (no contraint)
endfunction(declare_Wrapped_External_Dependency)

#.rst:
#
# .. ifmode:: internal
#
#  .. |declare_Wrapped_Component| replace:: ``declare_Wrapped_Component``
#  .. _declare_Wrapped_Component:
#
#  declare_Wrapped_Component
#  -------------------------
#
#   .. command:: declare_Wrapped_Component(component shared_links soname static_links includes definitions options c_standard cxx_standard runtime_resources)
#
#    Define a new component for currently described external package version. Internal counterpart of declare_PID_Wrapper_Component.
#
#      :component: the name of the component.
#
#      :shared_links: the list of path to shared objects that are part of the component, relative to external package root install folder.
#
#      :soname: the soname to use for that specific component's shared objects.
#
#      :static_links: the list of path to static libraries that are part of the component, relative to external package root install folder.
#
#      :includes: the list of includes path that are part of the component, relative to external package root install folder or absolute.
#
#      :definitions: the list preprocessor definitions that must be defined when using of the component.
#
#      :options: the list of compiler options that must be used when using the component.
#
#      :c_standard: the C language standard in use (may be empty).
#
#      :cxx_standard: the C++ language standard that is mandatory when using the component.
#
#      :runtime_resources: the list of path to file and folder used at runtime by the component, relative to external package root install folder.
#
function(declare_Wrapped_Component component shared_links soname static_links includes definitions options c_standard cxx_standard runtime_resources)
append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENTS ${component})
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_SHARED_LINKS ${shared_links} CACHE INTERNAL "")
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_SONAME ${soname} CACHE INTERNAL "")
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_STATIC_LINKS ${static_links} CACHE INTERNAL "")
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_INCLUDES ${includes} CACHE INTERNAL "")
escape_Guillemet_From_String(definitions)#special case, definition may contain complex string exprtession that we may want to escape using \". We generally want to preserve these espaces
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_DEFINITIONS "${definitions}" CACHE INTERNAL "")
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_OPTIONS ${options} CACHE INTERNAL "")
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_C_STANDARD ${c_standard} CACHE INTERNAL "")
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_CXX_STANDARD ${cxx_standard} CACHE INTERNAL "")
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_RUNTIME_RESOURCES ${runtime_resources} CACHE INTERNAL "")
endfunction(declare_Wrapped_Component)

#.rst:
#
# .. ifmode:: internal
#
#  .. |declare_Wrapped_Component_Dependency_To_Explicit_Component| replace:: ``declare_Wrapped_Component_Dependency_To_Explicit_Component``
#  .. _declare_Wrapped_Component_Dependency_To_Explicit_Component:
#
#  declare_Wrapped_Component_Dependency_To_Explicit_Component
#  ----------------------------------------------------------
#
#   .. command:: declare_Wrapped_Component_Dependency_To_Explicit_Component(component package dependency_component exported definitions)
#
#    Define a dependency between a local component defined by current version and a component belonging to another external package. Used when this external package provides a description.
#
#      :component: the name of the component.
#
#      :package: the name of the external package used as a dependency.
#
#      :dependency_component: the name of the component used as a dependency, and taht belongs to package.
#
#      :exported: TRUE if component exports dependency_component (i.e. if public headers of component include headers of dependency_component).
#
#      :definitions: the list preprocessor definitions used in dependency_component headers but set by component.
#
function(declare_Wrapped_Component_Dependency_To_Explicit_Component component package dependency_component exported definitions)
append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_DEPENDENCIES ${package})
append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_DEPENDENCY_${package} ${dependency_component})
escape_Guillemet_From_String(definitions)#special case, definition may contain complex string exprtession that we may want to escape using \". We generally want to preserve these espaces
append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_DEPENDENCY_${package}_${dependency_component}_DEFINITIONS "${definitions}")
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_DEPENDENCY_${package}_${dependency_component}_EXPORTED ${exported} CACHE INTERNAL "")
endfunction(declare_Wrapped_Component_Dependency_To_Explicit_Component)

#.rst:
#
# .. ifmode:: internal
#
#  .. |declare_Wrapped_Component_Dependency_To_Implicit_Components| replace:: ``declare_Wrapped_Component_Dependency_To_Implicit_Components``
#  .. _declare_Wrapped_Component_Dependency_To_Implicit_Components:
#
#  declare_Wrapped_Component_Dependency_To_Implicit_Components
#  -----------------------------------------------------------
#
#   .. command:: declare_Wrapped_Component_Dependency_To_Implicit_Components(component package includes shared static definitions options c_standard cxx_standard runtime_resources)
#
#    Define a dependency between a local component defined by current version and another external package's content. Used when this external package provides no description in use file.
#
#      :component: the name of the component.
#
#      :package: the name of the external package used as a dependency.
#
#      :includes: the list of includes path that are used by the component, relative to external package dependency root install folder.
#
#      :shared: the list of path to shared objects that are used by the component, relative to external package dependency root install folder.
#
#      :static: the list of path to static libraries that are used by the component, relative to external package dependency root install folder.
#
#      :definitions: the list preprocessor definitions that must be defined when using of the component.
#
#      :options: the list of compiler options that must be used when using the component.
#
#      :c_standard: the C language standard in use (may be empty).
#
#      :cxx_standard: the C++ language standard that is mandatory when using the component.
#
#      :runtime_resources: the list of path to file and folder used at runtime by the component, relative to external package dependency root install folder.
#
function(declare_Wrapped_Component_Dependency_To_Implicit_Components component package includes shared static definitions options c_standard cxx_standard runtime_resources)
append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_DEPENDENCIES ${package})
append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_INCLUDES "${includes}")
append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_SHARED "${shared}")
append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_STATIC "${static}")
escape_Guillemet_From_String(definitions)#special case, definition may contain complex string exprtession that we may want to escape using \". We generally want to preserve these espaces
append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_DEFINITIONS "${definitions}")
append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_OPTIONS "${options}")
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_C_STANDARD "${c_standard}" CACHE INTERNAL "")
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_CXX_STANDARD "${cxx_standard}" CACHE INTERNAL "")
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_DEPENDENCY_${package}_CONTENT_RUNTIME_RESOURCES "${runtime_resources}" CACHE INTERNAL "")
endfunction(declare_Wrapped_Component_Dependency_To_Implicit_Components)

#.rst:
#
# .. ifmode:: internal
#
#  .. |declare_Wrapped_Component_Internal_Dependency| replace:: ``declare_Wrapped_Component_Internal_Dependency``
#  .. _declare_Wrapped_Component_Internal_Dependency:
#
#  declare_Wrapped_Component_Internal_Dependency
#  ---------------------------------------------
#
#   .. command:: declare_Wrapped_Component_Internal_Dependency(component dependency_component exported definitions)
#
#    Define a dependency between two local components defined by current version.
#
#      :component: the name of the component that defines a dependency.
#
#      :dependency_component: the name of the component that is the dependency.
#
#      :exported: TRUE if component exports dependency_component.
#
#      :definitions: the list preprocessor definitions used in dependency_component headers but defined by component.
#
function(declare_Wrapped_Component_Internal_Dependency component dependency_component exported definitions)
append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_INTERNAL_DEPENDENCIES ${dependency_component})
escape_Guillemet_From_String(definitions)#special case, definition may contain complex string exprtession that we may want to escape using \". We generally want to preserve these espaces
append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_INTERNAL_DEPENDENCY_${dependency_component}_DEFINITIONS "${definitions}")
set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_INTERNAL_DEPENDENCY_${dependency_component}_EXPORTED ${exported} CACHE INTERNAL "")
endfunction(declare_Wrapped_Component_Internal_Dependency)


#.rst:
#
# .. ifmode:: internal
#
#  .. |declare_Wrapped_Component_System_Dependency| replace:: ``declare_Wrapped_Component_System_Dependency``
#  .. _declare_Wrapped_Component_System_Dependency:
#
#  declare_Wrapped_Component_System_Dependency
#  -------------------------------------------
#
#   .. command:: declare_Wrapped_Component_System_Dependency(component includes links lib_dirs defs opts c_std cxx_std resources)
#
#    Define a dependency between a local component defined by current version and operating system configuration.
#
#      :component: the name of the component.
#
#      :includes: the list of absolute includes path that are used by the component. May be defined as a configuration variable.
#
#      :lib_dirs: the list of absolute path to folder used to find system libraries. May be defined as a configuration variable.
#
#      :links: the list of linker options that are used by the component. May be defined as a configuration variable.
#
#      :defs: the list preprocessor definitions that must be defined when using of the component. May be defined as a configuration variable.
#
#      :opts: the list of compiler options that must be used when using the component.May be defined as a configuration variable.
#
#      :c_std: the C language standard in use (may be empty).May be defined as a configuration variable.
#
#      :cxx_std: the C++ language standard that is mandatory when using the component. May be defined as a configuration variable.
#
#      :resources: the list of absolute path to file and folder used at runtime by the component. May be defined as a configuration variable.
#
function(declare_Wrapped_Component_System_Dependency component includes lib_dirs links defs opts c_std cxx_std resources)
	append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_SYSTEM_INCLUDES "${includes}")
	append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_SYSTEM_LIB_DIRS "${lib_dirs}")
	append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_SYSTEM_LINKS "${links}")
	escape_Guillemet_From_String(defs)#special case, definition may contain complex string exprtession that we may want to escape using \". We generally want to preserve these espaces
	append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_SYSTEM_DEFINITIONS "${defs}")
	append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_SYSTEM_OPTIONS "${opts}")
	set(curr_std_c ${${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_SYSTEM_C_STANDARD})
	take_Greater_C_Standard_Version(curr_std_c c_std)
	set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_SYSTEM_C_STANDARD ${curr_std_c} CACHE INTERNAL "")

	set(curr_std_cxx ${${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_SYSTEM_CXX_STANDARD})
	take_Greater_CXX_Standard_Version(curr_std_cxx cxx_std)
	set(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_SYSTEM_CXX_STANDARD ${curr_std_cxx} CACHE INTERNAL "")

	append_Unique_In_Cache(${PROJECT_NAME}_KNOWN_VERSION_${CURRENT_MANAGED_VERSION}_COMPONENT_${component}_SYSTEM_RUNTIME_RESOURCES "${resources}")
endfunction(declare_Wrapped_Component_System_Dependency)

#.rst:
#
# .. ifmode:: internal
#
#  .. |install_External_Use_File_For_Version| replace:: ``install_External_Use_File_For_Version``
#  .. _install_External_Use_File_For_Version:
#
#  install_External_Use_File_For_Version
#  -------------------------------------
#
#   .. command:: install_External_Use_File_For_Version(package version platform)
#
#    Copy the use file of a given version of an external package into install tree of the workspace.
#
#      :package: the name of the external package.
#
#      :version: the version of the external package for which a use file is installed.
#
#      :platform: the identifier of the platform to use in workspace install tree.
#
function(install_External_Use_File_For_Version package version platform)
	set(file_path ${WORKSPACE_DIR}/wrappers/${package}/build/Use${package}-${version}.cmake)
	set(target_folder ${WORKSPACE_DIR}/external/${platform}/${package}/${version}/share)
	file(COPY ${file_path} DESTINATION ${target_folder})
endfunction(install_External_Use_File_For_Version)

#.rst:
#
# .. ifmode:: internal
#
#  .. |install_External_Find_File_For_Version| replace:: ``install_External_Find_File_For_Version``
#  .. _install_External_Find_File_For_Version:
#
#  install_External_Find_File_For_Version
#  --------------------------------------
#
#   .. command:: install_External_Find_File_For_Version(package)
#
#    Copy the find file of a given version of an external package into install tree of the workspace.
#
#      :package: the name of the external package.
#
function(install_External_Find_File_For_Version package)
	set(wrapper_path ${WORKSPACE_DIR}/wrappers/${package}/build)
	execute_process(COMMAND ${CMAKE_MAKE_PROGRAM} install WORKING_DIRECTORY ${wrapper_path})#simply call the install function of the wrapper
endfunction(install_External_Find_File_For_Version)

#.rst:
#
# .. ifmode:: internal
#
#  .. |generate_External_Use_File_For_Version| replace:: ``generate_External_Use_File_For_Version``
#  .. _generate_External_Use_File_For_Version:
#
#  generate_External_Use_File_For_Version
#  --------------------------------------
#
#   .. command:: generate_External_Use_File_For_Version(package version platform)
#
#    Generate the use file of a given version of an external package.
#
#      :package: the name of the external package.
#
#      :version: the version of the external package for which a use file is installed.
#
#      :platform: the identifier of the target platform for the installed version.
#
#      :os_variant: if true means that the binary are those found on OS not built within PID.
#
function(generate_External_Use_File_For_Version package version platform os_variant)
	set(file_for_version ${WORKSPACE_DIR}/wrappers/${package}/build/Use${package}-${version}.cmake)
	file(WRITE ${file_for_version} "############# description of ${package} build process ABi environment ##################\n")#reset file content (if any) or create file

	# writing info about what may be useful to check for binary compatibility
	file(APPEND ${file_for_version} "set(${package}_BUILT_FOR_DISTRIBUTION ${CURRENT_DISTRIBUTION} CACHE INTERNAL \"\")\n")
  file(APPEND ${file_for_version} "set(${package}_BUILT_FOR_DISTRIBUTION_VERSION ${CURRENT_DISTRIBUTION_VERSION} CACHE INTERNAL \"\")\n")
	file(APPEND ${file_for_version} "set(${package}_BUILT_OS_VARIANT ${os_variant} CACHE INTERNAL \"\")\n")
	file(APPEND ${file_for_version} "set(${package}_BUILT_FOR_INSTANCE ${CURRENT_PLATFORM_INSTANCE} CACHE INTERNAL \"\")\n")

  file(APPEND ${file_for_version} "set(${package}_BUILT_WITH_PYTHON_VERSION ${CURRENT_PYTHON} CACHE INTERNAL \"\")\n")

	 #writing info about compiler used to build the binary
  file(APPEND ${file_for_version} "set(${package}_BUILT_WITH_COMPILER_IS_GNUCXX \"${CMAKE_COMPILER_IS_GNUCXX}\" CACHE INTERNAL \"\" FORCE)\n")
  file(APPEND ${file_for_version} "set(${package}_BUILT_WITH_CXX_COMPILER_ID \"${CMAKE_CXX_COMPILER_ID}\" CACHE INTERNAL \"\" FORCE)\n")
  file(APPEND ${file_for_version} "set(${package}_BUILT_WITH_CXX_COMPILER_VERSION \"${CMAKE_CXX_COMPILER_VERSION}\" CACHE INTERNAL \"\" FORCE)\n")
  file(APPEND ${file_for_version} "set(${package}_BUILT_WITH_C_COMPILER_ID \"${CMAKE_C_COMPILER_ID}\" CACHE INTERNAL \"\" FORCE)\n")
  file(APPEND ${file_for_version} "set(${package}_BUILT_WITH_C_COMPILER_VERSION \"${CMAKE_C_COMPILER_VERSION}\" CACHE INTERNAL \"\" FORCE)\n")

	# add constraints related to C++ ABI in use
	file(APPEND ${file_for_version} "set(${package}_BUILT_WITH_CXX_ABI ${CURRENT_CXX_ABI} CACHE INTERNAL \"\")\n")
	file(APPEND ${file_for_version} "set(${package}_BUILT_WITH_CMAKE_INTERNAL_PLATFORM_ABI ${CMAKE_INTERNAL_PLATFORM_ABI} CACHE INTERNAL \"\")\n")
	file(APPEND ${file_for_version} "set(${package}_BUILT_WITH_CXX_STD_LIBRARIES ${CXX_STANDARD_LIBRARIES} CACHE INTERNAL \"\")\n")
	foreach(lib IN LISTS CXX_STANDARD_LIBRARIES)
		file(APPEND ${file_for_version} "set(${package}_BUILT_WITH_CXX_STD_LIB_${lib}_ABI_SOVERSION ${CXX_STD_LIB_${lib}_ABI_SOVERSION} CACHE INTERNAL \"\")\n")
	endforeach()
	file(APPEND ${file_for_version} "set(${package}_BUILT_WITH_CXX_STD_SYMBOLS ${CXX_STD_SYMBOLS} CACHE INTERNAL \"\")\n")
	foreach(symbol IN LISTS CXX_STD_SYMBOLS)
		file(APPEND ${file_for_version} "set(${package}_BUILT_WITH_CXX_STD_SYMBOL_${symbol}_VERSION ${CXX_STD_SYMBOL_${symbol}_VERSION} CACHE INTERNAL \"\")\n")
	endforeach()

	file(APPEND ${file_for_version} "############# ${package} (version ${version}) specific scripts for deployment #############\n")
	set(post_install_file_name)
	if(${package}_KNOWN_VERSION_${version}_POST_INSTALL_SCRIPT)
		get_filename_component(post_install_file_name ${WORKSPACE_DIR}/wrappers/${package}/src/${version}/${${package}_KNOWN_VERSION_${version}_POST_INSTALL_SCRIPT} NAME)
	endif()
	file(APPEND ${file_for_version} "set(${package}_SCRIPT_POST_INSTALL ${post_install_file_name} CACHE INTERNAL \"\")\n")#name of script, relative to share/cmake_script in install tree
	set(pre_use_file_name)
	if(${package}_KNOWN_VERSION_${version}_PRE_USE_SCRIPT)
		get_filename_component(pre_use_file_name ${WORKSPACE_DIR}/wrappers/${package}/src/${version}/${${package}_KNOWN_VERSION_${version}_PRE_USE_SCRIPT} NAME)
	endif()
	file(APPEND ${file_for_version} "set(${package}_SCRIPT_PRE_USE ${pre_use_file_name} CACHE INTERNAL \"\")\n")#name of script, relative to share/cmake_script in install tree

	file(APPEND ${file_for_version} "############# description of ${package} content (version ${version}) #############\n")
	file(APPEND ${file_for_version} "declare_PID_External_Package(PACKAGE ${package})\n")

	#add checks for required platform configurations
	set(list_of_configs)
	foreach(config IN LISTS ${package}_KNOWN_VERSION_${version}_CONFIGURATIONS)
		if(${package}_KNOWN_VERSION_${version}_CONFIGURATION_${config} STREQUAL "all"
			OR ${package}_KNOWN_VERSION_${version}_CONFIGURATION_${config} STREQUAL "${platform}")#this configuration is required for any platform
			generate_Configuration_Constraints(RESULTING_EXPRESSION ${config} "${${package}_KNOWN_VERSION_${version}_CONFIGURATION_${config}_ARGS}")
			list(APPEND list_of_configs ${RESULTING_EXPRESSION})
		endif()
	endforeach()
	if(list_of_configs)
		file(APPEND ${file_for_version} "#description of external package ${package} version ${version} required platform configurations\n")
		fill_String_From_List(list_of_configs RES_CONFIG)
		file(APPEND ${file_for_version} "check_PID_External_Package_Platform(PACKAGE ${package} PLATFORM ${platform} CONFIGURATION ${RES_CONFIG})\n")
	endif()

	#add required external dependencies
	file(APPEND ${file_for_version} "#description of external package ${package} dependencies for version ${version}\n")
	foreach(dependency IN LISTS ${package}_KNOWN_VERSION_${version}_DEPENDENCIES)#do the description for each dependency
		set(selected_version ${${package}_KNOWN_VERSION_${version}_DEPENDENCY_${dependency}_VERSION_USED_FOR_BUILD})
		if(${package}_KNOWN_VERSION_${version}_DEPENDENCY_${dependency}_VERSIONS_EXACT)
			list(FIND ${package}_KNOWN_VERSION_${version}_DEPENDENCY_${dependency}_VERSIONS_EXACT ${selected_version} INDEX)
			if(INDEX EQUAL -1)
				set(STR_EXACT "")#not an exact version
			else()
				set(STR_EXACT "EXACT ")
			endif()
		endif()
		file(APPEND ${file_for_version} "declare_PID_External_Package_Dependency(PACKAGE ${package} EXTERNAL ${dependency} ${EXACT_STR}VERSION ${selected_version})\n")
	endforeach()

	# manage generation of component description
	file(APPEND ${file_for_version} "#description of external package ${package} version ${version} components\n")
	# writing all components first in order to avoid that some component required other internal components that are not already defined
	foreach(component IN LISTS ${package}_KNOWN_VERSION_${version}_COMPONENTS)
		generate_Description_For_External_Component(${file_for_version} ${package} ${platform} ${version} ${component})
	endforeach()
	#then writing dependencies for all components => we are sure that all components are defined before defining dependencies
	foreach(component IN LISTS ${package}_KNOWN_VERSION_${version}_COMPONENTS)
		generate_Description_For_External_Component_Dependencies(${file_for_version} ${package} ${version} ${component})
	endforeach()

endfunction(generate_External_Use_File_For_Version)

#.rst:
#
# .. ifmode:: internal
#
#  .. |generate_Description_For_External_Component_Internal_Dependency| replace:: ``generate_Description_For_External_Component_Internal_Dependency``
#  .. _generate_Description_For_External_Component_Internal_Dependency:
#
#  generate_Description_For_External_Component_Internal_Dependency
#  ---------------------------------------------------------------
#
#   .. command:: generate_Description_For_External_Component_Internal_Dependency(file_for_version package version component dependency)
#
#    Append the description of an internal component dependency to a given external package's use file.
#
#      :file_for_version: the path to the file to write in..
#
#      :package: the name of target external package.
#
#      :version: the target version of external package.
#
#      :component: the name of the component that declares the dependency.
#
#      :dependency: the name of the component that is the dependency.
#
function(generate_Description_For_External_Component_Internal_Dependency file_for_version package version component dependency)
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCY_${dependency}_DEFINITIONS)
	fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCY_${dependency}_DEFINITIONS RES_STR)
	set(defs " DEFINITIONS ${RES_STR}")
else()
	set(defs "")
endif()
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCY_${dependency}_EXPORTED)
	set(usage "EXPORT")
else()
	set(usage "USE")
endif()
file(APPEND ${file_for_version} "declare_PID_External_Component_Dependency(PACKAGE ${package} COMPONENT ${component} ${usage} ${dependency}${defs})\n")
endfunction(generate_Description_For_External_Component_Internal_Dependency)

#.rst:
#
# .. ifmode:: internal
#
#  .. |generate_Description_For_External_Component_Dependency| replace:: ``generate_Description_For_External_Component_Dependency``
#  .. _generate_Description_For_External_Component_Dependency:
#
#  generate_Description_For_External_Component_Dependency
#  ------------------------------------------------------
#
#   .. command:: generate_Description_For_External_Component_Dependency(file_for_version package version component external_package_dependency)
#
#    Append the description of a component dependency to another external package to a given external package's use file.
#
#      :file_for_version: the path to the file to write in..
#
#      :package: the name of target external package.
#
#      :version: the target version of external package.
#
#      :component: the name of the component that declares the dependency.
#
#      :external_package_dependency: the name of the external package that is the dependency.
#
function(generate_Description_For_External_Component_Dependency file_for_version package version component external_package_dependency)
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency})
	foreach(dep_component IN LISTS ${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency})
		#managing each component individually
		set(defs "")
		if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_${dep_component}_DEFINITIONS)
			fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_${dep_component}_DEFINITIONS RES_STR)
			set(defs "DEFINITIONS ${RES_STR}")
		endif()
		if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_${dep_component}_EXPORTED)
			set(usage "EXPORT ${dep_component}")
		else()
			set(usage "USE ${dep_component}")
		endif()
		file(APPEND ${file_for_version} "declare_PID_External_Component_Dependency(PACKAGE ${package} COMPONENT ${component} ${usage} EXTERNAL ${external_package_dependency} ${defs})\n")
	endforeach()
endif()

#direct package relationship described (without using explicit components for instance because they are not described)
set(package_rel_to_write FALSE)
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_INCLUDES)
	fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_INCLUDES RES_INC)
	set(includes " INCLUDES ${RES_INC}")
	set(package_rel_to_write TRUE)
else()
	set(includes "")
endif()
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_SHARED)
	fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_SHARED RES_SHARED)
	set(shared " SHARED_LINKS ${RES_SHARED}")
	set(package_rel_to_write TRUE)
else()
	set(shared "")
endif()
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_STATIC)
	fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_STATIC RES_STATIC)
	set(static " STATIC_LINKS ${RES_STATIC}")
	set(package_rel_to_write TRUE)
else()
	set(static "")
endif()
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_DEFINITIONS)
	fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_DEFINITIONS RES_DEFS)
	set(defs " DEFINITIONS ${RES_DEFS}")
	set(package_rel_to_write TRUE)
else()
	set(defs "")
endif()
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_OPTIONS)
	fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_OPTIONS RES_OPTS)
	set(opts " COMPILER_OPTIONS ${RES_OPTS}")
	set(package_rel_to_write TRUE)
else()
	set(opts "")
endif()
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_C_STANDARD)
	set(c_std " C_STANDARD ${${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_C_STANDARD}")
	set(package_rel_to_write TRUE)
else()
	set(c_std "")
endif()
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_CXX_STANDARD)
	set(cxx_std " CXX_STANDARD ${${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_CXX_STANDARD}")
	set(package_rel_to_write TRUE)
else()
	set(cxx_std "")
endif()
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_RUNTIME_RESOURCES)
	fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCY_${external_package_dependency}_CONTENT_RUNTIME_RESOURCES RES_RESOURCES)
	set(resources " RUNTIME_RESOURCES ${RES_RESOURCES}")
	set(package_rel_to_write TRUE)
else()
	set(resources "")
endif()
if(package_rel_to_write)#write all the imported stuff from another external package in one call
file(APPEND ${file_for_version} "declare_PID_External_Component_Dependency(PACKAGE ${package} COMPONENT ${component} EXTERNAL ${external_package_dependency}${includes}${lib_dirs}${shared}${static}${defs}${opts}${c_std}${cxx_std}${resources})\n")
endif()
endfunction(generate_Description_For_External_Component_Dependency)


#.rst:
#
# .. ifmode:: internal
#
#  .. |generate_Description_For_External_Component_System_Dependency| replace:: ``generate_Description_For_External_Component_System_Dependency``
#  .. _generate_Description_For_External_Component_System_Dependency:
#
#  generate_Description_For_External_Component_System_Dependency
#  -------------------------------------------------------------
#
#   .. command:: generate_Description_For_External_Component_System_Dependency(file_for_version package version component)
#
#    Append the description of a component dependency to another external package to a given external package's use file.
#
#      :file_for_version: the path to the file to write in..
#
#      :package: the name of target external package.
#
#      :version: the target version of external package.
#
#      :component: the name of the component that declares the dependency.
#
function(generate_Description_For_External_Component_System_Dependency file_for_version package version component)
#direct system dependencies
set(package_rel_to_write FALSE)
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_INCLUDES)
	fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_INCLUDES RES_INCS)
	set(includes " INCLUDES ${RES_INCS}")
	set(package_rel_to_write TRUE)
else()
	set(includes "")
endif()

if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_LIB_DIRS)
	fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_LIB_DIRS RES_DIRS)
	set(lib_dirs " LIBRARY_DIRS ${RES_DIRS}")
	set(package_rel_to_write TRUE)
else()
	set(lib_dirs "")
endif()

if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_LINKS)
	fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_LINKS RES_LINKS)
	set(shared " SHARED_LINKS ${RES_LINKS}")#by default all system links are considered as shared links
	set(package_rel_to_write TRUE)
else()
	set(shared "")
endif()

if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_DEFINITIONS)
	fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_DEFINITIONS RES_DEFS)
	set(defs " DEFINITIONS ${RES_DEFS}")
	set(package_rel_to_write TRUE)
else()
	set(defs "")
endif()
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_OPTIONS)
	fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_OPTIONS RES_OPTS)
	set(opts " COMPILER_OPTIONS ${RES_OPTS}")
	set(package_rel_to_write TRUE)
else()
	set(opts "")
endif()
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_C_STANDARD)
	set(c_std " C_STANDARD ${${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_C_STANDARD}")
	set(package_rel_to_write TRUE)
else()
	set(c_std "")
endif()
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_CXX_STANDARD)
	set(cxx_std " CXX_STANDARD ${${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_CXX_STANDARD}")
	set(package_rel_to_write TRUE)
else()
	set(cxx_std "")
endif()
if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_RUNTIME_RESOURCES)
	fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SYSTEM_RUNTIME_RESOURCES RES_RESOURCES)
	set(resources " RUNTIME_RESOURCES ${RES_RESOURCES}")
	set(package_rel_to_write TRUE)
else()
	set(resources "")
endif()
if(package_rel_to_write)#write all the imported stuff from another external package in one call
	file(APPEND ${file_for_version} "declare_PID_External_Component_Dependency(PACKAGE ${package} COMPONENT ${component} ${dependency}${includes}${lib_dirs}${shared}${static}${defs}${opts}${c_std}${cxx_std}${resources})\n")
endif()
endfunction(generate_Description_For_External_Component_System_Dependency)


#.rst:
#
# .. ifmode:: internal
#
#  .. |generate_Description_For_External_Component_Dependencies| replace:: ``generate_Description_For_External_Component_Dependencies``
#  .. _generate_Description_For_External_Component_Dependencies:
#
#  generate_Description_For_External_Component_Dependencies
#  --------------------------------------------------------
#
#   .. command:: generate_Description_For_External_Component_Dependencies(file_for_version package platform version component)
#
#    Append the description of a component dependencies to a given external package use file.
#
#      :file_for_version: the path to the file to write in..
#
#      :package: the name of target external package.
#
#      :version: the target version of external package.
#
#      :component: the name of the component that may have dependencies.
#
function(generate_Description_For_External_Component_Dependencies file_for_version package version component)

	generate_Description_For_External_Component_System_Dependency(${file_for_version} ${package} ${version} ${component} ${dep})

	#management of component internal dependencies
	if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCIES)
		file(APPEND ${file_for_version} "#declaring internal dependencies for component ${component}\n")
		foreach(dep IN LISTS ${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_INTERNAL_DEPENDENCIES)
			generate_Description_For_External_Component_Internal_Dependency(${file_for_version} ${package} ${version} ${component} ${dep})
		endforeach()
	endif()

	#management of component internal dependencies
	if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCIES)
		file(APPEND ${file_for_version} "#declaring external dependencies for component ${component}\n")
		foreach(dep_pack IN LISTS ${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEPENDENCIES)
			generate_Description_For_External_Component_Dependency(${file_for_version} ${package} ${version} ${component} ${dep_pack})
		endforeach()
	endif()
endfunction(generate_Description_For_External_Component_Dependencies)

#.rst:
#
# .. ifmode:: internal
#
#  .. |generate_Description_For_External_Component| replace:: ``generate_Description_For_External_Component``
#  .. _generate_Description_For_External_Component:
#
#  generate_Description_For_External_Component
#  -------------------------------------------
#
#   .. command:: generate_Description_For_External_Component(file_for_version package platform version component)
#
#    Append the description of a component to a given external package use file.
#
#      :file_for_version: the path to the file to write in..
#
#      :package: the name of target external package.
#
#      :platform: the identifier of target platform in workspace install tree.
#
#      :version: the target version of external package.
#
#      :component: the name of the target component.
#
function(generate_Description_For_External_Component file_for_version package platform version component)
	file(APPEND ${file_for_version} "#component ${component}\n")
	set(options_str "")
	if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SHARED_LINKS)
		if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SONAME
				OR ${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SONAME EQUAL 0)#the component SONAME has priority over package SONAME
			set(USE_SONAME "${${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SONAME}")
		else()
			set(USE_SONAME "${${package}_KNOWN_VERSION_${version}_SONAME}")
		endif()
		create_Shared_Lib_Extension(RES_EXT ${platform} "${USE_SONAME}")#create the soname extension
		set(final_list_of_shared)#add the adequate extension name depending on the platform
		foreach(shared_lib_path IN LISTS ${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SHARED_LINKS)
				shared_Library_Needs_Soname(RESULT_SONAME ${shared_lib_path} ${platform})
				if(RESULT_SONAME)#OK no extension defined we can apply
					list(APPEND final_list_of_shared "${shared_lib_path}${RES_EXT}")
				else()
					list(APPEND final_list_of_shared "${shared_lib_path}")
				endif()
		endforeach()

		fill_String_From_List(final_list_of_shared RES_SHARED)
		set(options_str " SHARED_LINKS ${RES_SHARED}")
	endif()
	if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_STATIC_LINKS)
		#TODO for Windows ? need to manage static lib name to adapt them to OS => for windows archive have .lib extension !!
		#may be not usefull because Windows version will be very different ?
		fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_STATIC_LINKS RES_STR)
		set(options_str "${options_str} STATIC_LINKS ${RES_STR}")
	endif()
	if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_INCLUDES)
		fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_INCLUDES RES_STR)
		set(options_str "${options_str} INCLUDES ${RES_STR}")
	endif()
	if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEFINITIONS)
		fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_DEFINITIONS RES_STR)
		set(options_str "${options_str} DEFINITIONS ${RES_STR}")
	endif()
	if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_OPTIONS)
		fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_OPTIONS RES_STR)
		set(options_str "${options_str} OPTIONS ${RES_STR}")
	endif()
	if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_C_STANDARD)
		fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_C_STANDARD RES_STR)
		set(options_str "${options_str} C_STANDARD ${RES_STR}")
	endif()
	if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_CXX_STANDARD)
		fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_CXX_STANDARD RES_STR)
		set(options_str "${options_str} CXX_STANDARD ${RES_STR}")
	endif()
	if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_RUNTIME_RESOURCES)
		fill_String_From_List(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_RUNTIME_RESOURCES RES_STR)
		set(options_str "${options_str} RUNTIME_RESOURCES ${RES_STR}")
	endif()
	file(APPEND ${file_for_version} "declare_PID_External_Component(PACKAGE ${package} COMPONENT ${component}${options_str})\n")

endfunction(generate_Description_For_External_Component)


#.rst:
#
# .. ifmode:: internal
#
#  .. |generate_OS_Variant_Symlinks| replace:: ``generate_OS_Variant_Symlinks``
#  .. _generate_OS_Variant_Symlinks:
#
#  generate_OS_Variant_Symlinks
#  ----------------------------
#
#   .. command:: generate_OS_Variant_Symlinks(package platform version install_dir)
#
#    Generate symlinks in an external binary pakage, that points to its OS equivalent content (includes, libraries).
#
#      :package: the name of target external package.
#
#      :platform: the identifier of target platform in workspace install tree.
#
#      :version: the target version of external package.
#
#      :install_dir: path to the external package install folder where to put symlinks.
#
function(generate_OS_Variant_Symlinks package platform version install_dir)
	# we can use cache variables defined by the external package equivalent configuration
	# standard names that we can use: ${package}_RPATH (absolute path to runtime resources), ${package}_LIBRARY_DIRS (absolute path to folders containing the target libraries) ${package}_INCLUDE_DIRS (absolute path to folders containg the headers).

	# what we need to do is to generate a symlink with adequate name to specific binaries lying in OS folders
	foreach(component IN LISTS ${package}_KNOWN_VERSION_${version}_COMPONENTS)
		#each symlink with good name if generated to ensure consistency
		foreach(stat_link IN LISTS ${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_STATIC_LINKS)
			if(NOT stat_link MATCHES "^-l.*$")#only generate symlinks for non OS libraries
				generate_OS_Variant_Symlink_For_Path(${install_dir} ${stat_link} "${${package}_RPATH}")
			endif()
		endforeach()
		if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SHARED_LINKS)
			if(${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SONAME)#the component SONAME has priority over package SONAME
				set(USE_SONAME ${${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SONAME})
			else()
				set(USE_SONAME ${${package}_KNOWN_VERSION_${version}_SONAME})
			endif()
			create_Shared_Lib_Extension(RES_EXT ${platform} "${USE_SONAME}")#create the soname extension
			foreach(sha_link IN LISTS ${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_SHARED_LINKS)
				shared_Library_Needs_Soname(NEEDS_SONAME ${sha_link} ${platform})
				if(NEEDS_SONAME)#OK no extension defined we can apply
					set(full_name "${sha_link}${RES_EXT}")
				else()
					set(full_name "${sha_link}")
				endif()
				if(NOT full_name MATCHES "^-l.*$")#only generate symlinks for non OS libraries
					generate_OS_Variant_Symlink_For_Path(${install_dir} ${full_name} "${${package}_RPATH}")
				endif()
			endforeach()
		endif()
		foreach(rres IN LISTS ${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_RUNTIME_RESOURCES)
			generate_OS_Variant_Symlink_For_Path(${install_dir} ${rres} "${${package}_RPATH}")
		endforeach()
	endforeach()

	#for public headers a specific treatment is required as their names cannot be used (name can be completely different between OS and PID versions)
	foreach(component IN LISTS ${package}_KNOWN_VERSION_${version}_COMPONENTS)
		#agregate all includes for all components
		list(APPEND all_includes ${${package}_KNOWN_VERSION_${version}_COMPONENT_${component}_INCLUDES})
	endforeach()
	if(all_includes)#do something only if there are includes specified in external package description
		list(REMOVE_DUPLICATES all_includes)
		list(LENGTH all_includes NB_INCLUDES_DESCRIPTION)

		if(${package}_INCLUDE_DIRS)
			foreach(inc IN LISTS ${package}_INCLUDE_DIRS)
				list(FIND CMAKE_SYSTEM_INCLUDE_PATH ${inc} INDEX)
				if(INDEX EQUAL -1)#not a system include path
					list(APPEND os_includes_used ${inc})#no other choice than generating a symlink to it
				endif()
			endforeach()
			if(os_includes_used)#there are non system path in configuration variable
				list(REMOVE_DUPLICATES os_includes_used)
			else()#there are only system path, generate a symlink for first found
				list(GET ${package}_INCLUDE_DIRS 0 os_includes_used)
			endif()

			list(LENGTH os_includes_used NB_INCLUDES_OS)#Note: NB_INCLUDES_OS >=1
			#checking that generating symlinks to OS include folders is feasible
			if(NB_INCLUDES_OS GREATER NB_INCLUDES_DESCRIPTION)#no solution about that I have no enough "slots" in description to target all system include folders
				message(FATAL_ERROR "[PID] CRITICAL ERROR: cannot generate symlinks for include as they are too many include folders to target in operating system.")
				return()
			elseif(NB_INCLUDES_DESCRIPTION GREATER NB_INCLUDES_OS)
				message(FATAL_ERROR "[PID] CRITICAL ERROR: cannot generate symlinks for include as they are too many include folders defined in package description compared to those declared in operating system.")
				return()
			else()#they are equal
				if(NB_INCLUDES_DESCRIPTION GREATER 1)
					#problem => how to map adequately the each include folder from the description with the adequate one in system folder ?
					#only solution is to use their filename to match them
					foreach(descr_inc IN LISTS all_includes)
						set(match_found FALSE)
						get_filename_component(DESCR_NAME ${descr_inc} NAME)
						foreach(os_inc IN LISTS os_includes_used)
							get_filename_component(OS_NAME ${os_inc} NAME)
							if(DESCR_NAME STREQUAL OS_NAME)
								create_Symlink(${os_inc} ${install_dir}/${descr_inc})
								list(REMOVE_ITEM os_includes_used ${os_inc})#this include is no more usable
								set(match_found TRUE)
								break()
							endif()
						endforeach()
						if(NOT match_found)
							message(FATAL_ERROR "[PID] CRITICAL ERROR: cannot generate symlinks for include ${descr_inc} as there is no folder with same name in operating system.")
							return()
						endif()
					endforeach()
				else()#==1
					create_Symlink(${os_includes_used} ${install_dir}/${all_includes})
				endif()
			endif()
		else()
			message(FATAL_ERROR "[PID] CRITICAL ERROR: cannot generate symlinks for ${package} OS system as the ${package} configuration provides no OS include folders !")
			return()
		endif()
	endif()
endfunction(generate_OS_Variant_Symlinks)


#.rst:
#
# .. ifmode:: internal
#
#  .. |generate_OS_Variant_Symlink_For_Path| replace:: ``generate_OS_Variant_Symlink_For_Path``
#  .. _generate_OS_Variant_Symlink_For_Path:
#
#  generate_OS_Variant_Symlink_For_Path
#  ------------------------------------
#
#   .. command:: generate_OS_Variant_Symlink_For_Path(path_to_install_dir relative_path list_of_possible_path)
#
#    Create a symlink that points to an artefact (file, library) outside of the workspace (OS path) with same name.
#
#      :path_to_install_dir: the path to the folder containing the symlink.
#
#      :relative_path: the path that will be appended to path_to_install_dir that is used to define where to generate the symlink.
#
#      :list_of_possible_path: the list of all path in filesystem that may match the symlink to generate.
#
function(generate_OS_Variant_Symlink_For_Path path_to_install_dir relative_path list_of_possible_path)
	get_filename_component(target_name ${relative_path} NAME_WE)#using NAME_WE to avoid using extension because find files of configuration may only return names without soname, not complete names
	foreach(abs_path IN LISTS list_of_possible_path)
		get_filename_component(source_name ${abs_path} NAME_WE)#using NAME_WE to avoid using extension because find files of configuration may only return names without soname, not complete names
		if(source_name STREQUAL target_name)#same name for both binaries => create the symlink
			create_Symlink(${abs_path} ${path_to_install_dir}/${relative_path})
			break()# only only simlink per relative path !!
		endif()
	endforeach()
endfunction(generate_OS_Variant_Symlink_For_Path)

#.rst:
#
# .. ifmode:: internal
#
#  .. |define_Wrapper_Framework_Contribution| replace:: ``define_Wrapper_Framework_Contribution``
#  .. _define_Wrapper_Framework_Contribution:
#
#  define_Wrapper_Framework_Contribution
#  -------------------------------------
#
#   .. command:: define_Wrapper_Framework_Contribution(framework url description)
#
#    Declare that the external project wrapper is contibuting content to a framework generated site.
#
#      :framework: the name of target framework.
#
#      :url: the url of wrapper project page.
#
#      :description: string containing a detailed description of the external package to be used in statoc site.
#
macro(define_Wrapper_Framework_Contribution framework url description)
if(${PROJECT_NAME}_FRAMEWORK AND (NOT ${PROJECT_NAME}_FRAMEWORK STREQUAL ""))
	message("[PID] ERROR: a framework (${${PROJECT_NAME}_FRAMEWORK}) has already been defined, cannot define a new one !")
	return()
elseif(${PROJECT_NAME}_SITE_GIT_ADDRESS AND (NOT ${PROJECT_NAME}_SITE_GIT_ADDRESS STREQUAL ""))
	message("[PID] ERROR: a static site (${${PROJECT_NAME}_SITE_GIT_ADDRESS}) has already been defined, cannot define a framework !")
	return()
endif()
init_Documentation_Info_Cache_Variables("${framework}" "${url}" "" "" "${description}")
endmacro(define_Wrapper_Framework_Contribution)

################################################################################
################## Functions used inside build wrapper command #################
################################################################################

#
#.rst:
#
# .. ifmode:: internal
#
#  .. |agregate_All_Build_Info_For_Component| replace:: ``agregate_All_Build_Info_For_Component``
#  .. _agregate_All_Build_Info_For_Component:
#
#  agregate_All_Build_Info_For_Component
#  -------------------------------------
#
#   .. command:: agregate_All_Build_Info_For_Component(package component mode RES_INCS RES_LIB_DIRS RES_DEFS RES_OPTS RES_STD_C RES_STD_CXX RES_LINKS RES_RESOURCES)
#
#    Agregate and get all information necessary to use the given component of the given external package, in a specific build mode (Debug or Release).
#    Deduce the options than can be used when building an external package that depends on the target package based on the description provided by external package use file
#
#    - FOR LINKS: path to links folders or direct link options: remove the -l option so that we can use it even with projects that do not use direct compiler options like those using cmake) ; do not remove the -l if no absolute path can be deduced ; resolve the path for those that can be translated into absolute path
#
#    - FOR INCLUDES: only the list of path to include folders: remove the -I option so that we can use it even with projects that do not use direct compiler options like those using cmake) ; systematically translated into absolute path
#
#    - FOR DEFINITIONS:  only the list of definitions used to compile the project version ; remove the -D option so that we can use it even with projects that do not use direct compiler options like those using cmake)
#
#    - FOR COMPILER OPTIONS: return the list of other compile options used to compile the project version ; option are kept "as is" EXCEPT those setting the C and CXX languages standards to use to build the package
#
#      :package: the name of target external package.
#
#      :component: the name of the target component.
#
#      :mode: the given build mode.
#
#      :RES_INCS: the output variable containing all include path to set when using the component.
#
#      :RES_LIB_DIRS: the output variable containing all path to folders containing some libraries used by the component.
#
#      :RES_DEFS: the output variable containing all definitions to set when using the component.
#
#      :RES_OPTS: the output variable containing all compiler options to set when using the component.
#
#      :RES_STD_C: the output variable containing the C language standard to set when using the component.
#
#      :RES_STD_CXX: the output variable containing the C++ language standard to set when using the component.
#
#      :RES_LINKS: the output variable containing all links to set when using the component.
#
#      :RES_RESOURCES: the output variable containing all runtime resources used by the component.
#
function(agregate_All_Build_Info_For_Component package component mode RES_INCS RES_LIB_DIRS RES_DEFS RES_OPTS RES_STD_C RES_STD_CXX RES_LINKS RES_RESOURCES)
get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode})

#the variables containing the adequate values are located in the use file of the package containing the component
set(all_links ${${package}_${component}_STATIC_LINKS${VAR_SUFFIX}} ${${package}_${component}_SHARED_LINKS${VAR_SUFFIX}})
set(all_definitions ${${package}_${component}_DEFS${VAR_SUFFIX}})
set(all_includes ${${package}_${component}_INC_DIRS${VAR_SUFFIX}})
get_Library_Dirs_For_Links(all_lib_dirs ${package} all_links)
list(APPEND all_lib_dirs ${${package}_${component}_LIB_DIRS${VAR_SUFFIX}})
set(all_compiler_options ${${package}_${component}_OPTS${VAR_SUFFIX}})
set(all_resources ${${package}_${component}_RUNTIME_RESOURCES${VAR_SUFFIX}})
set(c_std ${${package}_${component}_C_STANDARD${VAR_SUFFIX}})
set(cxx_std ${${package}_${component}_CXX_STANDARD${VAR_SUFFIX}})
foreach(dep_component IN LISTS ${package}_${component}_INTERNAL_DEPENDENCIES${VAR_SUFFIX})
	agregate_All_Build_Info_For_Component(${package} ${dep_component} ${mode}
	INTERN_INCS INTERN_LIB_DIRS INTERN_DEFS INTERN_OPTS INTERN_STD_C INTERN_STD_CXX INTERN_LINKS INTERN_RESOURCES)

	list(APPEND all_links ${INTERN_LINKS})
	list(APPEND all_definitions ${INTERN_DEFS})
	list(APPEND all_includes ${INTERN_INCS})
	list(APPEND all_lib_dirs ${INTERN_LIB_DIRS})
	list(APPEND all_compiler_options ${INTERN_OPTS})
	list(APPEND all_resources ${INTERN_RESOURCES})
	list(APPEND c_std ${INTERN_STD_C})
	list(APPEND cxx_std ${INTERN_STD_CXX})
endforeach()

#dealing with dependent package (do the recursion)
foreach(dep_package IN LISTS ${package}_${component}_EXTERNAL_DEPENDENCIES${VAR_SUFFIX})
	foreach(dep_component IN LISTS ${package}_${component}_EXTERNAL_DEPENDENCY_${dep_package}_COMPONENTS${VAR_SUFFIX})
		agregate_All_Build_Info_For_Component(${dep_package} ${dep_component} ${mode}
			INTERN_INCS INTERN_LIB_DIRS INTERN_DEFS INTERN_OPTS INTERN_STD_C INTERN_STD_CXX INTERN_LINKS INTERN_RESOURCES)

		list(APPEND all_links ${INTERN_LINKS})
		list(APPEND all_definitions ${INTERN_DEFS})
		list(APPEND all_includes ${INTERN_INCS})
		list(APPEND all_lib_dirs ${INTERN_LIB_DIRS})
		list(APPEND all_compiler_options ${INTERN_OPTS})
		list(APPEND all_resources ${INTERN_RESOURCES})
		list(APPEND c_std ${INTERN_STD_C})
		list(APPEND cxx_std ${INTERN_STD_CXX})
	endforeach()
endforeach()

#cleaning a bit the result to avoid repetition
remove_Duplicates_From_List(all_includes)
remove_Duplicates_From_List(all_lib_dirs)
remove_Duplicates_From_List(all_definitions)
remove_Duplicates_From_List(all_compiler_options)
remove_Duplicates_From_List(all_links)
remove_Duplicates_From_List(c_std)
remove_Duplicates_From_List(cxx_std)
remove_Duplicates_From_List(all_resources)

set(${RES_INCS} ${all_includes} PARENT_SCOPE)
set(${RES_LIB_DIRS} ${all_lib_dirs} PARENT_SCOPE)
set(${RES_DEFS} ${all_definitions} PARENT_SCOPE)
set(${RES_OPTS} ${all_compiler_options} PARENT_SCOPE)
set(${RES_STD_C} ${c_std} PARENT_SCOPE)
set(${RES_STD_CXX} ${cxx_std} PARENT_SCOPE)
set(${RES_LINKS} ${all_links} PARENT_SCOPE)
set(${RES_RESOURCES} ${all_resources} PARENT_SCOPE)
endfunction(agregate_All_Build_Info_For_Component)


#
#.rst:
#
# .. ifmode:: internal
#
#  .. |set_Build_Info_For_Dependency| replace:: ``set_Build_Info_For_Dependency``
#  .. _set_Build_Info_For_Dependency:
#
#  set_Build_Info_For_Dependency
#  -----------------------------
#
#   .. command:: set_Build_Info_For_Dependency(prefix dep_package component)
#
#    Set the cache variable containing Build information for a given dependency.
#
#      :prefix: the prefix of cache variables used to .
#
#      :component: the name of the target component.
#
#      :version: the given version.
#
function(set_Build_Info_For_Dependency prefix dep_package component)
	########## manage per dependency build variables ############

	# get current value of dependency variables
	set(links ${${prefix}_DEPENDENCY_${dep_package}_BUILD_LINKS})
	set(includes ${${prefix}_DEPENDENCY_${dep_package}_BUILD_INCLUDES})
	set(lib_dirs ${${prefix}_DEPENDENCY_${dep_package}_BUILD_LIB_DIRS})
	set(defs ${${prefix}_DEPENDENCY_${dep_package}_BUILD_DEFINITIONS})
	set(opts ${${prefix}_DEPENDENCY_${dep_package}_BUILD_COMPILER_OPTIONS})
	set(rres ${${prefix}_DEPENDENCY_${dep_package}_BUILD_RUNTIME_RESOURCES})
	set(c_std ${${prefix}_DEPENDENCY_${dep_package}_BUILD_C_STANDARD})
	set(cxx_std ${${prefix}_DEPENDENCY_${dep_package}_BUILD_CXX_STANDARD})

	# add the flags coming from direct dependencies to an external package content
	list(APPEND links ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_SHARED} ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_STATIC})
	list(APPEND includes ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_INCLUDES})
	list(APPEND lib_dirs ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_LIB_DIRS})
	list(APPEND defs ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_DEFINITIONS})
	list(APPEND opts ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_OPTIONS})
	list(APPEND rres ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_RUNTIME_RESOURCES})
	list(APPEND c_std ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_C_STANDARD})
	list(APPEND cxx_std ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_CXX_STANDARD})

	#add info comming from dependency between explicit components
	foreach(dep_component IN LISTS ${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package})
		agregate_All_Build_Info_For_Component(${dep_package} ${dep_component} Release
		RES_INCS RES_LIB_DIRS RES_DEFS RES_OPTS RES_STD_C RES_STD_CXX RES_LINKS RES_RESOURCES)
		list(APPEND links ${RES_LINKS})
		list(APPEND includes ${RES_INCS})
		list(APPEND lib_dirs ${RES_LIB_DIRS})
		list(APPEND defs ${RES_DEFS})
		list(APPEND opts ${RES_OPTS})
		list(APPEND rres ${RES_RESOURCES})
		list(APPEND c_std ${RES_STD_C})
		list(APPEND cxx_std ${RES_STD_CXX})
	endforeach()

	# evaluate variables in global variables, if any
	evaluate_Variables_In_List(EVAL_BUILD_LNKS links) #first evaluate element of the list => if they are variables they are evaluated
	evaluate_Variables_In_List(EVAL_BUILD_INCS includes)
	evaluate_Variables_In_List(EVAL_BUILD_LDIRS lib_dirs)
	evaluate_Variables_In_List(EVAL_BUILD_DEFS defs)
	evaluate_Variables_In_List(EVAL_BUILD_OPTS opts)
	evaluate_Variables_In_List(EVAL_BUILD_RRES rres)
	evaluate_Variables_In_List(EVAL_BUILD_CSTD c_std)
	evaluate_Variables_In_List(EVAL_BUILD_CXXSTD cxx_std)

	#clean a bit the result, to avoid unecessary repetitions
	remove_Duplicates_From_List(EVAL_BUILD_LNKS)
	remove_Duplicates_From_List(EVAL_BUILD_INCS)
	remove_Duplicates_From_List(EVAL_BUILD_LDIRS)
	remove_Duplicates_From_List(EVAL_BUILD_DEFS)
	remove_Duplicates_From_List(EVAL_BUILD_OPTS)
	remove_Duplicates_From_List(EVAL_BUILD_RRES)
	remove_Duplicates_From_List(EVAL_BUILD_CSTD)
	remove_Duplicates_From_List(EVAL_BUILD_CXXSTD)

	# resolve all path into absolute path if required (path to external package content)
	resolve_External_Libs_Path(BUILD_COMPLETE_LINKS_PATH "${EVAL_BUILD_LNKS}" Release)
	resolve_External_Libs_Path(BUILD_COMPLETE_LDIRS_PATH "${EVAL_BUILD_LDIRS}" Release)
	resolve_External_Includes_Path(BUILD_COMPLETE_INCS_PATH "${EVAL_BUILD_INCS}" Release)
	remove_Duplicates_From_List(BUILD_COMPLETE_LINKS_PATH)
	remove_Duplicates_From_List(BUILD_COMPLETE_LDIRS_PATH)
	remove_Duplicates_From_List(BUILD_COMPLETE_INCS_PATH)

	# set the gloal variables adequately
	set(${prefix}_DEPENDENCY_${dep_package}_BUILD_LINKS ${BUILD_COMPLETE_LINKS_PATH} CACHE INTERNAL "")
	set(${prefix}_DEPENDENCY_${dep_package}_BUILD_INCLUDES ${BUILD_COMPLETE_INCS_PATH} CACHE INTERNAL "")
	set(${prefix}_DEPENDENCY_${dep_package}_BUILD_LIB_DIRS ${BUILD_COMPLETE_LDIRS_PATH} CACHE INTERNAL "")
	set(${prefix}_DEPENDENCY_${dep_package}_BUILD_DEFINITIONS ${EVAL_BUILD_DEFS} CACHE INTERNAL "")
	set(${prefix}_DEPENDENCY_${dep_package}_BUILD_COMPILER_OPTIONS ${EVAL_BUILD_OPTS} CACHE INTERNAL "")
	set(${prefix}_DEPENDENCY_${dep_package}_BUILD_RUNTIME_RESOURCES ${EVAL_BUILD_RRES} CACHE INTERNAL "")
	set(${prefix}_DEPENDENCY_${dep_package}_BUILD_C_STANDARD ${EVAL_BUILD_CSTD} CACHE INTERNAL "")
	set(${prefix}_DEPENDENCY_${dep_package}_BUILD_CXX_STANDARD ${EVAL_BUILD_CXXSTD} CACHE INTERNAL "")

endfunction(set_Build_Info_For_Dependency)

#
#.rst:
#
# .. ifmode:: internal
#
#  .. |set_Build_Info_For_Component| replace:: ``set_Build_Info_For_Component``
#  .. _set_Build_Info_For_Component:
#
#  set_Build_Info_For_Component
#  ----------------------------
#
#   .. command:: set_Build_Info_For_Component(package component version)
#
#    Set the cache variable containing Build information for a given component of a given external package version.
#
#      :package: the name of target external package.
#
#      :component: the name of the target component.
#
#      :version: the given version.
#
function(set_Build_Info_For_Component package component version)
	set(prefix ${package}_KNOWN_VERSION_${version})

	#initialization : giving the value of system dependencies related variables (they may be useful to build the component)
	set(links ${${prefix}_COMPONENT_${component}_SYSTEM_LINKS})
	set(includes ${${prefix}_COMPONENT_${component}_SYSTEM_INCLUDES})
	set(lib_dirs ${${prefix}_COMPONENT_${component}_SYSTEM_LIB_DIRS})
	set(defs ${${prefix}_COMPONENT_${component}_SYSTEM_DEFINITIONS})
	set(opts ${${prefix}_COMPONENT_${component}_SYSTEM_OPTIONS})

	#standards need to be resolve for the component (including its own standard constraints) to get a finally usable language standard resolved
	set(c_std ${${prefix}_COMPONENT_${component}_SYSTEM_C_STANDARD})
	if(${prefix}_COMPONENT_${component}_C_STANDARD)
		take_Greater_C_Standard_Version(c_std ${prefix}_COMPONENT_${component}_C_STANDARD)
	endif()
	set(cxx_std ${${prefix}_COMPONENT_${component}_SYSTEM_CXX_STANDARD})
	if(${prefix}_COMPONENT_${component}_CXX_STANDARD)
		take_Greater_CXX_Standard_Version(cxx_std ${prefix}_COMPONENT_${component}_CXX_STANDARD)
	endif()

	set(res ${${prefix}_COMPONENT_${component}_SYSTEM_RUNTIME_RESOURCES})

	#local recursion first and caching result to avoid doing many time the same operation
	# getting all build options from internal dependencies
	foreach(dep_component IN LISTS ${prefix}_COMPONENT_${component}_INTERNAL_DEPENDENCIES)
		if(NOT ${prefix}_COMPONENT_${dep_component}_BUILD_INFO_DONE)#if result not already in cache
			set_Build_Info_For_Component(${package} ${dep_component} ${version})#compute the variable for dependencies then put it in cache
		endif()#no need to resolve
		#use the collected build information from dependencies and add it
		list(APPEND links ${${prefix}_COMPONENT_${dep_component}_BUILD_LINKS})
		list(APPEND includes ${${prefix}_COMPONENT_${dep_component}_BUILD_INCLUDES})
		list(APPEND lib_dirs ${${prefix}_COMPONENT_${dep_component}_BUILD_LIB_DIRS})
		list(APPEND defs ${${prefix}_COMPONENT_${dep_component}_BUILD_DEFINITIONS})
		list(APPEND opts ${${prefix}_COMPONENT_${dep_component}_BUILD_COMPILER_OPTIONS})
		list(APPEND res ${${prefix}_COMPONENT_${dep_component}_BUILD_RUNTIME_RESOURCES})
		list(APPEND c_std ${${prefix}_COMPONENT_${dep_component}_BUILD_C_STANDARD})
		list(APPEND cxx_std ${${prefix}_COMPONENT_${dep_component}_BUILD_CXX_STANDARD})
	endforeach()

	#dealing with dependencies between external packages
	foreach(dep_package IN LISTS ${prefix}_COMPONENT_${component}_DEPENDENCIES)

		set_Build_Info_For_Dependency(${prefix} ${dep_package} ${component})
		######### continue collecting global build variables ##########
		#add the direct use of package content within component (direct reference to includes defs, etc.)
		list(APPEND links ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_SHARED} ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_STATIC})
		list(APPEND includes ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_INCLUDES})
		list(APPEND lib_dirs ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_LIB_DIRS})
		list(APPEND defs ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_DEFINITIONS})
		list(APPEND opts ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_OPTIONS})
		list(APPEND res ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_RUNTIME_RESOURCES})
		list(APPEND c_std ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_C_STANDARD})
		list(APPEND cxx_std ${${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package}_CONTENT_CXX_STANDARD})

		#add info comming from dependency between explicit components
		foreach(dep_component IN LISTS ${prefix}_COMPONENT_${component}_DEPENDENCY_${dep_package})
			agregate_All_Build_Info_For_Component(${dep_package} ${dep_component} Release
			RES_INCS RES_LIB_DIRS RES_DEFS RES_OPTS RES_STD_C RES_STD_CXX RES_LINKS RES_RESOURCES)
			list(APPEND links ${RES_LINKS})
			list(APPEND includes ${RES_INCS})
			list(APPEND lib_dirs ${RES_LIB_DIRS})
			list(APPEND defs ${RES_DEFS})
			list(APPEND opts ${RES_OPTS})
			list(APPEND res ${RES_RESOURCES})
			list(APPEND c_std ${RES_STD_C})
			list(APPEND cxx_std ${RES_STD_CXX})
		endforeach()
	endforeach()
	#evaluate variables, if any
	evaluate_Variables_In_List(EVAL_LNKS links) #first evaluate element of the list => if they are variables they are evaluated
	evaluate_Variables_In_List(EVAL_INCS includes)
	evaluate_Variables_In_List(EVAL_LDIRS lib_dirs)
	evaluate_Variables_In_List(EVAL_DEFS defs)
	evaluate_Variables_In_List(EVAL_OPTS opts)
	evaluate_Variables_In_List(EVAL_RRES res)
	evaluate_Variables_In_List(EVAL_CSTD c_std)
	evaluate_Variables_In_List(EVAL_CXXSTD cxx_std)
	#clean a bit the result, to avoid unecessary repetitions
	remove_Duplicates_From_List(EVAL_LNKS)
	remove_Duplicates_From_List(EVAL_INCS)
	remove_Duplicates_From_List(EVAL_LDIRS)
	remove_Duplicates_From_List(EVAL_DEFS)
	remove_Duplicates_From_List(EVAL_OPTS)
	remove_Duplicates_From_List(EVAL_RRES)
	remove_Duplicates_From_List(EVAL_CSTD)
	remove_Duplicates_From_List(EVAL_CXXSTD)
	#deduce the best C and C++ standards to use
	set(c_std)
	set(cxx_std)
	foreach(std IN LISTS EVAL_CSTD)
		take_Greater_C_Standard_Version(c_std std)
	endforeach()
	foreach(std IN LISTS EVAL_CXXSTD)
		take_Greater_CXX_Standard_Version(cxx_std std)
	endforeach()
	#resolbe all path into absolute path if required (path to external package content)
	resolve_External_Libs_Path(COMPLETE_LINKS_PATH "${EVAL_LNKS}" Release)
	resolve_External_Libs_Path(COMPLETE_LDIRS_PATH "${EVAL_LDIRS}" Release)
	resolve_External_Includes_Path(COMPLETE_INCS_PATH "${EVAL_INCS}" Release)

	#finally set the cach variables taht will be written
	set(${prefix}_COMPONENT_${component}_BUILD_INFO_DONE TRUE CACHE INTERNAL "")
	set(${prefix}_COMPONENT_${component}_BUILD_INCLUDES ${COMPLETE_INCS_PATH} CACHE INTERNAL "")
	set(${prefix}_COMPONENT_${component}_BUILD_LIB_DIRS ${COMPLETE_LDIRS_PATH} CACHE INTERNAL "")
	set(${prefix}_COMPONENT_${component}_BUILD_DEFINITIONS "${EVAL_DEFS}" CACHE INTERNAL "")#guillemets are required for this
	set(${prefix}_COMPONENT_${component}_BUILD_COMPILER_OPTIONS ${EVAL_OPTS} CACHE INTERNAL "")
	set(${prefix}_COMPONENT_${component}_BUILD_C_STANDARD ${c_std} CACHE INTERNAL "")
	set(${prefix}_COMPONENT_${component}_BUILD_CXX_STANDARD ${cxx_std} CACHE INTERNAL "")
	set(${prefix}_COMPONENT_${component}_BUILD_LINKS ${COMPLETE_LINKS_PATH} CACHE INTERNAL "")
	set(${prefix}_COMPONENT_${component}_BUILD_RUNTIME_RESOURCES ${EVAL_RRES} CACHE INTERNAL "")
endfunction(set_Build_Info_For_Component)

#
#.rst:
#
# .. ifmode:: internal
#
#  .. |configure_Wrapper_Build_Variables| replace:: ``configure_Wrapper_Build_Variables``
#  .. _configure_Wrapper_Build_Variables:
#
#  configure_Wrapper_Build_Variables
#  ---------------------------------
#
#   .. command:: configure_Wrapper_Build_Variables(package version)
#
#    Set all cache variables containing Build information (includes, flags, links, options, etc.) for a given external package version.
#    Those variables will be usable inside deploy script to help configuring adequately the wrapped project.
#
#      :package: the name of target external package.
#
#      :version: the given version.
#
function(configure_Wrapper_Build_Variables package version)
	set(prefix ${package}_KNOWN_VERSION_${version})#just for a simpler description
	set(all_links)
	set(all_definitions)
	set(all_includes)
	set(all_lib_dirs)
	set(all_compiler_options)
	set(c_std)
	set(cxx_std)
	set(all_resources)
	##########################################################################################################################
	#########################Build per component information and put everything in a simple global structure##################
	##########################################################################################################################
	#agregate all build variables related to each component defined for that version of external package
	#goal is to get everything related to dependencies used by components

	foreach(component IN LISTS ${prefix}_COMPONENTS)
		set_Build_Info_For_Component(${package} ${component} ${version})
		take_Greater_C_Standard_Version(c_std ${prefix}_COMPONENT_${component}_BUILD_C_STANDARD)
		take_Greater_CXX_Standard_Version(cxx_std ${prefix}_COMPONENT_${component}_BUILD_CXX_STANDARD)
		list(APPEND all_links ${${prefix}_COMPONENT_${component}_BUILD_LINKS})
		list(APPEND all_definitions ${${prefix}_COMPONENT_${component}_BUILD_DEFINITIONS})
		list(APPEND all_compiler_options ${${prefix}_COMPONENT_${component}_BUILD_COMPILER_OPTIONS})
		list(APPEND all_includes ${${prefix}_COMPONENT_${component}_BUILD_INCLUDES})
		list(APPEND all_lib_dirs ${${prefix}_COMPONENT_${component}_BUILD_LIB_DIRS})
		list(APPEND all_resources ${${prefix}_COMPONENT_${component}_BUILD_RUNTIME_RESOURCES})
	endforeach()
	#after this loop all lists contain evaluated content so no need to evaluate variables again

	#cleaning result a bit to avoid repetitions
	remove_Duplicates_From_List(all_links)
	remove_Duplicates_From_List(all_definitions)
	remove_Duplicates_From_List(all_compiler_options)
	remove_Duplicates_From_List(all_includes)
	remove_Duplicates_From_List(all_lib_dirs)
	remove_Duplicates_From_List(all_resources)

	#set the cache variables that will be used by other functions of the wrapper API
	set(${prefix}_BUILD_INCLUDES ${all_includes} CACHE INTERNAL "")
	set(${prefix}_BUILD_LIB_DIRS ${all_lib_dirs} CACHE INTERNAL "")
	set(${prefix}_BUILD_DEFINITIONS "${all_definitions}" CACHE INTERNAL "")
	set(${prefix}_BUILD_COMPILER_OPTIONS ${all_compiler_options} CACHE INTERNAL "")
	set(${prefix}_BUILD_C_STANDARD ${c_std} CACHE INTERNAL "")
	set(${prefix}_BUILD_CXX_STANDARD ${cxx_std} CACHE INTERNAL "")
	set(${prefix}_BUILD_LINKS ${all_links} CACHE INTERNAL "")
	set(${prefix}_BUILD_RUNTIME_RESOURCES ${all_resources} CACHE INTERNAL "")
endfunction(configure_Wrapper_Build_Variables)

################################################################################
############ resolve dependencies from full package description ################
################################################################################

#
#.rst:
#
# .. ifmode:: internal
#
#  .. |resolve_Wrapper_Configuration| replace:: ``resolve_Wrapper_Configuration``
#  .. _resolve_Wrapper_Configuration:
#
#  resolve_Wrapper_Configuration
#  -----------------------------
#
#   .. command:: resolve_Wrapper_Configuration(RESULT_OK package version)
#
#    Resolve platform configuration constraints for a given external package version. The constraints will be checked to ensure the external package wrapper description is consistent.
#
#      :package: the name of target external package.
#
#      :version: the given version.
#
#      :CONFIGURED: the output variable that is TRUE if all configuration constraint are satisfied for current platform.
#
function(resolve_Wrapper_Configuration CONFIGURED package version)
	set(IS_CONFIGURED TRUE)
	foreach(config IN LISTS ${package}_KNOWN_VERSION_${version}_CONFIGURATIONS)
		check_System_Configuration_With_Arguments(RESULT_WITH_ARGS BINARY_CONSTRAINTS ${config} ${package}_KNOWN_VERSION_${version}_CONFIGURATION_${config}_ARGS Release)
		if(NOT RESULT_WITH_ARGS)
			set(IS_CONFIGURED FALSE)
			set(${config}_AVAILABLE FALSE CACHE INTERNAL "")
		else()
			set(${config}_AVAILABLE TRUE CACHE INTERNAL "")
			set(${package}_KNOWN_VERSION_${version}_CONFIGURATION_${config}_ARGS ${BINARY_CONSTRAINTS} CACHE INTERNAL "")#reset argument to keep only those required in binary
		endif()
	endforeach()
	set(${CONFIGURED} ${IS_CONFIGURED} PARENT_SCOPE)
endfunction(resolve_Wrapper_Configuration)

#
#.rst:
#
# .. ifmode:: internal
#
#  .. |resolve_Wrapper_Dependency| replace:: ``resolve_Wrapper_Dependency``
#  .. _resolve_Wrapper_Dependency:
#
#  resolve_Wrapper_Dependency
#  --------------------------
#
#   .. command:: resolve_Wrapper_Dependency(package version dep_package os_variant)
#
#    Resolve dependency between a given external project version and another external package. Will end up in deploying the dependency if necessery and possible.
#
#      :package: the name of target external package.
#
#      :version: the given version.
#
#      :dep_package: the name of the external package that is a depenency.
#
#      :os_variant: if TRUE the os_variant of the dependency will be used.
#
function(resolve_Wrapper_Dependency package version dep_package os_variant)
get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX Release)
set(PROJECT_NAME ${package})
set(USE_MODE_SUFFIX ${VAR_SUFFIX})
set(REQUIRED_PACKAGES_AUTOMATIC_DOWNLOAD TRUE)
set(prefix ${package}_KNOWN_VERSION_${version})
set(unused FALSE)
if(${prefix}_DEPENDENCY_${dep_package}_ALTERNATIVE_VERSION_USED STREQUAL "NONE")
	set(unused TRUE)#dependency will be unused in that situation even if wrapper is generating os variant of teh external package
elseif(${prefix}_DEPENDENCY_${dep_package}_ALTERNATIVE_VERSION_USED STREQUAL "SYSTEM" #the system version has been selected => need to perform specific actions
			OR os_variant)#the wrapper is generating an os variant so all its dependencies are os variant too
	#need to check the equivalent OS configuration to get the OS installed version
	check_System_Configuration(RESULT_OK CONFIG_NAME CONFIG_CONSTRAINTS "${dep_package}" Release)
	if(NOT RESULT_OK OR NOT ${dep_package}_VERSION)
		finish_Progress(${GLOBAL_PROGRESS_VAR})
		message(FATAL_ERROR "[PID] CRITICAL ERROR : dependency ${dep_package} is defined with SYSTEM version but this version cannot be found on OS.")
		return()
	endif()
	#need to detect the version in order to pas it to add_External_Package_Dependency_To_Cache
	add_External_Package_Dependency_To_Cache(${dep_package} "${${dep_package}_VERSION}" TRUE TRUE "${${prefix}_DEPENDENCY_${dep_package}_COMPONENTS}") #set the dependency
elseif(${prefix}_DEPENDENCY_${dep_package}_ALTERNATIVE_VERSION_USED STREQUAL "ANY")# any version can be used so for now no contraint
	add_External_Package_Dependency_To_Cache(${dep_package} "" FALSE FALSE "${${prefix}_DEPENDENCY_${dep_package}_COMPONENTS}")
else()#a version is specified by the user OR the dependent build process has automatically set it
	list(FIND ${prefix}_DEPENDENCY_${dep_package}_VERSIONS_EXACT ${${prefix}_DEPENDENCY_${dep_package}_ALTERNATIVE_VERSION_USED} EXACT_AT)
	if(EXACT_AT GREATER -1)#exact version used
		set(USE_EXACT TRUE)
	else()
		set(USE_EXACT FALSE)
	endif()
	add_External_Package_Dependency_To_Cache(${dep_package} "${${prefix}_DEPENDENCY_${dep_package}_ALTERNATIVE_VERSION_USED}" ${USE_EXACT} FALSE "${${prefix}_DEPENDENCY_${dep_package}_COMPONENTS}") #set the dependency
endif()
# from here: external package description variables have been set the same as for native package => same functions can be used

# resolve the package dependency according to memorized internal variables
if(NOT unused) #if the dependency is really used (in case it were optional and unselected by user)
	# try to find the adequate package version => it is necessarily required
	#package has never been found by a direct call to find_package in root CMakeLists.txt
	resolve_External_Package_Dependency(IS_COMPATIBLE ${PROJECT_NAME} ${dep_package} Release)
	if(NOT IS_COMPATIBLE)
		finish_Progress(${GLOBAL_PROGRESS_VAR})
		set(message_versions "")
		if(${dep_package}_ALL_REQUIRED_VERSIONS)
			set(message_versions "All non exact required versions are : ${${dep_package}_ALL_REQUIRED_VERSIONS}")
		elseif(${dep_package}_REQUIRED_VERSION_EXACT)#the exact required version is contained in ${dep_package}_REQUIRED_VERSION_EXACT variable.
			if(${dep_package}_REQUIRED_VERSION_SYSTEM)
				set(message_versions "OS installed version already required is ${${dep_package}_REQUIRED_VERSION_EXACT}")
			else()
				set(message_versions "Exact version already required is ${${dep_package}_REQUIRED_VERSION_EXACT}")
			endif()
		endif()
		message(FATAL_ERROR "[PID] CRITICAL ERROR : impossible to find compatible versions of dependent package ${dep_package} regarding versions constraints. Search ended when trying to satisfy version ${${PROJECT_NAME}_EXTERNAL_DEPENDENCY_${dep_package}_VERSION${USE_MODE_SUFFIX}} coming from package ${PROJECT_NAME}. ${message_versions}. Try to put this dependency as first dependency in your CMakeLists.txt in order to force its version constraint before any other.")
		return()
	elseif(${dep_package}_FOUND)#dependency has been found in workspace after resolution
		add_Chosen_Package_Version_In_Current_Process(${dep_package})#report the choice made to global build process
		#set the variables used at build time
		set(${prefix}_DEPENDENCY_${dep_package}_VERSION_USED_FOR_BUILD ${${dep_package}_VERSION_STRING} CACHE INTERNAL "")
		set(${prefix}_DEPENDENCY_${dep_package}_VERSION_USED_FOR_BUILD_IS_SYSTEM ${${dep_package}_REQUIRED_VERSION_SYSTEM} CACHE INTERNAL "")
	endif()

endif()
endfunction(resolve_Wrapper_Dependency)

#
#.rst:
#
# .. ifmode:: internal
#
#  .. |resolve_Wrapper_Dependencies| replace:: ``resolve_Wrapper_Dependencies``
#  .. _resolve_Wrapper_Dependencies:
#
#  resolve_Wrapper_Dependencies
#  ----------------------------
#
#   .. command:: resolve_Wrapper_Dependencies(package version os_variant)
#
#    Resolve all dependencies of a given external project version. Will end up in deploying the dependencies that are not satisfied, if they exist.
#
#      :package: the name of target external package.
#
#      :version: the given version.
#
#      :os_variant: if TRUE the OS variant of the dependency version will be resolved.
#
function(resolve_Wrapper_Dependencies package version os_variant)
	set(PROJECT_NAME ${package}) #to be sure that all functions will work properly
	set(prefix ${package}_KNOWN_VERSION_${version})

	#1) from wrapper description we generate the internal variables used to manage each dependency
	# and we try to find these dependencies in workspace
	foreach(dep_package IN LISTS ${prefix}_DEPENDENCIES)#among all dependencies that have been specified
		resolve_Wrapper_Dependency(${package} ${version} ${dep_package} ${os_variant})
	endforeach()

	# from here only direct dependencies have been satisfied if they are present in the workspace, otherwise they need to be installed
	# 1) resolving dependencies of required external packages versions (different versions can be required at the same time)
	# we get the set of all packages undirectly required
	foreach(dep_pack IN LISTS ${package}_EXTERNAL_DEPENDENCIES)#contains only used dependencies
		need_Install_External_Package(MUST_BE_INSTALLED ${dep_pack})
		if(MUST_BE_INSTALLED)
			install_External_Package(INSTALL_OK ${dep_pack} FALSE FALSE)
			if(NOT INSTALL_OK)
				finish_Progress(${GLOBAL_PROGRESS_VAR})
				message(FATAL_ERROR "[PID] CRITICAL ERROR : impossible to install external package: ${dep_pack}. This bug is maybe due to bad referencing of this package. Please have a look in workspace and try to fond ReferExternal${dep_pack}.cmake file in share/cmake/references folder.")
				return()
			endif()
			resolve_External_Package_Dependency(IS_COMPATIBLE ${prefix} ${dep_pack} Release)#launch again the resolution
			if(NOT ${dep_pack}_FOUND)#this time the package must be found since installed => internak BUG in PID
				finish_Progress(${GLOBAL_PROGRESS_VAR})
				message(FATAL_ERROR "[PID] INTERNAL ERROR : impossible to find installed external package ${dep_pack}. This is an internal bug maybe due to a bad find file for ${dep_ext_pack}.")
				return()
			elseif(NOT IS_COMPATIBLE)#this time there is really nothing to do since package has been installed so it therically already has all its dependencies compatible (otherwise there is simply no solution)
				finish_Progress(${GLOBAL_PROGRESS_VAR})
				message(FATAL_ERROR "[PID] CRITICAL ERROR : impossible to find compatible versions of dependent external package ${dep_pack} regarding versions constraints. Search ended when trying to satisfy version coming from package ${PROJECT_NAME}. All required versions are : ${${dep_pack}_ALL_REQUIRED_VERSIONS}, Exact version already required is ${${dep_pack}_REQUIRED_VERSION_EXACT}, Last exact version required is ${${package}_EXTERNAL_DEPENDENCY_${dep_pack}_VERSION${VAR_SUFFIX}}.")
				return()
			else()#OK resolution took place !!
				#set the variables used at build time
				set(${prefix}_DEPENDENCY_${dep_pack}_VERSION_USED_FOR_BUILD ${${dep_pack}_VERSION_STRING} CACHE INTERNAL "")
				set(${prefix}_DEPENDENCY_${dep_pack}_VERSION_USED_FOR_BUILD_IS_SYSTEM ${${dep_pack}_REQUIRED_VERSION_SYSTEM} CACHE INTERNAL "")
				add_Chosen_Package_Version_In_Current_Process(${dep_pack})#memorize chosen version in progress file to share this information with dependent packages
				if(${dep_pack}_EXTERNAL_DEPENDENCIES) #are there any dependency (external only) for this external package
					resolve_Package_Dependencies(${dep_pack} Release TRUE)#recursion : resolving dependencies for each external package dependency
				endif()
			endif()
		else()#no need to be installed -> already found
			resolve_Package_Dependencies(${dep_pack} Release TRUE)
		endif()
	endforeach()
endfunction(resolve_Wrapper_Dependencies)
