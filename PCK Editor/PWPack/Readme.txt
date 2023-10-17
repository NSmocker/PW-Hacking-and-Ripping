PWPack 1.1 - simple en/decoding utilite for pck files
supports both GUI and command line modes

Compression level and specific options for GUI mode, you can change in "PWPack.xml"

Command line usage:

pwpack -switches Source [Destination]\n"
Where switches one or more:
	x: extract files from <Source> package into <Destination> folder
	c: compress files from <Source> folder into <Destination> package
	xe: extract files from <Source> Ether Saga package into <Destination> folder
	ce: compress files from <Source> folder into <Destination> Ether Saga package
    z0 - z9: compression level ( z0 - none, z1 - min (recommended), z9 - max)


Xelax