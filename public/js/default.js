/*
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
*/

var counter = 1;
var limit = 50;
var interface_ids = ['inet','netmask','inet6','prefix','alias'];
function addInput(parentId,elemName,varName,inputType){
	if (counter == limit)  {
		alert("You have reached the limit of adding " + counter + " addresses");
  }
  else {
		var newelem = document.createElement(elemName);
		newelem.id = counter;
    newelem.innerHTML = "<"+ elemName +" class='dynElem' ><input id='alias"+counter+"' class='inputs' type='"+ inputType +"' name='"+varName+"' ><img class='icon' src='/img/icons/ic_clear_black_24dp_2x.png' alt='Remove' height='16' width='16' onclick='delElem("+counter+");'></"+elemName+">";
    document.getElementById(parentId).appendChild(newelem);
    counter++;
  }
}

function delElem(id){
	document.getElementById(id).remove();
}

function disableClass(className){
	var config_type = document.getElementById('config_type').value;
	var inputs = document.getElementsByClassName(className), item;
	if(config_type == 'DHCP') {
		for (j = 0; j < inputs.length; j++ ) {
			document.getElementById(inputs[j].id).disabled=true;
		}
	}
	else {
    for (j = 0; j < inputs.length; j++ ) {
      document.getElementById(inputs[j].id).disabled=false;
    }
	}
}

function modEvent(action, eventName, id, fcnName){
	if(action == 'add'){
		document.getElementById(id).addEventListener(eventName, fcnName);
	}
	else {
		document.getElementById(id).removeEventListener(eventName, fcnName);
	}
}
