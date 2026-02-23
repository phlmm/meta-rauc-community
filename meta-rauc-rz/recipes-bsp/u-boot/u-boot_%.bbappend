FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://rzv2h-dev.env \
            file://rauc.cfg \
            file://fw_env.config \
            file://0001-Add-ifndef-guard-for-CONFIG_BOOTCOMMAND-to-avoid-red.patch \
            "

do_compile:prepend() {
    cp ${UNPACKDIR}/rzv2h-dev.env ${S}/board/renesas/rzv2h-dev/rzv2h-dev.env
}

do_install:append() {
    install -d ${D}/${sysconfdir}
    install -m 0644 ${UNPACKDIR}/fw_env.config ${D}/${sysconfdir}/fw_env.config
}

do_deploy:append() {
    install -d ${DEPLOYDIR}
    install -m 0644 ${S}/board/renesas/rzv2h-dev/rzv2h-dev.env ${DEPLOYDIR}/u-boot.env
}
