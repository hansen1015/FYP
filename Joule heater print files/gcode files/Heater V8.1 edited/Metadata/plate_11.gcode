; HEADER_BLOCK_START
; BambuStudio 02.06.00.51
; model printing time: 13m 16s; total estimated time: 18m 24s
; total layer number: 10
; total filament length [mm] : 40.18,112.90,280.76,32.42
; total filament volume [cm^3] : 96.65,271.56,675.31,77.98
; total filament weight [g] : 0.12,0.34,0.85,0.10
; model label id: 1563,1747
; object max height: 2.00,2.00
; filament_density: 1.26,1.26,1.25,1.26,1.25
; filament_diameter: 1.75,1.75,1.75,1.75,1.75
; max_z_height: 2.00
; filament: 2,3,4,5
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0,0,0,0,0
; additional_cooling_fan_speed = 75,40,75,100,0
; additional_fan_full_speed_layer = 0,0,0,0,0
; apply_scarf_seam_on_circles = 1
; auxiliary_fan = 1
; avoid_crossing_wall_includes_support = 0
; bed_custom_model = 
; bed_custom_texture = 
; bed_exclude_area = 
; bed_temperature_formula = by_highest_temp
; before_layer_change_gcode = 
; best_object_pos = 0.3,0.5
; bottom_color_penetration_layers = 3
; bottom_shell_layers = 3
; bottom_shell_thickness = 0
; bottom_surface_density = 100%
; bottom_surface_pattern = monotonic
; bridge_angle = 0
; bridge_flow = 1
; bridge_no_support = 0
; bridge_speed = 10,50
; brim_object_gap = 0.1
; brim_type = auto_brim
; brim_width = 5
; chamber_temperatures = 0,0,0,0,0
; change_filament_gcode = ;======== H2C filament_change ========\n;===== 20260409 =====\nM993 A2 B2 C2 ; nozzle cam detection allow status save.\nM993 A0 B0 C0 ; nozzle cam detection not allowed.\n\n{if (filament_type[next_extruder] == "PLA") ||  (filament_type[next_extruder] == "PETG")\n ||  (filament_type[next_extruder] == "PLA-CF")  ||  (filament_type[next_extruder] == "PETG-CF")}\nM1015.4 S1 K0 ;disable E air printing detect\n{else}\nM1015.4 S0 ; disable E air printing detect\n{endif}\n\nM620 O{toolchange_count + 1}\nM620 S[next_extruder]A H[next_hotend]\nM1002 gcode_claim_action : 4\nM204 S9000\n\nG1 Z{max_layer_z + 3.0} F1200\n\nM400\nM106 P1 S0\nM106 P2 S0\n\n{if toolchange_count == 2}\n; get travel path for change filament\n;M620.1 X[travel_point_1_x] Y[travel_point_1_y] F21000 P0\n;M620.1 X[travel_point_2_x] Y[travel_point_2_y] F21000 P1\n;M620.1 X[travel_point_3_x] Y[travel_point_3_y] F21000 P2\n{endif}\n\n{if wipe_tower_center_pos_valid}\n    M620.14 X[wipe_tower_center_pos_x] Y[wipe_tower_center_pos_y]\n{else}\n    M620.14 X95.5 Y336\n{endif}\n\n{if ((filament_type[current_extruder] == "PLA") || (filament_type[current_extruder] == "PLA-CF") || (filament_type[current_extruder] == "PETG")) && (nozzle_diameter[current_extruder] == 0.2)}\nM620.10 A0 F74.8347 L[flush_length] H{nozzle_diameter[current_extruder]} T{flush_temperatures[current_extruder]} P[old_filament_temp] S1\n{else}\nM620.10 A0 F{flush_volumetric_speeds[current_extruder]/2.4053*60*0.8} L[flush_length] H{nozzle_diameter[current_extruder]} T{flush_temperatures[current_extruder]} P[old_filament_temp] S1\n{endif}\n\n{if ((filament_type[next_extruder] == "PLA") || (filament_type[next_extruder] == "PLA-CF") || (filament_type[next_extruder] == "PETG")) && (nozzle_diameter[next_extruder] == 0.2)}\nM620.10 A1 F74.8347 L[flush_length] H{nozzle_diameter[next_extruder]} T{flush_temperatures[next_extruder]} P[new_filament_temp] S1\n{else}\nM620.10 A1 F{flush_volumetric_speeds[next_extruder]/2.4053*60*0.8} L[flush_length] H{nozzle_diameter[next_extruder]} T{flush_temperatures[next_extruder]} P[new_filament_temp] S1\n{endif}\n\n{if long_retraction_when_cut}\nM620.11 P1 I[current_extruder] B[current_hotend] E-{retraction_distance_when_cut} F{max((flush_volumetric_speeds[current_extruder]/2.4053*60), 200)}\n{else}\nM620.11 P0 I[current_extruder] B[current_hotend] E0\n{endif}\n\n\nM620.15 P[filament_pre_cooling_temperature_nc[next_extruder]]\nM620.15 C{new_filament_temp - filament_cooling_before_tower[next_extruder]}\nM620.11 O1 T[filament_retract_length_nc]\n\n{if long_retraction_when_ec}\nM620.11 K1 I[current_extruder] B[current_hotend] R{retraction_distance_when_ec} F{max((flush_volumetric_speeds[current_extruder]/2.4053*60), 200)}\n{else}\nM620.11 K0 I[current_extruder] B[current_hotend] R0\n{endif}\n\nM620.15 C{new_filament_temp - filament_cooling_before_tower[next_extruder]}\n\nM628 S1\n{if filament_type[current_extruder] == "TPU"}\nM620.11 S0 L0 I[current_extruder] B[current_hotend] E-{retraction_distances_when_cut[current_extruder]} F{max((flush_volumetric_speeds[current_extruder]/2.4053*60), 200)}\n{else}\n{if (filament_type[current_extruder] == "PA") || (filament_type[current_extruder] == "PA-GF")}\nM620.11 S1 L0 I[current_extruder] B[current_hotend] R4 D2 E-{retraction_distances_when_cut[current_extruder]} F{max((flush_volumetric_speeds[current_extruder]/2.4053*60), 200)}\n{else}\nM620.11 S1 L0 I[current_extruder] B[current_hotend] R10 D8 E-{retraction_distances_when_cut[current_extruder]} F{max((flush_volumetric_speeds[current_extruder]/2.4053*60), 200)}\n{endif}\n{endif}\nM629\n\n{if (filament_type[current_extruder] == "TPU" || filament_type[next_extruder] == "TPU") && (old_extruder_variant != "Direct Drive TPU High Flow")}\n;M620.11 H2 C331 TODO:add区分左右顶料\n{else}\n;M620.11 H0\n{endif}\n\n{if filament_type[next_extruder] == "TPU" }\n;ct:{filament_type[current_extruder]} nt:{filament_type[next_extruder]} \n;debug log pe:{previous_extruder} ce:{current_extruder} ne:{next_extruder} oev: {old_extruder_variant} nev:{new_extruder_variant}\n;debug fm-curr:{filament_map[current_extruder]} fm-next:{filament_map[next_extruder]}\n;sw from R2L&TPU kit, travel run a distance for sketch TPU\nG1 X30 Y30 F5000\nM400\nG1 X300 Y30 F5000\nM400\n{endif}\n\nT[next_extruder] H[next_hotend]\n\n;deretract\n{if filament_type[next_extruder] == "TPU"}\n{else}\n{if (filament_type[next_extruder] == "PA") || (filament_type[next_extruder] == "PA-GF")}\n;VG1 E1 F{max(new_filament_e_feedrate, 200)}\n;VG1 E1 F{max(new_filament_e_feedrate/2, 100)}\n{else}\n;VG1 E4 F{max(new_filament_e_feedrate, 200)}\n;VG1 E4 F{max(new_filament_e_feedrate/2, 100)}\n{endif}\n{endif}\n\n; VFLUSH_START\n\n{if flush_length>41.5}\n;VG1 E41.5 F{min(old_filament_e_feedrate,new_filament_e_feedrate)}\n;VG1 E{flush_length-41.5} F{new_filament_e_feedrate}\n{else}\n;VG1 E{flush_length} F{min(old_filament_e_feedrate,new_filament_e_feedrate)}\n{endif}\n\nSYNC T{ceil(flush_length / 125) * 5}\n\n; compensate for heating and cooling\n{if flush_length > 0}\n{if flush_temperatures[next_extruder] > new_filament_temp}\nSYNC T{(flush_temperatures[next_extruder]-(new_filament_temp - filament_cooling_before_tower[next_extruder]))/hotend_cooling_rate[filament_map[next_extruder]-1]}\nSYNC T{(flush_temperatures[next_extruder]-(new_filament_temp - filament_cooling_before_tower[next_extruder]))/hotend_heating_rate[filament_map[next_extruder]-1]}\n{else}\nSYNC T{(new_filament_temp - filament_cooling_before_tower[next_extruder] -flush_temperatures[next_extruder])/hotend_cooling_rate[filament_map[next_extruder]-1]}\nSYNC T{(new_filament_temp - filament_cooling_before_tower[next_extruder] -flush_temperatures[next_extruder])/hotend_heating_rate[filament_map[next_extruder]-1]}\n{endif}\n{endif}\n\n; VFLUSH_END\n\nM1002 set_filament_type:{filament_type[next_extruder]}\n\nM400\nM83\n{if next_extruder < 255}\n\n\nM620.10 R{new_extruder_retracted_length}\n\n{if (print_sequence == "by object" && !has_wipe_tower)}\nM628 S0 F1 L10.0\n; VFLUSH_START\n;VG1 E10 F[new_filament_e_feedrate]\n; VFLUSH_END\n{else}\nM628 S0\n{endif}\n;VM109 S[new_filament_temp]\n\nM629\nM400\n\n;prime_tower_interface\n{if is_prime_tower_interface && filament_tower_interface_purge_volume !=0}\nG150.1\nM620.13 W0 L{filament_tower_interface_purge_volume} T{filament_tower_interface_print_temp} R0.0\n{endif}\n;prime_tower_interface\n\nM983.3 F{filament_max_volumetric_speed[next_extruder]/2.4} A0.4 R{new_extruder_retracted_length}\n\n\nM400\n{if wipe_avoid_perimeter}\nG387 Y320 J1 F10000\nG1 X{wipe_avoid_pos_x} F30000\n{endif}\nG387 Y295 J1 F30000\nG387 Y265 J1 F18000\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\nM621 S[next_extruder]A\n\nM622.1 S0 ;for prev version, default skip\nM1002 judge_flag powerloss_resume_flag\nM622 J1\nM983.3 F{filament_max_volumetric_speed[next_extruder]/2.4} A0.4 R{new_extruder_retracted_length}\nM400\n{if wipe_avoid_perimeter}\nG387 Y320 J1 F10000\nG1 X{wipe_avoid_pos_x} F30000\n{endif}\nG387 Y295 J1 F30000\nG387 Y265 J1 F18000\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\nM1002 set_flag powerloss_resume_flag=0\nM623\n\nM993 A3 B3 C3 ; nozzle cam detection allow status restore.\n\n{if (filament_type[next_extruder]  == "TPU")}\nM1015.3 S1;enable tpu clog detect\n{else}\nM1015.3 S0;disable tpu clog detect\n{endif}\n\n{if (filament_type[next_extruder] == "PLA") ||  (filament_type[next_extruder] == "PETG")\n ||  (filament_type[next_extruder] == "PLA-CF")  ||  (filament_type[next_extruder] == "PETG-CF")}\nM1015.4 S1 K1 H[nozzle_diameter] ;enable E air printing detect\n{else}\nM1015.4 S0 ; disable E air printing detect\n{endif}\n\nM620.6 I[next_extruder] H[next_hotend] W1 ;enable ams air printing detect\nM620 O{toolchange_count + 1}\nM1002 gcode_claim_action : 0
; circle_compensation_manual_offset = 0
; circle_compensation_speed = 200,200,200,200,200
; close_additional_fan_first_x_layers = 1,1,1,1,3
; close_fan_the_first_x_layers = 1,1,1,1,3
; complete_print_exhaust_fan_speed = 70,70,70,70,70
; cool_plate_temp = 35,35,35,30,0
; cool_plate_temp_initial_layer = 35,35,35,30,0
; cooling_filter_enabled = 0
; cooling_perimeter_transition_distance = 10,10,10,10,10
; cooling_slowdown_logic = uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling
; counter_coef_1 = 0,0,0,0,0
; counter_coef_2 = 0.0025,0.0025,0.008,0.008,0.008
; counter_coef_3 = 0.014,0.014,-0.041,-0.041,-0.041
; counter_limit_max = 0.076,0.076,0.033,0.033,0.033
; counter_limit_min = 0.014,0.014,-0.035,-0.035,-0.035
; curr_bed_type = Textured PEI Plate
; default_acceleration = 25,8000
; default_filament_colour = ;;;;
; default_filament_profile = "Bambu PLA Basic @BBL H2C"
; default_jerk = 0
; default_nozzle_volume_type = Standard,Standard
; default_print_profile = 0.20mm Standard @BBL H2C
; deretraction_speed = 30,30
; detect_floating_vertical_shell = 1
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; diameter_limit = 50,50,50,50,50
; different_settings_to_system = bridge_speed;default_acceleration;enable_overhang_speed;gap_infill_speed;initial_layer_acceleration;initial_layer_infill_speed;initial_layer_speed;initial_layer_travel_acceleration;inner_wall_speed;internal_solid_infill_speed;outer_wall_acceleration;outer_wall_speed;skeleton_infill_density;skin_infill_density;sparse_infill_density;sparse_infill_pattern;sparse_infill_speed;support_interface_speed;support_speed;top_surface_acceleration;top_surface_speed;travel_acceleration;travel_short_distance_acceleration;travel_speed;;additional_cooling_fan_speed;fan_max_speed;fan_min_speed;filament_change_length;filament_change_length_nc;filament_retract_restart_extra;filament_retract_when_changing_layer;filament_retraction_minimum_travel;filament_start_gcode;nozzle_temperature;nozzle_temperature_initial_layer;nozzle_temperature_range_high;nozzle_temperature_range_low;nozzle_temperature;nozzle_temperature_initial_layer;;textured_plate_temp;textured_plate_temp_initial_layer;machine_start_gcode
; draft_shield = disabled
; during_print_exhaust_fan_speed = 70,70,70,70,70
; elefant_foot_compensation = 0.15
; embedding_wall_into_infill = 0
; enable_arc_fitting = 1
; enable_circle_compensation = 0
; enable_filament_dynamic_map = 0
; enable_height_slowdown = 0,0
; enable_long_retraction_when_cut = 2
; enable_mixed_color_sublayer = 0
; enable_overhang_bridge_fan = 1,1,1,1,1
; enable_overhang_speed = 0,1
; enable_pre_heating = 1
; enable_pressure_advance = 0,0,0,0,0
; enable_prime_tower = 1
; enable_support = 0
; enable_support_ironing = 0
; enable_tower_interface_features = 1
; enable_wrapping_detection = 0
; enforce_support_layers = 0
; eng_plate_temp = 55,55,55,35,70
; eng_plate_temp_initial_layer = 55,55,55,35,70
; ensure_vertical_shell_thickness = enabled
; exclude_object = 1
; extruder_ams_count = 1#0|4#0;1#0|4#0
; extruder_clearance_dist_to_rod = 50
; extruder_clearance_height_to_lid = 201
; extruder_clearance_height_to_rod = 47.4
; extruder_clearance_max_radius = 96
; extruder_colour = #018001;#018001
; extruder_max_nozzle_count = 1,6
; extruder_nozzle_stats = Standard#1;Standard#6
; extruder_offset = 0x0,0x0
; extruder_printable_area = 0x0,325x0,325x320,0x320#25x0,330x0,330x320,25x320
; extruder_printable_height = 320,325
; extruder_type = Direct Drive,Direct Drive
; extruder_variant_list = "Direct Drive Standard,Direct Drive High Flow";"Direct Drive Standard,Direct Drive High Flow"
; fan_cooling_layer_time = 100,100,100,30,30
; fan_direction = left
; fan_max_speed = 80,40,100,40,30
; fan_min_speed = 60,20,100,20,20
; filament_adaptive_volumetric_speed = 0,0,0,0,0
; filament_adhesiveness_category = 100,100,100,600,300
; filament_bridge_speed = 25,25,25,25,25
; filament_change_length = 4,2,4,4,4
; filament_change_length_nc = 4,2,4,4,4
; filament_colour = #FFFFFF;#AA6443;#43403D;#939393;#FF671F
; filament_colour_type = 0;1;1;1;1
; filament_cooling_before_tower = 10,10,10,10,10
; filament_cost = 24.99,24.99,29.99,38.99,24.99
; filament_density = 1.26,1.26,1.25,1.26,1.25
; filament_dev_ams_drying_ams_limitations = 1;0;1;0;1;0;1;1;0
; filament_dev_ams_drying_heat_distortion_temperature = 45,45,45,45,75
; filament_dev_ams_drying_temperature = 45,45,45,45,45,45,45,45,45,45,45,45,65,75,45,45,65,65,55,55
; filament_dev_ams_drying_time = 12,12,12,12,12,12,12,12,12,12,12,12,12,18,12,18,12,12,12,12
; filament_dev_chamber_drying_bed_temperature = 70,70,70,90,80
; filament_dev_chamber_drying_time = 12,12,12,16,12
; filament_dev_drying_cooling_temperature = 45,45,45,40,55
; filament_dev_drying_softening_temperature = 50,50,50,50,60
; filament_diameter = 1.75,1.75,1.75,1.75,1.75
; filament_enable_overhang_speed = 1,1,1,1,1
; filament_end_gcode = "; filament end gcode \n";"; filament end gcode \n";"; filament end gcode \n";"; filament end gcode \n";"; filament end gcode \n"
; filament_extruder_compatibility = 0,0,0,0,0
; filament_extruder_variant = "Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard"
; filament_flow_ratio = 0.99,0.99,1,0.97,0.97
; filament_flush_temp = 0,0,0,0,0
; filament_flush_volumetric_speed = 0,0,0,0,0
; filament_ids = GFA00;GFA00;GFA02;GFU02;GFG00
; filament_is_mixed = 0,0,0,0,0
; filament_is_support = 0,0,0,0,0
; filament_map = 1,1,2,2,2
; filament_map_2 = 0,0,1,1,1
; filament_map_mode = Manual
; filament_max_volumetric_speed = 25,25,21,12,18
; filament_metal_stickiness = None,None,None,None,High
; filament_minimal_purge_on_wipe_tower = 15,15,15,15,15
; filament_mixed_components = ;;;;
; filament_mixed_gradient = 0,0,0,0,0
; filament_mixed_gradient_range = ;;;;
; filament_mixed_sublayer_ratios = ;;;;
; filament_multi_colour = #FFFFFF;#AA6443;#43403D;#939393;#FF671F
; filament_notes = 
; filament_nozzle_map = 0,0,3,2,1
; filament_overhang_1_4_speed = 0,0,0,0,0
; filament_overhang_2_4_speed = 50,50,50,50,50
; filament_overhang_3_4_speed = 30,30,30,30,30
; filament_overhang_4_4_speed = 10,10,10,10,10
; filament_overhang_totally_speed = 10,10,10,10,10
; filament_pre_cooling_temperature = 0,0,0,200,0
; filament_pre_cooling_temperature_nc = 180,180,180,190,210
; filament_prime_volume = 30,30,30,30,30
; filament_prime_volume_nc = 30,30,30,30,30
; filament_printable = 3,3,3,3,3
; filament_ramming_travel_time = 0,0,0,20,0
; filament_ramming_travel_time_nc = 1,1,1,20,1
; filament_ramming_volumetric_speed = -1,-1,-1,4.5,-1
; filament_ramming_volumetric_speed_nc = -1,-1,-1,4.5,-1
; filament_retract_length_nc = 18,18,18,14,18
; filament_retract_restart_extra = nil,0.2,nil,nil,nil
; filament_retract_when_changing_layer = nil,0,nil,nil,nil
; filament_retraction_length = 0.4,0.4,0.4,0.4,0.4
; filament_retraction_minimum_travel = nil,3,nil,nil,nil
; filament_scarf_gap = 0%,0%,15%,0%,0%
; filament_scarf_height = 10%,10%,10%,10%,10%
; filament_scarf_length = 10,10,10,10,10
; filament_scarf_seam_type = none,none,none,none,none
; filament_self_index = 1,2,3,4,5
; filament_settings_id = "Bambu PLA Basic @BBL H2C";"Multi3D Copper filament 0.4mm@BBL H2C";"Protopasta CPLA @BBL H2C 0.4 nozzle";"Bambu TPU for AMS @BBL H2C 0.4 nozzle";"Bambu PETG Basic for PLA Basic @BBL H2C 0.4 nozzle"
; filament_shrink = 100%,100%,100%,100%,100%
; filament_soluble = 0,0,0,0,0
; filament_start_gcode = "; filament start gcode\n";"; filament start gcode\nM109 S145;\n";"; filament start gcode\n";"; filament start gcode\n";"; filament start gcode\n"
; filament_tower_interface_pre_extrusion_dist = 10,10,10,10,10
; filament_tower_interface_pre_extrusion_length = 0,0,0,0,0
; filament_tower_interface_print_temp = -1,-1,-1,-1,-1
; filament_tower_interface_purge_volume = 20,20,20,20,20
; filament_tower_ironing_area = 4,4,4,4,8
; filament_type = PLA;PLA;PLA;TPU-AMS;PETG
; filament_velocity_adaptation_factor = 1,1,1,1,1
; filament_vendor = "Bambu Lab";"Bambu Lab";"Bambu Lab";"Bambu Lab";"Bambu Lab"
; filament_volume_map = 0,0,0,0,0
; filament_wipe = 1,1,1,nil,1
; filament_wipe_distance = 1,1,1,nil,1
; filament_z_hop_types = Spiral Lift,Spiral Lift,Spiral Lift,nil,Spiral Lift
; filename_format = {input_filename_base}_{filament_type[0]}_{print_time}.gcode
; fill_multiline = 1
; filter_out_gap_fill = 0
; first_layer_print_sequence = 0
; first_x_layer_fan_speed = 0,0,0,0,0
; first_x_layer_part_fan_speed = 0,0,0,0,0
; flush_into_infill = 0
; flush_into_objects = 0
; flush_into_support = 1
; flush_multiplier = 1,1
; flush_volumes_matrix = 0,216,158,120,318,513,0,192,284,281,555,337,0,352,475,330,193,156,0,294,551,208,225,322,0,0,231,173,120,333,528,0,207,299,296,570,352,0,367,490,330,208,171,0,309,566,223,240,337,0
; flush_volumes_vector = 140,140,140,140,140,140,140,140,140,140
; full_fan_speed_layer = 0,0,0,0,0
; fuzzy_skin = none
; fuzzy_skin_first_layer = 0
; fuzzy_skin_mode = displacement
; fuzzy_skin_noise_type = classic
; fuzzy_skin_octaves = 4
; fuzzy_skin_persistence = 0.5
; fuzzy_skin_point_distance = 0.3
; fuzzy_skin_scale = 1
; fuzzy_skin_thickness = 0.2
; gap_infill_speed = 10,250
; gcode_add_line_number = 0
; gcode_flavor = marlin
; grab_length = 0,0
; group_algo_with_time = 0
; has_filament_switcher = 0
; has_scarf_joint_seam = 0
; head_wrap_detect_zone = 
; hole_coef_1 = 0,0,0,0,0
; hole_coef_2 = -0.0028,-0.0028,-0.008,-0.008,-0.008
; hole_coef_3 = 0.12,0.12,0.23415,0.23415,0.23415
; hole_limit_max = 0.12,0.12,0.22,0.22,0.22
; hole_limit_min = 0.05,0.05,0.088,0.088,0.088
; host_type = octoprint
; hot_plate_temp = 55,55,55,35,70
; hot_plate_temp_initial_layer = 55,55,55,35,70
; hotend_cooling_rate = 1.6,3.4
; hotend_heating_rate = 3.5,13.3
; impact_strength_z = 13.8,13.8,16.8,9.6,13.6
; independent_support_layer_height = 0
; infill_combination = 0
; infill_direction = 45
; infill_instead_top_bottom_surfaces = 0
; infill_jerk = 9
; infill_lock_depth = 1
; infill_rotate_step = 0
; infill_shift_step = 0.4
; infill_wall_overlap = 15%
; inherits_group = ;;"Bambu PLA Basic @BBL H2C";"Bambu PLA Metal @BBL H2C 0.4 nozzle";;"Bambu PETG Basic @BBL H2C 0.4 nozzle";"Bambu Lab H2C 0.4 nozzle"
; initial_layer_acceleration = 25,500
; initial_layer_flow_ratio = 1
; initial_layer_infill_speed = 5,105
; initial_layer_jerk = 9
; initial_layer_line_width = 0.5
; initial_layer_print_height = 0.2
; initial_layer_speed = 5,50
; initial_layer_travel_acceleration = 1000,6000
; inner_wall_acceleration = 0,0
; inner_wall_jerk = 9
; inner_wall_line_width = 0.45
; inner_wall_speed = 10,300
; interface_shells = 0
; interlocking_beam = 0
; interlocking_beam_layer_count = 2
; interlocking_beam_width = 0.8
; interlocking_boundary_avoidance = 2
; interlocking_depth = 2
; interlocking_orientation = 22.5
; internal_bridge_support_thickness = 0.8
; internal_solid_infill_line_width = 0.42
; internal_solid_infill_pattern = zig-zag
; internal_solid_infill_speed = 10,250
; ironing_direction = 45
; ironing_fan_speed = -1,-1,-1,-1,-1
; ironing_flow = 15%
; ironing_inset = 0.21
; ironing_pattern = zig-zag
; ironing_spacing = 0.15
; ironing_speed = 30
; ironing_type = no ironing
; is_infill_first = 0
; layer_change_gcode = ; layer num/total_layer_count: {layer_num+1}/[total_layer_count]\n; update layer progress\nM73 L{layer_num+1}\nM991 S0 P{layer_num} ;notify layer change
; layer_height = 0.2
; line_width = 0.42
; locked_skeleton_infill_pattern = zigzag
; locked_skin_infill_pattern = crosszag
; long_retractions_when_cut = 1,1
; long_retractions_when_ec = 1,1,1,1,1
; machine_end_gcode = ;===== machine: H2C end =====\n;====== date: 20260313 ======\n\nG392 S0 ;turn off nozzle clog detect\nM993 A0 B0 C0 ; nozzle cam detection not allowed.\n\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nM211 Z1\nM640.2 R0\n\nG90\nG1 Z{max_layer_z + 0.4} F900 ; lower z a little\nM1002 judge_flag timelapse_record_flag\nM622 J1\n    G150.3\n    M400 ; wait all motion done\n    M991 S0 P-1 ;end smooth timelapse at safe pos\n    M400 S5 ;wait for last picture to be taken\nM623  ;end of "timelapse_record_flag"\n\nG90\nG1 Z{max_layer_z + 10} F900 ; lower z a little\n\nG90\nM141 S0 ; turn off chamber heating\nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\nM106 P9 S0 ; turn off ext toodhead cooling fan\n\n; pull back filament to AMS\nM620 S65535\n{if long_retraction_when_cut}\nM620.11 P1 I[current_extruder] B[current_hotend] E-{retraction_distance_when_cut} F{max((flush_volumetric_speeds[current_extruder]/2.4053*60), 200)}\n{else}\nM620.11 P0 I[current_extruder] B[current_hotend] E0\n{endif}\n\n{if long_retraction_when_ec}\nM620.11 K1 I[current_extruder] B[current_hotend] R{retraction_distance_when_ec} F{max((flush_volumetric_speeds[current_extruder]/2.4053*60), 200)}\n{else}\nM620.11 K0 I[current_extruder] B[current_hotend] R0\n{endif}\n\nM620.11 P1 I[current_extruder] B[current_hotend] E-14\nT65535\nG150.2\nM621 S65535\n\nM620 S65279\nT65279\nG150.2\nM621 S65279\n\nG150.3\n\nM104 S0 T0; turn off hotend\nM104 S0 T1; turn off hotend\n\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (100.0 - max_layer_z/2) > 0}\n    {if (max_layer_z + 100.0 - max_layer_z/2) < 320}\n        G1 Z{max_layer_z + 100.0 - max_layer_z/2} F600\n        G1 Z{max_layer_z + 98.0 - max_layer_z/2}\n    {else}\n        G1 Z320 F600\n        G1 Z320\n    {endif}\n{else}\n    {if (max_layer_z + 4.0) < 320}\n        G1 Z{max_layer_z + 4.0} F600\n        G1 Z{max_layer_z + 2.0}\n    {else}\n        G1 Z320 F600\n        G1 Z320\n    {endif}\n{endif}\nM400 P100\nM17 R ; restore z current\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 0\n\nM1015.4 S0 K0 ;disable air printing detect\n\n\n;=====printer finish air purification=========\nM622.1 S0\nM1002 judge_flag print_finish_air_filt_flag\n\nM622 J1\nM1002 gcode_claim_action : 66\nM145 P1\nM106 P6 S255\nM400 S180\nM106 P6 S0\nM623\n\nM622 J2\nM1002 gcode_claim_action : 66\nM145 P0\nM106 P3 S127\nM400 S180\nM106 P3 S0\nM623\n;=====printer finish air purification=========\n\n;=====printer finish  sound=========\nM17\nM400 S1\nM1006 S1\nM1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 \nM1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 \nM1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A48 B10 L99 C48 D10 M99 E48 F10 N99 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A60 B10 L99 C60 D10 M99 E60 F10 N99 \nM1006 W\n;=====printer finish  sound=========\nM400\nM18\n\n
; machine_hotend_change_time = 0
; machine_load_filament_time = 15
; machine_max_acceleration_e = 5000,5000,5000,5000
; machine_max_acceleration_extruding = 20000,20000,20000,20000
; machine_max_acceleration_retracting = 5000,5000,5000,5000
; machine_max_acceleration_travel = 9000,9000,9000,9000
; machine_max_acceleration_x = 20000,20000,20000,20000
; machine_max_acceleration_y = 20000,20000,20000,20000
; machine_max_acceleration_z = 500,500,500,500
; machine_max_jerk_e = 2.5,2.5,2.5,2.5
; machine_max_jerk_x = 9,9,9,9
; machine_max_jerk_y = 9,9,9,9
; machine_max_jerk_z = 3,3,3,3
; machine_max_speed_e = 50,50,50,50
; machine_max_speed_x = 1000,1000,1000,1000
; machine_max_speed_y = 1000,1000,1000,1000
; machine_max_speed_z = 30,30,30,30
; machine_min_extruding_rate = 0,0
; machine_min_travel_rate = 0,0
; machine_pause_gcode = M400 U1
; machine_prepare_compensation_time = 260
; machine_start_gcode = ;===== machine: H2C =========================\n;===== date: 20260421 =====================\n\n;M1002 set_flag extrude_cali_flag=1\n;M1002 set_flag g29_before_print_flag=1\n;M1002 set_flag auto_cali_toolhead_offset_flag=1\n;M1002 set_flag build_plate_detect_flag=1\n\nM993 A0 B0 C0 ; nozzle cam detection not allowed.\n\nM400\n;M73 P99\n\nM960 S10 P1 ; ext fan led\n\n;=====printer start sound ===================\nM17\nM400 S1\nM1006 S1\nM1006 A53 B9 L99 C53 D9 M99 E53 F9 N99 \nM1006 A56 B9 L99 C56 D9 M99 E56 F9 N99 \nM1006 A61 B9 L99 C61 D9 M99 E61 F9 N99 \nM1006 A53 B9 L99 C53 D9 M99 E53 F9 N99 \nM1006 A56 B9 L99 C56 D9 M99 E56 F9 N99 \nM1006 A61 B18 L99 C61 D18 M99 E61 F18 N99 \nM1006 W\n;=====printer start sound ===================\n\n;===== reset machine status =================\nM204 S10000\nM630 S0 P0\n\nG90\nM17 D ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM1002 set_gcode_claim_speed_level 5 ;Reset speed level\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\nG29.1 Z{+0.0} ; clear z-trim value first\nM983.1 M1 \nM901 D4\nM481 S0 ; turn off cutter pos comp\nG28.140 D0; reset pre-extrude z pos\n;===== reset machine status =================\n\nM620 M ;enable remap\nM620 N ;enable hotend remap\nM620 T0 ;print tmpr\nM620 T1 ;sn -> pos\nM620 T2 ;filament_id\n\n;===== start to heat heatbed & hotend==========\n\n    M104 O-80 A\n    M140 D[bed_temperature_initial_layer_single]\n\n;===== start to heat heatbead & hotend==========\n\n;===== avoid end stop =================\nG91\nG380 S2 Z42 F1200\nG380 S2 Z-12 F1200\nG90\n;===== avoid end stop =================\n\n;==== set airduct mode ==== \n\n{if (overall_chamber_temperature >= 40)}\n\n    M145 P1 ; set airduct mode to heating mode for heating\n    M106 P2 S0 ; turn off auxiliary fan\n    M106 P3 S0 ; turn off chamber fan\n\n{else}\n    M145 P0 ; set airduct mode to cooling mode for cooling\n    M106 P2 S178 ; turn on auxiliary fan for cooling\n    M106 P3 S127 ; turn on chamber fan for cooling\n\n    M1002 gcode_claim_action : 29\n    M191 S0 ; wait for chamber temp\n    M106 P2 S0 ; turn off auxiliary fan\n    {if (min_vitrification_temperature <= 50)}\n        {if (nozzle_diameter == 0.2)}\n            M142 P1 R30 S35 T40 U0.3 V0.5 W0.8 O40 ; set PLA/TPU ND0.2 chamber autocooling\n        {else}\n            M142 P1 R30 S40 T45 U0.3 V0.5 W0.8 O45; set PLA/TPU ND0.4 chamber autocooling\n        {endif}\n    {else}\n        {if (!is_all_bbl_filament)}\n            M142 P1 R35 S40 T45 U0.3 V0.5 W0.8 O45 L1 ; set third-party PETG chamber autocooling\n        {else}\n            {if (nozzle_diameter == 0.2)}\n                M142 P1 R35 S45 T50 U0.3 V0.5 W0.8 O50 L1 ; set PETG ND0.2 chamber autocooling\n            {else}\n                M142 P1 R35 S50 T55 U0.3 V0.5 W0.8 O55 L1 ; set PETG ND0.4 chamber autocooling\n            {endif}\n        {endif}\n    {endif}\n{if(cooling_filter_enabled)}\nM145.2 P0 F0\n{else}\nM145.2 P0 F1\n{endif}\n{endif}\n;==== set airduct mode ==== \n\n\n;====== cog noise reduction=================\nM982.2 S1 ; turn on cog noise reduction\n\n;===== first homing start =====\nM1002 gcode_claim_action : 13\n\nM640 S\nM640.1 R\nM641\nG28 X T300\nT1000\n\nG150.3\nM972 S24 P0 T2000 ; live-view camera foolproof\nM972 S46 P0 T5000 ; vortek anti-collision\nM640.1 S\nM640.4\n{if (first_non_support_filaments[0] != -1)}\nM640 S\nM640.8 T A{first_non_support_filaments[0]} H{first_non_support_hotend[0]}\nM640.7 L\nM641\n{endif}\n\n\n{if wipe_tower_center_pos_valid}\n    M620.14 X[wipe_tower_center_pos_x] Y[wipe_tower_center_pos_y]\n{else}\n    M620.14 X95.5 Y336\n{endif}\n\n\nG150.1 F18000 ; wipe mouth to avoid filament stick to heatbed\nG150.3 F18000\nM400 P200\n\nM1002 gcode_claim_action : 74 ; Heatbed surface foreign object detection\nM104 S0\n{if curr_bed_type=="Textured PEI Plate"}\nM972 S26 P0 C0\n{else}\nM972 S36 P0 C0 X1\n{endif}\nM972 S35 P0 C0\n\nM972 S41 P0 T5000 ; trash can anti-collision\n\nM1009 Q1 L1\nG91\nG380 S2 Z30 F1200 ; lower heatbed to move toolhead\nG90\nG1 X175 Y160 F30000\nG28 Z P0 T250\nM1009 Q1 L0\n\n\n;===== first homing end =====\n\n;===== detection start =====\n    \nM1002 judge_flag build_plate_detect_flag\nM104 S0\nM622 S1\n    ;M1002 gcode_claim_action : 11 ; Indentifying build plate type\n    M972 S19 P0 C0    ; heatbed presence detection\n    M972 S31 P0 T5000 ; toolhead camera dirty detection\n    ;M1002 gcode_claim_action : 73 ; Build plate alignment detection\n    M972 S34 P0 T5000 ; heatbed plate offset detection\nM623\n\nM1002 gcode_claim_action : 72 ; Hotend Type Detection\nT1001\nM972 S14 P0 T5000 ; nozzle type detection\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]} T{filament_map[initial_no_support_extruder] % 2} ; rise temp in advance\n\nG151 P{filament_map[initial_no_support_extruder] % 2} M ; plug the heat nozzle\n\n{if max_print_z >= 145}\nM1002 gcode_claim_action : 75 ; Heatbed underside foreign object detection\nG3811 Z{max_print_z}  ; Detect obstacles at the bottom of the heated bed\n{endif}\n\n;===== detection end =====\n\nM400\n;M73 P99\n\n;===== prepare print temperature and material ==========\nM400\nM211 X0 Y0 Z0 ;turn off soft endstop\nM975 S1 ; turn on input shaping\n\nG29.2 S0 ; avoid invalid abl data\n\n{if ((filament_type[initial_no_support_extruder] == "PLA") || (filament_type[initial_no_support_extruder] == "PLA-CF") || (filament_type[initial_no_support_extruder] == "PETG")) && (nozzle_diameter[initial_no_support_extruder] == 0.2)}\nM620.10 A0 F74.8347 H{nozzle_diameter[initial_no_support_extruder]} T{flush_temperatures[initial_no_support_extruder]} P{nozzle_temperature_initial_layer[initial_no_support_extruder]} S1\nM620.10 A1 F74.8347 H{nozzle_diameter[initial_no_support_extruder]} T{flush_temperatures[initial_no_support_extruder]} P{nozzle_temperature_initial_layer[initial_no_support_extruder]} S1\n{else}\nM620.10 A0 F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60*0.8} H{nozzle_diameter[initial_no_support_extruder]} T{flush_temperatures[initial_no_support_extruder]} P{nozzle_temperature_initial_layer[initial_no_support_extruder]} S1\nM620.10 A1 F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60*0.8} H{nozzle_diameter[initial_no_support_extruder]} T{flush_temperatures[initial_no_support_extruder]} P{nozzle_temperature_initial_layer[initial_no_support_extruder]} S1\n{endif}\n\nM620.11 P1 I[initial_no_support_extruder] B[initial_no_support_hotend] E0\n\n{if long_retraction_when_ec }\nM620.11 K1 I[initial_no_support_extruder] B[initial_no_support_hotend] R{retraction_distance_when_ec} F{max((flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60), 200)}\n{else}\nM620.11 K0 I[initial_no_support_extruder] B[initial_no_support_hotend] R0\n{endif}\n\nM628 S1\n{if filament_type[initial_no_support_extruder] == "TPU"}\n    M620.11 S0 L0 I[initial_no_support_extruder] B[initial_no_support_hotend] E-{retraction_distances_when_cut[initial_no_support_extruder]} F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60}\n{else}\n{if (filament_type[initial_no_support_extruder] == "PA") ||  (filament_type[initial_no_support_extruder] == "PA-GF")}\n    M620.11 S1 L0 I[initial_no_support_extruder] B[initial_no_support_hotend] R4 D2 E-{retraction_distances_when_cut[initial_no_support_extruder]} F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60}\n{else}\n    M620.11 S1 L0 I[initial_no_support_extruder] B[initial_no_support_hotend] R10 D8 E-{retraction_distances_when_cut[initial_no_support_extruder]} F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60}\n{endif}\n{endif}\nM629\n\nM620 S[initial_no_support_extruder]A H[initial_no_support_hotend] ; switch material if AMS exist\nM1002 gcode_claim_action : 4\nM1002 set_filament_type:UNKNOWN\nM400\nT[initial_no_support_extruder] H[initial_no_support_hotend]\nM400\nM628 S0\nM629\nM400\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM621 S[initial_no_support_extruder]A\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\nM400\nM106 P1 S0\n\nG91\nG1 Y-16 F60000\nG90\n\nG29.2 S1\n;===== prepare print temperature and material ==========\n\n\nM400\n;M73 P99\n\n;===== xy ofst cali start =====\n\nM1002 judge_flag auto_cali_toolhead_offset_flag\n\nM622 J2\n    M1002 gcode_claim_action : 54\n    M190 D[bed_temperature_initial_layer_single]\n    \n    M1002 gcode_claim_action : 39\n    M620 D[initial_no_support_hotend]\n    G383.3 U140 L{initial_no_support_extruder}\nM623\n\nM622 J1\n    M1002 gcode_claim_action : 54\n    M190 D[bed_temperature_initial_layer_single]\n\n    M1002 gcode_claim_action : 39\n    M620 D[initial_no_support_hotend]\n    G383 O2 U140 L{initial_no_support_extruder}\nM623\n\n;===== xy ofst cali end =====\n\n;===== start to heat heatbed & hotend==========\n\n    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}\n    G150.3\n    M104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\n    M140 S[bed_temperature_initial_layer_single]\n\n    ;===== set chamber temperature ==========\n    {if (overall_chamber_temperature >= 40)}\n        M145 P1 ; set airduct mode to heating mode\n        M141 S[overall_chamber_temperature] ; Let Chamber begin to heat\n    {endif}\n    ;===== set chamber temperature ==========\n\n;===== start to heat heatbead & hotend==========\n\n\n\nM400\n;M73 P99\n\n;===== auto extrude cali start =========================\nM975 S1\nM1002 judge_flag extrude_cali_flag\n\nM622 J0\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4} A0.4 ; cali dynamic extrusion compensation\nM623\n\nM622 J1\n    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_no_support_extruder]}\n\n    G90\n    M83\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4} A0.4 ; cali dynamic extrusion compensation\n\n    M400\n    M106 P1 S255\n    M400 S5\n    M106 P1 S0\n    G150.3\nM623\n\nM622 J2\n    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_no_support_extruder]}\n\n    G90\n    M83\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4} A0.4 ; cali dynamic extrusion compensation\n\n    M400\n    M106 P1 S255\n    M400 S5\n    M106 P1 S0\n    G150.3\nM623\n\n;===== auto extrude cali end =========================\n\n{if filament_type[initial_no_support_extruder] == "TPU"}\n    G150.2\n    G150.1\n    G150.2\n    G150.1\n    G150.2\n    G150.1\n{else}\n    G150.3\n    M106 P1 S0\n    M400 S2\n    M109 S{nozzle_temperature[initial_no_support_extruder]} ; wait tmpr to extrude\n    M83\n    {if(nozzle_diameter == 0.8)}\n        G1 E60 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60}\n    {else}\n        G1 E45 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60}\n    {endif}\n    G1 E-3 F1800\n    M400 P500\n    G150.2\n    G150.1\n{endif}\n\nG91\nG1 Y-16 F12000 ; move away from the trash bin\nG90\n\nM400\n;M73 P99\n\n;===== wipe right nozzle start =====\n\nM1002 gcode_claim_action : 14\n    G150 T{nozzle_temperature_initial_layer[initial_no_support_extruder]}\n    {if (overall_chamber_temperature >= 40)}\n        G150 T{nozzle_temperature_initial_layer[initial_no_support_extruder] - 80}\n    {endif}\nM106 S255 ; turn on fan to cool the nozzle\n\n;===== wipe left nozzle end =====\n\nM400\n;M73 P99\n\nM1002 judge_flag auto_cali_toolhead_offset_flag\nM622 J0\n    G91\n    G1 Z5 F1200\n    G90\n    M1012.7\n    G383.7 U140 J0\nM623\n\n{if (overall_chamber_temperature >= 40)}\n    M1002 gcode_claim_action : 49\n    M191 S[overall_chamber_temperature] ; wait for chamber temp\n{endif}\n\nM400\n;M73 P99\n\n;===== bed leveling ==================================\n\nM1002 judge_flag g29_before_print_flag\n\nM190 S[bed_temperature_initial_layer_single]; ensure bed temp\nM109 S140 A\nM106 S0 ; turn off fan , too noisy\n\nG91\nG1 Z10 F1200\n{if (first_non_support_filaments[0] != -1)}\nM640 S\nM83\nG1 E-3 F1500\nM640.7 U\nM640.7 L\nM640.2 R1\nM641\n{endif}\nG90\nG1 X175 Y160 F30000\n\nM622 J1\n    M1002 gcode_claim_action : 1\n    G29.20 A3\n    G29 A1 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]} R \n    M400\nM623\n    \nM622 J2\n    M1002 gcode_claim_action : 1\n    {if has_tpu_in_first_layer}\n        G29.20 A3\n        G29 A1 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]} R\n    {else}\n        G29.20 A4\n        G29 A2 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]} R\n    {endif}\n    M400\nM623\n\nM622 J0\n    G28 R\nM623\n\n;===== bed leveling end ================================\n\nG39.1 ; cali nozzle wrapped detection pos\n\nG90\nG1 Z5 F1200\nG1 X270 Y-0.5 F60000\nG28.140 S0 ; cali pre-extrude z pos\n\n;============switch again==================\nM620 O1\nM211 X0 Y0 Z0 ;turn off soft endstop\nG91\nG1 Z6 F1200\nG90\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM620 S[initial_no_support_extruder]A H[initial_no_support_hotend]\nM400\nT[initial_no_support_extruder] H[initial_no_support_hotend]\nM400\nM628 S0\nM629\nM400\nM621 S[initial_no_support_extruder]A\n\n;============switch again==================\n\nM400\n;M73 P99\n\nM141 S[overall_chamber_temperature]\n\n;===== mech mode sweep start =====\n    M1002 gcode_claim_action : 3\n\n    G90\n    G1 Z5 F1200\n    G1 X165 Y160 F20000\n    M400 P200\n\n    M970.3 Q1 A5 K0 O1\n    M974 Q1 S2 P0\n\n    M970.3 Q0 A5 K0 O1\n    M974 Q0 S2 P0\n\n    M970.2 Q2 K0 W38 Z0.01\n    M974 Q2 S2 P0\n\n    M975 S1\n;===== mech mode sweep end =====\n\n;===== wait temperature reaching the reference value =======\n\nM140 S[bed_temperature_initial_layer_single] \nM190 S[bed_temperature_initial_layer_single] \n\n    ;========turn off light and fans =============\n    M960 S1 P0 ; turn off laser\n    M960 S2 P0 ; turn off laser\n    M106 S0 ; turn off fan\n    M106 P2 S0 ; turn off big fan\n    ;==== set ext toodhead cooling fan ==== \n    {if (min_vitrification_temperature <= 50)}\n    M106 P9 S255\n    {endif}\n    ;============set motor current==================\n    M400 S1\n\n;===== wait temperature reaching the reference value =======\n\nM400\n;M73 P99\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n    {if curr_bed_type=="Textured PEI Plate"}\n        {if nozzle_diameter[initial_no_support_extruder] == 0.2}\n            G29.1 Z{-0.01} ; for Textured PEI Plate\n        {else}\n            G29.1 Z{-0.02} ; for Textured PEI Plate\n        {endif}\n    {else}\n        {if nozzle_diameter[initial_no_support_extruder] == 0.2}\n            G29.1 Z{0.01} ; for Textured PEI Plate\n        {endif}\n    {endif}\nG150.1\n\nM975 S1 ; turn on mech mode supression\nM983.4 S1 ; turn on deformation compensation \nG29.2 S1 ; turn on pos comp\nG29.7 S1\n\nG90\nG1 Z5 F1200\nG1 Y295 F30000\nG1 Y265 F18000\n\n;===== nozzle load line ===============================\n    G29.2 S1 ; ensure z comp turn on\n    G90\n    M83\n    G1 Z5 F1200\n    G1 X270 Y-0.5 F60000\n    G28.14 R0\n    G29.2 S0\n    G91\n    G1 Z0.8 F1200\n    G90\n    G1 X250 F60000\n    M104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\n    \n    ========== record data ==========\n    M1026\n    M1012.8\n    M1012.9\n    G29.9\n    ========== record data ==========\n    \n    M400 P50\n    M500 D1\n    M400 S3\n    M109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\n    M83\n    G91\n    G3 Z0.4 I1.217 J0 P1 F60000\n    G90\n    M83\n    G29.2 S1 ; ensure z comp turn on\n;===== noozle load line end ===========================\n\nM400\n;M73 P99\n\nM993 A1 B1 C1 ; nozzle cam detection allowed.\n\n{if (filament_type[initial_no_support_extruder] == "TPU")}\nM1015.3 S1;enable tpu clog detect\n{else}\nM1015.3 S0;disable tpu clog detect\n{endif}\n\n{if (filament_type[initial_no_support_extruder] == "PLA") ||  (filament_type[initial_no_support_extruder] == "PETG")\n ||  (filament_type[initial_no_support_extruder] == "PLA-CF")  ||  (filament_type[initial_no_support_extruder] == "PETG-CF")}\nM1015.4 S1 K1 H[nozzle_diameter] ;enable E air printing detect\n{else}\nM1015.4 S0 K0 H[nozzle_diameter] ;disable E air printing detect\n{endif}\n\nM620.6 I[initial_no_support_extruder] H[initial_no_support_hotend] W1 ;enable ams air printing detect\n\nM211 Z1\nG29.99\nM1002 gcode_claim_action : 0\nM400\n
; machine_switch_extruder_time = 5
; machine_unload_filament_time = 15
; master_extruder_id = 2
; max_bridge_length = 0
; max_layer_height = 0.28,0.28
; max_travel_detour_distance = 0
; min_bead_width = 85%
; min_feature_size = 25%
; min_layer_height = 0.08,0.08
; minimum_sparse_infill_area = 15
; mmu_segmented_region_interlocking_depth = 0
; mmu_segmented_region_max_width = 0
; monotonic_travel_into_wall = 45%
; no_slow_down_for_cooling_on_outwalls = 0,0,0,0,0
; nozzle_diameter = 0.4,0.4
; nozzle_flush_dataset = 1,1
; nozzle_height = 4
; nozzle_temperature = 220,150,230,230,250
; nozzle_temperature_initial_layer = 220,150,230,230,245
; nozzle_temperature_range_high = 240,180,240,240,270
; nozzle_temperature_range_low = 190,140,190,220,230
; nozzle_type = hardened_steel,hardened_steel
; nozzle_volume = 130,145
; nozzle_volume_type = Standard,Standard
; only_one_wall_first_layer = 0
; ooze_prevention = 0
; other_layers_print_sequence = 0
; other_layers_print_sequence_nums = 0
; outer_wall_acceleration = 25,5000
; outer_wall_jerk = 9
; outer_wall_line_width = 0.42
; outer_wall_speed = 10,200
; overhang_1_4_speed = 0,0
; overhang_2_4_speed = 50,50
; overhang_3_4_speed = 30,30
; overhang_4_4_speed = 10,10
; overhang_fan_speed = 100,100,100,100,50
; overhang_fan_threshold = 50%,50%,50%,25%,10%
; overhang_threshold_participating_cooling = 95%,95%,95%,95%,95%
; overhang_totally_speed = 10,10
; override_filament_scarf_seam_setting = 0
; override_process_overhang_speed = 0,0,0,0,0
; physical_extruder_map = 1,0
; post_process = 
; pre_start_fan_time = 2,2,2,2,2
; precise_outer_wall = 0
; precise_z_height = 0
; pressure_advance = 0.02,0.02,0.02,0.02,0.02
; prime_tower_brim_width = -1
; prime_tower_enable_framework = 0
; prime_tower_extra_rib_length = 0
; prime_tower_fillet_wall = 1
; prime_tower_flat_ironing = 1
; prime_tower_infill_gap = 150%
; prime_tower_lift_height = -1
; prime_tower_lift_speed = 90
; prime_tower_max_speed = 90
; prime_tower_rib_wall = 1
; prime_tower_rib_width = 8
; prime_tower_skip_points = 1
; prime_tower_width = 60
; prime_volume_mode = Default
; print_compatible_printers = "Bambu Lab H2C 0.4 nozzle"
; print_extruder_id = 1,2
; print_extruder_variant = "Direct Drive Standard";"Direct Drive Standard"
; print_flow_ratio = 1
; print_in_clockwise = 0
; print_sequence = by layer
; print_settings_id = 0.20mm Standard @BBL H2C
; printable_area = 0x0,330x0,330x320,0x320
; printable_height = 325
; printer_extruder_id = 1,2
; printer_extruder_variant = "Direct Drive Standard";"Direct Drive Standard"
; printer_model = Bambu Lab H2C
; printer_notes = 
; printer_settings_id = Bambu Lab H2C 0.4 nozzle no flush
; printer_structure = corexy
; printer_technology = FFF
; printer_variant = 0.4
; printhost_authorization_type = key
; printhost_ssl_ignore_revoke = 0
; printing_by_object_gcode = 
; process_notes = 
; raft_contact_distance = 0.1
; raft_expansion = 1.5
; raft_first_layer_density = 90%
; raft_first_layer_expansion = -1
; raft_layers = 0
; reduce_crossing_wall = 0
; reduce_fan_stop_start_freq = 1,1,1,1,1
; reduce_infill_retraction_mode = Auto
; required_nozzle_HRC = 3,3,3,3,3
; resolution = 0.012
; retract_before_wipe = 0%,0%
; retract_length_toolchange = 2,2
; retract_lift_above = 0,0
; retract_lift_below = 319,319
; retract_restart_extra = 0,0
; retract_restart_extra_toolchange = 0,0
; retract_when_changing_layer = 1,1
; retraction_distances_when_cut = 14,14
; retraction_distances_when_ec = 10,10,10,10,10
; retraction_length = 0.8,0.8
; retraction_minimum_travel = 1,1
; retraction_speed = 30,30
; role_base_wipe_speed = 1
; scan_first_layer = 0
; scarf_angle_threshold = 155
; seam_gap = 15%
; seam_placement_away_from_overhangs = 0
; seam_position = aligned
; seam_slope_conditional = 1
; seam_slope_entire_loop = 0
; seam_slope_gap = 0
; seam_slope_inner_walls = 1
; seam_slope_min_length = 10
; seam_slope_start_height = 10%
; seam_slope_steps = 10
; seam_slope_type = none
; silent_mode = 0
; single_extruder_multi_material = 1
; skeleton_infill_density = 100%
; skeleton_infill_line_width = 0.45
; skin_infill_density = 100%
; skin_infill_depth = 2
; skin_infill_line_width = 0.45
; skirt_distance = 2
; skirt_height = 1
; skirt_loops = 0
; slice_closing_radius = 0.049
; slicing_mode = regular
; slow_down_for_layer_cooling = 1,1,1,1,1
; slow_down_layer_time = 4,4,4,10,12
; slow_down_min_speed = 20,20,20,20,10
; slowdown_end_acc = 100000,100000
; slowdown_end_height = 400,400
; slowdown_end_speed = 1000,1000
; slowdown_start_acc = 100000,100000
; slowdown_start_height = 0,0
; slowdown_start_speed = 1000,1000
; small_perimeter_speed = 50%,50%
; small_perimeter_threshold = 0,0
; smooth_coefficient = 4
; smooth_speed_discontinuity_area = 1
; solid_infill_filament = 0
; sparse_infill_acceleration = 100%,100%
; sparse_infill_anchor = 400%
; sparse_infill_anchor_max = 20
; sparse_infill_density = 100%
; sparse_infill_filament = 0
; sparse_infill_lattice_angle_1 = -45
; sparse_infill_lattice_angle_2 = 45
; sparse_infill_line_width = 0.45
; sparse_infill_pattern = concentric
; sparse_infill_speed = 10,350
; spiral_mode = 0
; spiral_mode_max_xy_smoothing = 200%
; spiral_mode_smooth = 0
; standby_temperature_delta = -5
; start_end_points = 30x-3,54x245
; supertack_plate_temp = 40,40,40,0,60
; supertack_plate_temp_initial_layer = 40,40,40,0,60
; support_air_filtration = 0
; support_angle = 0
; support_base_pattern = default
; support_base_pattern_spacing = 2.5
; support_bottom_interface_spacing = 0.5
; support_bottom_z_distance = 0.2
; support_chamber_temp_control = 1
; support_cooling_filter = 1
; support_critical_regions_only = 0
; support_expansion = 0
; support_filament = 0
; support_interface_bottom_layers = 2
; support_interface_filament = 0
; support_interface_loop_pattern = 0
; support_interface_not_for_body = 1
; support_interface_pattern = auto
; support_interface_spacing = 0.5
; support_interface_speed = 10,80
; support_interface_top_layers = 2
; support_ironing_direction = 0
; support_ironing_flow = 10%
; support_ironing_inset = 0
; support_ironing_pattern = zig-zag
; support_ironing_spacing = 0.15
; support_ironing_speed = 30
; support_line_width = 0.42
; support_object_first_layer_gap = 0.2
; support_object_skip_flush = 0
; support_object_xy_distance = 0.35
; support_on_build_plate_only = 0
; support_remove_small_overhang = 1
; support_speed = 10,150
; support_style = default
; support_threshold_angle = 30
; support_top_z_distance = 0.2
; support_type = tree(auto)
; symmetric_infill_y_axis = 0
; temperature_vitrification = 45,45,45,40,60
; template_custom_gcode = 
; textured_plate_temp = 55,55,55,35,60
; textured_plate_temp_initial_layer = 55,55,55,35,60
; thick_bridges = 0
; thumbnail_size = 50x50
; time_lapse_gcode = ;===== machine: H2C timelapse =====\n;======== date: 20260122 ========\n\n; SKIPPABLE_START\n; SKIPTYPE: timelapse\n\nM1002 judge_flag timelapse_record_flag\nM622 J1\n    {if !spiral_mode}\n        M993 A2 B2 C2\n        M993 A0 B0 C0\n    {endif}\n\n    {if !spiral_mode && !(has_timelapse_safe_pos) }\n        {if most_used_physical_extruder_id!= curr_physical_extruder_id || timelapse_type == 1}\n            M83\n            G1 Z{max_layer_z + 0.4} F1200\n            M400\n        {endif}\n    {endif}\n\n    {if has_timelapse_safe_pos && !spiral_mode}\n        M9711 M{timelapse_type} E{most_used_physical_extruder_id} U{timelapse_pos_x} V{timelapse_pos_y} Z{layer_z + 0.4} S11 C10 O0 T3000\n    {else}\n        {if spiral_mode}\n            M971 S11 C10 O0\n            M1004 S5 P1  ; external shutter\n        {else}\n            M9711 M{timelapse_type} E{most_used_physical_extruder_id} Z{layer_z + 0.4} S11 C10 O0 T3000\n        {endif}\n    {endif}\n\n    {if !spiral_mode && !(has_timelapse_safe_pos) }\n        {if most_used_physical_extruder_id!= curr_physical_extruder_id || timelapse_type == 1}\n            G90\n            G1 Z{max_layer_z + 3.0} F1200\n            G1 Y295 F30000\n            G1 Y265 F18000\n            M83\n        {endif}\n    {endif}\n    \n    {if !spiral_mode}\n        M993 A3 B3 C3\n    {endif}\nM623\n; SKIPPABLE_END\n
; timelapse_type = 0
; top_area_threshold = 200%
; top_color_penetration_layers = 5
; top_one_wall_type = all top
; top_shell_layers = 5
; top_shell_thickness = 1
; top_solid_infill_flow_ratio = 1,1
; top_surface_acceleration = 25,2000
; top_surface_density = 100%
; top_surface_jerk = 9
; top_surface_line_width = 0.42
; top_surface_pattern = monotonicline
; top_surface_speed = 10,200
; top_z_overrides_xy_distance = 0
; travel_acceleration = 1000,10000
; travel_jerk = 9
; travel_short_distance_acceleration = 25,250
; travel_speed = 50,1000
; travel_speed_z = 0,0
; tree_support_branch_angle = 45
; tree_support_branch_diameter = 2
; tree_support_branch_diameter_angle = 5
; tree_support_branch_distance = 5
; tree_support_wall_count = -1
; upward_compatible_machine = "Bambu Lab H2S 0.4 nozzle";"Bambu Lab H2D 0.4 nozzle";"Bambu Lab H2D Pro 0.4 nozzle"
; use_firmware_retraction = 0
; use_relative_e_distances = 1
; vertical_shell_speed = 80%,80%
; volumetric_speed_coefficients = "0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0"
; wall_distribution_count = 1
; wall_filament = 0
; wall_generator = classic
; wall_loops = 2
; wall_sequence = inner wall/outer wall
; wall_transition_angle = 10
; wall_transition_filter_deviation = 25%
; wall_transition_length = 100%
; wipe = 1,1
; wipe_distance = 2,2
; wipe_speed = 80%
; wipe_tower_no_sparse_layers = 0
; wipe_tower_rotation_angle = 0
; wipe_tower_x = 165,165,165,165,165,165,165,165,165,165,165
; wipe_tower_y = 250,250,250,250,250,250,250,250,250,250,250
; wrapping_detection_gcode = ;===== machine: H2C =========================\n;===== date: 20251104 =====================\n\n{if !spiral_mode}\n    {if layer_num == 3 || layer_num == 10 || layer_num == 19}\n        M993 A2 B2 C2 ; nozzle cam detection allow status save.\n        M993 A0 B0 C0 ; nozzle cam detection not allowed.\n\n        M400 P100\n\n        G39\n\n        G90\n        G1 Y295 F30000\n        G1 Y265 F18000\n        \n        M993 A3 B3 C3 ; nozzle cam detection allow status restore.\n    {endif}\n{endif}\n
; wrapping_detection_layers = 20
; wrapping_exclude_area = 145x310,251x310,251x326,145x326
; xy_contour_compensation = 0
; xy_hole_compensation = 0
; z_direction_outwall_speed_continuous = 1
; z_hop = 0.4,0.4
; z_hop_types = Auto Lift,Auto Lift
; CONFIG_BLOCK_END

