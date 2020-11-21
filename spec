# spec
# $Id$
#
# Author: Rich O'Hare  <rohare2@gmail.com>
#
%define Name givetake
%define Version 1.2
%define Release 2

Name: %{Name}
Version: %{Version}
Release: %{Release}
Source: %{Name}-%{Version}-%{Release}.tgz
License: GPLv2
Group: SystemEnvironment/Base
BuildArch: noarch
URL: https://www.ohares.us
Vendor: DVCAL
Packager: Rich O'Hare <rohare2@gmail.com
Provides: give take
Summary: Secure and convenient file sharing tool
%define _unpackaged_files_terminate_build 0

%description
Provides a convenient means of sharing files without fear of interception.
The Givetake package is composed of two shell scripts (give & take), that
take advantage of sudo in order control access as well as provide encryption.
Un-authorized users can not see or access given files.

The package has been tested on Red Hat/CentOS versions 5 through 7.
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
%config(noreplace) %attr(600, -, -) /etc/give.conf
%attr(440, -, -) /etc/sudoers.d/givetake
%attr(751, -, -) /usr/bin/give
%attr(751, -, -) /usr/bin/take
%dir %attr(700, -, -) /usr/local/give

