#!/usr/bin/env bash

# List of my written and collected scripts for MAC OS
my_scripts="get-ansible-cfg ConfigFileComp.py DHCPSim_Final.py FixAll.env NetMonSQL_Final.py OSPF_SNMP_Final.py SNMPTemplate.py SSHConfig.py SSHTemplate.py SetupLXC.sh SetupMAC.sh SetupSingleRun.sh Sniffer.py SubnetCalc.py TelnetTemplate.py activate.env backupDotfiles.sh brewUninstall.sh brewUpdate.sh bundler-search cleanupResurrect.sh clrcache.sh convox csv-json.py di-xquartz.sh dot_update.sh docker-completion.sh flushdns git-ca git-churn git-co-pr git-create-branch git-ctags git-current-branch git-delete-branch git-ignore git-merge-branch git-pr git-re-pull git-rename-branch git-up godocker goftp gomongo goneteng gonix gopostg goredis goretna gotfredmon gotftp gotrp install-mininet-vm.sh linkBatch.sh linkdots.sh nodocker noftp nomongo nonix nopostg noredis noretna notfredmon notftp notrp osx-for-hackers.sh pip-freeze-require.py printjsonAll.js ralssh.exp randpass.py remote-rsync.py renix repo-up.py rplc retftp shut.js slowvim ssh-copy-id.sh ssh-multi.sh ssh-multi2.sh tColors.sh tat traceroute.py tweakosx.sh ubuFontInstSrcCodePro.sh ubuInstall.sh ubuInstall_ohmyzsh.sh ubuInstallxRDPlxqt.sh ubuInstallxRDPxfce.sh ubuJava8.sh upgradePythonTools.sh vimPluginUpdate.sh vimfix.sh prettify_json.sh json create-py create-bash create-sh mac-diag move2dot_link"

# List of my written and collected scripts for Linux
mylinux_scripts="get-ansible-cfg activate.env backupDotfiles.sh bundler-search cleanupResurrect.sh ConfigFileComp.py convox csv-json.py DHCPSim_Final.py docker-completion.sh dot_update.sh FixAll.env git-ca git-churn git-co-pr git-create-branch git-ctags git-current-branch git-delete-branch git-ignore git-merge-branch git-pr git-re-pull git-rename-branch git-up install-mininet-vm.sh json linkBatch.sh linkdots.sh NetMonSQL_Final.py OSPF_SNMP_Final.py pip-freeze-require.py prettify_json.sh printjsonAll.js ralssh.exp randpass.py remote-rsync.py  repo-up.py rplc SetupLXC.sh shut.js Sniffer.py SNMPTemplate.py slowvim ssh-copy-id.sh ssh-multi.sh ssh-multi2.sh SSHConfig.py SSHTemplate.py SubnetCalc.py tat tColors.sh TelnetTemplate.py traceroute.py ubuFontInstSrcCodePro.sh ubuInstall.sh ubuInstall_ohmyzsh.sh ubuInstallxRDPlxqt.sh ubuInstallxRDPxfce.sh ubuJava8.sh upgradePythonTools.sh vimfix.sh vimPluginUpdate.sh create-py create-bash create-sh move2dot_link"

if ! [[ -d ~/bin ]]; then
    mkdir -p ~/bin
fi

# get and store OS type
ostype=$(uname -s)

echo "You are on a $ostype machine."
if [[ $ostype == "Darwin" ]]; then
    for i in $my_scripts; do
        if ! [[ -f ~/bin/$i ]]; then
            ln -s ~/scripts/bin/$i ~/bin/$i
        fi
    done
    exit 0
elif [[ $ostype == "Linux" ]]; then
    for i in $mylinux_scripts; do
        if ! [[ -f ~/bin/$i ]]; then
            ln -s ~/scripts/bin/$i ~/bin/$i
        fi
    done
    exit 0
elif [[ $ostype == "FreeBSD" ]]; then
    for i in $mylinux_scripts; do
        if ! [[ -f ~/bin/$i ]]; then
            ln -s ~/scripts/bin/$i ~/bin/$i
        fi
    done
    exit 0
else echo "Cannot run on this system"
exit 0
fi    

################################################################################
#if [[ "$OSTYPE" == "linux-gnu" ]]; then
#    for i in $mylinux_scripts; do
#        if ! [[ -f ~/bin/$i ]]; then
#            ln -s ~/scripts/bin/$i ~/bin/$i
#        fi
#    done
#    exit 0
#elif [[ "$OSTYPE" == "darwin"* ]]; then
#    for i in $my_scripts; do
#        if ! [[ -f ~/bin/$i ]]; then
#            ln -s ~/scripts/bin/$i ~/bin/$i
#        fi
#    done
#    exit 0
#else echo "Cannot run on this system"
#exit 0
#fi    
    