; EXECUTABLE_BLOCK_START
M73 P0 R18
M201 X20000 Y20000 Z500 E5000
M203 X1000 Y1000 Z30 E50
M204 P20000 R5000 T20000
M205 X9.00 Y9.00 Z3.00 E2.50
M106 S0
M106 P2 S0
; FEATURE: Custom
;===== machine: H2C =========================
;===== date: 20260421 =====================

;M1002 set_flag extrude_cali_flag=1
;M1002 set_flag g29_before_print_flag=1
;M1002 set_flag auto_cali_toolhead_offset_flag=1
;M1002 set_flag build_plate_detect_flag=1

M993 A0 B0 C0 ; nozzle cam detection not allowed.

M400
;M73 P99

M960 S10 P1 ; ext fan led

;=====printer start sound ===================
M17
M400 S1
M1006 S1
M1006 A53 B9 L99 C53 D9 M99 E53 F9 N99 
M1006 A56 B9 L99 C56 D9 M99 E56 F9 N99 
M1006 A61 B9 L99 C61 D9 M99 E61 F9 N99 
M1006 A53 B9 L99 C53 D9 M99 E53 F9 N99 
M1006 A56 B9 L99 C56 D9 M99 E56 F9 N99 
M1006 A61 B18 L99 C61 D18 M99 E61 F18 N99 
M1006 W
;=====printer start sound ===================

;===== reset machine status =================
M204 S10000
M630 S0 P0

G90
M17 D ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M1002 set_gcode_claim_speed_level 5 ;Reset speed level
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
G29.1 Z0 ; clear z-trim value first
M983.1 M1 
M901 D4
M481 S0 ; turn off cutter pos comp
G28.140 D0; reset pre-extrude z pos
;===== reset machine status =================

M620 M ;enable remap
M620 N ;enable hotend remap
M620 T0 ;print tmpr
M620 T1 ;sn -> pos
M620 T2 ;filament_id

;===== start to heat heatbed & hotend==========

    M104 O-80 A
    M140 D60

;===== start to heat heatbead & hotend==========

;===== avoid end stop =================
G91
G380 S2 Z42 F1200
G380 S2 Z-12 F1200
G90
;===== avoid end stop =================

;==== set airduct mode ==== 


    M145 P0 ; set airduct mode to cooling mode for cooling
    M106 P2 S178 ; turn on auxiliary fan for cooling
    M106 P3 S127 ; turn on chamber fan for cooling

    M1002 gcode_claim_action : 29
    M191 S0 ; wait for chamber temp
    M106 P2 S0 ; turn off auxiliary fan
    
        
            M142 P1 R30 S40 T45 U0.3 V0.5 W0.8 O45; set PLA/TPU ND0.4 chamber autocooling
        
    

M145.2 P0 F1


;==== set airduct mode ==== 


;====== cog noise reduction=================
M982.2 S1 ; turn on cog noise reduction

;===== first homing start =====
M1002 gcode_claim_action : 13

M640 S
M640.1 R
M641
G28 X T300
T1000

G150.3
M972 S24 P0 T2000 ; live-view camera foolproof
M972 S46 P0 T5000 ; vortek anti-collision
M640.1 S
M640.4

M640 S
M640.8 T A3 H-1
M640.7 L
M641




    M620.14 X163 Y267.675



G150.1 F18000 ; wipe mouth to avoid filament stick to heatbed
G150.3 F18000
M400 P200

M1002 gcode_claim_action : 74 ; Heatbed surface foreign object detection
M104 S0

M972 S26 P0 C0

M972 S35 P0 C0

M972 S41 P0 T5000 ; trash can anti-collision

M1009 Q1 L1
G91
G380 S2 Z30 F1200 ; lower heatbed to move toolhead
G90
G1 X175 Y160 F30000
G28 Z P0 T250
M1009 Q1 L0


;===== first homing end =====

;===== detection start =====
    
M1002 judge_flag build_plate_detect_flag
M104 S0
M622 S1
    ;M1002 gcode_claim_action : 11 ; Indentifying build plate type
    M972 S19 P0 C0    ; heatbed presence detection
    M972 S31 P0 T5000 ; toolhead camera dirty detection
    ;M1002 gcode_claim_action : 73 ; Build plate alignment detection
    M972 S34 P0 T5000 ; heatbed plate offset detection
M623

M1002 gcode_claim_action : 72 ; Hotend Type Detection
T1001
M972 S14 P0 T5000 ; nozzle type detection

M104 S230 T0 ; rise temp in advance

G151 P0 M ; plug the heat nozzle



;===== detection end =====

M400
;M73 P99

;===== prepare print temperature and material ==========
M400
M211 X0 Y0 Z0 ;turn off soft endstop
M975 S1 ; turn on input shaping

G29.2 S0 ; avoid invalid abl data


M620.10 A0 F239.471 H0.4 T240 P230 S1
M620.10 A1 F239.471 H0.4 T240 P230 S1


M620.11 P1 I3 B-1 E0


M620.11 K1 I3 B-1 R10 F299.339


M628 S1


    M620.11 S1 L0 I3 B-1 R10 D8 E-14 F299.339


M629

M620 S3A H-1 ; switch material if AMS exist
M1002 gcode_claim_action : 4
M1002 set_filament_type:UNKNOWN
M400
T3 H-1
M400
M628 S0
M629
M400
M1002 set_filament_type:TPU-AMS
M621 S3A

M104 S230
M400
M106 P1 S0

G91
G1 Y-16 F60000
G90

G29.2 S1
;===== prepare print temperature and material ==========


M400
;M73 P99

;===== xy ofst cali start =====

M1002 judge_flag auto_cali_toolhead_offset_flag

M622 J2
    M1002 gcode_claim_action : 54
    M190 D60
    
    M1002 gcode_claim_action : 39
    M620 D-1
    G383.3 U140 L3
M623

M622 J1
    M1002 gcode_claim_action : 54
    M190 D60

    M1002 gcode_claim_action : 39
    M620 D-1
    G383 O2 U140 L3
M623

;===== xy ofst cali end =====

;===== start to heat heatbed & hotend==========

    M1002 set_filament_type:TPU-AMS
    G150.3
    M104 S230
    M140 S60

    ;===== set chamber temperature ==========
    
    ;===== set chamber temperature ==========

;===== start to heat heatbead & hotend==========



M400
;M73 P99

;===== auto extrude cali start =========================
M975 S1
M1002 judge_flag extrude_cali_flag

M622 J0
    M983.3 F5 A0.4 ; cali dynamic extrusion compensation
M623

M622 J1
    M1002 set_filament_type:TPU-AMS
    M1002 gcode_claim_action : 8

    M109 S230

    G90
    M83
    M983.3 F5 A0.4 ; cali dynamic extrusion compensation

    M400
    M106 P1 S255
    M400 S5
    M106 P1 S0
    G150.3
M623

M622 J2
    M1002 set_filament_type:TPU-AMS
    M1002 gcode_claim_action : 8

    M109 S230

    G90
    M83
    M983.3 F5 A0.4 ; cali dynamic extrusion compensation

    M400
    M106 P1 S255
    M400 S5
    M106 P1 S0
    G150.3
M623

;===== auto extrude cali end =========================


    G150.3
    M106 P1 S0
    M400 S2
    M109 S230 ; wait tmpr to extrude
    M83
    
        G1 E45 F299.339
    
M73 P1 R18
    G1 E-3 F1800
    M400 P500
    G150.2
    G150.1


G91
M73 P2 R17
G1 Y-16 F12000 ; move away from the trash bin
G90

M400
;M73 P99

;===== wipe right nozzle start =====

M1002 gcode_claim_action : 14
    G150 T230
    
M106 S255 ; turn on fan to cool the nozzle

;===== wipe left nozzle end =====

M400
;M73 P99

M1002 judge_flag auto_cali_toolhead_offset_flag
M622 J0
    G91
M73 P3 R17
    G1 Z5 F1200
    G90
    M1012.7
    G383.7 U140 J0
M623



M400
;M73 P99

;===== bed leveling ==================================

M1002 judge_flag g29_before_print_flag

M190 S60; ensure bed temp
M109 S140 A
M106 S0 ; turn off fan , too noisy

G91
G1 Z10 F1200

M640 S
M83
M73 P27 R13
G1 E-3 F1500
M640.7 U
M640.7 L
M640.2 R1
M641

G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X156.157 Y36.247 I44.892 J249.107 R 
    M400
M623
    
M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X156.157 Y36.247 I44.892 J249.107 R
    
    M400
M623

M622 J0
    G28 R
M623

;===== bed leveling end ================================

G39.1 ; cali nozzle wrapped detection pos

G90
G1 Z5 F1200
G1 X270 Y-0.5 F60000
G28.140 S0 ; cali pre-extrude z pos

;============switch again==================
M620 O1
M211 X0 Y0 Z0 ;turn off soft endstop
G91
G1 Z6 F1200
G90
M1002 set_filament_type:TPU-AMS
M620 S3A H-1
M400
T3 H-1
M400
M628 S0
M629
M400
M621 S3A

;============switch again==================

M400
;M73 P99

M141 S0

;===== mech mode sweep start =====
    M1002 gcode_claim_action : 3

    G90
    G1 Z5 F1200
    G1 X165 Y160 F20000
    M400 P200

    M970.3 Q1 A5 K0 O1
    M974 Q1 S2 P0

    M970.3 Q0 A5 K0 O1
    M974 Q0 S2 P0

    M970.2 Q2 K0 W38 Z0.01
    M974 Q2 S2 P0

    M975 S1
;===== mech mode sweep end =====

;===== wait temperature reaching the reference value =======

M140 S60 
M190 S60 

    ;========turn off light and fans =============
    M960 S1 P0 ; turn off laser
    M960 S2 P0 ; turn off laser
    M106 S0 ; turn off fan
    M106 P2 S0 ; turn off big fan
    ;==== set ext toodhead cooling fan ==== 
    
    M106 P9 S255
    
    ;============set motor current==================
    M400 S1

;===== wait temperature reaching the reference value =======

M400
;M73 P99

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
    
        
            G29.1 Z-0.02 ; for Textured PEI Plate
        
    
G150.1

M975 S1 ; turn on mech mode supression
M983.4 S1 ; turn on deformation compensation 
G29.2 S1 ; turn on pos comp
G29.7 S1

G90
G1 Z5 F1200
G1 Y295 F30000
G1 Y265 F18000

