# About
This repository contains resources to setup a Particle device as a Spanner Testboard.

## Supported Particle Devices
* Argon
* Photon
* Xenon

## Supported Operating Systems
* Linux Ubuntu
* MacOS 10.10 and later
* Microsoft Windows 7 and later

For Linux and Mac, all the required software will be installed by the provided
'spannerize.sh' shell script. 

For Microsoft Windows, two packages need to be installed:
* MinGW (http://www.mingw.org)
* The Particle CLI setup: https://binaries.particle.io/cli/installer/windows/ParticleCLISetup.exe

For Microsoft Windows 7, extra device drivers needed for Gen 3 devices (argon, xenon, boron):
* Download Zadig (https://zadig.akeo.ie)
* Put the Particle device in listening mode (1)
* Run Zadic app, select “USB Serial (CDC)” and install driver
* Put the Particle device in DFU Mode (1), select “libusbK(v3.0.7.0)” and install driver

(1) For Particle device modes, check: https://docs.particle.io/tutorials/device-os/led/argon/#listening-mode

## Provisioning
Provisioning will enable a Particle device to be used as a Spanner Testboard.
For easy setup, the 'spannerize.sh <device>' provisioning script is provided,
e.g provisioning an argon device just execute:

```./spannerize.sh argon```

and follow the instructions. If troubleshooting, all the particle cli commands 
included in the script can be called directly from the shell, 
e.g `particle identify` to get the device id.

The provided device id can be used to add the device as a new Testboard in the
Spanner Web UI.
