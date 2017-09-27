import sys
import pandas
import matplotlib.pyplot as plt

script = sys.argv[0]
file_paths = sys.argv[1:]
#file_path = 'usertable20170223.xlsx'
extras = []

## options
# gluster (filter on gluster jobs)
# username(s)

# clip early/late bins
clip = True
front_clip = 1
late_clip = -1

# set bin size
bin_size = 3

def bin_times(hr):
	if hr > 72:
		hr = 72 + bin_size
	while hr % bin_size != 0:
		hr += 1
	return hr

def data_clean(file_path): 
	# load file + extract relevant columns
	xlsx_file = pandas.ExcelFile(file_path)
	sheet_name = xlsx_file.sheet_names[0]
	data = xlsx_file.parse(sheetname = sheet_name, skiprows = [1])
	extract_cols = ['User','Uniq Job Ids','25%','Median','75%','Max']
	extract_cols.extend(extras)
	data = data[extract_cols]
	# optional filter step
	# melt data
	ids = ['User','Uniq Job Ids']
	ids.extend(extras)
	values = ['25%','Median','75%','Max']
	data = pandas.melt(data, id_vars=ids, value_vars=values)
	# clean columns (hours + job ids) and add Bins
	quarter = lambda x: int(x/4)
	data['Quart Job Ids'] = data['Uniq Job Ids'].apply(quarter)
	split_hour = lambda s: int(s.split(':')[0]) + 1
	data['Hours'] = data['value'].apply(split_hour)
	binner = lambda x: bin_times(x)
	data['Bins'] = data['Hours'].apply(binner)
	# reduce to final selection
	final_cols = ['User','Quart Job Ids','Bins']
	final_cols.extend(extras)
	data = data[final_cols]
	return data

def group_bins(data):
	group_cols = ['Bins']
	grouped_data = data.groupby(group_cols).sum()
	grouped_data = grouped_data.reset_index()
	# reset index
	# option to clip early/late bins (print removed data)
	if clip:
		grouped_data = grouped_data.loc[front_clip:,:]
	return grouped_data

def plot_it(grouped_data):
	x_vals = grouped_data['Bins'].tolist()
	y_vals = grouped_data['Quart Job Ids'].tolist()
	
	print(x_vals)
	print(y_vals)
	
	plt.bar(left=x_vals, height=y_vals, width=4, color="green", tick_label=x_vals, align='center')
	
	plt.show()

def main():
	d = pandas.DataFrame()
	for fp in file_paths:
		d = pandas.concat([d, data_clean(fp)])
	group_d = group_bins(d)
	print(group_d)
	plot_it(group_d)

main()