#elif [[ "$OSTYPE" == "cygwin" ]]; then
#        # POSIX compatibility layer and Linux environment emulation for Windows
#elif [[ "$OSTYPE" == "msys" ]]; then
#        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
#elif [[ "$OSTYPE" == "win32" ]]; then
#        # I'm not sure this can happen.
#elif [[ "$OSTYPE" == "freebsd"* ]]; then
#        # ...
################################################################################
#ln -s ~/scripts/bin/ConfigFileComp.py        ~/bin/ConfigFileComp.py
#ln -s ~/scripts/bin/DHCPSim_Final.py         ~/bin/DHCPSim_Final.py
#ln -s ~/scripts/bin/FixAll.env               ~/bin/FixAll.env
#ln -s ~/scripts/bin/NetMonSQL_Final.py       ~/bin/NetMonSQL_Final.py
#ln -s ~/scripts/bin/OSPF_SNMP_Final.py       ~/bin/OSPF_SNMP_Final.py
#ln -s ~/scripts/bin/SNMPTemplate.py          ~/bin/SNMPTemplate.py
#ln -s ~/scripts/bin/SSHConfig.py             ~/bin/SSHConfig.py
#ln -s ~/scripts/bin/SSHTemplate.py           ~/bin/SSHTemplate.py
#ln -s ~/scripts/bin/SetupLXC.sh              ~/bin/SetupLXC.sh
#ln -s ~/scripts/bin/SetupMAC.sh              ~/bin/SetupMAC.sh
#ln -s ~/scripts/bin/SetupSingleRun.sh        ~/bin/SetupSingleRun.sh
#ln -s ~/scripts/bin/Sniffer.py               ~/bin/Sniffer.py
#ln -s ~/scripts/bin/SubnetCalc.py            ~/bin/SubnetCalc.py
#ln -s ~/scripts/bin/TelnetTemplate.py        ~/bin/TelnetTemplate.py
#ln -s ~/scripts/bin/activate.env             ~/bin/activate.env
#ln -s ~/scripts/bin/backupDotfiles.sh        ~/bin/backupDotfiles.sh
#ln -s ~/scripts/bin/brewUninstall.sh         ~/bin/brewUninstall.sh
#ln -s ~/scripts/bin/brewUpdate.sh            ~/bin/brewUpdate.sh
#ln -s ~/scripts/bin/bundler-search           ~/bin/bundler-search
#ln -s ~/scripts/bin/cleanupResurrect.sh      ~/bin/cleanupResurrect.sh
#ln -s ~/scripts/bin/clrcache.sh              ~/bin/clrcache.sh
#ln -s ~/scripts/bin/convox                   ~/bin/convox
#ln -s ~/scripts/bin/csv-json.py              ~/bin/csv-json.py
#ln -s ~/scripts/bin/di-xquartz.sh            ~/bin/di-xquartz.sh
#ln -s ~/scripts/bin/dot_update.sh            ~/bin/dot_update.sh
#ln -s ~/scripts/bin/docker-completion.sh     ~/bin/docker-completion.sh
#ln -s ~/scripts/bin/flushdns                 ~/bin/flushdns
#ln -s ~/scripts/bin/git-ca                   ~/bin/git-ca
#ln -s ~/scripts/bin/git-churn                ~/bin/git-churn
#ln -s ~/scripts/bin/git-co-pr                ~/bin/git-co-pr
#ln -s ~/scripts/bin/git-create-branch        ~/bin/git-create-branch
#ln -s ~/scripts/bin/git-ctags                ~/bin/git-ctags
#ln -s ~/scripts/bin/git-current-branch       ~/bin/git-current-branch
#ln -s ~/scripts/bin/git-delete-branch        ~/bin/git-delete-branch
#ln -s ~/scripts/bin/git-ignore               ~/bin/git-ignore
#ln -s ~/scripts/bin/git-merge-branch         ~/bin/git-merge-branch
#ln -s ~/scripts/bin/git-pr                   ~/bin/git-pr
#ln -s ~/scripts/bin/git-re-pull              ~/bin/git-re-pull
#ln -s ~/scripts/bin/git-rename-branch        ~/bin/git-rename-branch
#ln -s ~/scripts/bin/git-up                   ~/bin/git-up
#ln -s ~/scripts/bin/godocker                 ~/bin/godocker
#ln -s ~/scripts/bin/goftp                    ~/bin/goftp
#ln -s ~/scripts/bin/gomongo                  ~/bin/gomongo
#ln -s ~/scripts/bin/goneteng                 ~/bin/goneteng
#ln -s ~/scripts/bin/gonix                    ~/bin/gonix
#ln -s ~/scripts/bin/gopostg                  ~/bin/gopostg
#ln -s ~/scripts/bin/goredis                  ~/bin/goredis
#ln -s ~/scripts/bin/goretna                  ~/bin/goretna
#ln -s ~/scripts/bin/gotfredmon               ~/bin/gotfredmon
#ln -s ~/scripts/bin/gotftp                   ~/bin/gotftp
#ln -s ~/scripts/bin/gotrp                    ~/bin/gotrp
#ln -s ~/scripts/bin/install-mininet-vm.sh    ~/bin/install-mininet-vm.sh
#ln -s ~/scripts/bin/linkBatch.sh             ~/bin/linkBatch.sh
#ln -s ~/scripts/bin/linkdots.sh              ~/bin/linkdots.sh
#ln -s ~/scripts/bin/nodocker                 ~/bin/nodocker
#ln -s ~/scripts/bin/noftp                    ~/bin/noftp
#ln -s ~/scripts/bin/nomongo                  ~/bin/nomongo
#ln -s ~/scripts/bin/nonix                    ~/bin/nonix
#ln -s ~/scripts/bin/nopostg                  ~/bin/nopostg
#ln -s ~/scripts/bin/noredis                  ~/bin/noredis
#ln -s ~/scripts/bin/noretna                  ~/bin/noretna
#ln -s ~/scripts/bin/notfredmon               ~/bin/notfredmon
#ln -s ~/scripts/bin/notftp                   ~/bin/notftp
#ln -s ~/scripts/bin/notrp                    ~/bin/notrp
#ln -s ~/scripts/bin/osx-for-hackers.sh       ~/bin/osx-for-hackers.sh
#ln -s ~/scripts/bin/pip-freeze-require.py    ~/bin/pip-freeze-require.py
#ln -s ~/scripts/bin/printjsonAll.js          ~/bin/printjsonAll.js
#ln -s ~/scripts/bin/ralssh.exp               ~/bin/ralssh.exp
#ln -s ~/scripts/bin/randpass.py              ~/bin/randpass.py
#ln -s ~/scripts/bin/remote-rsync.py          ~/bin/remote-rsync.py
#ln -s ~/scripts/bin/renix                    ~/bin/renix
#ln -s ~/scripts/bin/repo-all-up.py           ~/bin/repo-all-up.py
#ln -s ~/scripts/bin/repo-up.py               ~/bin/repo-up.py
#ln -s ~/scripts/bin/rplc                     ~/bin/rplc
#ln -s ~/scripts/bin/retftp                   ~/bin/retftp
#ln -s ~/scripts/bin/shut.js                  ~/bin/shut.js
#ln -s ~/scripts/bin/ssh-copy-id.sh           ~/bin/ssh-copy-id.sh
#ln -s ~/scripts/bin/ssh-multi.sh             ~/bin/ssh-multi.sh
#ln -s ~/scripts/bin/ssh-multi2.sh            ~/bin/ssh-multi2.sh
#ln -s ~/scripts/bin/tColors.sh               ~/bin/tColors.sh
#ln -s ~/scripts/bin/tat                      ~/bin/tat
#ln -s ~/scripts/bin/traceroute.py            ~/bin/traceroute.py
#ln -s ~/scripts/bin/tweakosx.sh              ~/bin/tweakosx.sh
#ln -s ~/scripts/bin/ubuFontInstSrcCodePro.sh ~/bin/ubuFontInstSrcCodePro.sh
#ln -s ~/scripts/bin/ubuInstall.sh            ~/bin/ubuInstall.sh
#ln -s ~/scripts/bin/ubuInstall_ohmyzsh.sh    ~/bin/ubuInstall_ohmyzsh.sh
#ln -s ~/scripts/bin/ubuInstallxRDPlxqt.sh    ~/bin/ubuInstallxRDPlxqt.sh
#ln -s ~/scripts/bin/ubuInstallxRDPxfce.sh    ~/bin/ubuInstallxRDPxfce.sh
#ln -s ~/scripts/bin/ubuJava8.sh              ~/bin/ubuJava8.sh
#ln -s ~/scripts/bin/upgradePythonTools.sh    ~/bin/upgradePythonTools.sh
#ln -s ~/scripts/bin/vimPluginUpdate.sh       ~/bin/vimPluginUpdate.sh
#ln -s ~/scripts/bin/vimfix.sh                ~/bin/vimfix.sh

