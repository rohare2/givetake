# Makefile
# $ID: $
Name= give
Version= 1.2
Release= 1
BASE= ${shell pwd}

RPMBUILD= ${HOME}/rpmbuild
RPM_BUILD_ROOT= ${RPMBUILD}/BUILDROOT
TARGET_DIR= ${RPMBUILD}/RPMS/noarch
ETC_DIR= /etc
SUDO_DIR= /etc/sudoers.d
BIN_DIR= /usr/bin
DATA_DIR= /usr/local/give

ETC_FILES= give.conf

SUDO_FILES= givetake.sudo

BIN_FILES= give \
	take

rpmbuild: specfile source
	rpmbuild -bb --sign --buildroot ${RPM_BUILD_ROOT} ${RPMBUILD}/SPECS/${Name}-${Version}-${Release}.spec

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
	@if [ ! -d ${RPM_BUILD_ROOT}/${DATA_DIR} ]; then \
		mkdir -m 0700 -p ${RPM_BUILD_ROOT}/${DATA_DIR}; \
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
	@for file in ${BIN_FILES}; do \
		install -p $$file ${BIN_DIR} -o root -g root -m 711; \
	done

uid_chk:
	@if [ `id -u` != 0 ]; then echo You must become root first; exit 1; fi

