#!/usr/bin/perl
# Copyright 2012 by Diego F. Spinola Castro <spinolacastro@gmail.com>

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307


use Net::CloudStack;
use Data::Dumper;

sub getVals {

my ($opt_h, $opt_f) = @_;
my $api = Net::CloudStack->new(
	base_url        => 'YOUR_CS_SERVER',
	api_path        => 'client/api?',
	api_key         => 'YOUR_API_KEY',
	secret_key      => 'YOUR_SECRET_KEY',
	);


if ($opt_f =~ /hoststate/i) {

	my $what = 'state';
	my $stype = 'host';
	
	$api->listHosts("id=$opt_h", $what, $stype);
#	print $api->response . "\n";
#	print Dumper($api);

	my $vasd = $api->response;
	
	if ($vasd =~ /Up/) {
		$vasd = 1;
	} else {
		$vasd = 0;
	}
	print $vasd . "\n";

} elsif ($opt_f =~ /memalloc/i) {

	my $what = 'memoryallocated';
	my $stype = 'host';
	
	$api->listHosts("id=$opt_h", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_f =~ /cpualloc/i) {

	my $what = 'cpuallocated';
	my $stype = 'host';
	
	$api->listHosts("id=$opt_h", $what, $stype);
	#print $api->response . "\n";

	my $vasd = $api->response;
	$vasd =~ s/\%//g;
	print $vasd . "\n";

} elsif ($opt_f =~ /memtotal/i) {

	my $what = 'memorytotal';
	my $stype = 'host';
	
	$api->listHosts("id=$opt_h", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_f =~ /cpuused/i) {

	my $what = 'cpuused';
	my $stype = 'host';
	
	$api->listHosts("id=$opt_h", $what, $stype);
#	print $api->response . "\n";

	my $vasd = $api->response;
	$vasd =~ s/\%//g;
	print $vasd . "\n";


} elsif ($opt_f =~ /storstate/i) {
	
	my $what = 'state';
	my $stype = 'storagepool';
	
	$api->listStoragePools("id=$opt_h", $what, $stype);
#	print $api->response . "\n";


	my $vasd = $api->response;
	if ($vasd =~ /Up/) {
		$vasd = 1;
	} else {
		$vasd = 0;
	}
	print $vasd . "\n";


} elsif ($opt_f =~ /diskalloc/i) {
	
	my $what = 'disksizeallocated';
	my $stype = 'storagepool';
	
	$api->listStoragePools("id=$opt_h", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_f =~ /disksize/i) {
	
	my $what = 'disksizetotal';
	my $stype = 'storagepool';
	
	$api->listStoragePools("id=$opt_h", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_h =~ /memcapused/i) {
	
	my $what = 'capacityused';
	my $stype = 'capacity';
	
	$api->listCapacity("type=0", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_h =~ /memcaptotal/i) {
	
	my $what = 'capacitytotal';
	my $stype = 'capacity';
	
	$api->listCapacity("type=0", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_h =~ /cpucapused/i) {
	
	my $what = 'capacityused';
	my $stype = 'capacity';
	
	$api->listCapacity("type=1", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_h =~ /cpucaptotal/i) {
	
	my $what = 'capacitytotal';
	my $stype = 'capacity';
	
	$api->listCapacity("type=1", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_h =~ /pstorused/i) {
	
	my $what = 'capacityused';
	my $stype = 'capacity';
	
	$api->listCapacity("type=2", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_h =~ /pstoralloc/i) {
	
	my $what = 'capacityused';
	my $stype = 'capacity';
	
	$api->listCapacity("type=3", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_h =~ /pstortotal/i) {
	
	my $what = 'capacitytotal';
	my $stype = 'capacity';
	
	$api->listCapacity("type=2", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_h =~ /publicipused/i) {
	
	my $what = 'capacityused';
	my $stype = 'capacity';
	
	$api->listCapacity("type=4", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_h =~ /publiciptotal/i) {
	
	my $what = 'capacitytotal';
	my $stype = 'capacity';
	
	$api->listCapacity("type=4", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_h =~ /privipused/i) {
	
	my $what = 'capacityused';
	my $stype = 'capacity';
	
	$api->listCapacity("type=5", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_h =~ /priviptotal/i) {
	
	my $what = 'capacitytotal';
	my $stype = 'capacity';
	
	$api->listCapacity("type=5", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_h =~ /sstorused/i) {
	
	my $what = 'capacityused';
	my $stype = 'capacity';
	
	$api->listCapacity("type=6", $what, $stype);
	print $api->response . "\n";

} elsif ($opt_h =~ /sstortotal/i) {
	
	my $what = 'capacitytotal';
	my $stype = 'capacity';
	
	$api->listCapacity("type=6", $what, $stype);
	print $api->response . "\n";

	}

}
#getopt ('hf');

		getVals($ARGV[1], $ARGV[2]);

