import os
#import csv

myfile = open('All-combined.csv', 'wb')
#mywriter = csv.writer(csv_file, delimiter=',')

for i in os.listdir(os.getcwd()):
    #if i.startswith('App'):
        with open(i, 'rb') as x:
            lines = x.readlines()
            myfile.writelines(lines)
            myfile.write('\n')
            continue
    #else:
    #    continue

myfile.close()
