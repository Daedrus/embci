# Embedded CI
A proof-of-concept for a CI system meant for embedded software development

This README currently functions as a journal to track my progress and ideas.

## Purpose
To create a simple CI setup which will assist me when learning Embedded Rust.
The aim is to use a Raspberry Pi 4 as the CI server and connect it to a
Raspberry Pi Pico and a Saleae logic analyzer.

It should be possible to:
* build embedded Rust source code
* flash it to the Raspberry Pi Pico
* use Saleae's Automation API to run tests on the Pico

At the moment I am not sure if the Raspberry Pi 4 has enough resources to run
a CI server and the Saleae Automation API, time will tell. Might have to buy
a "normal" computer to do this.

## Current approach
I am planning on running Ubuntu Desktop 22.04.2 LTS on the Raspberry Pi 4 and
a dockerized Jenkins controller + agent combo which get started by docker
compose. Minimal security to begin with, just get the ball rolling.

Will switch to Ubuntu Server once I figure out the Jenkins CLI and see if Saleae
Automation API can work without the Logic GUI. If things go well I might create
Ansible provisioning scripts for the box so that I can experiment with other
Linux variants.

## Steps (so far)
- install Ubuntu Desktop 22.04.2 LTS for Raspberry Pi 4  
  https://ubuntu.com/download/raspberry-pi/thank-you?version=22.04.2&architecture=desktop-arm64+raspi  
  ubuntu-22.04.2-preinstalled-desktop-arm64+raspi.img-xz
- flash image on SD card using Raspberry Pi Imager  
  https://downloads.raspberrypi.org/imager/imager_latest.exe  
  imager_1.7.4.exe
- set up Ubuntu
- install Docker Engine + docker-compose  
  https://docs.docker.com/engine/install/ubuntu/  
  https://docs.docker.com/compose/install/linux/#install-using-the-repository
- enable SSH service (leave default for now, aka password based authentication)  
  https://ubuntuhandbook.org/index.php/2022/04/enable-ssh-ubuntu-22-04/
- log in from laptop to Raspbery Pi 4 using SSH
- give up on Jenkins, Buildbot, GoCD  
  Jenkins is too bulky and I don't really want to write Groovy  
  I couldn't get Buildbot to work with docker-compose, their docs seem out of sync  
  GoCD seems to have maintenance issues
- try woodpecker-ci  
  use docker-compose to create a gitea server, a woodpecker server and a woodpecker agent  
  TODO how to skip gitea initial configuration?  
  TODO how to create a repo and have it visible in gitea by default?
- TODO write docker compose instructions
- TODO  
  TODO :)
