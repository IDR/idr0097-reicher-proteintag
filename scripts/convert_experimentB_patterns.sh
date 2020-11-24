#! /bin/bash

today=$(date +%Y%m%d)
mkdir -p /data/idr0097-reicher-proteintag/${today}-raw/timelapse
mkdir -p /data/idr0097-reicher-proteintag/${today}-raw/sequencing
mkdir -p /data/idr0097-reicher-proteintag/${today}-ometiff/timelapse
mkdir -p /data/idr0097-reicher-proteintag/${today}-ometiff/sequencing

for i in 00 01 02 03 04 05 06 07 08; do
    /opt/bioformats2raw/bin/bioformats2raw /data/idr0097-reicher-proteintag/${today}-patterns/timelapse/tile${i}.pattern /data/idr0097-reicher-proteintag/${today}-raw/timelapse/tile${i}
    /opt/bioformats2raw/bin/bioformats2raw /data/idr0097-reicher-proteintag/${today}-patterns/sequencing/tile${i}.pattern /data/idr0097-reicher-proteintag/${today}-raw/sequencing/tile${i}
    /opt/raw2ometiff/bin/raw2ometiff /data/idr0097-reicher-proteintag/${today}-raw/timelapse/tile${i} /data/idr0097-reicher-proteintag/${today}-ometiff/timelapse/tile${i}.ome.tiff
    /opt/raw2ometiff/bin/raw2ometiff /data/idr0097-reicher-proteintag/${today}-raw/sequencing/tile${i} /data/idr0097-reicher-proteintag/${today}-ometiff/sequencing/tile${i}.ome.tiff
done
