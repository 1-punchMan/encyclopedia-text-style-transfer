# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

set -e

# output path
WIKI_PATH="/home/zchen/encyclopedia-text-style-transfer/data/wiki/raw_data"

# tools paths
TOOLS_PATH="/home/zchen/CLTS/tools"

# Wiki data
WIKI_DUMP_PATH="/home/zchen/CLTS/data/wiki/bz2/zhwiki-latest-pages-articles.xml.bz2"

# # extract Wiki data
echo "*** Get wiki raw data ... ***"
if [ ! -f $WIKI_PATH/all ]; then
  python $TOOLS_PATH/wikiextractor/wikiextractor/WikiExtractor.py $WIKI_DUMP_PATH --processes 8 -q -o - \
  | sed "/^\s*\$/d" \
  | grep -v "^<doc id=" \
  | grep -v "</doc>\$" \
  > $WIKI_PATH/all
fi