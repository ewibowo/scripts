#Importing the necessary modules
import difflib
import datetime
import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from trigger.netdevices import NetDevices
from netmiko import ConnectHandler



#Defining the function for extracting the running config and building the diff_file, report and master_report files.
def diff_function(device_type, vendor, username, password, command):

	#Using Netmiko to connect to the device and extract the running configuration
	session = ConnectHandler(device_type = device_type, ip = each_device, username = username, password = password, global_delay_factor = 5)
	session_output = session.send_command(command)
	cmd_output = session_output

	#Defining the file from yesterday, for comparison.
	device_cfg_old = 'cfgfiles/' + vendor + '/' + vendor + '_' + each_device + '_' + (datetime.date.today() - datetime.timedelta(days=1)).isoformat()

	#Writing the command output to a file for today.
	with open('cfgfiles/' + vendor + '/' + vendor + '_' + each_device + '_' + datetime.date.today().isoformat(), 'w') as device_cfg_new:
		if vendor == 'arista':
			device_cfg_new.write(cmd_output + '\n')
		else:
			device_cfg_new.write(cmd_output)

	#Defining the differences file as diff_file + the current date and time.
	diff_file_date = 'cfgfiles/' + vendor + '/diff_file_' + each_device + '_' + datetime.date.today().isoformat()

	#The same for the final report file.
	report_file_date = 'cfgfiles/' + vendor + '/report_' + each_device + '_' + datetime.date.today().isoformat()

	#Opening the old config file, the new config file for reading and a new file to write the differences.
	with open(device_cfg_old, 'r') as old_file, open('cfgfiles/' + vendor + '/' + vendor + '_' + each_device + '_' + datetime.date.today().isoformat(), 'r') as new_file, open(diff_file_date, 'w') as diff_file:
		#Using the ndiff() method to read the differences.
		diff = difflib.ndiff(old_file.readlines(), new_file.readlines())
		#Writing the differences to the new file.
		diff_file.write(''.join(list(diff)))

	#Opening the new file, reading each line and creating a list where each element is a line in the file.
	with open(str(diff_file_date), 'r') as diff_file:
		#Creating the list of lines.
		diff_list = diff_file.readlines()
		#print diff_list

	#Interating over the list and extracting the differences by type. Writing all the differences to the report file.
	#Using try/except to catch and ignore any IndexError exceptions that might occur.
	try:
		with open(str(report_file_date), 'a') as report_file:
			for index, line in enumerate(diff_list):
				if line.startswith('- ') and diff_list[index + 1].startswith(('?', '+')) == False:
					report_file.write('\nWas in old version, not there anymore: ' + '\n\n' + line + '\n-------\n\n')
				elif line.startswith('+ ') and diff_list[index + 1].startswith('?') == False:
					report_file.write('\nWas not in old version, is there now: ' + '\n\n' + '...\n' + diff_list[index - 2] + diff_list[index - 1] + line + '...\n' + '\n-------\n')
				elif line.startswith('- ') and diff_list[index + 1].startswith('?') and diff_list[index + 2].startswith('+ ') and diff_list[index + 3].startswith('?'):
					report_file.write('\nChange detected here: \n\n' + line + diff_list[index + 1] + diff_list[index + 2] + diff_list[index + 3] + '\n-------\n')
				elif line.startswith('- ') and diff_list[index + 1].startswith('+') and diff_list[index + 2].startswith('? '):
					report_file.write('\nChange detected here: \n\n' + line + diff_list[index + 1] + diff_list[index + 2] + '\n-------\n')
				else:
					pass

	except IndexError:
		pass

	#Reading the report file and writing to the master file.
	with open(str(report_file_date), 'r') as report_file, open('cfgfiles/master_report_' + datetime.date.today().isoformat() + '.txt', 'a') as master_report:
		if len(report_file.readlines()) < 1:
			#Adding device as first line in report.
			master_report.write('\n\n*** Device: ' + each_device + ' ***\n')
			master_report.write('\n' + 'No Configuration Changes Recorded On ' + datetime.datetime.now().isoformat() + '\n\n\n')
		else:
			#Appending the content to the master report file.
			report_file.seek(0)
			master_report.write('\n\n*** Device: ' + each_device + ' ***\n\n')
			master_report.write(report_file.read())



#Defining the list of devices to monitor. These are my Cisco 2691 / Juniper SRX100H / Arista vEOS devices. Replace with your own.
devices = ['172.16.1.2', '172.16.1.100', '172.16.1.101']



#Extracting the running config to a file, depending on the device vendor (Cisco, Juniper or Arista).
for each_device in devices:
	lab = NetDevices()
	device = lab.find(each_device)

	#Using Trigger to check for the device vendor.
	if str(device.vendor) == 'cisco':
		diff_function('cisco_ios', 'cisco', 'mihai', 'python', 'show running')

	#Using Trigger to check for the device vendor.
	elif str(device.vendor) == 'juniper':
		diff_function('juniper', 'juniper', 'mihai1', 'python1', 'show configuration')

	#Using Trigger to check for the device vendor.
	elif str(device.vendor) == 'arista':
		diff_function('arista_eos', 'arista', 'mihai', 'python', 'show running')

	else:
		print '\nThis device type is not supported, sorry!\n'

#Sending the content of the master report file (/cfgfiles/master_report.txt) via email to the network admin.
#Preparing the email.
fromaddr = 'mihai.python@gmail.com'
toaddr = 'mihai.python@gmail.com'
msg = MIMEMultipart()
msg['From'] = fromaddr
msg['To'] = toaddr
msg['Subject'] = 'Daily Configuration Change Report'

#Checking whether any changes were recorded and building the email body.
with open('cfgfiles/master_report_' + datetime.date.today().isoformat() + '.txt', 'r') as master_report:
	master_report.seek(0)
	body = '\n' + master_report.read() + '\n****************\n\nReport Generated: ' + datetime.datetime.now().isoformat() + '\n\nEnd Of Report\n'
	msg.attach(MIMEText(body, 'plain'))

#Sending the email.
server = smtplib.SMTP('smtp.gmail.com', 587)
server.ehlo()
server.starttls()
server.ehlo()
server.login('mihai.python', 'python123')
text = msg.as_string()
server.sendmail(fromaddr, toaddr, text)



#End Of Program
