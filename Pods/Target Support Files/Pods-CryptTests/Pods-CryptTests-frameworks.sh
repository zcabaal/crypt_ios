#!/bin/sh
set -e

echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

SWIFT_STDLIB_PATH="${DT_TOOLCHAIN_DIR}/usr/lib/swift/${PLATFORM_NAME}"

install_framework()
{
  if [ -r "${BUILT_PRODUCTS_DIR}/$1" ]; then
    local source="${BUILT_PRODUCTS_DIR}/$1"
  elif [ -r "${BUILT_PRODUCTS_DIR}/$(basename "$1")" ]; then
    local source="${BUILT_PRODUCTS_DIR}/$(basename "$1")"
  elif [ -r "$1" ]; then
    local source="$1"
  fi

  local destination="${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

  if [ -L "${source}" ]; then
      echo "Symlinked..."
      source="$(readlink "${source}")"
  fi

  # use filter instead of exclude so missing patterns dont' throw errors
  echo "rsync -av --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" --filter \"- Headers\" --filter \"- PrivateHeaders\" --filter \"- Modules\" \"${source}\" \"${destination}\""
  rsync -av --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" --filter "- Headers" --filter "- PrivateHeaders" --filter "- Modules" "${source}" "${destination}"

  local basename
  basename="$(basename -s .framework "$1")"
  binary="${destination}/${basename}.framework/${basename}"
  if ! [ -r "$binary" ]; then
    binary="${destination}/${basename}"
  fi

  # Strip invalid architectures so "fat" simulator / device frameworks work on device
  if [[ "$(file "$binary")" == *"dynamically linked shared library"* ]]; then
    strip_invalid_archs "$binary"
  fi

  # Resign the code if required by the build settings to avoid unstable apps
  code_sign_if_enabled "${destination}/$(basename "$1")"

  # Embed linked Swift runtime libraries. No longer necessary as of Xcode 7.
  if [ "${XCODE_VERSION_MAJOR}" -lt 7 ]; then
    local swift_runtime_libs
    swift_runtime_libs=$(xcrun otool -LX "$binary" | grep --color=never @rpath/libswift | sed -E s/@rpath\\/\(.+dylib\).*/\\1/g | uniq -u  && exit ${PIPESTATUS[0]})
    for lib in $swift_runtime_libs; do
      echo "rsync -auv \"${SWIFT_STDLIB_PATH}/${lib}\" \"${destination}\""
      rsync -auv "${SWIFT_STDLIB_PATH}/${lib}" "${destination}"
      code_sign_if_enabled "${destination}/${lib}"
    done
  fi
}

# Signs a framework with the provided identity
code_sign_if_enabled() {
  if [ -n "${EXPANDED_CODE_SIGN_IDENTITY}" -a "${CODE_SIGNING_REQUIRED}" != "NO" -a "${CODE_SIGNING_ALLOWED}" != "NO" ]; then
    # Use the current code_sign_identitiy
    echo "Code Signing $1 with Identity ${EXPANDED_CODE_SIGN_IDENTITY_NAME}"
    echo "/usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements \"$1\""
    /usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements "$1"
  fi
}

# Strip invalid architectures
strip_invalid_archs() {
  binary="$1"
  # Get architectures for current file
  archs="$(lipo -info "$binary" | rev | cut -d ':' -f1 | rev)"
  stripped=""
  for arch in $archs; do
    if ! [[ "${VALID_ARCHS}" == *"$arch"* ]]; then
      # Strip non-valid architectures in-place
      lipo -remove "$arch" -output "$binary" "$binary" || exit 1
      stripped="$stripped $arch"
    fi
  done
  if [[ "$stripped" ]]; then
    echo "Stripped $binary of architectures:$stripped"
  fi
}


if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_framework "Pods-CryptTests/AFNetworking.framework"
  install_framework "Pods-CryptTests/Alamofire.framework"
  install_framework "Pods-CryptTests/Bolts.framework"
  install_framework "Pods-CryptTests/Braintree.framework"
  install_framework "Pods-CryptTests/Canvas.framework"
  install_framework "Pods-CryptTests/CocoaLumberjack.framework"
  install_framework "Pods-CryptTests/FBSDKCoreKit.framework"
  install_framework "Pods-CryptTests/FBSDKLoginKit.framework"
  install_framework "Pods-CryptTests/FBSDKShareKit.framework"
  install_framework "Pods-CryptTests/JWTDecode.framework"
  install_framework "Pods-CryptTests/LUKeychainAccess.framework"
  install_framework "Pods-CryptTests/Lock.framework"
  install_framework "Pods-CryptTests/LockFacebook.framework"
  install_framework "Pods-CryptTests/MBProgressHUD.framework"
  install_framework "Pods-CryptTests/Masonry.framework"
  install_framework "Pods-CryptTests/NSData_Base64.framework"
  install_framework "Pods-CryptTests/OAuthCore.framework"
  install_framework "Pods-CryptTests/Obfuscator.framework"
  install_framework "Pods-CryptTests/PSAlertView.framework"
  install_framework "Pods-CryptTests/SimpleKeychain.framework"
  install_framework "Pods-CryptTests/Stripe.framework"
  install_framework "Pods-CryptTests/SwiftValidator.framework"
  install_framework "Pods-CryptTests/SwiftyJSON.framework"
  install_framework "Pods-CryptTests/TWReverseAuth.framework"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_framework "Pods-CryptTests/AFNetworking.framework"
  install_framework "Pods-CryptTests/Alamofire.framework"
  install_framework "Pods-CryptTests/Bolts.framework"
  install_framework "Pods-CryptTests/Braintree.framework"
  install_framework "Pods-CryptTests/Canvas.framework"
  install_framework "Pods-CryptTests/CocoaLumberjack.framework"
  install_framework "Pods-CryptTests/FBSDKCoreKit.framework"
  install_framework "Pods-CryptTests/FBSDKLoginKit.framework"
  install_framework "Pods-CryptTests/FBSDKShareKit.framework"
  install_framework "Pods-CryptTests/JWTDecode.framework"
  install_framework "Pods-CryptTests/LUKeychainAccess.framework"
  install_framework "Pods-CryptTests/Lock.framework"
  install_framework "Pods-CryptTests/LockFacebook.framework"
  install_framework "Pods-CryptTests/MBProgressHUD.framework"
  install_framework "Pods-CryptTests/Masonry.framework"
  install_framework "Pods-CryptTests/NSData_Base64.framework"
  install_framework "Pods-CryptTests/OAuthCore.framework"
  install_framework "Pods-CryptTests/Obfuscator.framework"
  install_framework "Pods-CryptTests/PSAlertView.framework"
  install_framework "Pods-CryptTests/SimpleKeychain.framework"
  install_framework "Pods-CryptTests/Stripe.framework"
  install_framework "Pods-CryptTests/SwiftValidator.framework"
  install_framework "Pods-CryptTests/SwiftyJSON.framework"
  install_framework "Pods-CryptTests/TWReverseAuth.framework"
fi
