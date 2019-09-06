import sys
import pandas as pd




l = sys.argv[1]
r = sys.argv[2]
col =sys.argv[3]
fill = sys.argv[4]
out=sys.argv[5]


dfl=pd.read_csv(l,dtype=str)
dfr=pd.read_csv(r,dtype=str)
if fill=="":
  dfout=pd.merge(dfl, dfr, on=col, how='outer')
else:
  dfout=pd.merge(dfl, dfr, on=col, how='outer').fillna(fill)

dfout.to_csv(out,index=False)


# ratio=0.8
# if len(sys.argv)>4:
#   ratio=float(sys.argv[4])
# print("ratio==",ratio)
