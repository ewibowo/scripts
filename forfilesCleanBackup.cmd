@echo off
	set date_=%date:~-10,2%-%date:~-7,2%-%date:~-4,4%
	set ftpFolder1=D:\DC4_Juniper_VPN
	set ftpFolder2=D:\CheckPoint_FW
	set ftpFolder3=D:\Netscaler
	set ftpFolder4=D:\Riverbed

forfiles /p %ftpFolder1% /s /m *.* /d -31 /c "cmd /c echo @path >> D:\Local_FTP_logs\DC4_Juniper_VPN\%date_%_Deleted.log && cmd /c del /q @path"
forfiles /p %ftpFolder2% /s /m *.* /d -31 /c "cmd /c echo @path >> D:\Local_FTP_logs\CheckPoint_FW\%date_%_Deleted.log && cmd /c del /q @path"
forfiles /p %ftpFolder3% /s /m *.* /d -31 /c "cmd /c echo @path >> D:\Local_FTP_logs\Netscaler\%date_%_Deleted.log && cmd /c del /q @path"
forfiles /p %ftpFolder4% /s /m *.* /d -31 /c "cmd /c echo @path >> D:\Local_FTP_logs\Riverbed\%date_%_Deleted.log && cmd /c del /q @path"

@echo on