;===== nozzle load line ===============================
    G29.2 S1 ; ensure z comp turn on
    G90
    M83
    G1 Z5 F1200
    G1 X270 Y-0.5 F60000
    G28.14 R0
    G29.2 S0
    G91
    G1 Z0.8 F1200
    G90
    G1 X250 F60000
    M104 S230
    
    ========== record data ==========
    M1026
    M1012.8
    M1012.9
    G29.9
    ========== record data ==========
    
    M400 P50
    M500 D1
    M400 S3
    M109 S230
    M83
    G91
    G3 Z0.4 I1.217 J0 P1 F60000
    G90
    M83
    G29.2 S1 ; ensure z comp turn on
;===== noozle load line end ===========================

M400
;M73 P99

M993 A1 B1 C1 ; nozzle cam detection allowed.


M1015.3 S0;disable tpu clog detect



M1015.4 S0 K0 H0.4 ;disable E air printing detect


M620.6 I3 H-1 W1 ;enable ams air printing detect

M211 Z1
G29.99
M1002 gcode_claim_action : 0
M400
; MACHINE_START_GCODE_END
M400
M104 T1 S25 N0 ;Multi extruder pre cooling
; filament start gcode
;VT3 H-1
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
M204 S10000
G1 Z.6 F60000
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
G1 E-.4 F1800
; layer num/total_layer_count: 1/10
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
M106 P2 S0
; OBJECT_ID: 1747
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
G1 X180.257 Y39.415 F60000
M204 S6000
G1 Z1
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
; LAYER_HEIGHT: 0.2
G1 F3000
M204 S500
G1 X187.114 Y39.415 E.25279
G1 X187.114 Y43.079 E.13508
G1 X179.8 Y43.079 E.26964
G1 X179.8 Y39.415 E.13508
G1 X180.197 Y39.415 E.01464
M204 S6000
G1 X180.257 Y39.872 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X186.657 Y39.872 E.23594
G1 X186.657 Y42.622 E.10138
G1 X180.257 Y42.622 E.23594
G1 X180.257 Y39.932 E.09917
; WIPE_START
G1 X182.257 Y39.913 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X174.731 Y41.184 Z.6 F60000
M73 P28 R13
G1 X166.214 Y42.622 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X166.214 Y43.079 E.01685
G1 X158.9 Y43.079 E.26964
G1 X158.9 Y39.415 E.13508
G1 X166.214 Y39.415 E.26964
G1 X166.214 Y42.562 E.11602
M204 S6000
G1 X165.757 Y42.622 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X159.357 Y42.622 E.23594
G1 X159.357 Y39.872 E.10138
G1 X165.757 Y39.872 E.23594
G1 X165.757 Y42.562 E.09917
; WIPE_START
G1 X163.757 Y42.581 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X171.21 Y40.934 Z.6 F60000
G1 X188.55 Y37.104 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X188.55 Y45.39 E.30547
G1 X157.464 Y45.39 E1.14602
G1 X157.464 Y37.104 E.30547
G1 X188.49 Y37.104 E1.1438
M204 S6000
G1 X189.007 Y36.647 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X189.007 Y45.847 E.33917
G1 X157.007 Y45.847 E1.17972
G1 X157.007 Y36.647 E.33917
G1 X188.947 Y36.647 E1.17751
; WIPE_START
G1 X188.96 Y38.647 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X188.367 Y38.226 Z.6 F60000
G1 Z.2
G1 E.4 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50711
G1 F6300
M204 S500
G1 X187.634 Y37.493 E.03883
G1 X186.977 Y37.493 E.02458
G1 X188.162 Y38.677 E.0627
G1 X188.162 Y39.333 E.02458
G1 X186.321 Y37.493 E.09746
G1 X185.664 Y37.493 E.02458
G1 X188.367 Y40.195 E.1431
; WIPE_START
G1 X186.953 Y38.781 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X187.297 Y39.782 Z.6 F60000
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X188.162 Y40.646 E.04577
G1 X188.162 Y41.303 E.02458
G1 X187.503 Y40.644 E.03488
G1 X187.503 Y41.3 E.02458
G1 X188.162 Y41.959 E.03488
G1 X188.162 Y42.616 E.02458
G1 X187.503 Y41.957 E.03488
G1 X187.503 Y42.613 E.02458
G1 X188.162 Y43.272 E.03488
G1 X188.162 Y43.928 E.02458
G1 X187.503 Y43.27 E.03488
G1 X187.503 Y43.468 E.00741
G1 X187.044 Y43.468 E.01717
G1 X188.162 Y44.585 E.05916
G1 X188.162 Y45.001 E.01559
G1 X187.922 Y45.001 E.00898
G1 X186.388 Y43.468 E.08121
G1 X185.731 Y43.468 E.02458
G1 X187.265 Y45.001 E.08121
G1 X186.609 Y45.001 E.02458
G1 X185.075 Y43.468 E.08121
G1 X184.418 Y43.468 E.02458
G1 X185.952 Y45.001 E.08121
G1 X185.296 Y45.001 E.02458
G1 X183.762 Y43.468 E.08121
G1 X183.105 Y43.468 E.02458
G1 X184.639 Y45.001 E.08121
G1 X183.983 Y45.001 E.02458
G1 X182.449 Y43.468 E.08121
G1 X181.792 Y43.468 E.02458
G1 X183.326 Y45.001 E.08121
G1 X182.67 Y45.001 E.02458
G1 X181.136 Y43.468 E.08121
G1 X180.48 Y43.468 E.02458
G1 X182.219 Y45.207 E.0921
; WIPE_START
G1 X180.805 Y43.793 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X186.747 Y39.232 Z.6 F60000
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X185.008 Y37.493 E.0921
G1 X184.352 Y37.493 E.02458
G1 X185.885 Y39.026 E.08121
G1 X185.229 Y39.026 E.02458
G1 X183.695 Y37.493 E.08121
G1 X183.039 Y37.493 E.02458
G1 X184.572 Y39.026 E.08121
G1 X183.916 Y39.026 E.02458
G1 X182.382 Y37.493 E.08121
G1 X181.726 Y37.493 E.02458
G1 X183.259 Y39.026 E.08121
G1 X182.603 Y39.026 E.02458
G1 X181.069 Y37.493 E.08121
G1 X180.413 Y37.493 E.02458
G1 X181.947 Y39.026 E.08121
G1 X181.29 Y39.026 E.02458
G1 X179.756 Y37.493 E.08121
G1 X179.1 Y37.493 E.02458
G1 X180.634 Y39.026 E.08121
G1 X179.977 Y39.026 E.02458
G1 X178.443 Y37.493 E.08121
G1 X177.787 Y37.493 E.02458
G1 X179.412 Y39.117 E.08602
G1 X179.412 Y39.774 E.02458
G1 X177.13 Y37.493 E.12078
G1 X176.474 Y37.493 E.02458
G1 X179.412 Y40.43 E.15554
G1 X179.412 Y41.087 E.02458
G1 X175.817 Y37.493 E.1903
M73 P29 R13
G1 X175.161 Y37.493 E.02458
G1 X179.412 Y41.743 E.22505
G1 X179.412 Y42.4 E.02458
G1 X174.505 Y37.493 E.25981
G1 X173.848 Y37.493 E.02458
G1 X179.412 Y43.056 E.29457
G1 X179.412 Y43.468 E.01541
G1 X179.823 Y43.468 E.01541
G1 X181.357 Y45.001 E.08121
G1 X180.7 Y45.001 E.02458
G1 X173.192 Y37.493 E.39758
G1 X172.535 Y37.493 E.02458
G1 X180.044 Y45.001 E.39758
G1 X179.388 Y45.001 E.02458
G1 X171.879 Y37.493 E.39758
G1 X171.222 Y37.493 E.02458
G1 X178.731 Y45.001 E.39758
G1 X178.075 Y45.001 E.02458
G1 X170.566 Y37.493 E.39758
G1 X169.909 Y37.493 E.02458
G1 X177.418 Y45.001 E.39758
G1 X176.762 Y45.001 E.02458
G1 X169.253 Y37.493 E.39758
G1 X168.596 Y37.493 E.02458
G1 X176.105 Y45.001 E.39758
G1 X175.449 Y45.001 E.02458
G1 X167.94 Y37.493 E.39758
G1 X167.283 Y37.493 E.02458
G1 X174.792 Y45.001 E.39758
G1 X174.136 Y45.001 E.02458
G1 X166.627 Y37.493 E.39758
G1 X165.971 Y37.493 E.02458
G1 X173.479 Y45.001 E.39758
G1 X172.823 Y45.001 E.02458
M73 P29 R12
G1 X165.314 Y37.493 E.39758
G1 X164.658 Y37.493 E.02458
G1 X172.166 Y45.001 E.39758
G1 X171.51 Y45.001 E.02458
G1 X166.603 Y40.094 E.25983
G1 X166.603 Y40.751 E.02458
G1 X170.853 Y45.001 E.22507
G1 X170.197 Y45.001 E.02458
G1 X166.603 Y41.407 E.19031
G1 X166.603 Y42.064 E.02458
G1 X169.541 Y45.001 E.15556
G1 X168.884 Y45.001 E.02458
G1 X166.603 Y42.72 E.1208
G1 X166.603 Y43.376 E.02458
G1 X168.228 Y45.001 E.08604
G1 X167.571 Y45.001 E.02458
G1 X166.037 Y43.468 E.08121
G1 X165.381 Y43.468 E.02458
G1 X166.915 Y45.001 E.08121
G1 X166.258 Y45.001 E.02458
G1 X164.724 Y43.468 E.08121
G1 X164.068 Y43.468 E.02458
G1 X165.602 Y45.001 E.08121
G1 X164.945 Y45.001 E.02458
G1 X163.411 Y43.468 E.08121
G1 X162.755 Y43.468 E.02458
G1 X164.289 Y45.001 E.08121
G1 X163.632 Y45.001 E.02458
G1 X162.099 Y43.468 E.08121
G1 X161.442 Y43.468 E.02458
G1 X162.976 Y45.001 E.08121
G1 X162.319 Y45.001 E.02458
G1 X160.786 Y43.468 E.08121
G1 X160.129 Y43.468 E.02458
G1 X161.663 Y45.001 E.08121
G1 X161.007 Y45.001 E.02458
G1 X159.267 Y43.262 E.0921
; WIPE_START
G1 X160.681 Y44.676 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X163.645 Y37.643 Z.6 F60000
G1 X163.795 Y37.287 Z.6
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X165.535 Y39.026 E.0921
G1 X164.879 Y39.026 E.02458
G1 X163.345 Y37.493 E.08121
G1 X162.688 Y37.493 E.02458
G1 X164.222 Y39.026 E.08121
G1 X163.566 Y39.026 E.02458
G1 X162.032 Y37.493 E.08121
G1 X161.375 Y37.493 E.02458
G1 X162.909 Y39.026 E.08121
G1 X162.253 Y39.026 E.02458
G1 X160.719 Y37.493 E.08121
G1 X160.062 Y37.493 E.02458
G1 X161.596 Y39.026 E.08121
G1 X160.94 Y39.026 E.02458
G1 X159.406 Y37.493 E.08121
G1 X158.749 Y37.493 E.02458
G1 X160.283 Y39.026 E.08121
G1 X159.627 Y39.026 E.02458
G1 X158.093 Y37.493 E.08121
G1 X157.853 Y37.493 E.009
G1 X157.853 Y37.909 E.01558
G1 X158.97 Y39.026 E.05918
G1 X158.512 Y39.026 E.01718
G1 X158.512 Y39.224 E.0074
G1 X157.853 Y38.565 E.03488
G1 X157.853 Y39.222 E.02458
G1 X158.512 Y39.881 E.03488
G1 X158.512 Y40.537 E.02458
G1 X157.853 Y39.878 E.03488
G1 X157.853 Y40.535 E.02458
G1 X158.512 Y41.193 E.03488
G1 X158.512 Y41.85 E.02458
G1 X157.853 Y41.191 E.03488
G1 X157.853 Y41.848 E.02458
G1 X158.717 Y42.712 E.04577
; WIPE_START
G1 X157.853 Y41.848 E-.2323
G1 X157.853 Y41.191 E-.12473
G1 X157.938 Y41.277 E-.02297
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X157.647 Y42.298 Z.6 F60000
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
M73 P30 R12
G1 X160.35 Y45.001 E.14312
G1 X159.694 Y45.001 E.02458
G1 X157.853 Y43.16 E.09747
G1 X157.853 Y43.817 E.02458
G1 X159.037 Y45.001 E.06272
G1 X158.381 Y45.001 E.02458
G1 X157.647 Y44.268 E.03885
; OBJECT_ID: 1563
; WIPE_START
G1 X158.381 Y45.001 E-.19715
G1 X159.037 Y45.001 E-.12473
G1 X158.821 Y44.785 E-.05812
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S6000
G1 X165.529 Y48.426 Z.6 F60000
G1 X179.807 Y56.175 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X186.664 Y56.175 E.25279
G1 X186.664 Y59.839 E.13508
G1 X179.349 Y59.839 E.26964
G1 X179.349 Y56.175 E.13508
G1 X179.747 Y56.175 E.01464
M204 S6000
G1 X179.807 Y56.632 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X186.207 Y56.632 E.23594
G1 X186.207 Y59.382 E.10138
G1 X179.807 Y59.382 E.23594
G1 X179.807 Y56.692 E.09917
; WIPE_START
G1 X181.806 Y56.673 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X174.281 Y57.944 Z.6 F60000
G1 X165.764 Y59.382 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X165.764 Y59.839 E.01685
G1 X158.449 Y59.839 E.26964
G1 X158.449 Y56.175 E.13508
G1 X165.764 Y56.175 E.26964
G1 X165.764 Y59.322 E.11602
M204 S6000
G1 X165.307 Y59.382 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X158.907 Y59.382 E.23594
G1 X158.907 Y56.632 E.10138
G1 X165.307 Y56.632 E.23594
G1 X165.307 Y59.322 E.09917
; WIPE_START
G1 X163.307 Y59.341 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X170.759 Y57.694 Z.6 F60000
G1 X188.099 Y53.864 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X188.099 Y62.15 E.30547
G1 X157.014 Y62.15 E1.14602
G1 X157.014 Y53.864 E.30547
G1 X188.039 Y53.864 E1.1438
M204 S6000
G1 X188.557 Y53.407 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X188.557 Y62.607 E.33917
G1 X156.557 Y62.607 E1.17972
G1 X156.557 Y53.407 E.33917
G1 X188.497 Y53.407 E1.17751
; WIPE_START
G1 X188.51 Y55.407 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X187.917 Y54.986 Z.6 F60000
G1 Z.2
G1 E.4 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50711
G1 F6300
M204 S500
G1 X187.183 Y54.253 E.03883
G1 X186.527 Y54.253 E.02458
G1 X187.711 Y55.437 E.0627
G1 X187.711 Y56.093 E.02458
G1 X185.87 Y54.253 E.09746
G1 X185.214 Y54.253 E.02458
G1 X187.917 Y56.955 E.1431
; WIPE_START
G1 X186.502 Y55.541 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X186.846 Y56.542 Z.6 F60000
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X187.711 Y57.406 E.04577
G1 X187.711 Y58.063 E.02458
G1 X187.052 Y57.404 E.03488
G1 X187.052 Y58.06 E.02458
G1 X187.711 Y58.719 E.03488
G1 X187.711 Y59.376 E.02458
G1 X187.052 Y58.717 E.03488
G1 X187.052 Y59.373 E.02458
G1 X187.711 Y60.032 E.03488
G1 X187.711 Y60.688 E.02458
G1 X187.052 Y60.03 E.03488
G1 X187.052 Y60.228 E.00741
G1 X186.594 Y60.228 E.01717
G1 X187.711 Y61.345 E.05916
G1 X187.711 Y61.761 E.01559
G1 X187.471 Y61.761 E.00898
G1 X185.937 Y60.228 E.08121
G1 X185.281 Y60.228 E.02458
G1 X186.815 Y61.761 E.08121
G1 X186.158 Y61.761 E.02458
G1 X184.624 Y60.228 E.08121
G1 X183.968 Y60.228 E.02458
G1 X185.502 Y61.761 E.08121
G1 X184.845 Y61.761 E.02458
G1 X183.311 Y60.228 E.08121
G1 X182.655 Y60.228 E.02458
G1 X184.189 Y61.761 E.08121
G1 X183.532 Y61.761 E.02458
G1 X181.998 Y60.228 E.08121
G1 X181.342 Y60.228 E.02458
G1 X182.876 Y61.761 E.08121
G1 X182.219 Y61.761 E.02458
G1 X180.685 Y60.228 E.08121
G1 X180.029 Y60.228 E.02458
G1 X181.769 Y61.967 E.0921
; WIPE_START
G1 X180.354 Y60.553 E-.38
; WIPE_END
M73 P31 R12
G1 E-.02 F1800
M204 S6000
G1 X186.297 Y55.992 Z.6 F60000
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X184.557 Y54.253 E.0921
G1 X183.901 Y54.253 E.02458
G1 X185.435 Y55.786 E.08121
G1 X184.778 Y55.786 E.02458
G1 X183.244 Y54.253 E.08121
G1 X182.588 Y54.253 E.02458
G1 X184.122 Y55.786 E.08121
G1 X183.465 Y55.786 E.02458
G1 X181.932 Y54.253 E.08121
G1 X181.275 Y54.253 E.02458
G1 X182.809 Y55.786 E.08121
G1 X182.152 Y55.786 E.02458
G1 X180.619 Y54.253 E.08121
G1 X179.962 Y54.253 E.02458
G1 X181.496 Y55.786 E.08121
G1 X180.84 Y55.786 E.02458
G1 X179.306 Y54.253 E.08121
G1 X178.649 Y54.253 E.02458
G1 X180.183 Y55.786 E.08121
G1 X179.527 Y55.786 E.02458
G1 X177.993 Y54.253 E.08121
G1 X177.336 Y54.253 E.02458
G1 X178.961 Y55.877 E.08602
G1 X178.961 Y56.534 E.02458
G1 X176.68 Y54.253 E.12078
G1 X176.023 Y54.253 E.02458
G1 X178.961 Y57.19 E.15554
G1 X178.961 Y57.847 E.02458
G1 X175.367 Y54.253 E.1903
G1 X174.71 Y54.253 E.02458
G1 X178.961 Y58.503 E.22505
G1 X178.961 Y59.16 E.02458
G1 X174.054 Y54.253 E.25981
G1 X173.398 Y54.253 E.02458
G1 X178.961 Y59.816 E.29457
G1 X178.961 Y60.228 E.01541
G1 X179.373 Y60.228 E.01541
G1 X180.906 Y61.761 E.08121
G1 X180.25 Y61.761 E.02458
G1 X172.741 Y54.253 E.39758
G1 X172.085 Y54.253 E.02458
G1 X179.593 Y61.761 E.39758
G1 X178.937 Y61.761 E.02458
G1 X171.428 Y54.253 E.39758
G1 X170.772 Y54.253 E.02458
G1 X178.281 Y61.761 E.39758
G1 X177.624 Y61.761 E.02458
G1 X170.115 Y54.253 E.39758
G1 X169.459 Y54.253 E.02458
G1 X176.968 Y61.761 E.39758
G1 X176.311 Y61.761 E.02458
G1 X168.802 Y54.253 E.39758
G1 X168.146 Y54.253 E.02458
G1 X175.655 Y61.761 E.39758
G1 X174.998 Y61.761 E.02458
G1 X167.489 Y54.253 E.39758
G1 X166.833 Y54.253 E.02458
G1 X174.342 Y61.761 E.39758
G1 X173.685 Y61.761 E.02458
G1 X166.176 Y54.253 E.39758
G1 X165.52 Y54.253 E.02458
G1 X173.029 Y61.761 E.39758
G1 X172.372 Y61.761 E.02458
G1 X164.864 Y54.253 E.39758
G1 X164.207 Y54.253 E.02458
G1 X171.716 Y61.761 E.39758
G1 X171.059 Y61.761 E.02458
G1 X166.152 Y56.854 E.25983
G1 X166.152 Y57.511 E.02458
G1 X170.403 Y61.761 E.22507
G1 X169.746 Y61.761 E.02458
G1 X166.152 Y58.167 E.19031
G1 X166.152 Y58.824 E.02458
G1 X169.09 Y61.761 E.15556
G1 X168.434 Y61.761 E.02458
G1 X166.152 Y59.48 E.1208
G1 X166.152 Y60.136 E.02458
G1 X167.777 Y61.761 E.08604
G1 X167.121 Y61.761 E.02458
G1 X165.587 Y60.228 E.08121
G1 X164.93 Y60.228 E.02458
G1 X166.464 Y61.761 E.08121
G1 X165.808 Y61.761 E.02458
G1 X164.274 Y60.228 E.08121
G1 X163.617 Y60.228 E.02458
G1 X165.151 Y61.761 E.08121
G1 X164.495 Y61.761 E.02458
G1 X162.961 Y60.228 E.08121
G1 X162.304 Y60.228 E.02458
G1 X163.838 Y61.761 E.08121
G1 X163.182 Y61.761 E.02458
G1 X161.648 Y60.228 E.08121
G1 X160.992 Y60.228 E.02458
G1 X162.525 Y61.761 E.08121
G1 X161.869 Y61.761 E.02458
G1 X160.335 Y60.228 E.08121
G1 X159.679 Y60.228 E.02458
G1 X161.212 Y61.761 E.08121
G1 X160.556 Y61.761 E.02458
G1 X158.816 Y60.022 E.0921
; WIPE_START
G1 X160.231 Y61.436 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X163.195 Y54.403 Z.6 F60000
G1 X163.345 Y54.047 Z.6
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X165.084 Y55.786 E.0921
G1 X164.428 Y55.786 E.02458
G1 X162.894 Y54.253 E.08121
G1 X162.238 Y54.253 E.02458
M73 P32 R12
G1 X163.771 Y55.786 E.08121
G1 X163.115 Y55.786 E.02458
G1 X161.581 Y54.253 E.08121
G1 X160.925 Y54.253 E.02458
G1 X162.459 Y55.786 E.08121
G1 X161.802 Y55.786 E.02458
G1 X160.268 Y54.253 E.08121
G1 X159.612 Y54.253 E.02458
G1 X161.146 Y55.786 E.08121
G1 X160.489 Y55.786 E.02458
G1 X158.955 Y54.253 E.08121
G1 X158.299 Y54.253 E.02458
G1 X159.833 Y55.786 E.08121
G1 X159.176 Y55.786 E.02458
G1 X157.642 Y54.253 E.08121
G1 X157.402 Y54.253 E.009
G1 X157.402 Y54.669 E.01558
G1 X158.52 Y55.786 E.05918
G1 X158.061 Y55.786 E.01718
G1 X158.061 Y55.984 E.0074
G1 X157.402 Y55.325 E.03488
G1 X157.402 Y55.982 E.02458
G1 X158.061 Y56.641 E.03488
G1 X158.061 Y57.297 E.02458
G1 X157.402 Y56.638 E.03488
G1 X157.402 Y57.295 E.02458
G1 X158.061 Y57.953 E.03488
G1 X158.061 Y58.61 E.02458
G1 X157.402 Y57.951 E.03488
G1 X157.402 Y58.608 E.02458
G1 X158.267 Y59.472 E.04577
; WIPE_START
G1 X157.402 Y58.608 E-.2323
G1 X157.402 Y57.951 E-.12473
G1 X157.488 Y58.037 E-.02297
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X157.196 Y59.058 Z.6 F60000
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X159.9 Y61.761 E.14312
G1 X159.243 Y61.761 E.02458
G1 X157.402 Y59.92 E.09747
G1 X157.402 Y60.577 E.02458
G1 X158.587 Y61.761 E.06272
G1 X157.93 Y61.761 E.02458
G1 X157.196 Y61.028 E.03885
; WIPE_START
G1 X157.93 Y61.761 E-.19715
G1 X158.587 Y61.761 E-.12473
G1 X158.37 Y61.545 E-.05812
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.217 J0 P1  F60000
; stop printing object, unique label id: 1563
M625
; object ids of layer 1 start: 1563,1747
M624 AwAAAAAAAAA=
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U173 V131 Z0.6 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; object ids of this layer1 end: 1563,1747
M625
M204 S6000
G1 X198.524 Y282.8
G1 Z.2
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S6000
G1  X199.024 Y283.300  
M204 S500
G3  X196.674 Y285.295   I-4.711 J-3.168 E0.1186 F3000
G3  X193.973 Y284.084   I-0.172 J-3.233 E0.1168
G2  X191.349 Y283.300   I-2.631 J4.026 E0.1056
G2  X174.514 Y283.304   I-8.325 J435.388 E0.6399
G2  X170.716 Y285.152   I0.481 J5.815 E0.1643
G3  X168.456 Y284.766   I-0.859 J-1.780 E0.0930
G1  X167.024 Y283.300   E0.0779
G3  X165.084 Y281.023   I3.772 J-5.179 E0.1147
G3  X166.258 Y278.335   I2.979 J-0.300 E0.1165
G2  X167.024 Y275.849   I-3.669 J-2.492 E0.1004
G1  Y265.050  E0.4104
G1 E-0.4000 F1800
M204 S6000
G1  Y262.550  F600
G1 E0.4000 F1800
M204 S500
G2  X166.678 Y257.787   I-11.963 J-1.524 E0.1827 F3000
G3  X165.056 Y255.336   I36.160 J-25.687 E0.1117
G3  X165.529 Y253.581   I1.814 J-0.453 E0.0721
G1  X167.024 Y252.050   E0.0813
G3  X169.374 Y250.055   I4.711 J3.168 E0.1186
G3  X172.075 Y251.266   I0.172 J3.233 E0.1168
G2  X174.700 Y252.050   I2.631 J-4.026 E0.1056
G1  X183.024  E0.3164
G1  X184.274  E0.0475
G2  X191.903 Y252.018   I3.537 J-65.693 E0.2901
G2  X195.472 Y250.136   I-1.997 J-8.111 E0.1549
G3  X197.592 Y250.584   I0.723 J1.820 E0.0873
G1  X199.024 Y252.050   E0.0779
G3  X200.964 Y254.327   I-3.772 J5.179 E0.1147
G3  X199.790 Y257.015   I-2.979 J0.300 E0.1165
G2  X199.024 Y259.501   I3.669 J2.492 E0.1003
G2  X199.028 Y276.025   I414.315 J8.174 E0.6281
G2  X199.990 Y278.606   I4.477 J-0.200 E0.1064
G1 E-0.4000 F1800
M204 S6000
G1  X201.026 Y280.756   F600
G1 E0.4000 F1800
M204 S500
G3  X200.519 Y281.769   I-1.946 J-0.340 E0.0437 F3000
G1  X199.024 Y283.300   E0.0813
; WIPE_TOWER_END
G1  X167.524 Y272.050   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
;--------------------
; CP EMPTY GRID START
; layer #2
M204 S500
G1  X198.524  E1.1782 F3000
G1  Y272.550  E0.0190
G1  X167.524  E1.1782
G1  Y273.050  E0.0190
G1  X198.524  E1.1782
G1  Y273.550  E0.0190
G1  X167.524  E1.1782
G1  Y274.050  E0.0190
G1  X198.524  E1.1782
G1  Y274.550  E0.0190
G1  X167.524  E1.1782
G1  Y275.050  E0.0190
M73 P33 R12
G1  X198.524  E1.1782
G1  Y275.550  E0.0190
G1  X167.524  E1.1782
G1  Y276.050  E0.0190
G1  X198.524  E1.1782
G1  Y276.550  E0.0190
G1  X167.524  E1.1782
G1  Y277.050  E0.0190
G1  X198.524  E1.1782
G1  Y277.550  E0.0190
G1  X167.524  E1.1782
G1  Y278.050  E0.0190
G1  X198.524  E1.1782
G1  Y278.550  E0.0190
G1  X167.524  E1.1782
G1  Y279.050  E0.0190
G1  X198.524  E1.1782
G1  Y279.550  E0.0190
G1  X167.524  E1.1782
G1  Y280.050  E0.0190
G1  X198.524  E1.1782
G1  Y280.550  E0.0190
G1  X167.524  E1.1782
G1  Y281.050  E0.0190
G1  X198.524  E1.1782
G1  Y281.550  E0.0190
G1  X167.524  E1.1782
G1  Y282.050  E0.0190
G1  X198.524  E1.1782
G1  Y282.550  E0.0190
M73 P34 R12
G1  X167.524  E1.1782
; CP EMPTY GRID END
;------------------






; WIPE_TOWER_END
G1  Y263.300   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S500
G1  Y255.550  E0.2945 F3000
G1  X198.524  E1.1782
G1  Y263.300  E0.2945
G1  X167.524  E1.1782
M204 S6000
G1  X168.524 Y255.550  
;--------------------
; CP EMPTY GRID START
; layer #2
M204 S500
G1  Y256.050  E0.0190
G1  X198.024  E1.1212
G1  Y256.569  E0.0197
G1  X168.024  E1.1402
G1  Y257.088  E0.0197
G1  X198.024  E1.1402
G1  Y257.608  E0.0197
G1  X168.024  E1.1402
G1  Y258.127  E0.0197
G1  X198.024  E1.1402
G1  Y258.646  E0.0197
G1  X168.024  E1.1402
G1  Y259.165  E0.0197
G1  X198.024  E1.1402
G1  Y259.685  E0.0197
G1  X168.024  E1.1402
G1  Y260.204  E0.0197
G1  X198.024  E1.1402
G1  Y260.723  E0.0197
M73 P34 R11
G1  X168.024  E1.1402
G1  Y261.242  E0.0197
G1  X198.024  E1.1402
G1  Y261.762  E0.0197
G1  X168.024  E1.1402
G1  Y262.281  E0.0197
M73 P35 R11
G1  X198.024  E1.1402
G1  Y262.800  E0.0197
G1  X168.024  E1.1402
G1  Y263.300  E0.0190
; CP EMPTY GRID END
;------------------






; WIPE_TOWER_END
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #1
; material : PETG -> PETG
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
G1 E-.4 F1800
G17
G3 Z.6 I1.217 J0 P1  F60000
G1 X167.774 Y252.8
G1 Z.2
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF3 NF4 ON2 NN1
M632 S4 M N
M400
M104 T0 S190 N0
M106 S255
M633
M204 S500
G1  X198.274 Y252.800  E2.4272 F1411
G1  Y253.800  E0.0796
G1  X167.774  E2.4272
G1  Y254.800  E0.0796
G1  X198.274  E2.4272
M632 S4 M N
M204 S6000
G1  Y255.300 
G1  X168.274  F266
G1  Y254.300 
G1  X197.774 
G1  Y253.300 
M73 P36 R11
G1  X168.274 
M633
; NOZZLE_CHANGE_END OF3 NF4 ON2 NN1

G1 E-2 F1800
G17
G3 Z.6 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O2
M620 S4A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z3.2 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X165.524 Y263.8



M620.10 A0 F239.471 L0 H0.4 T240 P230 S1



M620.10 A1 F359.207 L0 H0.4 T270 P245 S1



M620.11 P1 I3 B-1 E-14 F299.339



M620.15 P210
M620.15 C245
M620.11 O1 T14


M620.11 K1 I3 B-1 R10 F299.339


M620.15 C245

M628 S1


M620.11 S1 L0 I3 B-1 R10 D8 E-14 F299.339


M629


;M620.11 H0




T4 H-1
M73 E7

;deretract


M73 P37 R11
;VG1 E4 F449
;VG1 E4 F224



; VFLUSH_START


;VG1 E0 F299


SYNC T0

; compensate for heating and cooling


; VFLUSH_END

M1002 set_filament_type:PETG

M400
M83



M620.10 R2


M628 S0

;VM109 S245

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F7.5 A0.4 R2


M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
M73 P40 R11
G1 Z3.2 F3000

M204 S25


M621 S4A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F7.5 A0.4 R2
M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
M73 P40 R10
G1 Z3.2

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I4 H-1 W1 ;enable ams air printing detect
M620 O2
M1002 gcode_claim_action : 0
M106 S0
M106 P2 S0

; filament start gcode
G1 X167.524 Y263.8 F60000
G1 Z.2
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL1
; LINE_WIDTH: 0.500000
; LINE_WIDTH: 0.500000
M204 S500
G1  X170.524 Y263.800  E0.1140 F990
G1 E-0.4000 F1800
M204 S6000
G1  X166.024  F600
G1  X167.524  F240
G1  X168.024  F600
G1  Y264.300 
G1  X167.024 
G1  Y263.300 
G1  X168.524 
G1  Y264.800 
G1  X166.524 
G1  Y262.800 
G1  X169.024 
G1  Y265.300 
G1  X166.024 
G1  Y262.300 
G1  X170.524 Y263.800   F990
G1 E0.4000 F1800
M204 S500
G1  X198.524  E1.0642 F990
G1  Y264.300  E0.0190
G1  X167.524  E1.1782 F1125
G1  Y264.800  E0.0190
M73 P41 R10
G1  X198.524  E1.1782 F1374
G1  Y265.300  E0.0190
G1  X167.524  E1.1782 F2625
G1  Y265.800  E0.0190
G1  X198.524  E1.1782 F2675
G1  Y266.300  E0.0190
G1  X167.524  E1.1782
G1  Y266.800  E0.0190
G1  X198.524  E1.1782
G1  Y267.300  E0.0190
G1  X167.524  E1.1782
G1  Y267.800  E0.0190
G1  X198.524  E1.1782
G1  Y268.300  E0.0190
G1  X167.524  E1.1782
G1  Y268.800  E0.0190
G1  X198.524  E1.1782
G1  Y269.300  E0.0190
G1  X167.524  E1.1782
G1  Y269.800  E0.0190
G1  X198.524  E1.1782
G1  Y270.300  E0.0190
G1  X167.524  E1.1782
G1  Y270.800  E0.0190
M73 P42 R10
G1  X198.524  E1.1782
G1  Y271.300  E0.0190
G1  X167.524  E1.1782
; LINE_WIDTH: 0.500000
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------



