# Makefile
# $Id$
# $Date$
#
Name= give_zdiv
Version= 1.1
Release= 2
Source= ${Name}-${Version}-${Release}.tgz
BASE= ${shell pwd}

RPMBUILD= ${HOME}/rpmbuild
RPM_BUILD_ROOT= ${RPMBUILD}/BUILDROOT
TARGET_DIR= ${RPMBUILD}/RPMS/noarch

ETC_DIR= /etc
SUDO_DIR= /etc/sudoers.d
BIN_DIR= /usr/bin

ETC_FILES= give.conf

SUDO_FILES= givetake.sudo

BIN_FILES= give \
	take

WEB_BASE= /var/www/html/software

rpmbuild: rpmbuild2 copy2web

rpmbuild2: specfile source
	rpmbuild -bb --buildroot ${RPM_BUILD_ROOT} ${RPMBUILD}/SPECS/${Name}-${Version}-${Release}.spec

specfile: spec
	@cat ./spec > ${RPMBUILD}/SPECS/${Name}-${Version}-${Release}.spec

source:
	if [ ! -d ${RPMBUILD}/SOURCES/${Name} ]; then \
		mkdir ${RPMBUILD}/SOURCES/${Name}; \
	fi
	rsync -av * ${RPMBUILD}/SOURCES/${Name}
	tar czvf ${RPMBUILD}/SOURCES/${Source} --exclude=.git -C ${RPMBUILD}/SOURCES ${Name}
	rm -fr ${RPMBUILD}/SOURCES/${Name}

install: make_path etc sudo bin

make_path:
	@if [ ! -d ${RPM_BUILD_ROOT}/${ETC_DIR} ]; then \
		mkdir -m 0755 -p ${RPM_BUILD_ROOT}/${ETC_DIR}; \
	fi;
	@if [ ! -d ${RPM_BUILD_ROOT}/${SUDO_DIR} ]; then \
		mkdir -m 0750 -p ${RPM_BUILD_ROOT}/${SUDO_DIR}; \
	fi;
	@if [ ! -d ${RPM_BUILD_ROOT}/${BIN_DIR} ]; then \
		mkdir -m 0755 -p ${RPM_BUILD_ROOT}/${BIN_DIR}; \
	fi;

etc:
	@for file in ${ETC_FILES}; do \
		install -p $$file ${RPM_BUILD_ROOT}/${ETC_DIR}; \
	done;

sudo:
	@for file in ${SUDO_FILES}; do \
		install -p $$file ${RPM_BUILD_ROOT}/${SUDO_DIR}/givetake; \
	done;

bin:
	@for file in ${BIN_FILES}; do \
		install -p $$file ${RPM_BUILD_ROOT}/${BIN_DIR}; \
	done;

clean:
	@rm -f ${RPMBUILD}/SPECS/${Name}-${Version}-${Release}.spec
	@rm -fR ${RPMBUILD}/SOURCES/${Source}
	@rm -fR ${RPMBUILD}/BUILD/${Name}
	@rm -fR ${RPMBUILD}/BUILDROOT/*

localinstall: uid_chk
	@for file in ${ETC_FILES}; do \
		install -p $$file ${ETC_DIR} -o root -g root -m 600; \
	done
	@for file in ${SUDO_FILES}; do \
		install -p $$file ${SUDO_DIR}/givetake -o root -g root -m 440; \
	done
	@for file in ${SCRIPT_FILES}; do \
		install -p $$file ${SCRIPT_DIR} -o root -g root -m 755; \
	done

uid_chk:
	@if [ `id -u` != 0 ]; then echo You must become root first; exit 1; fi

copy2web:
	for net in gs hal jwics wnet; do \
		for distro in centos redhat; do \
			for vers in 5 6 7; do \
				cp ${TARGET_DIR}/${Name}-${Version}-${Release}.noarch.rpm ${WEB_BASE}/$$net/$$distro/$$vers/noarch/; \
			done; \
		done; \
	done
