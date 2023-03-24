import re

# open file 'asp_out.txt' and read the output
with open('/Users/jak/Documents/Uni/IALab/AI-lab/pozzato/project/asp_out.txt', 'r') as f:
    line = f.readline()
    result = line.split()
    i = 1
    # matches = []
    assegna = []
    for element in result:
        # if re.match(r'partita', element):
        #     matches.append(element)
        #     print(f'Match {i}: {element}')
        if re.match(r'assegna', element):
            assegna.append(element)
            print(f'{i}: {element}')
        i += 1

# total_matches = len(matches)
# print(f'Total matches: {total_matches}')

total_assegna = len(assegna)
print(f'Total assegna: {total_assegna}')

# print all fiorentina matches
for match in assegna:
    if re.search(r'fiorentina', match):
        print(match)
