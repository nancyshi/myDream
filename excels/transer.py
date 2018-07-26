import xlrd,json
path = "/Users/haoyun/Documents/XcodeProjects/myDream/excels/houseConfig.xlsx"
workbook = xlrd.open_workbook(path)

sheetNames = workbook.sheet_names()
for name in sheetNames :
	sheet = workbook.sheet_by_name(name)

	dicData = []
	for oneRow in range(2,sheet.nrows):   # first row is the name of data , second row is type of data
		dic = {}
		for oneCol in range(0,sheet.ncols):
			dataName = sheet.cell_value(0,oneCol)
			dataValue = sheet.cell_value(oneRow,oneCol)
			dataType = sheet.cell_value(1,oneCol)
			if dataType == "int":
				dataValue = int(dataValue)
			dic[dataName] = dataValue
		dicData.append(dic)

	jsonStr = json.dumps(dicData,indent = 2)
#	print(jsonStr)
	
	with open("%s.json" % name,"w") as f:
		f.write(jsonStr)
		f.close()

