set -x
PKG=sound-effects-library-weapons
VSN=1.0-1

# download medieval weapons
if [ ! -e Weapon_on_Weapon.zip ]
then
	wget http://www.mediafire.com/download/wk1t7u73hrejuzd/Weapon_on_Weapon.zip
fi

# download firearms
if [ ! -e Prepared_Master_Sheet.csv ]
then
    wget http://www.mediafire.com/view/2y39ocuu2au6x2b/Prepared_Master_Sheet.csv
fi
if [ ! -e Prepared_SFX_Library.zip ]
then
    wget http://www.mediafire.com/download/gh6e02cvj8x75fr/Prepared_SFX_Library.zip
fi

# process medieval weapons
if [ -e $PKG-$VSN/usr/share/sounds/sound-effects-library-medieval-weapons ]
then
    rm -rf $PKG-$VSN/usr/share/sounds/sound-effects-library-medieval-weapons
fi
mkdir -p $PKG-$VSN/usr/share/sounds/sound-effects-library-medieval-weapons
cd $PKG-$VSN/usr/share/sounds/sound-effects-library-medieval-weapons
unzip -o ../../../../../Weapon_on_Weapon.zip
ls | while read -r FILE
do
    mv -v "$FILE" `echo $FILE | tr ' ' '-' | tr '[A-Z]' '[a-z]'`
done
cd ../../../../..

# process firearms
if [ -e $PKG-$VSN/usr/share/sounds/sound-effects-library-firearms ]
then
    rm -rf $PKG-$VSN/usr/share/sounds/sound-effects-library-firearms
fi
mkdir -p $PKG-$VSN/usr/share/sounds/sound-effects-library-firearms
cd $PKG-$VSN/usr/share/sounds/sound-effects-library-firearms
unzip -o ../../../../../Prepared_SFX_Library.zip
rm -rf __MACOSX
rm -f */.DS_Store */*/.DS_Store
mv Prepared\ SFX\ Library/* .
rmdir Prepared\ SFX\ Library
ls | while read -r FILE
do
    if [ `echo $FILE|grep 1911|wc -l` = '0' -a `echo $FILE|grep 1911|wc -l` = '0' ]
    then
        mv -v "$FILE" `echo $FILE | tr ' ' '-' | tr '[A-Z]' '[a-z]' | sed 's/&/and/g' | sed 's/\.//g'`
    fi
done
for i in *
do
    for j in $i/*.wav
    do
        mv -v $j $i\_`basename $j`
    done
    rmdir $i
done
cd ../../../../..
if [ -e $PKG-$VSN/usr/share/doc/$PKG ]
then
    rm -rf $PKG-$VSN/usr/share/doc/$PKG
fi
mkdir -p $PKG-$VSN/usr/share/doc/$PKG
cd $PKG-$VSN/usr/share/doc/$PKG
tr '\015' '\n'<../../../../../Prepared_Master_Sheet.csv >prepared_master_sheet.csv
cd ../../../../..

# supply metadata
cp LICENSE $PKG-$VSN/usr/share/doc/$PKG/copyright
cp README.md $PKG-$VSN/usr/share/doc/$PKG

# create PKG
if [ -e $PKG-$VSN/DEBIAN ]
then
    rm -rf $PKG-$VSN/DEBIAN
fi
mkdir -p $PKG-$VSN/DEBIAN
cp control $PKG-$VSN/DEBIAN
rm -f $PKG-$VSN.deb
dpkg-deb --build $PKG-$VSN
