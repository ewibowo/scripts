#Importing the necessary module.
from trigger.cmds import Commando

#Asking the user for input.
devices = raw_input('\nEnter devices separated by comma: ')
commands = raw_input('\nEnter commands separated by comma: ')

#Splitting the devices/commands entered by the user.
devices_list = devices.split(',')
commands_list = commands.split(',')

#Running all given commands on all given devices. 
cmd = Commando(devices = devices_list, commands = commands_list, force_cli = True, creds = ('mihai1', 'python1', 'juniper'))

#Executing all the work in real time.
cmd.run()

#Capturing the results as a dictionary of dictionaries.
#Uncomment 'print result', then save and run the script...
#...to see how Commando returns the results initially.
output = cmd.results
#print output

#Using a while loop to allow the user to return and choose another cXdY combination.
while True:
	#Asking the user about the output he wants to obtain.
	print '\nNOTE! The format is always cXdY, where X is the command number and Y is the device number in the lists you enter.\nIf X = a this means that command Y will be executed on ALL devices.\nIf Y = a this means that all commands will be executed on device X.\nIf both X = a and Y = a then all the commands will be executed on all devices.'
	
	user_option_1 = raw_input('\nNow, what do you want to see? Example: To get the output of command 2 on device 1 just type c2d1: ')

	#Identifying the desired command(s) and device(s), based on the user input above.
	#Also addressing the cases where the user wants to run a command on all devices...
	#...in the list OR run all the commands in the list on a single device.

	#Now if the user types 'cad1' for example.
	if user_option_1[1] == 'a' and user_option_1[3] != 'a':
		user_option_device = int(user_option_1[3])
		all_outputs_list = []
		for command in commands_list:
			cmd_output = output[devices_list[user_option_device - 1]][command]
			#Adding hostname before the result
			all_outputs_list.append('Device: ' + devices_list[user_option_device - 1] + ' - Command #' + str(commands_list.index(command) + 1) + ':\n\n' + cmd_output)
		final_result = '\r\n'.join(all_outputs_list)

	#Now if the user types 'c1da' for example.
	elif user_option_1[1] != 'a' and user_option_1[3] == 'a':
		user_option_command = int(user_option_1[1])
		all_outputs_list = []
		for device in devices_list:
			cmd_output = output[device][commands_list[user_option_command - 1]]
			#Adding hostname before the result
			all_outputs_list.append('Device: ' + device + '\n\n' + cmd_output)
		final_result = '\r\n'.join(all_outputs_list)
	
	#Now if the user types 'cada' for example, meaning execute all commands on all devices.
	elif user_option_1[1] == 'a' and user_option_1[3] == 'a':
		all_outputs_list = []
		for device in devices_list:
			for command in commands_list:
				all_outputs_list.append('Device: ' + device + ' - Command #' + str(commands_list.index(command) + 1) + ':\n\n' + output[device][command])
		final_result = '\r\n'.join(all_outputs_list)

	#Finally, if the user types 'c2d1' for example.
	else:
		user_option_device = int(user_option_1[3])
		user_option_command = int(user_option_1[1])
		#Adding hostname before the result
		final_result = 'Device: ' + devices_list[user_option_device - 1] + '\n\n' + output[devices_list[user_option_device - 1]][commands_list[user_option_command - 1]]

	#Print to screen or save to file?
	user_option_2 = raw_input('\nOk, all done! Press "p" to print the result to the screen. Press "s" to save it to a file. (p/s) ')

	#Taking action based on user input.
	if user_option_2 == 'p':
		#Printing the output to the screen.
		print '\n'
		print final_result
		
		back = raw_input('\nGo back and choose another cXdY combination? (y/n) ')
		
		if back == 'y':
			continue
		else:
			break
			
	elif user_option_2 == 's':
		#Asking the user for the file name.
		filename = raw_input('\nPlease name your file. Example: /home/ubuntu/c2d1.txt: ')

		#Printing the output to a text file.

		with open(filename, 'w') as f:
			f.write(final_result)

		print "\nDone! Check out %s to see the results.\n" % filename
		
		back = raw_input('\nGo back and choose another cXdY combination? (y/n) ')
		
		if back == 'y':
			continue
		else:
			break

#End Of Program
