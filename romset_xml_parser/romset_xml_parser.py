import xml.etree.ElementTree as ET
tree = ET.parse("romsets.xml")
root = tree.getroot()
for romset in root.iter('romset'):
    print(romset.attrib["name"] + " <---> " + romset.attrib["altname"])