; WIPE_START
G1 F6300
M204 S500
G1 X168.524 Y271.3 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.217 J0 P1  F60000
; OBJECT_ID: 1747
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
M204 S6000
G1 X181.214 Y40.829
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
; LAYER_HEIGHT: 0.2
G1 F3000
M204 S500
G1 X185.7 Y40.829 E.16538
G1 X185.7 Y41.665 E.03082
G1 X181.214 Y41.665 E.16538
G1 X181.214 Y40.889 E.0286
M204 S6000
G1 X180.757 Y40.372 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X186.157 Y40.372 E.19908
G1 X186.157 Y42.122 E.06452
G1 X180.757 Y42.122 E.19908
G1 X180.757 Y40.432 E.0623
; WIPE_START
G1 X181.757 Y40.421 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I-.089 J-1.214 P1  F60000
G1 X164.8 Y41.665 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X160.314 Y41.665 E.16538
G1 X160.314 Y40.829 E.03082
G1 X164.8 Y40.829 E.16538
G1 X164.8 Y41.605 E.0286
M204 S6000
G1 X165.257 Y42.122 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X159.857 Y42.122 E.19908
G1 X159.857 Y40.372 E.06452
G1 X165.257 Y40.372 E.19908
G1 X165.257 Y42.062 E.0623
; WIPE_START
G1 X164.257 Y42.073 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.137 J.433 P1  F60000
G1 X164.571 Y41.247 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.42174
G1 F3000
M204 S500
G1 X160.543 Y41.247 E.1231
; WIPE_START
G1 X161.543 Y41.247 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I0 J1.217 P1  F60000
G1 X181.443 Y41.247 Z.6
G1 Z.2
G1 E.4 F1800
G1 F3000
M204 S500
G1 X185.471 Y41.247 E.1231
; OBJECT_ID: 1563
; WIPE_START
G1 X184.471 Y41.247 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S6000
G17
G3 Z.6 I-1.187 J-.269 P1  F60000
G1 X180.764 Y57.589 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X185.249 Y57.589 E.16538
G1 X185.249 Y58.425 E.03082
G1 X180.764 Y58.425 E.16538
G1 X180.764 Y57.649 E.0286
M204 S6000
G1 X180.307 Y57.132 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X185.707 Y57.132 E.19908
G1 X185.707 Y58.882 E.06452
G1 X180.307 Y58.882 E.19908
G1 X180.307 Y57.192 E.0623
; WIPE_START
G1 X181.306 Y57.181 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I-.089 J-1.214 P1  F60000
G1 X164.349 Y58.425 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X159.864 Y58.425 E.16538
G1 X159.864 Y57.589 E.03082
G1 X164.349 Y57.589 E.16538
G1 X164.349 Y58.365 E.0286
M204 S6000
G1 X164.807 Y58.882 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X159.407 Y58.882 E.19908
G1 X159.407 Y57.132 E.06452
G1 X164.807 Y57.132 E.19908
G1 X164.807 Y58.822 E.0623
; WIPE_START
G1 X163.807 Y58.833 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.137 J.433 P1  F60000
G1 X164.121 Y58.007 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.42174
G1 F3000
M204 S500
G1 X160.092 Y58.007 E.1231
; WIPE_START
G1 X161.092 Y58.007 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I0 J1.217 P1  F60000
G1 X180.992 Y58.007 Z.6
G1 Z.2
G1 E.4 F1800
G1 F3000
M204 S500
G1 X185.021 Y58.007 E.1231
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X184.021 Y58.007 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1563
M625
; layer num/total_layer_count: 2/10
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
; open powerlost recovery
M1003 S1
M104 S250 ; set nozzle temperature
; OBJECT_ID: 1747
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z.6 I1.2 J-.202 P1  F60000
G1 X181.109 Y40.724 Z.6
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F13265.217
M204 S8000
G1 X185.805 Y40.724 E.15418
G1 X185.805 Y41.77 E.03434
G1 X181.109 Y41.77 E.15418
G1 X181.109 Y40.784 E.03237
M204 S250
G1 X180.717 Y40.332 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X186.197 Y40.332 E.16667
G1 X186.197 Y42.162 E.05566
G1 X180.717 Y42.162 E.16667
G1 X180.717 Y40.392 E.05383
; WIPE_START
M204 S8000
G1 X181.717 Y40.381 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-.1 J-1.213 P1  F60000
G1 X164.905 Y41.77 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13265.217
M204 S8000
G1 X160.209 Y41.77 E.15418
G1 X160.209 Y40.724 E.03434
G1 X164.905 Y40.724 E.15418
G1 X164.905 Y41.71 E.03237
M204 S250
G1 X165.297 Y42.162 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X159.817 Y42.162 E.16667
G1 X159.817 Y40.332 E.05566
G1 X165.297 Y40.332 E.16667
G1 X165.297 Y42.102 E.05383
; WIPE_START
M204 S8000
G1 X164.297 Y42.113 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.103 J.515 P1  F60000
G1 X164.701 Y41.247 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.68174
G1 F8453.085
M204 S8000
G1 X160.413 Y41.247 E.22098
; WIPE_START
G1 X161.413 Y41.247 E-.38
; WIPE_END
M73 P43 R10
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I0 J1.217 P1  F60000
G1 X181.313 Y41.247 Z.8
G1 Z.4
G1 E.4 F1800
G1 F8453.085
M204 S8000
G1 X185.601 Y41.247 E.22098
; OBJECT_ID: 1563
; WIPE_START
G1 X184.601 Y41.247 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z.8 I-1.183 J-.287 P1  F60000
G1 X180.659 Y57.484 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13265.217
M204 S8000
G1 X185.354 Y57.484 E.15418
G1 X185.354 Y58.53 E.03434
G1 X180.659 Y58.53 E.15418
G1 X180.659 Y57.544 E.03237
M204 S250
G1 X180.267 Y57.092 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X185.747 Y57.092 E.16667
G1 X185.747 Y58.922 E.05566
G1 X180.267 Y58.922 E.16667
G1 X180.267 Y57.152 E.05383
; WIPE_START
M204 S8000
G1 X181.266 Y57.141 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-.1 J-1.213 P1  F60000
G1 X164.454 Y58.53 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13265.217
M204 S8000
G1 X159.759 Y58.53 E.15418
G1 X159.759 Y57.484 E.03434
G1 X164.454 Y57.484 E.15418
G1 X164.454 Y58.47 E.03237
M204 S250
G1 X164.847 Y58.922 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X159.367 Y58.922 E.16667
G1 X159.367 Y57.092 E.05566
G1 X164.847 Y57.092 E.16667
G1 X164.847 Y58.862 E.05383
; WIPE_START
M204 S8000
G1 X163.847 Y58.873 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.103 J.515 P1  F60000
G1 X164.251 Y58.007 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.68174
G1 F8453.085
M204 S8000
G1 X159.962 Y58.007 E.22098
; WIPE_START
G1 X160.962 Y58.007 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I0 J1.217 P1  F60000
G1 X180.862 Y58.007 Z.8
G1 Z.4
G1 E.4 F1800
G1 F8453.085
M204 S8000
G1 X185.151 Y58.007 E.22098
; WIPE_START
G1 X184.151 Y58.007 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.217 J0 P1  F60000
; stop printing object, unique label id: 1563
M625
; object ids of layer 2 start: 1563,1747
M624 AwAAAAAAAAA=
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U173 V131 Z0.8 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; object ids of this layer2 end: 1563,1747
M625
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #2
; material : TPU-AMS -> TPU-AMS
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
M204 S10000
G1 X167.774 Y264.05
G1 Z.4
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF4 NF3 ON1 NN2
M632 S3 M N
M400
M104 T0 S210 N0
M106 S255
M633
M204 S8000
G1  X198.274 Y264.050  E2.4272 F5642
G1  Y265.550  E0.1194
G1  X167.774  E2.4272
M632 S3 M N
M204 S10000
G1  Y266.300 
G1  X197.774  F3540
G1  Y264.800 
G1  X168.274 
M633
; NOZZLE_CHANGE_END OF4 NF3 ON1 NN2

G1 E-2 F1800
G17
G3 Z.8 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S0 ; disable E air printing detect


M620 O3
M620 S3A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z3.4 F1200

M400
M106 P1 S0
M106 P2 S0


; get travel path for change filament
;M620.1 X54 Y0 F21000 P0
;M620.1 X54 Y0 F21000 P1
;M620.1 X54 Y245 F21000 P2



    M620.14 X200.524 Y260.05



M620.10 A0 F359.207 L0 H0.4 T270 P250 S1



M620.10 A1 F239.471 L0 H0.4 T240 P230 S1



M620.11 P1 I4 B-1 E-14 F449.008



M620.15 P190
M620.15 C220
M620.11 O1 T18


M620.11 K1 I4 B-1 R10 F449.008


M620.15 C220

M628 S1


M620.11 S1 L0 I4 B-1 R10 D8 E-14 F449.008


M629


;M620.11 H0




T3 H-1
M73 E6

;deretract


;VG1 E4 F299
;VG1 E4 F149



; VFLUSH_START


;VG1 E0 F299


SYNC T0

; compensate for heating and cooling


; VFLUSH_END

M1002 set_filament_type:TPU-AMS

M400
M83



M620.10 R2


M628 S0

;VM109 S230

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F5 A0.4 R2


M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
M73 P46 R9
G1 Z3.4 F3000

M204 S25


M621 S3A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F5 A0.4 R2
M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.4

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S0 ; disable E air printing detect


M620.6 I3 H-1 W1 ;enable ams air printing detect
M620 O3
M1002 gcode_claim_action : 0
M106 S51
M106 P2 S255

; filament start gcode
G1 X198.524 Y260.05 F60000
G1 Z.4
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X195.524 Y260.050  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X200.024  F600
G1  X198.524  F240
G1  X199.024  F600
G1  Y260.550 
G1  X198.024 
G1  Y259.550 
G1  X199.524 
G1  Y261.050 
G1  X197.524 
G1  Y259.050 
G1  X195.524 Y260.050   F1782
G1 E0.4000 F1800
M400
M104 T0 S230 N0
M204 S8000
G1  X167.524  E1.0642 F1782
G1  Y259.300  E0.0285
G1  X198.524  E1.1782 F2025
G1  Y258.550  E0.0285
G1  X167.524  E1.1782 F2473
G1  Y257.800  E0.0285
G1  X198.524  E1.1782 F4725
G1  Y257.050  E0.0285
G1  X167.524  E1.1782 F4775
G1  Y256.300  E0.0285
M73 P47 R9
G1  X198.524  E1.1782
G1  Y255.550  E0.0285
G1  X167.524  E1.1782
G1  Y254.800  E0.0285
G1  X198.524  E1.1782
G1  Y254.050  E0.0285
G1  X167.524  E1.1782
G1  Y253.300  E0.0285
G1  X198.524  E1.1782
G1  Y252.550  E0.0285
G1  X167.524  E1.1782
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  X198.524 Y282.800   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X199.024 Y283.300  
M204 S8000
G3  X196.674 Y285.295   I-4.711 J-3.168 E0.1186
G3  X193.973 Y284.084   I-0.172 J-3.233 E0.1168
G2  X191.349 Y283.300   I-2.631 J4.026 E0.1056
G2  X174.514 Y283.304   I-8.325 J435.388 E0.6399
G2  X170.716 Y285.152   I0.481 J5.815 E0.1643
G3  X168.456 Y284.766   I-0.859 J-1.780 E0.0930
G1  X167.024 Y283.300   E0.0779
G3  X165.084 Y281.023   I3.772 J-5.179 E0.1147
G3  X166.258 Y278.335   I2.979 J-0.300 E0.1165
G2  X167.024 Y275.849   I-3.669 J-2.492 E0.1004
G2  X167.020 Y259.325   I-414.299 J-8.174 E0.6281
G2  X165.150 Y255.613   I-7.052 J1.226 E0.1603
G3  X165.529 Y253.581   I1.718 J-0.731 E0.0832
G1  X167.024 Y252.050   E0.0813
G3  X169.374 Y250.055   I4.711 J3.168 E0.1186
G3  X172.075 Y251.266   I0.172 J3.233 E0.1168
G2  X174.700 Y252.050   I2.631 J-4.026 E0.1056
G1  X183.024  E0.3164
G1  X184.274  E0.0475
G2  X191.903 Y252.018   I3.537 J-65.693 E0.2901
G2  X195.472 Y250.136   I-1.997 J-8.111 E0.1549
G3  X197.592 Y250.584   I0.723 J1.820 E0.0873
G1  X199.024 Y252.050   E0.0779
G3  X200.964 Y254.327   I-3.772 J5.179 E0.1147
G3  X199.790 Y257.015   I-2.979 J0.300 E0.1165
G2  X199.080 Y258.800   I3.685 J2.500 E0.0736
G1 E-0.4000 F1800
M204 S10000
G1  X199.024 Y261.300   F600
G1 E0.4000 F1800
M204 S8000
G2  X199.028 Y276.025   I369.198 J7.275 E0.5597 F5400
G2  X199.990 Y278.606   I4.477 J-0.200 E0.1064
G1 E-0.4000 F1800
M204 S10000
G1  X201.026 Y280.756   F600
G1 E0.4000 F1800
M204 S8000
G3  X200.519 Y281.769   I-1.946 J-0.340 E0.0437 F5400
G1  X199.024 Y283.300   E0.0813
; WIPE_TOWER_END

; WIPE_START
G1 F8453.085
M204 S8000
G1 X199.024 Y283.3 E-.00001
G1 X199.024 Y283.3 E-.00001
G1 X200.422 Y281.869 E-.37998
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.217 J0 P1  F60000
; OBJECT_ID: 1747
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
M204 S10000
G1 X159.397 Y39.912
G1 Z.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.2
G1 F9547.055
M204 S5000
G1 X159.397 Y42.582 E.0812
G1 X165.297 Y42.582 E.17944
G1 X165.297 Y46.037 E.10508
G1 X156.817 Y46.037 E.25791
G1 X156.817 Y36.457 E.29136
G1 X165.297 Y36.457 E.25791
G1 X165.297 Y39.912 E.10508
G1 X159.457 Y39.912 E.17762
; WIPE_START
M204 S8000
G1 X159.412 Y41.912 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X167.031 Y41.459 Z.8 F60000
G1 X170.609 Y41.247 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X170.609 Y36.849 E.1444
G1 X175.405 Y36.849 E.15746
G1 X175.405 Y45.645 E.2888
G1 X170.609 Y45.645 E.15746
G1 X170.609 Y41.307 E.14243
M204 S250
G1 X170.217 Y41.247 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X170.217 Y36.457 E.14568
G1 X175.797 Y36.457 E.16971
G1 X175.797 Y46.037 E.29136
G1 X170.217 Y46.037 E.16971
G1 X170.217 Y41.307 E.14386
; WIPE_START
M204 S8000
G1 X170.217 Y39.307 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X177.837 Y39.746 Z.8 F60000
G1 X180.717 Y39.912 Z.8
G1 Z.4
G1 E.4 F1800
G1 F9547.055
M204 S5000
G1 X180.717 Y36.457 E.10508
G1 X189.197 Y36.457 E.25791
G1 X189.197 Y46.037 E.29136
G1 X180.717 Y46.037 E.25791
G1 X180.717 Y42.582 E.10508
G1 X186.617 Y42.582 E.17944
G1 X186.617 Y39.912 E.0812
G1 X180.777 Y39.912 E.17762
; WIPE_START
M204 S8000
G1 X180.742 Y37.912 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X175.013 Y39.247 Z.8 F60000
G1 Z.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X175.013 Y37.241 E.061
G1 X171.001 Y37.241 E.12201
G1 X171.001 Y45.253 E.24366
G1 X175.013 Y45.253 E.12201
G1 X175.013 Y39.307 E.18083
M204 S10000
G1 X174.636 Y39.247 F60000
G1 F9547.299
M204 S8000
G1 X174.636 Y37.618 E.04954
G1 X171.378 Y37.618 E.09907
G1 X171.378 Y44.876 E.22073
G1 X174.636 Y44.876 E.09907
G1 X174.636 Y39.307 E.16936
M204 S10000
G1 X174.259 Y39.247 F60000
G1 F9547.299
M204 S8000
G1 X174.259 Y37.995 E.03807
G1 X171.755 Y37.995 E.07614
G1 X171.755 Y44.499 E.19779
G1 X174.259 Y44.499 E.07614
G1 X174.259 Y39.307 E.1579
M204 S10000
G1 X173.882 Y39.247 F60000
G1 F9547.299
M204 S8000
G1 X173.882 Y38.372 E.0266
G1 X172.132 Y38.372 E.0532
G1 X172.132 Y44.122 E.17485
G1 X173.882 Y44.122 E.0532
G1 X173.882 Y39.307 E.14643
M204 S10000
G1 X173.505 Y39.247 F60000
G1 F9547.299
M204 S8000
G1 X173.505 Y38.749 E.01513
G1 X172.509 Y38.749 E.03027
G1 X172.509 Y43.745 E.15192
G1 X173.505 Y43.745 E.03027
G1 X173.505 Y39.307 E.13496
M204 S10000
G1 X173.162 Y39.247 F60000
; LINE_WIDTH: 0.35198
G1 F11648.225
M204 S8000
G1 X173.162 Y39.092 E.00385
G1 X172.853 Y39.092 E.0077
G1 X172.853 Y43.402 E.10741
G1 X173.162 Y43.402 E.0077
G1 X173.162 Y39.307 E.10207
; WIPE_START
G1 X173.162 Y41.307 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X166.275 Y44.598 Z.8 F60000
G1 X165.09 Y45.165 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S2000
G1 X164.425 Y45.83 E.02859
G1 X164.291 Y45.963
G1 X163.758 Y45.963
G1 X163.892 Y45.83
G1 X165.09 Y44.632 E.05153
G1 X165.223 Y44.498
G1 X165.223 Y43.965
G1 X165.09 Y44.098
G1 X163.358 Y45.83 E.07446
G1 X163.225 Y45.963
G1 X162.692 Y45.963
G1 X162.825 Y45.83
G1 X165.09 Y43.565 E.0974
G1 X165.223 Y43.431
G1 X165.223 Y42.898
G1 X165.09 Y43.032
G1 X162.292 Y45.83 E.12034
G1 X162.158 Y45.963
G1 X161.625 Y45.963
G1 X161.759 Y45.83
G1 X164.799 Y42.789 E.13076
G1 X164.933 Y42.656
G1 X164.399 Y42.656
G1 X164.266 Y42.789
G1 X161.225 Y45.83 E.13076
G1 X161.092 Y45.963
G1 X160.559 Y45.963
G1 X160.692 Y45.83
G1 X163.732 Y42.789 E.13076
G1 X163.866 Y42.656
G1 X163.333 Y42.656
G1 X163.199 Y42.789
G1 X160.159 Y45.83 E.13076
G1 X160.025 Y45.963
G1 X159.492 Y45.963
G1 X159.626 Y45.83
G1 X162.666 Y42.789 E.13076
G1 X162.8 Y42.656
G1 X162.266 Y42.656
G1 X162.133 Y42.789
G1 X159.092 Y45.83 E.13076
G1 X158.959 Y45.963
G1 X158.425 Y45.963
G1 X158.559 Y45.83
G1 X161.599 Y42.789 E.13076
G1 X161.733 Y42.656
G1 X161.2 Y42.656
G1 X161.066 Y42.789
G1 X158.026 Y45.83 E.13076
G1 X157.892 Y45.963
G1 X157.359 Y45.963
G1 X157.493 Y45.83
G1 X160.533 Y42.789 E.13076
G1 X160.666 Y42.656
G1 X160.133 Y42.656
G1 X160 Y42.789
G1 X157.024 Y45.765 E.12796
G1 X156.891 Y45.898
M73 P48 R9
G1 X156.891 Y45.365
G1 X157.024 Y45.231
G1 X159.466 Y42.789 E.10503
G1 X159.6 Y42.656
G1 X159.323 Y42.399
G1 X159.19 Y42.533
G1 X157.024 Y44.698 E.09313
G1 X156.891 Y44.832
G1 X156.891 Y44.298
G1 X157.024 Y44.165
G1 X159.19 Y42 E.09313
G1 X159.323 Y41.866
G1 X159.323 Y41.333
G1 X159.19 Y41.466
G1 X157.024 Y43.631 E.09313
G1 X156.891 Y43.765
G1 X156.891 Y43.232
G1 X157.024 Y43.098
G1 X159.19 Y40.933 E.09313
G1 X159.323 Y40.799
G1 X159.323 Y40.266
G1 X159.19 Y40.4
G1 X157.024 Y42.565 E.09313
G1 X156.891 Y42.699
G1 X156.891 Y42.165
G1 X157.024 Y42.032
G1 X159.19 Y39.867 E.09313
; WIPE_START
M204 S8000
G1 X157.775 Y41.281 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X164.684 Y39.705 Z.8 F60000
G1 Z.4
G1 E.4 F1800
G1 F9547.055
M204 S2000
G1 X165.09 Y39.299 E.01744
G1 X165.223 Y39.165
G1 X165.223 Y38.632
G1 X165.09 Y38.766
G1 X164.151 Y39.705 E.04038
G1 X164.017 Y39.838
G1 X163.484 Y39.838
G1 X163.618 Y39.705
G1 X165.09 Y38.233 E.06332
G1 X165.223 Y38.099
G1 X165.223 Y37.566
G1 X165.09 Y37.699
G1 X163.084 Y39.705 E.08625
G1 X162.951 Y39.838
G1 X162.417 Y39.838
G1 X162.551 Y39.705
G1 X165.09 Y37.166 E.10919
G1 X165.223 Y37.032
G1 X165.192 Y36.531
G1 X165.058 Y36.664
G1 X162.018 Y39.705 E.13076
G1 X161.884 Y39.838
G1 X161.351 Y39.838
G1 X161.485 Y39.705
G1 X164.525 Y36.664 E.13076
G1 X164.658 Y36.531
G1 X164.125 Y36.531
G1 X163.992 Y36.664
G1 X160.951 Y39.705 E.13076
G1 X160.818 Y39.838
G1 X160.284 Y39.838
G1 X160.418 Y39.705
G1 X163.458 Y36.664 E.13076
G1 X163.592 Y36.531
G1 X163.059 Y36.531
G1 X162.925 Y36.664
G1 X159.885 Y39.705 E.13076
G1 X159.751 Y39.838
G1 X159.218 Y39.838
G1 X159.352 Y39.705
G1 X162.392 Y36.664 E.13076
G1 X162.525 Y36.531
G1 X161.992 Y36.531
G1 X161.859 Y36.664
G1 X157.024 Y41.498 E.20792
G1 X156.891 Y41.632
G1 X156.891 Y41.099
G1 X157.024 Y40.965
G1 X161.325 Y36.664 E.18498
G1 X161.459 Y36.531
G1 X160.926 Y36.531
G1 X160.792 Y36.664
G1 X157.024 Y40.432 E.16205
G1 X156.891 Y40.566
G1 X156.891 Y40.032
G1 X157.024 Y39.899
G1 X160.259 Y36.664 E.13911
G1 X160.392 Y36.531
G1 X159.859 Y36.531
G1 X159.726 Y36.664
G1 X157.024 Y39.365 E.11618
G1 X156.891 Y39.499
G1 X156.891 Y38.966
G1 X157.024 Y38.832
G1 X159.192 Y36.664 E.09324
G1 X159.326 Y36.531
G1 X158.793 Y36.531
G1 X158.659 Y36.664
G1 X157.024 Y38.299 E.0703
G1 X156.891 Y38.433
G1 X156.891 Y37.899
G1 X157.024 Y37.766
G1 X158.126 Y36.664 E.04737
G1 X158.259 Y36.531
G1 X157.726 Y36.531
G1 X157.592 Y36.664
G1 X157.024 Y37.232 E.02443
; WIPE_START
M204 S8000
G1 X157.592 Y36.664 E-.15263
G1 X157.726 Y36.531 E-.03591
G1 X158.259 Y36.531 E-.10132
G1 X158.126 Y36.664 E-.03591
G1 X157.924 Y36.866 E-.05424
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X165.292 Y38.857 Z.8 F60000
G1 X188.99 Y45.261 Z.8
G1 Z.4
G1 E.4 F1800
G1 F9547.055
M204 S2000
G1 X188.422 Y45.83 E.02444
G1 X188.288 Y45.963
G1 X187.755 Y45.963
G1 X187.888 Y45.83
G1 X188.99 Y44.728 E.04737
G1 X189.123 Y44.595
G1 X189.123 Y44.061
G1 X188.99 Y44.195
G1 X187.355 Y45.83 E.07031
G1 X187.221 Y45.963
G1 X186.688 Y45.963
G1 X186.822 Y45.83
G1 X188.99 Y43.662 E.09325
G1 X189.123 Y43.528
G1 X189.123 Y42.995
G1 X188.99 Y43.128
G1 X186.289 Y45.83 E.11618
G1 X186.155 Y45.963
G1 X185.622 Y45.963
G1 X185.755 Y45.83
G1 X188.99 Y42.595 E.13912
G1 X189.123 Y42.462
G1 X189.123 Y41.928
G1 X188.99 Y42.062
G1 X185.222 Y45.83 E.16205
G1 X185.088 Y45.963
G1 X184.555 Y45.963
G1 X184.689 Y45.83
G1 X188.99 Y41.529 E.18499
G1 X189.123 Y41.395
G1 X189.123 Y40.862
G1 X188.99 Y40.995
G1 X184.155 Y45.83 E.20793
G1 X184.022 Y45.963
G1 X183.489 Y45.963
G1 X183.622 Y45.83
G1 X186.662 Y42.789 E.13076
G1 X186.796 Y42.656
G1 X186.263 Y42.656
G1 X186.129 Y42.789
G1 X183.089 Y45.83 E.13076
G1 X182.955 Y45.963
G1 X182.422 Y45.963
G1 X182.556 Y45.83
G1 X185.596 Y42.789 E.13076
G1 X185.73 Y42.656
G1 X185.196 Y42.656
G1 X185.063 Y42.789
G1 X182.022 Y45.83 E.13076
G1 X181.889 Y45.963
G1 X181.356 Y45.963
G1 X181.489 Y45.83
G1 X184.529 Y42.789 E.13076
G1 X184.663 Y42.656
G1 X184.13 Y42.656
G1 X183.996 Y42.789
G1 X180.956 Y45.83 E.13076
G1 X180.822 Y45.963
G1 X180.791 Y45.461
G1 X180.924 Y45.328
G1 X183.463 Y42.789 E.10918
G1 X183.597 Y42.656
G1 X183.063 Y42.656
G1 X182.93 Y42.789
G1 X180.924 Y44.795 E.08625
G1 X180.791 Y44.928
G1 X180.791 Y44.395
G1 X180.924 Y44.261
G1 X182.396 Y42.789 E.06331
G1 X182.53 Y42.656
G1 X181.997 Y42.656
G1 X181.863 Y42.789
G1 X180.924 Y43.728 E.04037
G1 X180.791 Y43.862
G1 X180.791 Y43.328
G1 X180.924 Y43.195
G1 X181.33 Y42.789 E.01744
; WIPE_START
M204 S8000
G1 X180.924 Y43.195 E-.10893
G1 X180.791 Y43.328 E-.03591
G1 X180.791 Y43.862 E-.10132
G1 X180.924 Y43.728 E-.03591
G1 X181.289 Y43.364 E-.09793
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X186.824 Y42.627 Z.8 F60000
G1 Z.4
G1 E.4 F1800
G1 F9547.055
M204 S2000
G1 X188.99 Y40.462 E.09313
G1 X189.123 Y40.329
G1 X189.123 Y39.795
G1 X188.99 Y39.929
G1 X186.824 Y42.094 E.09313
G1 X186.691 Y42.228
G1 X186.691 Y41.695
G1 X186.824 Y41.561
G1 X188.99 Y39.396 E.09313
G1 X189.123 Y39.262
G1 X189.123 Y38.729
G1 X188.99 Y38.862
G1 X186.824 Y41.028 E.09313
G1 X186.691 Y41.161
G1 X186.691 Y40.628
G1 X186.824 Y40.494
G1 X188.99 Y38.329 E.09313
G1 X189.123 Y38.196
G1 X189.123 Y37.662
G1 X188.99 Y37.796
G1 X186.824 Y39.961 E.09313
G1 X186.691 Y40.095
G1 X186.414 Y39.838
G1 X186.548 Y39.705
G1 X188.99 Y37.263 E.10503
G1 X189.123 Y37.129
G1 X189.123 Y36.596
G1 X188.99 Y36.729
G1 X186.014 Y39.705 E.12797
G1 X185.881 Y39.838
G1 X185.348 Y39.838
G1 X185.481 Y39.705
G1 X188.521 Y36.664 E.13076
G1 X188.655 Y36.531
G1 X188.122 Y36.531
G1 X187.988 Y36.664
G1 X184.948 Y39.705 E.13076
G1 X184.814 Y39.838
G1 X184.281 Y39.838
G1 X184.415 Y39.705
G1 X187.455 Y36.664 E.13076
G1 X187.589 Y36.531
G1 X187.055 Y36.531
G1 X186.922 Y36.664
G1 X183.881 Y39.705 E.13076
G1 X183.748 Y39.838
G1 X183.215 Y39.838
G1 X183.348 Y39.705
G1 X186.388 Y36.664 E.13076
G1 X186.522 Y36.531
G1 X185.989 Y36.531
G1 X185.855 Y36.664
G1 X182.815 Y39.705 E.13076
G1 X182.681 Y39.838
G1 X182.148 Y39.838
G1 X182.282 Y39.705
G1 X185.322 Y36.664 E.13076
G1 X185.456 Y36.531
G1 X184.922 Y36.531
G1 X184.789 Y36.664
G1 X181.748 Y39.705 E.13076
G1 X181.615 Y39.838
G1 X181.081 Y39.838
G1 X181.215 Y39.705
G1 X184.255 Y36.664 E.13076
G1 X184.389 Y36.531
G1 X183.856 Y36.531
G1 X183.722 Y36.664
G1 X180.924 Y39.462 E.12033
G1 X180.791 Y39.596
G1 X180.791 Y39.062
G1 X180.924 Y38.929
G1 X183.189 Y36.664 E.09739
G1 X183.322 Y36.531
G1 X182.789 Y36.531
G1 X182.656 Y36.664
G1 X180.924 Y38.396 E.07446
G1 X180.791 Y38.529
G1 X180.791 Y37.996
G1 X180.924 Y37.862
G1 X182.122 Y36.664 E.05152
G1 X182.256 Y36.531
G1 X181.723 Y36.531
G1 X181.589 Y36.664
G1 X180.924 Y37.329 E.02859
; OBJECT_ID: 1563
; WIPE_START
M204 S8000
G1 X181.589 Y36.664 E-.17858
G1 X181.723 Y36.531 E-.03591
G1 X182.256 Y36.531 E-.10132
G1 X182.122 Y36.664 E-.03591
G1 X182.017 Y36.77 E-.02829
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S10000
G1 X176.238 Y41.755 Z.8 F60000
G1 X158.947 Y56.672 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Outer wall
G1 F9547.055
M204 S5000
G1 X158.947 Y59.342 E.0812
G1 X164.847 Y59.342 E.17944
G1 X164.847 Y62.797 E.10508
G1 X156.367 Y62.797 E.25791
G1 X156.367 Y53.217 E.29136
G1 X164.847 Y53.217 E.25791
G1 X164.847 Y56.672 E.10508
G1 X159.007 Y56.672 E.17762
; WIPE_START
M204 S8000
G1 X158.962 Y58.671 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X166.581 Y58.219 Z.8 F60000
G1 X170.159 Y58.007 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X170.159 Y53.609 E.1444
G1 X174.954 Y53.609 E.15746
G1 X174.954 Y62.405 E.2888
G1 X170.159 Y62.405 E.15746
G1 X170.159 Y58.067 E.14243
M204 S250
G1 X169.767 Y58.007 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S5000
G1 X169.767 Y53.217 E.14568
G1 X175.347 Y53.217 E.16971
G1 X175.347 Y62.797 E.29136
G1 X169.767 Y62.797 E.16971
G1 X169.767 Y58.067 E.14386
; WIPE_START
M204 S8000
G1 X169.767 Y56.067 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X177.386 Y56.506 Z.8 F60000
G1 X180.267 Y56.672 Z.8
G1 Z.4
G1 E.4 F1800
G1 F9547.055
M204 S5000
G1 X180.267 Y53.217 E.10508
G1 X188.747 Y53.217 E.25791
G1 X188.747 Y62.797 E.29136
G1 X180.267 Y62.797 E.25791
G1 X180.267 Y59.342 E.10508
G1 X186.167 Y59.342 E.17944
G1 X186.167 Y56.672 E.0812
G1 X180.327 Y56.672 E.17762
; WIPE_START
M204 S8000
G1 X180.292 Y54.672 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X174.562 Y56.007 Z.8 F60000
G1 Z.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X174.562 Y54.001 E.061
G1 X170.551 Y54.001 E.12201
G1 X170.551 Y62.013 E.24366
G1 X174.562 Y62.013 E.12201
G1 X174.562 Y56.067 E.18083
M204 S10000
G1 X174.185 Y56.007 F60000
G1 F9547.299
M204 S8000
G1 X174.185 Y54.378 E.04954
G1 X170.928 Y54.378 E.09907
G1 X170.928 Y61.636 E.22073
G1 X174.185 Y61.636 E.09907
G1 X174.185 Y56.067 E.16936
M204 S10000
G1 X173.808 Y56.007 F60000
G1 F9547.299
M204 S8000
G1 X173.808 Y54.755 E.03807
G1 X171.305 Y54.755 E.07614
G1 X171.305 Y61.259 E.19779
G1 X173.808 Y61.259 E.07614
G1 X173.808 Y56.067 E.1579
M204 S10000
G1 X173.431 Y56.007 F60000
G1 F9547.299
M204 S8000
G1 X173.431 Y55.132 E.0266
G1 X171.682 Y55.132 E.0532
G1 X171.682 Y60.882 E.17485
G1 X173.431 Y60.882 E.0532
G1 X173.431 Y56.067 E.14643
M204 S10000
G1 X173.054 Y56.007 F60000
G1 F9547.299
M204 S8000
G1 X173.054 Y55.509 E.01513
G1 X172.059 Y55.509 E.03027
G1 X172.059 Y60.505 E.15192
G1 X173.054 Y60.505 E.03027
G1 X173.054 Y56.067 E.13496
M204 S10000
G1 X172.711 Y56.007 F60000
; LINE_WIDTH: 0.35198
G1 F11648.225
M204 S8000
G1 X172.711 Y55.852 E.00385
G1 X172.402 Y55.852 E.0077
G1 X172.402 Y60.162 E.10741
G1 X172.711 Y60.162 E.0077
G1 X172.711 Y56.067 E.10207
; WIPE_START
G1 X172.711 Y58.067 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X165.825 Y61.358 Z.8 F60000
G1 X164.639 Y61.925 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F9547.055
M204 S2000
G1 X163.974 Y62.59 E.02859
G1 X163.841 Y62.723
G1 X163.308 Y62.723
G1 X163.441 Y62.59
G1 X164.639 Y61.392 E.05153
G1 X164.773 Y61.258
G1 X164.773 Y60.725
G1 X164.639 Y60.858
G1 X162.908 Y62.59 E.07446
G1 X162.774 Y62.723
G1 X162.241 Y62.723
G1 X162.375 Y62.59
G1 X164.639 Y60.325 E.0974
G1 X164.773 Y60.191
G1 X164.773 Y59.658
G1 X164.639 Y59.792
G1 X161.841 Y62.59 E.12034
G1 X161.708 Y62.723
G1 X161.174 Y62.723
G1 X161.308 Y62.59
G1 X164.348 Y59.549 E.13076
G1 X164.482 Y59.416
G1 X163.949 Y59.416
G1 X163.815 Y59.549
G1 X160.775 Y62.59 E.13076
G1 X160.641 Y62.723
G1 X160.108 Y62.723
G1 X160.242 Y62.59
G1 X163.282 Y59.549 E.13076
G1 X163.415 Y59.416
G1 X162.882 Y59.416
G1 X162.749 Y59.549
G1 X159.708 Y62.59 E.13076
G1 X159.575 Y62.723
G1 X159.041 Y62.723
G1 X159.175 Y62.59
G1 X162.215 Y59.549 E.13076
G1 X162.349 Y59.416
M73 P49 R9
G1 X161.816 Y59.416
G1 X161.682 Y59.549
G1 X158.642 Y62.59 E.13076
G1 X158.508 Y62.723
G1 X157.975 Y62.723
G1 X158.109 Y62.59
G1 X161.149 Y59.549 E.13076
G1 X161.282 Y59.416
G1 X160.749 Y59.416
G1 X160.616 Y59.549
G1 X157.575 Y62.59 E.13076
G1 X157.442 Y62.723
G1 X156.908 Y62.723
G1 X157.042 Y62.59
G1 X160.082 Y59.549 E.13076
G1 X160.216 Y59.416
G1 X159.683 Y59.416
G1 X159.549 Y59.549
G1 X156.574 Y62.525 E.12796
G1 X156.44 Y62.658
G1 X156.44 Y62.125
G1 X156.574 Y61.991
G1 X159.016 Y59.549 E.10503
G1 X159.149 Y59.416
G1 X158.873 Y59.159
G1 X158.739 Y59.293
G1 X156.574 Y61.458 E.09313
G1 X156.44 Y61.592
G1 X156.44 Y61.058
G1 X156.574 Y60.925
G1 X158.739 Y58.76 E.09313
G1 X158.873 Y58.626
G1 X158.873 Y58.093
G1 X158.739 Y58.226
G1 X156.574 Y60.391 E.09313
G1 X156.44 Y60.525
G1 X156.44 Y59.992
G1 X156.574 Y59.858
G1 X158.739 Y57.693 E.09313
G1 X158.873 Y57.559
G1 X158.873 Y57.026
G1 X158.739 Y57.16
G1 X156.574 Y59.325 E.09313
G1 X156.44 Y59.459
G1 X156.44 Y58.925
G1 X156.574 Y58.792
G1 X158.739 Y56.626 E.09313
; WIPE_START
M204 S8000
G1 X157.325 Y58.041 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X164.234 Y56.465 Z.8 F60000
G1 Z.4
G1 E.4 F1800
G1 F9547.055
M204 S2000
G1 X164.639 Y56.059 E.01744
G1 X164.773 Y55.925
G1 X164.773 Y55.392
G1 X164.639 Y55.526
G1 X163.7 Y56.465 E.04038
G1 X163.567 Y56.598
G1 X163.033 Y56.598
G1 X163.167 Y56.465
G1 X164.639 Y54.993 E.06332
G1 X164.773 Y54.859
G1 X164.773 Y54.326
G1 X164.639 Y54.459
G1 X162.634 Y56.465 E.08625
G1 X162.5 Y56.598
G1 X161.967 Y56.598
G1 X162.101 Y56.465
G1 X164.639 Y53.926 E.10919
G1 X164.773 Y53.792
G1 X164.741 Y53.291
G1 X164.608 Y53.424
G1 X161.567 Y56.465 E.13076
G1 X161.434 Y56.598
G1 X160.9 Y56.598
G1 X161.034 Y56.465
G1 X164.074 Y53.424 E.13076
G1 X164.208 Y53.291
G1 X163.675 Y53.291
G1 X163.541 Y53.424
G1 X160.501 Y56.465 E.13076
G1 X160.367 Y56.598
G1 X159.834 Y56.598
G1 X159.968 Y56.465
G1 X163.008 Y53.424 E.13076
G1 X163.141 Y53.291
G1 X162.608 Y53.291
G1 X162.475 Y53.424
G1 X159.434 Y56.465 E.13076
G1 X159.301 Y56.598
G1 X158.767 Y56.598
G1 X158.901 Y56.465
G1 X161.941 Y53.424 E.13076
G1 X162.075 Y53.291
G1 X161.542 Y53.291
G1 X161.408 Y53.424
G1 X156.574 Y58.258 E.20792
G1 X156.44 Y58.392
G1 X156.44 Y57.859
G1 X156.574 Y57.725
G1 X160.875 Y53.424 E.18498
G1 X161.008 Y53.291
G1 X160.475 Y53.291
G1 X160.341 Y53.424
G1 X156.574 Y57.192 E.16205
G1 X156.44 Y57.326
G1 X156.44 Y56.792
G1 X156.574 Y56.659
G1 X159.808 Y53.424 E.13911
G1 X159.942 Y53.291
G1 X159.409 Y53.291
G1 X159.275 Y53.424
G1 X156.574 Y56.125 E.11618
G1 X156.44 Y56.259
G1 X156.44 Y55.726
G1 X156.574 Y55.592
G1 X158.742 Y53.424 E.09324
G1 X158.875 Y53.291
G1 X158.342 Y53.291
G1 X158.208 Y53.424
G1 X156.574 Y55.059 E.0703
G1 X156.44 Y55.193
G1 X156.44 Y54.659
G1 X156.574 Y54.526
G1 X157.675 Y53.424 E.04737
G1 X157.809 Y53.291
G1 X157.276 Y53.291
G1 X157.142 Y53.424
G1 X156.574 Y53.992 E.02443
; WIPE_START
M204 S8000
G1 X157.142 Y53.424 E-.15263
G1 X157.276 Y53.291 E-.03591
G1 X157.809 Y53.291 E-.10132
G1 X157.675 Y53.424 E-.03591
G1 X157.473 Y53.626 E-.05424
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X164.841 Y55.617 Z.8 F60000
G1 X188.539 Y62.021 Z.8
G1 Z.4
G1 E.4 F1800
G1 F9547.055
M204 S2000
G1 X187.971 Y62.59 E.02444
G1 X187.837 Y62.723
G1 X187.304 Y62.723
G1 X187.438 Y62.59
G1 X188.539 Y61.488 E.04737
G1 X188.673 Y61.355
G1 X188.673 Y60.821
G1 X188.539 Y60.955
G1 X186.904 Y62.59 E.07031
G1 X186.771 Y62.723
G1 X186.238 Y62.723
G1 X186.371 Y62.59
G1 X188.539 Y60.422 E.09325
G1 X188.673 Y60.288
G1 X188.673 Y59.755
G1 X188.539 Y59.888
G1 X185.838 Y62.59 E.11618
G1 X185.704 Y62.723
G1 X185.171 Y62.723
G1 X185.305 Y62.59
G1 X188.539 Y59.355 E.13912
G1 X188.673 Y59.222
G1 X188.673 Y58.688
G1 X188.539 Y58.822
G1 X184.771 Y62.59 E.16205
G1 X184.638 Y62.723
G1 X184.105 Y62.723
G1 X184.238 Y62.59
G1 X188.539 Y58.289 E.18499
G1 X188.673 Y58.155
G1 X188.673 Y57.622
G1 X188.539 Y57.755
G1 X183.705 Y62.59 E.20793
G1 X183.571 Y62.723
G1 X183.038 Y62.723
G1 X183.172 Y62.59
G1 X186.212 Y59.549 E.13076
G1 X186.346 Y59.416
G1 X185.812 Y59.416
G1 X185.679 Y59.549
G1 X182.638 Y62.59 E.13076
G1 X182.505 Y62.723
G1 X181.972 Y62.723
G1 X182.105 Y62.59
G1 X185.145 Y59.549 E.13076
G1 X185.279 Y59.416
G1 X184.746 Y59.416
G1 X184.612 Y59.549
G1 X181.572 Y62.59 E.13076
G1 X181.438 Y62.723
G1 X180.905 Y62.723
G1 X181.039 Y62.59
G1 X184.079 Y59.549 E.13076
G1 X184.213 Y59.416
G1 X183.679 Y59.416
G1 X183.546 Y59.549
G1 X180.505 Y62.59 E.13076
G1 X180.372 Y62.723
G1 X180.34 Y62.221
G1 X180.474 Y62.088
G1 X183.012 Y59.549 E.10918
G1 X183.146 Y59.416
G1 X182.613 Y59.416
G1 X182.479 Y59.549
G1 X180.474 Y61.555 E.08625
G1 X180.34 Y61.688
G1 X180.34 Y61.155
G1 X180.474 Y61.021
G1 X181.946 Y59.549 E.06331
G1 X182.079 Y59.416
G1 X181.546 Y59.416
G1 X181.413 Y59.549
G1 X180.474 Y60.488 E.04037
G1 X180.34 Y60.622
G1 X180.34 Y60.088
G1 X180.474 Y59.955
G1 X180.879 Y59.549 E.01744
; WIPE_START
M204 S8000
G1 X180.474 Y59.955 E-.10893
G1 X180.34 Y60.088 E-.03591
G1 X180.34 Y60.622 E-.10132
G1 X180.474 Y60.488 E-.03591
G1 X180.838 Y60.124 E-.09793
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X186.374 Y59.387 Z.8 F60000
G1 Z.4
G1 E.4 F1800
G1 F9547.055
M204 S2000
G1 X188.539 Y57.222 E.09313
G1 X188.673 Y57.089
G1 X188.673 Y56.555
G1 X188.539 Y56.689
G1 X186.374 Y58.854 E.09313
G1 X186.24 Y58.988
G1 X186.24 Y58.455
G1 X186.374 Y58.321
G1 X188.539 Y56.156 E.09313
G1 X188.673 Y56.022
G1 X188.673 Y55.489
G1 X188.539 Y55.622
G1 X186.374 Y57.788 E.09313
G1 X186.24 Y57.921
G1 X186.24 Y57.388
G1 X186.374 Y57.254
G1 X188.539 Y55.089 E.09313
G1 X188.673 Y54.955
G1 X188.673 Y54.422
G1 X188.539 Y54.556
G1 X186.374 Y56.721 E.09313
G1 X186.24 Y56.855
G1 X185.964 Y56.598
G1 X186.097 Y56.465
G1 X188.539 Y54.023 E.10503
G1 X188.673 Y53.889
G1 X188.673 Y53.356
G1 X188.539 Y53.489
G1 X185.564 Y56.465 E.12797
G1 X185.43 Y56.598
G1 X184.897 Y56.598
G1 X185.031 Y56.465
G1 X188.071 Y53.424 E.13076
G1 X188.205 Y53.291
G1 X187.671 Y53.291
G1 X187.538 Y53.424
G1 X184.497 Y56.465 E.13076
G1 X184.364 Y56.598
G1 X183.83 Y56.598
G1 X183.964 Y56.465
G1 X187.004 Y53.424 E.13076
G1 X187.138 Y53.291
G1 X186.605 Y53.291
G1 X186.471 Y53.424
G1 X183.431 Y56.465 E.13076
G1 X183.297 Y56.598
G1 X182.764 Y56.598
G1 X182.898 Y56.465
G1 X185.938 Y53.424 E.13076
G1 X186.071 Y53.291
G1 X185.538 Y53.291
G1 X185.405 Y53.424
G1 X182.364 Y56.465 E.13076
G1 X182.231 Y56.598
G1 X181.697 Y56.598
G1 X181.831 Y56.465
G1 X184.871 Y53.424 E.13076
G1 X185.005 Y53.291
G1 X184.472 Y53.291
G1 X184.338 Y53.424
G1 X181.298 Y56.465 E.13076
G1 X181.164 Y56.598
G1 X180.631 Y56.598
G1 X180.765 Y56.465
G1 X183.805 Y53.424 E.13076
G1 X183.938 Y53.291
G1 X183.405 Y53.291
G1 X183.272 Y53.424
G1 X180.474 Y56.222 E.12033
G1 X180.34 Y56.356
G1 X180.34 Y55.822
G1 X180.474 Y55.689
G1 X182.738 Y53.424 E.09739
G1 X182.872 Y53.291
G1 X182.339 Y53.291
G1 X182.205 Y53.424
G1 X180.474 Y55.155 E.07446
G1 X180.34 Y55.289
G1 X180.34 Y54.756
G1 X180.474 Y54.622
G1 X181.672 Y53.424 E.05152
G1 X181.805 Y53.291
G1 X181.272 Y53.291
G1 X181.139 Y53.424
G1 X180.474 Y54.089 E.02859
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #3
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
; WIPE_START
M204 S8000
G1 X181.139 Y53.424 E-.17858
G1 X181.272 Y53.291 E-.03591
G1 X181.805 Y53.291 E-.10132
G1 X181.672 Y53.424 E-.03591
G1 X181.567 Y53.53 E-.02829
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.217 J0 P1  F60000
; stop printing object, unique label id: 1563
M625
G1 X167.774 Y261.05
G1 Z.4
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF3 NF2 ON2 NN3
M632 S2 M N
M400
M104 T0 S190 N0
M106 S255
M633
M204 S8000
G1  X198.274 Y261.050  E2.4272 F1411
G1  Y262.550  E0.1194
G1  X167.774  E2.4272
M632 S2 M N
M204 S10000
G1  Y263.300 
G1  X197.774  F177
G1  Y261.800 
G1  X168.274 
M633
; NOZZLE_CHANGE_END OF3 NF2 ON2 NN3

