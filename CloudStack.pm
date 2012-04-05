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


package Net::CloudStack;

use 5.006;

use Mouse;
use Mouse::Util::TypeConstraints;
use Digest::SHA qw(hmac_sha1);
use MIME::Base64;
use LWP::UserAgent;
use Encode;
use XML::Twig;
use URI::Encode;
use JSON;
use Carp;

subtype 'CloudStack::YN'
    => as 'Str'
    => where { $_ =~ /^(yes|no)$/ }
=> message { "Please input yes or no" }
;

has 'base_url' => ( #http://localhost:8080
    is => 'rw',
    isa => 'Str',
    required => 1,
    );

has 'api_path' => ( #/client/api?
    is => 'rw',
    isa => 'Str',
    required => 1,
    );

has 'api_key' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    );

has 'secret_key' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    );

has 'url' => (
    is => 'rw',
    isa => 'Str',
    );

has 'response' => (
    is => 'rw',
    isa => 'Str',
    );

__PACKAGE__->meta->make_immutable;
no Mouse;
no Mouse::Util::TypeConstraints;

### FOR TEST ###

sub test{
    my ($self,$opt) = @_;
    my @required = ();

    print "BASE URL:".$self->base_url."\n";
    print "API PATH:".$self->api_path."\n";
    print "OPT:".$opt."\n";
    print "API KEY:".$self->api_key."\n";
    print "SECRET KEY:".$self->secret_key."\n";

    $self->proc($opt, \@required);
}

### For Capacity Check ###

### Host ###
sub listHosts{
	my ($self, $opt, $what, $stype) = @_;
	my @required = ();
	$self->proc($opt, \@required);
	$self->gen_response($what, $stype); 
}	  

### System Capacity ###
sub listCapacity{
	my ($self, $opt, $what, $stype) = @_;
	my @required = ();
	$self->proc($opt, \@required);
	$self->gen_response($what, $stype); 
}	  

### Storage Pool ###
sub listStoragePools{
	my ($self, $opt, $what, $stype) = @_;
	my @required = ();
	$self->proc($opt, \@required);
	$self->gen_response($what, $stype); 	
}


### SUB ROUTINE ###
sub proc{
    my ($self, $opt, $required) = @_;

    if(!defined($opt)){
        $opt = "";
    }
    else{
        $opt =~ s/([\=\&])\s+/$1/g;
        $opt =~ s/\s+([\=\&])/$1/g;
    }

    my $cmd = (caller 1)[3];
    $cmd =~ s/.*:://;

    foreach (@$required){
        croak "$_ is required"  if(!defined($opt) || $opt !~ /[\s\&]*$_\s*\=/);
    }

    $self->gen_url($cmd, $opt);
}


sub gen_url{
    my ($self, $cmd, $opt) = @_;
    my $base_url = $self->base_url;
    my $api_path = $self->api_path;
    my $api_key = $self->api_key;
    my $secret_key = $self->secret_key;
#    my $xml_json = $self->xml_json;
    my $uri = URI::Encode->new();

#step1
    if($opt){
        $cmd .= "&".$opt;
    }
 
    my $query = "command=".$cmd."&apiKey=".$api_key;
    my @list = split(/&/,$query);
    foreach  (@list){
        if(/(.+)\=(.+)/){
            my $field = $1;
            my $value = $uri->encode($2, 1); # encode_reserved option is set to 1
            $_ = $field."=".$value;
        }
    }

#step2
    foreach  (@list){
        $_ = lc($_);
    }
    my $output = join("&",sort @list);

#step3
    my $digest = hmac_sha1($output, $secret_key);
    my $base64_encoded = encode_base64($digest);chomp($base64_encoded);
    my $url_encoded = $uri->encode($base64_encoded, 1); # encode_reserved option is set to 1
    my $url = $base_url."/".$api_path."apikey=".$api_key."&command=".$cmd."&signature=".$url_encoded;
    $self->url("$url");
}

sub gen_response{
    my ($self, $what, $stype) = @_;
	my $val = shift;
    my $ua = LWP::UserAgent->new();
    my $ua_res = $ua->get($self->url);


        my $xml = encode('utf8',$ua_res->decoded_content);#Please Change cp932 for Win.
        my $twig = XML::Twig->new();
        $twig->parse($xml);

		my $root = $twig->root;
		my @nums = $root->children($stype);

			foreach my $num (@nums) {
				$val =  $num->first_child_text($what);
			}
        $self->response("$val");
}

1; # End of Net::CloudStack


