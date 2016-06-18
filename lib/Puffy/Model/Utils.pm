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

package Puffy::Model::Utils;
 
use strict;
use warnings;
use Storable;

sub new { bless {}, shift }

sub getIfs
{
	#my @ifs = split("\n", `doas /sbin/pfctl -s Interface -v`); #only available in 5.8 and later
	my @ifs = split("\n", `/sbin/pfctl -s Interface -v | grep -v "lo"`);
    push(@ifs, 'rdomain');
	return @ifs;
}

sub getProtos
{
	my @protos = split("\n", `cat /etc/protocols | awk '{print \$3}' | grep "^[A-Z]" | sort`);
	return @protos;
}

sub saveConfig {
	my ($self, $data, $file) = @_;
	my $res = store($data, "config/$file");
	return $res;
}

sub getConfig {
	my ($self, $file) = @_;
	my $data = eval { retrieve("config/$file") };
	if($@){
		warn "$file not found!";
	}
	return $data;
}

sub getMedia{
	my ($self, $if) = @_;
	my @tmp = split("\n",`/sbin/ifconfig $if media | grep "media " | awk '{print \$2, \$3, \$4}'`);
	return @tmp;	
}

1;
