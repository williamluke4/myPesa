# This script creates ./android/key.properties file which is used signing


# Checking whether the secrets are available as environment
# variables or not.
if [ -z "${ANDROID_KEYSTORE}" ]; then
    echo "Missing ANDROID_KEYSTORE environment variable"
    exit 1
fi

if [ -z "${KEYSTORE_PASSWORD}" ]; then
    echo "Missing KEYSTORE_PASSWORD environment variable"
    exit 1
fi

if [ -z "${ALIAS_NAME}" ]; then
    echo "Missing ALIAS_NAME environment variable"
    exit 1
fi

if [ -z "${KEY_PASSWORD}" ]; then
    echo "Missing KEY_PASSWORD environment variable"
    exit 1
fi

echo -n ${ANDROID_KEYSTORE} | base64 -d > ./android/my.keystore
cat <<EOF > ./android/key.properties
storeFile=../my.keystore
storePassword=${KEYSTORE_PASSWORD}
keyAlias=${ALIAS_NAME}
keyPassword=${KEY_PASSWORD}
EOF
