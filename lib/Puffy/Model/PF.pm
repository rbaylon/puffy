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
		"set" => { 
			"type" => "literal",
			"timeout" => {
				"type" => "literal",
				"opt-type" => "key",
				"opts" => ["timeout","timeout-list"],
			},
			"ruleset-optimization" => {
				"type" => "literal",
				"opt-type" => "select",
				"opts" => ["none","basic","profile"]
			},
			"optimization" => {
        "type" => "literal",
        "opt-type" => "select",
				"opts" => ["default","normal","high-latency","satellite","aggressive","conservative"]
			},
			"limit" => {
        "type" => "literal",
        "opt-type" => "key",
				"opts" => ["limit-item","limit-list"]
			},
			"loginterface" => {
				"type" => "literal",
				"opt-type" => "select",
				"opts" => ["interface-name","none"]
			},
			"block-policy" => {
				type => "literal",
				"opt-type" => "select",
				opts => ["drop","return"]
			},
			"state-policy" => {
        type => "literal",
        "opt-type" => "select",
				opts => ["if-bound","floating"]
			},
			"state-defaults" => {
				type => "literal",
				"opt-type" => "key",
				opts => "state-opts"
			},
			"fingerprints" => {
				type => "literal",
				"opt-type" => "filename",
				opts => "path-to-file"
			},
			"skip on" => {
				type => "literal",
				"opt-type" => "key",	
				opts => "ifspec"
			},
			"debug" => {
				type => "literal",
				"opt-type" => "select",
				opts => ["none","urgent","misc","loud"]
			},
			"reassemble" => ["yes","no","yes no-df","no no-df"]
		}
	},
	"timeout" => { 
		type => "key",
		"opt-type" => "multi-select",
		opts => [
		"tcp.first","tcp.opening","tcp.established","tcp.closing","tcp.finwait","tcp.closed","udp.first","udp.single",
		"udp.multiple","icmp.first","icmp.error","other.first","other.single","other.multiple","frag","interval","src.track",
		"adaptive.start","adaptive.end"
		],
		arg => "int"
	},
	"limit-item" => {
		type => "key",
    "opt-type" => "multi-select",
		opts => ["states","frags","src-nodes","tables","table-entries"],
		arg => "int"
	},
	"interface-name" => {
		type => "key",
		"opt-type" => "select",
		opts => \@ifs
	},
	"state-opts" => {
		type => "key",
		"opt-type" => "key-multi-select",
		opts => "state-opt"
	},
	"state-opt" => {
		type => "key",
		"opt-type" => "multi-select",
		opts => [
			{"max" => { type => "literal", "opt-type" => "none", arg => "int" } },
			"no-sync",
			{ "timeout" => { type => "key" } },
			"sloppy",
			"pflow",
			{"source-track" => { type => "literal", "opt-type" => "select", opts => ["rule","global"]} },
			{"max-src-nodes" => { type => "literal", "opt-type" => "none", arg => "int" } },
			{"max-src-states" => { type => "literal", "opt-type" => "none", arg => "int" } },
			{"max-src-conn" => { type => "literal", "opt-type" => "none", arg => "int" } },
			{"max-src-conn-rate" => { type => "literal", "opt-type" => "none", arg => "int/int" } },
			{"overload" => { type => "literal-with-name", "opt-type" => "select", opts => ["flush","flush global"]} },
			"if-bound",
			"floating"
			]
		},
	"ifspec" => {
		type => "key",
		"opt-type" => "key-multi-select-w-negate",
		opts => "interface-name"
	},
};

sub new { bless {}, shift }
