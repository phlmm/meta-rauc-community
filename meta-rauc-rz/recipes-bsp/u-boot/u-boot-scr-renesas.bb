FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SUMMARY = "Standardized RAUC Boot Script for Renesas RZ/V2H"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "u-boot-mkimage-native"
SRC_URI = "file://boot.cmd"

inherit deploy

do_compile() {
    # You can use sed here to replace @@KERNEL_IMAGETYPE@@ if you want to be generic
    mkimage -A arm64 -T script -C none -n "RAUC Boot Script" \
            -d "${WORKDIR}/boot.cmd" "${B}/boot.scr"
}

do_deploy() {
    install -d ${DEPLOYDIR}
    install -m 0644 ${B}/boot.scr ${DEPLOYDIR}/boot.scr
}

addtask deploy after do_compile before do_build
