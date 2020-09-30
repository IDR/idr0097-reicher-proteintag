#! /bin/bash

today=$(date +%Y%m%d)
mkdir -p /data/${today}-raw/timelapse
mkdir -p /data/${today}-raw/sequencing
mkdir -p /data/${today}-ometiff/timelapse
mkdir -p /data/${today}-ometiff/sequencing

for i in 00 01 02 03 04 05 06 07 08; do
    /opt/bioformats2raw/bin/bioformats2raw /data/${today}-patterns/timelapse/tile${i}.pattern /data/${today}-raw/timelapse/tile${i}
    /opt/bioformats2raw/bin/bioformats2raw /data/${today}-patterns/sequencing/tile${i}.pattern /data/${today}-raw/sequencing/tile${i}
    /opt/raw2ometiff/bin/raw2ometiff /data/${today}-raw/timelapse/tile${i} /data/${today}-ometiff/timelapse/tile${i}.ome.tiff
    /opt/raw2ometiff/bin/raw2ometiff /data/${today}-raw/sequencing/tile${i} /data/${today}-ometiff/sequencing/tile${i}.ome.tiff
done
