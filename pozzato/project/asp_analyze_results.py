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
# final_calendar.append([38, 'fiorentina', 'fiorentina'])

# sort the calendar by day
final_calendar.sort(key=lambda x: x[0])

# check if no team plays against itself
error = False
for element in final_calendar:
    if element[1] == element[2]:
        print(f'Error: {element[1]} plays against itself on day {element[0]}')
        error = True
if not error:
    print('No team plays against itself')

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

# teams and respective cities
teams_cities = {'napoli': 'napoli', 'milan': 'milano', 'inter': 'milano', 'juventus': 'juventus', 'atalanta': 'brescia', 'roma': 'roma', 'lazio': 'lazio', 'fiorentina': 'firenze', 'sassuolo': 'sassuolo', 'torino': 'torino', 'udinese': 'udine', 'bologna': 'bologna', 'monza': 'monza', 'empoli': 'empoli', 'salernitana': 'salerno', 'lecce': 'lecce', 'spezia': 'spezia', 'hellas_verona': 'verona', 'sampdoria': 'genova', 'cremonese': 'cremona'}

# reset n_match_per_city_per_day dictionary to 0
def reset_dict():
    dict = {}
    for city in teams_cities.values():
        dict[city] = 0
    return dict

# check if only one from two teams from the same city plays per day
error = False
n_match_per_city_per_day = reset_dict()
for i in range(1, 39):
    for element in final_calendar:
        if element[0] == i:
            if element[1] in teams_cities:
                n_match_per_city_per_day[teams_cities[element[1]]] += 1
    for city in teams_cities.values():
        if n_match_per_city_per_day[city] > 1:
            print(f'Error: more than one match in {city} on day {i}')
            error = True
    n_match_per_city_per_day = reset_dict()
if not error:
    print('There is maximum one match per city per day')

# check number of days between home and away matches for each couple of teams
error = False
# create dictionary with teams couples as keys and 0 as values (e.g. {'napoli-milan': 0, 'napoli-inter': 0, ...})
teams_couples = {}
for team1 in teams:
    for team2 in teams:
        if team1 != team2:
            tmp1 = f'{team1}-{team2}'
            tmp2 = f'{team2}-{team1}'
            if not tmp1 in teams_couples and not tmp2 in teams_couples:
                teams_couples[f'{team1}-{team2}'] = 0

# for each couple of teams, check the number of days between home and away matches
for couple in teams_couples:
    team1 = couple.split('-')[0]
    team2 = couple.split('-')[1]
    for element in final_calendar:
        if re.search(team1, element[1]) and re.search(team2, element[2]):
            teams_couples[couple] = element[0] - teams_couples[couple]
        elif re.search(team2, element[1]) and re.search(team1, element[2]):
            teams_couples[couple] = element[0] - teams_couples[couple]
    if teams_couples[couple] < 10:
        print(f'Error: less than 10 days between matches between {couple} (days: {teams_couples[couple]})')
        error = True
if not error:
    print('There are at least 10 days between matches between each couple of teams')

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
