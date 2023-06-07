# Embedded CI
A proof-of-concept for a CI system meant for embedded software development

This README currently functions as a journal to track my progress and ideas.

## Purpose
To create a simple CI setup which will assist me when learning Embedded Rust.
The aim is to use a [LattePanda 3 Delta](https://www.lattepanda.com/lattepanda-3-delta)
as the CI server and connect it to a Raspberry Pi Pico and a Saleae logic
analyzer.

It should be possible to:
* build embedded Rust source code
* flash it to the Raspberry Pi Pico
* use Saleae's Automation API to run tests on the Pico

Note: I initially wanted to use a Raspberry Pi 4 but Saleae's Logic [does not
have binaries for ARM](https://support.saleae.com/faq/technical-faq/can-logic-run-on-arm)

## Current approach
I am running Ubuntu Desktop 22.04.2 LTS on the LattePanda and a dockerized
Woodpecker server + agent combo which get started by docker compose. Minimal
security to begin with, just get the ball rolling.

Will switch to Ubuntu Server at some point. If things go well I might create
Ansible provisioning scripts for the box so that I can experiment with other
Linux variants.

## Steps (TODO: clean up and add pictures)
- install Ubuntu Desktop 22.04.2 LTS
- set up Ubuntu (apt-get update, apt-get upgrade, etc.)
- install Docker Engine + docker-compose  
  https://docs.docker.com/engine/install/ubuntu/
- for convenience, make sure you can run Docker as a non-root user  
  https://docs.docker.com/engine/install/linux-postinstall/
- enable SSH service (leave default for now, aka password based authentication)  
  https://ubuntuhandbook.org/index.php/2022/04/enable-ssh-ubuntu-22-04/
- set up udev rules to handle the Raspberry Pi Debug Probe  
  https://probe.rs/docs/getting-started/probe-setup/
- set up udev rules to handle Saleae logic analyzers
  ```
  embci@LattePanda:~/git/embci$ cat /etc/udev/rules.d/99-SaleaeLogic.rules
  # Saleae Logic Analyzer
  # This file should be installed to /etc/udev/rules.d so that you can access the Logic hardware without being root
  #
  # type this at the command prompt: sudo cp 99-SaleaeLogic.rules /etc/udev/rules.d

  SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="0925", ATTR{idProduct}=="3881", MODE="0666"
  SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1001", MODE="0666"
  SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1003", MODE="0666"
  SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1004", MODE="0666"
  SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1005", MODE="0666"
  SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1006", MODE="0666"
  ```
- set up an environment variable containing the LattePanda's IP address,
  for example `export IP_ADDRESS=192.168.0.104`. This variable is used
  by `docker-compose.yml`. For the instructions below, replace `$IP_ADDRESS`
  with the IP address.
- start the Gitea container
  `docker compose up -d gitea`
- access http://$IP_ADDRESS:3000/ in your browser
- configure the admin user in `Optional Settings` below then click
  `Install Gitea`
- go to http://$IP_ADDRESS:3000/user/settings/applications and below in
  `Manage OAuth2 Applications` choose:  
  `Application Name: Woodpecker CI`  
  `Redirect URI: http://$IP_ADDRESS:8000/authorize`  
  make sure that the `Confidential Client` checkbox is ticked and then click
  `Create Application`  
  copy the `Client ID` in the `WOODPECKER_GITEA_CLIENT` variable in `.env`  
  copy the `Client Secret` in the `WOODPECKER_GITEA_SECRET` variable in `.env`  
  finally click `Save`
- create an agent secret  
  `openssl rand -base64 32`  
  and add the output to the `WOODPECKER_AGENT_SECRET` variable in `.env`
- start the Woodpecker server and agent containers
  `docker compose up -d`
- go back to Gitea, mirror the `https://github.com/Daedrus/embci-example-repo`
  repository
- add that repository to Woodpecker and run the pipeline
