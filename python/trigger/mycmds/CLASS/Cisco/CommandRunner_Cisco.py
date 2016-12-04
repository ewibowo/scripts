#Importing the necessary module.
from trigger.contrib.docommand import CommandRunner

#Asking the user for input.
print '\nNOTE! Make sure all files have "configure terminal" or similar at line 1.'
print '\nNOTE! Make sure all devices have remote access enabled and user/pass set.'
	
#IP addresses are verified by Trigger. 
#If an address is not registered in NetDevices you'll get: 'Device not found in NetDevices: 172.16.1.103'.
#If an address is not reachable you'll get: '172.16.1.101 - Error: An error occurred while connecting'.
#If a file is not found in the filesystem you'll get an IOError and we want to catch that exception.
try:
	devices = raw_input('\nEnter devices separated by comma: ')
	cmd_files = raw_input('\nEnter files separated by comma. Example: /home/ubuntu/cmd1.txt: ')

	#Splitting the devices/commands entered by the user.
	devices_list = devices.split(',')
	cmd_files_list = cmd_files.split(',')

	#Running all commands from all the given files on all given devices.
	cmd = CommandRunner(devices = devices_list, files = cmd_files_list)
	
	#Executing all the work in real time.
	cmd.run()

	print '\nCommands executed successfully on all devices.\n'
		
#Raise exception in case one file does not exist. IP addresses are already verified by Trigger.
except IOError, reason:
	print '\nError! Reason: ' + str(reason) + '.\n'
	print 'Please check the file(s) and paths. Redirecting back to prompt...\n'

#End Of Program
