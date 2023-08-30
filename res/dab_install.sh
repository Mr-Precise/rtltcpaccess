#!/bin/sh

dab_md5="a25b2303badbea40df5e2e2ff58486a3"

get_files()
{
	if [ "`md5sum DABPlayer5.01.zip | cut -d ' ' -f 1`" != "$dab_md5" ]; then
		wget https://www.noxonradio.ch/download/NOXON_DAB_Stick/Updates/DABPlayer5.01.zip -O DABPlayer5.01.zip
		[ "`md5sum DABPlayer5.01.zip | cut -d ' ' -f 1`" != "$dab_md5" ] && return 1
	fi

	return 0
}

wine --version
if [ "$?" != "0" ]; then
	echo "Wine needs to be installed!"
	exit 1
fi

# unpack the archive
unzip -o DABPlayer5.01.zip

# install it silently
wine msiexec /i DABStickInstaller5.01.msi /qn

# Add device information to registry to make it believe a device is connected via USB
wine regedit device_key.reg

wine regedit dab_settings.reg

echo "\nFinished!\n"
