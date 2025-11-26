#!/bin/bash

# Define variables for keystore properties
KEYSTORE_NAME="my-release-key.jks"
KEYSTORE_PATH="../keys/$KEYSTORE_NAME"
ALIAS="my-key-alias"
STORE_PASSWORD="your-store-password"
KEY_PASSWORD="your-key-password"
VALIDITY=10000

# Generate the keystore
keytool -genkeypair -v -keystore "$KEYSTORE_PATH" -alias "$ALIAS" -storepass "$STORE_PASSWORD" -keypass "$KEY_PASSWORD" -keyalg RSA -keysize 2048 -validity $VALIDITY -dname "CN=Your Name, OU=Your Organization, O=Your Company, L=Your City, S=Your State, C=Your Country"

echo "Keystore generated at $KEYSTORE_PATH"