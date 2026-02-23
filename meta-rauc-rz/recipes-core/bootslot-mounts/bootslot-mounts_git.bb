FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-3.0-only;md5=c79ff39f19dfec6d293b95dea7b07891"

SRC_URI = "git://github.com/phlmm/bootslot-mounts.git;branch=master;protocol=https \
           file://bootslot-mounts.conf.${MACHINE} \
"

# Modify these as desired
SRCREV = "6470e39c8cb2b21d90ae81f3cb90a3098ec7d88b"
RDEPENDS:${PN} += "systemd"

do_install () {
   install -d ${D}${libdir}/systemd/system-generators/
   install -d ${D}${sysconfdir}
   install -m 0755 ${S}/bootslot-mounts ${D}${libdir}/systemd/system-generators/bootslot-mounts
   install -m 0644 ${UNPACKDIR}/bootslot-mounts.conf.${MACHINE} ${D}${sysconfdir}/bootslot-mounts.conf
}

FILES:${PN} += "${sysconfdir}/* ${libdir}/systemd/system-generators/*"
