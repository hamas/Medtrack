#!/bin/bash

# This script generates the real firebase_options.dart by replacing the 
# String.fromEnvironment calls with the actual environment variables provided by Vercel.

sed -e "s/String.fromEnvironment('FIREBASE_WEB_API_KEY')/'$FIREBASE_WEB_API_KEY'/g" \
    -e "s/String.fromEnvironment('FIREBASE_WEB_APP_ID')/'$FIREBASE_WEB_APP_ID'/g" \
    -e "s/String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID')/'$FIREBASE_MESSAGING_SENDER_ID'/g" \
    -e "s/String.fromEnvironment('FIREBASE_PROJECT_ID')/'$FIREBASE_PROJECT_ID'/g" \
    -e "s/String.fromEnvironment('FIREBASE_WEB_AUTH_DOMAIN')/'$FIREBASE_WEB_AUTH_DOMAIN'/g" \
    -e "s/String.fromEnvironment('FIREBASE_STORAGE_BUCKET')/'$FIREBASE_STORAGE_BUCKET'/g" \
    -e "s/String.fromEnvironment('FIREBASE_WEB_MEASUREMENT_ID')/'$FIREBASE_WEB_MEASUREMENT_ID'/g" \
    -e "s/String.fromEnvironment('FIREBASE_ANDROID_API_KEY')/'$FIREBASE_ANDROID_API_KEY'/g" \
    -e "s/String.fromEnvironment('FIREBASE_ANDROID_APP_ID')/'$FIREBASE_ANDROID_APP_ID'/g" \
    lib/firebase_options.template.dart > lib/firebase_options.dart

echo "Successfully generated lib/firebase_options.dart from environment variables."
