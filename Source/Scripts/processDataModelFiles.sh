#!/bin/sh
#  mogen.sh
#
#  Created by Jean-Denis Muys on 24/02/11.
#  Modified by Ryan Rounkles on 15/5/11 to use correct model version and to account for spaces in file paths

#TODO: Change this to the name of custom ManagedObject base class
#  If no custom MO class is required, remove the "--base-class $baseClass" parameter from mogenerator call
baseClass=TLManagedObject

echo mogenerator --model \"${INPUT_FILE_PATH}\" --human-dir "${INPUT_FILE_DIR}/../Classes/CoreData/Entities/" --machine-dir "${INPUT_FILE_DIR}/../Classes/CoreData/Generated" --base-class $baseClass --template-var arc=true
mogenerator --model \"${INPUT_FILE_PATH}\" --human-dir "${INPUT_FILE_DIR}/../Classes/CoreData/Entities/" --machine-dir "${INPUT_FILE_DIR}/../Classes/CoreData/Generated" --base-class $baseClass --template-var arc=true

if [ -n "${EXECUTABLE_FOLDER_PATH:+x}" ]; then

  if [[ ("${EFFECTIVE_PLATFORM_NAME}" == "-iphonesimulator") || ("${EFFECTIVE_PLATFORM_NAME}" == "-iphoneos") ]]; then
    RESOURCE_BUNDLE_PATH="${TARGET_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}"
  else
    RESOURCE_BUNDLE_PATH="${TARGET_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}/../Resources/"
  fi

  # On a clean build the target directory does not exist, yet. Consequently "momc" will fail. Therefore we create it here.
  mkdir -p "${RESOURCE_BUNDLE_PATH}"

  echo \"${DEVELOPER_BIN_DIR}/momc\" -XD_MOMC_SDKROOT=\"${SDKROOT}\" -XD_MOMC_IOS_TARGET_VERSION=${IPHONEOS_DEPLOYMENT_TARGET} -MOMC_PLATFORMS iphonesimulator -MOMC_PLATFORMS iphoneos  -XD_MOMC_TARGET_VERSION=10.6 \"${INPUT_FILE_PATH}\" \"${RESOURCE_BUNDLE_PATH}/${INPUT_FILE_BASE}.mom\"
  "${DEVELOPER_BIN_DIR}/momc" -XD_MOMC_SDKROOT="${SDKROOT}" -XD_MOMC_IOS_TARGET_VERSION=${IPHONEOS_DEPLOYMENT_TARGET} -MOMC_PLATFORMS iphonesimulator -MOMC_PLATFORMS iphoneos  -XD_MOMC_TARGET_VERSION=10.6 "${INPUT_FILE_PATH}" "${RESOURCE_BUNDLE_PATH}/${INPUT_FILE_BASE}.mom"

else
  echo "Error: Executable folder not defined."
fi
