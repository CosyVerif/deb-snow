#! /bin/sh
################################################################################
# List of Variables
#      DIRECTORYNAME  : Source Code directory 
#      BINPACKAGENAME : Name of the package that will contain the binary files.
#                       In order to create that package, you have to put "s" in
#                       the array PACKAGETYPE (see below).
#      VERSION        : Current version of the program
#      COPYRIGHT      : Is one of the following :
#                       gpl,gpl2,gpl3,lgpl,lgpl2,lgpl3, artistic, apache, bsd or
#                       mit
#      BINARYNAMES    : Name of the binary files you want to include in the 
#                       package that will contain the binaries.
#      BINPACKAGEDESC : Path of the file containing the description of 
#                       the package. It must be in the following format : the 
#                       first line contains a short description of the package
#                       (up to 60 chars), and the rest of the file contains a
#                       long description of the package (no limit).
#      DEBEMAIL       : Email of the package maintainer
#      DEBFULLNAME    : Name of the package maintainer

DIRECTORYNAME=snow;
BINPACKAGENAME=snow;
VERSION=1.4.2;
COPYRIGHT=gpl;
BINARYNAMES="cami2gpsn cami2smart";
BINPACKAGEDESCFILE="";
HOMEPAGE="";
LOGFILE="";
DEBEMAIL="maxime.bittan@gmail.com";
DEBFULLNAME="Maxime Bittan";
export DEBEMAIL; export DEBFULLNAME;
export HOMEPAGE; export LOGFILE;
################################################################################

    #Copying Files in the right directory.
cp -r $DIRECTORYNAME "$BINPACKAGENAME-$VERSION";
BINPACKAGEDIRECTORY="$BINPACKAGENAME-$VERSION";

    #Creation of the tarball
cd $BINPACKAGEDIRECTORY;
autoreconf -vfi;
./configure;
cd ..;
tar -czf "$BINPACKAGENAME""_$VERSION.orig.tar.gz" $BINPACKAGEDIRECTORY;
    
    #Creation of the debian packaging files
cd $BINPACKAGEDIRECTORY;
env echo -e -n "\n" > tmpfile
dh_make -s -c $COPYRIGHT < tmpfile
rm -f tmpfile

    #Removing useless files
rm -rf debian/*.EX debian/*.ex debian/README*

    #creating debian/source/include-binaries file
rm -f debian/source/include-binaries
for binary in $BINARYNAMES
do
    env echo "usr/bin/$binary" >> debian/source/include-binaries
done;

    #Fixing generated files
debuild -S -uc -us
../correct_lintian.pl  ../"$BINPACKAGENAME""_$VERSION-1_source.build"
    #Build package
debuild -us -uc;

    #clean-up
cd ..;
rm -rf $BINPACKAGEDIRECTORY;
rm -f "$BINPACKAGENAME""_$VERSION.orig.tar.gz";
rm -f "$BINPACKAGENAME""_$VERSION-1.debian.tar.gz";
rm -f "$BINPACKAGENAME""_$VERSION-1.dsc";
rm -f *.build *.changes;
