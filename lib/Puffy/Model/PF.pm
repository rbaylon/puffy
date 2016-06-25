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

package Puffy::Model::PF;
my $utils = Puffy::Model::Utils->new();

use strict;
use warnings;

my @ifs = $utils->getIfs();
my @actions = ('PASS', 'MATCH', 'BLOCK', 'BLOCK RETURN', 'BLOCK RETURN-RST', 'BLOCK RETURN-ICMP', 'BLOCK RETURN-ICMP6');
my @direction = ('ANY','IN', 'OUT');
my @af = ('ANY','INET', 'INET6');
my @srctype = ('Any', 'Single Host', 'Host Range', 'Network Block', 'Macro', 'Interface', 'No Route', 'Route', 'Self', 'Table','Urpf-failed','Hostname');
my @dsttype = @srctype;
my @protos = ('ANY','TCP','UDP','ICMP','IP-ENCAP','GRE','IPSEC-AH','IPSEC-ESP','IPV6-ICMP','OSPFIGP','ETHERIP','CARP','L2TP','PFSYNC','OTHER');
my @os = $utils->getOS();

sub new { 
	my $class = shift;
	my $self = {};
	$self->{actions} = \@actions;
	$self->{ifs} = \@ifs;
	$self->{direction} = \@direction;
	$self->{af} = \@af;
	$self->{protos} = \@protos;
	$self->{srctype} = \@srctype;
    $self->{dsttype} = \@dsttype;
	$self->{os} = \@os;
	bless $self, $class;
}

1;

