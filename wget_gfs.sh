#!/bin/bash
#
#Writen by jpma in 7/29/2017
#Email:jiapeima@lzb.ac.cn
#
#This script uses wget to get the 0.25 degree GFS data 
#which will be used by the WRF model later.
#It can specify the extent of the data (subregion)thus
#reducing the space for string the data, getting a faster
#download speed.
########################
#The url of the GFS data filtered by the conditions usually
#has a form like:
#URL=
# http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?
# file=gfs.t12z.pgrb2.0p25.f000&all_lev=on
# &var_HGT=on&var_LAND=on&var_PRES=on&var_PRMSL=on&var_RH=on&var_SOILW=on&va  r_SPFH=on&var_TMP=on&var_TSOIL=on&var_UGRD=on&var_VGRD=on
# &subregion=&leftlon=100&rightlon=120&toplat=40&bottomlat=20
# &dir=%2Fgfs.2017072112
########################

#This script needs to  be used as:
#
#    ./wget_gfs.sh date hr num intv llon rlon toplat botlat 
#
#date is the day,hr is the time when the date created
#num is the amonut of data, intv is the interval
# between two data,llon is left longitude
#rlon is right longitude,toplat is the top latitude, botlat
#is the bottom latitude.
#
#Where date: YYYYMMDD(20170708)
#	hr: 00, 06,12 or 18
#	num:0-384
#	intv:0-384
#	llon:0-360
#	rlon:0-360
#	toplat:-90-90
#	botlat:-90-90 
#
starttime=$(date +%s)
#--------------
#This step defines the time and subregion
date=$1
hr=$2
num=$3
intv=$4
llon=$5
rlon=$6
toplat=$7
botlat=$8
#--------------
echo "cccccccccccccccccccccccccc"
echo "The time is: $date"
echo "Left longitude is:$llon"
echo "Right longitude is:$rlon"
echo "Top latitude is:$toplat"
echo "Bottom latitude is:$botlat"
echo "cccccccccccccccccccccccccc"

for ((i=0;i<=num;i++))
do
	fhr=$(printf "%03d" $[$i * $intv])
	url="http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25_1hr.pl?file=gfs.t${hr}z.pgrb2.0p25.f${fhr}&all_lev=on&all_var=on&subregion&leftlon=${llon}&rightlon=${rlon}&toplat=${toplat}&bottomlat=${botlat}&dir=%2Fgfs.${date}${hr}"

	#echo $url
	#----------------
	#using wget to download the gfs data and rename it
	wget $url -O gfs.t${hr}z.pgrb.0p25.f${fhr}
	#----------------
	
	#----------------
	#To know whether wget returned without any wrong
	if [ $? -eq 0 ]
	then
		echo "The file gfs.t${hr}z.pgrb.0p25.f${fhr} done"
	else
		echo "Something wrong,checking your inputs and the network!"
		exit 1
	fi
	#---------------
done
endtime=$(date +%s)
echo "All finished. Using $[$endtime - $starttime] s"

