set -e

VOC_PATH=/home/zchen/encyclopedia-text-style-transfer/data/vocab

# Numericalize and binarize data.
DIR1="/home/zchen/encyclopedia-text-style-transfer/data/ETST/wiki/processed_data_cleaned/original"
DIR2="/home/zchen/encyclopedia-text-style-transfer/data/ETST/baidu/processed_data_cleaned/original"
DIRS="$DIR1 $DIR2"
for dir in $DIRS; do
    for split in train valid test; do
        echo
        DATA_PATH=$dir/$split
        python numericalize.py $VOC_PATH $DATA_PATH
    done
    echo
    echo "Numericalized and binarized the data in"
    echo $dir
done