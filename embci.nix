{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rustup
    probe-rs
    openssl
    usbutils
    docker
    docker-compose
    saleae-logic-2
    (python311.withPackages (ppkgs: [
      ppkgs.pytest
      ppkgs.more-itertools
      ppkgs.pyserial
      ppkgs.pyvisa
      ppkgs.pyvisa-py
      # TODO ppkgs.logic2-automation
    ]))
  ];

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "embci" ];

  services.udev.extraRules = ''
    # RND 320-KA3305P Power Supply
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0416", ATTRS{idProduct}=="5011", ACTION=="add", RUN+="${pkgs.coreutils}/bin/rm -f /dev/ttyPowerSupply"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0416", ATTRS{idProduct}=="5011", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/ln `${pkgs.coreutils}/bin/realpath /dev/serial/by-id/usb-Nuvoton_USB_Virtual_COM_00320B0E0454-if00` /dev/ttyPowerSupply'"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0416", ATTRS{idProduct}=="5011", ACTION=="remove", RUN+="${pkgs.coreutils}/bin/rm -f /dev/ttyPowerSupply"

    # Raspberry PI Debug Probes
    #
    # Note that these aren't used at all since `cargo flash` wants a VID:PID:Serial
    # combination to uniquely identify a probe
    SUBSYSTEM=="tty", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="000c", ATTRS{serial}=="E6614103E7826A24", MODE="0666", GROUP="plugdev", SYMLINK="ttyRPI1", TAG+="uaccess"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="000c", ATTRS{serial}=="E6614103E7246F25", MODE="0666", GROUP="plugdev", SYMLINK="ttyRPI2", TAG+="uaccess"

    # Saleae Logic Analyzer
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="0925", ATTR{idProduct}=="3881", MODE="0666"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1001", MODE="0666"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1003", MODE="0666"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1004", MODE="0666"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1005", MODE="0666"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1006", MODE="0666", SYMLINK="ttySaleae"
  '';
}
