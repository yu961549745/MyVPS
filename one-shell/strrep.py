import sys

args = sys.argv
inFile = args[1]
reps = args[2:]

f = open(inFile)
s = f.read()
f.close()

for k in range(len(reps) // 2):
    s = s.replace(reps[2 * k], reps[2 * k + 1])

f = open(inFile, 'w')
f.write(s)
f.close()
