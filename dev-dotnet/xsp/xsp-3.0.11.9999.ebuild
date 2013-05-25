# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/xsp/xsp-2.10.2-r2.ebuild,v 1.4 2012/12/07 04:54:33 phajdan.jr Exp $

EAPI="4"
EGIT_COMMIT="4587438369691b9b3e8415e1f113aa98b57d1fde"

inherit eutils go-mono mono user

PATCHDIR="${FILESDIR}/2.2/"

DESCRIPTION="XSP is a small web server that can host ASP.NET pages"
HOMEPAGE="http://www.mono-project.com/ASP.NET"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

IUSE=""

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}"

src_prepare() {
	AT_M4DIR="build/m4/shamrock build/m4/shave" AM_OPTS="--force" \
		NOCONFIGURE="yes" eautoreconf
}

#src_configure() {
#	default
#}

pkg_preinst() {
	enewgroup aspnet
	# Give aspnet home dir of /tmp since it must create ~/.wapi
	enewuser aspnet -1 -1 /tmp aspnet
}

src_install() {
	mv_command="cp -ar" go-mono_src_install
	newinitd "${PATCHDIR}"/xsp.initd xsp
	newinitd "${PATCHDIR}"/mod-mono-server-r1.initd mod-mono-server
	newconfd "${PATCHDIR}"/xsp.confd xsp
	newconfd "${PATCHDIR}"/mod-mono-server.confd mod-mono-server

	keepdir /var/run/aspnet
}

pkg_postinst() {
	chown aspnet:aspnet /var/run/aspnet
}
