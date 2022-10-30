import os
files = os.listdir()
for files in os.listdir():
    filename = os.path.splitext(files)[0]
    filename_old = os.path.basename(files)
    import xml.etree.ElementTree as ET
    tree = ET.parse("system.xml")
    root = tree.getroot()
    for romset in root.iter('romset'):
        romname = romset.attrib["name"]
        altname = romset.attrib["altname"] 
        if filename == romname:
           import re
           altname = re.sub("\!|\'|\?|\/|\'","", altname)
           filename_new = str(altname + '.mgl')
           os.rename (filename_old,filename_new)
