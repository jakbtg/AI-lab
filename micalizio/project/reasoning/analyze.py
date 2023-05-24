import re
from prettytable import PrettyTable

with open ('micalizio/project/reasoning/result.txt', 'r') as f:
    lines = f.readlines()

# print(lines)

# find total number of guesses
total_guesses = 0
for line in lines:
    if re.search(r'guess', line, re.IGNORECASE):
        total_guesses += 1

print(f'Total guesses: {total_guesses}')

# find total number of water cells
total_water_cells = 0
for line in lines:
    if re.search(r'water', line, re.IGNORECASE) and re.search(r'fill', line, re.IGNORECASE):
        total_water_cells += 1

print(f'Total water cells: {total_water_cells}')

# create grid 10x10
grid = []
for i in range(10):
    grid.append(['   '] * 10)

for line in lines:
    if re.search(r'guess', line, re.IGNORECASE):
        # find coordinates: row is after '[' and before ','
        # find coordinates: column is after ',' and before ']'
        row = re.search(r'\[(\d)', line).group(1)
        column = re.search(r'(\d)\]', line).group(1)
        x = int(row)
        y = int(column)
        grid[x][y] = '⛵️'

# for line in lines:
    if re.search(r'water', line, re.IGNORECASE) and re.search(r'fill', line, re.IGNORECASE):
        # find coordinates: row is after '[' and before ','
        # find coordinates: column is after ',' and before ']'
        row = re.search(r'\[(\d)', line).group(1)
        column = re.search(r'(\d)\]', line).group(1)
        x = int(row)
        y = int(column)
        grid[x][y] = '🌊'

# check number of sunk boats
sunk_one = 0
sunk_two = 0
sunk_three = 0
sunk_four = 0
for line in lines:
    if re.search(r'sink', line, re.IGNORECASE):
        if re.search(r'one', line, re.IGNORECASE):
            sunk_one += 1
        if re.search(r'two', line, re.IGNORECASE):
            sunk_two += 1
        if re.search(r'three', line, re.IGNORECASE):
            sunk_three += 1
        if re.search(r'four', line, re.IGNORECASE):
            sunk_four += 1

print(f'Sunk sub: {sunk_one}')
print(f'Sunk two-pieces: {sunk_two}')
print(f'Sunk three-pieces: {sunk_three}')
print(f'Sunk four-pieces: {sunk_four}')

# print the grid with pretty table
table = PrettyTable()
table.field_names = [' ', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
for i in range(10):
    table.add_row([i, grid[i][0], grid[i][1], grid[i][2], grid[i][3], grid[i][4], grid[i][5], grid[i][6], grid[i][7], grid[i][8], grid[i][9]])


print(table)