G1 E-2 F1800
G17
M73 P50 R9
G3 Z.8 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O4
M620 S2A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z3.4 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X210.524 Y279.55



M620.10 A0 F239.471 L0 H0.4 T240 P230 S1



M620.10 A1 F419.075 L0 H0.4 T240 P230 S1



M620.11 P1 I3 B-1 E-14 F299.339



M620.15 P180
M620.15 C230
M620.11 O1 T14


M620.11 K1 I3 B-1 R10 F299.339


M620.15 C230

M628 S1


M620.11 S1 L0 I3 B-1 R10 D8 E-14 F299.339


M629


;M620.11 H0




T2 H-1
M73 E5

;deretract


M73 P51 R8
;VG1 E4 F523
;VG1 E4 F261



; VFLUSH_START


;VG1 E0 F299


SYNC T0

; compensate for heating and cooling


; VFLUSH_END

M1002 set_filament_type:PLA

M400
M83



M620.10 R2


M628 S0

;VM109 S230

M629
M400

;prime_tower_interface

G150.1
M620.13 W0 L20 T240 R0.0

;prime_tower_interface

M983.3 F8.75 A0.4 R2


M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
M73 P54 R8
G1 Z3.4 F3000

M204 S25


M621 S2A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F8.75 A0.4 R2
M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.4

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I2 H-1 W1 ;enable ams air printing detect
M620 O4
M1002 gcode_claim_action : 0
M106 S255
M106 P2 S191

; filament start gcode
G1 X208.524 Y279.55 F60000
G1 Z.4
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT1 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X167.524 Y279.550  E1.5583 F396
G1  Y279.050  E0.0190
G1  X198.524  E1.1782 F450
G1  Y278.550  E0.0190
M73 P55 R8
G1  X167.524  E1.1782 F550
G1  Y278.050  E0.0190
G1  X198.524  E1.1782 F1050
G1  Y277.550  E0.0190
M73 P56 R8
G1  X167.524  E1.1782 F1100
G1  Y277.050  E0.0190
G1  X198.524  E1.1782
G1  Y276.550  E0.0190
G1  X167.524  E1.1782
G1  Y276.050  E0.0190
M73 P56 R7
G1  X198.524  E1.1782
G1  Y275.550  E0.0190
G1  X167.524  E1.1782
G1  Y275.050  E0.0190
G1  X198.524  E1.1782
G1  Y274.550  E0.0190
M73 P57 R7
G1  X167.524  E1.1782
G1  Y274.050  E0.0190
G1  X198.524  E1.1782
G1  Y273.550  E0.0190
G1  X167.524  E1.1782
G1  Y273.050  E0.0190
G1  X198.524  E1.1782
G1  Y272.550  E0.0190
G1  X167.524  E1.1782
G1  Y272.050  E0.0190
G1  X198.524  E1.1782
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


M73 P58 R7
G1  Y282.800   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
;--------------------
; CP EMPTY GRID START
; layer #3
M204 S8000
G1  X167.524  E1.1782 F1200
G1  Y282.300  E0.0190
G1  X198.524  E1.1782
G1  Y281.800  E0.0190
G1  X167.524  E1.1782
G1  Y281.300  E0.0190
G1  X198.524  E1.1782
G1  Y280.800  E0.0190
G1  X167.524  E1.1782
G1  Y280.300  E0.0190
G1  X198.524  E1.1782
M400
M104 T0 S230 N0
; CP EMPTY GRID END
;------------------






; WIPE_TOWER_END

; WIPE_START
G1 F9547.055
M204 S8000
G1 X197.524 Y280.3 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
M73 P59 R7
G3 Z.8 I1.217 J0 P1  F60000
; OBJECT_ID: 1747
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
M204 S10000
G1 X179.905 Y41.247
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F15476.087
M204 S8000
G1 X179.905 Y45.645 E.14887
G1 X176.609 Y45.645 E.11156
G1 X176.609 Y36.849 E.29773
G1 X179.905 Y36.849 E.11156
G1 X179.905 Y41.187 E.14683
M204 S250
G1 X180.297 Y41.247 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X180.297 Y46.037 E.15019
G1 X176.217 Y46.037 E.12793
G1 X176.217 Y36.457 E.30037
G1 X180.297 Y36.457 E.12793
G1 X180.297 Y41.187 E.14831
; WIPE_START
M204 S8000
G1 X180.297 Y42.187 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I.105 J-1.212 P1  F60000
G1 X169.405 Y41.247 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F15476.087
M204 S8000
G1 X169.405 Y45.645 E.14887
G1 X166.109 Y45.645 E.11156
G1 X166.109 Y36.849 E.29773
G1 X169.405 Y36.849 E.11156
G1 X169.405 Y41.187 E.14683
M204 S250
G1 X169.797 Y41.247 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X169.797 Y46.037 E.15019
G1 X165.717 Y46.037 E.12793
G1 X165.717 Y36.457 E.30037
G1 X169.797 Y36.457 E.12793
G1 X169.797 Y41.187 E.14831
; WIPE_START
M204 S8000
G1 X169.797 Y42.187 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.19 J-.253 P1  F60000
G1 X169.013 Y38.497 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X169.013 Y37.241 E.03938
G1 X166.501 Y37.241 E.07875
G1 X166.501 Y45.253 E.2512
G1 X169.013 Y45.253 E.07875
G1 X169.013 Y38.557 E.20994
M204 S10000
G1 X168.636 Y38.497 F60000
G1 F15000
M204 S8000
G1 X168.636 Y37.618 E.02755
G1 X166.878 Y37.618 E.05511
G1 X166.878 Y44.876 E.22755
G1 X168.636 Y44.876 E.05511
G1 X168.636 Y38.557 E.19812
M204 S10000
G1 X168.259 Y38.497 F60000
G1 F15000
M204 S8000
G1 X168.259 Y37.995 E.01573
G1 X167.255 Y37.995 E.03146
G1 X167.255 Y44.499 E.20391
G1 X168.259 Y44.499 E.03146
G1 X168.259 Y38.557 E.18629
M204 S10000
G1 X167.914 Y38.497 F60000
; LINE_WIDTH: 0.35612
G1 F15000
M204 S8000
G1 X167.914 Y38.34 E.00408
G1 X167.6 Y38.34 E.00816
G1 X167.6 Y44.154 E.15139
G1 X167.914 Y44.154 E.00816
G1 X167.914 Y38.557 E.14575
; WIPE_START
G1 X167.914 Y39.557 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-.501 J1.109 P1  F60000
G1 X178.1 Y44.154 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.35611
G1 F15000
M204 S8000
G1 X178.414 Y44.154 E.00816
G1 X178.414 Y38.34 E.15139
G1 X178.1 Y38.34 E.00816
G1 X178.1 Y44.094 E.14982
M204 S10000
G1 X177.755 Y44.499 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X178.759 Y44.499 E.03146
G1 X178.759 Y37.995 E.20391
G1 X177.755 Y37.995 E.03146
G1 X177.755 Y44.439 E.20203
M204 S10000
G1 X177.378 Y44.876 F60000
G1 F15000
M204 S8000
G1 X179.136 Y44.876 E.05511
G1 X179.136 Y37.618 E.22755
G1 X177.378 Y37.618 E.05511
G1 X177.378 Y44.816 E.22567
M204 S10000
G1 X177.001 Y45.253 F60000
G1 F15000
M204 S8000
G1 X179.513 Y45.253 E.07875
G1 X179.513 Y37.241 E.2512
G1 X177.001 Y37.241 E.07875
G1 X177.001 Y45.193 E.24931
; OBJECT_ID: 1563
; WIPE_START
G1 X177.001 Y44.193 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z.8 I-1.198 J.213 P1  F60000
G1 X179.454 Y58.007 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F15476.087
M204 S8000
G1 X179.454 Y62.405 E.14887
G1 X176.159 Y62.405 E.11156
G1 X176.159 Y53.609 E.29773
G1 X179.454 Y53.609 E.11156
G1 X179.454 Y57.947 E.14683
M204 S250
G1 X179.847 Y58.007 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X179.847 Y62.797 E.15019
G1 X175.767 Y62.797 E.12793
G1 X175.767 Y53.217 E.30037
G1 X179.847 Y53.217 E.12793
G1 X179.847 Y57.947 E.14831
; WIPE_START
M204 S8000
G1 X179.847 Y58.947 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I.105 J-1.212 P1  F60000
G1 X168.954 Y58.007 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F15476.087
M204 S8000
G1 X168.954 Y62.405 E.14887
G1 X165.659 Y62.405 E.11156
G1 X165.659 Y53.609 E.29773
G1 X168.954 Y53.609 E.11156
G1 X168.954 Y57.947 E.14683
M204 S250
G1 X169.347 Y58.007 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X169.347 Y62.797 E.15019
G1 X165.267 Y62.797 E.12793
G1 X165.267 Y53.217 E.30037
G1 X169.347 Y53.217 E.12793
G1 X169.347 Y57.947 E.14831
; WIPE_START
M204 S8000
G1 X169.347 Y58.947 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.19 J-.253 P1  F60000
G1 X168.562 Y55.257 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X168.562 Y54.001 E.03938
G1 X166.051 Y54.001 E.07875
G1 X166.051 Y62.013 E.2512
G1 X168.562 Y62.013 E.07875
G1 X168.562 Y55.317 E.20994
M204 S10000
G1 X168.185 Y55.257 F60000
G1 F15000
M204 S8000
G1 X168.185 Y54.378 E.02755
G1 X166.428 Y54.378 E.05511
G1 X166.428 Y61.636 E.22755
G1 X168.185 Y61.636 E.05511
G1 X168.185 Y55.317 E.19812
M204 S10000
G1 X167.808 Y55.257 F60000
G1 F15000
M204 S8000
G1 X167.808 Y54.755 E.01573
G1 X166.805 Y54.755 E.03146
G1 X166.805 Y61.259 E.20391
G1 X167.808 Y61.259 E.03146
G1 X167.808 Y55.317 E.18629
M204 S10000
G1 X167.463 Y55.257 F60000
; LINE_WIDTH: 0.35612
G1 F15000
M204 S8000
G1 X167.463 Y55.1 E.00408
G1 X167.15 Y55.1 E.00816
G1 X167.15 Y60.914 E.15139
G1 X167.463 Y60.914 E.00816
G1 X167.463 Y55.317 E.14575
; WIPE_START
G1 X167.463 Y56.317 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-.501 J1.109 P1  F60000
G1 X177.65 Y60.914 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.35611
G1 F15000
M204 S8000
G1 X177.963 Y60.914 E.00816
G1 X177.963 Y55.1 E.15139
G1 X177.65 Y55.1 E.00816
G1 X177.65 Y60.854 E.14982
M204 S10000
G1 X177.305 Y61.259 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X178.308 Y61.259 E.03146
G1 X178.308 Y54.755 E.20391
G1 X177.305 Y54.755 E.03146
G1 X177.305 Y61.199 E.20203
M204 S10000
G1 X176.928 Y61.636 F60000
G1 F15000
M204 S8000
G1 X178.685 Y61.636 E.05511
G1 X178.685 Y54.378 E.22755
G1 X176.928 Y54.378 E.05511
G1 X176.928 Y61.576 E.22567
M204 S10000
G1 X176.551 Y62.013 F60000
G1 F15000
M204 S8000
G1 X179.062 Y62.013 E.07875
G1 X179.062 Y54.001 E.2512
G1 X176.551 Y54.001 E.07875
G1 X176.551 Y61.953 E.24931
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X176.551 Y60.953 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1563
M625
; layer num/total_layer_count: 3/10
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
; OBJECT_ID: 1747
; COOLING_NODE: 0
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z.8 I1.129 J-.455 P1  F60000
G1 X168.609 Y41.247 Z.8
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F15476.087
M204 S8000
G1 X168.609 Y36.849 E.14887
G1 X177.405 Y36.849 E.29773
G1 X177.405 Y45.645 E.29773
G1 X168.609 Y45.645 E.29773
G1 X168.609 Y41.307 E.14683
; COOLING_NODE: 0
M204 S250
G1 X168.217 Y41.247 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6762
M204 S5000
G1 X168.217 Y36.457 E.15019
G1 X177.797 Y36.457 E.30037
G1 X177.797 Y46.037 E.30037
G1 X168.217 Y46.037 E.30037
G1 X168.217 Y41.307 E.14831
; WIPE_START
G1 F12000
M204 S8000
G1 X168.217 Y40.307 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I-1.207 J.153 P1  F60000
G1 X168.773 Y44.696 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.43098
G1 F15000
M204 S8000
G1 X169.389 Y45.312 E.0281
G1 X169.937 Y45.312 E.01771
G1 X168.942 Y44.317 E.0454
G1 X168.942 Y43.768 E.01771
G1 X170.486 Y45.312 E.07044
G1 X171.035 Y45.312 E.01771
G1 X168.942 Y43.219 E.09549
G1 X168.942 Y42.67 E.01771
G1 X171.584 Y45.312 E.12053
G1 X172.133 Y45.312 E.01771
G1 X168.942 Y42.122 E.14557
G1 X168.942 Y41.573 E.01771
G1 X172.681 Y45.312 E.17062
G1 X173.23 Y45.312 E.01771
G1 X168.942 Y41.024 E.19566
G1 X168.942 Y40.475 E.01771
G1 X173.779 Y45.312 E.2207
G1 X174.328 Y45.312 E.01771
G1 X168.942 Y39.926 E.24575
G1 X168.942 Y39.378 E.01771
G1 X174.877 Y45.312 E.27079
G1 X175.425 Y45.312 E.01771
G1 X168.942 Y38.829 E.29583
G1 X168.942 Y38.28 E.01771
G1 X175.974 Y45.312 E.32088
G1 X176.523 Y45.312 E.01771
G1 X168.942 Y37.731 E.34592
G1 X168.942 Y37.182 E.01771
G1 X177.072 Y45.312 E.37096
G1 X177.072 Y44.763 E.01771
G1 X169.491 Y37.182 E.34593
G1 X170.04 Y37.182 E.01771
G1 X177.072 Y44.214 E.32088
G1 X177.072 Y43.665 E.01771
G1 X170.589 Y37.182 E.29584
G1 X171.138 Y37.182 E.01771
G1 X177.072 Y43.117 E.2708
G1 X177.072 Y42.568 E.01771
G1 X171.686 Y37.182 E.24575
G1 X172.235 Y37.182 E.01771
G1 X177.072 Y42.019 E.22071
G1 X177.072 Y41.47 E.01771
G1 X172.784 Y37.182 E.19567
G1 X173.333 Y37.182 E.01771
G1 X177.072 Y40.921 E.17062
G1 X177.072 Y40.373 E.01771
G1 X173.882 Y37.182 E.14558
G1 X174.43 Y37.182 E.01771
G1 X177.072 Y39.824 E.12054
G1 X177.072 Y39.275 E.01771
G1 X174.979 Y37.182 E.09549
G1 X175.528 Y37.182 E.01771
G1 X177.072 Y38.726 E.07045
G1 X177.072 Y38.177 E.01771
G1 X176.077 Y37.182 E.04541
G1 X176.626 Y37.182 E.01771
G1 X177.241 Y37.798 E.0281
; OBJECT_ID: 1563
; COOLING_NODE: 0
; WIPE_START
G1 X176.626 Y37.182 E-.33098
G1 X176.497 Y37.182 E-.04902
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z1 I-1.13 J-.452 P1  F60000
G1 X168.159 Y58.007 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F15476.087
M204 S8000
G1 X168.159 Y53.609 E.14887
G1 X176.954 Y53.609 E.29773
G1 X176.954 Y62.405 E.29773
G1 X168.159 Y62.405 E.29773
M73 P60 R7
G1 X168.159 Y58.067 E.14683
; COOLING_NODE: 0
M204 S250
G1 X167.767 Y58.007 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6762
M204 S5000
G1 X167.767 Y53.217 E.15019
G1 X177.347 Y53.217 E.30037
G1 X177.347 Y62.797 E.30037
G1 X167.767 Y62.797 E.30037
G1 X167.767 Y58.067 E.14831
; WIPE_START
G1 F12000
M204 S8000
G1 X167.767 Y57.067 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I-1.207 J.153 P1  F60000
G1 X168.322 Y61.456 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.43098
G1 F15000
M204 S8000
G1 X168.938 Y62.072 E.0281
G1 X169.487 Y62.072 E.01771
G1 X168.492 Y61.077 E.0454
G1 X168.492 Y60.528 E.01771
G1 X170.036 Y62.072 E.07044
G1 X170.584 Y62.072 E.01771
G1 X168.492 Y59.979 E.09549
G1 X168.492 Y59.43 E.01771
G1 X171.133 Y62.072 E.12053
G1 X171.682 Y62.072 E.01771
G1 X168.492 Y58.882 E.14557
G1 X168.492 Y58.333 E.01771
G1 X172.231 Y62.072 E.17062
G1 X172.78 Y62.072 E.01771
G1 X168.492 Y57.784 E.19566
G1 X168.492 Y57.235 E.01771
G1 X173.328 Y62.072 E.2207
G1 X173.877 Y62.072 E.01771
G1 X168.492 Y56.686 E.24575
G1 X168.492 Y56.138 E.01771
G1 X174.426 Y62.072 E.27079
G1 X174.975 Y62.072 E.01771
G1 X168.492 Y55.589 E.29583
G1 X168.492 Y55.04 E.01771
G1 X175.524 Y62.072 E.32088
G1 X176.072 Y62.072 E.01771
G1 X168.492 Y54.491 E.34592
G1 X168.492 Y53.942 E.01771
G1 X176.621 Y62.072 E.37096
G1 X176.621 Y61.523 E.01771
G1 X169.041 Y53.942 E.34593
G1 X169.589 Y53.942 E.01771
G1 X176.621 Y60.974 E.32088
G1 X176.621 Y60.425 E.01771
G1 X170.138 Y53.942 E.29584
G1 X170.687 Y53.942 E.01771
G1 X176.621 Y59.877 E.2708
G1 X176.621 Y59.328 E.01771
G1 X171.236 Y53.942 E.24575
G1 X171.785 Y53.942 E.01771
G1 X176.621 Y58.779 E.22071
G1 X176.621 Y58.23 E.01771
G1 X172.333 Y53.942 E.19567
G1 X172.882 Y53.942 E.01771
G1 X176.621 Y57.681 E.17062
G1 X176.621 Y57.133 E.01771
G1 X173.431 Y53.942 E.14558
G1 X173.98 Y53.942 E.01771
G1 X176.621 Y56.584 E.12054
G1 X176.621 Y56.035 E.01771
G1 X174.529 Y53.942 E.09549
G1 X175.077 Y53.942 E.01771
G1 X176.621 Y55.486 E.07045
G1 X176.621 Y54.937 E.01771
G1 X175.626 Y53.942 E.04541
G1 X176.175 Y53.942 E.01771
G1 X176.791 Y54.558 E.0281
; WIPE_START
G1 X176.175 Y53.942 E-.33098
G1 X176.046 Y53.942 E-.04902
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I1.217 J0 P1  F60000
; stop printing object, unique label id: 1563
M625
; object ids of layer 3 start: 1563,1747
M624 AwAAAAAAAAA=
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U173 V131 Z1 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; object ids of this layer3 end: 1563,1747
M625
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #4
; material : TPU-AMS -> TPU-AMS
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
M204 S10000
G1 X167.774 Y272.3
G1 Z.6
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF2 NF3 ON3 NN2
M632 S3 M N
M400
M104 T0 S180 N0
M106 S255
M633
M204 S8000
G1  X198.274 Y272.300  E2.4272 F6583
G1  Y273.800  E0.1194
G1  X167.774  E2.4272
M632 S3 M N
M204 S10000
G1  Y274.550 
G1  X197.774  F3540
G1  Y273.050 
G1  X168.274 
M633
; NOZZLE_CHANGE_END OF2 NF3 ON3 NN2

G1 E-2 F1800
G17
G3 Z1 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S0 ; disable E air printing detect


M620 O5
M620 S3A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z3.6 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X200.524 Y252.55



M620.10 A0 F419.075 L0 H0.4 T240 P230 S1



M620.10 A1 F239.471 L0 H0.4 T240 P230 S1



M620.11 P1 I2 B-1 E-14 F523.843



M620.15 P190
M620.15 C220
M620.11 O1 T18


M620.11 K1 I2 B-1 R10 F523.843


M620.15 C220

M628 S1


M620.11 S1 L0 I2 B-1 R10 D8 E-14 F523.843


M629


;M620.11 H0




T3 H-1
M73 E4

;deretract


;VG1 E4 F299
;VG1 E4 F149



; VFLUSH_START


;VG1 E0 F299


SYNC T0

; compensate for heating and cooling


; VFLUSH_END

M1002 set_filament_type:TPU-AMS

M400
M83



M620.10 R2


M628 S0

;VM109 S230

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F5 A0.4 R2


M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
M73 P63 R6
G1 Z3.6 F3000

M204 S25


M621 S3A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F5 A0.4 R2
M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.6

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S0 ; disable E air printing detect


M620.6 I3 H-1 W1 ;enable ams air printing detect
M620 O5
M1002 gcode_claim_action : 0
M106 S51
M106 P2 S255

; filament start gcode
G1 X198.524 Y252.55 F60000
G1 Z.6
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X195.524 Y252.550  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X200.024  F600
G1  X198.524  F240
G1  X199.024  F600
G1  Y253.050 
G1  X198.024 
G1  Y252.050 
G1  X199.524 
G1  Y253.550 
G1  X197.524 
G1  Y251.550 
G1  X195.524 Y252.550   F1782
G1 E0.4000 F1800
M400
M104 T0 S230 N0
M204 S8000
G1  X167.524  E1.0642 F1782
G1  Y253.300  E0.0285
G1  X198.524  E1.1782 F2025
G1  Y254.050  E0.0285
G1  X167.524  E1.1782 F2473
G1  Y254.800  E0.0285
G1  X198.524  E1.1782 F4725
G1  Y255.550  E0.0285
M73 P64 R6
G1  X167.524  E1.1782 F4775
G1  Y256.300  E0.0285
G1  X198.524  E1.1782
G1  Y257.050  E0.0285
G1  X167.524  E1.1782
G1  Y257.800  E0.0285
G1  X198.524  E1.1782
G1  Y258.550  E0.0285
G1  X167.524  E1.1782
G1  Y259.300  E0.0285
G1  X198.524  E1.1782
G1  Y260.050  E0.0285
G1  X167.524  E1.1782
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  X198.524 Y282.800   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X199.024 Y283.300  
M204 S8000
G3  X196.674 Y285.295   I-4.711 J-3.168 E0.1186
G3  X193.973 Y284.084   I-0.172 J-3.233 E0.1168
G2  X191.349 Y283.300   I-2.631 J4.026 E0.1056
G2  X174.514 Y283.304   I-8.325 J435.388 E0.6399
G2  X170.716 Y285.152   I0.481 J5.815 E0.1643
G3  X168.456 Y284.766   I-0.859 J-1.780 E0.0930
G1  X167.024 Y283.300   E0.0779
G3  X165.084 Y281.023   I3.772 J-5.179 E0.1147
G3  X166.258 Y278.335   I2.979 J-0.300 E0.1165
G2  X167.024 Y275.849   I-3.669 J-2.492 E0.1004
G2  X167.020 Y259.325   I-414.299 J-8.174 E0.6281
G2  X165.150 Y255.613   I-7.052 J1.226 E0.1603
G3  X165.529 Y253.581   I1.718 J-0.731 E0.0832
G1  X167.024 Y252.050   E0.0813
G3  X169.374 Y250.055   I4.711 J3.168 E0.1186
G3  X172.075 Y251.266   I0.172 J3.233 E0.1168
G2  X174.700 Y252.050   I2.631 J-4.026 E0.1056
G1  X183.024  E0.3164
G1  X184.274  E0.0475
G2  X191.903 Y252.018   I3.537 J-65.693 E0.2901
G2  X195.472 Y250.136   I-1.997 J-8.111 E0.1549
G3  X197.592 Y250.584   I0.723 J1.820 E0.0873
G1  X198.639 Y251.656   E0.0569
G1 E-0.4000 F1800
M204 S10000
G1  X200.386 Y253.444   F600
G1 E0.4000 F1800
M204 S8000
G3  X200.000 Y256.732   I-1.401 J1.502 E0.1463 F5400
G2  X199.024 Y259.501   I3.455 J2.774 E0.1137
G1  Y273.800  E0.5435
G1 E-0.4000 F1800
M204 S10000
G1  X199.048 Y276.299   F600
G1 E0.4000 F1800
M204 S8000
G2  X200.898 Y279.737   I7.289 J-1.706 E0.1501 F5400
G3  X200.519 Y281.769   I-1.718 J0.731 E0.0832
G1  X199.024 Y283.300   E0.0813
; WIPE_TOWER_END

