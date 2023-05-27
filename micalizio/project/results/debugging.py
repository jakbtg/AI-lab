import re

with open ('micalizio/project/results/debug.txt', 'r') as f:
    lines = f.readlines()

# sort lines given cells in brackets [row, column]
lines = sorted(lines, key=lambda x: (int(re.search(r'\[(\d),', x).group(1)), int(re.search(r'(\d)\]', x).group(1))))

i = 0
print('Sorted lines:')
for line in lines:
    print(line, end='')
    i += 1
print()
print(f'Total lines: {i}')
