import re

# open file 'asp_out.txt' and read the output
with open('/Users/jak/Documents/Uni/IALab/AI-lab/pozzato/project/asp_out.txt', 'r') as f:
    line = f.readline()
    result = line.split()
    i = 1
    assegna = []
    for element in result:
        if re.match(r'assegna', element):
            assegna.append(element)
            # print(f'{i}: {element}')
        i += 1

# total_matches = len(matches)
# print(f'Total matches: {total_matches}')

total_assegna = len(assegna)
print(f'Total assegna: {total_assegna}')

# create an output file 
columns = ['Giornata', 'Squadra Casa', 'Squadra Ospite']
with open('/Users/jak/Documents/Uni/IALab/AI-lab/pozzato/project/asp_final_calendar.tsv', 'w') as f:
    f.write('\t'.join(columns) + '\n')
    for match in assegna:
        match = match.replace('assegna(partita(', '')
        match = match.replace(')', '')
        match = match.replace(',', '\t')
        f.write(match + '\n')





# print all fiorentina matches
fio_matches = []
for match in assegna:
    if re.search(r'fiorentina', match):
        fio_matches.append(match)
        print(match)
print(f'Total Fiorentina matches: {len(fio_matches)}')