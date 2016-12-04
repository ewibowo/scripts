#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python

In [6]: dev = nd.values()

In [7]: print(dev)
[<NetDevice: dc4-edge>, <NetDevice: sc9-nxos2>, <NetDevice: internet1>, <NetDevice: sc9-gw2>, <NetDevice: dc4-backhaul>, <NetDevice: sc9-eos1>, <NetDevice: dc4-sw1>, <NetDevice: sc9-eos2>, <NetDevice: sc9-gw1>, <NetDevice: dc4-nxos2>, <NetDevice: dc4-nxos1>, <NetDevice: dc4-gw2>, <NetDevice: sc9-nxos1>, <NetDevice: sc9-sw1>, <NetDevice: dc4-gw1>, <NetDevice: sc9-edge>, <NetDevice: internet2>, <NetDevice: dc4-eos2>, <NetDevice: dc4-eos1>, <NetDevice: sc9-backhaul>]

In [8]: print(nd)
<trigger.netdevices._actual object at 0x10f4eb3d0>

In [9]: dev
Out[9]:
[<NetDevice: dc4-edge>,
 <NetDevice: sc9-nxos2>,
 <NetDevice: internet1>,
 <NetDevice: sc9-gw2>,
 <NetDevice: dc4-backhaul>,
 <NetDevice: sc9-eos1>,
 <NetDevice: dc4-sw1>,
 <NetDevice: sc9-eos2>,
 <NetDevice: sc9-gw1>,
 <NetDevice: dc4-nxos2>,
 <NetDevice: dc4-nxos1>,
 <NetDevice: dc4-gw2>,
 <NetDevice: sc9-nxos1>,
 <NetDevice: sc9-sw1>,
 <NetDevice: dc4-gw1>,
 <NetDevice: sc9-edge>,
 <NetDevice: internet2>,
 <NetDevice: dc4-eos2>,
 <NetDevice: dc4-eos1>,
 <NetDevice: sc9-backhaul>]

In [10]: nd
Out[10]: {u'dc4-edge': <NetDevice: dc4-edge>, u'sc9-gw2': <NetDevice: sc9-gw2>, u'internet1': <NetDevice: internet1>, u'internet2': <NetDevice: internet2>, u'dc4-backhaul': <NetDevice: dc4-backhaul>, u'sc9-eos1': <NetDevice: sc9-eos1>, u'dc4-sw1': <NetDevice: dc4-sw1>, u'sc9-nxos2': <NetDevice: sc9-nxos2>, u'dc4-nxos2': <NetDevice: dc4-nxos2>, u'dc4-nxos1': <NetDevice: dc4-nxos1>, u'dc4-gw2': <NetDevice: dc4-gw2>, u'sc9-gw1': <NetDevice: sc9-gw1>, u'dc4-eos1': <NetDevice: dc4-eos1>, u'sc9-sw1': <NetDevice: sc9-sw1>, u'dc4-gw1': <NetDevice: dc4-gw1>, u'sc9-eos2': <NetDevice: sc9-eos2>, u'sc9-nxos1': <NetDevice: sc9-nxos1>, u'dc4-eos2': <NetDevice: dc4-eos2>, u'sc9-edge': <NetDevice: sc9-edge>, u'sc9-backhaul': <NetDevice: sc9-backhaul>}


for d in dev:
    print d

dc4-edge
sc9-nxos2
internet1
sc9-gw2
dc4-backhaul
sc9-eos1
dc4-sw1
sc9-eos2
sc9-gw1
dc4-nxos2
dc4-nxos1
dc4-gw2
sc9-nxos1
sc9-sw1
dc4-gw1
sc9-edge
internet2
dc4-eos2
dc4-eos1
sc9-backhaul


for d in dev:
    good = d.has_ssh()
    print good

True
False
False
False
False
True
False
True
False
True
True
False
True
False
False
False
False
True
True
False


for d in dev:
    if d.has_ssh():
        print d

dc4-edge
sc9-eos1
sc9-eos2
dc4-nxos2
dc4-nxos1
sc9-nxos1
dc4-eos2
dc4-eos1

