import re
from prettytable import PrettyTable

with open ('micalizio/project/reasoning/result.txt', 'r') as f:
    lines = f.readlines()

# find total pieces per column and row
pieces_per_row = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0}
pieces_per_column = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0}
for line in lines:
    if re.search(r'know that column', line, re.IGNORECASE):
        pieces_per_column[int(re.search(r'column (\d)', line).group(1))] = int(re.search(r'(\d) pieces', line).group(1))
    if re.search(r'know that row', line, re.IGNORECASE):
        pieces_per_row[int(re.search(r'row (\d)', line).group(1))] = int(re.search(r'(\d) pieces', line).group(1))

print(f'Initial pieces per row: {pieces_per_row}')
print(f'Initial pieces per column: {pieces_per_column}')

# empty cells per row and column
empty_cells_per_row = {0: 10, 1: 10, 2: 10, 3: 10, 4: 10, 5: 10, 6: 10, 7: 10, 8: 10, 9: 10}
empty_cells_per_column = {0: 10, 1: 10, 2: 10, 3: 10, 4: 10, 5: 10, 6: 10, 7: 10, 8: 10, 9: 10}

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
        pieces_per_row[x] -= 1
        pieces_per_column[y] -= 1
        empty_cells_per_row[x] -= 1
        empty_cells_per_column[y] -= 1

# for line in lines:
    if re.search(r'water', line, re.IGNORECASE) and (re.search(r'fill', line, re.IGNORECASE) or re.search(r'deduce', line, re.IGNORECASE)):
        # find coordinates: row is after '[' and before ','
        # find coordinates: column is after ',' and before ']'
        row = re.search(r'\[(\d)', line).group(1)
        column = re.search(r'(\d)\]', line).group(1)
        x = int(row)
        y = int(column)
        grid[x][y] = '🌊'
        empty_cells_per_row[x] -= 1
        empty_cells_per_column[y] -= 1

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

sink_table = PrettyTable()
sink_table.field_names = ['Boat', 'Sunk']
sink_table.add_row(['Sub', sunk_one])
sink_table.add_row(['Two-pieces', sunk_two])
sink_table.add_row(['Three-pieces', sunk_three])
sink_table.add_row(['Four-pieces', sunk_four])
print(sink_table)

# check number of fire used
fire_used = 0
for line in lines:
    if re.search(r'fire', line, re.IGNORECASE):
        fire_used += 1

print(f'Fire used: {fire_used}')

# print the grid with pretty table
table = PrettyTable()
table.field_names = [' ', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'Pieces left', 'Empty cells']
for i in range(9):
    table.add_row([i, grid[i][0], grid[i][1], grid[i][2], grid[i][3], grid[i][4], grid[i][5], grid[i][6], grid[i][7], grid[i][8], grid[i][9], pieces_per_row[i], empty_cells_per_row[i]])
table.add_row([9, grid[9][0], grid[9][1], grid[9][2], grid[9][3], grid[9][4], grid[9][5], grid[9][6], grid[9][7], grid[9][8], grid[9][9], pieces_per_row[9], empty_cells_per_row[9]], divider=True)
table.add_row(['Pieces left', pieces_per_column[0], pieces_per_column[1], pieces_per_column[2], pieces_per_column[3], pieces_per_column[4], pieces_per_column[5], pieces_per_column[6], pieces_per_column[7], pieces_per_column[8], pieces_per_column[9], '', ''])
table.add_row(['Empty cells', empty_cells_per_column[0], empty_cells_per_column[1], empty_cells_per_column[2], empty_cells_per_column[3], empty_cells_per_column[4], empty_cells_per_column[5], empty_cells_per_column[6], empty_cells_per_column[7], empty_cells_per_column[8], empty_cells_per_column[9], '', ''])
print(table)




