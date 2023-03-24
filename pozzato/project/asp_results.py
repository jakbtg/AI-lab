import re

# open file 'asp_out.txt' and read the output
with open('/Users/jak/Documents/Uni/IALab/AI-lab/pozzato/project/asp_out.txt', 'r') as f:
    line = f.readline()
    result = line.split()
    i = 1
    for match in result:
        print(f'{i}: {match}')
        i += 1

total_matches = len(result)
print(f'Total matches: {total_matches}')
# find total matches of fiorentina team using regex
fio_matches = len(re.findall(r'fiorentina', line))
# find total matches of roma team using regex
roma_matches = len(re.findall(r'roma', line))

print(f'Fiorentina matches: {fio_matches}')
print(f'Roma matches: {roma_matches}')