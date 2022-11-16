# ``Authentication``

This Package is a way that we could login to Billetautomaten which is an OAuth2, however you should inject all the ``AuthenticationHandler/Configuration`` to it to be able to use the functionality

## Overview

By using ``AuthenticationHandler`` You will be able to do:

- Login User by ``AuthenticationHandler/login()``
- Fetch Token ``AuthenticationHandler/fetchToken()``
- Store/Retrieve the Token on Keychain ``AuthenticationHandler/fetchToken()``
- Refresh Token ``AuthenticationHandler/fetchToken()``
- Logout User ``AuthenticationHandler/logout()``
- Check Token exist or not ``AuthenticationHandler/checkTokenIfExist()``

![The Hacking with Swift logo](chart.png)

## Topics

### Models
- ``AuthenticationHandler/Configuration``
- ``AuthenticationHandler/TokenModel``
- ``AuthenticationHandler/UserModel``
- ``AuthenticationHandler/CustomError``

