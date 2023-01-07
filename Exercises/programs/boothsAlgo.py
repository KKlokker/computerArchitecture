# function to perform adding in the accumulator
def add(ac, x, qrn):
	c = 0
	for i in range(qrn):
		
		# updating accumulator with A = A + BR
		ac[i] = ac[i] + x[i] + c
		
		if (ac[i] > 1):
			ac[i] = ac[i] % 2
			c = 1
		
		else:
			c = 0

# function to find the number's complement
def complement(a, n):
	x = [0] * (n+1)
	x[0] = 1
	for i in range(n):
		a[i] = (a[i] + 1) % 2
	add(a, x, n)


# function to perform right shift
def rightShift(ac, qr, qn, qrn):

	temp = ac[0]
	qnTemp = qr[0]
	
	print(" rightShift & ", end = "")
	
	for i in range(qrn - 1):
		ac[i] = ac[i + 1]
		qr[i] = qr[i + 1]

	
	qr[qrn - 1] = temp
	return qnTemp


# function to display operations
def display(ac, qr, qrn):

	# accumulator content
	for i in range(qrn - 1, -1, -1):
		print(ac[i], end = '')
		if i % 4 == 0:
			print(" ", end='')
	print(" & ", end = '')

	# multiplier content
	for i in range(qrn - 1, -1, -1):
		print(qr[i], end = "")
		if i % 4 == 0:
			print(" ", end='')

def writeList(list):
	output = ""
	for i in list:
		output = str(i) + output
	return output

# Function to implement booth's algo
def boothAlgorithm(br, qr, mt, qrn, sc,brn):

	qn = 0
	ac = [0] * 10
	temp = 0
	print("\\begin{table}[h!]")
	print("\\begin{tabular}{|l|l|l|l|l|l|}")
	print("multiplicand:",writeList(br),"& Multiplier:",writeList(qr),"\\\\")
	print("\hline")
	print("Q[0] & Q-1 & Log & A & Q & SC\\\\")
	print("\hline")
	print(qr[0],"&",qn,"& initial & ", end = "")
	
	display(ac, qr, qrn)
	print(" & ", sc, "\\\\", sep = "")
	print("\hline")
	
	while (sc != 0):
		print(qr[0], " & ", qn, " & ", sep = "", end = "")
		# SECOND CONDITION
		if ((qn + qr[0]) == 1):
		
			if (temp == 0):
				
				# subtract BR from accumulator
				add(ac, mt, qrn)
				print("A = A - M &", end = "")
				
				display(ac, qr, qrn)
				print("&\\\\")
				print("\\hline")

				temp = 1
			
			
			# THIRD CONDITION
			elif (temp == 1):
			
				# add BR to accumulator
				add(ac, br, qrn)
				print("A = A + M & ", end = "")
				
				display(ac, qr, qrn)
				print("&\\\\")
				print("\\hline")
				temp = 0
			print("& & ", end="")
			qn = rightShift(ac, qr, qn, qrn)
		
		# FIRST CONDITION
		elif (qn - qr[0] == 0):
			qn = rightShift(ac, qr, qn, qrn)
		
		display(ac, qr, qrn)
		
		
		# decrement counter
		sc -= 1
		print(" & ", sc, "\\\\", sep = "")
		print("\\hline")
	
	print("\\end{tabular}")
	print("\\end{table}")
		
	print("\nResult = ", end = "")
	for i in range(brn - 1, -1, -1):
		print(ac[i], end = "")
	for i in range(qrn - 1, -1, -1):
		print(qr[i], end = "")

# driver code
def main():

	
	# Number of multiplicand bit
	brn = 5
	
	mt = [0] * brn

	# multiplicand
	br = [ 0,1,0,1,0]
	
	br.reverse()
	# copy multiplier to temp array mt[]
	for i in range(brn - 1, -1, -1):
		mt[i] = br[i]
	

	complement(mt, brn)
	# No. of multiplier bit
	qrn = 5
	
	# sequence counter
	sc = qrn
	
	# multiplier
	qr = [ 1,0,0,1,1]
	qr.reverse()

	boothAlgorithm(br, qr, mt, qrn, sc,brn)
		
main()
