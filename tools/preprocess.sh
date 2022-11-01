# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

#
# Usage: preprocess.sh RAW_DATA_FILE OUT_PATH
# Note: Don't add '/' at the end of the output directory.
#

set -e

# data file
RAW_DATA_FILE=$1

# create an output path
OUT_PATH=$2
mkdir -p $OUT_PATH

# tools paths
TOKENIZE="/home/zchen/encyclopedia-text-style-transfer/tools/zh_char_tokenize.sh"

# # clean and tokenize data
echo "*** Cleaning and tokenizing data ... ***"
if [ ! -f $OUT_PATH/all ]; then
  cat $RAW_DATA_FILE \
  | $TOKENIZE \
  > $OUT_PATH/all
fi
echo "*** Tokenized (+ lowercase + accent-removal) data to $OUT_PATH/all ***"

# split into train / valid / test
echo "*** Split into train / valid / test ***"
split_data() {
    get_seeded_random() {
        seed="$1"; openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt </dev/zero 2>/dev/null
    };
    NLINES=`wc -l $1  | awk -F " " '{print $1}'`;
    NTRAIN=$((NLINES - 10000));
    NVAL=$((NTRAIN + 5000));
    shuf --random-source=<(get_seeded_random 42) $1 | head -$NTRAIN             > $2;
    shuf --random-source=<(get_seeded_random 42) $1 | head -$NVAL | tail -5000  > $3;
    shuf --random-source=<(get_seeded_random 42) $1 | tail -5000                > $4;
}
split_data $OUT_PATH/all $OUT_PATH/train $OUT_PATH/valid $OUT_PATH/test

