FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://data-dir.conf"

do_install:append() {
    install -d ${D}${libdir}/tmpfiles.d
    install -m 0644 ${UNPACKDIR}/data-dir.conf ${D}${libdir}/tmpfiles.d/
}

# Ensure the package includes the new file
FILES:${PN} += "${libdir}/tmpfiles.d/data-dir.conf"
