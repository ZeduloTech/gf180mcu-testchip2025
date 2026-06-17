# Set the prefix for `riscvXX-unknown-elf-*`
# On installations using `multilib`, this will be `riscv64` even for compiling to 32-bit targets
TOOLCHAIN_PREFIX?=riscv64-unknown-elf

.PHONY: hex flash clean

PROG ?= uart
COMMON_DIR = common
ABI_FLAGS = -mabi=ilp32 -march=rv32i_zicsr

hex:  $(PROG).hex
ehex: $(PROG).ehex
lst:  $(PROG).lst

%.elf: %.c
	$(TOOLCHAIN_PATH)$(TOOLCHAIN_PREFIX)-gcc -I$(COMMON_DIR) -I$(COMMON_DIR)/generated/ -O2 $(ABI_FLAGS) -D__vexriscv__ -Wl,-Bstatic,-T,$(COMMON_DIR)/sections.lds,--strip-debug -ffreestanding -nostdlib -o $@ $(COMMON_DIR)/crt0_vex.S $(COMMON_DIR)/isr.c $(COMMON_DIR)/utils.c $<

%.elf: %.S
	$(TOOLCHAIN_PATH)$(TOOLCHAIN_PREFIX)-gcc $(ABI_FLAGS) -ffreestanding -nostdlib -Wl,-Bstatic,-T,$(COMMON_DIR)/sections.lds,--strip-debug -o $@ $<

%.hex: %.elf
	$(TOOLCHAIN_PATH)$(TOOLCHAIN_PREFIX)-objcopy -O verilog $< $@
	chmod 644 $@
	sed -i 's/@1000/@0000/g' $@
	@# following helps to prevent X states in sim when caching last instructions
	echo "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00" >> $@

%.ehex: %.elf
	$(TOOLCHAIN_PATH)$(TOOLCHAIN_PREFIX)-objcopy --only-section=.efuse --set-section-flags .efuse=alloc,load --verilog-data-width=4 -O verilog $< $@
	sed -i 's/@0C000000/@00000000/g' $@
	@# following helps to prevent X states in sim when caching last instructions
	echo "00000000 00000000" >> $@

%.e8hex: %.elf
	$(TOOLCHAIN_PATH)$(TOOLCHAIN_PREFIX)-objcopy --only-section=.efuse --set-section-flags .efuse=alloc,load --verilog-data-width=1 -O verilog $< $@
	sed -i 's/@30000000/@00000000/g' $@
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
	rm -f *.elf *.hex *.ehex *.e8hex *.bin *.vvp *.vcd *.lst

.PHONY: clean hex ehex lst all flash
