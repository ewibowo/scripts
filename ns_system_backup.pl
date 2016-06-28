#!/usr/bin/perl

$ENV{PATH} = '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin';

$backup_home_dir  = "/var/ns_system_backup";
$backup_dir  = "$backup_home_dir/backup";
$backup_file  = "$backup_dir.tgz";

backup();

sub backup (){
        print "\nBackup NetScaler start\n";
        system("rm -rf $backup_home_dir/*");
        system("mkdir -p $backup_dir");

        system("mkdir -p $backup_dir/nsconfig");
		system("cp -rf /nsconfig/* $backup_dir/nsconfig/");

		system("mkdir -p $backup_dir/var/download");
		system("cp -rf /var/download/* $backup_dir/var/download/");
		
		system("mkdir -p $backup_dir/var/netscaler/ssl");
		system("cp -rf /var/netscaler/ssl/* $backup_dir/var/netscaler/ssl/");

		system("mkdir -p $backup_dir/var/netscaler/locdb");
		system("cp -rf /var/netscaler/locdb/* $backup_dir/var/netscaler/locdb/");
		
		system("mkdir -p $backup_dir/var/nstemplates");
		system("cp -rf /var/nstemplates/* $backup_dir/var/nstemplates/");
		
		system("mkdir -p $backup_dir/var/lib/likewise/db");
		system("cp -rf /var/lib/likewise/db/* $backup_dir/var/lib/likewise/db/");
		
		system("mkdir -p $backup_dir/var/vpn/bookmark");
		system("cp -rf /var/vpn/bookmark/* $backup_dir/var/vpn/bookmark/");
		
		system("mkdir -p $backup_dir/var/wi/tomcat/webapps");
		system("cp -rf /var/wi/tomcat/webapps/* $backup_dir/var/wi/tomcat/webapps/");
		
		system("mkdir -p $backup_dir/var/wi/tomcat/conf/catalina/localhost");
		system("cp -rf /var/wi/tomcat/conf/catalina/localhost/* $backup_dir/var/wi/tomcat/conf/catalina/localhost/");
		
		system("mkdir -p $backup_dir/var/wi/java_home/lib/security/cacerts");
		system("cp -rf /var/wi/java_home/lib/security/cacerts/* $backup_dir/var/wi/java_home/lib/security/cacerts/");
		
		system("mkdir -p $backup_dir/var/wi/java_home/jre/lib/security/cacerts");
		system("cp -rf /var/wi/java_home/jre/lib/security/cacerts/* $backup_dir/var/wi/java_home/jre/lib/security/cacerts/");
		
		system("mkdir -p $backup_dir/var/nslw.bin/etc");
		system("cp -rf /var/nslw.bin/etc/krb.conf $backup_dir/var/nslw.bin/etc/krb.conf");
		
		system("mkdir -p $backup_dir/var/nslw.bin/etc");
        system("cp -rf /var/nslw.bin/etc/krb.keytab $backup_dir/var/nslw.bin/etc/krb.keytab");
        
        system("mkdir -p $backup_dir/var/netscaler/crl");
        system("cp -rf /var/netscaler/crl $backup_dir/var/netscaler/crl");
        
        system("mkdir -p $backup_dir/var/learnt_data");
        system("cp -rf /var/learnt_data $backup_dir/var/learnt_data");
        
        system("mkdir -p $backup_dir/var/wi/tomcat/logs");
        system("cp -rf /var/wi/tomcat/logs $backup_dir/var/wi/tomcat/logs");
        
        system("mkdir -p $backup_dir/var/log");
        system("cp -rf /var/log/wicmd.log $backup_dir/var/log/wicmd.log");
       
		system("tar cfz $backup_file -C $backup_home_dir backup") == 0 || die "unable to pack backup_file at $backup_home_dir\n";
		system("rm -rf $backup_dir");
        print "Backup NetScaler done\n";
}