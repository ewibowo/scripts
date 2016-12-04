import difflib
from ciscoconfparse import CiscoConfParse
from netmiko import ConnectHandler



#Tasks #1, #2 and #3
#Using Netmiko to connect to the device and extract the running configuration.
session = ConnectHandler(device_type = 'cisco_ios', ip = '172.16.1.100', username = 'mihai', password = 'python', global_delay_factor = 3)
session_output = session.send_command('show running-config')
cmd_output = session_output

#Task #4
#Saving the running configuration to a file.
with open('old_config.txt', 'w') as old_config:
	old_config.write(cmd_output)

#Task #5
#Parsing the configuration file and finding all the interfaces.
parse = CiscoConfParse("/home/ubuntu/MyFiles/PROJECT/old_config.txt")
obj = parse.find_objects(r'^interface ')

#Task #6
#Adding a description to each interface in the file.
#Pay special attention to the number of spaces before each child in the configuration file!
for interface in obj:
	interface.append_to_family(' description MyCiscoRouter')

#Printing the new configuration to a new file.
new_config_list = []
for line in parse.ioscfg:
	new_config_list.append(line)

#Joining all the elements of the list into a string and writing the string to the new file.
with open('new_config.txt', 'w') as new_config:
	new_config.write('\n'.join(new_config_list))

#Task #7
#Comparing the old and new configuration files and creating the diff_file and report files.
#Writing the interface description differences to the report file.
with open('old_config.txt', 'r') as old_file, open('new_config.txt', 'r') as new_file, open('report.txt', 'w') as report:
	#Using the ndiff() method to read the differences.
	diff = difflib.ndiff(old_file.readlines(), new_file.readlines())
	for index, line in enumerate(diff):
		if line.startswith('+ ') and ('description' in line):
			report.write('New line was found: ' + line + '\n')

#End Of Program
