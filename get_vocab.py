#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

import os
import sys
import argparse

from logger import create_logger
from dictionary import Dictionary

def get_parser():
    """
    Generate a parameters parser.
    """
    # parse parameters
    parser = argparse.ArgumentParser(description="get a vocabulary file")

    parser.add_argument("--txt_paths", type=str, default="",
                        help="Data paths")
    parser.add_argument("--out_path", type=str, default="",
                        help="Output path")

    return parser

if __name__ == '__main__':

    logger = create_logger(None, 0)
    
    # generate parser / parse parameters
    parser = get_parser()
    params = parser.parse_args()
    
    txt_paths = params.txt_paths.split(',')
    assert all([os.path.isfile(txt_path) for txt_path in txt_paths])
    dico = Dictionary.build_vocab_from_datasets(txt_paths)
    dico.export(params.out_path)