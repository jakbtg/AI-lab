import re
from prettytable import PrettyTable

with open ('micalizio/project/results/result.txt', 'r') as f:
    lines = f.readlines()


# last 8 lines for statistics
statistics = lines[-8:]
# exclude last 8 lines
lines = lines[:-8]

# first n lines --> fpr testing
# lines = lines[:556]

# empty cells per row and column
empty_cells_per_row = {0: 10, 1: 10, 2: 10, 3: 10, 4: 10, 5: 10, 6: 10, 7: 10, 8: 10, 9: 10}
empty_cells_per_column = {0: 10, 1: 10, 2: 10, 3: 10, 4: 10, 5: 10, 6: 10, 7: 10, 8: 10, 9: 10}

# find total pieces per column and row, total number of guesses, fire used and water cells
pieces_per_row = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0}
pieces_per_column = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0}
fire_used = 0
total_guesses = 0
total_water_cells = 0
# check number of sunk boats
sunk_one = 0
sunk_two = 0
sunk_three = 0
sunk_four = 0
for line in lines:
    if re.search(r'know that column', line, re.IGNORECASE):
        pieces_per_column[int(re.search(r'column (\d)', line).group(1))] = int(re.search(r'(\d) pieces', line).group(1))
    if re.search(r'know that row', line, re.IGNORECASE):
        pieces_per_row[int(re.search(r'row (\d)', line).group(1))] = int(re.search(r'(\d) pieces', line).group(1))
    if re.search(r'guess', line, re.IGNORECASE) and re.search(r'cell', line, re.IGNORECASE):
        total_guesses += 1
    if re.search(r'fire', line, re.IGNORECASE):
        fire_used += 1
    if re.search(r'water', line, re.IGNORECASE) and (re.search(r'fill', line, re.IGNORECASE) or re.search(r'deduce', line, re.IGNORECASE)):
        total_water_cells += 1
    if re.search(r'sink', line, re.IGNORECASE):
        if re.search(r'sub', line, re.IGNORECASE):
            sunk_one += 1
        if re.search(r'two', line, re.IGNORECASE):
            sunk_two += 1
        if re.search(r'three', line, re.IGNORECASE):
            sunk_three += 1
        if re.search(r'four', line, re.IGNORECASE):
            sunk_four += 1

print('Initial pieces per row: ', end='')
for value in pieces_per_row.values():
    print(value, end=' ')
print()
print('Initial pieces per column: ', end='')
for value in pieces_per_column.values():
    print(value, end=' ')
print()
print(f'Fire used: {fire_used}')
print(f'Total guesses: {total_guesses}')
print(f'Total water cells: {total_water_cells}')

# find number of known cells since the beginning, searching only the first 30 lines to avoid counting
# cells known after a fire. Considering that the first 20 lines are for the rows and columns content
# and considering that I could know a maximum of 10 cells since the beginning
num_known_cells_from_beginning = 0
for line in lines[:30]:
    if re.search(r'know that cell', line, re.IGNORECASE):
        num_known_cells_from_beginning += 1
print(f'Number of known cells since the beginning: {num_known_cells_from_beginning}')

# print sunk boats
sink_table = PrettyTable()
sink_table.field_names = ['Boat', 'Sunk', 'Total']
sink_table.add_row(['Sub', sunk_one, 4])
sink_table.add_row(['Two-pieces', sunk_two, 3])
sink_table.add_row(['Three-pieces', sunk_three, 2])
sink_table.add_row(['Four-pieces', sunk_four, 1])
print(sink_table)

# create grid 10x10
grid = []
for i in range(10):
    grid.append(['   '] * 10)

for line in lines:
    # if re.search(r'guess', line, re.IGNORECASE) and not re.search(r'best', line, re.IGNORECASE):
    if re.search(r'guess', line, re.IGNORECASE) and re.search(r'cell', line, re.IGNORECASE):
        row = re.search(r'\[(\d)', line).group(1)
        column = re.search(r'(\d)\]', line).group(1)
        x = int(row)
        y = int(column)
        grid[x][y] = '⛵️'
        pieces_per_row[x] -= 1
        pieces_per_column[y] -= 1
        empty_cells_per_row[x] -= 1
        empty_cells_per_column[y] -= 1
    if re.search(r'water', line, re.IGNORECASE) and (re.search(r'fill', line, re.IGNORECASE) or re.search(r'deduce', line, re.IGNORECASE)):
        row = re.search(r'\[(\d)', line).group(1)
        column = re.search(r'(\d)\]', line).group(1)
        x = int(row)
        y = int(column)
        grid[x][y] = '🌊'
        empty_cells_per_row[x] -= 1
        empty_cells_per_column[y] -= 1
        # print(line.strip()) # for testing

# find row and column ratio
row_ratio = []
column_ratio = []
for i in range(10):
    if empty_cells_per_row[i] == 0:
        row_ratio.append(0.0)
    if empty_cells_per_column[i] == 0:
        column_ratio.append(0.0)
    if empty_cells_per_row[i] != 0:
        row_ratio.append(round(pieces_per_row[i] / empty_cells_per_row[i], 2))
    if empty_cells_per_column[i] != 0:
        column_ratio.append(round(pieces_per_column[i] / empty_cells_per_column[i], 2))

# print the grid with pretty table
table = PrettyTable()
table.field_names = [' ', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'Pieces left', 'Empty cells', 'Row ratio']
for i in range(9):
    table.add_row([i, grid[i][0], grid[i][1], grid[i][2], grid[i][3], grid[i][4], grid[i][5], grid[i][6], grid[i][7], grid[i][8], grid[i][9], pieces_per_row[i], empty_cells_per_row[i], row_ratio[i]])
table.add_row([9, grid[9][0], grid[9][1], grid[9][2], grid[9][3], grid[9][4], grid[9][5], grid[9][6], grid[9][7], grid[9][8], grid[9][9], pieces_per_row[9], empty_cells_per_row[9], 
                row_ratio[9]], divider=True)
table.add_row(['Pieces left', pieces_per_column[0], pieces_per_column[1], pieces_per_column[2], pieces_per_column[3], pieces_per_column[4], pieces_per_column[5], pieces_per_column[6], 
               pieces_per_column[7], pieces_per_column[8], pieces_per_column[9], '', '', ''])
table.add_row(['Empty cells', empty_cells_per_column[0], empty_cells_per_column[1], empty_cells_per_column[2], empty_cells_per_column[3], empty_cells_per_column[4], empty_cells_per_column[5], 
               empty_cells_per_column[6], empty_cells_per_column[7], empty_cells_per_column[8], empty_cells_per_column[9], '', '', ''])
table.add_row(['Column ratio', column_ratio[0], column_ratio[1], column_ratio[2], column_ratio[3], column_ratio[4], column_ratio[5], column_ratio[6], column_ratio[7], column_ratio[8],
                column_ratio[9], '', '', ''])
print(table)

# print statistics
for line in statistics:
    print(line.strip())