; WIPE_START
G1 F15000
M204 S8000
G1 X199.024 Y283.3 E-.00001
G1 X199.024 Y283.3 E-.00001
G1 X200.422 Y281.869 E-.37998
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I1.217 J0 P1  F60000
; OBJECT_ID: 1747
; COOLING_NODE: 0
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
M204 S10000
G1 X180.717 Y36.457
G1 Z.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.2
G1 F6762
M204 S5000
G1 X181.197 Y36.457 E.0146
G1 X181.197 Y39.912 E.10508
G1 X180.717 Y39.912 E.0146
G1 X180.717 Y36.517 E.10325
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.197 Y36.457 E-.09191
G1 X181.197 Y37.973 E-.28809
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X181.197 Y42.582 Z1 F60000
G1 Z.6
G1 E.4 F1800
G1 F6762
M204 S5000
G1 X181.197 Y46.037 E.10508
G1 X180.717 Y46.037 E.0146
G1 X180.717 Y42.582 E.10508
G1 X181.137 Y42.582 E.01277
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.172 Y44.582 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X173.599 Y43.628 Z1 F60000
G1 X165.297 Y42.582 Z1
G1 Z.6
G1 E.4 F1800
G1 F6762
M204 S5000
G1 X165.297 Y46.037 E.10508
G1 X164.817 Y46.037 E.0146
G1 X164.817 Y42.582 E.10508
G1 X165.237 Y42.582 E.01277
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X165.272 Y44.582 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X165.297 Y39.912 Z1 F60000
G1 Z.6
G1 E.4 F1800
G1 F6762
M204 S5000
G1 X164.817 Y39.912 E.0146
G1 X164.817 Y36.457 E.10508
G1 X165.297 Y36.457 E.0146
G1 X165.297 Y39.852 E.10325
M204 S10000
G1 X165.057 Y39.716 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F15000
M204 S8000
G1 X165.057 Y36.653 E.02173
; WIPE_START
G1 X165.057 Y38.653 E-.38
; WIPE_END
G1 E-.02 F1800
M632 S1 W
M400
M104 T1 S140 N0 ;Multi extruder pre heating
M633
M204 S10000
G1 X165.057 Y42.778 Z1 F60000
G1 Z.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X165.057 Y45.841 E.02173
; WIPE_START
G1 X165.057 Y43.841 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X172.63 Y44.794 Z1 F60000
G1 X180.957 Y45.841 Z1
G1 Z.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X180.957 Y42.778 E.02173
; WIPE_START
G1 X180.957 Y44.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X180.957 Y39.716 Z1 F60000
G1 Z.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X180.957 Y36.653 E.02173
; OBJECT_ID: 1563
; COOLING_NODE: 0
; WIPE_START
G1 X180.957 Y38.653 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S10000
G1 X180.596 Y46.277 Z1 F60000
G1 X180.267 Y53.217 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6762
M204 S5000
G1 X180.747 Y53.217 E.0146
G1 X180.747 Y56.672 E.10508
G1 X180.267 Y56.672 E.0146
G1 X180.267 Y53.277 E.10325
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.747 Y53.217 E-.09191
G1 X180.747 Y54.733 E-.28809
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X180.747 Y59.342 Z1 F60000
G1 Z.6
G1 E.4 F1800
G1 F6762
M204 S5000
G1 X180.747 Y62.797 E.10508
G1 X180.267 Y62.797 E.0146
G1 X180.267 Y59.342 E.10508
G1 X180.687 Y59.342 E.01277
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.721 Y61.342 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X173.149 Y60.388 Z1 F60000
G1 X164.847 Y59.342 Z1
G1 Z.6
G1 E.4 F1800
G1 F6762
M204 S5000
G1 X164.847 Y62.797 E.10508
G1 X164.367 Y62.797 E.0146
G1 X164.367 Y59.342 E.10508
G1 X164.787 Y59.342 E.01277
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.821 Y61.342 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X164.847 Y56.672 Z1 F60000
G1 Z.6
G1 E.4 F1800
G1 F6762
M204 S5000
G1 X164.367 Y56.672 E.0146
G1 X164.367 Y53.217 E.10508
G1 X164.847 Y53.217 E.0146
G1 X164.847 Y56.612 E.10325
M204 S10000
G1 X164.607 Y56.476 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F15000
M204 S8000
G1 X164.607 Y53.413 E.02173
; WIPE_START
G1 X164.607 Y55.413 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X164.607 Y59.538 Z1 F60000
G1 Z.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X164.607 Y62.601 E.02173
; WIPE_START
G1 X164.607 Y60.601 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X172.179 Y61.554 Z1 F60000
G1 X180.507 Y62.601 Z1
G1 Z.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X180.507 Y59.538 E.02173
; WIPE_START
G1 X180.507 Y61.538 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X180.507 Y56.476 Z1 F60000
G1 Z.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X180.507 Y53.413 E.02173
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #5
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
; WIPE_START
M204 S8000
G1 X180.507 Y55.413 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I1.217 J0 P1  F60000
; stop printing object, unique label id: 1563
M625
G1 X167.774 Y261.05
G1 Z.6
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF3 NF1 ON2 NN0
M400
M104 T0 S200 N0 ;Multi extruder pre cooling in post extrusion
M204 S8000
G1  X198.274 Y261.050  E2.4272 F415
M73 P65 R6
G1  Y262.550  E0.1194
G1  X167.774  E2.4272
M204 S10000
G1  Y263.300 
G1  X197.774  F177
G1  Y261.800 
G1  X168.274 
; NOZZLE_CHANGE_END OF3 NF1 ON2 NN0
M400
M104 T0 S25 N0 ;Multi extruder pre cooling

G1 E-2 F1800
G17
M73 P66 R6
G3 Z1 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O6
M620 S1A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z3.6 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X200.524 Y275.05



M620.10 A0 F239.471 L0 H0.4 T240 P230 S1



M620.10 A1 F498.898 L0 H0.4 T180 P150 S1



M620.11 P1 I3 B-1 E-14 F299.339



M620.15 P180
M620.15 C140
M620.11 O1 T14


M620.11 K1 I3 B-1 R10 F299.339


M620.15 C140

M628 S1


M620.11 S1 L0 I3 B-1 R10 D8 E-14 F299.339


M629


;M620.11 H0




T1 H-1
M73 E3

;deretract


M73 P67 R5
;VG1 E4 F623
;VG1 E4 F311



; VFLUSH_START


;VG1 E0 F299


SYNC T0

; compensate for heating and cooling


; VFLUSH_END

M1002 set_filament_type:PLA

M400
M83



M620.10 R0


M628 S0

;VM109 S150

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F10.4167 A0.4 R0


M400

G387 Y320 J1 F10000
M73 P69 R5
G1 X204.048 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.6 F3000

M204 S8000


M621 S1A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R0
M400

G387 Y320 J1 F10000
G1 X204.048 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.6 F3000

M204 S8000

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I1 H-1 W1 ;enable ams air printing detect
M620 O6
M1002 gcode_claim_action : 0
M106 S51
M106 P2 S102
G1 E-.4 F1800
G1 X203.048 Y275.05 F3000
M204 S1000
G1 Z.6

; filament start gcode
M109 S145;
G17
G3 Z1 I0 J-1.217 P1
G1 X198.524 Y275.05 Z1
G1 Z.6
G1 E.6 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S25
G1  X195.524 Y275.050  E0.1140 F1782
G1 E-0.4000 F1800
M204 S1000
G1  X200.024  F600
G1  X198.524  F240
G1  X199.024  F600
G1  Y275.550 
G1  X198.024 
G1  Y274.550 
G1  X199.524 
G1  Y276.050 
G1  X197.524 
G1  Y274.050 
G1  X195.524 Y275.050   F1782
G1 E0.4000 F1800
M400
M104 T1 S150 N0
M204 S25
G1  X167.524  E1.0642 F1782
G1  Y275.800  E0.0285
G1  X198.524  E1.1782 F2025
G1  Y276.550  E0.0285
M73 P70 R5
G1  X167.524  E1.1782 F2473
G1  Y277.300  E0.0285
G1  X198.524  E1.1782 F4725
G1  Y278.050  E0.0285
G1  X167.524  E1.1782 F4775
G1  Y278.800  E0.0285
G1  X198.524  E1.1782
G1  Y279.550  E0.0285
G1  X167.524  E1.1782
G1  Y280.300  E0.0285
G1  X198.524  E1.1782
G1  Y281.050  E0.0285
M73 P71 R5
G1  X167.524  E1.1782
G1  Y281.800  E0.0285
G1  X198.524  E1.1782
G1  Y282.550  E0.0285
G1  X167.524  E1.1782
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------



; WIPE_START
G1 F15000
M204 S25
G1 X168.524 Y282.55 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I1.217 J0 P1  F3000
; OBJECT_ID: 1747
; COOLING_NODE: 0
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
M204 S1000
G1 X179.905 Y40.332
G1 Z.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
M73 P72 R5
G1 X179.905 Y40.724 E.01314
G1 X185.805 Y40.724 E.19771
G1 X185.805 Y41.77 E.03505
G1 X179.905 Y41.77 E.19771
G1 X179.905 Y45.645 E.12985
G1 X178.609 Y45.645 E.04343
G1 X178.609 Y36.849 E.29475
G1 X179.905 Y36.849 E.04343
G1 X179.905 Y40.272 E.1147
; COOLING_NODE: 0
G1 X180.297 Y40.332 F3000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F600
G1 X186.197 Y40.332 E.18314
G1 X186.197 Y42.162 E.05681
G1 X180.297 Y42.162 E.18314
G1 X180.297 Y46.037 E.12028
G1 X178.217 Y46.037 E.06457
G1 X178.217 Y36.457 E.29737
G1 X180.297 Y36.457 E.06457
G1 X180.297 Y40.272 E.11842
; COOLING_NODE: 0
; WIPE_START
G1 X181.297 Y40.282 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I-.035 J-1.216 P1  F3000
G1 X166.109 Y40.724 Z1
G1 Z.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X166.109 Y36.849 E.12985
G1 X167.405 Y36.849 E.04343
G1 X167.405 Y45.645 E.29475
G1 X166.109 Y45.645 E.04343
G1 X166.109 Y41.77 E.12985
G1 X160.209 Y41.77 E.19771
M73 P72 R4
G1 X160.209 Y40.724 E.03505
G1 X166.049 Y40.724 E.1957
; COOLING_NODE: 0
G1 X165.717 Y40.332 F3000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P73 R4
G1 F600
G1 X165.717 Y36.457 E.12028
G1 X167.797 Y36.457 E.06457
G1 X167.797 Y46.037 E.29737
G1 X165.717 Y46.037 E.06457
G1 X165.717 Y42.162 E.12028
G1 X159.817 Y42.162 E.18314
G1 X159.817 Y40.332 E.05681
G1 X165.657 Y40.332 E.18128
M204 S1000
G1 X166.313 Y41.247 F3000
; FEATURE: Gap infill
; LINE_WIDTH: 0.68174
G1 F600
M204 S25
G1 X160.413 Y41.247 E.31026
M204 S1000
G1 X167.03 Y40.703 F3000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.402564
G1 F600
M204 S25
G1 X167.013 Y40.578 E.00372
; LINE_WIDTH: 0.43647
G1 X166.996 Y40.454 E.00407
; LINE_WIDTH: 0.487024
G1 X166.979 Y40.329 E.00459
G1 X166.979 Y37.275 E.11166
G1 X166.535 Y37.275 E.01625
G1 X166.535 Y40.486 E.11739
G1 X166.637 Y40.516 E.00388
; LINE_WIDTH: 0.470377
G1 X166.654 Y40.578 E.00227
; LINE_WIDTH: 0.43647
G1 X166.67 Y40.64 E.00209
; LINE_WIDTH: 0.386558
G1 X166.687 Y40.703 E.00182
G1 X166.687 Y41.792 E.03081
; LINE_WIDTH: 0.402564
G1 X166.67 Y41.854 E.00191
; LINE_WIDTH: 0.43647
G1 X166.654 Y41.916 E.00209
; LINE_WIDTH: 0.487171
G1 X166.637 Y41.978 E.00236
G1 X166.535 Y42.008 E.00388
G1 X166.535 Y45.219 E.11743
G1 X166.979 Y45.219 E.01625
G1 X166.979 Y42.165 E.1117
; LINE_WIDTH: 0.470377
G1 X166.996 Y42.04 E.00442
; LINE_WIDTH: 0.43647
G1 X167.013 Y41.916 E.00407
; LINE_WIDTH: 0.387455
G1 X167.03 Y41.792 E.00356
G1 X167.03 Y40.763 E.02918
; WIPE_START
G1 X167.03 Y41.763 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I-.003 J1.217 P1  F3000
G1 X178.984 Y41.792 Z1
G1 Z.6
G1 E.6 F1800
; LINE_WIDTH: 0.402562
G1 F600
M204 S25
G1 X179.001 Y41.916 E.00372
; LINE_WIDTH: 0.436465
G1 X179.018 Y42.04 E.00407
; LINE_WIDTH: 0.487014
G1 X179.035 Y42.165 E.00459
G1 X179.035 Y45.219 E.11166
G1 X179.479 Y45.219 E.01625
G1 X179.479 Y42.008 E.11739
G1 X179.378 Y41.978 E.00388
; LINE_WIDTH: 0.470369
G1 X179.361 Y41.916 E.00227
; LINE_WIDTH: 0.436465
G1 X179.344 Y41.854 E.00209
; LINE_WIDTH: 0.386558
G1 X179.327 Y41.792 E.00182
G1 X179.327 Y40.703 E.03081
; LINE_WIDTH: 0.402562
G1 X179.344 Y40.64 E.00191
; LINE_WIDTH: 0.436465
G1 X179.361 Y40.578 E.00209
; LINE_WIDTH: 0.487161
G1 X179.378 Y40.516 E.00236
G1 X179.479 Y40.486 E.00388
G1 X179.479 Y37.275 E.11743
G1 X179.035 Y37.275 E.01625
G1 X179.035 Y40.329 E.11169
; LINE_WIDTH: 0.470369
G1 X179.018 Y40.454 E.00442
; LINE_WIDTH: 0.436465
G1 X179.001 Y40.578 E.00407
; LINE_WIDTH: 0.387455
G1 X178.984 Y40.703 E.00356
G1 X178.984 Y41.732 E.02918
M204 S1000
G1 X179.702 Y41.247 F3000
; FEATURE: Gap infill
; LINE_WIDTH: 0.68174
G1 F600
M204 S25
G1 X185.601 Y41.247 E.31026
; OBJECT_ID: 1563
; COOLING_NODE: 0
; WIPE_START
G1 X184.601 Y41.247 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S1000
G17
G3 Z1 I-1.157 J-.376 P1  F3000
G1 X179.454 Y57.092 Z1
G1 Z.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
M73 P74 R4
G1 X179.454 Y57.484 E.01314
G1 X185.354 Y57.484 E.19771
G1 X185.354 Y58.53 E.03505
G1 X179.454 Y58.53 E.19771
G1 X179.454 Y62.405 E.12985
G1 X178.159 Y62.405 E.04343
G1 X178.159 Y53.609 E.29475
G1 X179.454 Y53.609 E.04343
G1 X179.454 Y57.032 E.1147
; COOLING_NODE: 0
G1 X179.847 Y57.092 F3000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F600
G1 X185.747 Y57.092 E.18314
G1 X185.747 Y58.922 E.05681
G1 X179.847 Y58.922 E.18314
G1 X179.847 Y62.797 E.12028
G1 X177.767 Y62.797 E.06457
G1 X177.767 Y53.217 E.29737
G1 X179.847 Y53.217 E.06457
G1 X179.847 Y57.032 E.11842
; COOLING_NODE: 0
; WIPE_START
G1 X180.846 Y57.042 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I-.035 J-1.216 P1  F3000
G1 X165.659 Y57.484 Z1
G1 Z.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X165.659 Y53.609 E.12985
G1 X166.954 Y53.609 E.04343
G1 X166.954 Y62.405 E.29475
G1 X165.659 Y62.405 E.04343
G1 X165.659 Y58.53 E.12985
G1 X159.759 Y58.53 E.19771
G1 X159.759 Y57.484 E.03505
G1 X165.599 Y57.484 E.1957
; COOLING_NODE: 0
G1 X165.267 Y57.092 F3000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F600
G1 X165.267 Y53.217 E.12028
G1 X167.347 Y53.217 E.06457
G1 X167.347 Y62.797 E.29737
G1 X165.267 Y62.797 E.06457
M73 P75 R4
G1 X165.267 Y58.922 E.12028
G1 X159.367 Y58.922 E.18314
G1 X159.367 Y57.092 E.05681
G1 X165.207 Y57.092 E.18128
M204 S1000
G1 X165.862 Y58.007 F3000
; FEATURE: Gap infill
; LINE_WIDTH: 0.68174
G1 F600
M204 S25
G1 X159.962 Y58.007 E.31026
M204 S1000
G1 X166.58 Y57.463 F3000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.402564
G1 F600
M204 S25
G1 X166.563 Y57.338 E.00372
; LINE_WIDTH: 0.43647
G1 X166.546 Y57.214 E.00407
; LINE_WIDTH: 0.487024
G1 X166.529 Y57.089 E.00459
G1 X166.529 Y54.035 E.11166
G1 X166.084 Y54.035 E.01625
G1 X166.084 Y57.246 E.11739
G1 X166.186 Y57.276 E.00388
; LINE_WIDTH: 0.470377
G1 X166.203 Y57.338 E.00227
; LINE_WIDTH: 0.43647
G1 X166.22 Y57.4 E.00209
; LINE_WIDTH: 0.386558
G1 X166.237 Y57.463 E.00182
G1 X166.237 Y58.552 E.03081
; LINE_WIDTH: 0.402564
G1 X166.22 Y58.614 E.00191
; LINE_WIDTH: 0.43647
G1 X166.203 Y58.676 E.00209
; LINE_WIDTH: 0.487171
G1 X166.186 Y58.738 E.00236
G1 X166.084 Y58.768 E.00388
G1 X166.084 Y61.979 E.11743
G1 X166.529 Y61.979 E.01625
G1 X166.529 Y58.925 E.1117
; LINE_WIDTH: 0.470377
G1 X166.546 Y58.8 E.00442
; LINE_WIDTH: 0.43647
G1 X166.563 Y58.676 E.00407
; LINE_WIDTH: 0.387455
G1 X166.58 Y58.552 E.00356
G1 X166.58 Y57.523 E.02918
; WIPE_START
G1 X166.58 Y58.522 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I-.003 J1.217 P1  F3000
G1 X178.533 Y58.552 Z1
G1 Z.6
G1 E.6 F1800
; LINE_WIDTH: 0.402562
G1 F600
M204 S25
G1 X178.55 Y58.676 E.00372
; LINE_WIDTH: 0.436465
G1 X178.567 Y58.8 E.00407
; LINE_WIDTH: 0.487014
G1 X178.584 Y58.925 E.00459
G1 X178.584 Y61.979 E.11166
G1 X179.029 Y61.979 E.01625
G1 X179.029 Y58.768 E.11739
G1 X178.927 Y58.738 E.00388
; LINE_WIDTH: 0.470369
G1 X178.91 Y58.676 E.00227
; LINE_WIDTH: 0.436465
G1 X178.893 Y58.614 E.00209
; LINE_WIDTH: 0.386558
G1 X178.876 Y58.552 E.00182
G1 X178.876 Y57.463 E.03081
; LINE_WIDTH: 0.402562
G1 X178.893 Y57.4 E.00191
; LINE_WIDTH: 0.436465
G1 X178.91 Y57.338 E.00209
; LINE_WIDTH: 0.487161
G1 X178.927 Y57.276 E.00236
G1 X179.029 Y57.246 E.00388
G1 X179.029 Y54.035 E.11743
G1 X178.584 Y54.035 E.01625
G1 X178.584 Y57.089 E.11169
; LINE_WIDTH: 0.470369
G1 X178.567 Y57.214 E.00442
; LINE_WIDTH: 0.436465
G1 X178.55 Y57.338 E.00407
; LINE_WIDTH: 0.387455
G1 X178.533 Y57.463 E.00356
G1 X178.533 Y58.492 E.02918
M204 S1000
G1 X179.251 Y58.007 F3000
; FEATURE: Gap infill
; LINE_WIDTH: 0.68174
G1 F600
M204 S25
G1 X185.151 Y58.007 E.31026
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; stop printing object, unique label id: 1563
M625
; layer num/total_layer_count: 4/10
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
; OBJECT_ID: 1747
; COOLING_NODE: 0
; WIPE_START
G1 F600
G1 X184.151 Y58.007 E-.38
; WIPE_END
G1 E-.02 F1800
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
M204 S1000
G17
G3 Z1 I1.183 J-.284 P1  F3000
G1 X179.905 Y40.332 Z1
G1 Z.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
G1 X179.905 Y40.724 E.01314
G1 X180.329 Y40.724 E.01422
G1 X180.329 Y41.77 E.03505
G1 X179.905 Y41.77 E.01422
G1 X179.905 Y45.645 E.12985
G1 X178.609 Y45.645 E.04343
G1 X178.609 Y36.849 E.29475
G1 X179.905 Y36.849 E.04343
G1 X179.905 Y40.272 E.1147
; COOLING_NODE: 0
G1 X180.297 Y40.332 F3000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P76 R4
G1 F600
G1 X186.197 Y40.332 E.18314
G1 X186.197 Y42.162 E.05681
G1 X180.297 Y42.162 E.18314
G1 X180.297 Y46.037 E.12028
G1 X178.217 Y46.037 E.06457
G1 X178.217 Y36.457 E.29737
G1 X180.297 Y36.457 E.06457
G1 X180.297 Y40.272 E.11842
; COOLING_NODE: 0
; WIPE_START
G1 X181.297 Y40.282 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I-.035 J-1.216 P1  F3000
G1 X166.109 Y40.724 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X166.109 Y36.849 E.12985
G1 X167.405 Y36.849 E.04343
G1 X167.405 Y45.645 E.29475
G1 X166.109 Y45.645 E.04343
G1 X166.109 Y41.77 E.12985
G1 X165.685 Y41.77 E.01422
G1 X165.685 Y40.724 E.03505
G1 X166.049 Y40.724 E.01221
; COOLING_NODE: 0
G1 X165.717 Y40.332 F3000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F600
G1 X165.717 Y36.457 E.12028
G1 X167.797 Y36.457 E.06457
G1 X167.797 Y46.037 E.29737
G1 X165.717 Y46.037 E.06457
G1 X165.717 Y42.162 E.12028
G1 X159.817 Y42.162 E.18314
G1 X159.817 Y40.332 E.05681
G1 X165.657 Y40.332 E.18128
M204 S1000
G1 X166.979 Y40.928 F3000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48733
G1 F600
M204 S25
G1 X166.979 Y37.275 E.13363
G1 X166.535 Y37.275 E.01626
G1 X166.535 Y40.928 E.13363
; LINE_WIDTH: 0.501678
G1 X166.521 Y41.007 E.00306
; LINE_WIDTH: 0.530373
M73 P77 R4
G1 X166.506 Y41.087 E.00326
; LINE_WIDTH: 0.521922
G1 X166.392 Y41.087 E.00452
; LINE_WIDTH: 0.476324
G1 X166.277 Y41.087 E.00409
; LINE_WIDTH: 0.430727
G1 X166.163 Y41.087 E.00366
; LINE_WIDTH: 0.368348
G1 X166.048 Y41.087 E.00307
G1 X166.048 Y41.407 E.00856
; LINE_WIDTH: 0.385129
G1 X166.163 Y41.407 E.00323
; LINE_WIDTH: 0.430727
G1 X166.277 Y41.407 E.00366
; LINE_WIDTH: 0.476324
G1 X166.392 Y41.407 E.00409
; LINE_WIDTH: 0.518465
G1 X166.506 Y41.407 E.00448
G1 X166.535 Y41.566 E.00635
; LINE_WIDTH: 0.48733
G1 X166.535 Y45.219 E.13363
G1 X166.979 Y45.219 E.01626
G1 X166.979 Y41.566 E.13363
; LINE_WIDTH: 0.501678
G1 X166.965 Y41.407 E.00606
; LINE_WIDTH: 0.521489
G3 X166.974 Y40.987 I1.162 J-.185 E.01661
M204 S1000
G1 X165.1 Y41.955 F3000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F600
M204 S25
G1 X165.462 Y41.593 E.01588
G1 X165.596 Y41.459
G1 X165.596 Y40.926
G1 X165.462 Y41.06
G1 X164.567 Y41.955 E.03929
G1 X164.434 Y42.088
G1 X163.9 Y42.088
G1 X164.034 Y41.955
G1 X165.449 Y40.539 E.06213
G1 X165.583 Y40.406
G1 X165.05 Y40.406
G1 X164.916 Y40.539
G1 X163.501 Y41.955 E.06213
G1 X163.367 Y42.088
G1 X162.834 Y42.088
G1 X162.967 Y41.955
G1 X164.383 Y40.539 E.06213
G1 X164.516 Y40.406
G1 X163.983 Y40.406
G1 X163.849 Y40.539
G1 X162.434 Y41.955 E.06213
G1 X162.3 Y42.088
G1 X161.767 Y42.088
G1 X161.901 Y41.955
G1 X163.316 Y40.539 E.06213
G1 X163.45 Y40.406
G1 X162.917 Y40.406
G1 X162.783 Y40.539
G1 X161.368 Y41.955 E.06213
G1 X161.234 Y42.088
G1 X160.701 Y42.088
G1 X160.834 Y41.955
G1 X162.25 Y40.539 E.06213
G1 X162.383 Y40.406
G1 X161.85 Y40.406
G1 X161.716 Y40.539
G1 X160.301 Y41.955 E.06213
G1 X160.167 Y42.088
G1 X159.891 Y41.832
G1 X160.024 Y41.698
G1 X161.183 Y40.539 E.05086
G1 X161.317 Y40.406
G1 X160.783 Y40.406
G1 X160.65 Y40.539
G1 X160.024 Y41.165 E.02745
; WIPE_START
G1 X160.65 Y40.539 E-.33607
G1 X160.732 Y40.458 E-.04393
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I-.074 J1.215 P1  F3000
G1 X179.035 Y41.566 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48732
G1 F600
M204 S25
G1 X179.035 Y45.219 E.13363
G1 X179.479 Y45.219 E.01626
G1 X179.479 Y41.566 E.13363
; LINE_WIDTH: 0.501668
G1 X179.494 Y41.487 E.00306
; LINE_WIDTH: 0.530363
G1 X179.508 Y41.407 E.00326
; LINE_WIDTH: 0.521913
G1 X179.623 Y41.407 E.00452
; LINE_WIDTH: 0.476318
G1 X179.737 Y41.407 E.00409
; LINE_WIDTH: 0.430723
G1 X179.852 Y41.407 E.00366
; LINE_WIDTH: 0.368348
G1 X179.966 Y41.407 E.00307
G1 X179.966 Y41.087 E.00856
; LINE_WIDTH: 0.385128
G1 X179.852 Y41.087 E.00323
; LINE_WIDTH: 0.430723
G1 X179.737 Y41.087 E.00366
; LINE_WIDTH: 0.476318
G1 X179.623 Y41.087 E.00409
; LINE_WIDTH: 0.518456
G1 X179.508 Y41.087 E.00448
G1 X179.479 Y40.928 E.00635
; LINE_WIDTH: 0.48732
G1 X179.479 Y37.275 E.13363
G1 X179.035 Y37.275 E.01626
G1 X179.035 Y40.928 E.13363
; LINE_WIDTH: 0.501668
G1 X179.049 Y41.087 E.00606
; LINE_WIDTH: 0.521479
G3 X179.04 Y41.507 I-1.162 J.185 E.01661
; WIPE_START
G1 X179.064 Y41.247 E-.23529
G1 X179.049 Y41.087 E-.14471
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I-.042 J1.216 P1  F3000
G1 X185.99 Y41.329 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F600
M204 S25
G1 X185.364 Y41.955 E.02746
G1 X185.231 Y42.088
G1 X184.697 Y42.088
G1 X184.831 Y41.955
G1 X185.99 Y40.796 E.05087
G1 X186.123 Y40.662
G1 X185.847 Y40.406
G1 X185.713 Y40.539
G1 X184.298 Y41.955 E.06213
G1 X184.164 Y42.088
G1 X183.631 Y42.088
G1 X183.764 Y41.955
G1 X185.18 Y40.539 E.06213
G1 X185.313 Y40.406
G1 X184.78 Y40.406
G1 X184.646 Y40.539
G1 X183.231 Y41.955 E.06213
G1 X183.098 Y42.088
G1 X182.564 Y42.088
G1 X182.698 Y41.955
G1 X184.113 Y40.539 E.06213
G1 X184.247 Y40.406
G1 X183.714 Y40.406
G1 X183.58 Y40.539
G1 X182.165 Y41.955 E.06213
G1 X182.031 Y42.088
G1 X181.498 Y42.088
G1 X181.631 Y41.955
G1 X183.047 Y40.539 E.06213
G1 X183.18 Y40.406
G1 X182.647 Y40.406
G1 X182.513 Y40.539
G1 X181.098 Y41.955 E.06213
G1 X180.965 Y42.088
G1 X180.431 Y42.088
G1 X180.565 Y41.955
G1 X181.98 Y40.539 E.06213
G1 X182.114 Y40.406
G1 X181.581 Y40.406
G1 X181.447 Y40.539
G1 X180.552 Y41.434 E.03929
G1 X180.418 Y41.568
G1 X180.418 Y41.035
G1 X180.552 Y40.901
G1 X180.914 Y40.539 E.01588
; OBJECT_ID: 1563
; COOLING_NODE: 0
; WIPE_START
G1 X180.552 Y40.901 E-.19439
G1 X180.418 Y41.035 E-.07182
G1 X180.418 Y41.334 E-.1138
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S1000
G17
G3 Z1.2 I-1.215 J-.074 P1  F3000
G1 X179.454 Y57.092 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P78 R4
G1 F600
M204 S25
G1 X179.454 Y57.484 E.01314
G1 X179.879 Y57.484 E.01422
G1 X179.879 Y58.53 E.03505
G1 X179.454 Y58.53 E.01422
G1 X179.454 Y62.405 E.12985
G1 X178.159 Y62.405 E.04343
G1 X178.159 Y53.609 E.29475
G1 X179.454 Y53.609 E.04343
G1 X179.454 Y57.032 E.1147
; COOLING_NODE: 0
G1 X179.847 Y57.092 F3000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F600
G1 X185.747 Y57.092 E.18314
G1 X185.747 Y58.922 E.05681
G1 X179.847 Y58.922 E.18314
G1 X179.847 Y62.797 E.12028
G1 X177.767 Y62.797 E.06457
M73 P78 R3
G1 X177.767 Y53.217 E.29737
G1 X179.847 Y53.217 E.06457
G1 X179.847 Y57.032 E.11842
; COOLING_NODE: 0
; WIPE_START
G1 X180.846 Y57.042 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I-.035 J-1.216 P1  F3000
G1 X165.659 Y57.484 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X165.659 Y53.609 E.12985
G1 X166.954 Y53.609 E.04343
G1 X166.954 Y62.405 E.29475
G1 X165.659 Y62.405 E.04343
G1 X165.659 Y58.53 E.12985
G1 X165.234 Y58.53 E.01422
G1 X165.234 Y57.484 E.03505
G1 X165.599 Y57.484 E.01221
; COOLING_NODE: 0
G1 X165.267 Y57.092 F3000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F600
G1 X165.267 Y53.217 E.12028
G1 X167.347 Y53.217 E.06457
G1 X167.347 Y62.797 E.29737
G1 X165.267 Y62.797 E.06457
G1 X165.267 Y58.922 E.12028
G1 X159.367 Y58.922 E.18314
G1 X159.367 Y57.092 E.05681
G1 X165.207 Y57.092 E.18128
M204 S1000
M73 P79 R3
G1 X166.529 Y57.688 F3000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48733
G1 F600
M204 S25
G1 X166.529 Y54.035 E.13363
G1 X166.084 Y54.035 E.01626
G1 X166.084 Y57.688 E.13363
; LINE_WIDTH: 0.501678
G1 X166.07 Y57.767 E.00306
; LINE_WIDTH: 0.530373
G1 X166.056 Y57.847 E.00326
; LINE_WIDTH: 0.521922
G1 X165.941 Y57.847 E.00452
; LINE_WIDTH: 0.476324
G1 X165.827 Y57.847 E.00409
; LINE_WIDTH: 0.430727
G1 X165.712 Y57.847 E.00366
; LINE_WIDTH: 0.368348
G1 X165.597 Y57.847 E.00307
G1 X165.597 Y58.167 E.00856
; LINE_WIDTH: 0.385129
G1 X165.712 Y58.167 E.00323
; LINE_WIDTH: 0.430727
G1 X165.827 Y58.167 E.00366
; LINE_WIDTH: 0.476324
G1 X165.941 Y58.167 E.00409
; LINE_WIDTH: 0.518465
G1 X166.056 Y58.167 E.00448
G1 X166.084 Y58.326 E.00635
; LINE_WIDTH: 0.48733
G1 X166.084 Y61.979 E.13363
G1 X166.529 Y61.979 E.01626
G1 X166.529 Y58.326 E.13363
; LINE_WIDTH: 0.501678
G1 X166.514 Y58.167 E.00606
; LINE_WIDTH: 0.521489
G3 X166.523 Y57.747 I1.162 J-.185 E.01661
M204 S1000
G1 X164.65 Y58.715 F3000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F600
M204 S25
G1 X165.012 Y58.353 E.01588
G1 X165.145 Y58.219
G1 X165.145 Y57.686
G1 X165.012 Y57.82
G1 X164.117 Y58.715 E.03929
G1 X163.983 Y58.848
G1 X163.45 Y58.848
G1 X163.583 Y58.715
G1 X164.999 Y57.299 E.06213
G1 X165.132 Y57.166
G1 X164.599 Y57.166
G1 X164.465 Y57.299
G1 X163.05 Y58.715 E.06213
G1 X162.916 Y58.848
G1 X162.383 Y58.848
G1 X162.517 Y58.715
M632 S3 N R W
M400
M104 T0 S220 N0 ;Multi extruder pre heating
M633
G1 X163.932 Y57.299 E.06213
G1 X164.066 Y57.166
G1 X163.532 Y57.166
G1 X163.399 Y57.299
G1 X161.984 Y58.715 E.06213
G1 X161.85 Y58.848
G1 X161.317 Y58.848
G1 X161.45 Y58.715
G1 X162.866 Y57.299 E.06213
G1 X162.999 Y57.166
G1 X162.466 Y57.166
G1 X162.332 Y57.299
G1 X160.917 Y58.715 E.06213
G1 X160.783 Y58.848
G1 X160.25 Y58.848
G1 X160.384 Y58.715
G1 X161.799 Y57.299 E.06213
G1 X161.933 Y57.166
G1 X161.399 Y57.166
G1 X161.266 Y57.299
G1 X159.851 Y58.715 E.06213
G1 X159.717 Y58.848
G1 X159.44 Y58.592
G1 X159.574 Y58.458
G1 X160.733 Y57.299 E.05086
G1 X160.866 Y57.166
G1 X160.333 Y57.166
G1 X160.199 Y57.299
G1 X159.574 Y57.925 E.02745
; WIPE_START
G1 X160.199 Y57.299 E-.33607
G1 X160.281 Y57.218 E-.04393
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I-.074 J1.215 P1  F3000
G1 X178.584 Y58.326 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48732
G1 F600
M204 S25
G1 X178.584 Y61.979 E.13363
G1 X179.029 Y61.979 E.01626
G1 X179.029 Y58.326 E.13363
; LINE_WIDTH: 0.501668
G1 X179.043 Y58.247 E.00306
; LINE_WIDTH: 0.530363
G1 X179.057 Y58.167 E.00326
; LINE_WIDTH: 0.521913
G1 X179.172 Y58.167 E.00452
; LINE_WIDTH: 0.476318
G1 X179.287 Y58.167 E.00409
; LINE_WIDTH: 0.430723
G1 X179.401 Y58.167 E.00366
; LINE_WIDTH: 0.368348
G1 X179.516 Y58.167 E.00307
G1 X179.516 Y57.847 E.00856
; LINE_WIDTH: 0.385128
G1 X179.401 Y57.847 E.00323
; LINE_WIDTH: 0.430723
G1 X179.287 Y57.847 E.00366
; LINE_WIDTH: 0.476318
G1 X179.172 Y57.847 E.00409
; LINE_WIDTH: 0.518456
G1 X179.057 Y57.847 E.00448
G1 X179.029 Y57.688 E.00635
; LINE_WIDTH: 0.48732
G1 X179.029 Y54.035 E.13363
G1 X178.584 Y54.035 E.01626
G1 X178.584 Y57.688 E.13363
; LINE_WIDTH: 0.501668
G1 X178.599 Y57.847 E.00606
; LINE_WIDTH: 0.521479
G3 X178.59 Y58.267 I-1.162 J.185 E.01661
; WIPE_START
G1 X178.613 Y58.007 E-.23529
G1 X178.599 Y57.847 E-.14471
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I-.042 J1.216 P1  F3000
G1 X185.539 Y58.089 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F600
M204 S25
G1 X184.914 Y58.715 E.02746
G1 X184.78 Y58.848
G1 X184.247 Y58.848
G1 X184.38 Y58.715
G1 X185.539 Y57.556 E.05087
G1 X185.673 Y57.422
G1 X185.396 Y57.166
G1 X185.262 Y57.299
G1 X183.847 Y58.715 E.06213
G1 X183.714 Y58.848
G1 X183.18 Y58.848
G1 X183.314 Y58.715
G1 X184.729 Y57.299 E.06213
G1 X184.863 Y57.166
G1 X184.33 Y57.166
G1 X184.196 Y57.299
G1 X182.781 Y58.715 E.06213
G1 X182.647 Y58.848
G1 X182.114 Y58.848
G1 X182.247 Y58.715
G1 X183.663 Y57.299 E.06213
G1 X183.796 Y57.166
G1 X183.263 Y57.166
G1 X183.129 Y57.299
M73 P80 R3
G1 X181.714 Y58.715 E.06213
G1 X181.58 Y58.848
G1 X181.047 Y58.848
G1 X181.181 Y58.715
G1 X182.596 Y57.299 E.06213
G1 X182.73 Y57.166
G1 X182.196 Y57.166
G1 X182.063 Y57.299
G1 X180.648 Y58.715 E.06213
G1 X180.514 Y58.848
G1 X179.981 Y58.848
G1 X180.114 Y58.715
G1 X181.53 Y57.299 E.06213
G1 X181.663 Y57.166
G1 X181.13 Y57.166
G1 X180.996 Y57.299
G1 X180.101 Y58.194 E.03929
G1 X179.968 Y58.328
G1 X179.968 Y57.795
G1 X180.101 Y57.661
G1 X180.463 Y57.299 E.01588
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #6
; material : TPU-AMS -> TPU-AMS
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
; WIPE_START
M204 S25
G1 X180.101 Y57.661 E-.19439
G1 X179.968 Y57.795 E-.07182
G1 X179.968 Y58.094 E-.1138
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I1.217 J0 P1  F3000
; stop printing object, unique label id: 1563
M625
G1 X167.774 Y272.3
G1 Z.8
G1 E.6 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF1 NF3 ON0 NN2
M204 S25
G1  X198.274 Y272.300  E2.4272 F7836
; NOZZLE_CHANGE_END OF1 NF3 ON0 NN2
M400
M104 T1 S25 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S25
G1 X197.274 Y272.3 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S1000
G17
G3 Z1.2 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S0 ; disable E air printing detect


