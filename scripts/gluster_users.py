import sys
import pandas
import sqlite3


script = sys.argv[0]
file_path = sys.argv[1]

data = pandas.read_csv(file_path)

split_username = lambda s: s.split('/')[3]
data['username'] = data['Directory'].apply(split_username)

split_unit = lambda s: s[-1]
data['unit'] = data['Size'].apply(split_unit)
split_num = lambda s: s[:-1]
data['value'] = data['Size'].apply(split_num)
#def size_in_MB(row):
#	if row['unit'] == 'T':
#		mb = row['value']*1024*1024
#	elif row['unit'] == 'G':
#		mb = row['value']*1024
#	elif row['unit'] == 'M': 
#		mb = row['value']
#	elif row['unit'] == 'K':
#		mb = row['value']/1024
#	return mb
#data['size_in_MB'] = data.apply(size_in_MB, axis=1)

projects = pandas.read_csv('2016_365_users.csv')
data = pandas.merge(data, projects, how='left', on='username')

db = sqlite3.connect('/Users/ckoch/Code/r_chtc_sheets/data/dictionary.db')
depts = pandas.read_sql('SELECT project, dept FROM projects', db)
db.close()
data = pandas.merge(data, depts, how='left', on='project')

data.to_csv('final_data.csv', index=False)

#print(data)
#print(data.columns.values)


	
#data = pandas.merge(hours, projects, on='project')
