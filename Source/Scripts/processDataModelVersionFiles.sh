#!/bin/sh
#  mogend.sh
#
#  Created by Jean-Denis Muys on 24/02/11.
#  Modified by Ryan Rounkles on 15/5/11 to use correct model version and to account for spaces in file paths

#TODO: Change this to the name of custom ManagedObject base class (if applicable)
#  If no custom MO class is required, remove the "--base-class $baseClass" parameter from mogenerator call
baseClass=TLManagedObject

curVer=`/usr/libexec/PlistBuddy "${INPUT_FILE_PATH}/.xccurrentversion" -c 'print _XCCurrentVersionName'`

echo mogenerator --model "${INPUT_FILE_PATH}/$curVer" --human-dir "${INPUT_FILE_DIR}/../Classes/CoreData/Entities/" --machine-dir "${INPUT_FILE_DIR}/../Classes/CoreData/Generated" --base-class $baseClass --template-var arc=true
mogenerator --model "${INPUT_FILE_PATH}/$curVer" --human-dir "${INPUT_FILE_DIR}/../Classes/CoreData/Entities/" --machine-dir "${INPUT_FILE_DIR}/../Classes/CoreData/Generated" --base-class $baseClass --template-var arc=true

if [ -n "${EXECUTABLE_FOLDER_PATH:+x}" ]; then

  if [[ ("${EFFECTIVE_PLATFORM_NAME}" == "-iphonesimulator") || ("${EFFECTIVE_PLATFORM_NAME}" == "-iphoneos") ]]; then
    RESOURCE_BUNDLE_PATH="${TARGET_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}"
  else
    RESOURCE_BUNDLE_PATH="${TARGET_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}/../Resources/"
  fi

  # On a clean build the target directory does not exist, yet. Consequently "momc" will fail. Therefore we create it here.
  mkdir -p "${RESOURCE_BUNDLE_PATH}"

  echo \"${DEVELOPER_BIN_DIR}/momc\" -XD_MOMC_SDKROOT=\"${SDKROOT}\" -XD_MOMC_IOS_TARGET_VERSION=${IPHONEOS_DEPLOYMENT_TARGET} -MOMC_PLATFORMS iphonesimulator -MOMC_PLATFORMS iphoneos  -XD_MOMC_TARGET_VERSION=10.6 \"${INPUT_FILE_PATH}\" \"${RESOURCE_BUNDLE_PATH}/${INPUT_FILE_BASE}.momd\"
  "${DEVELOPER_BIN_DIR}/momc" -XD_MOMC_SDKROOT="${SDKROOT}" -XD_MOMC_IOS_TARGET_VERSION=${IPHONEOS_DEPLOYMENT_TARGET} -MOMC_PLATFORMS iphonesimulator -MOMC_PLATFORMS iphoneos  -XD_MOMC_TARGET_VERSION=10.6 "${INPUT_FILE_PATH}" "${RESOURCE_BUNDLE_PATH}/${INPUT_FILE_BASE}.momd"

else
  echo "Error: Executable folder not defined."
fi
