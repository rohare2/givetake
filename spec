# $Id$
# $URL: https://www.ohares.us/repos/admin/givetake/spec $
#
# Author: Rich O'Hare  <rohare2@gmail.com>
#
# Give/Take file sharing tools
#
%define Name give_zdiv
%define Version 1.1
%define Release 2

Name: %{Name}
Version: %{Version}
Release: %{Release}
Source: %{Name}-%{Version}-%{Release}.tgz
License: GPLv2
Group: SystemEnvironment/Base
BuildArch: noarch
URL: https://corbin.llnl.gov
Vendor: LLNL
Packager: Rich O'Hare <ohare2@llnl.gov
Provides: give take
Summary: Secure file sharing tools
%define _unpackaged_files_terminate_build 0

%description
Provides a means for sharing files with others without fear of interception.
%conflicts give

%prep
%setup -q -n %{Name}

%build
exit 0

%install
make install
exit 0

%clean
exit 0

%files
%defattr(755, root, root)
%attr(600, -, -) /etc/give.conf
%attr(440, -, -) /etc/sudoers.d/givetake
%attr(755, -, -) /usr/bin/give
%attr(755, -, -) /usr/bin/take

