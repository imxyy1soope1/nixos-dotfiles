{ lib, ... }:
let
  # T400
  gpuIDs = [
    "8086:56a0" # A770
    "8086:4f90"

    "10de:1f82" # 1650
    "10de:10fa"

    "10de:1fb2" # T400
  ];
in
{
  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];
    kernelParams = [
      "pcie_acs_override=downstream,multifunction"
      "amd_iommu=on"
      "vfio-pci.ids=${lib.concatStringsSep "," gpuIDs}"
    ];
    extraModprobeConfig = ''
      options kvm ignore_msrs=Y
      options kvm report_ignored_msrs=N
    '';
  };
  virtualisation.spiceUSBRedirection.enable = true;
  my.virt.enable = true;
}
