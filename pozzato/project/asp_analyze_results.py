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

# check if there are 380 matches in the calendar
total_days = len(days)
if total_days == 380:
    print(f'There are 380 matches in the calendar')
else:
    print(f'Error: {total_days} matches in the calendar')

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

# add fake match -- for testing
# final_calendar.append([38, 'fiorentina', 'napoli'])

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
    if count_matches != 38:
        print(f'Error: {count_matches} matches for {team}')
        break
else:
    print('There are 38 total matches for each team')

# helper function to fill a dictionary of 38 elements with 0
def fill_dict():
    dict = {}
    for i in range(1, 39):
        dict[i] = 0
    return dict

# check if each team plays only once per day
error = False
for i in range(1, 39):
    for team in teams:
        count_matches_per_day = fill_dict()
        for element in final_calendar:
            if element[0] == i:
                if re.search(team, element[1]) or re.search(team, element[2]):
                    count_matches_per_day[element[0]] = count_matches_per_day.get(element[0], 0) + 1
        if count_matches_per_day[i] != 1:
            print(f'Error: {count_matches_per_day[i]} matches for {team} on day {i}')
            error = True
if not error:
    print('Each team plays only once per day')

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
