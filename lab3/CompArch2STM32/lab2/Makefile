# Toolchain and tools
SDK_PREFIX ?= arm-none-eabi-
CC        = $(SDK_PREFIX)gcc
LD        = $(SDK_PREFIX)ld
SIZE      = $(SDK_PREFIX)size
OBJCOPY   = $(SDK_PREFIX)objcopy

# QEMU config
QEMU      = qemu-system-gnuarmeclipse
BOARD     ?= STM32F4-Discovery
MCU       = STM32F407VG
TCP_ADDR  = 1234

# Target
TARGET    = firmware
CPU_CC    = cortex-m4

# Flags
CFLAGS    = -O0 -g3 -Wall
LDFLAGS   = -Wall --specs=nosys.specs -nostdlib -lgcc

# Paths
APP_PATH  = $(abspath ./)

# Source files
GASSRC    += start.S
GASSRC    += print.S
GASSRC    += bootloader.S

SOBJS     = $(GASSRC:.S=.o)
COBJS     = $(patsubst .c,%.o,$(APP_SRC))

# Search path
vpath % $(APP_PATH)

.PHONY: all clean flash qemu qemu_run

all: $(TARGET).bin $(COBJS) $(SOBJS) $(TARGET).elf kernel.bin

# Compile assembly files
%.o: %.S
	$(CC) -x assembler-with-cpp $(CFLAGS) -mcpu=$(CPU_CC) -c -o $@ $^

# Make kernel binary first for bootloader
bootloader.S: kernel.bin

# Link main ELF
$(TARGET).elf: $(COBJS) $(SOBJS)
	$(CC) -mcpu=$(CPU_CC) $(LDFLAGS) -T./lscript.ld -o $@ $^ $(INCFLAGS)

# Convert ELF to binary
$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $(TARGET).elf $(TARGET).bin

# Build kernel binary
kernel.bin:
	$(CC) -x assembler-with-cpp $(CFLAGS) -mcpu=$(CPU_CC) -c kernel.S -o kernel.o
	$(CC) -x assembler-with-cpp $(CFLAGS) -mcpu=$(CPU_CC) -c print.S -o print.o
	$(CC) -mcpu=$(CPU_CC) $(LDFLAGS) -T./lscript_kernel.ld -o kernel.elf kernel.o print.o $(INCFLAGS)
	$(OBJCOPY) -O binary kernel.elf kernel.bin

# Launch QEMU and wait for debugger
qemu:
	$(QEMU) --verbose --verbose --board $(BOARD) --mcu $(MCU) \
		-d unimp,guest_errors --image $(TARGET).elf \
		--semihosting-config enable=on,target=native \
		-gdb tcp::$(TCP_ADDR) -S

# Run QEMU immediately
qemu_run:
	$(QEMU) --verbose --verbose --board $(BOARD) --mcu $(MCU) \
		-d unimp,guest_errors --image $(TARGET).elf \
		--semihosting-config enable=on,target=native

# Clean build artifacts
clean:
	-rm -f *.o
	-rm -f *.elf
	-rm -f *.bin

# Flash firmware to device
flash:
	st-flash write $(TARGET).bin 0x08000000

