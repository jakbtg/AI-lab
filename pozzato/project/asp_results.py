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
print(f'Total assegna: {total_days}')

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
print(final_calendar)

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