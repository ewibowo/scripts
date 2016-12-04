
import datetime
import re

app_today = datetime.date.today().isoformat()
bad_seperator = re.compile(" => ")
good_seperator = ': '
bad_admin = re.compile(r"'active': 'true'")
good_admin = "'adminStatus': 'PRODUCTION'"
bad_name = re.compile(r"'name'")
good_name = "'nodeName'"
bad_site = re.compile(r"'group'")
good_site = "'site'"
bad_ip = re.compile(r"'host'")
good_ip = "'ipv4'"
bad_owner = re.compile(r"'group'")
good_owner = "'owner'"
bad_team = re.compile(r"'group'")
good_team = "'owningTeam'"
bad_tags = re.compile(r"'notes'")
good_tags = "'deviceTags'"


with open('dc4-nodes.nmis', 'r') as node_file, \
     open(app_today + '_' + 'netdevs.json', 'w') as dev_file:
    for line in node_file.readlines():
        line = re.sub(bad_seperator, good_seperator, line)
        line = re.sub(bad_admin, good_admin, line)
        line = re.sub(bad_name, good_name, line)
        line = re.sub(bad_site, good_site, line)
        line = re.sub(bad_ip, good_ip, line)
        line = re.sub(bad_owner, good_owner, line)
        line = re.sub(bad_team, good_team, line)
        line = re.sub(bad_tags, good_tags, line)
        dev_file.write(line)
