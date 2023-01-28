OBJS = sorter.o parseFile.o sortingAlgo.o
ASFLAGS = --gstabs

sorter: $(OBJS)
	ld -o sorter $^

.PHONY:  clean, output, test, benchmark
clean:
	rm -f *.o sorter

output: sorter
	./sorter numbers.txt > output.txt
test: sorter
	javac test.java
	echo ''
	java -Xms1024m -Xmx4096m test
	echo ''
	rm -f *.class
	make clean

benchmark: sorter
	for i in {1..10000}; do echo -e "$$RANDOM\t$$RANDOM"; done > numbers.txt
	time ./sorter numbers.txt > /dev/null
	for i in {1..50000}; do echo -e "$$RANDOM\t$$RANDOM"; done > numbers.txt
	time ./sorter numbers.txt > /dev/null
	for i in {1..100000}; do echo -e "$$RANDOM\t$$RANDOM"; done > numbers.txt
	time ./sorter numbers.txt > /dev/null
	for i in {1..500000}; do echo -e "$$RANDOM\t$$RANDOM"; done > numbers.txt
	time ./sorter numbers.txt > /dev/null
	for i in {1..1000000}; do echo -e "$$RANDOM\t$$RANDOM"; done > numbers.txt
	time ./sorter numbers.txt > /dev/null




