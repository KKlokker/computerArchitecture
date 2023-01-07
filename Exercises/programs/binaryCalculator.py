import math


def binaryDecimal(binary):
    decimal = 0
    for i in range(len(binary)-1,-1,-1):
        decimal += int(math.pow(2,len(binary)-i-1))*int(binary[i])
    return decimal

def decimalToBinaryRecursion(num):
    if num >= 1:
        return str(num % 2) + decimalToBinaryRecursion(num // 2)
    else :
        return ""
def decimalToBinary(num):
    inverted = decimalToBinaryRecursion(num)
    return inverted[::-1]

def twosComplimentDecimal(binary):
    decimal = -int(math.pow(2,len(binary)-1))*int(binary[0])
    for i in range(len(binary)-1,0,-1):
        decimal += int(math.pow(2,len(binary)-i-1))*int(binary[i])
    return decimal

def binaryInfo(binary):
    print("Binary to decimal: ",binaryDecimal(binary))
    print("Twos compliment decimal: ",twosComplimentDecimal(binary))

def binaryToFloat(binary, showCalculaitons=False):
    binary = binary.replace(" ", "")
    sign = math.pow(-1,int(binary[0]))
    power = binaryDecimal(binary[1:9])-127
    decimal = 1
    for i in range(len(binary[9:23])):
        decimal += int(binary[9+i])*math.pow(2,-i-1)
    if showCalculaitons:
        print("Sign:",sign)
        print("Power:",binary[1:9],"- 127 =",power)
        print("Decimal:","1." + str(binary[9:23]),"=", decimal)
        signPrint = "+" if sign == 1 else "-"
        print(signPrint,decimal,"*2^",power)

    return sign*math.pow(2,power)*decimal

def decToBinConversion(no, precision): 
    binary = ""  
    IntegralPart = int(no)  
    fractionalPart = no- IntegralPart
    #to convert an integral part to binary equivalent
    while (IntegralPart):
        re = IntegralPart % 2 
        binary += str(re)  
        IntegralPart //= 2
    binary = binary[ : : -1]    
    binary += '.'
    #to convert an fractional part to binary equivalent
    while (precision):
        fractionalPart *= 2
        bit = int(fractionalPart)
        if (bit == 1) :   
            fractionalPart -= bit  
            binary += '1'
        else : 
            binary += '0'
        precision -= 1
    return binary  

#IEE 754 32 bit
def floatToBinary(float):
    sign = "0" if float > 0 else "1" 
    floatBin = decToBinConversion(float, 24)
    power = floatBin.find(".")-1+127
    power = decimalToBinary(power)
    floatBin = floatBin.replace(".","")
    return sign + " " + power + " " + floatBin[1:24]

#IEE 754 64 bit
def doubleToBinary(float):
    sign = "0" if float > 0 else "1" 
    floatBin = decToBinConversion(float, 53)
    power = floatBin.find(".")-1+1023
    power = decimalToBinary(power)
    floatBin = floatBin.replace(".","")
    return sign + " " + power + " " + floatBin[1:53]

def invertTwosCompliment(binary):
    result = ""
    for i in binary:
        result += "0" if i == "1" else "1"
    sum = ""
    carry = 1
    for i in range(len(result)-1,-1,-1):
        y = result[i]
        res = int(y) + carry
        carry = 1 if res > 1 else 0
        sum = str(res % 2) + sum
    return sum

def floatBinAddtion(x, y):
    x = x.replace(" ","")
    y = y.replace(" ", "")
    if round(binaryToFloat(x),12) == 0:
        print("Since x is 0 the result is y")
        print("Result is ", y)
        return
    if round(binaryToFloat(y),12) == 0:
        print("Since y is 0 the result is x")
        print("Result is ", x)
        return
    xs = x[0]
    ys = y[0]
    xe = binaryDecimal(x[1:9])-127
    ye = binaryDecimal(y[1:9])-127
    xm = x[9:]
    xm = "1"+xm
    ym = y[9:]
    ym = "1"+ym
    print("X exponent: ", xe)
    print("Y exponent: ", ye)
    print("X fraction: ", xm)
    print("Y fraction: ", ym)
    if xe != ye:
        print("First align mantisse")
        if xe < ye:
            print("Add", ye-xe ,"zero(es) to X to align")
            xm = "0"*(ye-xe) + xm
            print("X fraction:", xm)
        else:
            print("Add", xe-ye ,"zero(es) to Y to align")
            ym = "0"*(xe-ye) + ym
            print("Y fraction:", ym)
    
    if xs != ys:
        if xs == "1":
            print("Since X is negative it is changed into twos compliment to make it negative")
            xm = invertTwosCompliment(xm)
        if ys == "1":
            print("Since Y is negative it is changed into twos compliment to make it negative")
            ym = invertTwosCompliment(ym)


    print("Adding X fraction and Y fraction")
    print(xm)
    print(ym)
    sum = ""
    carry = 0
    for i in range(max(len(ym)-1,len(xm)-1),-1,-1):
        yValue = ym[i] if len(ym) > i else "0"
        xValue = xm[i] if len(xm) > i else "0"
        res = int(yValue) + int(xValue) + carry
        carry = 1 if res > 1 else 0
        sum = str(res % 2) + sum
    if carry == 1:
        sum = "1" + sum
    print("Sum: ", sum)
    if xs != ys:
        print("Since one is negative and another is positive the first bit is removed from the sum")
        sum = sum[1:]
        if sum[1] == 0:
            print("The first bit of the sum is zero making it positive and the result therefore have to be positive")
            xs = "0"
        else:
            print("The first bit of the sum is one making it negative and the result therefore have to be negative")
            xs = "1"
            
    print("Convert sum back into IEEE 754 format, by removing the first 1 if the sum and using the largest exponent")
    result = xs + " " + decimalToBinary(max(xe,ye)+127) + " " + sum[1:24]
    if binaryToFloat(x) + binaryToFloat(y) != binaryToFloat(result):
        print("Some overflow occoured or precision error")
        print(binaryToFloat(x), "+", binaryToFloat(y), "!=", binaryToFloat(result))
    return(result)

def hexToInt(hex):
    return int(hex, 16)

def decToTwosCompliment(number):
    if number < 0:
        mostSignificant = math.ceil(math.log2(-number))
        mostValue = math.pow(2,mostSignificant)
        restBin = decimalToBinary(int(mostValue+number))
        while len(restBin) < mostSignificant:
            restBin = "0" + restBin
        restBin = "1" + restBin
        return restBin
    else:
        return "0" + decimalToBinary(number)
    

#print(decimalToBinary(11))
#print(floatToBinary(191.625))
#print(floatBinAddtion("0 1000 0011 1011 0101 000000000000000" , "0 1000 1001 0011 1010 000000000000000"))
#print(decimalToBinary(hexToInt("6d")))
#print("Float value of decimal value of 191.625: ", binaryToFloat(floatToBinary(0)))
#print("Float value: ", binaryToFloat("0 1000 0000 1100 1100 1100 1100 1100 110"))
#binaryInfo("1011")
#print(floatBinAddtion(" 0111 0001 0011 0100 000000000000000" , "0 0111 0011 1001 1000 000000000000000"))
print(twosComplimentDecimal(decToTwosCompliment(142)))