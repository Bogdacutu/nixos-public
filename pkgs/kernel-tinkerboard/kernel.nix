{ ... } @ args: import <nixpkgs/pkgs/os-specific/linux/kernel/linux-4.14.nix> (args // rec {
  kernelPatches = [
    { name = "0002-clk-rockchip-add-all-known-operating-points-to-the-a"; patch = ./patches/0002-clk-rockchip-add-all-known-operating-points-to-the-a.patch; }
    { name = "0003-clk-rockchip-rk3288-prefer-vdpu-for-vcodec-clock-sou"; patch = ./patches/0003-clk-rockchip-rk3288-prefer-vdpu-for-vcodec-clock-sou.patch; }
    { name = "0005-Reboot-patch-2-The-Return"; patch = ./patches/0005-Reboot-patch-2-The-Return.patch; }
    { name = "0006-rockchip-rga-v4l2-m2m-support"; patch = ./patches/0006-rockchip-rga-v4l2-m2m-support.patch; }
    { name = "0007-dt-bindings-Document-the-Rockchip-RGA-bindings"; patch = ./patches/0007-dt-bindings-Document-the-Rockchip-RGA-bindings.patch; }
    { name = "DTS/0001-dts-rk3288-miqi-Enabling-the-Mali-GPU-node"; patch = ./patches/DTS/0001-dts-rk3288-miqi-Enabling-the-Mali-GPU-node.patch; }
    { name = "DTS/0002-ARM-dts-rockchip-fix-the-regulator-s-voltage-range-o"; patch = ./patches/DTS/0002-ARM-dts-rockchip-fix-the-regulator-s-voltage-range-o.patch; }
    { name = "DTS/0003-ARM-dts-rockchip-add-the-MiQi-board-s-fan-definition"; patch = ./patches/DTS/0003-ARM-dts-rockchip-add-the-MiQi-board-s-fan-definition.patch; }
    { name = "DTS/0004-ARM-dts-rockchip-add-support-for-1800-MHz-operation-"; patch = ./patches/DTS/0004-ARM-dts-rockchip-add-support-for-1800-MHz-operation-.patch; }
    { name = "DTS/0005-Readapt-ARM-dts-rockchip-miqi-add-turbo-mode-operati"; patch = ./patches/DTS/0005-Readapt-ARM-dts-rockchip-miqi-add-turbo-mode-operati.patch; }
    { name = "DTS/0006-ARM-DTSI-rk3288-Missing-GRF-handles"; patch = ./patches/DTS/0006-ARM-DTSI-rk3288-Missing-GRF-handles.patch; }
    { name = "DTS/0007-RK3288-DTSI-rk3288-Add-missing-SPI2-pinctrl"; patch = ./patches/DTS/0007-RK3288-DTSI-rk3288-Add-missing-SPI2-pinctrl.patch; }
    { name = "DTS/0008-Added-support-for-Tinkerboard-s-SPI-interface"; patch = ./patches/DTS/0008-Added-support-for-Tinkerboard-s-SPI-interface.patch; }
    { name = "DTS/0010-ARM-DTSI-rk3288-Adding-cells-addresses-and-size"; patch = ./patches/DTS/0010-ARM-DTSI-rk3288-Adding-cells-addresses-and-size.patch; }
    { name = "DTS/0011-ARM-DTSI-rk3288-Adding-missing-EDP-power-domain"; patch = ./patches/DTS/0011-ARM-DTSI-rk3288-Adding-missing-EDP-power-domain.patch; }
    { name = "DTS/0012-ARM-DTSI-rk3288-Add-the-RGA-node"; patch = ./patches/DTS/0012-ARM-DTSI-rk3288-Add-the-RGA-node.patch; }
    { name = "DTS/0013-ARM-DTSI-rk3288-Adding-missing-VOPB-registers"; patch = ./patches/DTS/0013-ARM-DTSI-rk3288-Adding-missing-VOPB-registers.patch; }
    { name = "DTS/0014-ARM-DTSI-rk3288-Fixed-the-SPDIF-node-address"; patch = ./patches/DTS/0014-ARM-DTSI-rk3288-Fixed-the-SPDIF-node-address.patch; }
    { name = "DTS/0015-ARM-DTS-rk3288-tinker-Enabling-SDIO-Wireless-and"; patch = ./patches/DTS/0015-ARM-DTS-rk3288-tinker-Enabling-SDIO-Wireless-and.patch; }
    { name = "DTS/0016-ARM-DTS-rk3288-tinker-Improving-the-CPU-max-volt"; patch = ./patches/DTS/0016-ARM-DTS-rk3288-tinker-Improving-the-CPU-max-volt.patch; }
    { name = "DTS/0017-ARM-DTS-rk3288-tinker-Setting-up-the-SD-regulato"; patch = ./patches/DTS/0017-ARM-DTS-rk3288-tinker-Setting-up-the-SD-regulato.patch; }
    { name = "DTS/0018-ARM-DTS-rk3288-tinker-Defined-the-I2C-interfaces"; patch = ./patches/DTS/0018-ARM-DTS-rk3288-tinker-Defined-the-I2C-interfaces.patch; }
    { name = "DTS/0020-ARM-DTS-rk3288-tinker-Defining-the-SPI-interface"; patch = ./patches/DTS/0020-ARM-DTS-rk3288-tinker-Defining-the-SPI-interface.patch; }
    { name = "DTS/0021-ARM-DTS-rk3288-tinker-Defining-SDMMC-properties"; patch = ./patches/DTS/0021-ARM-DTS-rk3288-tinker-Defining-SDMMC-properties.patch; }
    { name = "DTS/0022-ARM-DTSI-rk3288-Define-the-VPU-services"; patch = ./patches/DTS/0022-ARM-DTSI-rk3288-Define-the-VPU-services.patch; }
    { name = "DTS/0023-ARM-DTS-rk3288-miqi-Enable-the-Video-encoding-MM"; patch = ./patches/DTS/0023-ARM-DTS-rk3288-miqi-Enable-the-Video-encoding-MM.patch; }
    { name = "DTS/0024-ARM-DTS-rk3288-tinker-Enable-the-Video-encoding-MMU-"; patch = ./patches/DTS/0024-ARM-DTS-rk3288-tinker-Enable-the-Video-encoding-MMU-.patch; }
    { name = "DTS/0025-ARM-DTSI-rk3288-firefly-Enable-the-Video-encoding-MM"; patch = ./patches/DTS/0025-ARM-DTSI-rk3288-firefly-Enable-the-Video-encoding-MM.patch; }
    { name = "DTS/0026-ARM-DTSI-rk3288-veyron-Enable-the-Video-encoding-MMU"; patch = ./patches/DTS/0026-ARM-DTSI-rk3288-veyron-Enable-the-Video-encoding-MMU.patch; }
  ];
} // (args.argsOverride or {}))
