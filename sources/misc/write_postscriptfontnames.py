#!/usr/bin/env python3
##
# usage: ./sources/misc/write_postscriptfontnames.py "sources/designspace/Besley.designspace"
##

try:
    import regex
except ImportError:
    import re as regex
import itertools
import sys

from collections import OrderedDict, defaultdict
from xml.etree.ElementTree import ElementTree, ShortEmptyElements, XMLDeclarationQuotes

_, designspace = sys.argv

with open(designspace, "r") as f:
    xml = ElementTree(file=f)

root = xml.getroot()

for e in root.iter("instance"):
    postscriptfontname = regex.match(r'^.*/(.*?)\.ufo$', e.get("filename")).group(1)
    e.attrib["postscriptfontname"] = postscriptfontname

def d_to_od(d: dict, move_to_start = None, move_to_end = None) -> OrderedDict:
    move_to_start = move_to_start or list()
    move_to_end = move_to_end or list()
    keys = [k for k in sorted(d) if k not in set(move_to_start + move_to_end)]
    od = OrderedDict()

    for m in move_to_start:
        od[m] = d[m]
    for k in keys:
        od[k] = d[k]
    for m in move_to_end:
        od[m] = d[m]

    return od

for e in root.iter("instance"):
    e.attrib = d_to_od(e.attrib, move_to_start=["postscriptfontname"], move_to_end=["filename"])

for e in itertools.chain(root.iter("instance"), root.iter("source")):
    if "Condensed" in e.attrib["familyname"] or "Narrow" in e.attrib["familyname"]:
        family = e.attrib["familyname"].split()
        style = e.attrib["stylename"].split()
        style = [family[-1]] + style
        family = family[:-1]
        e.attrib["familyname"] = " ".join(family)
        e.attrib["stylename"] = " ".join(style)

with open(designspace, "wb+") as f:
    short_empty_elements = defaultdict(lambda: ShortEmptyElements.NOSPACE, {"axis": ShortEmptyElements.NONE})
    xml.write(f, xml_declaration=True, encoding="UTF-8", short_empty_elements=short_empty_elements, xml_declaration_quotes=XMLDeclarationQuotes.DOUBLE)
    f.write(b'\n')
