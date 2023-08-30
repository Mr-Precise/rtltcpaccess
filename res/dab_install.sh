#!/bin/sh
# Installation script for DAB receiver in Wine
# https://github.com/steve-m/rtltcpaccess

dab_name="NOXON_DAB_MediaPlayer-v5.1.3.exe.zip"
dab_md5="95b959a321c5d25af651f308cd096c2b"
tcpacc_name="RTL283XACCESS.zip"
tcpacc_md5="f6f6909a9070a7b5008f6e63e0a3e174"

get_files()
{
	if [ "`md5sum $dab_name | cut -d ' ' -f 1`" != "$dab_md5" ]; then
		wget https://www.noxonradio.ch/download/NOXON_DAB_Stick/$dab_name -O $dab_name
		[ "`md5sum $dab_name | cut -d ' ' -f 1`" != "$dab_md5" ] && return 1
	fi

	if [ "`md5sum $tcpacc_name | cut -d ' ' -f 1`" != "$tcpacc_md5" ]; then
		wget https://github.com/Mr-Precise/rtltcpaccess/releases/download/v2023.8.30/$tcpacc_name -O $tcpacc_name
		[ "`md5sum $tcpacc_name | cut -d ' ' -f 1`" != "$tcpacc_md5" ] && return 2
	fi

	return 0
}

wine --version
if [ "$?" != "0" ]; then
	echo "Wine needs to be installed!"
	exit 1
fi

# figure out application path
app_path="`wine cmd /c echo %ProgramFiles% | tr -d '\r\n'`\NOXON\DAB Media Player"
unix_path="`winepath -u "$app_path"`"

mkdir /tmp/dab_install
cd /tmp/dab_install/

# grab the software
get_files
if [ "$?" != "0" ]; then
	echo "Error fetching files, aborting!"
	exit 1
fi

# unpack the archive
unzip -o $dab_name

# install it silently
wine NOXON_DAB_MediaPlayer-v5.1.3.exe /S

rm "$unix_path/RTL283XACCESS.dll"

unzip -o $tcpacc_name
cp RTL283XACCESS.dll "$unix_path/"


echo "\nInstallation finished!\nTo run the software, start rtl_tcp first, and then start:"
echo "wine \"\`winepath -u \"$app_path\NOXON_DAB_MediaPlayer.exe\"\`"\"

# Add device information to registry to make it believe a device is connected via USB
wine regedit device_key.reg

wine regedit dab_settings.reg

echo "\nFinished!\n"
