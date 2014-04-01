LinkedInSDK
===========

### Summary

This project contains SDK for simple LinkedIn integration.

The project is configured for building with the iOS7 SDK with a deployment target of iOS6.

### To use the demo:

1. Add your API keys to User-Defined block in project Build Settings under the keys `LINKEDIN_API_KEY` and `LINKEDIN_SECRET_KEY` keys, respectively.
2. Build and run. Click the button labeled "Login" to execute the token exchange and get your profile info. Click "Send" button to post new status.

### Author

This lybrary was created by Ilya Elovikov (@RavenEIA)

### Credits:

The OAuth library used is derived from the OAuthConsumer project.
Some changes were made but it's mostly intact.
    http://code.google.com/p/oauthconsumer/wiki/UsingOAuthConsumer

The JSON library used is JSONKit by John Engelhart.
    https://github.com/johnezang/JSONKit
