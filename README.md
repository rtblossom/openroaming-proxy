# Table of Contents
1. [Introduction](#introduction)
2. [Install Prerequisites](#install-prerequisites)
3. [Configurable Inputs](#configurable-inputs)
4. [Configure Local RADIUS Server](#configure-local-radius-server)
5. [Add Certificates](#add-certificates)
6. [Start Server](#start-server)

## Install Prerequisites
1. Docker (https://docs.docker.com/engine/install/)
2. docker-compose (https://docs.docker.com/compose/install/)

## Configurable Inputs
Set as environment variables:
  1. LOCAL_SHARED_SECRET: RADIUS shared secret (defaults to secret)
  2. CLIENT_KEY: Client key (base64-encoded pem file)
  3. CLIENT_CRT: Client certificate that is sent over RadSec (base64-encoded pem file, needs to have client cert on top)

Set in docker-compose file:
  1. Published RADIUS authentication port (defaults to 1812)
  2. Published RADIUS accounting port (defaults to 1813)

The next few sections go over configuring the inputs.

## Configure Local RADIUS Server
This container consists of a local RADIUS server that proxies to dynamically-discoverable hosts via RadSec. The following information is needed for the local RADIUS server.

1. Shared secret
2. Authentication port
3. Accounting port

Search `docker-compose.yml` for the comment text `CONFIGURE`. Replace corresponding values with desired values.

For example, replace the following to configure the RADIUS shared secret from 'secret' to 'super_secret'.

```
LOCAL_SHARED_SECRET: secret #CONFIGURE: RADIUS shared secret
```

With this

```
LOCAL_SHARED_SECRET: super_secret #CONFIGURE: RADIUS shared secret
```

## Add Certificates

#### Step 1: Create an environment file to store certificates and key
Certificates and private key are passed to the container as environment variables. We need to create an environment variables file to store this information.

Make a copy of the .env.pki.stub file and name it .env.pki.

Linux / Mac OS command:
```
cp .env.pki.stub .env.pki
```

#### Step 2: Get certificate pem files ready
Prepare the certificate pem files. These are needed for adding as environment variables when deploying the container.

1. client.crt.pem : individual client certificate
2. client.key.pem : client key
3. chain.crt.pem : Openroaming certificate chain that issued client certificate

#### Step 3: Combine Openroaming ANP certificates into chain
Starting with client certificate at the top, combine all Openroaming certificates into one file.

Linux / Mac OS command:
```
cat client.crt.pem chain.crt.pem > client.chain.crt.pem
```

#### Step 4: Base64-encode client certs and key

Base64 client certs. Output will be passed to container as as `CLIENT_CRT` environment variable.

Linux / Mac OS command:
```
base64 -i client.chain.crt.pem
```
Copy and paste above output into CLIENT_CRT in .env.pki so it will have.....
```
CLIENT_CRT=<<your pasted base64 text>>
```

Base64 client key. Output will be passed to container as as `CLIENT_KEY` environment variable.

Linux / Mac OS command:
```
base64 -i client.key
```

Copy and paste above output into `CLIENT_KEY` in .env.pki so it will have.....
```
CLIENT_KEY=<<your pasted base64 text>>
```

## Start Server

Run the following command to start the server in the foreground:
```
docker-compose up
```
The output should be similar to the following:
```
❯ docker-compose up
Starting openroaming-proxy ... done
Attaching to openroaming-proxy
openroaming-proxy | Wed Jul  5 22:35:43 2023: radsecproxy 1.9.3 starting
openroaming-proxy | Wed Jul  5 22:35:43 2023: udp server writer, waiting for signal
openroaming-proxy | Wed Jul  5 22:35:43 2023: resolvehostport: (src info not available) -> 0.0.0.0
openroaming-proxy | Wed Jul  5 22:35:43 2023: disable_DF_bit: disabling DF bit (Linux variant)
openroaming-proxy | Wed Jul  5 22:35:43 2023: createlistener: listening for udp on *:1812
openroaming-proxy | Wed Jul  5 22:35:43 2023: resolvehostport: (src info not available) -> 0.0.0.0
openroaming-proxy | Wed Jul  5 22:35:43 2023: disable_DF_bit: disabling DF bit (Linux variant)
openroaming-proxy | Wed Jul  5 22:35:43 2023: createlistener: listening for udp on *:1813
```

Run the following command to build image again if you made changes to the source files.
```
docker-compose build
```
