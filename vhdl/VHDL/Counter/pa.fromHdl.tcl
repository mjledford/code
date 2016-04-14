
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name Counter -dir "C:/Users/AFIT/Documents/VHDL/Counter/planAhead_run_5" -part xc6vlx240tff1156-2
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "pins.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {Counter.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top Counter $srcset
add_files [list {pins.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6vlx240tff1156-2
