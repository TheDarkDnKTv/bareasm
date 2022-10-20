BUILD_PATH=./build
SRC_PATH=./src

all:
	nasm -f elf32 -o $(BUILD_PATH)/bootloader.o $(SRC_PATH)/bootloader.ASM
	gcc -m32 -c -g -fno-pic -no-pie -ffreestanding -nostdlib -nostdinc -Wall -Werror -o $(BUILD_PATH)/main.o $(SRC_PATH)/main.c
	ld -static -nostdlib -build-id=none -T linker16.ld -o $(BUILD_PATH)/bootloader.elf $(BUILD_PATH)/bootloader.o
	ld -static -nostdlib -build-id=none -T linker32.ld -o $(BUILD_PATH)/main.elf $(BUILD_PATH)/main.o
	objcopy -O binary $(BUILD_PATH)/bootloader.elf $(BUILD_PATH)/bootloader.bin
	objcopy -O binary $(BUILD_PATH)/main.elf $(BUILD_PATH)/main.bin
	cat $(BUILD_PATH)/bootloader.bin $(BUILD_PATH)/main.bin > $(BUILD_PATH)/bareasm.img