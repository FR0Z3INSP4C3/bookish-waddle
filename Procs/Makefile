build = 2_4.o

all: build

build: $(build)
	ld -m elf_x86_64 $(build)

%.o: %.asm
	nasm -f elf64 $< -o $@

clean:
	@rm -vf *.o *.out *.exe
