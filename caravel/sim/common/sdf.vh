`ifdef ENABLE_SDF
initial begin
    $sdf_annotate({`FINAL_PREFIX, "/sdf/nom_tt_025C_5v00/chip_top__nom_tt_025C_5v00.sdf"}, `CHIP_TOP_HIER );
    $sdf_annotate({`CARAVEL_FINAL_PREFIX, "/sdf/nom_tt_025C_5v00/caravel_core__nom_tt_025C_5v00.sdf"}, `CHIP_TOP_HIER.\i_chip_core.caravel );
    $sdf_annotate({`OSC_FINAL_PREFIX, "/sdf/nom_tt_025C_5v00/ring_osc2x13__nom_tt_025C_5v00.sdf"}, `CHIP_TOP_HIER.\i_chip_core.caravel .\pll.ringosc );
    $sdf_annotate({`FINAL_PREFIX, "../ip/efuse_wb_mem_1024x32/nom_tt_025C_5v00/efuse_wb_mem_1024x32__nom_tt_025C_5v00.sdf"}, `CHIP_TOP_HIER.\i_chip_core.wb_efuses.efuse_wb_1024x32 );
    $sdf_annotate({`FINAL_PREFIX, "../ip/efuse_wb_mem_128x8/nom_tt_025C_5v00/efuse_wb_mem_128x8__nom_tt_025C_5v00.sdf"}, `CHIP_TOP_HIER.\i_chip_core.wb_efuses.efuse_wb_128x8 );
    $sdf_annotate({`FINAL_PREFIX, "../ip/efuse_wb_mem_64x32/nom_tt_025C_5v00/efuse_wb_mem_64x32__nom_tt_025C_5v00.sdf"}, `CHIP_TOP_HIER.\i_chip_core.wb_efuses.efuse_wb_64x32 );
    $sdf_annotate({`FINAL_PREFIX, "../ip/efuse_wb_mem_32x8/nom_tt_025C_5v00/efuse_wb_mem_32x8__nom_tt_025C_5v00.sdf"}, `CHIP_TOP_HIER.\i_chip_core.wb_efuses.efuse_wb_32x8 );
    $sdf_annotate({`FINAL_PREFIX, "../ip/efuse_spi_mem_256x8/nom_tt_025C_5v00/efuse_spi_mem_256x8__nom_tt_025C_5v00.sdf"}, `CHIP_TOP_HIER.\i_chip_core.efuse_spi );
    $sdf_annotate({`FINAL_PREFIX, "../ip/efuse_async_mem_1x8/nom_tt_025C_5v00/efuse_async_mem_1x8__nom_tt_025C_5v00.sdf"}, `CHIP_TOP_HIER.\i_chip_core.efuse_async );
    $sdf_annotate({`FINAL_PREFIX, "../ip/efuse_async_mem_1x8/nom_tt_025C_5v00/efuse_async_mem_1x8__nom_tt_025C_5v00.sdf"}, `CHIP_TOP_HIER.\i_chip_core.wb_efuses.efuse_wb_async.efuse[0].efuse_async );
    $sdf_annotate({`FINAL_PREFIX, "../ip/efuse_async_mem_1x8/nom_tt_025C_5v00/efuse_async_mem_1x8__nom_tt_025C_5v00.sdf"}, `CHIP_TOP_HIER.\i_chip_core.wb_efuses.efuse_wb_async.efuse[1].efuse_async );
    $sdf_annotate({`FINAL_PREFIX, "../ip/efuse_async_mem_1x8/nom_tt_025C_5v00/efuse_async_mem_1x8__nom_tt_025C_5v00.sdf"}, `CHIP_TOP_HIER.\i_chip_core.wb_efuses.efuse_wb_async.efuse[2].efuse_async );
    $sdf_annotate({`FINAL_PREFIX, "../ip/efuse_async_mem_1x8/nom_tt_025C_5v00/efuse_async_mem_1x8__nom_tt_025C_5v00.sdf"}, `CHIP_TOP_HIER.\i_chip_core.wb_efuses.efuse_wb_async.efuse[3].efuse_async );
    $sdf_annotate({`FINAL_PREFIX, "../uart2gpi/final/sdf/nom_tt_025C_5v00/uart2gpi__nom_tt_025C_5v00.sdf"}, `CHIP_TOP_HIER.\i_chip_core.uart2gpi_0 );
end
`endif
