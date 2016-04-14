onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate /tb_rcvr/c_clk
add wave -noupdate /tb_rcvr/w_dv
add wave -noupdate /tb_rcvr/w_dv_2_check
add wave -noupdate /tb_rcvr/w_nco
add wave -noupdate /tb_rcvr/w_out
add wave -noupdate /tb_rcvr/w_in_sig
add wave -noupdate -divider Stim
add wave -noupdate /tb_rcvr/u_stim/o_in_sig
add wave -noupdate /tb_rcvr/u_stim/o_nco
add wave -noupdate /tb_rcvr/u_stim/o_dv
add wave -noupdate -divider DUT
add wave -noupdate /tb_rcvr/u_rcvr/i_dv
add wave -noupdate -radix decimal /tb_rcvr/u_rcvr/i_in
add wave -noupdate -radix decimal /tb_rcvr/u_rcvr/i_nco
add wave -noupdate -radix decimal /tb_rcvr/u_rcvr/o_out
add wave -noupdate /tb_rcvr/u_rcvr/o_dv
add wave -noupdate -divider Checker
add wave -noupdate /tb_rcvr/u_check/i_c
add wave -noupdate /tb_rcvr/u_check/i_dv
add wave -noupdate /tb_rcvr/u_check/c_c
add wave -noupdate /tb_rcvr/u_check/f_c
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {42534 ns} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ns} {131382 ns}
