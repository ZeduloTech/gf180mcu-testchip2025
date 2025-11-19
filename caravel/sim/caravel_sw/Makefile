# Set the prefix for `riscvXX-unknown-elf-*`
# On installations using `multilib`, this will be `riscv64` even for compiling to 32-bit targets
TOOLCHAIN_PREFIX?=riscv64-unknown-elf

.PHONY: hex flash clean

PROG ?= uart
COMMON_DIR = common

hex:  $(PROG).hex

%.elf: %.c
	$(TOOLCHAIN_PATH)$(TOOLCHAIN_PREFIX)-gcc -I$(COMMON_DIR) -I$(COMMON_DIR)/generated/ -O0 -mabi=ilp32 -march=rv32i_zicsr -D__vexriscv__ -Wl,-Bstatic,-T,$(COMMON_DIR)/sections.lds,--strip-debug -ffreestanding -nostdlib -o $@ $(COMMON_DIR)/crt0_vex.S $(COMMON_DIR)/isr.c $<

%.hex: %.elf
	$(TOOLCHAIN_PATH)$(TOOLCHAIN_PREFIX)-objcopy -O verilog $< $@
	chmod 644 $@
	sed -i 's/@1000/@0000/g' $@
	@# following helps to prevent X states in sim when caching last instructions
	echo "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00" >> $@

%.bin: %.elf
	$(TOOLCHAIN_PATH)$(TOOLCHAIN_PREFIX)-objcopy -O binary $< $@
	
%.lst: %.elf
	${TOOLCHAIN_PATH}$(TOOLCHAIN_PREFIX)-objdump -D  $(PROG).elf >  $(PROG).lst

flash:  $(PROG).hex
	python3 ../util/caravel_hkflash.py  $(PROG).hex

flash2:  $(PROG).hex
	python3 ../util/caravel_flash.py  $(PROG).hex

# ---- Clean ----

clean:
	rm -f *.elf *.hex *.bin *.vvp *.vcd *.lst

.PHONY: clean hex all flash
