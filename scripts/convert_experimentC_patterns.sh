#! /bin/bash

today=$(date +%Y%m%d)
mkdir -p /data/idr0097-reicher-proteintag/${today}-raw
mkdir -p /data/idr0097-reicher-proteintag/${today}-ometiff

for i in r04c05 r05c04 r05c05; do
    for j in 0h 1h 3h; do
        /opt/bioformats2raw/bin/bioformats2raw /data/idr0097-reicher-proteintag/20201117-ftp/${i}_${j}_green.tif /data/idr0097-reicher-proteintag//${today}-raw/${i}_${j}
        /opt/raw2ometiff/bin/raw2ometiff /data/idr0097-reicher-proteintag/${today}-raw/${i}_${j} /data/idr0097-reicher-proteintag/${today}-ometiff/${i}_${j}.ome.tiff
    done
    for j in SBS1 SBS2 SBS3 SBS4 SBS5 SBS6 SBS7 SBS8; do
        /opt/bioformats2raw/bin/bioformats2raw /data/idr0097-reicher-proteintag/${today}-patterns/${i}_${j}.pattern /data/idr0097-reicher-proteintag/${today}-raw/${i}_${j}
        /opt/raw2ometiff/bin/raw2ometiff /data/idr0097-reicher-proteintag/${today}-raw/${i}_${j} /data/idr0097-reicher-proteintag/${today}-ometiff/${i}_${j}.ome.tiff
    done
done
