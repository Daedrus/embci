# Embedded CI
A proof-of-concept for a CI system meant for embedded software development

This README currently functions as a journal to track my progress and ideas.

## Purpose
To create a simple CI setup which will assist me when learning Embedded Rust.

The aim is to use a [LattePanda 3 Delta](https://www.lattepanda.com/lattepanda-3-delta)
as the CI server and connect it to two Raspberry Pi Picos and a Saleae logic
analyzer.

It should be possible to:
* build embedded Rust source code
* flash it to either Raspberry Pi Pico
* use Saleae's Automation API to run tests on the Picos

Note: I initially wanted to use a Raspberry Pi 4 but Saleae's Logic [does not
have binaries for ARM](https://support.saleae.com/faq/technical-faq/can-logic-run-on-arm)

## Current approach
I am running [NixOS](https://nixos.org/) on the LattePanda and the following
dockerized applications:
- [Gitea](https://about.gitea.com/) for Git repository management
- [Woodpecker](https://woodpecker-ci.org/) as a CI engine
- [MinIO](https://min.io/) for artifact storage

Use [Docker Compose](https://docs.docker.com/compose/) to run the above.

Minimal security to begin with, just to get the ball rolling.

## System diagram
![embci](embci.png)

## Steps
- Install NixOS 23.11 and use the `configuration.nix` file from my `configfiles`
  [repository](https://github.com/Daedrus/configfiles) together with the
  `embci.nix` file from this repository.
- Clone this repository
- Configure the LattePanda's IP address in `.env`. This variable is used
  by `docker-compose.yml`. For the instructions below, replace `$IP_ADDRESS`
  with the IP address.
- Configure the debug probes' serial numbers in `.env`
- Start the MinIO container
  `docker compose up -d minio`
- Access `http://$IP_ADDRESS:9001/` in your browser
- Log in with minioadmin/minioadmin (the default admin user)
- Create an access key and copy the results in the `MINIO_ACCESS_KEY` and
  `MINIO_SECRET_KEY` variables in `.env`
- Start the Gitea container
  `docker compose up -d gitea`
- Access `http://$IP_ADDRESS:3000/` in your browser
- Log in with embci/embci (the default admin user)
- Go to `http://$IP_ADDRESS:3000/user/settings/applications` and in
  `Manage OAuth2 Applications` choose:  
  `Application Name: Woodpecker CI`  
  `Redirect URI: http://$IP_ADDRESS:8000/authorize`  
  Make sure that the `Confidential Client` checkbox is ticked and then click
  `Create Application`  
  Copy the `Client ID` in the `WOODPECKER_GITEA_CLIENT` variable in `.env`  
  Copy the `Client Secret` in the `WOODPECKER_GITEA_SECRET` variable in `.env`  
  Finally click `Save`
- Clone the `https://github.com/Daedrus/embci-example-repo` repository by
  clicking the + button in the top-right and choosing `New Migration` ->
  `Github`
- Create an agent secret  
  `openssl rand -base64 32`  
  and add the output to the `WOODPECKER_AGENT_SECRET` variable in `.env`
- Stop MinIO and Gitea
  `docker compose stop`
- All of the variables in `.env` should be set (none of them should be set
  to CHANGEME anymore)
- Start all containers
  `docker compose up -d`
- Access `http://$IP_ADDRESS:8000/` in your browser
- Log in with embci/embci (the default admin user)
- It should ask to confirm the authentication
- Add the `embci-example-repo` repository to Woodpecker and run the pipeline
- Things should work out of the box provided that your hardware setup is
  similar to mine or, if different, you have made the necessary changes.
- Note that the Woodpecker agent is currently running in privileged mode
  since I couldn't get it to work with the debug probe and the analyzer
  otherwise. I hope to fix this in the future.
