file=2_4
start:
	@nasm -f elf64 $(file).asm
	@ld $(file).o -o test.exe
	@./test.exe
	@rm test.exe
	@rm $(file).o
clean:
	@rm test.exe
	@rm $(file).o
