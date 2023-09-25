
targets  = ["A","B","D","T","av","bv","dv"]
sniplist = []
argment={}
out = ""
count = 1

def clean():
    argrm=[]
    for i in range(0,len(list(argment.keys()))):
        if argment[list(argment.keys())[i]]==0:
            argrm.append(list(argment.keys())[i])
    for i in argrm:
        argment.pop(i,None)

with open("ind") as ind:
    for line in ind:
        line = line.replace("{","{{").replace("}","}}")
        argment={}
        for key in targets:
            argment[key]=line.count(key)
        clean()
        while 1:
            if len(list(argment.keys())) == 0:
                break
            indexs={}
            for key in argment.keys():
                indexs[key]=line.index(key)
            index=min(indexs, key=indexs.get)
            line=line.replace(index,"{}",1)
            sniplist.append(index)
            argment[index]-=1
            clean()
        out+=line


inserts=[]
for nr, i in enumerate(sniplist):
    if i in inserts:
        sniplist[nr] = "rep("+str(inserts.index(i)+1)+")"
    else:
        sniplist[nr] = "i("+str(count)+",'')"
        count +=1
        inserts.append(i)

out += "\n\n{"
for i in sniplist:
    out+=i+","
out += "}"
print(out)