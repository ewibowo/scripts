#Importing the necessary module
import AvayaERSConnect

#User menu
print '\nPlease choose an action:\n\n1 - Read command output from a device\n2 - Send config commands from a file to a device\n3 - Send config commands from a file to multiple devices\n'

user_choice = raw_input('\nEnter your choice: ')

#Defining actions based on user input
if user_choice == '1':
	#Asking the user for input
	ip = raw_input('\nEnter the device IP address: ')

	username = raw_input('\nEnter username for Telnet connection: ')

	password = raw_input('\nEnter password for Telnet connection: ')
	
	show_command = raw_input('\nEnter command to send: ')
	
	save = raw_input('\nSave output to file? (y/n) ')
	
	screen = raw_input('\nPrint output to screen? (y/n) ')
	
	if save == 'y':
		to_file = True
	
	elif save == 'n':
		to_file = False
		
	if screen == 'y':
		to_screen = True
	
	elif screen == 'n':
		to_screen = False

	print '\n'
	
	AvayaERSConnect.ReadConfig(ip, username, password, show_command, to_file = to_file, to_screen = to_screen)
	
elif user_choice == '2':
	#Asking the user for input
	ip = raw_input('\nEnter the device IP address: ')
	
	cmd_file = raw_input('\nEnter filename and extension: ')

	username = raw_input('\nEnter username for Telnet connection: ')

	password = raw_input('\nEnter password for Telnet connection: ')
	
	save = raw_input('\nSave config to device NVRAM? (y/n) ')
	
	if save == 'y':
		save_config = True
	
	elif save == 'n':
		save_config = False

	print '\n'
	
	AvayaERSConnect.SendConfig(ip, cmd_file, username, password, save_config = True) 
	
elif user_choice == '3':
	#Asking the user for input
	username = raw_input('\nEnter username for Telnet connection: ')

	password = raw_input('\nEnter password for Telnet connection: ')
	
	save = raw_input('\nSave config to device NVRAM? (y/n) ')
	
	if save == 'y':
		save_config = True
	
	elif save == 'n':
		save_config = False

	print '\n'
	
	AvayaERSConnect.SendConfigToMultiDev(username, password, save_config = True)
	
#End Of Program
