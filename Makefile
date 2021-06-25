CC = ./toolchain/compiler/bin/i686-elf-gcc
LD = $(CC)
NASM = nasm
ISO_FILE = PlatypusOS.iso
KERNEL_FILE = kernel.bin
INITRD_FILE = initrd.img
INCLUDE = -I$(PWD) -I./kernel/ -I./kernel/cpu/ -I./kernel/drivers/ -I./kernel/fs/ -I./kernel/kernel/ -I./kernel/include/ -I./user/

CFLAGS = $(INCLUDE)
NASMFLAGS = -f elf32
LDFLAGS = -T./kernel/arch/i386/linker.ld -ffreestanding -O2 -nostdlib

C_SOURCES = $(shell find init/ initrd/ kernel/ lib/ user/ -name '*.c')
ASM_SOURCES = $(shell find kernel/ -name '*.asm')
OBJ_FILES = $(C_SOURCES:.c=.o) $(ASM_SOURCES:.asm=.o)

$(ISO_FILE): $(KERNEL_FILE)
	 gcc -o ./scripts/gen_initrd ./scripts/gen_initrd.c
	 ./scripts/gen_initrd initrd/file.txt initrd/file.txt initrd/file2.txt initrd/file2.txt
	 @echo "MKDIR"
	 mkdir -p isodir/boot/grub/
	 @echo "CP"
	 cp grub.cfg isodir/boot/grub/
	 cp kernel.bin initrd.img isodir/boot/
	 @echo "GRUB-MKRESCUE"
	 grub-mkrescue -o PlatypusOS.iso isodir

$(KERNEL_FILE): kernel/arch/i386/boot.o $(OBJ_FILES)
	 @echo "LD $^"
	 $(LD) $(LDFLAGS) $^ -o $@

kernel/arch/i386/boot.o: kernel/arch/i386/boot.asm
	  $(NASM) $(NASMFLAGS) $< -o $@

%.o: %.c
	  @echo "CC $<"
	  $(CC) $(CFLAGS) -c $< -o $@

%.o: %.asm
	  @echo "NASM $<"
	  $(NASM) $(NASMFLAGS) $< -o $@

clean:
	  @echo "Cleaning"
	  rm -rf isodir/ $(KERNEL_FILE) $(INITRD_FILE) $(ISO_FILE) $(OBJ_FILES)

run:
	  qemu-system-x86_64 -soundhw pcspk $(ISO_FILE)
