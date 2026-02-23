rauc_logic=if test "${board_name}" = "rzv2h-dev"; then setenv fdt_file r9a09g057h4-dev.dtb; \
elif test "${board_name}" = "rzv2h-evk-alpha"; then setenv fdt_file r9a09g057h4-evk-alpha.dtb; \
else setenv fdt_file r9a09g057h44-rzv2h-evk.dtb; fi; \
setenv bootpart; setenv raucslot; \
for BOOT_SLOT in "${BOOT_ORDER}"; do \
  if test -n "${bootpart}"; then true; \
  elif test "${BOOT_SLOT}" = "A" && itest ${BOOT_A_LEFT} -gt 0; then \
    setexpr BOOT_A_LEFT ${BOOT_A_LEFT} - 1; setenv raucslot "A"; \
    setenv bootpart "/dev/mmcblk0p2"; setenv BOOT_DEV "0:2"; \
  elif test "${BOOT_SLOT}" = "B" && itest ${BOOT_B_LEFT} -gt 0; then \
    setexpr BOOT_B_LEFT ${BOOT_B_LEFT} - 1; setenv raucslot "B"; \
    setenv bootpart "/dev/mmcblk0p3"; setenv BOOT_DEV "0:3"; \
  fi; \
done; \
if test -n "${bootpart}"; then \
  setenv bootargs "rw rootwait earlycon root=${bootpart} rauc.slot=${raucslot}"; \
  saveenv; \
  echo "RAUC: Booting Slot ${raucslot} from MMC ${BOOT_DEV}..."; \
  ext4load mmc ${BOOT_DEV} ${kernel_addr_r} /boot/Image; \
  ext4load mmc ${BOOT_DEV} ${fdt_addr_r} /boot/${fdt_file}; \
  booti ${kernel_addr_r} - ${fdt_addr_r}; \
else \
  echo "RAUC: No valid slots! Resetting..."; \
  setenv BOOT_A_LEFT 3; setenv BOOT_B_LEFT 3; saveenv; reset; \
fi
