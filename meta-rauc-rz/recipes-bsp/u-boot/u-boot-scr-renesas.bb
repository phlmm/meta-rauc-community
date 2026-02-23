FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SUMMARY = "U-boot RAUC bootscript for Renesas RZ/V2H"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "u-boot-mkimage-native"
SRC_URI = "file://boot.cmd"

inherit deploy

# This ensures the script is included in the rootfs package
FILES:${PN} += "/boot/boot.scr"

do_compile() {
    cp ${UNPACKDIR}/boot.cmd ${B}/boot.scr
    #mkimage -A arm64 -T script -C none -n "RAUC Boot Script" -d "${UNPACKDIR}/boot.cmd" boot.scr
}

do_install() {
    install -d ${D}/boot
    install -m 0644 boot.scr ${D}/boot/boot.scr
}

do_deploy() {
    install -d ${DEPLOYDIR}
    install -m 0644 boot.scr ${DEPLOYDIR}/boot.scr
}

addtask deploy after do_compile before do_build
