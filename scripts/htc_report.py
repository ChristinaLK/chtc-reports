## USAGE
# python htc_report.py filename options
# supported options: 72 and Gluster
# file is one of Greg's user reports

## LIBRARIES

import sys
import pandas

## GLOBAL VARIABLES

tables = ['projects','users']

script = sys.argv[0]
file_path = sys.argv[1]
options = sys.argv[2:]

attr_dict = {
			'72' : '72 Hour',
			'gluster' : 'WantGluster' 
			}

attributes = [attr_dict[opt.lower()] for opt in options]
print(attributes)

def measure(dat, attribute):
	return dat[dat[attribute]>0][attribute].sort_values(ascending = False)

def main():
	xlsx_file = pandas.ExcelFile(file_path)
	sheet_name = xlsx_file.sheet_names[0]
	
	data = xlsx_file.parse(sheetname = sheet_name, skiprows = [1], index_col='User')
	
	for attr in attributes:
		#print(attr)
		print(measure(data, attr))
	#print(data)

main()
