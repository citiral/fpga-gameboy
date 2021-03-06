# Copyright (C) 2020  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details, at
# https://fpgasoftware.intel.com/eula.

# Quartus Prime: Generate Tcl File for Project
# File: pomodoro.tcl
# Generated on: Thu May 06 23:03:46 2021

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "pomodoro"]} {
		puts "Project pomodoro is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists pomodoro]} {
		project_open -revision pomodoro pomodoro
	} else {
		project_new -revision pomodoro pomodoro
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "MAX 10"
	set_global_assignment -name DEVICE 10M08DAF256C8GES
	set_global_assignment -name TOP_LEVEL_ENTITY main
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 15.1.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "22:00:46  APRIL 02, 2016"
	set_global_assignment -name LAST_QUARTUS_VERSION "20.1.1 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name DEVICE_FILTER_PACKAGE FBGA
	set_global_assignment -name DEVICE_FILTER_PIN_COUNT 256
	set_global_assignment -name DEVICE_FILTER_SPEED_GRADE 8
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (VHDL)"
	set_global_assignment -name EDA_RUN_TOOL_AUTOMATICALLY OFF -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
	set_global_assignment -name ENABLE_DEVICE_WIDE_RESET ON
	set_global_assignment -name ENABLE_OCT_DONE OFF
	set_global_assignment -name ENABLE_BOOT_SEL_PIN OFF
	set_global_assignment -name EXTERNAL_FLASH_FALLBACK_ADDRESS 00000000
	set_global_assignment -name USE_CONFIGURATION_DEVICE OFF
	set_global_assignment -name CRC_ERROR_OPEN_DRAIN OFF
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED WITH BUS-HOLD"
	set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"
	set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
	set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
	set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
	set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
	set_global_assignment -name PROJECT_IP_REGENERATION_POLICY ALWAYS_REGENERATE_IP
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name VHDL_INPUT_VERSION VHDL_2008
	set_global_assignment -name VHDL_SHOW_LMF_MAPPING_MESSAGES OFF
	set_global_assignment -name VHDL_FILE z80/z80.vhd
	set_global_assignment -name VHDL_FILE PLL_50.vhd
	set_global_assignment -name QIP_FILE PLL_50.qip
	set_global_assignment -name SOURCE_FILE PLL_50.cmp
	set_global_assignment -name VHDL_FILE pb_debouncer.vhd
	set_global_assignment -name VHDL_FILE multi_display.vhd
	set_global_assignment -name VHDL_FILE main.vhd
	set_global_assignment -name VHDL_FILE hex2seg.vhd
	set_global_assignment -name VHDL_FILE divider.vhd
	set_global_assignment -name QIP_FILE ram_1port.qip
	set_global_assignment -name VHDL_FILE z80/z80_register.vhd
	set_global_assignment -name INTERNAL_FLASH_UPDATE_MODE "SINGLE IMAGE WITH ERAM"
	set_location_assignment PIN_L3 -to CLK_10MHz
	set_location_assignment PIN_L16 -to SEG[0]
	set_location_assignment PIN_J15 -to SEG[1]
	set_location_assignment PIN_J16 -to SEG[2]
	set_location_assignment PIN_H15 -to SEG[3]
	set_location_assignment PIN_H16 -to SEG[4]
	set_location_assignment PIN_G15 -to SEG[5]
	set_location_assignment PIN_G16 -to SEG[6]
	set_location_assignment PIN_F16 -to SEG[7]
	set_location_assignment PIN_E15 -to DISP[0]
	set_location_assignment PIN_E16 -to DISP[1]
	set_location_assignment PIN_D15 -to DISP[2]
	set_location_assignment PIN_D16 -to DISP[3]
	set_location_assignment PIN_B15 -to BTN[0]
	set_location_assignment PIN_B16 -to BTN[1]
	set_location_assignment PIN_P16 -to LED[2]
	set_location_assignment PIN_R16 -to LED[3]
	set_location_assignment PIN_R15 -to nRES
	set_location_assignment PIN_M16 -to LED[0]
	set_location_assignment PIN_N16 -to LED[1]
	set_location_assignment PIN_C15 -to WS2812B
	set_location_assignment PIN_M1 -to BLUE
	set_location_assignment PIN_N1 -to GREEN
	set_location_assignment PIN_L1 -to HSYNC
	set_location_assignment PIN_R1 -to RED
	set_location_assignment PIN_J1 -to VSYNC
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
