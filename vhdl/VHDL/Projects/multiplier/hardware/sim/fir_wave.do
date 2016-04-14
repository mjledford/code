onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate /tb_fir_top/c_clk
add wave -noupdate /tb_fir_top/w_rst
add wave -noupdate /tb_fir_top/w_en
add wave -noupdate /tb_fir_top/w_x
add wave -noupdate /tb_fir_top/w_b0
add wave -noupdate /tb_fir_top/w_b1
add wave -noupdate /tb_fir_top/w_b2
add wave -noupdate /tb_fir_top/w_b3
add wave -noupdate /tb_fir_top/w_result
add wave -noupdate -divider {FIR 1}
add wave -noupdate /tb_fir_top/ft/fir1/i_en
add wave -noupdate /tb_fir_top/ft/fir1/i_rst
add wave -noupdate /tb_fir_top/ft/fir1/i_x
add wave -noupdate /tb_fir_top/ft/fir1/i_b0
add wave -noupdate /tb_fir_top/ft/fir1/i_b1
add wave -noupdate /tb_fir_top/ft/fir1/f_chainin
add wave -noupdate /tb_fir_top/ft/fir1/f_syst_reg
add wave -noupdate /tb_fir_top/ft/fir1/f_syst_reg2
add wave -noupdate /tb_fir_top/ft/fir1/f_out_reg
add wave -noupdate /tb_fir_top/ft/fir1/f_dv
add wave -noupdate /tb_fir_top/ft/fir1/o_result
add wave -noupdate /tb_fir_top/ft/fir1/o_dv
add wave -noupdate -divider {FIR 2}
add wave -noupdate /tb_fir_top/ft/fir2/i_en
add wave -noupdate /tb_fir_top/ft/fir2/i_x
add wave -noupdate /tb_fir_top/ft/fir2/i_chainin
add wave -noupdate /tb_fir_top/ft/fir2/i_b0
add wave -noupdate /tb_fir_top/ft/fir2/i_b1
add wave -noupdate /tb_fir_top/ft/fir2/f_chainin
add wave -noupdate /tb_fir_top/ft/fir2/f_syst_reg
add wave -noupdate /tb_fir_top/ft/fir2/f_syst_reg2
add wave -noupdate /tb_fir_top/ft/fir2/f_out_reg
add wave -noupdate /tb_fir_top/ft/fir2/o_result
add wave -noupdate /tb_fir_top/ft/fir2/o_dv
add wave -noupdate -divider TOP
add wave -noupdate /tb_fir_top/ft/o_result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {307 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1004 ns}
