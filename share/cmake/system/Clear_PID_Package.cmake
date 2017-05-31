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

include(${WORKSPACE_DIR}/pid/Workspace_Platforms_Info.cmake) #loading the current platform configuration


list(APPEND CMAKE_MODULE_PATH ${WORKSPACE_DIR}/share/cmake/system)
include(PID_Workspace_Internal_Functions NO_POLICY_SCOPE)

if(TARGET_PACKAGE AND TARGET_VERSION)
	if(	EXISTS ${WORKSPACE_DIR}/install/${CURRENT_PLATFORM}/${TARGET_PACKAGE}
		AND IS_DIRECTORY ${WORKSPACE_DIR}/install/${CURRENT_PLATFORM}/${TARGET_PACKAGE})
		clear_PID_Package(	${TARGET_PACKAGE}
					${TARGET_VERSION})
	elseif(EXISTS ${WORKSPACE_DIR}/external/${CURRENT_PLATFORM}/${TARGET_PACKAGE}
		AND IS_DIRECTORY ${WORKSPACE_DIR}/external/${CURRENT_PLATFORM}/${TARGET_PACKAGE})
		clear_PID_Package(	${TARGET_PACKAGE}
					${TARGET_VERSION})
	else()
		message("[PID] ERROR : there is no package named ${TARGET_PACKAGE} installed.")
	endif()
else()
	message("[PID] ERROR : you must specify the name of the package to clear using name=<name of package> argument and a version using version=<type or number of the  version>")
endif()
