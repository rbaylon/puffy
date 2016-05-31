# Copyright (c) 2015, Ricardo Baylon Jr.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the 
# documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
# SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

package Puffy::Controller::Interface;
use Mojo::Base 'Mojolicious::Controller';
use Puffy::Model::Validate;
use Puffy::Model::Utils;
use Switch;

my $utils = Puffy::Model::Utils->new();
my $validator = Puffy::Model::Validate->new();

# This action will render a template
sub interface {
  my $self = shift;
  ## Utils subroutine
  my @ifs = $utils->getIfs();
  $self->stash(ifs => \@ifs);
  my $if = $self->param('if');
  my $page = 'Interface';
  my @media = ();
  my $localmsg = "Configuration successfully saved!";
	
  if($self->req->method eq 'POST'){
		my $testnet =  qq{
                  From RFC 3330: 192.0.2.0/24 - This block is assigned as "TEST-NET" for use in
                  documentation and example code.  It is often used in conjunction with
                  domain names example.com or example.net in vendor and protocol
                  documentation.  Addresses within this block should not appear on the
                  public Internet.
                };
		my $flashmode = 'success';
		my $ok = 1;
		my $cf;
		if($self->param('config_type') eq 'Static'){
            my $ip4_addr = 1;
            my $ip6_addr = 1;
			$cf = {
				config_type => $self->param('config_type'),
				description => $self->param('description'),
				inet => $self->param('inet'),
				netmask => $self->param('netmask'),
				inet6 => $self->param('inet6'),
				prefix =>	$self->param('prefix'),
				media => $self->param('media'),
				alias => $self->every_param('alias')
			};
			while(my ($key, $value) = each(%{$cf})){
				switch($key){
					case 'inet' { 
						if($validator->is_ipv4($value)){
							if($validator->is_testnet_ipv4($value)){
								$localmsg = "($value) $testnet";
								$ok = 0;
								$flashmode = 'error';
								last;
							}
						} else {
                            if($value){
                                $localmsg = "$value is not a valid IPv4 address!";	
                                $ok = 0;
                                $flashmode = 'error';
                                last;
                            } else {
                                $ip4_addr = 0;
                            }
						}
					}
					case 'inet6' {
						if($validator->is_ipv6($value)){
							next;
						} else {
                            if($value){
                                $localmsg = "$value is not a valid IPv6 address!";
                                $ok = 0;
                                $flashmode = 'error';
                                last;
                            } else {
                                $ip6_addr = 0;
                            }
						}
					}
					case 'alias' {
						my $last = 0;
						my $next = 0;
						for my $ip(@{$value}){
							next unless $ip;
                            if($validator->is_ipv4($ip)){
                                if($validator->is_testnet_ipv4($ip)){
                                    $localmsg = "($ip) $testnet";
                                    $ok = 0;
                                    $flashmode = 'error';
									$last = 1;
                                    last;
                                } else {
									next;
								}
                            } elsif($validator->is_ipv6($ip)){
                                next;
							} else {
                                $localmsg = "$ip is not a valid IPv4 or IPv6 alias!";
                                $ok = 0;
                                $flashmode = 'error';
								$last = 1;
                                last;
                            }
						}
						last if $last;
					}
					case 'description' {
						if($validator->is_descr($value)){
							next;
						} else {
                            $localmsg = "\"$value\" should be less than 51 characters!";
                            $ok = 0;
                            $flashmode = 'error';
                            last;						
						}				
					}
				}
			}
            if(!($ip4_addr || $ip6_addr)){
                $localmsg = "Enter a valid IPv4 or IPv6 address!";
                $ok = 0;
                $flashmode = 'error';
            }
		}
		else {
			my @alias = ('');
            $cf = {
                config_type => $self->param('config_type'),
                description => $self->param('description'),
                inet => '',
                netmask => 24,
                inet6 => '',
                prefix => 64,
                media => $self->param('media'),
                alias => \@alias
            };
            
            if(!$validator->is_descr($self->param('description'))){
                $localmsg = $self->param('description')." should be less than 51 characters!";
                $ok = 0;
                $flashmode = 'error';
            }
		}
		if($ok){
			$utils->saveConfig($cf, "hostname.$if");
			push @{$self->config->{'pending'}}, "hostname.$if";
		}
		$self->flash(localmsg => $localmsg, mode => $flashmode);
		$self->redirect_to('/interface?if='.$if);
	} 
	else {
		if ( grep( /^$if$/, @ifs ) ) {
			@media = $utils->getMedia($if);
			my $config = $utils->getConfig("hostname.$if");
	 		$self->stash(if => $if);
			$self->stash(c => $config);
			$self->stash(media => \@media);
        } else {
            $self->stash(if => '');
			$self->stash(media => \@media);
			$page = $page."s";
        }
		$self->render(msg => $page);
	}	
}

1;
