# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

set -e

# data path
RAW_DATA_PATH="/home/zchen/encyclopedia-text-style-transfer/data/ChnSentiCorp/raw"

# create an output path
OUT_PATH="/home/zchen/encyclopedia-text-style-transfer/data/ChnSentiCorp/processed"

# tools paths
FILTER_SHORT="/home/zchen/encyclopedia-text-style-transfer/tools/filter_short.py"
TOKENIZE="/home/zchen/encyclopedia-text-style-transfer/tools/zh_char_tokenize.sh"

# # clean and tokenize data
for class in positive negative; do
  mkdir -p $OUT_PATH/$class
  for split in train valid test; do
    if [ ! -f $OUT_PATH/$class/$split ]; then
      cat $RAW_DATA_PATH/$class/$split \
      | $TOKENIZE \
      | python $FILTER_SHORT \
      > $OUT_PATH/$class/$split
    fi
    echo "*** Tokenized (+ lowercase + accent-removal) data to $OUT_PATH/$class/$split ***"
  done
done

