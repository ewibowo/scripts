
import datetime
import re

app_today = "datetime.date.today().isoformat() + '_' +"
bad_seperator = re.compile(r" => ")
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
     open(app_today 'netdevs.json', 'w') as dev_file:
    bad_seperator.sub(good_seperator, node_file)
    bad_admin.sub(good_admin, node_file)
    bad_name.sub(good_name, node_file)
    bad_site.sub(good_site, node_file)
    bad_ip.sub(good_ip, node_file)
    bad_owner.sub(good_owner, node_file)
    bad_team.sub(good_team, node_file)
    bad_tags.sub(good_tags, node_file)
    dev_file.write(node_file)