M620 O7
M620 S3A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z3.8 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X165.524 Y260.05



M620.10 A0 F498.898 L0 H0.4 T180 P150 S1



M620.10 A1 F239.471 L0 H0.4 T240 P230 S1



M620.11 P1 I1 B-1 E-14 F623.623



M620.15 P190
M620.15 C220
M620.11 O1 T18


M620.11 K1 I1 B-1 R10 F623.623


M620.15 C220

M628 S1


M620.11 S1 L0 I1 B-1 R10 D8 E-14 F623.623


M629


;M620.11 H0




T3 H-1
M73 E2

;deretract


;VG1 E4 F299
;VG1 E4 F149



; VFLUSH_START


;VG1 E0 F299


SYNC T0

; compensate for heating and cooling


; VFLUSH_END

M1002 set_filament_type:TPU-AMS

M400
M83



M620.10 R2


M628 S0

;VM109 S230

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F5 A0.4 R2


M400

G387 Y320 J1 F10000
M73 P81 R3
G1 X204.048 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.8 F3000

M204 S25


M621 S3A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F5 A0.4 R2
M400

G387 Y320 J1 F10000
G1 X204.048 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.8 F3000

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S0 ; disable E air printing detect


M620.6 I3 H-1 W1 ;enable ams air printing detect
M620 O7
M1002 gcode_claim_action : 0
M106 S51
M106 P2 S255
G1 X203.048 Y264.879 F60000
M204 S10000
G1 Z.8
G1 X203.048 Y257.247 Z1.2
G1 X203.048 Y247.996 Z1.2
G1 X163 Y247.996
G1 X163 Y260.05

; filament start gcode
G1 X167.524 Y260.05
G1 Z.8
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X170.524 Y260.050  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X166.024  F600
G1  X167.524  F240
G1  X168.024  F600
G1  Y260.550 
G1  X167.024 
G1  Y259.550 
G1  X168.524 
G1  Y261.050 
G1  X166.524 
G1  Y259.050 
G1  X170.524 Y260.050   F1782
G1 E0.4000 F1800
M400
M104 T0 S230 N0
M204 S8000
G1  X198.524  E1.0642 F1782
G1  Y259.300  E0.0285
G1  X167.524  E1.1782 F2025
G1  Y258.550  E0.0285
G1  X198.524  E1.1782 F2473
G1  Y257.800  E0.0285
G1  X167.524  E1.1782 F4725
G1  Y257.050  E0.0285
M73 P82 R3
G1  X198.524  E1.1782 F4775
G1  Y256.300  E0.0285
G1  X167.524  E1.1782
G1  Y255.550  E0.0285
G1  X198.524  E1.1782
G1  Y254.800  E0.0285
G1  X167.524  E1.1782
G1  Y254.050  E0.0285
G1  X198.524  E1.1782
G1  Y253.300  E0.0285
G1  X167.524  E1.1782
G1  Y252.550  E0.0285
G1  X198.524  E1.1782
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  X167.524 Y282.800   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X168.456 Y284.766  
M204 S8000
G1  X165.810 Y282.057   E0.1439
G1 E-0.4000 F1800
M204 S10000
G1  X165.117 Y279.824   F600
G1 E0.4000 F1800
M204 S8000
G2  X166.898 Y276.895   I-9.396 J-7.722 E0.1307 F5400
G2  X167.024 Y275.849   I-4.838 J-1.112 E0.0401
G1  Y261.300  E0.5530
G1 E-0.4000 F1800
M204 S10000
G1  X166.968 Y258.800   F600
G1 E0.4000 F1800
M204 S8000
G2  X165.150 Y255.613   I-7.569 J2.206 E0.1407 F5400
G3  X165.529 Y253.581   I1.718 J-0.731 E0.0832
G1  X167.024 Y252.050   E0.0813
G3  X169.374 Y250.055   I4.711 J3.168 E0.1186
G3  X172.075 Y251.266   I0.172 J3.233 E0.1168
G2  X174.700 Y252.050   I2.631 J-4.026 E0.1056
G1  X183.024  E0.3164
G1  X184.274  E0.0475
G2  X191.903 Y252.018   I3.537 J-65.693 E0.2901
G2  X195.472 Y250.136   I-1.997 J-8.111 E0.1549
G3  X197.592 Y250.584   I0.723 J1.820 E0.0873
G1  X199.024 Y252.050   E0.0779
G3  X200.964 Y254.327   I-3.772 J5.179 E0.1147
G3  X199.790 Y257.015   I-2.979 J0.300 E0.1165
G2  X199.024 Y259.501   I3.669 J2.492 E0.1003
G2  X199.028 Y276.025   I414.315 J8.174 E0.6281
G2  X200.898 Y279.737   I7.052 J-1.226 E0.1603
G3  X200.519 Y281.769   I-1.718 J0.731 E0.0832
G1  X199.024 Y283.300   E0.0813
G3  X196.674 Y285.295   I-4.711 J-3.168 E0.1186
G3  X193.973 Y284.084   I-0.172 J-3.233 E0.1168
G2  X191.349 Y283.300   I-2.631 J4.026 E0.1056
G2  X174.514 Y283.304   I-8.325 J435.388 E0.6399
G2  X170.716 Y285.152   I0.481 J5.815 E0.1643
G3  X168.456 Y284.766   I-0.859 J-1.780 E0.0930
; WIPE_TOWER_END

; WIPE_START
M204 S8000
G1 X168.567 Y284.871 E-.0291
G1 X168.687 Y284.968 E-.0291
G1 X168.813 Y285.054 E-.02911
G1 X168.946 Y285.13 E-.0291
G1 X169.084 Y285.196 E-.0291
G1 X169.227 Y285.251 E-.02909
G1 X169.374 Y285.294 E-.0291
G1 X169.524 Y285.326 E-.0291
G1 X169.676 Y285.346 E-.0291
G1 X169.828 Y285.354 E-.0291
G1 X169.982 Y285.349 E-.02911
G1 X170.134 Y285.333 E-.0291
G1 X170.284 Y285.305 E-.02909
G1 X170.293 Y285.303 E-.00172
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I1.217 J0 P1  F60000
; OBJECT_ID: 1747
; COOLING_NODE: 0
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
M204 S10000
G1 X180.717 Y36.457
G1 Z.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.2
G1 F6576
M204 S5000
G1 X181.197 Y36.457 E.0146
G1 X181.197 Y39.912 E.10508
G1 X180.717 Y39.912 E.0146
G1 X180.717 Y36.517 E.10325
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.197 Y36.457 E-.09191
G1 X181.197 Y37.973 E-.28809
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X181.197 Y42.582 Z1.2 F60000
G1 Z.8
G1 E.4 F1800
G1 F6576
M204 S5000
G1 X181.197 Y46.037 E.10508
G1 X180.717 Y46.037 E.0146
G1 X180.717 Y42.582 E.10508
G1 X181.137 Y42.582 E.01277
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.172 Y44.582 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X173.599 Y43.628 Z1.2 F60000
G1 X165.297 Y42.582 Z1.2
G1 Z.8
G1 E.4 F1800
G1 F6576
M204 S5000
G1 X165.297 Y46.037 E.10508
G1 X164.817 Y46.037 E.0146
G1 X164.817 Y42.582 E.10508
G1 X165.237 Y42.582 E.01277
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X165.272 Y44.582 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X165.297 Y39.912 Z1.2 F60000
G1 Z.8
G1 E.4 F1800
G1 F6576
M204 S5000
G1 X164.817 Y39.912 E.0146
G1 X164.817 Y36.457 E.10508
G1 X165.297 Y36.457 E.0146
G1 X165.297 Y39.852 E.10325
M204 S10000
G1 X165.057 Y39.716 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F15000
M204 S8000
G1 X165.057 Y36.653 E.02173
; WIPE_START
G1 X165.057 Y38.653 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X165.057 Y42.778 Z1.2 F60000
G1 Z.8
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X165.057 Y45.841 E.02173
; WIPE_START
G1 X165.057 Y43.841 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X172.63 Y44.794 Z1.2 F60000
G1 X180.957 Y45.841 Z1.2
G1 Z.8
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X180.957 Y42.778 E.02173
; WIPE_START
G1 X180.957 Y44.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X180.957 Y39.716 Z1.2 F60000
G1 Z.8
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X180.957 Y36.653 E.02173
; OBJECT_ID: 1563
; COOLING_NODE: 0
; WIPE_START
G1 X180.957 Y38.653 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S10000
G1 X180.596 Y46.277 Z1.2 F60000
G1 X180.267 Y53.217 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6576
M204 S5000
G1 X180.747 Y53.217 E.0146
G1 X180.747 Y56.672 E.10508
G1 X180.267 Y56.672 E.0146
G1 X180.267 Y53.277 E.10325
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.747 Y53.217 E-.09191
G1 X180.747 Y54.733 E-.28809
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X180.747 Y59.342 Z1.2 F60000
G1 Z.8
G1 E.4 F1800
G1 F6576
M204 S5000
G1 X180.747 Y62.797 E.10508
G1 X180.267 Y62.797 E.0146
G1 X180.267 Y59.342 E.10508
G1 X180.687 Y59.342 E.01277
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.721 Y61.342 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X173.149 Y60.388 Z1.2 F60000
G1 X164.847 Y59.342 Z1.2
G1 Z.8
G1 E.4 F1800
G1 F6576
M204 S5000
G1 X164.847 Y62.797 E.10508
G1 X164.367 Y62.797 E.0146
G1 X164.367 Y59.342 E.10508
G1 X164.787 Y59.342 E.01277
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.821 Y61.342 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X164.847 Y56.672 Z1.2 F60000
G1 Z.8
G1 E.4 F1800
G1 F6576
M204 S5000
G1 X164.367 Y56.672 E.0146
G1 X164.367 Y53.217 E.10508
G1 X164.847 Y53.217 E.0146
G1 X164.847 Y56.612 E.10325
M204 S10000
G1 X164.607 Y56.476 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F15000
M204 S8000
G1 X164.607 Y53.413 E.02173
; WIPE_START
G1 X164.607 Y55.413 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X164.607 Y59.538 Z1.2 F60000
G1 Z.8
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X164.607 Y62.601 E.02173
; WIPE_START
G1 X164.607 Y60.601 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X172.179 Y61.554 Z1.2 F60000
G1 X180.507 Y62.601 Z1.2
G1 Z.8
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X180.507 Y59.538 E.02173
; WIPE_START
G1 X180.507 Y61.538 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X180.507 Y56.476 Z1.2 F60000
G1 Z.8
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X180.507 Y53.413 E.02173
; WIPE_START
G1 X180.507 Y55.413 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I1.217 J0 P1  F60000
; stop printing object, unique label id: 1563
M625
; object ids of layer 4 start: 1563,1747
M624 AwAAAAAAAAA=
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U173 V131 Z1.2 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; object ids of this layer4 end: 1563,1747
M625
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #7
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
M204 S10000
G1 X167.774 Y261.05
G1 Z.8
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF3 NF2 ON2 NN3
M632 S2 M N
M400
M104 T0 S190 N0
M106 S255
M633
M204 S8000
G1  X198.274 Y261.050  E2.4272 F1411
G1  Y262.550  E0.1194
G1  X167.774  E2.4272
M632 S2 M N
M204 S10000
G1  Y263.300 
M73 P83 R3
G1  X197.774  F177
G1  Y261.800 
G1  X168.274 
M633
; NOZZLE_CHANGE_END OF3 NF2 ON2 NN3

G1 E-2 F1800
G17
M73 P84 R2
G3 Z1.2 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O8
M620 S2A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z3.8 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X165.524 Y281.05



M620.10 A0 F239.471 L0 H0.4 T240 P230 S1



M620.10 A1 F419.075 L0 H0.4 T240 P230 S1



M620.11 P1 I3 B-1 E-14 F299.339



M620.15 P180
M620.15 C220
M620.11 O1 T14


M620.11 K1 I3 B-1 R10 F299.339


M620.15 C220

M628 S1


M620.11 S1 L0 I3 B-1 R10 D8 E-14 F299.339


M629


;M620.11 H0




T2 H-1
M73 E1

;deretract


M73 P85 R2
;VG1 E4 F523
;VG1 E4 F261



; VFLUSH_START


;VG1 E0 F299


SYNC T0

; compensate for heating and cooling


; VFLUSH_END

M1002 set_filament_type:PLA

M400
M83



M620.10 R2


M628 S0

;VM109 S230

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F8.75 A0.4 R2


M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
M73 P87 R2
G1 Z3.8 F3000

M204 S25


M621 S2A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F8.75 A0.4 R2
M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.8

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I2 H-1 W1 ;enable ams air printing detect
M620 O8
M1002 gcode_claim_action : 0
M106 S255
M106 P2 S191

; filament start gcode
G1 X167.524 Y281.05 F60000
G1 Z.8
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X170.524 Y281.050  E0.1140 F1782
M73 P88 R2
G1 E-0.4000 F1800
M204 S10000
G1  X166.024  F600
G1  X167.524  F240
G1  X168.024  F600
G1  Y281.550 
G1  X167.024 
G1  Y280.550 
G1  X168.524 
G1  Y282.050 
G1  X166.524 
G1  Y280.050 
G1  X170.524 Y281.050   F1782
G1 E0.4000 F1800
M400
M104 T0 S230 N0
M204 S8000
G1  X198.524  E1.0642 F1782
G1  Y280.300  E0.0285
G1  X167.524  E1.1782 F2025
G1  Y279.550  E0.0285
G1  X198.524  E1.1782 F2473
G1  Y278.800  E0.0285
G1  X167.524  E1.1782 F4725
G1  Y278.050  E0.0285
G1  X198.524  E1.1782 F4775
G1  Y277.300  E0.0285
G1  X167.524  E1.1782
G1  Y276.550  E0.0285
G1  X198.524  E1.1782
G1  Y275.800  E0.0285
G1  X167.524  E1.1782
G1  Y275.050  E0.0285
G1  X198.524  E1.1782
G1  Y274.300  E0.0285
G1  X167.524  E1.1782
G1  Y273.550  E0.0285
G1  X198.524  E1.1782
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------



; WIPE_START
G1 F15000
M204 S8000
G1 X197.524 Y273.55 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I1.217 J0 P1  F60000
; OBJECT_ID: 1747
; COOLING_NODE: 0
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
M204 S10000
G1 X168.609 Y41.247
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F15476.087
M204 S8000
G1 X168.609 Y36.849 E.14887
G1 X177.405 Y36.849 E.29773
G1 X177.405 Y45.645 E.29773
G1 X168.609 Y45.645 E.29773
G1 X168.609 Y41.307 E.14683
; COOLING_NODE: 0
M204 S250
G1 X168.217 Y41.247 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6576
M204 S5000
G1 X168.217 Y36.457 E.15019
G1 X177.797 Y36.457 E.30037
G1 X177.797 Y46.037 E.30037
G1 X168.217 Y46.037 E.30037
G1 X168.217 Y41.307 E.14831
; WIPE_START
G1 F12000
M204 S8000
G1 X168.217 Y40.307 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I1.127 J.459 P1  F60000
G1 X169.558 Y37.013 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.43098
G1 F15000
M204 S8000
G1 X168.942 Y37.628 E.0281
G1 X168.942 Y38.177 E.01771
G1 X169.937 Y37.182 E.0454
G1 X170.486 Y37.182 E.01771
G1 X168.942 Y38.726 E.07044
G1 X168.942 Y39.275 E.01771
G1 X171.035 Y37.182 E.09549
G1 X171.584 Y37.182 E.01771
G1 X168.942 Y39.824 E.12053
G1 X168.942 Y40.372 E.01771
G1 X172.133 Y37.182 E.14557
G1 X172.681 Y37.182 E.01771
M73 P89 R2
G1 X168.942 Y40.921 E.17062
G1 X168.942 Y41.47 E.01771
G1 X173.23 Y37.182 E.19566
G1 X173.779 Y37.182 E.01771
G1 X168.942 Y42.019 E.2207
G1 X168.942 Y42.568 E.01771
G1 X174.328 Y37.182 E.24575
G1 X174.877 Y37.182 E.01771
G1 X168.942 Y43.116 E.27079
G1 X168.942 Y43.665 E.01771
G1 X175.425 Y37.182 E.29583
G1 X175.974 Y37.182 E.01771
G1 X168.942 Y44.214 E.32088
G1 X168.942 Y44.763 E.01771
G1 X176.523 Y37.182 E.34592
G1 X177.072 Y37.182 E.01771
G1 X168.942 Y45.312 E.37096
G1 X169.491 Y45.312 E.01771
G1 X177.072 Y37.731 E.34593
G1 X177.072 Y38.28 E.01771
G1 X170.04 Y45.312 E.32088
G1 X170.589 Y45.312 E.01771
G1 X177.072 Y38.829 E.29584
G1 X177.072 Y39.377 E.01771
G1 X171.138 Y45.312 E.2708
G1 X171.686 Y45.312 E.01771
G1 X177.072 Y39.926 E.24575
G1 X177.072 Y40.475 E.01771
G1 X172.235 Y45.312 E.22071
G1 X172.784 Y45.312 E.01771
G1 X177.072 Y41.024 E.19567
G1 X177.072 Y41.573 E.01771
G1 X173.333 Y45.312 E.17062
G1 X173.882 Y45.312 E.01771
G1 X177.072 Y42.121 E.14558
G1 X177.072 Y42.67 E.01771
G1 X174.43 Y45.312 E.12054
G1 X174.979 Y45.312 E.01771
G1 X177.072 Y43.219 E.09549
G1 X177.072 Y43.768 E.01771
G1 X175.528 Y45.312 E.07045
G1 X176.077 Y45.312 E.01771
G1 X177.072 Y44.317 E.04541
G1 X177.072 Y44.865 E.01771
G1 X176.456 Y45.481 E.0281
; OBJECT_ID: 1563
; COOLING_NODE: 0
; WIPE_START
G1 X177.072 Y44.865 E-.33098
G1 X177.072 Y44.736 E-.04902
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z1.2 I-1.01 J-.679 P1  F60000
G1 X168.159 Y58.007 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F15476.087
M204 S8000
G1 X168.159 Y53.609 E.14887
G1 X176.954 Y53.609 E.29773
G1 X176.954 Y62.405 E.29773
G1 X168.159 Y62.405 E.29773
G1 X168.159 Y58.067 E.14683
; COOLING_NODE: 0
M204 S250
M73 P89 R1
G1 X167.767 Y58.007 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6576
M204 S5000
G1 X167.767 Y53.217 E.15019
G1 X177.347 Y53.217 E.30037
G1 X177.347 Y62.797 E.30037
G1 X167.767 Y62.797 E.30037
G1 X167.767 Y58.067 E.14831
; WIPE_START
G1 F12000
M204 S8000
G1 X167.767 Y57.067 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I1.127 J.459 P1  F60000
G1 X169.108 Y53.773 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.43098
G1 F15000
M204 S8000
G1 X168.492 Y54.388 E.0281
G1 X168.492 Y54.937 E.01771
G1 X169.487 Y53.942 E.0454
G1 X170.036 Y53.942 E.01771
G1 X168.492 Y55.486 E.07044
G1 X168.492 Y56.035 E.01771
G1 X170.584 Y53.942 E.09549
G1 X171.133 Y53.942 E.01771
G1 X168.492 Y56.584 E.12053
G1 X168.492 Y57.132 E.01771
G1 X171.682 Y53.942 E.14557
G1 X172.231 Y53.942 E.01771
G1 X168.492 Y57.681 E.17062
G1 X168.492 Y58.23 E.01771
G1 X172.78 Y53.942 E.19566
G1 X173.328 Y53.942 E.01771
G1 X168.492 Y58.779 E.2207
G1 X168.492 Y59.328 E.01771
G1 X173.877 Y53.942 E.24575
G1 X174.426 Y53.942 E.01771
G1 X168.492 Y59.876 E.27079
G1 X168.492 Y60.425 E.01771
G1 X174.975 Y53.942 E.29583
G1 X175.524 Y53.942 E.01771
G1 X168.492 Y60.974 E.32088
G1 X168.492 Y61.523 E.01771
G1 X176.072 Y53.942 E.34592
G1 X176.621 Y53.942 E.01771
G1 X168.492 Y62.072 E.37096
G1 X169.041 Y62.072 E.01771
G1 X176.621 Y54.491 E.34593
G1 X176.621 Y55.04 E.01771
G1 X169.589 Y62.072 E.32088
G1 X170.138 Y62.072 E.01771
G1 X176.621 Y55.589 E.29584
G1 X176.621 Y56.137 E.01771
G1 X170.687 Y62.072 E.2708
G1 X171.236 Y62.072 E.01771
G1 X176.621 Y56.686 E.24575
G1 X176.621 Y57.235 E.01771
G1 X171.785 Y62.072 E.22071
G1 X172.333 Y62.072 E.01771
G1 X176.621 Y57.784 E.19567
G1 X176.621 Y58.333 E.01771
G1 X172.882 Y62.072 E.17062
G1 X173.431 Y62.072 E.01771
G1 X176.621 Y58.881 E.14558
G1 X176.621 Y59.43 E.01771
G1 X173.98 Y62.072 E.12054
G1 X174.529 Y62.072 E.01771
G1 X176.621 Y59.979 E.09549
G1 X176.621 Y60.528 E.01771
G1 X175.077 Y62.072 E.07045
G1 X175.626 Y62.072 E.01771
G1 X176.621 Y61.077 E.04541
G1 X176.621 Y61.625 E.01771
G1 X176.005 Y62.241 E.0281
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X176.621 Y61.625 E-.33098
G1 X176.621 Y61.496 E-.04902
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1563
M625
; layer num/total_layer_count: 5/10
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
; OBJECT_ID: 1747
; COOLING_NODE: 0
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z1.2 I1.201 J.195 P1  F60000
G1 X179.905 Y41.247 Z1.2
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F15476.087
M204 S8000
G1 X179.905 Y45.645 E.14887
G1 X176.609 Y45.645 E.11156
G1 X176.609 Y36.849 E.29773
G1 X179.905 Y36.849 E.11156
G1 X179.905 Y41.187 E.14683
; COOLING_NODE: 0
M204 S250
G1 X180.297 Y41.247 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6450
M204 S5000
G1 X180.297 Y46.037 E.15019
G1 X176.217 Y46.037 E.12793
G1 X176.217 Y36.457 E.30037
G1 X180.297 Y36.457 E.12793
G1 X180.297 Y41.187 E.14831
; COOLING_NODE: 0
; WIPE_START
G1 F12000
M204 S8000
G1 X180.297 Y42.187 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.105 J-1.212 P1  F60000
G1 X169.405 Y41.247 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F15476.087
M204 S8000
G1 X169.405 Y45.645 E.14887
G1 X166.109 Y45.645 E.11156
G1 X166.109 Y36.849 E.29773
G1 X169.405 Y36.849 E.11156
G1 X169.405 Y41.187 E.14683
; COOLING_NODE: 0
M204 S250
G1 X169.797 Y41.247 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6450
M204 S5000
G1 X169.797 Y46.037 E.15019
G1 X165.717 Y46.037 E.12793
G1 X165.717 Y36.457 E.30037
G1 X169.797 Y36.457 E.12793
G1 X169.797 Y41.187 E.14831
; WIPE_START
G1 F12000
M204 S8000
G1 X169.797 Y42.187 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.19 J-.253 P1  F60000
G1 X169.013 Y38.497 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X169.013 Y37.241 E.03938
G1 X166.501 Y37.241 E.07875
G1 X166.501 Y45.253 E.2512
G1 X169.013 Y45.253 E.07875
G1 X169.013 Y38.557 E.20994
M204 S10000
G1 X168.636 Y38.497 F60000
G1 F15000
M204 S8000
G1 X168.636 Y37.618 E.02755
G1 X166.878 Y37.618 E.05511
G1 X166.878 Y44.876 E.22755
G1 X168.636 Y44.876 E.05511
G1 X168.636 Y38.557 E.19812
M204 S10000
G1 X168.259 Y38.497 F60000
G1 F15000
M204 S8000
G1 X168.259 Y37.995 E.01573
G1 X167.255 Y37.995 E.03146
G1 X167.255 Y44.499 E.20391
G1 X168.259 Y44.499 E.03146
G1 X168.259 Y38.557 E.18629
M204 S10000
G1 X167.914 Y38.497 F60000
; LINE_WIDTH: 0.35612
G1 F15000
M204 S8000
G1 X167.914 Y38.34 E.00408
G1 X167.6 Y38.34 E.00816
G1 X167.6 Y44.154 E.15139
G1 X167.914 Y44.154 E.00816
G1 X167.914 Y38.557 E.14575
; WIPE_START
G1 X167.914 Y39.557 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.501 J1.109 P1  F60000
G1 X178.1 Y44.154 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.35611
G1 F15000
M204 S8000
G1 X178.414 Y44.154 E.00816
G1 X178.414 Y38.34 E.15139
G1 X178.1 Y38.34 E.00816
G1 X178.1 Y44.094 E.14982
M204 S10000
G1 X177.755 Y44.499 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X178.759 Y44.499 E.03146
G1 X178.759 Y37.995 E.20391
G1 X177.755 Y37.995 E.03146
G1 X177.755 Y44.439 E.20203
M204 S10000
G1 X177.378 Y44.876 F60000
G1 F15000
M204 S8000
G1 X179.136 Y44.876 E.05511
G1 X179.136 Y37.618 E.22755
G1 X177.378 Y37.618 E.05511
G1 X177.378 Y44.816 E.22567
M204 S10000
G1 X177.001 Y45.253 F60000
G1 F15000
M204 S8000
G1 X179.513 Y45.253 E.07875
G1 X179.513 Y37.241 E.2512
G1 X177.001 Y37.241 E.07875
G1 X177.001 Y45.193 E.24931
; OBJECT_ID: 1563
; COOLING_NODE: 0
; WIPE_START
G1 X177.001 Y44.193 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z1.4 I-1.198 J.213 P1  F60000
G1 X179.454 Y58.007 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F15476.087
M204 S8000
G1 X179.454 Y62.405 E.14887
G1 X176.159 Y62.405 E.11156
G1 X176.159 Y53.609 E.29773
G1 X179.454 Y53.609 E.11156
G1 X179.454 Y57.947 E.14683
; COOLING_NODE: 0
M204 S250
G1 X179.847 Y58.007 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6450
M204 S5000
G1 X179.847 Y62.797 E.15019
G1 X175.767 Y62.797 E.12793
G1 X175.767 Y53.217 E.30037
G1 X179.847 Y53.217 E.12793
G1 X179.847 Y57.947 E.14831
; COOLING_NODE: 0
; WIPE_START
G1 F12000
M204 S8000
G1 X179.847 Y58.947 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.105 J-1.212 P1  F60000
G1 X168.954 Y58.007 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F15476.087
M204 S8000
G1 X168.954 Y62.405 E.14887
G1 X165.659 Y62.405 E.11156
G1 X165.659 Y53.609 E.29773
G1 X168.954 Y53.609 E.11156
G1 X168.954 Y57.947 E.14683
; COOLING_NODE: 0
M204 S250
G1 X169.347 Y58.007 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6450
M204 S5000
G1 X169.347 Y62.797 E.15019
G1 X165.267 Y62.797 E.12793
G1 X165.267 Y53.217 E.30037
G1 X169.347 Y53.217 E.12793
G1 X169.347 Y57.947 E.14831
; WIPE_START
G1 F12000
M204 S8000
G1 X169.347 Y58.947 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.19 J-.253 P1  F60000
G1 X168.562 Y55.257 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X168.562 Y54.001 E.03938
G1 X166.051 Y54.001 E.07875
G1 X166.051 Y62.013 E.2512
G1 X168.562 Y62.013 E.07875
G1 X168.562 Y55.317 E.20994
M204 S10000
G1 X168.185 Y55.257 F60000
G1 F15000
M204 S8000
G1 X168.185 Y54.378 E.02755
G1 X166.428 Y54.378 E.05511
G1 X166.428 Y61.636 E.22755
G1 X168.185 Y61.636 E.05511
G1 X168.185 Y55.317 E.19812
M204 S10000
G1 X167.808 Y55.257 F60000
G1 F15000
M204 S8000
G1 X167.808 Y54.755 E.01573
G1 X166.805 Y54.755 E.03146
G1 X166.805 Y61.259 E.20391
G1 X167.808 Y61.259 E.03146
G1 X167.808 Y55.317 E.18629
M204 S10000
G1 X167.463 Y55.257 F60000
; LINE_WIDTH: 0.35612
G1 F15000
M204 S8000
G1 X167.463 Y55.1 E.00408
G1 X167.15 Y55.1 E.00816
G1 X167.15 Y60.914 E.15139
G1 X167.463 Y60.914 E.00816
G1 X167.463 Y55.317 E.14575
; WIPE_START
G1 X167.463 Y56.317 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.501 J1.109 P1  F60000
G1 X177.65 Y60.914 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.35611
G1 F15000
M204 S8000
G1 X177.963 Y60.914 E.00816
G1 X177.963 Y55.1 E.15139
G1 X177.65 Y55.1 E.00816
G1 X177.65 Y60.854 E.14982
M204 S10000
G1 X177.305 Y61.259 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X178.308 Y61.259 E.03146
G1 X178.308 Y54.755 E.20391
G1 X177.305 Y54.755 E.03146
G1 X177.305 Y61.199 E.20203
M204 S10000
G1 X176.928 Y61.636 F60000
G1 F15000
M204 S8000
G1 X178.685 Y61.636 E.05511
G1 X178.685 Y54.378 E.22755
M73 P90 R1
G1 X176.928 Y54.378 E.05511
G1 X176.928 Y61.576 E.22567
M204 S10000
G1 X176.551 Y62.013 F60000
G1 F15000
M204 S8000
G1 X179.062 Y62.013 E.07875
G1 X179.062 Y54.001 E.2512
G1 X176.551 Y54.001 E.07875
G1 X176.551 Y61.953 E.24931
; WIPE_START
G1 X176.551 Y60.953 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.217 J0 P1  F60000
; stop printing object, unique label id: 1563
M625
; object ids of layer 5 start: 1563,1747
M624 AwAAAAAAAAA=
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U173 V131 Z1.4 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; object ids of this layer5 end: 1563,1747
M625
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #8
; material : TPU-AMS -> TPU-AMS
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
M204 S10000
G1 X167.774 Y272.3
G1 Z1
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF2 NF3 ON3 NN2
M632 S3 M N
M400
M104 T0 S180 N0
M106 S255
M633
M204 S8000
G1  X198.274 Y272.300  E2.4272 F6583
G1  Y273.800  E0.1194
G1  X167.774  E2.4272
M632 S3 M N
M204 S10000
G1  Y274.550 
G1  X197.774  F3540
G1  Y273.050 
G1  X168.274 
M633
; NOZZLE_CHANGE_END OF2 NF3 ON3 NN2

G1 E-2 F1800
G17
G3 Z1.4 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S0 ; disable E air printing detect


M620 O9
M620 S3A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X165.524 Y252.55



M620.10 A0 F419.075 L0 H0.4 T240 P230 S1



M620.10 A1 F239.471 L0 H0.4 T240 P230 S1



M620.11 P1 I2 B-1 E-14 F523.843



M620.15 P190
M620.15 C220
M620.11 O1 T18


M620.11 K1 I2 B-1 R10 F523.843


M620.15 C220

M628 S1


M620.11 S1 L0 I2 B-1 R10 D8 E-14 F523.843


M629


;M620.11 H0




T3 H-1
M73 E0

;deretract


;VG1 E4 F299
;VG1 E4 F149



; VFLUSH_START


;VG1 E0 F299


SYNC T0

; compensate for heating and cooling


; VFLUSH_END

M1002 set_filament_type:TPU-AMS

M400
M83



M620.10 R2


M628 S0

;VM109 S230

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F5 A0.4 R2


M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
M73 P92 R1
G1 Z4 F3000

M204 S25


M621 S3A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F5 A0.4 R2
M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
M73 P93 R1
G1 Z4

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S0 ; disable E air printing detect


M620.6 I3 H-1 W1 ;enable ams air printing detect
M620 O9
M1002 gcode_claim_action : 0
M106 S79.05
M106 P2 S255

; filament start gcode
G1 X167.524 Y252.55 F60000
G1 Z1
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X170.524 Y252.550  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X166.024  F600
G1  X167.524  F240
G1  X168.024  F600
G1  Y253.050 
G1  X167.024 
G1  Y252.050 
G1  X168.524 
G1  Y253.550 
G1  X166.524 
G1  Y251.550 
G1  X170.524 Y252.550   F1782
G1 E0.4000 F1800
M400
M104 T0 S230 N0
M204 S8000
G1  X198.524  E1.0642 F1782
G1  Y253.300  E0.0285
G1  X167.524  E1.1782 F2025
G1  Y254.050  E0.0285
G1  X198.524  E1.1782 F2473
G1  Y254.800  E0.0285
G1  X167.524  E1.1782 F4725
G1  Y255.550  E0.0285
G1  X198.524  E1.1782 F4775
G1  Y256.300  E0.0285
G1  X167.524  E1.1782
G1  Y257.050  E0.0285
G1  X198.524  E1.1782
G1  Y257.800  E0.0285
G1  X167.524  E1.1782
G1  Y258.550  E0.0285
G1  X198.524  E1.1782
G1  Y259.300  E0.0285
G1  X167.524  E1.1782
G1  Y260.050  E0.0285
M73 P94 R1
G1  X198.524  E1.1782
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y282.800   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X199.024 Y283.300  
M204 S8000
G3  X196.674 Y285.295   I-4.711 J-3.168 E0.1186
G3  X193.973 Y284.084   I-0.172 J-3.233 E0.1168
G2  X191.349 Y283.300   I-2.631 J4.026 E0.1056
G2  X174.514 Y283.304   I-8.325 J435.388 E0.6399
G2  X170.716 Y285.152   I0.481 J5.815 E0.1643
G3  X168.456 Y284.766   I-0.859 J-1.780 E0.0930
G1  X167.024 Y283.300   E0.0779
G3  X165.084 Y281.023   I3.772 J-5.179 E0.1147
G3  X166.258 Y278.335   I2.979 J-0.300 E0.1165
G2  X167.024 Y275.849   I-3.669 J-2.492 E0.1004
G2  X167.020 Y259.325   I-414.299 J-8.174 E0.6281
G2  X165.150 Y255.613   I-7.052 J1.226 E0.1603
G3  X165.662 Y253.444   I1.765 J-0.728 E0.0904
G1 E-0.4000 F1800
M204 S10000
G1  X167.409 Y251.656   F600
G1 E0.4000 F1800
M204 S8000
G3  X170.134 Y250.016   I2.971 J1.854 E0.1254 F5400
G3  X172.556 Y251.543   I-3.988 J9.012 E0.1092
G2  X174.700 Y252.050   I2.175 J-4.416 E0.0844
G1  X183.024  E0.3164
G1  X184.274  E0.0475
G2  X191.903 Y252.018   I3.537 J-65.693 E0.2901
G2  X195.472 Y250.136   I-1.997 J-8.111 E0.1549
G3  X197.592 Y250.584   I0.723 J1.820 E0.0873
G1  X199.024 Y252.050   E0.0779
G3  X200.964 Y254.327   I-3.772 J5.179 E0.1147
G3  X199.790 Y257.015   I-2.979 J0.300 E0.1165
G2  X199.024 Y259.501   I3.669 J2.492 E0.1003
G2  X199.028 Y276.025   I414.315 J8.174 E0.6281
G2  X200.898 Y279.737   I7.052 J-1.226 E0.1603
G3  X200.519 Y281.769   I-1.718 J0.731 E0.0832
G1  X199.024 Y283.300   E0.0813
; WIPE_TOWER_END

