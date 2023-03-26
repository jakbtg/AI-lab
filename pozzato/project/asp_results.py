import re

# open file 'asp_out.txt' and read the output
with open('/Users/jak/Documents/Uni/IALab/AI-lab/pozzato/project/asp_out.txt', 'r') as f:
    line = f.readline()
    result = line.split()
    days = []
    for element in result:
        if re.match(r'assegna', element):
            days.append(element)
            # print(f'{i}: {element}')


total_days = len(days)
print(f'Are there 380 matches? {total_days == 380}')

# create matrix 380x3 (380 matches, 3 columns: day, home team, away team)
final_calendar = []
for element in days:
    day = re.findall(r'\d+', element)
    day = int(day[0])
    home_team = re.findall(r'(?<=\().*?(?=\,)', element)
    home_team = home_team[0].replace('partita(', '')
    away_team = re.findall(r'(?<=\,).*?(?=\))', element)
    away_team = away_team[0]
    final_calendar.append([day, home_team, away_team])

# sort the calendar by day
final_calendar.sort(key=lambda x: x[0])

# check if there are 10 matches per day
error = False
for i in range(1, 39):
    count_matches_per_day = {}
    for element in final_calendar:
        if element[0] == i:
            count_matches_per_day[element[0]] = count_matches_per_day.get(element[0], 0) + 1
    if count_matches_per_day[i] != 10:
        print(f'Error: {count_matches_per_day[i]} matches on day {i}')
        error = True
if not error:
    print('There are 10 matches per each day')

# check number of matches for each team
teams = ['napoli', 'milan', 'inter', 'juventus', 'atalanta', 'roma', 'lazio', 'fiorentina', 'sassuolo', 'torino', 'udinese', 'bologna', 'monza', 'empoli', 'salernitana', 'lecce', 'spezia', 'hellas_verona', 'sampdoria', 'cremonese']
for team in teams:
    count_matches = 0
    for element in final_calendar:
        if re.search(team, element[1]) or re.search(team, element[2]):
            count_matches += 1
    print(f'{team}: {count_matches}')

# print the final calendar
# print(final_calendar)

# create an output file 
headers = ['Giornata', 'Squadra Casa', 'Squadra Ospite']
with open('/Users/jak/Documents/Uni/IALab/AI-lab/pozzato/project/asp_final_calendar.tsv', 'w') as f:
    f.write('\t'.join(headers) + '\n')
    i = 1
    for element in final_calendar:
        f.write('\t'.join(map(str, element)) + '\n')
        i += 1
        if i == 11:
            f.write('-'*50 + '\n')
            i = 1


# # print all fiorentina matches
# fio_matches = []
# for match in days:
#     if re.search(r'fiorentina', match):
#         fio_matches.append(match)
#         print(match)
# print(f'Total Fiorentina matches: {len(fio_matches)}')