set -e

# Build a vocabulary file from one or several datasets.
TXT_PATH1="/home/zchen/encyclopedia-text-style-transfer/data/wiki/processed_data/train"
TXT_PATH2="/home/zchen/encyclopedia-text-style-transfer/data/baidu/processed_data/tokenized/train"
TXT_PATHS=$TXT_PATH1,$TXT_PATH2
VOC_PATH=/home/zchen/encyclopedia-text-style-transfer/data/vocab
python get_vocab.py \
    --txt_paths $TXT_PATHS  `# Separate by ','` \
    --out_path $VOC_PATH

# Numericalize and binarize data.
DIR1=/home/zchen/encyclopedia-text-style-transfer/data/wiki/processed_data
DIR2=/home/zchen/encyclopedia-text-style-transfer/data/baidu/processed_data/tokenized
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