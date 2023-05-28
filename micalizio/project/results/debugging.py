import re
from prettytable import PrettyTable

with open ('micalizio/project/results/debug.txt', 'r') as f:
    lines = f.readlines()

# sort lines given cells in brackets [row, column]
# lines = sorted(lines, key=lambda x: (int(re.search(r'\[(\d),', x).group(1)), int(re.search(r'(\d)\]', x).group(1))))

# i = 0
# print('Sorted lines:')
# for line in lines:
#     print(line, end='')
#     i += 1
# print()
# print(f'Total lines: {i}')

# used to debug work of another agent
grid = []
for i in range(10):
    grid.append(['   '] * 10)


for line in lines:
    x = int(re.search(r'\[(\d)', line).group(1))
    y = int(re.search(r'(\d)\]', line).group(1))
    grid[x][y] = '⛵️'

table = PrettyTable()
table.field_names = [' ', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
for i in range(10):
    table.add_row([i] + grid[i])

print(table)
