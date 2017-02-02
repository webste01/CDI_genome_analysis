import sys

name = sys.argv[1][:-4]
for line in open(sys.argv[1]):
    if line.startswith('LOCUS '):
        out = open(name + '_' + line.split()[1] + '.gbk', 'w')
    out.write(line)

