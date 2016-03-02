# TCL-based simple bitswapping utility
set text(license) {
# Copyright (c) 2010 Cisco Systems, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of Cisco, the name of the copyright holder nor the
#    names of their respective contributors may be used to endorse or
#    promote products derived from this software without specific prior
#    written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#
#
# TECHNICAL ASSISTANCE CENTER (TAC) SUPPORT IS NOT AVAILABLE FOR THIS SCRIPT.
# For questions or comments, send email to bitswapp-feedback@cisco.com.
}

#############
# GUI Code
#############

package require Tk

wm title . "Bitswapping tool - Cisco Systems, Inc - Freely redistributable"

# Basic menu
# ----------
option add *tearOff 0
menu .menubar
set m ".menubar"
. configure -menu $m
menu $m.file
menu $m.help
$m add cascade -menu $m.file -label File
$m add cascade -menu $m.help -label Help
$m.file add command -label "Exit" -command exit
$m.help add command -label "About" -command showAbout
$m.help add command -label "License" -command showLicense

# Text strings used
# -----------------
set text(macaddresses) "MAC Address(es)"
set text(swap) "Swap"
set text(resultsAppear) "Results appear here, showing original on left, new on right"
set text(original) "Original"
set text(new) "New"
set text(error) "Error"
set text(macaddress) "MAC Address"
set text(sixvalues) "does not have 6 hex values"
set text(notvalidformat) "not a valid format"
set text(aboutTitle) "About the bitswapping utility.."
set text(licenseTitle) "License information - BSD variant"
set text(instructions) {
This tool provides a simple mechanism for performing bit swapping on a Hexidecimal MAC address. 

To perform the swap, simply enter a MAC address in the box provided and click the "Swap" button.

Supported formats:
* Without any spaces: 400000000001 
* With dots (aka. cisco): 4000.0000.0001 
* With dashes (aka. Dec): 40-00-00-00-00-01 

Note: You may also enter multiple MAC address values in the accepted formats separated by commas.

Other formats are not currently handled by this utility.

}

set text(about) {
MAC Bitswapping utility, v1.1

Provided by Cisco Systems, Inc.

This utility is a wrapper around a simple Tcl function which reverses byte order in a hexidecimal, regardless of the inherent bye order of the platform.

If you would like to script your own functions, to allow automation of more frequent swaps or perhaps port this capability to another scripting language, the portion
of the code doing the real work is simply:

proc reverseHex hex {
  set binRepH [binary format H* $hex]
  binary scan $binRepH B* binStrBH
  set bin [binary format b* $binStrBH]
  binary scan $bin H2 hex
  return $hex
}

There are plenty of alternate ways to code this, whether in Tcl or other languages, so feel free to experiment.

This application may be freely redistributed, but is provided "as-is" with no warranty of any kind expressed or implied.

Questions, concerns, comments? Email bitswapp-feedback@cisco.com.

- The Cisco Services Team
}


# Main Panel
# ----------

label .instructions -text $text(instructions) -justify left
label .entrylabel -text $text(macaddresses)
set macvalues ""
entry .macaddress -textvariable macvalues -width 30
button .swapbutton -text $text(swap) -command {guiSwap $macvalues} -padx 20
label .blankspace -text "" -pady 10
text .results
.results insert end ($text(resultsAppear))

grid .instructions -row 1 -column 0 -columnspan 3
grid .entrylabel -row 2 -column 0
grid .macaddress -row 2 -column 1
grid .swapbutton -row 2 -column 2
grid .blankspace -row 3 -column 0
grid .results -row 4 -column 0 -columnspan 3

bind .macaddress <Return> {guiSwap $macvalues}



############
# Logic
############

# Tie the MAC swap function to the GUI
# - Note that this is called from the Tk button's -command property
proc guiSwap {macvalues} {
	global text
	set result ""
	foreach mac [split $macvalues ","] {
		append result "$text(original) : $mac     $text(new) : [doSwap $mac]\n"
	}
	.results delete 1.0 end
	.results insert end $result
}

# Display "About" information
proc showAbout {} {
	global text
	tk_messageBox -message $text(about) -title $text(aboutTitle)
}

# Display license information
proc showLicense {} {
	global text
	tk_messageBox -message $text(license) -title $text(licenseTitle)
}


# Simple hex reversal mechanism
# -works regardless of tcl_platform(byteOrder) result, no lookup table required
proc rHex hex {
  set binRepH [binary format H* $hex]
  binary scan $binRepH B* binStrBH
  set bin [binary format b* $binStrBH]
  binary scan $bin H2 hex
  return $hex
}

# Extremely simplistic reversal mechanism
# - Many other cleaner ways to implement
proc doSwap mac {
  global text
  # Remove all "." and "-" characters
  set mac [string trim $mac]
  regsub -all -- "\\." $mac "" mac
  regsub -all -- "-" $mac "" mac
  set newmac ""
  set pairs 0

  if {[string length $mac] != 12} {
	return "$text(error): $text(macaddress) '$mac' $text(sixvalues)"
  }

  # Grab sets of 2 characters, every 2 hex addresses add a "."
  foreach {a b} [split $mac {}] {
	if {$pairs == 2} {
		append newmac "."
		set pairs 0
	}
	if {[catch {rHex $a$b} new]} {
		return "$text(error): $text(macaddress) '$mac' $text(notvalidformat) ($new)"
	} else {
		append newmac $new
		incr pairs
	}
  }
  return [string toupper $newmac]
}



