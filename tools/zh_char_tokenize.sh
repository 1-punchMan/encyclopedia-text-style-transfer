# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

# Tokenize chinese text data by char-based tokenization.

set -e

TOOLS_PATH=/home/zchen/CLTS/tools

# moses
MOSES=$TOOLS_PATH/mosesdecoder
REPLACE_UNICODE_PUNCT=$MOSES/scripts/tokenizer/replace-unicode-punctuation.perl
NORM_PUNC=$MOSES/scripts/tokenizer/normalize-punctuation.perl
REM_NON_PRINT_CHAR=$MOSES/scripts/tokenizer/remove-non-printing-char.perl
CLEAN="/home/zchen/encyclopedia-text-style-transfer/tools/clean.py"
TOKENIZER=$TOOLS_PATH/char-based_segmenter.py
LOWER_REMOVE_ACCENT=/home/zchen/CLTS/tools/lowercase_and_remove_accent.py

cat - | $REPLACE_UNICODE_PUNCT | $NORM_PUNC -l zh | $REM_NON_PRINT_CHAR | python $CLEAN | python $TOKENIZER | python $LOWER_REMOVE_ACCENT