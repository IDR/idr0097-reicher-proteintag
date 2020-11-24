#! /bin/bash

today=$(date +%Y%m%d)
rm -rf ${today}-patterns
mkdir ${today}-patterns -p


cycles=
cycles=(SBS1_red SBS1_yellow SBS2_red SBS2_yellow SBS3_red SBS3_yellow SBS4_red SBS4_yellow SBS5_red SBS5_yellow SBS6_red SBS6_yellow SBS7_red SBS7_yellow SBS7_DAPI)

for i in r04c05 r05c04 r05c05; do
    for j in SBS1 SBS2 SBS3 SBS4 SBS5 SBS6 SBS7 SBS8; do
        ln -s ../20201117-ftp/${i}_${j}_red.tif ${today}-patterns/${i}_${j}_c0.tif
        ln -s ../20201117-ftp/${i}_${j}_yellow.tif ${today}-patterns/${i}_${j}_c1.tif
        ln -s ../20201117-ftp/${i}_${j}_green.tif ${today}-patterns/${i}_${j}_c2.tif
        echo "${i}_${j}_c<0-2>.tif" > ${today}-patterns/${i}_${j}.pattern
    done
done

