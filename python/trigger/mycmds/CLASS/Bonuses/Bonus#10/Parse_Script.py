#Importing the necessary modules.
from ciscoconfparse import CiscoConfParse

#Defining the list of configuration files to analyze.
cfg_files = ['cisco_cfg', 'arista_cfg', 'hp_cfg']

#Iterating over the files and capturing the interfaces and their ip addresses.
for cfg_file in cfg_files:
	parse = CiscoConfParse("/tftpboot/" + cfg_file)
	obj = parse.find_objects_w_parents(r'interface ', r'ip address')
	print '\n\n' + cfg_file + '\n'
	for interface in obj:
		print interface.geneology_text[0] + ': ' + interface.geneology_text[1]

#End Of Program
