
http://17.209.10.209:8080/job/ISTCFBuildAutomation/ws/ISTCF_OS_Build/

/Users/apple/jenkins/jobs/ISTCFBuildAutomation/workspace/ISTCF_OS_Build/ISTCFOS.tgz


# !/bin/sh
#select HOMEPAGE from spaces where SPACENAME='AAAT Rollout'
db=finalpro
username=root
password=root
host_name=localhost
mysql -h $host_name -u $username -p$password -D $db -e "select body from bodycontent where contentid=3604481" > /Users/swathikumar/Desktop/test11

cat /Users/swathikumar/Desktop/test11 | wc -l
#LINE2=`sed -n '2p' /Users/swathikumar/Desktop/test11`
#echo $LINE2

currentdate=`date "+%Y-%m-%d %T"`
echo $currentdate
radarNumbers=` cat /Users/swathikumar/Desktop/test11`
#echo"The radar Numbers-------------++++++++++---- +$radarNumbers"

mysql -h $host_name -u $username -p$password -D $db -e "update bodycontent set body='$radarNumbers' where contentid=3604481"











export CONFIGURATION=Release
#Export the directory containing your project (i.e. the directory containing the projectname.xcodeproj package).
export XCODE_PROJ_DIR="$WORKSPACE/Frameworks/ISTCF/projects/ISTProjectArchiver"
export PROJECT=ISTProjectArchiver.xcodeproj
export TARGET="Archive ISTCF OS"
export BUILD_DIR="$WORKSPACE/../builds"

#Change directory to script directory
echo ${HUDSON_HOME}
cd "$HUDSON_HOME"/scripts

#Build the product 
cd "$XCODE_PROJ_DIR";xcodebuild -project "$PROJECT" -target "$TARGET" -configuration Release clean OBJROOT="$BUILD_DIR" SYMROOT="$BUILD_DIR"

cd "$XCODE_PROJ_DIR";xcodebuild -project "$PROJECT" -target "$TARGET" -configuration Release OBJROOT="$BUILD_DIR" SYMROOT="$BUILD_DIR"










export CONFIGURATION=Release
#Export the directory containing your project (i.e. the directory containing the projectname.xcodeproj package).
export XCODE_PROJ_DIR="$WORKSPACE/Frameworks/ISTCF/projects/ISTProjectArchiver"
export PROJECT=ISTProjectArchiver.xcodeproj
export TARGET="Archive ISTCF OS"
export BUILD_DIR="$WORKSPACE/../builds"

#Change directory to script directory
echo ${HUDSON_HOME}
cd "$HUDSON_HOME"/scripts

#Build the product 
cd "$XCODE_PROJ_DIR";xcodebuild -project "$PROJECT" -target "$TARGET" -configuration Release clean OBJROOT="$BUILD_DIR" SYMROOT="$BUILD_DIR"

cd "$XCODE_PROJ_DIR";xcodebuild -project "$PROJECT" -target "$TARGET" -configuration Release OBJROOT="$BUILD_DIR" SYMROOT="$BUILD_DIR"









#!/bin/sh

URL=http://myprojectnow.unfuddle.com/svn/myprojectnow_myproject/hudsontest/


CURRENTREVISION=`svn info http://myprojectnow.unfuddle.com/svn/myprojectnow_myproject/hudsontest/ | sed -ne 's/^Revision: //p'`
echo $CURRENTREVISION
echo "ISTCF-GM- $CURRENTREVISION" > /Users/swathikumar/Desktop/test11
OLD_REVISION=`expr $CURRENTREVISION - 1`
echo $OLD_REVISION

#LogFile=/Users/swathikumar/Desktop/svndiff/revision.log
#svn log $URL -r $CURRENTREVISION > $LogFile
#username=`cat $LogFile | head -2 |tail -1 | cut -f2 -d '|'`
#echo $username

## Doing svn diff and storing it into one file
DiffFile=/Users/swathikumar/Desktop/svndiff/$CURRENTREVISION.log
radarNo=/Users/swathikumar/Desktop/test12
svn diff -r $OLD_REVISION:$CURRENTREVISION $URL > $DiffFile

## Fetching all the radars and storing into one file
radarNames=`cat $DiffFile | grep   "<rdar://problem"`
echo $radarNames > $radarNo

## Fetching radar numbers and storing into another file
totalRadarNumbers=`cat $radarNo | grep -o "[0123456789]\{7,\}"`
echo $totalRadarNumbers > /Users/swathikumar/Desktop/test13

## Reading radar numbers and store it into an Array
radarNumbers=` cat /Users/swathikumar/Desktop/test13`
export IFS=" "
#Declaring Arrays
declare -a radarnumbersArray
declare -a radarName
count=0;
for number in $radarNumbers
  do
	radarnumbersArray[$count]=`echo $number`
	count=$count+1
  done
echo "The count-- ${#radarnumbersArray[*]}"

## Fetching Actual Radar from the temp file
releasenote=/Users/swathikumar/Desktop/svndiff/releaseNote$CURRENTREVISION.txt
echo "       ISTCF Build Automation process Release Notes" > $releasenote
echo "       Release 10.0rc1.6 `date`" >> $releasenote
echo "       -----------------------------------------------" >> $releasenote

radarCount=0;
for (( i=0 ; i < ${#radarnumbersArray[*]} ; i++ ))
do
tempRadarName=`cat $DiffFile | grep  ${radarnumbersArray[i]}`
indexArg="<"
indexNo=`awk -v a="$tempRadarName" -v b="$indexArg" 'BEGIN{print index(a,b)}'`
actualRadarName=${tempRadarName:`expr indexNo-1`:${#tempRadarName}}
radarName[$radarCount]=$actualRadarName
radarCount=$radarCount+1
done

for (( j=0 ; j < ${#radarName[*]} ; j++ ))
do 
echo ${radarName[j]} >> $releasenote
done
echo ${PROJECT_PATH}