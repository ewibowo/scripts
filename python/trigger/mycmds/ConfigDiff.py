#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python2.7

# Importing the necessary modules
import difflib
import datetime
import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from trigger.netdevices import NetDevices
from netmiko import ConnectHandler



# Defining the function for extracting the running config and building the diff_file, report and master_report files.
def diff_function(device_type, vendor, username, password, command):

    # Using Netmiko to connect to the device and extract the running configuration
    session = ConnectHandler(device_type=device_type, ip=each_device, username=username, password=password, global_delay_factor=5)
    session_output = session.send_command(command)
    cmd_output = session_output

    # Defining the file from yesterday, for comparison.
    device_cfg_old = 'cfgfiles/' + vendor + '/' + vendor + '_' + each_device + '_' + (datetime.date.today() - datetime.timedelta(days=1)).isoformat()

    # Writing the command output to a file for today.
    with open('cfgfiles/' + vendor + '/' + vendor + '_' + each_device + '_' + datetime.date.today().isoformat(), 'w') as device_cfg_new:
        if vendor == 'arista':
            device_cfg_new.write(cmd_output + '\n')
        else:
            device_cfg_new.write(cmd_output)

    # Defining the differences file as diff_file + the current date and time.
    diff_file_date = 'cfgfiles/' + vendor + '/diff_file_' + each_device + '_' + datetime.date.today().isoformat()

    # The same for the final report file.
    report_file_date = 'cfgfiles/' + vendor + '/report_' + each_device + '_' + datetime.date.today().isoformat()

    # The same for the log file.
    log_file_date = 'cfgfiles/' + vendor + '/log_' + each_device + '_' + datetime.date.today().isoformat()

    # Opening the old config file, the new config file for reading and a new file to write the differences.
    with open(device_cfg_old, 'r') as old_file, \
        open('cfgfiles/' + vendor + '/' + vendor + '_' + each_device + '_' + datetime.date.today().isoformat(), 'r') as new_file, \
        open(diff_file_date, 'w') as diff_file:

        # Using the ndiff() method to read the differences.
        diff = difflib.ndiff(old_file.readlines(), new_file.readlines())
        # Writing the differences to the new file.
        diff_file.write(''.join(list(diff)))

        # Opening the new file, reading each line and creating a list where each element is a line in the file.
    with open(str(diff_file_date), 'r') as diff_file:
        # Creating the list of lines.
        diff_list = diff_file.readlines()
        # print diff_list

    # Interating over the list and extracting the differences by type. Writing all the differences to the report file.
    # Using try/except to catch and ignore any IndexError exceptions that might occur.
    try:
        with open(str(report_file_date), 'w') as report_file:
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

    # Reading the report file and writing to the master file.
    with open(str(report_file_date), 'r') as report_file, open('cfgfiles/master_report_' + datetime.date.today().isoformat() + '.txt', 'a') as master_report:
        if len(report_file.readlines()) < 1:
            # Adding device as first line in report.
            master_report.write('\n\n*** Device: ' + each_device + ' ***\n')
            master_report.write('\n' + 'No Configuration Changes Recorded On ' + datetime.datetime.now().isoformat() + '\n\n\n')
        else:
            # Appending the content to the master report file.
            report_file.seek(0)
            master_report.write('\n\n*** Device: ' + each_device + ' ***\n\n')
            master_report.write(report_file.read())


# Defining the list of devices to monitor. These are my LAB01 devices.
nd = NetDevices()
neteng_devices = nd.all()
#devices = sorted(neteng_devices)
#print(devices)

# Extracting the running config to a file, depending on the device vendor (Cisco, Juniper or Arista).
for each_device in neteng_devices:
    # Check the device to see if it is reachable.
    if not each_device.is_reachable():
        print 'Sorry.. %s, was unreachable.' % format(each_device)
        trash = each_device.dump()
    else:
        # Using Trigger to check for the each_device vendor.
        if str(each_device.vendor) == 'cisco':
            diff_function('cisco_ios', 'cisco', 'rlaney', 'ralrox', 'show running')
        # Using Trigger to check for the each_device vendor.
        elif str(each_device.vendor) == 'juniper':
            diff_function('juniper', 'juniper', 'rlaney', 'ralrox', 'show configuration')
        # Using Trigger to check for the each_device vendor.
        elif str(each_device.vendor) == 'arista':
            diff_function('arista_eos', 'arista', 'rlaney', 'ralrox', 'show running')
        else:
            print('This {} type is not supported, sorry!\n'.format(each_device)

# Sending the content of the master report file (/cfgfiles/master_report.txt) via email to the network admin.
# Preparing the email.
fromaddr = 'rlaneyjr@gmail.com'
toaddr = 'rlaneyjr@gmail.com'
msg = MIMEMultipart()
msg['From'] = fromaddr
msg['To'] = toaddr
msg['Subject'] = 'Daily Configuration Change Report'

# Checking whether any changes were recorded and building the email body.
with open('cfgfiles/master_report_' + datetime.date.today().isoformat() + '.txt', 'r') as master_report:
    master_report.seek(0)
    body = '\n' + master_report.read() + '\n****************\n\nReport Generated: ' + datetime.datetime.now().isoformat() + '\n\nEnd Of Report\n'
    msg.attach(MIMEText(body, 'plain'))

# Sending the email.
server = smtplib.SMTP('smtp.gmail.com', 587)
server.ehlo()
server.starttls()
server.ehlo()
server.login('rlaneyjr@gmail.com', '22RalRox76')
text = msg.as_string()
server.sendmail(fromaddr, toaddr, text)
