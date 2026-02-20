# --- 1. Renesas Board Detection & Environment Setup ---
# Set default addresses if not provided by U-Boot env
if test -z "${kernel_addr_r}"; then setenv kernel_addr_r 0x48080000; fi
if test -z "${fdt_addr_r}"; then setenv fdt_addr_r 0x48000000; fi

# Detect MMC Device (SD vs eMMC) based on your board config logic
if test "${board_name}" = "rzv2h-dev"; then
    setenv fdt_file "r9a09g057h4-dev.dtb"
    if mmc dev 2; then setenv rauc_mmc 2; else setenv rauc_mmc 0; fi
elif test "${board_name}" = "rzv2h-evk-alpha"; then
    setenv fdt_file "r9a09g057h4-evk-alpha.dtb"
    if mmc dev 1; then setenv rauc_mmc 1; else setenv rauc_mmc 0; fi
    echo "Configuring PMIC for Alpha..."
    i2c dev 8; i2c mw 0x6a 0x22 0x0f; i2c mw 0x6a 0x24 0x00; i2c mw 0x12 0x8D 0x02
else
    setenv fdt_file "r9a09g057h44-rzv2h-evk.dtb"
    if mmc dev 1; then setenv rauc_mmc 1; else setenv rauc_mmc 0; fi
fi

# --- 2. Integrated RAUC Slot Logic (from RPi4) ---
test -n "${BOOT_ORDER}" || setenv BOOT_ORDER "A B"
test -n "${BOOT_A_LEFT}" || setenv BOOT_A_LEFT 3
test -n "${BOOT_B_LEFT}" || setenv BOOT_B_LEFT 3

setenv bootpart
setenv raucslot

for BOOT_SLOT in "${BOOT_ORDER}"; do
  if test "x${bootpart}" != "x"; then
    true # skip
  elif test "x${BOOT_SLOT}" = "xA"; then
    if itest ${BOOT_A_LEFT} -gt 0; then
      setexpr BOOT_A_LEFT ${BOOT_A_LEFT} - 1
      setenv raucslot "A"
      setenv bootpart "/dev/mmcblk${rauc_mmc}p2"
      setenv BOOT_DEV "${rauc_mmc}:2"
    fi
  elif test "x${BOOT_SLOT}" = "xB"; then
    if itest ${BOOT_B_LEFT} -gt 0; then
      setexpr BOOT_B_LEFT ${BOOT_B_LEFT} - 1
      setenv raucslot "B"
      setenv bootpart "/dev/mmcblk${rauc_mmc}p3"
      setenv BOOT_DEV "${rauc_mmc}:3"
    fi
  fi
done

# --- 3. Finalize Bootargs and Boot ---
if test -n "${bootpart}"; then
  setenv bootargs "rw rootwait earlycon root=${bootpart} rauc.slot=${raucslot}"
  saveenv
else
  echo "No valid RAUC slot found. Resetting..."
  setenv BOOT_A_LEFT 3
  setenv BOOT_B_LEFT 3
  saveenv
  reset
fi

echo "Loading Image and DTB from MMC ${BOOT_DEV}..."
ext4load mmc ${BOOT_DEV} ${kernel_addr_r} boot/Image
ext4load mmc ${BOOT_DEV} ${fdt_addr_r} boot/${fdt_file}

# Execute Boot
booti ${kernel_addr_r} - ${fdt_addr_r}
