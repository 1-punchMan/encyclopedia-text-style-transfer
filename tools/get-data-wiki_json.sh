# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

set -e

# output path
OUTPATH="/home/zchen/encyclopedia-text-style-transfer/data/ETST/wiki/raw_data/json/"

# tools paths
TOOLS_PATH="CLTS.tools"

# Wiki data
WIKI_DUMP_PATH="/home/zchen/XLM/data/wiki/bz2/zhwiki-latest-pages-articles.xml.bz2"

# # extract Wiki data
echo "*** Get wiki raw data ... ***"
python -m $TOOLS_PATH.wikiextractor.wikiextractor.WikiExtractor $WIKI_DUMP_PATH --processes 8 -q -o $OUTPATH --json