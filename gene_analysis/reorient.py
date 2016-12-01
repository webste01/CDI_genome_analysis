import sys
import subprocess

try:   
   sys.argv[1:]
except IndexError:  
	sys.exit('''USAGE python reorient.py query.fa reference.fa output.fa
where query.fa is the fasta file to be reorientated
reference is the fasta file with the correct start
and output.fa is the fasta file to put reorientated fasta
will only work with single entry fastas
''')


subprocess.Popen('makeblastdb -dbtype nucl -in ' + sys.argv[2] + ' -out tempdb', shell=True).wait()
subprocess.Popen('blastn -query ' + sys.argv[1] + ' -db tempdb -outfmt 6 -out blast_temp.out', shell=True).wait()
first = {}
seqDict = {}
with open(sys.argv[1]) as f:
    for line in f:
        if line.startswith('>'):
            name = line.rstrip()[1:]
            seqDict[name] = ''
            first[name] = None
        else:
            seqDict[name] += line.rstrip()

with open('blast_temp.out') as f:
    for line in f:
        query, subject, length, ident, mm, indel, qstart, qstop, rstart, rstop, evalue, bitscore = line.split()
        if int(qstart) < int(qstop) and int(rstart) < int(rstop) and int(rstart) < 10 and float(ident) > 90:
            if first[query] is None:
                first[query] = map(int, (qstart, qstop, rstart, rstop))
with open(sys.argv[1]) as f:
    for line in f:
        if line.startswith('>'):
            name = line.rstrip()[1:]
            seqDict[name] = ''
        else:
            seqDict[name] += line.rstrip()
with open(sys.argv[3], 'w') as out:
    for i in seqDict:
        newstart = first[i][0] - first[i][2]
        out.write('>' + i + '\n')
        seq = seqDict[i][newstart:] + seqDict[i][:newstart]
        for k in range(0, len(seq), 80):
            out.write(seq[k:k+80] + '\n')
