echo "Passes on Verilator v4.216 but has issues on v5.x, to be fixed"

#Use this for v4.216
#verilator -D_VERILATOR=1  --cc --exe sim_main.cpp ../../src/sramtest/uspi_sramtest.sv gf180sram/gf180_ram_64x8_wrapper.v gf180sram/gf180_ram_128x8_wrapper.v gf180sram/gf180_ram_256x8_wrapper.v gf180sram/gf180_ram_512x8_wrapper.v

#Use this for v5.x
verilator -D_VERILATOR=1 --no-timing  --cc --exe sim_main.cpp ../../src/sramtest/uspi_sramtest.sv gf180sram/gf180_ram_64x8_wrapper.v gf180sram/gf180_ram_128x8_wrapper.v gf180sram/gf180_ram_256x8_wrapper.v gf180sram/gf180_ram_512x8_wrapper.v

cd obj_dir
make -f Vuspi_sramtest.mk
cd ..

