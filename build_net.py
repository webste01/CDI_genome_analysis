import networkx as nx
import matplotlib.pyplot as plt
import numpy as np
import random
 
relax='/sc/orga/scratch/webste01/out/coregenesrelaxed.mp'
strict='/sc/orga/scratch/webste01/out/coregenesstrict.mp'
uniqs='/sc/orga/scratch/webste01/out/uniques.mp'
#relax=sys.argv[1]
#strict=sys.argv[2]
#orth=sys.argv[3]
#uniqs=sys.argv[4]
gg = nx.Graph()
g_colors={} #dictionary of genome names -> colors
 
 
def nonblank_lines(f):
     for l in f:
         line = l.rstrip()
         if line:
             yield line
 
with open (relax) as f:
         for l in nonblank_lines(f):
                 if l.startswith('Genome'):
                         genome=l.split(':')[1]
                         genome_name=genome.split('_')[1]
                         g_colors[genome_name]="#%06x" % random.randint(0, 0xFFFFFF)
                         print genome_name
with open (relax) as f:
	for l in nonblank_lines(f):
        	if not l.startswith('Genome'):
                	 score, l1, l2 = l.strip().split()
                         if l1 not in gg.nodes():
                        	 gn=l1.split('p')[0]
                                 gg.add_node(l1)
                                 gg.node[l1]['col']=g_colors[gn]
                                 if l2 not in gg.nodes():
                                	 gn=l2.split('p')[0]
                                         gg.add_node(l2)
                                         gg.node[l2]['col']=g_colors[gn]
                                         gg.add_node(l2)
                                         gg.add_edge(l1,l2,weight="%s" %(score))
                                 else:
                                         gg.add_edge(l1,l2,weight="%s" %(score))
                         else:
                                 if l2 not in gg.nodes():
                                         gn=l2.split('p')[0]
                                         gg.add_node(l2)
                                         gg.node[l2]['col']=g_colors[gn]
                                         gg.add_edge(l1,l2,weight="%s" %(score))
                                 gg.add_edge(l1,l2,weight="%s" %(score))
unique_cols={}
unique_cols['023063']='#99ff66'
unique_cols['022944']='#FF0000'
unique_cols['020695']='#fff34c'
with open(uniqs) as f:
         for l in nonblank_lines(f):
                 if not l.startswith('Query'):
                         l1=l.strip().split()[0]
			 genome=l1.split('p')[0]
                         if l1 not in gg.nodes():
                                 gg.add_node(l1)
				 col=unique_cols[genome]
                                 gg.node[l1]['col']=col
                         else:
				 col=unique_cols[genome]
                                 gg.node[l1]['col']=col
 
plt.figure(1,figsize=(17,17))
nx.draw_graphviz(gg,node_color=map(lambda x: x[1]['col'],gg.nodes(data=True)),node_size=10,font_size=0,linewidths=0.01, labels=None)
plt.savefig("/sc/orga/scratch/webste01/out/out.png")
plt.show()
