import pandas as pd
from unidecode import unidecode

PATH = 'script/geonames-all-cities-with-a-population-1000@public.csv'
MIN_POPULATION = 10_000

data = pd.read_csv(PATH, sep=';')

mask = data['Population'] >= MIN_POPULATION
data = data[mask]
data = data[['Name', 'Coordinates']]

def normalize(row):
    coordinates = row[1].split(', ')
    name = unidecode(row[0]).lower()
    return [name, (float(coordinates[0]), float(coordinates[1]))]

data = data.apply(normalize, axis=1, result_type='expand')
data.columns = ['name', 'coordinates']

def stringify(row):
    result = ''
    for x, y in row:
        result += f'{x}:{y},'

    if result == '':
        return ''
    else:
        return result[:-1]

data = data.groupby('name')['coordinates'].apply(stringify).reset_index(name='coordinates')

data.to_csv('assets/data/cities.csv', index=False, sep=';')
