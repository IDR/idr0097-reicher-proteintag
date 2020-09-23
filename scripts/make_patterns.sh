#! /bin/bash

rm -rf 2020923-patterns
mkdir 2020923-patterns -p
mkdir 2020923-patterns/timelapse -p
mkdir 2020923-patterns/sequencing -p

for i in 00; do
    for j in 0h 3h; do
        (cd 2020923-patterns/timelapse && ln -s ../../original/${j}_green_tile${i}.tif tile${i}_t${j}.tif)
    done
    echo "tile${i}_t<0h,3h>.tif" > 2020923-patterns/timelapse/tile${i}.pattern
done

cycles=(SBS1_red SBS1_yellow SBS2_red SBS2_yellow SBS3_red SBS3_yellow SBS4_red SBS4_yellow SBS5_red SBS5_yellow SBS6_red SBS6_yellow SBS7_red SBS7_yellow SBS7_DAPI)

for i in 00; do
    for j in "${!cycles[@]}"; do      
        (cd 2020923-patterns/sequencing  && ln -s ../../original/${cycles[j]}_tile${i}.tif tile${i}_c${j}.tif)
    done
    echo "tile${i}_c<0-15>.tif" > 2020923-patterns/sequencing/tile${i}.pattern
done  
