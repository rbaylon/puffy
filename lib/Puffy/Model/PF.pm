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

my $SYNTAX = {
	"option" => {
							"set" => { "timeout" => ["timeout","timeout-list"],
											"ruleset-optimization" => ["none","basic","profile"],
											"optimization" => ["default","normal","high-latency","satellite","aggressive","conservative"],
											"limit" => ["limit-item","limit-list"],
											"loginterface" => ["interface-name","none"],
											"block-policy" => ["drop","return"],
											"state-policy" => ["if-bound","floating"],
											"state-defaults" => "state-opts",
											"fingerprints" => "filename",
											"skip on" => "ifspec",
											"debug" => ["none","urgent","misc","loud"],
											"reassemble" => ["yes","no","yes no-df","no no-df"]
										}
						},
	"timeout" => { opt => [
									"tcp.first","tcp.opening","tcp.established","tcp.closing","tcp.finwait","tcp.closed","udp.first","udp.single",
                	"udp.multiple","icmp.first","icmp.error","other.first","other.single","other.multiple","frag","interval","src.track",
                	"adaptive.start","adaptive.end"
               		],
							 	arg => "int" 
							},
							
	"limit-item" => { opt => ["states","frags","src-nodes","tables","table-entries"],
										arg => "int"
									},
	"interface-name" => \@ifs,
	"state-opts" => "state-opt",
	"state-opt" => [
									{"max" => "int"},"no-sync","timeout","sloppy","pflow",{"source-track" => ["rule","global"]},{"max-src-nodes" => "int"},
									{"max-src-states" => "int"},{"max-src-conn" => "int"},{"max-src-conn-rate" => "int/int"},{"overload" => ["< string >","flush","flush global"]},
									"if-bound","floating"
								],
	"ifspec" => "interface-name",
	
};

sub new { bless {}, shift }
