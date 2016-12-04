#Importing the necessary module(s)
from netmiko import ConnectHandler
import sys

#User menu
print '\nMake sure you have an username and password and SSHv2 enabled on the device(s)!'

print '\nPlease choose an action:\n\n1 - Send config commands to a single HP device\n2 - Send config commands to multiple HP devices\n3 - Send config commands from a file to a single HP device\n4 - Send config commands from a file to multiple HP devices\n'

user_choice = raw_input('\nEnter your choice: ')

#Defining actions based on user input
if user_choice == '1':
	#Asking the user for input
	ip = raw_input('\nEnter the device IP address: ')

	username = raw_input('\nEnter username for SSHv2 connection: ')

	password = raw_input('\nEnter password for SSHv2 connection: ')
	
	commands = raw_input('\nEnter commands to send separated by comma: ')

	print '\n'
	
	session = ConnectHandler(device_type = 'hp_procurve', ip = ip, username = username, password = password)
	
	session_output = session.send_config_set(commands.split(','))
	
	print "\nDone! Check out %s to see the results.\n" % ip
	
elif user_choice == '2':
	#Asking the user for input
	ip = raw_input('\nEnter the device IP addresses separated by comma: ')

	username = raw_input('\nEnter username for SSHv2 connection: ')

	password = raw_input('\nEnter password for SSHv2 connection: ')
	
	commands = raw_input('\nEnter commands to send separated by comma: ')

	print '\n'
	
	for ip in ip.split(','):
	
		session = ConnectHandler(device_type = 'hp_procurve', ip = ip, username = username, password = password)
		
		session_output = session.send_config_set(commands.split(','))
		
		print "\nDone! Check out %s to see the results.\n" % ip
		
elif user_choice == '3':
	#Asking the user for input
	ip = raw_input('\nEnter the device IP address: ')

	username = raw_input('\nEnter username for SSHv2 connection: ')

	password = raw_input('\nEnter password for SSHv2 connection: ')
	
	commands_file = raw_input('\nEnter the filename. Example: /home/ubuntu/cmd.txt: ')

	print '\n'
	
	session = ConnectHandler(device_type = 'hp_procurve', ip = ip, username = username, password = password)
	
	session_output = session.send_config_from_file(commands_file)
	
	print "\nDone! Check out %s to see the results.\n" % ip
	
elif user_choice == '4':
	#Asking the user for input
	ip = raw_input('\nEnter the device IP addresses separated by comma: ')

	username = raw_input('\nEnter username for SSHv2 connection: ')

	password = raw_input('\nEnter password for SSHv2 connection: ')
	
	commands_file = raw_input('\nEnter the filename. Example: /home/ubuntu/cmd.txt: ')

	print '\n'
	
	for ip in ip.split(','):
	
		session = ConnectHandler(device_type = 'hp_procurve', ip = ip, username = username, password = password)
		
		session_output = session.send_config_from_file(commands_file)
		
		print "\nDone! Check out %s to see the results.\n" % ip
		
else:
	print "\nInvalid input. Exiting...\n"
	sys.exit()
	
#For using this application on other networking vendors, just replace device_type = 'hp_procurve' with any of the following:
#device_type = 'cisco_ios'
#device_type = 'juniper'
#device_type = 'arista_eos'

#End of Program	
