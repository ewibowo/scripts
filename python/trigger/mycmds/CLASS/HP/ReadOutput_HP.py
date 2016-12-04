#Importing the necessary module(s)
from netmiko import ConnectHandler
import time

#User menu
print '\nPlease choose an action:\n\n1 - Read command output from a single device\n2 - Read command output from multiple devices\n'

user_choice = raw_input('\nEnter your choice: ')

#Defining actions based on user input
if user_choice == '1':
	#Asking the user for input
	ip = raw_input('\nEnter the device IP address: ')

	username = raw_input('\nEnter username for SSHv2 connection: ')

	password = raw_input('\nEnter password for SSHv2 connection: ')
	
	command = raw_input('\nEnter command to send: ')

	print '\n'
	
	session = ConnectHandler(device_type = 'hp_procurve', ip = ip, username = username, password = password)
	
	time.sleep(1)

	session_output = session.send_command(command)
	
	time.sleep(1)
	
	print '\nNow what?\n\n1 - Print the output to the screen\n2 - Save the output to a file\n'

	user_choice = raw_input('\nEnter your choice: ')
	
	if user_choice == '1':
		print session_output
		
	elif user_choice == '2':
		filename = raw_input('\nPlease name your file. Example: /home/ubuntu/hp1.txt: ')

		#Printing the output to a text file.
		with open(filename, 'a') as f:
			f.write(session_output)

		print "\nDone! Check out %s to see the results.\n" % filename
	
elif user_choice == '2':
	#Asking the user for input
	ip = raw_input('\nEnter the device IP addresses separated by comma: ')

	username = raw_input('\nEnter username for SSHv2 connection: ')

	password = raw_input('\nEnter password for SSHv2 connection: ')
	
	command = raw_input('\nEnter command to send: ')

	#Storing the device IP addresses as a list
	dev_list = ip.split(',')
	#print dev_list
	
	print '\nNow what?\n\n1 - Print the output to the screen\n2 - Save the output to a file\n'

	user_choice = raw_input('\nEnter your choice: ')
	
	if user_choice == '1':
		for ip in dev_list:
			#Running the code for each device specified by the user
			session = ConnectHandler(device_type = 'hp_procurve', ip = ip, username = username, password = password)
	
			time.sleep(1)

			session_output = session.send_command(command)
			
			time.sleep(1)
			
			#Printing the output to the screen
			print '\n' + session_output + '\n'
		
	elif user_choice == '2':
		filename = raw_input('\nPlease name your file. Example: /home/ubuntu/hp1.txt: ')
		
		for ip in dev_list:
			#Running the code for each device specified by the user
			session = ConnectHandler(device_type = 'hp_procurve', ip = ip, username = username, password = password)

			time.sleep(1)

			session_output = session.send_command(command)
			
			time.sleep(1)
			
			#Printing the output to a text file.
			with open(filename, 'a') as f:
				f.write('\n' + session_output + '\n')

		print "\nDone! Check out %s to see the results.\n" % filename

#For using this application on other networking vendors, just replace device_type = 'hp_procurve' with any of the following:
#device_type = 'cisco_ios'
#device_type = 'juniper'
#device_type = 'arista_eos'

#End of Program
