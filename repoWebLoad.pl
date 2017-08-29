#!/usr/bin/perl -w
# $Id: $
# $Date: $
#
# repoWebLoad.pl
# Copy our FIE rpms to the webserver
use strict;
use File::Copy;

my $debug = 0;
my $BASE_DIR = "/var/www/html/software";

# RPMS source directory
my $dir = $ARGV[0];
if (not defined $dir) {
	$dir = $ENV{"HOME"} . "/rpmbuild/RPMS";
	print "RPM source directory [$dir]: ";
	my $ans = <STDIN>;
	chomp $ans;
	if ($ans ne "") {
		$dir = $ans;
	}
}

-d $dir or die "rpmbuild directory does not exist";
my $basedir = $dir;

# Push rpms to web server
foreach my $subdir ("i386","x86_64","noarch") {
	$dir = $basedir . "/" . $subdir;
	if (-d $dir) { 
		$debug && print "$dir\n";
		opendir(DIR, "$dir") or warn "Can't open $dir";
		while (my $file = readdir(DIR)) {
			$file =~ /^give_zdiv-/ or next;
			-d $dir or die "missing destination directory";

			foreach my $net ("gs","jwics","hal") {
				foreach my $ver ("6","7") {
					my $dest = $BASE_DIR . "/" . $net . "/centos/${ver}/noarch";
					$debug && print "install -m 644 $dir/$file $dest/$file\n";
					`install -m 644 $dir/$file $dest/$file`;
				}

				foreach my $ver ("6","7Server","7Workstation") {
					my $dest = $BASE_DIR . "/" . $net . "/redhat/${ver}/noarch";
					$debug && print "install -m 644 $dir/$file $dest/$file\n";
					`install -m 644 $dir/$file $dest/$file`;
				}
			}
		}
		close DIR;
	}
}