; WIPE_START
G1 F15000
M204 S8000
G1 X199.024 Y283.3 E-.00001
G1 X199.024 Y283.3 E-.00001
G1 X200.422 Y281.869 E-.37998
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.217 J0 P1  F60000
; OBJECT_ID: 1747
; COOLING_NODE: 0
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
M204 S10000
G1 X165.297 Y36.457
G1 Z1
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.2
G1 F6450
M204 S5000
G1 X165.297 Y46.037 E.29136
G1 X164.817 Y46.037 E.0146
G1 X164.817 Y36.457 E.29136
G1 X165.237 Y36.457 E.01277
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X165.25 Y38.457 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X170.609 Y41.247 Z1.4 F60000
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X170.609 Y36.849 E.1444
G1 X175.405 Y36.849 E.15746
G1 X175.405 Y45.645 E.2888
G1 X170.609 Y45.645 E.15746
G1 X170.609 Y41.307 E.14243
; COOLING_NODE: 0
M204 S250
G1 X170.217 Y41.247 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6450
M204 S5000
G1 X170.217 Y36.457 E.14568
G1 X175.797 Y36.457 E.16971
G1 X175.797 Y46.037 E.29136
G1 X170.217 Y46.037 E.16971
G1 X170.217 Y41.307 E.14386
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X170.217 Y39.307 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X177.583 Y37.308 Z1.4 F60000
G1 X180.717 Y36.457 Z1.4
G1 Z1
G1 E.4 F1800
G1 F6450
M204 S5000
G1 X181.197 Y36.457 E.0146
G1 X181.197 Y46.037 E.29136
G1 X180.717 Y46.037 E.0146
G1 X180.717 Y36.517 E.28954
M204 S10000
G1 X180.957 Y36.653 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F15000
M204 S8000
G1 X180.957 Y45.841 E.06517
; WIPE_START
G1 X180.957 Y43.841 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X175.013 Y39.247 Z1.4 F60000
G1 Z1
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X175.013 Y37.241 E.061
G1 X171.001 Y37.241 E.12201
G1 X171.001 Y45.253 E.24366
G1 X175.013 Y45.253 E.12201
G1 X175.013 Y39.307 E.18083
M204 S10000
G1 X174.636 Y39.247 F60000
G1 F9547.299
M204 S8000
G1 X174.636 Y37.618 E.04954
G1 X171.378 Y37.618 E.09907
G1 X171.378 Y44.876 E.22073
G1 X174.636 Y44.876 E.09907
G1 X174.636 Y39.307 E.16936
M204 S10000
G1 X174.259 Y39.247 F60000
G1 F9547.299
M204 S8000
G1 X174.259 Y37.995 E.03807
G1 X171.755 Y37.995 E.07614
G1 X171.755 Y44.499 E.19779
G1 X174.259 Y44.499 E.07614
G1 X174.259 Y39.307 E.1579
M204 S10000
G1 X173.882 Y39.247 F60000
G1 F9547.299
M204 S8000
G1 X173.882 Y38.372 E.0266
G1 X172.132 Y38.372 E.0532
G1 X172.132 Y44.122 E.17485
G1 X173.882 Y44.122 E.0532
G1 X173.882 Y39.307 E.14643
M204 S10000
G1 X173.505 Y39.247 F60000
G1 F9547.299
M204 S8000
G1 X173.505 Y38.749 E.01513
G1 X172.509 Y38.749 E.03027
G1 X172.509 Y43.745 E.15192
G1 X173.505 Y43.745 E.03027
G1 X173.505 Y39.307 E.13496
M204 S10000
G1 X173.162 Y39.247 F60000
; LINE_WIDTH: 0.35198
G1 F11648.225
M204 S8000
G1 X173.162 Y39.092 E.00385
G1 X172.853 Y39.092 E.0077
G1 X172.853 Y43.402 E.10741
G1 X173.162 Y43.402 E.0077
G1 X173.162 Y39.307 E.10207
; WIPE_START
G1 X173.162 Y41.307 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X166.543 Y37.506 Z1.4 F60000
G1 X165.057 Y36.653 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F15000
M204 S8000
G1 X165.057 Y45.841 E.06517
; OBJECT_ID: 1563
; COOLING_NODE: 0
; WIPE_START
M73 P94 R0
G1 X165.057 Y43.841 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S10000
G1 X164.886 Y51.472 Z1.4 F60000
G1 X164.847 Y53.217 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6450
M204 S5000
G1 X164.847 Y62.797 E.29136
G1 X164.367 Y62.797 E.0146
G1 X164.367 Y53.217 E.29136
G1 X164.787 Y53.217 E.01277
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.799 Y55.217 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X170.159 Y58.007 Z1.4 F60000
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8843.478
M204 S8000
G1 X170.159 Y53.609 E.1444
G1 X174.954 Y53.609 E.15746
G1 X174.954 Y62.405 E.2888
G1 X170.159 Y62.405 E.15746
G1 X170.159 Y58.067 E.14243
; COOLING_NODE: 0
M204 S250
G1 X169.767 Y58.007 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6450
M204 S5000
G1 X169.767 Y53.217 E.14568
G1 X175.347 Y53.217 E.16971
G1 X175.347 Y62.797 E.29136
G1 X169.767 Y62.797 E.16971
G1 X169.767 Y58.067 E.14386
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X169.767 Y56.067 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X177.132 Y54.068 Z1.4 F60000
G1 X180.267 Y53.217 Z1.4
G1 Z1
G1 E.4 F1800
G1 F6450
M204 S5000
G1 X180.747 Y53.217 E.0146
G1 X180.747 Y62.797 E.29136
G1 X180.267 Y62.797 E.0146
G1 X180.267 Y53.277 E.28954
M204 S10000
G1 X180.507 Y53.413 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F15000
M204 S8000
G1 X180.507 Y62.601 E.06517
; WIPE_START
G1 X180.507 Y60.601 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X174.562 Y56.007 Z1.4 F60000
G1 Z1
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F9547.299
M204 S8000
G1 X174.562 Y54.001 E.061
G1 X170.551 Y54.001 E.12201
G1 X170.551 Y62.013 E.24366
G1 X174.562 Y62.013 E.12201
G1 X174.562 Y56.067 E.18083
M204 S10000
G1 X174.185 Y56.007 F60000
G1 F9547.299
M204 S8000
G1 X174.185 Y54.378 E.04954
G1 X170.928 Y54.378 E.09907
G1 X170.928 Y61.636 E.22073
G1 X174.185 Y61.636 E.09907
G1 X174.185 Y56.067 E.16936
M204 S10000
G1 X173.808 Y56.007 F60000
G1 F9547.299
M204 S8000
G1 X173.808 Y54.755 E.03807
G1 X171.305 Y54.755 E.07614
G1 X171.305 Y61.259 E.19779
G1 X173.808 Y61.259 E.07614
G1 X173.808 Y56.067 E.1579
M204 S10000
G1 X173.431 Y56.007 F60000
G1 F9547.299
M204 S8000
G1 X173.431 Y55.132 E.0266
G1 X171.682 Y55.132 E.0532
G1 X171.682 Y60.882 E.17485
G1 X173.431 Y60.882 E.0532
G1 X173.431 Y56.067 E.14643
M204 S10000
G1 X173.054 Y56.007 F60000
G1 F9547.299
M204 S8000
G1 X173.054 Y55.509 E.01513
G1 X172.059 Y55.509 E.03027
G1 X172.059 Y60.505 E.15192
G1 X173.054 Y60.505 E.03027
G1 X173.054 Y56.067 E.13496
M204 S10000
G1 X172.711 Y56.007 F60000
; LINE_WIDTH: 0.35198
G1 F11648.225
M204 S8000
G1 X172.711 Y55.852 E.00385
G1 X172.402 Y55.852 E.0077
G1 X172.402 Y60.162 E.10741
G1 X172.711 Y60.162 E.0077
G1 X172.711 Y56.067 E.10207
; WIPE_START
G1 X172.711 Y58.067 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X166.092 Y54.266 Z1.4 F60000
G1 X164.607 Y53.413 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F15000
M204 S8000
G1 X164.607 Y62.601 E.06517
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X164.607 Y60.601 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1563
M625
; layer num/total_layer_count: 6/10
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
M106 S99.45
; OBJECT_ID: 1747
; COOLING_NODE: 0
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z1.4 I1.003 J.689 P1  F60000
G1 X181.197 Y36.457 Z1.4
G1 Z1.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.2
G1 F6180
M204 S5000
G1 X181.197 Y46.037 E.29136
G1 X164.817 Y46.037 E.49818
G1 X164.817 Y36.457 E.29136
G1 X181.137 Y36.457 E.49635
; WIPE_START
G1 F9547.055
M204 S8000
G1 X181.15 Y38.457 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X180.99 Y45.263 Z1.6 F60000
G1 Z1.2
G1 E.4 F1800
; FEATURE: Top surface
G1 F6180
M204 S2000
G1 X180.423 Y45.83 E.02439
M73 P95 R0
G1 X180.289 Y45.963
G1 X179.756 Y45.963
G1 X179.889 Y45.83
G1 X180.99 Y44.729 E.04732
G1 X181.123 Y44.596
G1 X181.123 Y44.062
G1 X180.99 Y44.196
G1 X179.356 Y45.83 E.07026
G1 X179.223 Y45.963
G1 X178.689 Y45.963
G1 X178.823 Y45.83
G1 X180.99 Y43.663 E.0932
G1 X181.123 Y43.529
G1 X181.123 Y42.996
G1 X180.99 Y43.13
G1 X178.29 Y45.83 E.11613
G1 X178.156 Y45.963
G1 X177.623 Y45.963
G1 X177.756 Y45.83
G1 X180.99 Y42.596 E.13907
G1 X181.123 Y42.463
G1 X181.123 Y41.929
G1 X180.99 Y42.063
G1 X177.223 Y45.83 E.162
G1 X177.09 Y45.963
G1 X176.556 Y45.963
G1 X176.69 Y45.83
G1 X180.99 Y41.53 E.18494
G1 X181.123 Y41.396
G1 X181.123 Y40.863
G1 X180.99 Y40.997
G1 X176.157 Y45.83 E.20788
G1 X176.023 Y45.963
G1 X175.49 Y45.963
G1 X175.623 Y45.83
G1 X180.99 Y40.463 E.23081
G1 X181.123 Y40.33
G1 X181.123 Y39.796
G1 X180.99 Y39.93
G1 X175.09 Y45.83 E.25375
G1 X174.956 Y45.963
G1 X174.423 Y45.963
G1 X174.557 Y45.83
G1 X180.99 Y39.397 E.27669
G1 X181.123 Y39.263
G1 X181.123 Y38.73
G1 X180.99 Y38.864
G1 X174.024 Y45.83 E.29962
G1 X173.89 Y45.963
G1 X173.357 Y45.963
G1 X173.49 Y45.83
G1 X180.99 Y38.33 E.32256
G1 X181.123 Y38.197
G1 X181.123 Y37.663
G1 X180.99 Y37.797
G1 X172.957 Y45.83 E.34549
G1 X172.823 Y45.963
G1 X172.29 Y45.963
G1 X172.424 Y45.83
G1 X180.99 Y37.264 E.36843
G1 X181.123 Y37.13
G1 X181.123 Y36.597
G1 X180.99 Y36.731
G1 X171.891 Y45.83 E.39137
G1 X171.757 Y45.963
G1 X171.224 Y45.963
G1 X171.357 Y45.83
G1 X180.523 Y36.664 E.39421
G1 X180.656 Y36.531
G1 X180.123 Y36.531
G1 X179.989 Y36.664
G1 X170.824 Y45.83 E.39421
G1 X170.69 Y45.963
G1 X170.157 Y45.963
G1 X170.291 Y45.83
G1 X179.456 Y36.664 E.39421
G1 X179.59 Y36.531
G1 X179.056 Y36.531
G1 X178.923 Y36.664
G1 X169.758 Y45.83 E.39421
G1 X169.624 Y45.963
G1 X169.091 Y45.963
G1 X169.224 Y45.83
G1 X178.39 Y36.664 E.39421
G1 X178.523 Y36.531
G1 X177.99 Y36.531
G1 X177.856 Y36.664
G1 X168.691 Y45.83 E.39421
G1 X168.557 Y45.963
G1 X168.024 Y45.963
G1 X168.158 Y45.83
G1 X177.323 Y36.664 E.39421
G1 X177.457 Y36.531
G1 X176.923 Y36.531
G1 X176.79 Y36.664
G1 X167.625 Y45.83 E.39421
G1 X167.491 Y45.963
G1 X166.958 Y45.963
G1 X167.091 Y45.83
G1 X176.256 Y36.664 E.39421
G1 X176.39 Y36.531
G1 X175.857 Y36.531
G1 X175.723 Y36.664
G1 X166.558 Y45.83 E.39421
G1 X166.424 Y45.963
G1 X165.891 Y45.963
G1 X166.025 Y45.83
G1 X175.19 Y36.664 E.39421
G1 X175.324 Y36.531
G1 X174.79 Y36.531
G1 X174.657 Y36.664
G1 X165.491 Y45.83 E.39421
G1 X165.358 Y45.963
G1 X164.891 Y45.897
G1 X165.024 Y45.763
G1 X174.123 Y36.664 E.39136
G1 X174.257 Y36.531
G1 X173.724 Y36.531
G1 X173.59 Y36.664
G1 X165.024 Y45.23 E.36842
G1 X164.891 Y45.364
G1 X164.891 Y44.831
G1 X165.024 Y44.697
G1 X173.057 Y36.664 E.34549
G1 X173.191 Y36.531
G1 X172.657 Y36.531
G1 X172.524 Y36.664
G1 X165.024 Y44.164 E.32255
G1 X164.891 Y44.297
G1 X164.891 Y43.764
G1 X165.024 Y43.63
G1 X171.99 Y36.664 E.29962
G1 X172.124 Y36.531
G1 X171.591 Y36.531
G1 X171.457 Y36.664
G1 X165.024 Y43.097 E.27668
G1 X164.891 Y43.231
G1 X164.891 Y42.697
G1 X165.024 Y42.564
G1 X170.924 Y36.664 E.25374
G1 X171.058 Y36.531
G1 X170.524 Y36.531
G1 X170.391 Y36.664
G1 X165.024 Y42.031 E.23081
G1 X164.891 Y42.164
G1 X164.891 Y41.631
G1 X165.024 Y41.497
G1 X169.857 Y36.664 E.20787
G1 X169.991 Y36.531
G1 X169.458 Y36.531
G1 X169.324 Y36.664
G1 X165.024 Y40.964 E.18494
G1 X164.891 Y41.098
G1 X164.891 Y40.564
G1 X165.024 Y40.431
G1 X168.791 Y36.664 E.162
G1 X168.925 Y36.531
G1 X168.391 Y36.531
G1 X168.258 Y36.664
G1 X165.024 Y39.898 E.13906
G1 X164.891 Y40.031
G1 X164.891 Y39.498
G1 X165.024 Y39.364
G1 X167.724 Y36.664 E.11613
G1 X167.858 Y36.531
G1 X167.325 Y36.531
G1 X167.191 Y36.664
G1 X165.024 Y38.831 E.09319
G1 X164.891 Y38.965
G1 X164.891 Y38.431
G1 X165.024 Y38.298
G1 X166.658 Y36.664 E.07025
G1 X166.792 Y36.531
G1 X166.258 Y36.531
G1 X166.125 Y36.664
G1 X165.024 Y37.765 E.04732
G1 X164.891 Y37.898
G1 X164.891 Y37.365
G1 X165.024 Y37.231
G1 X165.591 Y36.664 E.02438
; OBJECT_ID: 1563
; COOLING_NODE: 0
; WIPE_START
G1 F9547.055
M204 S8000
G1 X165.024 Y37.231 E-.15232
G1 X164.891 Y37.365 E-.03591
G1 X164.891 Y37.898 E-.10132
G1 X165.024 Y37.765 E-.03591
G1 X165.227 Y37.562 E-.05454
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S10000
G1 X170.601 Y42.982 Z1.6 F60000
G1 X180.747 Y53.217 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Outer wall
G1 F6180
M204 S5000
G1 X180.747 Y62.797 E.29136
G1 X164.367 Y62.797 E.49818
G1 X164.367 Y53.217 E.29136
G1 X180.687 Y53.217 E.49635
; WIPE_START
G1 F9547.055
M204 S8000
G1 X180.699 Y55.217 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X180.539 Y62.023 Z1.6 F60000
G1 Z1.2
G1 E.4 F1800
; FEATURE: Top surface
G1 F6180
M204 S2000
G1 X179.972 Y62.59 E.02439
G1 X179.839 Y62.723
G1 X179.305 Y62.723
G1 X179.439 Y62.59
G1 X180.539 Y61.489 E.04732
G1 X180.673 Y61.356
G1 X180.673 Y60.822
G1 X180.539 Y60.956
G1 X178.906 Y62.59 E.07026
G1 X178.772 Y62.723
G1 X178.239 Y62.723
G1 X178.372 Y62.59
G1 X180.539 Y60.423 E.0932
G1 X180.673 Y60.289
G1 X180.673 Y59.756
G1 X180.539 Y59.89
G1 X177.839 Y62.59 E.11613
G1 X177.705 Y62.723
G1 X177.172 Y62.723
G1 X177.306 Y62.59
G1 X180.539 Y59.356 E.13907
G1 X180.673 Y59.223
G1 X180.673 Y58.689
G1 X180.539 Y58.823
G1 X176.773 Y62.59 E.162
G1 X176.639 Y62.723
G1 X176.106 Y62.723
G1 X176.239 Y62.59
G1 X180.539 Y58.29 E.18494
G1 X180.673 Y58.156
G1 X180.673 Y57.623
G1 X180.539 Y57.757
G1 X175.706 Y62.59 E.20788
G1 X175.572 Y62.723
G1 X175.039 Y62.723
G1 X175.173 Y62.59
G1 X180.539 Y57.223 E.23081
G1 X180.673 Y57.09
G1 X180.673 Y56.556
G1 X180.539 Y56.69
G1 X174.64 Y62.59 E.25375
G1 X174.506 Y62.723
G1 X173.973 Y62.723
G1 X174.106 Y62.59
G1 X180.539 Y56.157 E.27669
G1 X180.673 Y56.023
G1 X180.673 Y55.49
G1 X180.539 Y55.624
G1 X173.573 Y62.59 E.29962
G1 X173.439 Y62.723
G1 X172.906 Y62.723
G1 X173.04 Y62.59
G1 X180.539 Y55.09 E.32256
G1 X180.673 Y54.957
G1 X180.673 Y54.423
G1 X180.539 Y54.557
G1 X172.507 Y62.59 E.34549
G1 X172.373 Y62.723
G1 X171.84 Y62.723
G1 X171.973 Y62.59
G1 X180.539 Y54.024 E.36843
G1 X180.673 Y53.89
G1 X180.673 Y53.357
G1 X180.539 Y53.491
G1 X171.44 Y62.59 E.39137
G1 X171.306 Y62.723
G1 X170.773 Y62.723
G1 X170.907 Y62.59
G1 X180.072 Y53.424 E.39421
G1 X180.206 Y53.291
G1 X179.672 Y53.291
G1 X179.539 Y53.424
G1 X170.374 Y62.59 E.39421
G1 X170.24 Y62.723
G1 X169.707 Y62.723
G1 X169.84 Y62.59
G1 X179.005 Y53.424 E.39421
G1 X179.139 Y53.291
G1 X178.606 Y53.291
G1 X178.472 Y53.424
G1 X169.307 Y62.59 E.39421
G1 X169.173 Y62.723
G1 X168.64 Y62.723
G1 X168.774 Y62.59
G1 X177.939 Y53.424 E.39421
G1 X178.073 Y53.291
G1 X177.539 Y53.291
G1 X177.406 Y53.424
G1 X168.24 Y62.59 E.39421
G1 X168.107 Y62.723
G1 X167.574 Y62.723
G1 X167.707 Y62.59
G1 X176.872 Y53.424 E.39421
G1 X177.006 Y53.291
G1 X176.473 Y53.291
G1 X176.339 Y53.424
G1 X167.174 Y62.59 E.39421
G1 X167.04 Y62.723
G1 X166.507 Y62.723
G1 X166.641 Y62.59
G1 X175.806 Y53.424 E.39421
G1 X175.94 Y53.291
G1 X175.406 Y53.291
G1 X175.273 Y53.424
G1 X166.107 Y62.59 E.39421
G1 X165.974 Y62.723
G1 X165.441 Y62.723
G1 X165.574 Y62.59
M73 P96 R0
G1 X174.739 Y53.424 E.39421
G1 X174.873 Y53.291
G1 X174.34 Y53.291
G1 X174.206 Y53.424
G1 X165.041 Y62.59 E.39421
G1 X164.907 Y62.723
G1 X164.44 Y62.657
G1 X164.574 Y62.523
G1 X173.673 Y53.424 E.39136
G1 X173.807 Y53.291
G1 X173.273 Y53.291
G1 X173.14 Y53.424
G1 X164.574 Y61.99 E.36842
G1 X164.44 Y62.124
G1 X164.44 Y61.591
G1 X164.574 Y61.457
G1 X172.606 Y53.424 E.34549
G1 X172.74 Y53.291
G1 X172.207 Y53.291
G1 X172.073 Y53.424
G1 X164.574 Y60.924 E.32255
G1 X164.44 Y61.057
G1 X164.44 Y60.524
G1 X164.574 Y60.39
G1 X171.54 Y53.424 E.29962
G1 X171.674 Y53.291
G1 X171.14 Y53.291
G1 X171.007 Y53.424
G1 X164.574 Y59.857 E.27668
G1 X164.44 Y59.991
G1 X164.44 Y59.457
G1 X164.574 Y59.324
G1 X170.473 Y53.424 E.25374
G1 X170.607 Y53.291
G1 X170.074 Y53.291
G1 X169.94 Y53.424
G1 X164.574 Y58.791 E.23081
G1 X164.44 Y58.924
G1 X164.44 Y58.391
G1 X164.574 Y58.257
G1 X169.407 Y53.424 E.20787
G1 X169.54 Y53.291
G1 X169.007 Y53.291
G1 X168.874 Y53.424
G1 X164.574 Y57.724 E.18494
G1 X164.44 Y57.858
G1 X164.44 Y57.324
G1 X164.574 Y57.191
G1 X168.34 Y53.424 E.162
G1 X168.474 Y53.291
G1 X167.941 Y53.291
G1 X167.807 Y53.424
G1 X164.574 Y56.658 E.13906
G1 X164.44 Y56.791
G1 X164.44 Y56.258
G1 X164.574 Y56.124
G1 X167.274 Y53.424 E.11613
G1 X167.407 Y53.291
G1 X166.874 Y53.291
G1 X166.741 Y53.424
G1 X164.574 Y55.591 E.09319
G1 X164.44 Y55.725
G1 X164.44 Y55.191
G1 X164.574 Y55.058
G1 X166.207 Y53.424 E.07025
G1 X166.341 Y53.291
G1 X165.808 Y53.291
G1 X165.674 Y53.424
G1 X164.574 Y54.525 E.04732
G1 X164.44 Y54.658
G1 X164.44 Y54.125
G1 X164.574 Y53.991
G1 X165.141 Y53.424 E.02438
; WIPE_START
G1 F9547.055
M204 S8000
G1 X164.574 Y53.991 E-.15232
G1 X164.44 Y54.125 E-.03591
G1 X164.44 Y54.658 E-.10132
G1 X164.574 Y54.525 E-.03591
G1 X164.777 Y54.322 E-.05454
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.217 J0 P1  F60000
; stop printing object, unique label id: 1563
M625
; object ids of layer 6 start: 1563,1747
M624 AwAAAAAAAAA=
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U173 V131 Z1.6 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; object ids of this layer6 end: 1563,1747
M625
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 7/10
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
M106 S102
; OBJECT_ID: 1747
; COOLING_NODE: 9
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
G1 X179.697 Y36.457 F60000
G1 Z1.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S5000
G1 X179.697 Y46.037 E.29136
G1 X179.217 Y46.037 E.0146
G1 X179.217 Y36.457 E.29136
G1 X179.637 Y36.457 E.01277
M204 S10000
G1 X179.457 Y36.653 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X179.457 Y45.841 E.06517
; COOLING_NODE: 8
; WIPE_START
G1 F15000
G1 X179.457 Y43.841 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X174.763 Y37.823 Z1.8 F60000
G1 X173.697 Y36.457 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.697 Y46.037 E.29136
G1 X173.217 Y46.037 E.0146
G1 X173.217 Y36.457 E.29136
G1 X173.637 Y36.457 E.01277
M204 S10000
G1 X173.457 Y36.653 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X173.457 Y45.841 E.06517
; OBJECT_ID: 1563
; COOLING_NODE: 9
; WIPE_START
G1 F15000
G1 X173.457 Y43.841 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S10000
G1 X177.467 Y50.335 Z1.8 F60000
G1 X179.247 Y53.217 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X179.247 Y62.797 E.29136
M73 P97 R0
G1 X178.767 Y62.797 E.0146
G1 X178.767 Y53.217 E.29136
G1 X179.187 Y53.217 E.01277
M204 S10000
G1 X179.007 Y53.413 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X179.007 Y62.601 E.06517
; COOLING_NODE: 8
; WIPE_START
G1 F15000
G1 X179.007 Y60.601 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X174.312 Y54.583 Z1.8 F60000
G1 X173.247 Y53.217 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.247 Y62.797 E.29136
G1 X172.767 Y62.797 E.0146
G1 X172.767 Y53.217 E.29136
G1 X173.187 Y53.217 E.01277
M204 S10000
G1 X173.007 Y53.413 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X173.007 Y62.601 E.06517
; WIPE_START
G1 F15000
G1 X173.007 Y60.601 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.217 J0 P1  F60000
; stop printing object, unique label id: 1563
M625
; object ids of layer 7 start: 1563,1747
M624 AwAAAAAAAAA=
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U173 V131 Z1.8 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; object ids of this layer7 end: 1563,1747
M625
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 8/10
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
; OBJECT_ID: 1747
; COOLING_NODE: 9
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
G1 X179.697 Y36.457 F60000
G1 Z1.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S5000
G1 X179.697 Y46.037 E.29136
G1 X179.217 Y46.037 E.0146
G1 X179.217 Y36.457 E.29136
G1 X179.637 Y36.457 E.01277
M204 S10000
G1 X179.457 Y36.653 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X179.457 Y45.841 E.06517
; COOLING_NODE: 8
; WIPE_START
G1 F15000
G1 X179.457 Y43.841 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X174.763 Y37.823 Z2 F60000
G1 X173.697 Y36.457 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.697 Y46.037 E.29136
G1 X173.217 Y46.037 E.0146
G1 X173.217 Y36.457 E.29136
G1 X173.637 Y36.457 E.01277
M204 S10000
G1 X173.457 Y36.653 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X173.457 Y45.841 E.06517
; OBJECT_ID: 1563
; COOLING_NODE: 9
; WIPE_START
G1 F15000
G1 X173.457 Y43.841 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S10000
G1 X177.467 Y50.335 Z2 F60000
G1 X179.247 Y53.217 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X179.247 Y62.797 E.29136
G1 X178.767 Y62.797 E.0146
G1 X178.767 Y53.217 E.29136
G1 X179.187 Y53.217 E.01277
M204 S10000
G1 X179.007 Y53.413 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X179.007 Y62.601 E.06517
; COOLING_NODE: 8
; WIPE_START
G1 F15000
G1 X179.007 Y60.601 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X174.312 Y54.583 Z2 F60000
G1 X173.247 Y53.217 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.247 Y62.797 E.29136
G1 X172.767 Y62.797 E.0146
G1 X172.767 Y53.217 E.29136
G1 X173.187 Y53.217 E.01277
M204 S10000
G1 X173.007 Y53.413 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X173.007 Y62.601 E.06517
; WIPE_START
G1 F15000
G1 X173.007 Y60.601 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I1.217 J0 P1  F60000
; stop printing object, unique label id: 1563
M625
; object ids of layer 8 start: 1563,1747
M624 AwAAAAAAAAA=
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U173 V131 Z2 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; object ids of this layer8 end: 1563,1747
M625
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 9/10
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
; OBJECT_ID: 1747
; COOLING_NODE: 9
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
G1 X179.697 Y36.457 F60000
G1 Z1.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.2
G1 F1200
M204 S5000
G1 X179.697 Y46.037 E.29136
G1 X179.217 Y46.037 E.0146
G1 X179.217 Y36.457 E.29136
G1 X179.637 Y36.457 E.01277
M204 S10000
G1 X179.457 Y36.653 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
M73 P98 R0
G1 X179.457 Y45.841 E.06517
; COOLING_NODE: 8
; WIPE_START
G1 F15000
G1 X179.457 Y43.841 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X174.763 Y37.823 Z2.2 F60000
G1 X173.697 Y36.457 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.697 Y46.037 E.29136
G1 X173.217 Y46.037 E.0146
G1 X173.217 Y36.457 E.29136
G1 X173.637 Y36.457 E.01277
M204 S10000
G1 X173.457 Y36.653 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X173.457 Y45.841 E.06517
; OBJECT_ID: 1563
; COOLING_NODE: 9
; WIPE_START
G1 F15000
G1 X173.457 Y43.841 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S10000
G1 X177.467 Y50.335 Z2.2 F60000
G1 X179.247 Y53.217 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X179.247 Y62.797 E.29136
G1 X178.767 Y62.797 E.0146
G1 X178.767 Y53.217 E.29136
G1 X179.187 Y53.217 E.01277
M204 S10000
G1 X179.007 Y53.413 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X179.007 Y62.601 E.06517
; COOLING_NODE: 8
; WIPE_START
G1 F15000
G1 X179.007 Y60.601 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X174.312 Y54.583 Z2.2 F60000
G1 X173.247 Y53.217 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.247 Y62.797 E.29136
G1 X172.767 Y62.797 E.0146
G1 X172.767 Y53.217 E.29136
G1 X173.187 Y53.217 E.01277
M204 S10000
G1 X173.007 Y53.413 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X173.007 Y62.601 E.06517
; WIPE_START
G1 F15000
G1 X173.007 Y60.601 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I1.217 J0 P1  F60000
; stop printing object, unique label id: 1563
M625
; object ids of layer 9 start: 1563,1747
M624 AwAAAAAAAAA=
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U173 V131 Z2.2 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; object ids of this layer9 end: 1563,1747
M625
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 10/10
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
; OBJECT_ID: 1747
; COOLING_NODE: 9
; start printing object, unique label id: 1747
M624 AgAAAAAAAAA=
G1 X179.697 Y36.457 F60000
G1 Z2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X179.697 Y46.037 E.29136
G1 X179.217 Y46.037 E.0146
G1 X179.217 Y36.457 E.29136
G1 X179.637 Y36.457 E.01277
M204 S10000
G1 X179.457 Y36.653 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X179.457 Y45.841 E.06517
; COOLING_NODE: 8
; WIPE_START
G1 F15000
G1 X179.457 Y43.841 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X174.763 Y37.823 Z2.4 F60000
G1 X173.697 Y36.457 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.697 Y46.037 E.29136
G1 X173.217 Y46.037 E.0146
G1 X173.217 Y36.457 E.29136
G1 X173.637 Y36.457 E.01277
M204 S10000
G1 X173.457 Y36.653 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X173.457 Y45.841 E.06517
; OBJECT_ID: 1563
; COOLING_NODE: 9
; WIPE_START
G1 F15000
G1 X173.457 Y43.841 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 1747
M625
; start printing object, unique label id: 1563
M624 AQAAAAAAAAA=
M204 S10000
G1 X177.467 Y50.335 Z2.4 F60000
G1 X179.247 Y53.217 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X179.247 Y62.797 E.29136
G1 X178.767 Y62.797 E.0146
G1 X178.767 Y53.217 E.29136
G1 X179.187 Y53.217 E.01277
M204 S10000
G1 X179.007 Y53.413 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X179.007 Y62.601 E.06517
; COOLING_NODE: 8
; WIPE_START
G1 F15000
G1 X179.007 Y60.601 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X174.312 Y54.583 Z2.4 F60000
G1 X173.247 Y53.217 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X173.247 Y62.797 E.29136
G1 X172.767 Y62.797 E.0146
G1 X172.767 Y53.217 E.29136
G1 X173.187 Y53.217 E.01277
M204 S10000
M73 P99 R0
G1 X173.007 Y53.413 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13086
G1 F1200
M204 S8000
G1 X173.007 Y62.601 E.06517
; WIPE_START
G1 F15000
G1 X173.007 Y60.601 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I1.217 J0 P1  F60000
; stop printing object, unique label id: 1563
M625
; object ids of layer 10 start: 1563,1747
M624 AwAAAAAAAAA=
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U173 V131 Z2.4 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; object ids of this layer10 end: 1563,1747
M625
; close powerlost recovery
M1003 S0
M106 S0
M106 P2 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; MACHINE_END_GCODE_START
; filament end gcode 
;===== machine: H2C end =====
;====== date: 20260313 ======

G392 S0 ;turn off nozzle clog detect
M993 A0 B0 C0 ; nozzle cam detection not allowed.

M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
M211 Z1
M640.2 R0

G90
G1 Z2.4 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z12 F900 ; lower z a little

G90
M141 S0 ; turn off chamber heating
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan
M106 P9 S0 ; turn off ext toodhead cooling fan

; pull back filament to AMS
M620 S65535

M620.11 P1 I3 B-1 E-14 F299.339



M620.11 K1 I3 B-1 R10 F299.339


M620.11 P1 I3 B-1 E-14
T65535
G150.2
M621 S65535

M620 S65279
T65279
G150.2
M621 S65279

G150.3

M104 S0 T0; turn off hotend
M104 S0 T1; turn off hotend

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom

    
        G1 Z101 F600
        G1 Z99
    

M400 P100
M17 R ; restore z current

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

M1015.4 S0 K0 ;disable air printing detect


;=====printer finish air purification=========
M622.1 S0
M1002 judge_flag print_finish_air_filt_flag

M622 J1
M1002 gcode_claim_action : 66
M145 P1
M106 P6 S255
M400 S180
M106 P6 S0
M623

M622 J2
M1002 gcode_claim_action : 66
M145 P0
M106 P3 S127
M400 S180
M106 P3 S0
M623
;=====printer finish air purification=========

;=====printer finish  sound=========
M17
M400 S1
M1006 S1
M1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 
M1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 
M1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A48 B10 L99 C48 D10 M99 E48 F10 N99 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A60 B10 L99 C60 D10 M99 E60 F10 N99 
M1006 W
;=====printer finish  sound=========
M400
M18

M73 P100 R0
; EXECUTABLE_BLOCK_END

