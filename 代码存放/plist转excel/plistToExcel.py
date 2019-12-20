import xlsxwriter

from biplist import *
try:
	plist = readPlist("YLLanguage.plist")
	# print plist
	language = plist['Language']
	# print language

	workbook = xlsxwriter.Workbook('language.xlsx')
	worksheet = workbook.add_worksheet()

	languageType = {'B':'en', 'C':'zh-Hans', 'D':'zh-Hant', 'E':'es'}
	worksheet.write('A1', "key")
	
	for i in languageType:
		worksheet.write('%s1' % i, languageType[i])
	
	index = 2
	for i in language:
		print "dict[%s] = " % i,language[i]
		worksheet.write('A%d' % index, i)
		for j in languageType:
			position = '%s%s' % (j,index)
			worksheet.write(position, language[i][languageType[j]])
		index = index + 1
	workbook.close()

except (InvalidPlistException, NotBinaryPlistException), e:
	print "Not a plist:", e

