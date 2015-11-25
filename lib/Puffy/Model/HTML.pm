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

package Puffy::Model::HTML;

use strict;
use warnings;

sub new {
  my ($class, $name, $attr) = @_;
  my $self = {};
  $self->{name} = $name;
  if(defined $attr){
    $self->{attr} = $attr;
  } else {
    $self->{attr} = {};
  }
  bless $self, $class;
	$self->__initialize();
	return $self;
}

sub open {
  my $self = shift;
  print "<$self->{name} ";
  while (my ($key, $value) = each %{$self->{attr}}){
    print "$key=$value";
  }
  print ">\n";
}

sub close {
  my $self = shift;
  print "</$self->{name}>\n";
}

sub __initialize {
  my $self = shift;
  my @attrs = ();
  while (my ($key, $value) = each %{$self->{attr}}){
    push @attrs, "$key=$value";
  }
  $self->{open} = "<$self->{name} "."@attrs".">";
  $self->{close} = "</$self->{name}>";
}

1;

