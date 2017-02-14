# ============LICENSE_START==========================================
# ===================================================================
# Copyright (c) 2017 AT&T Intellectual Property. All rights reserved.
# ===================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END============================================
# ECOMP and OpenECOMP are trademarks and service marks of AT&T Intellectual Property.

from __future__ import print_function
import os
import re
import sys

"""
Replace patterns in a file with the corresponding replacements.

Args: OriginalFile OutFile XRefFile
"""


def process_kv_file(fname):
    """
    Read a simple properties file, X=Y type; file may contain comment lines and blanks. Return a dict
    Leading comments are '^\s*#', while blank lines aare '^\s*$'
    Key cannot contain '=', but value can
    """
    ignore_pattern = re.compile(r'^\s*(#|$)') 
    with open(fname) as fid:
        all_lines = [ line.strip() for line in fid if not re.match(ignore_pattern, line) ]
        return dict( line.partition('=')[::2] for line in all_lines )


def replace_kv(fname, outfname, *xref_files):
    """
    Read a file, and perform multiple search replace using key-values in xref. 
    Keys have to be simple keys
    """
    xref = {}
    for xref_file in xref_files:
        xref.update(process_kv_file(xref_file))
    pattern = re.compile("|".join(xref.keys()))
    with open(outfname, 'w') as outf:
        with open(fname) as fid:
            all_text = fid.read()
            outf.write(pattern.sub(lambda m: xref[m.group(0)], all_text))

 
if __name__ == "__main__":
    if len(sys.argv) >= 3: 
        replace_kv(*sys.argv[1:]) 
    else:
        print("Usage: {} <{}> <{}> <{}> [{}]".format(
              sys.argv[0], "InputFile", "OutPutFile", "XREF-DictFile[s]", "..."), file=sys.stderr);
