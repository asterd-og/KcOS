#######################
#all: main.c out.o    #
#$@ = all             #
#$< = main.c          #
#$^ = main.c out.o    #
#######################

GCC=i686-elf-gcc

GFLAGS=-ffreestanding \
	   -Isrc/include  \
	   -std=gnu99 	  \
	   -g

ASFLAGS=-ffreestanding \
		-std=gnu99	   \
		-g

LDFLAGS=-ffreestanding \
		-nostdlib 	   \
		-g			   \
		-Tlinker.ld

OBJS=out/boot/boot.o   \
	 out/kernel/kernel.o \
	 out/system/terminal.o

OUT=out/kcos.bin

SOURCES:=$(wildcard src/boot/*.s src/kernel/*.c src/system/*.c)
OBJECTS:=$(patsubst src/boot/%.s, out/boot/%.o, $(SOURCES))
OBJECTS+=$(patsubst src/kernel/%.c, out/kernel/%.o, $(SOURCES))
OBJECTS+=$(patsubst src/system/%.c, out/system/%.o, $(SOURCES))

all: run
	@echo done

run: link
	qemu-system-i386 -kernel $(OUT)

link: $(OBJECTS)
	$(GCC) $(LDFLAGS) $(OBJS) -o $(OUT) -lgcc

out/boot/%.o: src/boot/%.s
	$(GCC) $(ASFLAGS) -c $< -o $@

out/kernel/%.o: src/kernel/%.c 
	$(GCC) $(GFLAGS) -c $< -o $@

out/system/%.o: src/system/%.c 
	$(GCC) $(GFLAGS) -c $< -o $@

clean:
	@del /s /q out\kernel\*.o
	@del /s /q out\boot\*.o
	@del /s /q out\system\*.o
#	del /s /q out\kcos.bin