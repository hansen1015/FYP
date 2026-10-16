; HEADER_BLOCK_START
; BambuStudio 02.06.00.51
; model printing time: 10m 8s; total estimated time: 15m 16s
; total layer number: 14
; total filament length [mm] : 517.07,40.45,67.37
; total filament volume [cm^3] : 1243.69,97.28,162.05
; total filament weight [g] : 1.57,0.12,0.20
; filament_density: 1.26,1.26,1.25
; filament_diameter: 1.75,1.75,1.75
; max_z_height: 2.80
; filament: 1,2,3
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0,0,0
; additional_cooling_fan_speed = 75,40,75
; additional_fan_full_speed_layer = 0,0,0
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
; chamber_temperatures = 0,0,0
; change_filament_gcode = ;======== H2C filament_change ========\n;===== 20260409 =====\nM993 A2 B2 C2 ; nozzle cam detection allow status save.\nM993 A0 B0 C0 ; nozzle cam detection not allowed.\n\n{if (filament_type[next_extruder] == "PLA") ||  (filament_type[next_extruder] == "PETG")\n ||  (filament_type[next_extruder] == "PLA-CF")  ||  (filament_type[next_extruder] == "PETG-CF")}\nM1015.4 S1 K0 ;disable E air printing detect\n{else}\nM1015.4 S0 ; disable E air printing detect\n{endif}\n\nM620 O{toolchange_count + 1}\nM620 S[next_extruder]A H[next_hotend]\nM1002 gcode_claim_action : 4\nM204 S9000\n\nG1 Z{max_layer_z + 3.0} F1200\n\nM400\nM106 P1 S0\nM106 P2 S0\n\n{if toolchange_count == 2}\n; get travel path for change filament\n;M620.1 X[travel_point_1_x] Y[travel_point_1_y] F21000 P0\n;M620.1 X[travel_point_2_x] Y[travel_point_2_y] F21000 P1\n;M620.1 X[travel_point_3_x] Y[travel_point_3_y] F21000 P2\n{endif}\n\n{if wipe_tower_center_pos_valid}\n    M620.14 X[wipe_tower_center_pos_x] Y[wipe_tower_center_pos_y]\n{else}\n    M620.14 X95.5 Y336\n{endif}\n\n{if ((filament_type[current_extruder] == "PLA") || (filament_type[current_extruder] == "PLA-CF") || (filament_type[current_extruder] == "PETG")) && (nozzle_diameter[current_extruder] == 0.2)}\nM620.10 A0 F74.8347 L[flush_length] H{nozzle_diameter[current_extruder]} T{flush_temperatures[current_extruder]} P[old_filament_temp] S1\n{else}\nM620.10 A0 F{flush_volumetric_speeds[current_extruder]/2.4053*60*0.8} L[flush_length] H{nozzle_diameter[current_extruder]} T{flush_temperatures[current_extruder]} P[old_filament_temp] S1\n{endif}\n\n{if ((filament_type[next_extruder] == "PLA") || (filament_type[next_extruder] == "PLA-CF") || (filament_type[next_extruder] == "PETG")) && (nozzle_diameter[next_extruder] == 0.2)}\nM620.10 A1 F74.8347 L[flush_length] H{nozzle_diameter[next_extruder]} T{flush_temperatures[next_extruder]} P[new_filament_temp] S1\n{else}\nM620.10 A1 F{flush_volumetric_speeds[next_extruder]/2.4053*60*0.8} L[flush_length] H{nozzle_diameter[next_extruder]} T{flush_temperatures[next_extruder]} P[new_filament_temp] S1\n{endif}\n\n{if long_retraction_when_cut}\nM620.11 P1 I[current_extruder] B[current_hotend] E-{retraction_distance_when_cut} F{max((flush_volumetric_speeds[current_extruder]/2.4053*60), 200)}\n{else}\nM620.11 P0 I[current_extruder] B[current_hotend] E0\n{endif}\n\n\nM620.15 P[filament_pre_cooling_temperature_nc[next_extruder]]\nM620.15 C{new_filament_temp - filament_cooling_before_tower[next_extruder]}\nM620.11 O1 T[filament_retract_length_nc]\n\n{if long_retraction_when_ec}\nM620.11 K1 I[current_extruder] B[current_hotend] R{retraction_distance_when_ec} F{max((flush_volumetric_speeds[current_extruder]/2.4053*60), 200)}\n{else}\nM620.11 K0 I[current_extruder] B[current_hotend] R0\n{endif}\n\nM620.15 C{new_filament_temp - filament_cooling_before_tower[next_extruder]}\n\nM628 S1\n{if filament_type[current_extruder] == "TPU"}\nM620.11 S0 L0 I[current_extruder] B[current_hotend] E-{retraction_distances_when_cut[current_extruder]} F{max((flush_volumetric_speeds[current_extruder]/2.4053*60), 200)}\n{else}\n{if (filament_type[current_extruder] == "PA") || (filament_type[current_extruder] == "PA-GF")}\nM620.11 S1 L0 I[current_extruder] B[current_hotend] R4 D2 E-{retraction_distances_when_cut[current_extruder]} F{max((flush_volumetric_speeds[current_extruder]/2.4053*60), 200)}\n{else}\nM620.11 S1 L0 I[current_extruder] B[current_hotend] R10 D8 E-{retraction_distances_when_cut[current_extruder]} F{max((flush_volumetric_speeds[current_extruder]/2.4053*60), 200)}\n{endif}\n{endif}\nM629\n\n{if (filament_type[current_extruder] == "TPU" || filament_type[next_extruder] == "TPU") && (old_extruder_variant != "Direct Drive TPU High Flow")}\n;M620.11 H2 C331 TODO:add区分左右顶料\n{else}\n;M620.11 H0\n{endif}\n\n{if filament_type[next_extruder] == "TPU" }\n;ct:{filament_type[current_extruder]} nt:{filament_type[next_extruder]} \n;debug log pe:{previous_extruder} ce:{current_extruder} ne:{next_extruder} oev: {old_extruder_variant} nev:{new_extruder_variant}\n;debug fm-curr:{filament_map[current_extruder]} fm-next:{filament_map[next_extruder]}\n;sw from R2L&TPU kit, travel run a distance for sketch TPU\nG1 X30 Y30 F5000\nM400\nG1 X300 Y30 F5000\nM400\n{endif}\n\nT[next_extruder] H[next_hotend]\n\n;deretract\n{if filament_type[next_extruder] == "TPU"}\n{else}\n{if (filament_type[next_extruder] == "PA") || (filament_type[next_extruder] == "PA-GF")}\n;VG1 E1 F{max(new_filament_e_feedrate, 200)}\n;VG1 E1 F{max(new_filament_e_feedrate/2, 100)}\n{else}\n;VG1 E4 F{max(new_filament_e_feedrate, 200)}\n;VG1 E4 F{max(new_filament_e_feedrate/2, 100)}\n{endif}\n{endif}\n\n; VFLUSH_START\n\n{if flush_length>41.5}\n;VG1 E41.5 F{min(old_filament_e_feedrate,new_filament_e_feedrate)}\n;VG1 E{flush_length-41.5} F{new_filament_e_feedrate}\n{else}\n;VG1 E{flush_length} F{min(old_filament_e_feedrate,new_filament_e_feedrate)}\n{endif}\n\nSYNC T{ceil(flush_length / 125) * 5}\n\n; compensate for heating and cooling\n{if flush_length > 0}\n{if flush_temperatures[next_extruder] > new_filament_temp}\nSYNC T{(flush_temperatures[next_extruder]-(new_filament_temp - filament_cooling_before_tower[next_extruder]))/hotend_cooling_rate[filament_map[next_extruder]-1]}\nSYNC T{(flush_temperatures[next_extruder]-(new_filament_temp - filament_cooling_before_tower[next_extruder]))/hotend_heating_rate[filament_map[next_extruder]-1]}\n{else}\nSYNC T{(new_filament_temp - filament_cooling_before_tower[next_extruder] -flush_temperatures[next_extruder])/hotend_cooling_rate[filament_map[next_extruder]-1]}\nSYNC T{(new_filament_temp - filament_cooling_before_tower[next_extruder] -flush_temperatures[next_extruder])/hotend_heating_rate[filament_map[next_extruder]-1]}\n{endif}\n{endif}\n\n; VFLUSH_END\n\nM1002 set_filament_type:{filament_type[next_extruder]}\n\nM400\nM83\n{if next_extruder < 255}\n\n\nM620.10 R{new_extruder_retracted_length}\n\n{if (print_sequence == "by object" && !has_wipe_tower)}\nM628 S0 F1 L10.0\n; VFLUSH_START\n;VG1 E10 F[new_filament_e_feedrate]\n; VFLUSH_END\n{else}\nM628 S0\n{endif}\n;VM109 S[new_filament_temp]\n\nM629\nM400\n\n;prime_tower_interface\n{if is_prime_tower_interface && filament_tower_interface_purge_volume !=0}\nG150.1\nM620.13 W0 L{filament_tower_interface_purge_volume} T{filament_tower_interface_print_temp} R0.0\n{endif}\n;prime_tower_interface\n\nM983.3 F{filament_max_volumetric_speed[next_extruder]/2.4} A0.4 R{new_extruder_retracted_length}\n\n\nM400\n{if wipe_avoid_perimeter}\nG387 Y320 J1 F10000\nG1 X{wipe_avoid_pos_x} F30000\n{endif}\nG387 Y295 J1 F30000\nG387 Y265 J1 F18000\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\nM621 S[next_extruder]A\n\nM622.1 S0 ;for prev version, default skip\nM1002 judge_flag powerloss_resume_flag\nM622 J1\nM983.3 F{filament_max_volumetric_speed[next_extruder]/2.4} A0.4 R{new_extruder_retracted_length}\nM400\n{if wipe_avoid_perimeter}\nG387 Y320 J1 F10000\nG1 X{wipe_avoid_pos_x} F30000\n{endif}\nG387 Y295 J1 F30000\nG387 Y265 J1 F18000\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\nM1002 set_flag powerloss_resume_flag=0\nM623\n\nM993 A3 B3 C3 ; nozzle cam detection allow status restore.\n\n{if (filament_type[next_extruder]  == "TPU")}\nM1015.3 S1;enable tpu clog detect\n{else}\nM1015.3 S0;disable tpu clog detect\n{endif}\n\n{if (filament_type[next_extruder] == "PLA") ||  (filament_type[next_extruder] == "PETG")\n ||  (filament_type[next_extruder] == "PLA-CF")  ||  (filament_type[next_extruder] == "PETG-CF")}\nM1015.4 S1 K1 H[nozzle_diameter] ;enable E air printing detect\n{else}\nM1015.4 S0 ; disable E air printing detect\n{endif}\n\nM620.6 I[next_extruder] H[next_hotend] W1 ;enable ams air printing detect\nM620 O{toolchange_count + 1}\nM1002 gcode_claim_action : 0
; circle_compensation_manual_offset = 0
; circle_compensation_speed = 200,200,200
; close_additional_fan_first_x_layers = 1,1,1
; close_fan_the_first_x_layers = 1,1,1
; complete_print_exhaust_fan_speed = 70,70,70
; cool_plate_temp = 35,35,35
; cool_plate_temp_initial_layer = 35,35,35
; cooling_filter_enabled = 0
; cooling_perimeter_transition_distance = 10,10,10
; cooling_slowdown_logic = uniform_cooling,uniform_cooling,uniform_cooling
; counter_coef_1 = 0,0,0
; counter_coef_2 = 0.0025,0.0025,0.008
; counter_coef_3 = 0.014,0.014,-0.041
; counter_limit_max = 0.076,0.076,0.033
; counter_limit_min = 0.014,0.014,-0.035
; curr_bed_type = Textured PEI Plate
; default_acceleration = 25,8000
; default_filament_colour = ;;
; default_filament_profile = "Bambu PLA Basic @BBL H2C"
; default_jerk = 0
; default_nozzle_volume_type = Standard,Standard
; default_print_profile = 0.20mm Standard @BBL H2C
; deretraction_speed = 30,30
; detect_floating_vertical_shell = 1
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; diameter_limit = 50,50,50
; different_settings_to_system = bridge_speed;default_acceleration;enable_overhang_speed;enable_support_ironing;gap_infill_speed;initial_layer_acceleration;initial_layer_infill_speed;initial_layer_speed;initial_layer_travel_acceleration;inner_wall_speed;internal_solid_infill_speed;outer_wall_acceleration;outer_wall_speed;skeleton_infill_density;skin_infill_density;small_perimeter_threshold;sparse_infill_density;sparse_infill_pattern;sparse_infill_speed;support_interface_speed;support_speed;top_surface_acceleration;top_surface_speed;travel_acceleration;travel_short_distance_acceleration;travel_speed;;additional_cooling_fan_speed;fan_max_speed;fan_min_speed;filament_change_length;filament_change_length_nc;filament_retract_restart_extra;filament_retract_when_changing_layer;filament_retraction_minimum_travel;filament_start_gcode;nozzle_temperature;nozzle_temperature_initial_layer;nozzle_temperature_range_high;nozzle_temperature_range_low;nozzle_temperature;nozzle_temperature_initial_layer;
; draft_shield = disabled
; during_print_exhaust_fan_speed = 70,70,70
; elefant_foot_compensation = 0.15
; embedding_wall_into_infill = 0
; enable_arc_fitting = 1
; enable_circle_compensation = 0
; enable_filament_dynamic_map = 0
; enable_height_slowdown = 0,0
; enable_long_retraction_when_cut = 2
; enable_mixed_color_sublayer = 0
; enable_overhang_bridge_fan = 1,1,1
; enable_overhang_speed = 0,1
; enable_pre_heating = 1
; enable_pressure_advance = 0,0,0
; enable_prime_tower = 1
; enable_support = 0
; enable_support_ironing = 1
; enable_tower_interface_features = 1
; enable_wrapping_detection = 0
; enforce_support_layers = 0
; eng_plate_temp = 55,55,55
; eng_plate_temp_initial_layer = 55,55,55
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
; fan_cooling_layer_time = 100,100,100
; fan_direction = left
; fan_max_speed = 80,40,100
; fan_min_speed = 60,20,100
; filament_adaptive_volumetric_speed = 0,0,0
; filament_adhesiveness_category = 100,100,100
; filament_bridge_speed = 25,25,25
; filament_change_length = 4,2,4
; filament_change_length_nc = 4,2,4
; filament_colour = #FFFFFF;#AA6443;#43403D
; filament_colour_type = 0;1;1
; filament_cooling_before_tower = 10,10,10
; filament_cost = 24.99,24.99,29.99
; filament_density = 1.26,1.26,1.25
; filament_dev_ams_drying_ams_limitations = 1;0;1;0;1;0
; filament_dev_ams_drying_heat_distortion_temperature = 45,45,45
; filament_dev_ams_drying_temperature = 45,45,45,45,45,45,45,45,45,45,45,45
; filament_dev_ams_drying_time = 12,12,12,12,12,12,12,12,12,12,12,12
; filament_dev_chamber_drying_bed_temperature = 70,70,70
; filament_dev_chamber_drying_time = 12,12,12
; filament_dev_drying_cooling_temperature = 45,45,45
; filament_dev_drying_softening_temperature = 50,50,50
; filament_diameter = 1.75,1.75,1.75
; filament_enable_overhang_speed = 1,1,1
; filament_end_gcode = "; filament end gcode \n";"; filament end gcode \n";"; filament end gcode \n"
; filament_extruder_compatibility = 0,0,0
; filament_extruder_variant = "Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard"
; filament_flow_ratio = 0.99,0.99,1
; filament_flush_temp = 0,0,0
; filament_flush_volumetric_speed = 0,0,0
; filament_ids = GFA00;GFA00;GFA02
; filament_is_mixed = 0,0,0
; filament_is_support = 0,0,0
; filament_map = 2,1,2
; filament_map_2 = 1,0,1
; filament_map_mode = Manual
; filament_max_volumetric_speed = 25,25,21
; filament_metal_stickiness = None,None,None
; filament_minimal_purge_on_wipe_tower = 15,15,15
; filament_mixed_components = ;;
; filament_mixed_gradient = 0,0,0
; filament_mixed_gradient_range = ;;
; filament_mixed_sublayer_ratios = ;;
; filament_multi_colour = #FFFFFF;#AA6443;#43403D
; filament_notes = 
; filament_nozzle_map = 2,0,1
; filament_overhang_1_4_speed = 0,0,0
; filament_overhang_2_4_speed = 50,50,50
; filament_overhang_3_4_speed = 30,30,30
; filament_overhang_4_4_speed = 10,10,10
; filament_overhang_totally_speed = 10,10,10
; filament_pre_cooling_temperature = 0,0,0
; filament_pre_cooling_temperature_nc = 180,180,180
; filament_prime_volume = 30,30,30
; filament_prime_volume_nc = 30,30,30
; filament_printable = 3,3,3
; filament_ramming_travel_time = 0,0,0
; filament_ramming_travel_time_nc = 1,1,1
; filament_ramming_volumetric_speed = -1,-1,-1
; filament_ramming_volumetric_speed_nc = -1,-1,-1
; filament_retract_length_nc = 18,18,18
; filament_retract_restart_extra = nil,0.2,nil
; filament_retract_when_changing_layer = nil,0,nil
; filament_retraction_length = 0.4,0.4,0.4
; filament_retraction_minimum_travel = nil,3,nil
; filament_scarf_gap = 0%,0%,15%
; filament_scarf_height = 10%,10%,10%
; filament_scarf_length = 10,10,10
; filament_scarf_seam_type = none,none,none
; filament_self_index = 1,2,3
; filament_settings_id = "Bambu PLA Basic @BBL H2C";"Multi3D Copper filament 0.4mm@BBL H2C";"Protopasta CPLA @BBL H2C 0.4 nozzle"
; filament_shrink = 100%,100%,100%
; filament_soluble = 0,0,0
; filament_start_gcode = "; filament start gcode\n";"; filament start gcode\nM109 S145;\n";"; filament start gcode\n"
; filament_tower_interface_pre_extrusion_dist = 10,10,10
; filament_tower_interface_pre_extrusion_length = 0,0,0
; filament_tower_interface_print_temp = -1,-1,-1
; filament_tower_interface_purge_volume = 20,20,20
; filament_tower_ironing_area = 4,4,4
; filament_type = PLA;PLA;PLA
; filament_velocity_adaptation_factor = 1,1,1
; filament_vendor = "Bambu Lab";"Bambu Lab";"Bambu Lab"
; filament_volume_map = 0,0,0
; filament_wipe = 1,1,1
; filament_wipe_distance = 1,1,1
; filament_z_hop_types = Spiral Lift,Spiral Lift,Spiral Lift
; filename_format = {input_filename_base}_{filament_type[0]}_{print_time}.gcode
; fill_multiline = 1
; filter_out_gap_fill = 0
; first_layer_print_sequence = 0
; first_x_layer_fan_speed = 0,0,0
; first_x_layer_part_fan_speed = 0,0,0
; flush_into_infill = 0
; flush_into_objects = 0
; flush_into_support = 1
; flush_multiplier = 1,1
; flush_volumes_matrix = 0,216,158,513,0,192,555,337,0,0,231,173,528,0,207,570,352,0
; flush_volumes_vector = 140,140,140,140,140,140
; full_fan_speed_layer = 0,0,0
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
; hole_coef_1 = 0,0,0
; hole_coef_2 = -0.0028,-0.0028,-0.008
; hole_coef_3 = 0.12,0.12,0.23415
; hole_limit_max = 0.12,0.12,0.22
; hole_limit_min = 0.05,0.05,0.088
; host_type = octoprint
; hot_plate_temp = 55,55,55
; hot_plate_temp_initial_layer = 55,55,55
; hotend_cooling_rate = 1.6,3.4
; hotend_heating_rate = 3.5,13.3
; impact_strength_z = 13.8,13.8,16.8
; independent_support_layer_height = 0
; infill_combination = 0
; infill_direction = 45
; infill_instead_top_bottom_surfaces = 0
; infill_jerk = 9
; infill_lock_depth = 1
; infill_rotate_step = 0
; infill_shift_step = 0.4
; infill_wall_overlap = 15%
; inherits_group = ;;"Bambu PLA Basic @BBL H2C";"Bambu PLA Metal @BBL H2C 0.4 nozzle";
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
; ironing_fan_speed = -1,-1,-1
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
; long_retractions_when_ec = 1,1,1
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
; machine_start_gcode = ;===== machine: H2C =========================\n;===== date: 20260421 =====================\n\n;M1002 set_flag extrude_cali_flag=1\n;M1002 set_flag g29_before_print_flag=1\n;M1002 set_flag auto_cali_toolhead_offset_flag=1\n;M1002 set_flag build_plate_detect_flag=1\n\nM993 A0 B0 C0 ; nozzle cam detection not allowed.\n\nM400\n;M73 P99\n\nM960 S10 P1 ; ext fan led\n\n;=====printer start sound ===================\nM17\nM400 S1\nM1006 S1\nM1006 A53 B9 L99 C53 D9 M99 E53 F9 N99 \nM1006 A56 B9 L99 C56 D9 M99 E56 F9 N99 \nM1006 A61 B9 L99 C61 D9 M99 E61 F9 N99 \nM1006 A53 B9 L99 C53 D9 M99 E53 F9 N99 \nM1006 A56 B9 L99 C56 D9 M99 E56 F9 N99 \nM1006 A61 B18 L99 C61 D18 M99 E61 F18 N99 \nM1006 W\n;=====printer start sound ===================\n\n;===== reset machine status =================\nM204 S10000\nM630 S0 P0\n\nG90\nM17 D ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM1002 set_gcode_claim_speed_level 5 ;Reset speed level\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\nG29.1 Z{+0.0} ; clear z-trim value first\nM983.1 M1 \nM901 D4\nM481 S0 ; turn off cutter pos comp\nG28.140 D0; reset pre-extrude z pos\n;===== reset machine status =================\n\nM620 M ;enable remap\nM620 N ;enable hotend remap\nM620 T0 ;print tmpr\nM620 T1 ;sn -> pos\nM620 T2 ;filament_id\n\n;===== start to heat heatbed & hotend==========\n\n    M104 O-80 A\n    M140 D[bed_temperature_initial_layer_single]\n\n;===== start to heat heatbead & hotend==========\n\n;===== avoid end stop =================\nG91\nG380 S2 Z42 F1200\nG380 S2 Z-12 F1200\nG90\n;===== avoid end stop =================\n\n;==== set airduct mode ==== \n\n{if (overall_chamber_temperature >= 40)}\n\n    M145 P1 ; set airduct mode to heating mode for heating\n    M106 P2 S0 ; turn off auxiliary fan\n    M106 P3 S0 ; turn off chamber fan\n\n{else}\n    M145 P0 ; set airduct mode to cooling mode for cooling\n    M106 P2 S178 ; turn on auxiliary fan for cooling\n    M106 P3 S127 ; turn on chamber fan for cooling\n\n    M1002 gcode_claim_action : 29\n    M191 S0 ; wait for chamber temp\n    M106 P2 S0 ; turn off auxiliary fan\n    {if (min_vitrification_temperature <= 50)}\n        {if (nozzle_diameter == 0.2)}\n            M142 P1 R30 S35 T40 U0.3 V0.5 W0.8 O40 ; set PLA/TPU ND0.2 chamber autocooling\n        {else}\n            M142 P1 R30 S40 T45 U0.3 V0.5 W0.8 O45; set PLA/TPU ND0.4 chamber autocooling\n        {endif}\n    {else}\n        {if (!is_all_bbl_filament)}\n            M142 P1 R35 S40 T45 U0.3 V0.5 W0.8 O45 L1 ; set third-party PETG chamber autocooling\n        {else}\n            {if (nozzle_diameter == 0.2)}\n                M142 P1 R35 S45 T50 U0.3 V0.5 W0.8 O50 L1 ; set PETG ND0.2 chamber autocooling\n            {else}\n                M142 P1 R35 S50 T55 U0.3 V0.5 W0.8 O55 L1 ; set PETG ND0.4 chamber autocooling\n            {endif}\n        {endif}\n    {endif}\n{if(cooling_filter_enabled)}\nM145.2 P0 F0\n{else}\nM145.2 P0 F1\n{endif}\n{endif}\n;==== set airduct mode ==== \n\n\n;====== cog noise reduction=================\nM982.2 S1 ; turn on cog noise reduction\n\n;===== first homing start =====\nM1002 gcode_claim_action : 13\n\nM640 S\nM640.1 R\nM641\nG28 X T300\nT1000\n\nG150.3\nM972 S24 P0 T2000 ; live-view camera foolproof\nM972 S46 P0 T5000 ; vortek anti-collision\nM640.1 S\nM640.4\n{if (first_non_support_filaments[0] != -1)}\nM640 S\nM640.8 T A{first_non_support_filaments[0]} H{first_non_support_hotend[0]}\nM640.7 L\nM641\n{endif}\n\n\n{if wipe_tower_center_pos_valid}\n    M620.14 X[wipe_tower_center_pos_x] Y[wipe_tower_center_pos_y]\n{else}\n    M620.14 X95.5 Y336\n{endif}\n\n\nG150.1 F18000 ; wipe mouth to avoid filament stick to heatbed\nG150.3 F18000\nM400 P200\n\nM1002 gcode_claim_action : 74 ; Heatbed surface foreign object detection\nM104 S0\n{if curr_bed_type=="Textured PEI Plate"}\nM972 S26 P0 C0\n{else}\nM972 S36 P0 C0 X1\n{endif}\nM972 S35 P0 C0\n\nM972 S41 P0 T5000 ; trash can anti-collision\n\nM1009 Q1 L1\nG91\nG380 S2 Z30 F1200 ; lower heatbed to move toolhead\nG90\nG1 X175 Y160 F30000\nG28 Z P0 T250\nM1009 Q1 L0\n\n\n;===== first homing end =====\n\n;===== detection start =====\n    \nM1002 judge_flag build_plate_detect_flag\nM104 S0\nM622 S1\n    ;M1002 gcode_claim_action : 11 ; Indentifying build plate type\n    M972 S19 P0 C0    ; heatbed presence detection\n    M972 S31 P0 T5000 ; toolhead camera dirty detection\n    ;M1002 gcode_claim_action : 73 ; Build plate alignment detection\n    M972 S34 P0 T5000 ; heatbed plate offset detection\nM623\n\nM1002 gcode_claim_action : 72 ; Hotend Type Detection\nT1001\nM972 S14 P0 T5000 ; nozzle type detection\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]} T{filament_map[initial_no_support_extruder] % 2} ; rise temp in advance\n\nG151 P{filament_map[initial_no_support_extruder] % 2} M ; plug the heat nozzle\n\n{if max_print_z >= 145}\nM1002 gcode_claim_action : 75 ; Heatbed underside foreign object detection\nG3811 Z{max_print_z}  ; Detect obstacles at the bottom of the heated bed\n{endif}\n\n;===== detection end =====\n\nM400\n;M73 P99\n\n;===== prepare print temperature and material ==========\nM400\nM211 X0 Y0 Z0 ;turn off soft endstop\nM975 S1 ; turn on input shaping\n\nG29.2 S0 ; avoid invalid abl data\n\n{if ((filament_type[initial_no_support_extruder] == "PLA") || (filament_type[initial_no_support_extruder] == "PLA-CF") || (filament_type[initial_no_support_extruder] == "PETG")) && (nozzle_diameter[initial_no_support_extruder] == 0.2)}\nM620.10 A0 F74.8347 H{nozzle_diameter[initial_no_support_extruder]} T{flush_temperatures[initial_no_support_extruder]} P{nozzle_temperature_initial_layer[initial_no_support_extruder]} S1\nM620.10 A1 F74.8347 H{nozzle_diameter[initial_no_support_extruder]} T{flush_temperatures[initial_no_support_extruder]} P{nozzle_temperature_initial_layer[initial_no_support_extruder]} S1\n{else}\nM620.10 A0 F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60*0.8} H{nozzle_diameter[initial_no_support_extruder]} T{flush_temperatures[initial_no_support_extruder]} P{nozzle_temperature_initial_layer[initial_no_support_extruder]} S1\nM620.10 A1 F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60*0.8} H{nozzle_diameter[initial_no_support_extruder]} T{flush_temperatures[initial_no_support_extruder]} P{nozzle_temperature_initial_layer[initial_no_support_extruder]} S1\n{endif}\n\nM620.11 P1 I[initial_no_support_extruder] B[initial_no_support_hotend] E0\n\n{if long_retraction_when_ec }\nM620.11 K1 I[initial_no_support_extruder] B[initial_no_support_hotend] R{retraction_distance_when_ec} F{max((flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60), 200)}\n{else}\nM620.11 K0 I[initial_no_support_extruder] B[initial_no_support_hotend] R0\n{endif}\n\nM628 S1\n{if filament_type[initial_no_support_extruder] == "TPU"}\n    M620.11 S0 L0 I[initial_no_support_extruder] B[initial_no_support_hotend] E-{retraction_distances_when_cut[initial_no_support_extruder]} F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60}\n{else}\n{if (filament_type[initial_no_support_extruder] == "PA") ||  (filament_type[initial_no_support_extruder] == "PA-GF")}\n    M620.11 S1 L0 I[initial_no_support_extruder] B[initial_no_support_hotend] R4 D2 E-{retraction_distances_when_cut[initial_no_support_extruder]} F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60}\n{else}\n    M620.11 S1 L0 I[initial_no_support_extruder] B[initial_no_support_hotend] R10 D8 E-{retraction_distances_when_cut[initial_no_support_extruder]} F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60}\n{endif}\n{endif}\nM629\n\nM620 S[initial_no_support_extruder]A H[initial_no_support_hotend] ; switch material if AMS exist\nM1002 gcode_claim_action : 4\nM1002 set_filament_type:UNKNOWN\nM400\nT[initial_no_support_extruder] H[initial_no_support_hotend]\nM400\nM628 S0\nM629\nM400\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM621 S[initial_no_support_extruder]A\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\nM400\nM106 P1 S0\n\nG91\nG1 Y-16 F60000\nG90\n\nG29.2 S1\n;===== prepare print temperature and material ==========\n\n\nM400\n;M73 P99\n\n;===== xy ofst cali start =====\n\nM1002 judge_flag auto_cali_toolhead_offset_flag\n\nM622 J2\n    M1002 gcode_claim_action : 54\n    M190 D[bed_temperature_initial_layer_single]\n    \n    M1002 gcode_claim_action : 39\n    M620 D[initial_no_support_hotend]\n    G383.3 U140 L{initial_no_support_extruder}\nM623\n\nM622 J1\n    M1002 gcode_claim_action : 54\n    M190 D[bed_temperature_initial_layer_single]\n\n    M1002 gcode_claim_action : 39\n    M620 D[initial_no_support_hotend]\n    G383 O2 U140 L{initial_no_support_extruder}\nM623\n\n;===== xy ofst cali end =====\n\n;===== start to heat heatbed & hotend==========\n\n    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}\n    G150.3\n    M104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\n    M140 S[bed_temperature_initial_layer_single]\n\n    ;===== set chamber temperature ==========\n    {if (overall_chamber_temperature >= 40)}\n        M145 P1 ; set airduct mode to heating mode\n        M141 S[overall_chamber_temperature] ; Let Chamber begin to heat\n    {endif}\n    ;===== set chamber temperature ==========\n\n;===== start to heat heatbead & hotend==========\n\n\n\nM400\n;M73 P99\n\n;===== auto extrude cali start =========================\nM975 S1\nM1002 judge_flag extrude_cali_flag\n\nM622 J0\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4} A0.4 ; cali dynamic extrusion compensation\nM623\n\nM622 J1\n    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_no_support_extruder]}\n\n    G90\n    M83\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4} A0.4 ; cali dynamic extrusion compensation\n\n    M400\n    M106 P1 S255\n    M400 S5\n    M106 P1 S0\n    G150.3\nM623\n\nM622 J2\n    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_no_support_extruder]}\n\n    G90\n    M83\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4} A0.4 ; cali dynamic extrusion compensation\n\n    M400\n    M106 P1 S255\n    M400 S5\n    M106 P1 S0\n    G150.3\nM623\n\n;===== auto extrude cali end =========================\n\n{if filament_type[initial_no_support_extruder] == "TPU"}\n    G150.2\n    G150.1\n    G150.2\n    G150.1\n    G150.2\n    G150.1\n{else}\n    G150.3\n    M106 P1 S0\n    M400 S2\n    M109 S{nozzle_temperature[initial_no_support_extruder]} ; wait tmpr to extrude\n    M83\n    {if(nozzle_diameter == 0.8)}\n        G1 E60 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60}\n    {else}\n        G1 E45 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60}\n    {endif}\n    G1 E-3 F1800\n    M400 P500\n    G150.2\n    G150.1\n{endif}\n\nG91\nG1 Y-16 F12000 ; move away from the trash bin\nG90\n\nM400\n;M73 P99\n\n;===== wipe right nozzle start =====\n\nM1002 gcode_claim_action : 14\n    G150 T{nozzle_temperature_initial_layer[initial_no_support_extruder]}\n    {if (overall_chamber_temperature >= 40)}\n        G150 T{nozzle_temperature_initial_layer[initial_no_support_extruder] - 80}\n    {endif}\nM106 S255 ; turn on fan to cool the nozzle\n\n;===== wipe left nozzle end =====\n\nM400\n;M73 P99\n\nM1002 judge_flag auto_cali_toolhead_offset_flag\nM622 J0\n    G91\n    G1 Z5 F1200\n    G90\n    M1012.7\n    G383.7 U140 J0\nM623\n\n{if (overall_chamber_temperature >= 40)}\n    M1002 gcode_claim_action : 49\n    M191 S[overall_chamber_temperature] ; wait for chamber temp\n{endif}\n\nM400\n;M73 P99\n\n;===== bed leveling ==================================\n\nM1002 judge_flag g29_before_print_flag\n\nM190 S[bed_temperature_initial_layer_single]; ensure bed temp\nM109 S140 A\nM106 S0 ; turn off fan , too noisy\n\nG91\nG1 Z10 F1200\n{if (first_non_support_filaments[0] != -1)}\nM640 S\nM83\nG1 E-3 F1500\nM640.7 U\nM640.7 L\nM640.2 R1\nM641\n{endif}\nG90\nG1 X175 Y160 F30000\n\nM622 J1\n    M1002 gcode_claim_action : 1\n    G29.20 A3\n    G29 A1 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]} R \n    M400\nM623\n    \nM622 J2\n    M1002 gcode_claim_action : 1\n    {if has_tpu_in_first_layer}\n        G29.20 A3\n        G29 A1 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]} R\n    {else}\n        G29.20 A4\n        G29 A2 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]} R\n    {endif}\n    M400\nM623\n\nM622 J0\n    G28 R\nM623\n\n;===== bed leveling end ================================\n\nG39.1 ; cali nozzle wrapped detection pos\n\nG90\nG1 Z5 F1200\nG1 X270 Y-0.5 F60000\nG28.140 S0 ; cali pre-extrude z pos\n\n;============switch again==================\nM620 O1\nM211 X0 Y0 Z0 ;turn off soft endstop\nG91\nG1 Z6 F1200\nG90\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM620 S[initial_no_support_extruder]A H[initial_no_support_hotend]\nM400\nT[initial_no_support_extruder] H[initial_no_support_hotend]\nM400\nM628 S0\nM629\nM400\nM621 S[initial_no_support_extruder]A\n\n;============switch again==================\n\nM400\n;M73 P99\n\nM141 S[overall_chamber_temperature]\n\n;===== mech mode sweep start =====\n    M1002 gcode_claim_action : 3\n\n    G90\n    G1 Z5 F1200\n    G1 X165 Y160 F20000\n    M400 P200\n\n    M970.3 Q1 A5 K0 O1\n    M974 Q1 S2 P0\n\n    M970.3 Q0 A5 K0 O1\n    M974 Q0 S2 P0\n\n    M970.2 Q2 K0 W38 Z0.01\n    M974 Q2 S2 P0\n\n    M975 S1\n;===== mech mode sweep end =====\n\n;===== wait temperature reaching the reference value =======\n\nM140 S[bed_temperature_initial_layer_single] \nM190 S[bed_temperature_initial_layer_single] \n\n    ;========turn off light and fans =============\n    M960 S1 P0 ; turn off laser\n    M960 S2 P0 ; turn off laser\n    M106 S0 ; turn off fan\n    M106 P2 S0 ; turn off big fan\n    ;==== set ext toodhead cooling fan ==== \n    {if (min_vitrification_temperature <= 50)}\n    M106 P9 S255\n    {endif}\n    ;============set motor current==================\n    M400 S1\n\n;===== wait temperature reaching the reference value =======\n\nM400\n;M73 P99\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n    {if curr_bed_type=="Textured PEI Plate"}\n        {if nozzle_diameter[initial_no_support_extruder] == 0.2}\n            G29.1 Z{-0.01} ; for Textured PEI Plate\n        {else}\n            G29.1 Z{-0.02} ; for Textured PEI Plate\n        {endif}\n    {else}\n        {if nozzle_diameter[initial_no_support_extruder] == 0.2}\n            G29.1 Z{0.01} ; for Textured PEI Plate\n        {endif}\n    {endif}\nG150.1\n\nM975 S1 ; turn on mech mode supression\nM983.4 S1 ; turn on deformation compensation \nG29.2 S1 ; turn on pos comp\nG29.7 S1\n\nG90\nG1 Z5 F1200\nG1 Y295 F30000\nG1 Y265 F18000\n\n;===== nozzle load line ===============================\n    G29.2 S1 ; ensure z comp turn on\n    G90\n    M83\n    G1 Z5 F1200\n    G1 X270 Y-0.5 F60000\n    G28.14 R0\n    G29.2 S0\n    G91\n    G1 Z0.8 F1200\n    G90\n    G1 X250 F60000\n    M104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\n    \n    ========== record data ==========\n    M1026\n    M1012.8\n    M1012.9\n    G29.9\n    ========== record data ==========\n    \n    M400 P50\n    M500 D1\n    M400 S3\n    M109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\n    M83\n{if nozzle_diameter[initial_no_support_extruder] == 0.8}\n    G1 E5 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60}\n{endif}\n{if (filament_type[initial_no_support_extruder] == "TPU")}\n    G1 E5 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60}\n{endif}\n    G1 E5 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60}\n    G1 X290 E10 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60}\n    G91\n    G3 Z0.4 I1.217 J0 P1 F60000\n    G90\n    M83\n    G29.2 S1 ; ensure z comp turn on\n;===== noozle load line end ===========================\n\nM400\n;M73 P99\n\nM993 A1 B1 C1 ; nozzle cam detection allowed.\n\n{if (filament_type[initial_no_support_extruder] == "TPU")}\nM1015.3 S1;enable tpu clog detect\n{else}\nM1015.3 S0;disable tpu clog detect\n{endif}\n\n{if (filament_type[initial_no_support_extruder] == "PLA") ||  (filament_type[initial_no_support_extruder] == "PETG")\n ||  (filament_type[initial_no_support_extruder] == "PLA-CF")  ||  (filament_type[initial_no_support_extruder] == "PETG-CF")}\nM1015.4 S1 K1 H[nozzle_diameter] ;enable E air printing detect\n{else}\nM1015.4 S0 K0 H[nozzle_diameter] ;disable E air printing detect\n{endif}\n\nM620.6 I[initial_no_support_extruder] H[initial_no_support_hotend] W1 ;enable ams air printing detect\n\nM211 Z1\nG29.99\nM1002 gcode_claim_action : 0\nM400\n
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
; no_slow_down_for_cooling_on_outwalls = 0,0,0
; nozzle_diameter = 0.4,0.4
; nozzle_flush_dataset = 1,1
; nozzle_height = 4
; nozzle_temperature = 220,150,230
; nozzle_temperature_initial_layer = 220,150,230
; nozzle_temperature_range_high = 240,180,240
; nozzle_temperature_range_low = 190,140,190
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
; overhang_fan_speed = 100,100,100
; overhang_fan_threshold = 50%,50%,50%
; overhang_threshold_participating_cooling = 95%,95%,95%
; overhang_totally_speed = 10,10
; override_filament_scarf_seam_setting = 0
; override_process_overhang_speed = 0,0,0
; physical_extruder_map = 1,0
; post_process = 
; pre_start_fan_time = 2,2,2
; precise_outer_wall = 0
; precise_z_height = 0
; pressure_advance = 0.02,0.02,0.02
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
; printer_settings_id = Bambu Lab H2C 0.4 nozzle
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
; reduce_fan_stop_start_freq = 1,1,1
; reduce_infill_retraction_mode = Auto
; required_nozzle_HRC = 3,3,3
; resolution = 0.012
; retract_before_wipe = 0%,0%
; retract_length_toolchange = 2,2
; retract_lift_above = 0,0
; retract_lift_below = 319,319
; retract_restart_extra = 0,0
; retract_restart_extra_toolchange = 0,0
; retract_when_changing_layer = 1,1
; retraction_distances_when_cut = 14,14
; retraction_distances_when_ec = 10,10,10
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
; slow_down_for_layer_cooling = 1,1,1
; slow_down_layer_time = 4,4,4
; slow_down_min_speed = 20,20,20
; slowdown_end_acc = 100000,100000
; slowdown_end_height = 400,400
; slowdown_end_speed = 1000,1000
; slowdown_start_acc = 100000,100000
; slowdown_start_height = 0,0
; slowdown_start_speed = 1000,1000
; small_perimeter_speed = 50%,50%
; small_perimeter_threshold = 0,10
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
; supertack_plate_temp = 40,40,40
; supertack_plate_temp_initial_layer = 40,40,40
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
; temperature_vitrification = 45,45,45
; template_custom_gcode = 
; textured_plate_temp = 55,55,55
; textured_plate_temp_initial_layer = 55,55,55
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
; travel_speed = 10,1000
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
; volumetric_speed_coefficients = "0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0"
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
; wipe_tower_x = 165,40,40,135.746,40,140.428,165
; wipe_tower_y = 250,200,200,150.855,200,62.841,250
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
M73 P0 R15
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
    M140 D55

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
M640.8 T A0 H-1
M640.7 L
M641




    M620.14 X169.213 Y165.922



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

M104 S220 T0 ; rise temp in advance

G151 P0 M ; plug the heat nozzle



;===== detection end =====

M400
;M73 P99

;===== prepare print temperature and material ==========
M400
M211 X0 Y0 Z0 ;turn off soft endstop
M975 S1 ; turn on input shaping

G29.2 S0 ; avoid invalid abl data


M620.10 A0 F498.898 H0.4 T240 P220 S1
M620.10 A1 F498.898 H0.4 T240 P220 S1


M620.11 P1 I0 B-1 E0


M620.11 K1 I0 B-1 R10 F623.623


M628 S1


    M620.11 S1 L0 I0 B-1 R10 D8 E-14 F623.623


M629

M620 S0A H-1 ; switch material if AMS exist
M1002 gcode_claim_action : 4
M1002 set_filament_type:UNKNOWN
M400
T0 H-1
M400
M628 S0
M629
M400
M1002 set_filament_type:PLA
M621 S0A

M104 S220
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
    M190 D55
    
    M1002 gcode_claim_action : 39
    M620 D-1
    G383.3 U140 L0
M623

M622 J1
    M1002 gcode_claim_action : 54
    M190 D55

    M1002 gcode_claim_action : 39
    M620 D-1
    G383 O2 U140 L0
M623

;===== xy ofst cali end =====

;===== start to heat heatbed & hotend==========

    M1002 set_filament_type:PLA
    G150.3
    M104 S220
    M140 S55

    ;===== set chamber temperature ==========
    
    ;===== set chamber temperature ==========

;===== start to heat heatbead & hotend==========



M400
;M73 P99

;===== auto extrude cali start =========================
M975 S1
M1002 judge_flag extrude_cali_flag

M622 J0
    M983.3 F10.4167 A0.4 ; cali dynamic extrusion compensation
M623

M622 J1
    M1002 set_filament_type:PLA
    M1002 gcode_claim_action : 8

    M109 S220

    G90
    M83
    M983.3 F10.4167 A0.4 ; cali dynamic extrusion compensation

    M400
    M106 P1 S255
    M400 S5
    M106 P1 S0
    G150.3
M623

M622 J2
    M1002 set_filament_type:PLA
    M1002 gcode_claim_action : 8

    M109 S220

    G90
    M83
    M983.3 F10.4167 A0.4 ; cali dynamic extrusion compensation

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
    M109 S220 ; wait tmpr to extrude
    M83
    
        G1 E45 F623.623
    
M73 P1 R14
    G1 E-3 F1800
    M400 P500
    G150.2
    G150.1


G91
M73 P3 R14
G1 Y-16 F12000 ; move away from the trash bin
G90

M400
;M73 P99

;===== wipe right nozzle start =====

M1002 gcode_claim_action : 14
    G150 T220
    
M106 S255 ; turn on fan to cool the nozzle

;===== wipe left nozzle end =====

M400
;M73 P99

M1002 judge_flag auto_cali_toolhead_offset_flag
M622 J0
    G91
    G1 Z5 F1200
    G90
    M1012.7
    G383.7 U140 J0
M623



M400
;M73 P99

;===== bed leveling ==================================

M1002 judge_flag g29_before_print_flag

M190 S55; ensure bed temp
M109 S140 A
M106 S0 ; turn off fan , too noisy

G91
G1 Z10 F1200

M640 S
M83
M73 P32 R10
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
    G29 A1 O X132.499 Y102.397 I43.8734 J78.604 R 
    M400
M623
    
M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X132.499 Y102.397 I43.8734 J78.604 R
    
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
M1002 set_filament_type:PLA
M620 S0A H-1
M400
T0 H-1
M400
M628 S0
M629
M400
M621 S0A

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

M140 S55 
M190 S55 

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
    M104 S220
    
    ========== record data ==========
    M1026
    M1012.8
    M1012.9
    G29.9
    ========== record data ==========
    
    M400 P50
    M500 D1
    M400 S3
    M109 S220
    M83


    G1 E5 F623.623
    G1 X290 E10 F623.623
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



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I0 H-1 W1 ;enable ams air printing detect

M211 Z1
G29.99
M1002 gcode_claim_action : 0
M400
; MACHINE_START_GCODE_END
M400
M104 T1 S25 N0 ;Multi extruder pre cooling
; filament start gcode
;VT0 H-1
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
M204 S10000
G1 Z.6 F60000
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
M73 P33 R10
G1 E-.4 F1800
; layer num/total_layer_count: 1/14
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
M106 P2 S0
M204 S6000
G1 Z1 F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U244 V110 Z0.6 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

G1 X164.711 Y177.922
M204 S6000
G1 Z.2
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S500
G1  X138.211 Y177.922  E1.0072 F3000
G1  Y153.422  E0.9312
G1  X164.711  E1.0072
G1  Y177.922  E0.9312
M204 S6000
G1  X139.211 Y153.422  
;--------------------
; CP EMPTY GRID START
; layer #2
M204 S500
G1  Y153.922  E0.0190
G1  X164.211  E0.9502
G1  Y154.422  E0.0190
G1  X138.711  E0.9692
G1  Y154.922  E0.0190
G1  X164.211  E0.9692
G1  Y155.422  E0.0190
M73 P34 R10
G1  X138.711  E0.9692
G1  Y155.922  E0.0190
G1  X164.211  E0.9692
G1  Y156.422  E0.0190
G1  X138.711  E0.9692
G1  Y156.922  E0.0190
G1  X164.211  E0.9692
G1  Y157.422  E0.0190
G1  X138.711  E0.9692
G1  Y157.922  E0.0190
G1  X164.211  E0.9692
G1  Y158.422  E0.0190
G1  X138.711  E0.9692
G1  Y158.922  E0.0190
G1  X164.211  E0.9692
G1  Y159.422  E0.0190
M73 P34 R9
G1  X138.711  E0.9692
G1  Y159.922  E0.0190
G1  X164.211  E0.9692
G1  Y160.422  E0.0190
G1  X138.711  E0.9692
G1  Y160.922  E0.0190
G1  X164.211  E0.9692
G1  Y161.422  E0.0190
G1  X138.711  E0.9692
G1  Y161.922  E0.0190
G1  X164.211  E0.9692
G1  Y162.422  E0.0190
G1  X138.711  E0.9692
G1  Y162.922  E0.0190
M73 P35 R9
G1  X164.211  E0.9692
G1  Y163.422  E0.0190
G1  X138.711  E0.9692
G1  Y163.922  E0.0190
G1  X164.211  E0.9692
G1  Y164.422  E0.0190
G1  X138.711  E0.9692
G1  Y164.922  E0.0190
G1  X164.211  E0.9692
G1  Y165.422  E0.0190
G1  X138.711  E0.9692
G1  Y165.922  E0.0190
G1  X164.211  E0.9692
G1  Y166.422  E0.0190
G1  X138.711  E0.9692
G1  Y166.922  E0.0190
G1  X164.211  E0.9692
G1  Y167.422  E0.0190
G1  X138.711  E0.9692
G1  Y167.922  E0.0190
G1  X164.211  E0.9692
G1  Y168.422  E0.0190
G1  X138.711  E0.9692
G1  Y168.922  E0.0190
G1  X164.211  E0.9692
G1  Y169.422  E0.0190
G1  X138.711  E0.9692
G1  Y169.922  E0.0190
G1  X164.211  E0.9692
G1  Y170.422  E0.0190
M73 P36 R9
G1  X138.711  E0.9692
G1  Y170.922  E0.0190
G1  X164.211  E0.9692
G1  Y171.422  E0.0190
G1  X138.711  E0.9692
G1  Y171.922  E0.0190
G1  X164.211  E0.9692
G1  Y172.422  E0.0190
G1  X138.711  E0.9692
G1  Y172.922  E0.0190
G1  X164.211  E0.9692
G1  Y173.422  E0.0190
G1  X138.711  E0.9692
G1  Y173.922  E0.0190
G1  X164.211  E0.9692
G1  Y174.422  E0.0190
G1  X138.711  E0.9692
G1  Y174.922  E0.0190
G1  X164.211  E0.9692
G1  Y175.422  E0.0190
G1  X138.711  E0.9692
G1  Y175.922  E0.0190
G1  X164.211  E0.9692
G1  Y176.422  E0.0190
G1  X138.711  E0.9692
G1  Y176.922  E0.0190
G1  X164.211  E0.9692
G1  Y177.422  E0.0190
G1  X138.711  E0.9692
M73 P37 R9
G1  Y177.922  E0.0190
; CP EMPTY GRID END
;------------------






M204 S6000
G1  X139.085 Y180.375  
M204 S500
G3  X136.023 Y177.104   I16.406 J-18.427 E0.1705
G3  X136.857 Y174.149   I2.026 J-1.023 E0.1282
G2  X137.711 Y171.616   I-3.390 J-2.554 E0.1033
G2  X137.708 Y160.058   I-283.960 J-5.694 E0.4393
G2  X135.865 Y156.493   I-6.625 J1.166 E0.1549
G3  X136.200 Y154.520   I1.652 J-0.734 E0.0806
G3  X139.318 Y151.258   I19.448 J15.469 E0.1717
G3  X142.516 Y151.916   I1.278 J1.891 E0.1383
G2  X145.533 Y152.922   I3.023 J-4.037 E0.1230
G2  X157.579 Y152.918   I5.928 J-318.375 E0.4578
G2  X161.526 Y151.036   I-0.501 J-6.129 E0.1699
G3  X162.596 Y150.854   I0.865 J1.848 E0.0418
G3  X163.837 Y151.469   I-0.224 J2.011 E0.0537
G3  X166.899 Y154.740   I-16.399 J18.421 E0.1705
G3  X166.065 Y157.695   I-2.026 J1.023 E0.1282
G2  X165.211 Y160.228   I3.390 J2.554 E0.1033
G2  X165.214 Y171.786   I283.960 J5.694 E0.4393
G2  X167.057 Y175.351   I6.625 J-1.166 E0.1549
G3  X166.722 Y177.324   I-1.652 J0.734 E0.0806
G1  X165.211 Y178.922   E0.0836
G3  X162.752 Y180.967   I-4.377 J-2.762 E0.1236
G3  X160.093 Y179.711   I0.009 J-3.462 E0.1154
G2  X157.389 Y178.922   I-2.710 J4.259 E0.1085
G2  X145.343 Y178.926   I-5.928 J318.375 E0.4578
G2  X141.396 Y180.808   I0.501 J6.129 E0.1699
G3  X139.085 Y180.375   I-0.852 J-1.839 E0.0953
; WIPE_TOWER_END

; WIPE_START
G1 F48000
M204 S500
G1 X139.197 Y180.486 E-.05968
G1 X139.318 Y180.586 E-.05967
G1 X139.446 Y180.677 E-.05968
G1 X139.58 Y180.758 E-.05967
G1 X139.721 Y180.827 E-.05967
G1 X139.867 Y180.886 E-.05968
G1 X139.922 Y180.903 E-.02195
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.217 J0 P1  F60000
; OBJECT_ID: 671
M204 S6000
G1 X133.356 Y103.254
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
; LAYER_HEIGHT: 0.2
G1 F3000
M204 S500
G1 X175.515 Y103.254 E1.58629
G1 X175.515 Y111.54 E.31177
G1 X133.356 Y111.54 E1.58629
G1 X133.356 Y103.314 E.30951
M204 S6000
G1 X132.899 Y102.797 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X175.972 Y102.797 E1.62069
G1 X175.972 Y111.997 E.34616
G1 X132.899 Y111.997 E1.62069
G1 X132.899 Y102.857 E.3439
; WIPE_START
G1 X133.899 Y102.856 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I-.017 J1.217 P1  F60000
G1 X174.407 Y103.437 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50029
M73 P38 R9
G1 F6300
M204 S500
G1 X175.126 Y104.156 E.03828
G1 X175.126 Y104.803 E.02435
G1 X173.966 Y103.643 E.06177
G1 X173.32 Y103.643 E.02435
G1 X175.126 Y105.449 E.09621
G1 X175.126 Y106.096 E.02435
G1 X172.673 Y103.643 E.13065
G1 X172.026 Y103.643 E.02435
G1 X175.126 Y106.743 E.16509
G1 X175.126 Y107.39 E.02435
G1 X171.379 Y103.643 E.19953
G1 X170.732 Y103.643 E.02435
G1 X175.126 Y108.037 E.23397
G1 X175.126 Y108.684 E.02435
G1 X170.085 Y103.643 E.26841
G1 X169.439 Y103.643 E.02435
G1 X175.126 Y109.33 E.30285
G1 X175.126 Y109.977 E.02435
G1 X168.792 Y103.643 E.33729
G1 X168.145 Y103.643 E.02435
G1 X175.126 Y110.624 E.37173
G1 X175.126 Y111.151 E.01986
G1 X175.007 Y111.151 E.00449
G1 X167.498 Y103.643 E.39981
G1 X166.851 Y103.643 E.02435
G1 X174.36 Y111.151 E.39981
G1 X173.713 Y111.151 E.02435
G1 X166.204 Y103.643 E.39981
G1 X165.558 Y103.643 E.02435
G1 X173.067 Y111.151 E.39981
G1 X172.42 Y111.151 E.02435
G1 X164.911 Y103.643 E.39981
G1 X164.264 Y103.643 E.02435
G1 X171.773 Y111.151 E.39981
G1 X171.126 Y111.151 E.02435
G1 X163.617 Y103.643 E.39981
G1 X162.97 Y103.643 E.02435
G1 X170.479 Y111.151 E.39981
G1 X169.832 Y111.151 E.02435
G1 X162.324 Y103.643 E.39981
G1 X161.677 Y103.643 E.02435
G1 X169.186 Y111.151 E.39981
G1 X168.539 Y111.151 E.02435
G1 X161.03 Y103.643 E.39981
G1 X160.383 Y103.643 E.02435
G1 X167.892 Y111.151 E.39981
G1 X167.245 Y111.151 E.02435
G1 X159.736 Y103.643 E.39981
G1 X159.089 Y103.643 E.02435
G1 X166.598 Y111.151 E.39981
G1 X165.952 Y111.151 E.02435
G1 X158.443 Y103.643 E.39981
G1 X157.796 Y103.643 E.02435
G1 X165.305 Y111.151 E.39981
G1 X164.658 Y111.151 E.02435
G1 X157.149 Y103.643 E.39981
G1 X156.502 Y103.643 E.02435
G1 X164.011 Y111.151 E.39981
G1 X163.364 Y111.151 E.02435
G1 X155.855 Y103.643 E.39981
G1 X155.209 Y103.643 E.02435
G1 X162.717 Y111.151 E.39981
G1 X162.071 Y111.151 E.02435
G1 X154.562 Y103.643 E.39981
G1 X153.915 Y103.643 E.02435
G1 X161.424 Y111.151 E.39981
G1 X160.777 Y111.151 E.02435
G1 X153.268 Y103.643 E.39981
G1 X152.621 Y103.643 E.02435
M73 P39 R9
G1 X160.13 Y111.151 E.39981
G1 X159.483 Y111.151 E.02435
G1 X151.974 Y103.643 E.39981
G1 X151.328 Y103.643 E.02435
G1 X158.837 Y111.151 E.39981
G1 X158.19 Y111.151 E.02435
G1 X150.681 Y103.643 E.39981
G1 X150.034 Y103.643 E.02435
G1 X157.543 Y111.151 E.39981
G1 X156.896 Y111.151 E.02435
G1 X149.387 Y103.643 E.39981
G1 X148.74 Y103.643 E.02435
G1 X156.249 Y111.151 E.39981
G1 X155.602 Y111.151 E.02435
G1 X148.094 Y103.643 E.39981
G1 X147.447 Y103.643 E.02435
G1 X154.956 Y111.151 E.39981
G1 X154.309 Y111.151 E.02435
G1 X146.8 Y103.643 E.39981
G1 X146.153 Y103.643 E.02435
G1 X153.662 Y111.151 E.39981
G1 X153.015 Y111.151 E.02435
G1 X145.506 Y103.643 E.39981
G1 X144.859 Y103.643 E.02435
G1 X152.368 Y111.151 E.39981
G1 X151.722 Y111.151 E.02435
G1 X144.213 Y103.643 E.39981
G1 X143.566 Y103.643 E.02435
G1 X151.075 Y111.151 E.39981
G1 X150.428 Y111.151 E.02435
G1 X142.919 Y103.643 E.39981
G1 X142.272 Y103.643 E.02435
G1 X149.781 Y111.151 E.39981
G1 X149.134 Y111.151 E.02435
G1 X141.625 Y103.643 E.39981
G1 X140.979 Y103.643 E.02435
G1 X148.487 Y111.151 E.39981
G1 X147.841 Y111.151 E.02435
G1 X140.332 Y103.643 E.39981
G1 X139.685 Y103.643 E.02435
G1 X147.194 Y111.151 E.39981
G1 X146.547 Y111.151 E.02435
G1 X139.038 Y103.643 E.39981
G1 X138.391 Y103.643 E.02435
G1 X145.9 Y111.151 E.39981
G1 X145.253 Y111.151 E.02435
G1 X137.744 Y103.643 E.39981
G1 X137.098 Y103.643 E.02435
G1 X144.606 Y111.151 E.39981
G1 X143.96 Y111.151 E.02435
G1 X136.451 Y103.643 E.39981
G1 X135.804 Y103.643 E.02435
G1 X143.313 Y111.151 E.39981
G1 X142.666 Y111.151 E.02435
G1 X135.157 Y103.643 E.39981
G1 X134.51 Y103.643 E.02435
G1 X142.019 Y111.151 E.39981
G1 X141.372 Y111.151 E.02435
G1 X133.864 Y103.643 E.39981
G1 X133.744 Y103.643 E.0045
M73 P40 R9
G1 X133.744 Y104.17 E.01986
G1 X140.726 Y111.151 E.37173
G1 X140.079 Y111.151 E.02435
G1 X133.744 Y104.817 E.33729
G1 X133.744 Y105.464 E.02435
G1 X139.432 Y111.151 E.30285
G1 X138.785 Y111.151 E.02435
G1 X133.744 Y106.11 E.26841
G1 X133.744 Y106.757 E.02435
G1 X138.138 Y111.151 E.23397
G1 X137.491 Y111.151 E.02435
G1 X133.744 Y107.404 E.19953
G1 X133.744 Y108.051 E.02435
G1 X136.845 Y111.151 E.16509
G1 X136.198 Y111.151 E.02435
G1 X133.744 Y108.698 E.13065
G1 X133.744 Y109.345 E.02435
G1 X135.551 Y111.151 E.09621
G1 X134.904 Y111.151 E.02435
G1 X133.744 Y109.991 E.06177
G1 X133.744 Y110.638 E.02435
G1 X134.463 Y111.357 E.03828
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X133.756 Y110.65 E-.38
; WIPE_END
G1 E-.02 F1800
; layer num/total_layer_count: 2/14
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
M106 S198.9
M106 P2 S191
; open powerlost recovery
M1003 S1
M204 S10000
G17
G3 Z.6 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U244 V110 Z0.8 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

M204 S10000
G1 X164.711 Y177.922
G1 Z.4
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S8000
G1  X138.211 Y177.922  E1.0072 F5400
G1  Y153.422  E0.9312
G1  X164.711  E1.0072
G1  Y177.922  E0.9312
M204 S10000
G1  X139.211 Y153.422  
;--------------------
; CP EMPTY GRID START
; layer #3
M204 S8000
G1  Y177.922  E0.9312
M204 S10000
G1  X147.378 
M204 S8000
G1  Y153.422  E0.9312
M204 S10000
G1  X155.544 
M204 S8000
G1  Y177.922  E0.9312
M204 S10000
G1  X163.711 
M204 S8000
G1  Y153.422  E0.9312
; CP EMPTY GRID END
;------------------






M204 S10000
G1  X163.837 Y151.469  
M204 S8000
G3  X166.899 Y154.740   I-16.399 J18.421 E0.1705
G3  X166.065 Y157.695   I-2.026 J1.023 E0.1282
G2  X165.211 Y160.228   I3.390 J2.554 E0.1033
G2  X165.214 Y171.786   I283.960 J5.694 E0.4393
G2  X167.057 Y175.351   I6.625 J-1.166 E0.1549
G3  X166.722 Y177.324   I-1.652 J0.734 E0.0806
G1  X165.211 Y178.922   E0.0836
G3  X162.752 Y180.967   I-4.377 J-2.762 E0.1236
G3  X160.093 Y179.711   I0.009 J-3.462 E0.1154
G2  X157.389 Y178.922   I-2.710 J4.259 E0.1085
G2  X145.343 Y178.926   I-5.928 J318.375 E0.4578
G2  X141.396 Y180.808   I0.501 J6.129 E0.1699
G3  X139.085 Y180.375   I-0.852 J-1.839 E0.0953
G3  X136.023 Y177.104   I16.406 J-18.427 E0.1705
G3  X136.857 Y174.149   I2.026 J-1.023 E0.1282
G2  X137.711 Y171.616   I-3.390 J-2.554 E0.1033
G2  X137.708 Y160.058   I-283.960 J-5.694 E0.4393
G2  X135.865 Y156.493   I-6.625 J1.166 E0.1549
G3  X136.200 Y154.520   I1.652 J-0.734 E0.0806
G3  X139.318 Y151.258   I19.448 J15.469 E0.1717
G3  X142.516 Y151.916   I1.278 J1.891 E0.1383
G2  X145.533 Y152.922   I3.023 J-4.037 E0.1230
G2  X157.579 Y152.918   I5.928 J-318.375 E0.4578
G2  X161.526 Y151.036   I-0.501 J-6.129 E0.1699
G3  X162.596 Y150.854   I0.865 J1.848 E0.0418
G3  X163.837 Y151.469   I-0.224 J2.011 E0.0537
; WIPE_TOWER_END

; WIPE_START
G1 F6300
M204 S8000
G1 X163.724 Y151.359 E-.05967
G1 X163.604 Y151.259 E-.05968
G1 X163.476 Y151.168 E-.05968
G1 X163.341 Y151.087 E-.05967
G1 X163.2 Y151.018 E-.05967
G1 X163.054 Y150.959 E-.05967
G1 X162.999 Y150.942 E-.02196
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.217 J0 P1  F60000
; OBJECT_ID: 671
M204 S10000
G1 X133.101 Y102.999
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F18000
M204 S8000
G1 X175.77 Y102.999 E1.42986
G1 X175.77 Y111.795 E.29475
G1 X133.101 Y111.795 E1.42986
G1 X133.101 Y103.059 E.29274
M204 S250
G1 X132.709 Y102.607 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X176.162 Y102.607 E1.34883
G1 X176.162 Y112.187 E.29737
G1 X132.709 Y112.187 E1.34883
G1 X132.709 Y102.667 E.29551
; WIPE_START
M204 S8000
G1 X133.709 Y102.666 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-1.021 J.662 P1  F60000
G1 X134.031 Y103.163 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42167
G1 F15000
M204 S8000
G1 X133.434 Y103.76 E.02632
G1 X133.434 Y104.295 E.0167
G1 X134.397 Y103.332 E.04246
G1 X134.933 Y103.332 E.0167
G1 X133.434 Y104.831 E.06608
G1 X133.434 Y105.367 E.0167
G1 X135.468 Y103.332 E.0897
G1 X136.004 Y103.332 E.0167
G1 X133.434 Y105.902 E.11331
G1 X133.434 Y106.438 E.0167
M73 P41 R9
G1 X136.539 Y103.332 E.13693
G1 X137.075 Y103.332 E.0167
G1 X133.434 Y106.973 E.16055
G1 X133.434 Y107.509 E.0167
G1 X137.611 Y103.332 E.18417
G1 X138.146 Y103.332 E.0167
G1 X133.434 Y108.045 E.20778
G1 X133.434 Y108.58 E.0167
G1 X138.682 Y103.332 E.2314
G1 X139.218 Y103.332 E.0167
G1 X133.434 Y109.116 E.25502
G1 X133.434 Y109.652 E.0167
G1 X139.753 Y103.332 E.27864
G1 X140.289 Y103.332 E.0167
G1 X133.434 Y110.187 E.30225
G1 X133.434 Y110.723 E.0167
G1 X140.824 Y103.332 E.32587
G1 X141.36 Y103.332 E.0167
G1 X133.434 Y111.259 E.34949
G1 X133.434 Y111.462 E.00633
G1 X133.766 Y111.462 E.01037
G1 X141.896 Y103.332 E.35845
G1 X142.431 Y103.332 E.0167
G1 X134.302 Y111.462 E.35845
G1 X134.838 Y111.462 E.0167
G1 X142.967 Y103.332 E.35845
G1 X143.503 Y103.332 E.0167
G1 X135.373 Y111.462 E.35845
G1 X135.909 Y111.462 E.0167
M73 P41 R8
G1 X144.038 Y103.332 E.35845
G1 X144.574 Y103.332 E.0167
G1 X136.445 Y111.462 E.35845
G1 X136.98 Y111.462 E.0167
G1 X145.11 Y103.332 E.35845
G1 X145.645 Y103.332 E.0167
G1 X137.516 Y111.462 E.35845
G1 X138.051 Y111.462 E.0167
G1 X146.181 Y103.332 E.35845
G1 X146.716 Y103.332 E.0167
G1 X138.587 Y111.462 E.35845
G1 X139.123 Y111.462 E.0167
G1 X147.252 Y103.332 E.35845
G1 X147.788 Y103.332 E.0167
G1 X139.658 Y111.462 E.35845
G1 X140.194 Y111.462 E.0167
G1 X148.323 Y103.332 E.35845
G1 X148.859 Y103.332 E.0167
G1 X140.73 Y111.462 E.35845
G1 X141.265 Y111.462 E.0167
G1 X149.395 Y103.332 E.35845
G1 X149.93 Y103.332 E.0167
G1 X141.801 Y111.462 E.35845
G1 X142.337 Y111.462 E.0167
G1 X150.466 Y103.332 E.35845
G1 X151.002 Y103.332 E.0167
G1 X142.872 Y111.462 E.35845
G1 X143.408 Y111.462 E.0167
G1 X151.537 Y103.332 E.35845
G1 X152.073 Y103.332 E.0167
G1 X143.943 Y111.462 E.35845
G1 X144.479 Y111.462 E.0167
G1 X152.608 Y103.332 E.35845
G1 X153.144 Y103.332 E.0167
G1 X145.015 Y111.462 E.35845
G1 X145.55 Y111.462 E.0167
G1 X153.68 Y103.332 E.35845
G1 X154.215 Y103.332 E.0167
G1 X146.086 Y111.462 E.35845
G1 X146.622 Y111.462 E.0167
G1 X154.751 Y103.332 E.35845
G1 X155.287 Y103.332 E.0167
G1 X147.157 Y111.462 E.35845
G1 X147.693 Y111.462 E.0167
G1 X155.822 Y103.332 E.35845
G1 X156.358 Y103.332 E.0167
G1 X148.228 Y111.462 E.35845
G1 X148.764 Y111.462 E.0167
G1 X156.893 Y103.332 E.35845
G1 X157.429 Y103.332 E.0167
G1 X149.3 Y111.462 E.35845
G1 X149.835 Y111.462 E.0167
G1 X157.965 Y103.332 E.35845
G1 X158.5 Y103.332 E.0167
G1 X150.371 Y111.462 E.35845
G1 X150.907 Y111.462 E.0167
G1 X159.036 Y103.332 E.35845
G1 X159.572 Y103.332 E.0167
G1 X151.442 Y111.462 E.35845
G1 X151.978 Y111.462 E.0167
G1 X160.107 Y103.332 E.35845
G1 X160.643 Y103.332 E.0167
G1 X152.514 Y111.462 E.35845
G1 X153.049 Y111.462 E.0167
G1 X161.179 Y103.332 E.35845
G1 X161.714 Y103.332 E.0167
G1 X153.585 Y111.462 E.35845
G1 X154.12 Y111.462 E.0167
G1 X162.25 Y103.332 E.35845
G1 X162.785 Y103.332 E.0167
G1 X154.656 Y111.462 E.35845
G1 X155.192 Y111.462 E.0167
G1 X163.321 Y103.332 E.35845
G1 X163.857 Y103.332 E.0167
G1 X155.727 Y111.462 E.35845
G1 X156.263 Y111.462 E.0167
G1 X164.392 Y103.332 E.35845
G1 X164.928 Y103.332 E.0167
G1 X156.799 Y111.462 E.35845
G1 X157.334 Y111.462 E.0167
G1 X165.464 Y103.332 E.35845
G1 X165.999 Y103.332 E.0167
G1 X157.87 Y111.462 E.35845
G1 X158.406 Y111.462 E.0167
G1 X166.535 Y103.332 E.35845
G1 X167.071 Y103.332 E.0167
G1 X158.941 Y111.462 E.35845
G1 X159.477 Y111.462 E.0167
G1 X167.606 Y103.332 E.35845
G1 X168.142 Y103.332 E.0167
G1 X160.012 Y111.462 E.35845
G1 X160.548 Y111.462 E.0167
G1 X168.677 Y103.332 E.35845
G1 X169.213 Y103.332 E.0167
G1 X161.084 Y111.462 E.35845
G1 X161.619 Y111.462 E.0167
G1 X169.749 Y103.332 E.35845
G1 X170.284 Y103.332 E.0167
G1 X162.155 Y111.462 E.35845
G1 X162.691 Y111.462 E.0167
G1 X170.82 Y103.332 E.35845
G1 X171.356 Y103.332 E.0167
G1 X163.226 Y111.462 E.35845
G1 X163.762 Y111.462 E.0167
G1 X171.891 Y103.332 E.35845
G1 X172.427 Y103.332 E.0167
G1 X164.297 Y111.462 E.35845
G1 X164.833 Y111.462 E.0167
G1 X172.962 Y103.332 E.35845
G1 X173.498 Y103.332 E.0167
G1 X165.369 Y111.462 E.35845
G1 X165.904 Y111.462 E.0167
G1 X174.034 Y103.332 E.35845
G1 X174.569 Y103.332 E.0167
G1 X166.44 Y111.462 E.35845
G1 X166.976 Y111.462 E.0167
G1 X175.105 Y103.332 E.35845
G1 X175.437 Y103.332 E.01034
G1 X175.437 Y103.536 E.00636
G1 X167.511 Y111.462 E.34945
G1 X168.047 Y111.462 E.0167
G1 X175.437 Y104.072 E.32583
G1 X175.437 Y104.608 E.0167
G1 X168.583 Y111.462 E.30221
G1 X169.118 Y111.462 E.0167
G1 X175.437 Y105.143 E.2786
G1 X175.437 Y105.679 E.0167
G1 X169.654 Y111.462 E.25498
G1 X170.189 Y111.462 E.0167
G1 X175.437 Y106.215 E.23136
G1 X175.437 Y106.75 E.0167
G1 X170.725 Y111.462 E.20774
G1 X171.261 Y111.462 E.0167
G1 X175.437 Y107.286 E.18413
G1 X175.437 Y107.821 E.0167
G1 X171.796 Y111.462 E.16051
G1 X172.332 Y111.462 E.0167
G1 X175.437 Y108.357 E.13689
G1 X175.437 Y108.893 E.0167
G1 X172.868 Y111.462 E.11327
G1 X173.403 Y111.462 E.0167
G1 X175.437 Y109.428 E.08966
G1 X175.437 Y109.964 E.0167
G1 X173.939 Y111.462 E.06604
G1 X174.475 Y111.462 E.0167
G1 X175.437 Y110.5 E.04242
G1 X175.437 Y111.035 E.0167
G1 X174.84 Y111.631 E.02628
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X175.437 Y111.035 E-.32036
G1 X175.437 Y110.878 E-.05964
; WIPE_END
G1 E-.02 F1800
; layer num/total_layer_count: 3/14
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
M106 S193.8
; OBJECT_ID: 671
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.8 I.232 J-1.195 P1  F60000
G1 X157.537 Y107.397 Z.8
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X157.537 Y102.999 E.14738
G1 X175.77 Y102.999 E.61098
G1 X175.77 Y111.795 E.29475
G1 X157.537 Y111.795 E.61098
G1 X157.537 Y107.457 E.14537
; COOLING_NODE: 0
M204 S250
G1 X157.145 Y107.397 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X157.145 Y102.607 E.14869
G1 X176.162 Y102.607 E.59029
G1 X176.162 Y112.187 E.29737
G1 X157.145 Y112.187 E.59029
G1 X157.145 Y107.457 E.14682
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X157.145 Y106.457 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I-.194 J-1.201 P1  F60000
G1 X151.333 Y107.397 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X151.333 Y111.795 E.14738
G1 X133.101 Y111.795 E.61098
G1 X133.101 Y102.999 E.29475
G1 X151.333 Y102.999 E.61098
G1 X151.333 Y107.337 E.14537
; COOLING_NODE: 0
M204 S250
M73 P42 R8
G1 X151.725 Y107.397 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X151.725 Y112.187 E.14869
G1 X132.709 Y112.187 E.59029
G1 X132.709 Y102.607 E.29737
G1 X151.725 Y102.607 E.59029
G1 X151.725 Y107.337 E.14682
; WIPE_START
M204 S8000
G1 X151.725 Y108.337 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I1.207 J-.152 P1  F60000
G1 X151.17 Y103.935 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42461
G1 F15000
M204 S8000
G1 X150.567 Y103.332 E.02677
G1 X150.028 Y103.332 E.01696
G1 X151 Y104.305 E.04321
G1 X151 Y104.844 E.01696
G1 X149.488 Y103.332 E.0672
G1 X148.948 Y103.332 E.01696
G1 X151 Y105.384 E.09118
G1 X151 Y105.924 E.01696
G1 X148.408 Y103.332 E.11517
G1 X147.868 Y103.332 E.01696
G1 X151 Y106.464 E.13915
G1 X151 Y107.004 E.01696
G1 X147.329 Y103.332 E.16314
G1 X146.789 Y103.332 E.01696
G1 X151 Y107.543 E.18713
G1 X151 Y108.083 E.01696
G1 X146.249 Y103.332 E.21111
G1 X145.709 Y103.332 E.01696
G1 X151 Y108.623 E.2351
G1 X151 Y109.163 E.01696
G1 X145.169 Y103.332 E.25908
G1 X144.63 Y103.332 E.01696
G1 X151 Y109.703 E.28307
G1 X151 Y110.242 E.01696
G1 X144.09 Y103.332 E.30705
G1 X143.55 Y103.332 E.01696
G1 X151 Y110.782 E.33104
G1 X151 Y111.322 E.01696
G1 X143.01 Y103.332 E.35503
G1 X142.47 Y103.332 E.01696
G1 X150.6 Y111.462 E.36124
G1 X150.06 Y111.462 E.01696
G1 X141.931 Y103.332 E.36124
G1 X141.391 Y103.332 E.01696
G1 X149.52 Y111.462 E.36124
G1 X148.981 Y111.462 E.01696
G1 X140.851 Y103.332 E.36124
G1 X140.311 Y103.332 E.01696
G1 X148.441 Y111.462 E.36124
G1 X147.901 Y111.462 E.01696
G1 X139.772 Y103.332 E.36124
G1 X139.232 Y103.332 E.01696
G1 X147.361 Y111.462 E.36124
G1 X146.821 Y111.462 E.01696
G1 X138.692 Y103.332 E.36124
G1 X138.152 Y103.332 E.01696
G1 X146.282 Y111.462 E.36124
G1 X145.742 Y111.462 E.01696
G1 X137.612 Y103.332 E.36124
G1 X137.073 Y103.332 E.01696
G1 X145.202 Y111.462 E.36124
G1 X144.662 Y111.462 E.01696
G1 X136.533 Y103.332 E.36124
G1 X135.993 Y103.332 E.01696
G1 X144.123 Y111.462 E.36124
G1 X143.583 Y111.462 E.01696
G1 X135.453 Y103.332 E.36124
G1 X134.913 Y103.332 E.01696
G1 X143.043 Y111.462 E.36124
G1 X142.503 Y111.462 E.01696
G1 X134.374 Y103.332 E.36124
G1 X133.834 Y103.332 E.01696
G1 X141.963 Y111.462 E.36124
G1 X141.424 Y111.462 E.01696
G1 X133.434 Y103.472 E.35503
G1 X133.434 Y104.012 E.01696
G1 X140.884 Y111.462 E.33104
G1 X140.344 Y111.462 E.01696
G1 X133.434 Y104.552 E.30705
G1 X133.434 Y105.091 E.01696
G1 X139.804 Y111.462 E.28307
G1 X139.264 Y111.462 E.01696
G1 X133.434 Y105.631 E.25908
G1 X133.434 Y106.171 E.01696
G1 X138.725 Y111.462 E.2351
G1 X138.185 Y111.462 E.01696
G1 X133.434 Y106.711 E.21111
G1 X133.434 Y107.251 E.01696
G1 X137.645 Y111.462 E.18713
G1 X137.105 Y111.462 E.01696
G1 X133.434 Y107.79 E.16314
G1 X133.434 Y108.33 E.01696
G1 X136.565 Y111.462 E.13916
G1 X136.026 Y111.462 E.01696
G1 X133.434 Y108.87 E.11517
G1 X133.434 Y109.41 E.01696
G1 X135.486 Y111.462 E.09118
G1 X134.946 Y111.462 E.01696
G1 X133.434 Y109.949 E.0672
G1 X133.434 Y110.489 E.01696
G1 X134.406 Y111.462 E.04321
G1 X133.867 Y111.462 E.01696
G1 X133.264 Y110.859 E.02677
; WIPE_START
G1 X133.867 Y111.462 E-.32372
G1 X134.015 Y111.462 E-.05628
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I.031 J1.217 P1  F60000
G1 X157.701 Y110.859 Z1
G1 Z.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X158.303 Y111.462 E.02677
G1 X158.843 Y111.462 E.01696
G1 X157.87 Y110.489 E.04321
G1 X157.87 Y109.949 E.01696
G1 X159.383 Y111.462 E.0672
G1 X159.923 Y111.462 E.01696
G1 X157.87 Y109.41 E.09118
G1 X157.87 Y108.87 E.01696
G1 X160.462 Y111.462 E.11517
G1 X161.002 Y111.462 E.01696
G1 X157.87 Y108.33 E.13916
G1 X157.87 Y107.79 E.01696
G1 X161.542 Y111.462 E.16314
G1 X162.082 Y111.462 E.01696
G1 X157.87 Y107.251 E.18713
G1 X157.87 Y106.711 E.01696
G1 X162.622 Y111.462 E.21111
G1 X163.161 Y111.462 E.01696
G1 X157.87 Y106.171 E.2351
G1 X157.87 Y105.631 E.01696
G1 X163.701 Y111.462 E.25908
G1 X164.241 Y111.462 E.01696
G1 X157.87 Y105.091 E.28307
G1 X157.87 Y104.552 E.01696
G1 X164.781 Y111.462 E.30705
G1 X165.32 Y111.462 E.01696
G1 X157.87 Y104.012 E.33104
G1 X157.87 Y103.472 E.01696
G1 X165.86 Y111.462 E.35503
G1 X166.4 Y111.462 E.01696
G1 X158.27 Y103.332 E.36124
G1 X158.81 Y103.332 E.01696
G1 X166.94 Y111.462 E.36124
G1 X167.48 Y111.462 E.01696
G1 X159.35 Y103.332 E.36124
G1 X159.89 Y103.332 E.01696
G1 X168.019 Y111.462 E.36124
G1 X168.559 Y111.462 E.01696
G1 X160.43 Y103.332 E.36124
G1 X160.969 Y103.332 E.01696
G1 X169.099 Y111.462 E.36124
G1 X169.639 Y111.462 E.01696
G1 X161.509 Y103.332 E.36124
G1 X162.049 Y103.332 E.01696
G1 X170.179 Y111.462 E.36124
G1 X170.718 Y111.462 E.01696
G1 X162.589 Y103.332 E.36124
G1 X163.129 Y103.332 E.01696
G1 X171.258 Y111.462 E.36124
G1 X171.798 Y111.462 E.01696
G1 X163.668 Y103.332 E.36124
G1 X164.208 Y103.332 E.01696
G1 X172.338 Y111.462 E.36124
G1 X172.878 Y111.462 E.01696
G1 X164.748 Y103.332 E.36124
G1 X165.288 Y103.332 E.01696
G1 X173.417 Y111.462 E.36124
G1 X173.957 Y111.462 E.01696
G1 X165.828 Y103.332 E.36124
G1 X166.367 Y103.332 E.01696
G1 X174.497 Y111.462 E.36124
G1 X175.037 Y111.462 E.01696
G1 X166.907 Y103.332 E.36124
G1 X167.447 Y103.332 E.01696
G1 X175.437 Y111.322 E.35503
G1 X175.437 Y110.782 E.01696
G1 X167.987 Y103.332 E.33104
G1 X168.527 Y103.332 E.01696
G1 X175.437 Y110.242 E.30705
G1 X175.437 Y109.703 E.01696
G1 X169.066 Y103.332 E.28307
G1 X169.606 Y103.332 E.01696
G1 X175.437 Y109.163 E.25908
G1 X175.437 Y108.623 E.01696
G1 X170.146 Y103.332 E.2351
G1 X170.686 Y103.332 E.01696
G1 X175.437 Y108.083 E.21111
G1 X175.437 Y107.543 E.01696
G1 X171.225 Y103.332 E.18713
G1 X171.765 Y103.332 E.01696
G1 X175.437 Y107.004 E.16314
G1 X175.437 Y106.464 E.01696
G1 X172.305 Y103.332 E.13915
G1 X172.845 Y103.332 E.01696
G1 X175.437 Y105.924 E.11517
G1 X175.437 Y105.384 E.01696
G1 X173.385 Y103.332 E.09118
G1 X173.924 Y103.332 E.01696
G1 X175.437 Y104.844 E.0672
G1 X175.437 Y104.305 E.01696
G1 X174.464 Y103.332 E.04321
G1 X175.004 Y103.332 E.01696
G1 X175.606 Y103.935 E.02677
; WIPE_START
G1 X175.004 Y103.332 E-.32371
G1 X174.856 Y103.332 E-.05629
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U244 V110 Z1 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

M204 S10000
G1 X164.711 Y177.922
G1 Z.6
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X165.211 Y178.922  
M204 S8000
G3  X162.752 Y180.967   I-4.377 J-2.762 E0.1236 F5400
G3  X160.093 Y179.711   I0.009 J-3.462 E0.1154
G2  X157.389 Y178.922   I-2.710 J4.259 E0.1085
G2  X145.343 Y178.926   I-5.928 J318.375 E0.4578
G2  X141.396 Y180.808   I0.501 J6.129 E0.1699
G3  X139.085 Y180.375   I-0.852 J-1.839 E0.0953
G3  X136.023 Y177.104   I16.406 J-18.427 E0.1705
G3  X136.857 Y174.149   I2.026 J-1.023 E0.1282
M73 P43 R8
G2  X137.711 Y171.616   I-3.390 J-2.554 E0.1033
G2  X137.708 Y160.058   I-283.960 J-5.694 E0.4393
G2  X135.865 Y156.493   I-6.625 J1.166 E0.1549
G3  X136.200 Y154.520   I1.652 J-0.734 E0.0806
G3  X139.318 Y151.258   I19.448 J15.469 E0.1717
G3  X142.516 Y151.916   I1.278 J1.891 E0.1383
G2  X145.533 Y152.922   I3.023 J-4.037 E0.1230
G1  X151.461  E0.2253
G1  X152.711  E0.0475
G2  X158.335 Y152.832   I2.339 J-29.659 E0.2141
G2  X161.670 Y150.974   I-2.882 J-9.098 E0.1461
G3  X163.837 Y151.469   I0.711 J1.877 E0.0895
G3  X166.899 Y154.740   I-16.399 J18.421 E0.1705
G3  X167.124 Y155.198   I-2.082 J1.304 E0.0194
G1 E-0.4000 F1800
M204 S10000
G1  X166.319 Y157.394   F600
G1 E0.4000 F1800
M204 S8000
G2  X165.211 Y160.228   I3.079 J2.837 E0.1183 F5400
G2  X165.214 Y171.786   I283.960 J5.694 E0.4393
G2  X167.057 Y175.351   I6.625 J-1.166 E0.1549
G3  X166.722 Y177.324   I-1.652 J0.734 E0.0806
G1  X165.211 Y178.922   E0.0836
; WIPE_TOWER_END
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #1
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
G1 E-.4 F1800
G17
G3 Z1 I1.217 J0 P1  F60000
G1 X138.461 Y153.672
G1 Z.6
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF0 NF2 ON2 NN1
M632 S2 M N
M400
M104 T0 S180 N0
M106 S255
M633
M204 S8000
G1  X164.461 Y153.672  E2.0691 F7836
G1  Y155.172  E0.1194
G1  X138.461  E2.0691
M632 S2 M N
M204 S10000
G1  Y155.922 
G1  X163.961  F3000
G1  Y154.422 
G1  X138.961 
M633
; NOZZLE_CHANGE_END OF0 NF2 ON2 NN1

G1 E-2 F1800
G17
G3 Z1 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O2
M620 S2A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z3.6 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X166.711 Y156.422



M620.10 A0 F498.898 L0 H0.4 T240 P220 S1



M620.10 A1 F419.075 L0 H0.4 T240 P230 S1



M620.11 P1 I0 B-1 E-14 F623.623



M620.15 P180
M620.15 C220
M620.11 O1 T18


M620.11 K1 I0 B-1 R10 F623.623


M620.15 C220

M628 S1


M620.11 S1 L0 I0 B-1 R10 D8 E-14 F623.623


M629


;M620.11 H0




T2 H-1
M73 E5

;deretract


;VG1 E4 F523
;VG1 E4 F261



; VFLUSH_START


;VG1 E0 F523


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
M73 P46 R8
G1 Z3.6 F3000

M204 S25


M621 S2A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F8.75 A0.4 R2
M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.6

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I2 H-1 W1 ;enable ams air printing detect
M620 O2
M1002 gcode_claim_action : 0
M106 S255
M106 P2 S191

; filament start gcode
G1 X164.711 Y156.422 F60000
G1 Z.6
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X161.711 Y156.422  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
M73 P47 R8
G1  X166.211  F600
G1  X164.711  F240
G1  X165.211  F600
G1  Y156.922 
G1  X164.211 
G1  Y155.922 
G1  X165.711 
G1  Y157.422 
G1  X163.711 
G1  Y155.422 
G1  X161.711 Y156.422   F1782
G1 E0.4000 F1800
M400
M104 T0 S230 N0
M204 S8000
G1  X138.211  E0.8931 F1782
G1  Y157.172  E0.0285
G1  X164.711  E1.0072 F2025
G1  Y157.922  E0.0285
G1  X138.211  E1.0072 F2473
G1  Y158.672  E0.0285
G1  X164.711  E1.0072 F4725
G1  Y159.422  E0.0285
G1  X138.211  E1.0072 F4775
G1  Y160.172  E0.0285
G1  X164.711  E1.0072
G1  Y160.922  E0.0285
G1  X138.211  E1.0072
G1  Y161.672  E0.0285
G1  X164.711  E1.0072
G1  Y162.422  E0.0285
M73 P47 R7
G1  X138.211  E1.0072
G1  Y163.172  E0.0285
G1  X164.711  E1.0072
G1  Y163.922  E0.0285
G1  X138.211  E1.0072
G1  Y164.672  E0.0285
G1  X164.711  E1.0072
G1  Y165.422  E0.0285
G1  X138.211  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y178.422   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S8000
G1  Y166.172  E0.4656
G1  X164.711  E1.0072
G1  Y178.422  E0.4656
G1  X138.211  E1.0072
M204 S10000
G1  X139.211 Y166.172  
;--------------------
; CP EMPTY GRID START
; layer #4
M204 S8000
G1  Y178.422  E0.4656
M204 S10000
G1  X147.378 
M204 S8000
M73 P48 R7
G1  Y166.172  E0.4656
M204 S10000
G1  X155.544 
M204 S8000
G1  Y178.422  E0.4656
M204 S10000
G1  X163.711 
M204 S8000
G1  Y166.172  E0.4656
; CP EMPTY GRID END
;------------------






; WIPE_TOWER_END

; WIPE_START
G1 F15000
M204 S8000
G1 X163.711 Y167.172 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I1.217 J0 P1  F60000
; OBJECT_ID: 671
; COOLING_NODE: 0
M204 S10000
G1 X152.537 Y107.397
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X152.537 Y102.999 E.14887
G1 X156.333 Y102.999 E.12849
G1 X156.333 Y111.795 E.29773
G1 X152.537 Y111.795 E.12849
G1 X152.537 Y107.457 E.14683
; COOLING_NODE: 0
M204 S250
G1 X152.145 Y107.397 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X152.145 Y102.607 E.15019
G1 X156.725 Y102.607 E.1436
G1 X156.725 Y112.187 E.30037
G1 X152.145 Y112.187 E.1436
G1 X152.145 Y107.457 E.14831
; WIPE_START
M204 S8000
G1 X152.145 Y106.457 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I-1.013 J.674 P1  F60000
G1 X154.435 Y109.897 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F15000
M204 S8000
G1 X154.435 Y104.957 E.15291
M204 S10000
G1 X154.81 Y104.897 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X154.81 Y104.522 E.01175
G1 X154.061 Y104.522 E.02349
G1 X154.061 Y110.272 E.18026
G1 X154.81 Y110.272 E.02349
G1 X154.81 Y104.957 E.16663
M204 S10000
G1 X155.187 Y104.897 F60000
G1 F15000
M204 S8000
G1 X155.187 Y104.145 E.02357
G1 X153.684 Y104.145 E.04714
G1 X153.684 Y110.649 E.20391
G1 X155.187 Y110.649 E.04714
G1 X155.187 Y104.957 E.17846
M204 S10000
G1 X155.564 Y104.897 F60000
G1 F15000
M204 S8000
G1 X155.564 Y103.768 E.03539
G1 X153.306 Y103.768 E.07078
G1 X153.306 Y111.026 E.22755
G1 X155.564 Y111.026 E.07078
G1 X155.564 Y104.957 E.19028
M204 S10000
G1 X155.941 Y104.897 F60000
G1 F15000
M204 S8000
G1 X155.941 Y103.391 E.04721
G1 X152.929 Y103.391 E.09443
G1 X152.929 Y111.403 E.2512
G1 X155.941 Y111.403 E.09443
G1 X155.941 Y104.957 E.2021
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X155.941 Y105.957 E-.38
; WIPE_END
G1 E-.02 F1800
; layer num/total_layer_count: 4/14
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
; OBJECT_ID: 671
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1 I-.267 J-1.187 P1  F60000
G1 X149.537 Y107.397 Z1
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X149.537 Y102.999 E.14887
G1 X159.333 Y102.999 E.33158
G1 X159.333 Y111.795 E.29773
G1 X149.537 Y111.795 E.33158
G1 X149.537 Y107.457 E.14683
; COOLING_NODE: 0
M204 S250
G1 X149.145 Y107.397 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X149.145 Y102.607 E.15019
G1 X159.725 Y102.607 E.33173
G1 X159.725 Y112.187 E.30037
G1 X149.145 Y112.187 E.33173
G1 X149.145 Y107.457 E.14831
; WIPE_START
M204 S8000
G1 X149.145 Y106.457 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I1.097 J.528 P1  F60000
G1 X150.396 Y103.857 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.65613
G1 F10273.808
M204 S8000
G2 X150.398 Y106.539 I30.784 J1.309 E.13676
M204 S10000
G1 X150.401 Y106.599 F60000
; LINE_WIDTH: 0.645137
G1 F10461.346
M204 S8000
G1 X150.379 Y106.71 E.00568
; LINE_WIDTH: 0.601771
G1 F11273.13
G1 X150.358 Y106.821 E.00527
; LINE_WIDTH: 0.558405
G1 F12221.5
G1 X150.336 Y106.933 E.00486
; LINE_WIDTH: 0.515039
G1 F13344.094
G1 X150.314 Y107.044 E.00445
; LINE_WIDTH: 0.450216
G1 F15467.895
G1 X150.293 Y111.04 E.13532
G1 X152.44 Y111.04 E.07272
G1 X152.44 Y108.713 E.07878
G1 X150.709 Y106.983 E.08289
; LINE_WIDTH: 0.471673
G1 F14693.774
G1 X150.655 Y106.915 E.00308
; LINE_WIDTH: 0.515039
G1 F13344.094
G1 X150.601 Y106.848 E.00339
; LINE_WIDTH: 0.558405
G1 F12221.5
G1 X150.547 Y106.78 E.00371
; LINE_WIDTH: 0.601771
G1 F11273.13
G1 X150.493 Y106.713 E.00402
; LINE_WIDTH: 0.645137
G1 F10461.346
G1 X150.439 Y106.645 E.00433
M204 S10000
G1 X150.7 Y107.549 F60000
; LINE_WIDTH: 0.44999
G1 F15476.455
M204 S8000
G1 X150.7 Y110.633 E.10438
G1 X152.033 Y110.633 E.04513
G1 X152.033 Y108.882 E.05925
G1 X150.742 Y107.591 E.06179
M204 S10000
G1 X151.135 Y108.599 F60000
; LINE_WIDTH: 0.50597
G1 F13605.442
M204 S8000
G1 X151.135 Y110.197 E.06154
G1 X151.598 Y110.197 E.01783
G1 X151.598 Y109.062 E.04371
G1 X151.177 Y108.642 E.0229
M204 S10000
G1 X152.847 Y108.545 F60000
; LINE_WIDTH: 0.44999
G1 F15476.455
M204 S8000
G1 X150.997 Y106.695 E.08856
G1 X150.906 Y106.474 E.00807
G1 X150.906 Y103.347 E.10585
G1 X149.886 Y103.347 E.03453
G1 X149.886 Y111.447 E.27415
G1 X152.847 Y111.447 E.10024
G1 X152.847 Y108.605 E.09619
M204 S10000
G1 X154.435 Y110.207 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54986
G1 F12427.506
M204 S8000
G1 X154.435 Y108.555 E.06964
M204 S10000
G1 X155.711 Y108.303 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X157.57 Y106.444 E.08243
G2 X157.573 Y103.391 I-462.218 J-1.975 E.09572
G1 X151.298 Y103.391 E.19674
G1 X151.298 Y106.437 E.0955
G2 X153.16 Y108.303 I283.497 J-281.006 E.08265
G1 X153.239 Y108.495 E.0065
G1 X153.239 Y111.403 E.09118
G1 X155.631 Y111.403 E.07501
G1 X155.631 Y108.495 E.09118
G1 X155.688 Y108.358 E.00462
M204 S10000
G1 X155.444 Y108.036 F60000
G1 F15000
M204 S8000
G1 X157.196 Y106.285 E.07766
G1 X157.196 Y103.768 E.07891
G1 X151.675 Y103.768 E.1731
G1 X151.675 Y106.285 E.07891
G1 X153.426 Y108.036 E.07766
G1 X153.573 Y108.278 E.00887
G1 X153.616 Y108.495 E.00692
G1 X153.616 Y111.026 E.07936
G1 X155.254 Y111.026 E.05136
G1 X155.254 Y108.495 E.07936
G1 X155.321 Y108.22 E.00887
G1 X155.411 Y108.086 E.00504
M204 S10000
G1 X155.074 Y107.892 F60000
G1 F15000
M204 S8000
G3 X156.819 Y106.129 I60.437 J58.035 E.07777
G1 X156.819 Y104.145 E.06219
G1 X152.052 Y104.145 E.14945
G1 X152.052 Y106.129 E.06219
G1 X153.693 Y107.77 E.07277
G1 X153.897 Y108.076 E.01153
G3 X153.993 Y108.495 I-.885 J.423 E.01358
G1 X153.993 Y110.649 E.06754
G1 X154.877 Y110.649 E.02772
G1 X154.877 Y108.495 E.06754
G1 X154.949 Y108.134 E.01153
G1 X155.047 Y107.945 E.00666
M204 S10000
G1 X154.766 Y107.674 F60000
G1 F15000
M204 S8000
G3 X156.441 Y105.973 I44.763 J42.382 E.07487
G1 X156.441 Y104.522 E.04547
G1 X152.429 Y104.522 E.12581
G1 X152.429 Y105.973 E.04547
G1 X153.96 Y107.503 E.06787
G1 X154.246 Y107.931 E.01615
; LINE_WIDTH: 0.441635
G1 X154.309 Y108.119 E.00657
; LINE_WIDTH: 0.484925
G1 F14253.233
G1 X154.372 Y108.307 E.00728
; LINE_WIDTH: 0.528215
G1 F12981.795
G1 X154.435 Y108.495 E.00799
G1 X154.49 Y108.326 E.00715
; LINE_WIDTH: 0.484925
G1 F14253.233
G1 X154.545 Y108.158 E.00651
; LINE_WIDTH: 0.42809
G1 F15000
G3 X154.739 Y107.728 I1.366 J.354 E.01518
M204 S10000
G1 X154.435 Y107.499 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X154.644 Y107.237 E.01052
G1 X156.064 Y105.816 E.06297
G1 X156.064 Y104.899 E.02875
G1 X152.806 Y104.899 E.10216
G1 X152.806 Y105.816 E.02875
G1 X154.226 Y107.237 E.06297
G1 X154.398 Y107.452 E.00864
M204 S10000
G1 X154.435 Y106.912 F60000
G1 F15000
M204 S8000
G1 X155.687 Y105.66 E.05552
G1 X155.687 Y105.276 E.01203
G1 X153.183 Y105.276 E.07852
G1 X153.183 Y105.66 E.01203
G1 X154.393 Y106.87 E.05364
M204 S10000
G1 X154.435 Y106.3 F60000
; LINE_WIDTH: 0.53194
G1 F12882.909
M204 S8000
G1 X155.026 Y105.71 E.03395
G1 X153.845 Y105.71 E.04801
G1 X154.393 Y106.257 E.03151
M204 S10000
G1 X156.023 Y108.545 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.44999
G1 F15476.455
M204 S8000
G1 X156.023 Y111.447 E.09822
G1 X158.985 Y111.447 E.10024
G1 X158.985 Y103.347 E.27415
G1 X157.965 Y103.347 E.03453
G1 X157.965 Y106.474 E.10585
G1 X157.873 Y106.695 E.00807
G1 X156.066 Y108.502 E.08653
M204 S10000
G1 X157.736 Y108.599 F60000
; LINE_WIDTH: 0.50597
G1 F13605.442
M204 S8000
G1 X157.273 Y109.062 E.02521
G1 X157.273 Y110.197 E.04371
G1 X157.736 Y110.197 E.01783
G1 X157.736 Y108.659 E.05923
M204 S10000
G1 X158.171 Y107.549 F60000
; LINE_WIDTH: 0.44999
G1 F15476.455
M204 S8000
G1 X156.838 Y108.882 E.06382
G1 X156.838 Y110.633 E.05925
G1 X158.171 Y110.633 E.04513
G1 X158.171 Y107.609 E.10234
M204 S10000
G1 X158.469 Y106.599 F60000
; LINE_WIDTH: 0.656251
G1 F10271.788
M204 S8000
G2 X158.475 Y103.917 I-30.839 J-1.403 E.13678
M204 S10000
G1 X158.469 Y106.599 F60000
; LINE_WIDTH: 0.645119
G1 F10461.659
M204 S8000
G1 X158.408 Y106.675 E.00493
; LINE_WIDTH: 0.601757
G1 F11273.413
G1 X158.346 Y106.752 E.00458
; LINE_WIDTH: 0.558395
G1 F12221.738
G1 X158.285 Y106.829 E.00422
; LINE_WIDTH: 0.515033
G1 F13344.263
G1 X158.223 Y106.906 E.00387
; LINE_WIDTH: 0.450186
G1 F15469.015
G1 X156.431 Y108.713 E.0862
G1 X156.431 Y111.04 E.07878
G1 X158.578 Y111.04 E.07272
G1 X158.578 Y107.155 E.13154
; LINE_WIDTH: 0.471671
G1 F14693.843
G1 X158.558 Y107.056 E.00361
; LINE_WIDTH: 0.515033
G1 F13344.263
G1 X158.539 Y106.956 E.00398
; LINE_WIDTH: 0.558395
G1 F12221.738
G1 X158.52 Y106.857 E.00435
; LINE_WIDTH: 0.601757
G1 F11273.413
G1 X158.5 Y106.757 E.00471
; LINE_WIDTH: 0.645119
G1 F10461.659
G1 X158.481 Y106.658 E.00508
; WIPE_START
G1 X158.5 Y106.757 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U244 V110 Z1.2 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #2
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
M204 S10000
G1 X138.461 Y153.672
G1 Z.8
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF2 NF0 ON1 NN2
M632 S0 M N
M400
M104 T0 S180 N0
M106 S255
M633
M204 S8000
G1  X164.461 Y153.672  E2.0691 F6583
G1  Y155.172  E0.1194
G1  X138.461  E2.0691
M632 S0 M N
M204 S10000
G1  Y155.922 
G1  X163.961  F3000
G1  Y154.422 
G1  X138.961 
M633
; NOZZLE_CHANGE_END OF2 NF0 ON1 NN2

G1 E-2 F1800
G17
G3 Z1.2 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O3
M620 S0A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z3.8 F1200

M400
M106 P1 S0
M106 P2 S0


; get travel path for change filament
;M620.1 X54 Y0 F21000 P0
;M620.1 X54 Y0 F21000 P1
;M620.1 X54 Y245 F21000 P2



    M620.14 X136.211 Y165.422



M620.10 A0 F419.075 L0 H0.4 T240 P230 S1



M620.10 A1 F498.898 L0 H0.4 T240 P220 S1



M620.11 P1 I2 B-1 E-14 F523.843



M620.15 P180
M620.15 C210
M620.11 O1 T18


M620.11 K1 I2 B-1 R10 F523.843


M620.15 C210

M628 S1


M620.11 S1 L0 I2 B-1 R10 D8 E-14 F523.843


M629


;M620.11 H0




T0 H-1
M73 E4

;deretract


M73 P49 R7
;VG1 E4 F623
;VG1 E4 F311



; VFLUSH_START


;VG1 E0 F523


SYNC T0

; compensate for heating and cooling


; VFLUSH_END

M1002 set_filament_type:PLA

M400
M83



M620.10 R2


M628 S0

;VM109 S220

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F10.4167 A0.4 R2


M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
M73 P52 R7
G1 Z3.8 F3000

M204 S25


M621 S0A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
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


M620.6 I0 H-1 W1 ;enable ams air printing detect
M620 O3
M1002 gcode_claim_action : 0
M106 S193.8
M106 P2 S191

; filament start gcode
G1 X138.211 Y165.422 F60000
G1 Z.8
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X141.211 Y165.422  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X136.711  F600
G1  X138.211  F240
G1  X138.711  F600
G1  Y165.922 
G1  X137.711 
G1  Y164.922 
G1  X139.211 
G1  Y166.422 
G1  X137.211 
G1  Y164.422 
G1  X141.211 Y165.422   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X164.711  E0.8931 F1782
G1  Y164.672  E0.0285
G1  X138.211  E1.0072 F2025
G1  Y163.922  E0.0285
G1  X164.711  E1.0072 F2473
G1  Y163.172  E0.0285
M73 P53 R7
G1  X138.211  E1.0072 F4725
G1  Y162.422  E0.0285
G1  X164.711  E1.0072 F4775
G1  Y161.672  E0.0285
G1  X138.211  E1.0072
G1  Y160.922  E0.0285
G1  X164.711  E1.0072
G1  Y160.172  E0.0285
G1  X138.211  E1.0072
G1  Y159.422  E0.0285
G1  X164.711  E1.0072
G1  Y158.672  E0.0285
G1  X138.211  E1.0072
G1  Y157.922  E0.0285
G1  X164.711  E1.0072
G1  Y157.172  E0.0285
G1  X138.211  E1.0072
G1  Y156.422  E0.0285
G1  X164.711  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y178.422   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S8000
G1  X138.211  E1.0072
G1  Y166.172  E0.4656
G1  X164.711  E1.0072
G1  Y178.422  E0.4656
M204 S10000
G1  X139.211 Y166.172  
;--------------------
; CP EMPTY GRID START
; layer #5
M204 S8000
G1  Y178.422  E0.4656
M204 S10000
G1  X147.378 
M204 S8000
G1  Y166.172  E0.4656
M204 S10000
G1  X155.544 
M204 S8000
G1  Y178.422  E0.4656
M204 S10000
G1  X163.711 
M204 S8000
G1  Y166.172  E0.4656
; CP EMPTY GRID END
;------------------






; WIPE_TOWER_END
G1  X164.711 Y177.922
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X165.211 Y178.922  
M204 S8000
G3  X162.752 Y180.967   I-4.377 J-2.762 E0.1236
G3  X160.093 Y179.711   I0.009 J-3.462 E0.1154
G2  X157.389 Y178.922   I-2.710 J4.259 E0.1085
G2  X145.343 Y178.926   I-5.928 J318.375 E0.4578
G2  X141.396 Y180.808   I0.501 J6.129 E0.1699
G3  X139.085 Y180.375   I-0.852 J-1.839 E0.0953
G3  X136.023 Y177.104   I16.406 J-18.427 E0.1705
G3  X136.857 Y174.149   I2.026 J-1.023 E0.1282
G2  X137.711 Y171.616   I-3.390 J-2.554 E0.1033
G1  Y166.672  E0.1879
G1 E-0.4000 F1800
M204 S10000
G1  Y164.172  F600
G1 E0.4000 F1800
M204 S8000
G2  X137.587 Y159.217   I-20.265 J-1.972 E0.1888 F5400
G2  X135.812 Y156.361   I-11.353 J5.076 E0.1282
G3  X136.200 Y154.520   I1.734 J-0.596 E0.0751
G3  X139.318 Y151.258   I19.448 J15.469 E0.1717
G3  X142.516 Y151.916   I1.278 J1.891 E0.1383
G2  X145.533 Y152.922   I3.023 J-4.037 E0.1230
G1  X151.461  E0.2253
G1  X152.711  E0.0475
G2  X158.335 Y152.832   I2.339 J-29.659 E0.2141
G2  X161.670 Y150.974   I-2.882 J-9.098 E0.1461
G3  X163.837 Y151.469   I0.711 J1.877 E0.0895
G3  X166.899 Y154.740   I-16.399 J18.421 E0.1705
G3  X166.065 Y157.695   I-2.026 J1.023 E0.1282
G2  X165.211 Y160.228   I3.390 J2.554 E0.1033
G2  X165.214 Y171.786   I283.960 J5.694 E0.4393
G2  X167.057 Y175.351   I6.625 J-1.166 E0.1549
G3  X166.722 Y177.324   I-1.652 J0.734 E0.0806
G1  X165.211 Y178.922   E0.0836
; WIPE_TOWER_END

; WIPE_START
G1 F10461.659
M204 S8000
G1 X165.211 Y178.922 E-.00001
G1 X165.211 Y178.922 E-.00001
G1 X165.898 Y178.196 E-.37998
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I1.217 J0 P1  F60000
; OBJECT_ID: 671
; COOLING_NODE: 0
M204 S10000
G1 X160.537 Y107.397
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X160.537 Y102.999 E.14738
G1 X175.77 Y102.999 E.51045
G1 X175.77 Y111.795 E.29475
G1 X160.537 Y111.795 E.51045
G1 X160.537 Y107.457 E.14537
; COOLING_NODE: 0
M204 S250
G1 X160.145 Y107.397 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
M73 P54 R7
G1 X160.145 Y102.607 E.14869
G1 X176.162 Y102.607 E.49717
G1 X176.162 Y112.187 E.29737
G1 X160.145 Y112.187 E.49717
G1 X160.145 Y107.457 E.14682
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X160.145 Y106.457 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I-.097 J-1.213 P1  F60000
G1 X148.333 Y107.397 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X148.333 Y111.795 E.14738
G1 X133.101 Y111.795 E.51045
G1 X133.101 Y102.999 E.29475
G1 X148.333 Y102.999 E.51045
G1 X148.333 Y107.337 E.14537
; COOLING_NODE: 0
M204 S250
G1 X148.725 Y107.397 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X148.725 Y112.187 E.14869
G1 X132.709 Y112.187 E.49717
G1 X132.709 Y102.607 E.29737
G1 X148.725 Y102.607 E.49717
G1 X148.725 Y107.337 E.14682
; WIPE_START
M204 S8000
G1 X148.725 Y108.337 E-.38
; WIPE_END
M73 P54 R6
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I.43 J-1.138 P1  F60000
G1 X144.773 Y106.844 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.36131
G1 F21000
M204 S8000
G3 X144.402 Y107.397 I-1.896 J-.871 E.01751
G1 X144.773 Y107.95 E.01744
G1 X144.773 Y106.904 E.02739
M204 S10000
G1 X145.136 Y106.444 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X145.136 Y106.197 E.00829
G1 X144.693 Y106.197 E.01482
G1 X144.662 Y106.343 E.00503
G3 X143.91 Y107.412 I-3.799 J-1.873 E.04396
G3 X144.693 Y108.597 I-2.645 J2.598 E.04789
G1 X145.136 Y108.597 E.01482
G1 X145.136 Y106.504 E.07014
M204 S10000
G1 X145.543 Y106.444 F60000
G1 F18424.351
M204 S8000
G1 X145.543 Y105.79 E.02193
G1 X144.373 Y105.79 E.0392
G1 X144.29 Y106.178 E.0133
G3 X143.246 Y107.397 I-3.406 J-1.86 E.05418
G3 X144.373 Y109.004 I-1.473 J2.231 E.06735
G1 X145.543 Y109.004 E.0392
G1 X145.543 Y106.504 E.08378
M204 S10000
G1 X145.95 Y106.444 F60000
G1 F18424.351
M204 S8000
G1 X145.95 Y105.383 E.03557
G1 X144.052 Y105.383 E.06358
G3 X142.295 Y107.397 I-2.357 J-.283 E.09514
G3 X144.052 Y109.411 I-.614 J2.31 E.09506
G1 X145.95 Y109.411 E.06358
G1 X145.95 Y106.504 E.09742
M204 S10000
G1 X146.357 Y106.444 F60000
G1 F18424.351
M204 S8000
G1 X146.357 Y104.976 E.04921
G1 X143.705 Y104.976 E.08886
G1 X143.547 Y105.847 E.02967
G3 X142.571 Y106.861 I-2.338 J-1.271 E.04774
; LINE_WIDTH: 0.47312
G1 F17433.752
G1 X142.298 Y106.949 E.01016
; LINE_WIDTH: 0.51938
G1 F15741.091
G1 X142.025 Y107.036 E.01125
; LINE_WIDTH: 0.587447
G1 F13773.44
G1 X141.752 Y107.124 E.01285
G1 X139.662 Y107.124 E.09365
G1 X139.662 Y107.67 E.02447
G1 X141.752 Y107.67 E.09365
; LINE_WIDTH: 0.56564
G1 F14348.027
G1 X142.025 Y107.758 E.01234
; LINE_WIDTH: 0.51938
G1 F15741.091
G1 X142.298 Y107.845 E.01125
; LINE_WIDTH: 0.450764
G1 F18389.379
G3 X143.705 Y109.819 I-.606 J1.921 E.08732
G1 X146.357 Y109.819 E.08903
G1 X146.357 Y106.504 E.11127
M204 S10000
G1 X146.764 Y106.444 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X146.764 Y104.568 E.06285
G1 X143.298 Y104.568 E.11614
G3 X142.389 Y106.497 I-1.823 J.319 E.07615
G3 X141.752 Y106.648 I-.637 J-1.274 E.02214
G1 X139.186 Y106.648 E.08598
G1 X139.186 Y108.146 E.05022
G1 X141.752 Y108.146 E.08598
G3 X143.298 Y109.693 I-.069 J1.616 E.08048
G1 X143.298 Y110.226 E.01785
G1 X146.764 Y110.226 E.11614
G1 X146.764 Y106.504 E.1247
M204 S10000
G1 X147.171 Y106.444 F60000
G1 F18424.351
M204 S8000
G1 X147.171 Y104.161 E.07649
G1 X142.891 Y104.161 E.14342
G3 X142.803 Y105.515 I-3.228 J.47 E.0458
G3 X141.752 Y106.241 I-1.18 J-.586 E.04468
G1 X138.779 Y106.241 E.09962
G1 X138.779 Y108.553 E.0775
G1 X141.752 Y108.553 E.09962
G3 X142.891 Y109.693 I-.115 J1.254 E.05858
G1 X142.891 Y110.633 E.03149
G1 X147.171 Y110.633 E.14342
G1 X147.171 Y106.504 E.13834
M204 S10000
G1 X147.578 Y106.444 F60000
G1 F18424.351
M204 S8000
G1 X147.578 Y103.754 E.09014
G1 X142.484 Y103.754 E.1707
G1 X142.484 Y105.101 E.04513
G3 X141.752 Y105.833 I-.77 J-.038 E.03805
G1 X138.372 Y105.833 E.11326
G1 X138.372 Y108.961 E.10479
G1 X141.752 Y108.961 E.11326
G3 X142.484 Y109.693 I-.038 J.77 E.03805
G1 X142.484 Y111.04 E.04513
G1 X147.578 Y111.04 E.1707
G1 X147.578 Y106.504 E.15199
M204 S10000
G1 X147.985 Y106.444 F60000
G1 F18424.351
M204 S8000
G1 X147.985 Y103.347 E.10378
G1 X142.077 Y103.347 E.19798
G1 X142.077 Y105.101 E.05877
G3 X141.752 Y105.426 I-.54 J-.214 E.01585
G1 X137.965 Y105.426 E.1269
G1 X137.965 Y109.368 E.13207
G1 X141.752 Y109.368 E.1269
G3 X142.077 Y109.693 I-.163 J.489 E.01598
G1 X142.077 Y111.447 E.05877
G1 X147.985 Y111.447 E.19798
G1 X147.985 Y106.504 E.16563
M204 S10000
G1 X141.308 Y104.657 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X141.308 Y103.768 E.0276
G1 X133.87 Y103.768 E.23087
G1 X133.87 Y111.026 E.22528
G1 X141.308 Y111.026 E.23087
G1 X141.308 Y110.137 E.0276
G1 X137.854 Y110.137 E.1072
G1 X137.454 Y109.971 E.01344
G1 X137.228 Y109.667 E.01176
G1 X137.196 Y109.363 E.00949
G1 X137.196 Y105.316 E.12562
G1 X137.228 Y105.127 E.00594
G1 X137.454 Y104.823 E.01176
G1 X137.756 Y104.666 E.01057
G1 X137.854 Y104.657 E.00304
G1 X141.248 Y104.657 E.10534
M204 S10000
G1 X140.863 Y104.213 F60000
; LINE_WIDTH: 0.555304
G1 F14637.46
M204 S8000
G1 X137.738 Y104.218 E.13181
M204 S10000
G1 X136.74 Y104.522 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X134.624 Y104.522 E.06568
G1 X134.624 Y110.272 E.17846
G1 X136.74 Y110.272 E.06568
G1 X136.517 Y109.918 E.01297
G1 X136.441 Y109.363 E.01739
G1 X136.441 Y105.316 E.12562
G1 X136.517 Y104.876 E.01385
G1 X136.708 Y104.573 E.01111
M204 S10000
G1 X136.136 Y104.899 F60000
G1 F15000
M204 S8000
G1 X135.001 Y104.899 E.03523
G1 X135.001 Y109.895 E.15505
G1 X136.136 Y109.895 E.03523
G1 X136.064 Y109.363 E.01665
G1 X136.064 Y105.316 E.12562
G1 X136.126 Y104.959 E.01125
M204 S10000
G1 X135.704 Y109.363 F60000
; LINE_WIDTH: 0.3861
G1 F15000
M204 S8000
G1 X135.714 Y105.26 E.11592
G1 X135.361 Y105.26 E.00997
G1 X135.361 Y109.534 E.12077
G1 X135.714 Y109.534 E.00997
G1 X135.708 Y109.423 E.00316
M204 S10000
G1 X137.854 Y110.581 F60000
; LINE_WIDTH: 0.55502
G1 F14645.578
M204 S8000
G1 X140.803 Y110.581 E.12432
M204 S10000
G1 X137.854 Y110.581 F60000
; LINE_WIDTH: 0.532515
G1 F15000
M204 S8000
G1 X137.632 Y110.467 E.01007
; LINE_WIDTH: 0.487505
G1 X137.41 Y110.352 E.00915
; LINE_WIDTH: 0.420907
G1 X137.187 Y110.238 E.00778
G1 X136.872 Y109.792 E.01697
G1 X136.819 Y109.363 E.01347
G1 X136.819 Y105.316 E.12593
G1 X136.872 Y105.002 E.00992
G1 X137.187 Y104.556 E.01697
; LINE_WIDTH: 0.438782
G1 X137.31 Y104.472 E.00484
; LINE_WIDTH: 0.476364
G1 X137.433 Y104.388 E.0053
; LINE_WIDTH: 0.513947
G1 X137.555 Y104.304 E.00576
; LINE_WIDTH: 0.551529
G1 F14746.109
G1 X137.678 Y104.22 E.00622
G1 X137.513 Y104.202 E.00696
; LINE_WIDTH: 0.513947
G1 F15000
G1 X137.348 Y104.183 E.00645
; LINE_WIDTH: 0.476364
G1 X137.182 Y104.164 E.00593
; LINE_WIDTH: 0.420246
G1 X137.017 Y104.145 E.00517
G1 X134.247 Y104.145 E.08605
G1 X134.247 Y110.649 E.202
G1 X137.017 Y110.649 E.08605
; LINE_WIDTH: 0.442495
G1 X137.276 Y110.628 E.00855
; LINE_WIDTH: 0.487505
G1 X137.535 Y110.607 E.00951
; LINE_WIDTH: 0.532515
G1 X137.794 Y110.586 E.01047
M204 S10000
G1 X141.685 Y109.779 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X140.863 Y109.76 E.02551
G1 X137.854 Y109.76 E.0934
G1 X137.721 Y109.704 E.00448
G1 X137.583 Y109.541 E.00662
G1 X137.573 Y109.363 E.00554
G1 X137.573 Y105.316 E.12562
G1 X137.628 Y105.182 E.00448
G1 X137.821 Y105.037 E.00751
G1 X137.854 Y105.034 E.00102
G1 X141.674 Y105.034 E.11856
G2 X141.685 Y103.391 I-59.74 J-1.232 E.05101
G1 X133.493 Y103.391 E.25428
G1 X133.493 Y111.403 E.24868
G1 X141.685 Y111.403 E.25428
G1 X141.685 Y109.839 E.04855
; WIPE_START
G1 X141.685 Y110.839 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I.156 J1.207 P1  F60000
G1 X164.098 Y107.95 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.36131
G1 F21000
M204 S8000
G3 X164.468 Y107.397 I1.895 J.871 E.01751
G1 X164.098 Y106.844 E.01744
G1 X164.098 Y107.89 E.02739
M204 S10000
G1 X163.735 Y108.597 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X164.177 Y108.597 E.01482
G1 X164.208 Y108.451 E.00503
G3 X164.978 Y107.397 I2.915 J1.321 E.04402
G3 X164.177 Y106.197 I2.593 J-2.596 E.04866
G1 X163.735 Y106.197 E.01482
G1 X163.735 Y108.537 E.07843
M204 S10000
G1 X163.328 Y109.004 F60000
G1 F18424.351
M204 S8000
G1 X164.498 Y109.004 E.0392
G1 X164.58 Y108.616 E.0133
G3 X165.624 Y107.397 I3.406 J1.86 E.05418
G3 X164.498 Y105.79 I1.473 J-2.231 E.06735
G1 X163.328 Y105.79 E.0392
G1 X163.328 Y108.944 E.10571
M204 S10000
G1 X162.921 Y109.411 F60000
G1 F18424.351
M204 S8000
G1 X164.818 Y109.411 E.06358
G3 X166.575 Y107.397 I2.357 J.283 E.09514
G3 X164.818 Y105.383 I.614 J-2.31 E.09506
G1 X162.921 Y105.383 E.06358
G1 X162.921 Y109.351 E.13299
M204 S10000
G1 X162.514 Y109.819 F60000
G1 F18424.351
M204 S8000
G1 X165.165 Y109.819 E.08886
G1 X165.324 Y108.947 E.02967
G3 X166.3 Y107.933 I2.338 J1.271 E.04774
; LINE_WIDTH: 0.474504
G1 F17377.872
G1 X166.517 Y107.846 E.00832
; LINE_WIDTH: 0.52353
G1 F15605.168
G1 X166.735 Y107.76 E.00927
; LINE_WIDTH: 0.588313
G1 F13751.563
G3 X167.119 Y107.67 I.311 J.465 E.01808
G1 X169.208 Y107.67 E.0938
G1 X169.208 Y107.124 E.02451
G3 X166.953 Y107.121 I-1.045 J-60.606 E.10126
; LINE_WIDTH: 0.572557
G1 F14160.651
G1 X166.735 Y107.034 E.01022
; LINE_WIDTH: 0.52353
G1 F15605.168
G1 X166.517 Y106.948 E.00927
; LINE_WIDTH: 0.450566
G1 F18398.351
G3 X165.165 Y104.976 I.726 J-1.947 E.0855
G1 X162.514 Y104.976 E.08898
G1 X162.514 Y109.759 E.1605
M204 S10000
G1 X162.107 Y110.226 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X165.573 Y110.226 E.11614
G3 X166.482 Y108.297 I1.823 J-.319 E.07615
G3 X167.119 Y108.146 I.637 J1.274 E.02214
G1 X169.685 Y108.146 E.08598
G1 X169.685 Y106.648 E.05022
G1 X167.119 Y106.648 E.08598
G3 X165.573 Y105.101 I.069 J-1.616 E.08048
G1 X165.573 Y104.568 E.01785
G1 X162.107 Y104.568 E.11614
G1 X162.107 Y110.166 E.18756
M204 S10000
G1 X161.7 Y110.633 F60000
G1 F18424.351
M204 S8000
G1 X165.98 Y110.633 E.14342
G3 X166.068 Y109.279 I3.228 J-.47 E.0458
G3 X167.119 Y108.553 I1.18 J.586 E.04468
G1 X170.092 Y108.553 E.09962
G1 X170.092 Y106.241 E.0775
G1 X167.119 Y106.241 E.09962
G3 X165.98 Y105.101 I.115 J-1.254 E.05858
G1 X165.98 Y104.161 E.03149
G1 X161.7 Y104.161 E.14342
G1 X161.7 Y110.573 E.21484
M204 S10000
G1 X161.293 Y111.04 F60000
G1 F18424.351
M204 S8000
G1 X166.387 Y111.04 E.1707
G1 X166.387 Y109.693 E.04513
G3 X167.119 Y108.961 I.77 J.038 E.03805
G1 X170.499 Y108.961 E.11326
G1 X170.499 Y105.833 E.10479
G1 X167.119 Y105.833 E.11326
G3 X166.387 Y105.101 I.038 J-.77 E.03805
G1 X166.387 Y103.754 E.04513
G1 X161.293 Y103.754 E.1707
G1 X161.293 Y110.98 E.24212
M204 S10000
G1 X160.885 Y111.447 F60000
G1 F18424.351
M204 S8000
G1 X166.794 Y111.447 E.19798
G1 X166.794 Y109.693 E.05877
G3 X167.119 Y109.368 I.54 J.214 E.01585
G1 X170.906 Y109.368 E.1269
G1 X170.906 Y105.426 E.13207
G1 X167.119 Y105.426 E.1269
G3 X166.794 Y105.101 I.163 J-.489 E.01598
G1 X166.794 Y103.347 E.05877
G1 X160.885 Y103.347 E.19798
G1 X160.885 Y111.387 E.2694
M204 S10000
G1 X167.563 Y110.137 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X167.563 Y111.026 E.0276
G1 X175.001 Y111.026 E.23087
G1 X175.001 Y103.768 E.22528
G1 X167.563 Y103.768 E.23087
G1 X167.563 Y104.657 E.0276
G1 X171.017 Y104.657 E.1072
G1 X171.416 Y104.823 E.01344
G1 X171.643 Y105.127 E.01176
G1 X171.675 Y105.431 E.00949
G1 X171.675 Y109.478 E.12562
G1 X171.643 Y109.667 E.00594
G1 X171.416 Y109.971 E.01176
G1 X171.114 Y110.128 E.01057
G1 X171.017 Y110.137 E.00304
G1 X167.623 Y110.137 E.10534
M204 S10000
G1 X168.007 Y110.581 F60000
; LINE_WIDTH: 0.555304
G1 F14637.46
M204 S8000
G1 X171.132 Y110.576 E.13181
M204 S10000
G1 X172.131 Y110.272 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X174.247 Y110.272 E.06568
G1 X174.247 Y104.522 E.17846
G1 X172.131 Y104.522 E.06568
G1 X172.354 Y104.876 E.01297
G1 X172.429 Y105.431 E.01739
M73 P55 R6
G1 X172.429 Y109.478 E.12562
G1 X172.354 Y109.918 E.01385
G1 X172.163 Y110.221 E.01111
M204 S10000
G1 X172.735 Y109.895 F60000
G1 F15000
M204 S8000
G1 X173.87 Y109.895 E.03523
G1 X173.87 Y104.899 E.15505
G1 X172.735 Y104.899 E.03523
G1 X172.806 Y105.431 E.01665
G1 X172.806 Y109.478 E.12562
G1 X172.745 Y109.835 E.01125
M204 S10000
G1 X173.166 Y105.431 F60000
; LINE_WIDTH: 0.3861
G1 F15000
M204 S8000
G1 X173.157 Y109.534 E.11592
G1 X173.509 Y109.534 E.00997
G1 X173.509 Y105.26 E.12077
G1 X173.157 Y105.26 E.00997
G1 X173.163 Y105.371 E.00316
M204 S10000
G1 X171.017 Y104.213 F60000
; LINE_WIDTH: 0.532515
G1 F15000
M204 S8000
G1 X171.239 Y104.327 E.01007
; LINE_WIDTH: 0.487505
G1 X171.461 Y104.442 E.00915
; LINE_WIDTH: 0.420907
G1 X171.683 Y104.556 E.00778
G1 X171.998 Y105.002 E.01697
G1 X172.052 Y105.431 E.01347
G1 X172.052 Y109.478 E.12593
G1 X171.998 Y109.793 E.00992
G1 X171.683 Y110.238 E.01697
; LINE_WIDTH: 0.438782
G1 X171.56 Y110.322 E.00484
; LINE_WIDTH: 0.476364
G1 X171.438 Y110.406 E.0053
; LINE_WIDTH: 0.513947
G1 X171.315 Y110.49 E.00576
; LINE_WIDTH: 0.551529
G1 F14746.109
G1 X171.192 Y110.574 E.00622
G1 X171.358 Y110.592 E.00696
; LINE_WIDTH: 0.513947
G1 F15000
G1 X171.523 Y110.611 E.00645
; LINE_WIDTH: 0.476364
G1 X171.688 Y110.63 E.00593
; LINE_WIDTH: 0.420246
G1 X171.853 Y110.649 E.00517
G1 X174.624 Y110.649 E.08605
G1 X174.624 Y104.145 E.202
G1 X171.853 Y104.145 E.08605
; LINE_WIDTH: 0.442495
G1 X171.594 Y104.166 E.00855
; LINE_WIDTH: 0.487505
G1 X171.335 Y104.187 E.00951
; LINE_WIDTH: 0.532515
G1 X171.076 Y104.208 E.01047
M204 S10000
G1 X168.007 Y104.213 F60000
; LINE_WIDTH: 0.55502
G1 F14645.578
M204 S8000
G1 X170.957 Y104.213 E.12432
M204 S10000
G1 X167.186 Y105.023 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G2 X171.017 Y105.034 I2.326 J-139.27 E.11891
G1 X171.15 Y105.09 E.00448
G1 X171.287 Y105.253 E.00662
G1 X171.298 Y105.431 E.00554
G1 X171.298 Y109.478 E.12562
G1 X171.243 Y109.612 E.00448
G1 X171.049 Y109.757 E.00751
G1 X171.017 Y109.76 E.00102
G1 X167.197 Y109.76 E.11856
G2 X167.186 Y111.403 I59.74 J1.232 E.05101
G1 X175.378 Y111.403 E.25428
G1 X175.378 Y103.391 E.24868
G1 X167.186 Y103.391 E.25428
G1 X167.186 Y104.963 E.0488
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X167.186 Y103.963 E-.38
; WIPE_END
G1 E-.02 F1800
; layer num/total_layer_count: 5/14
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
; OBJECT_ID: 671
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.2 I-.558 J-1.081 P1  F60000
G1 X160.537 Y107.397 Z1.2
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X160.537 Y102.999 E.14738
G1 X170.858 Y102.999 E.34584
G1 X170.858 Y111.795 E.29475
G1 X160.537 Y111.795 E.34584
G1 X160.537 Y107.457 E.14537
; COOLING_NODE: 0
M204 S250
G1 X160.145 Y107.397 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X160.145 Y102.607 E.14869
G1 X176.162 Y102.607 E.49717
G1 X176.162 Y112.187 E.29737
G1 X160.145 Y112.187 E.49717
G1 X160.145 Y107.457 E.14682
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X160.145 Y106.457 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.097 J-1.213 P1  F60000
G1 X148.333 Y107.397 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X148.333 Y111.795 E.14738
G1 X138.013 Y111.795 E.34584
G1 X138.013 Y102.999 E.29475
G1 X148.333 Y102.999 E.34584
G1 X148.333 Y107.337 E.14537
; COOLING_NODE: 0
M204 S250
G1 X148.725 Y107.397 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X148.725 Y112.187 E.14869
G1 X132.709 Y112.187 E.49717
G1 X132.709 Y102.607 E.29737
G1 X148.725 Y102.607 E.49717
G1 X148.725 Y107.337 E.14682
; WIPE_START
M204 S8000
G1 X148.725 Y108.337 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.43 J-1.138 P1  F60000
G1 X144.773 Y106.844 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.36131
G1 F21000
M204 S8000
G3 X144.402 Y107.397 I-1.896 J-.871 E.01751
G1 X144.773 Y107.95 E.01744
G1 X144.773 Y106.904 E.02739
M204 S10000
G1 X145.136 Y106.444 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X145.136 Y106.197 E.00829
G1 X144.693 Y106.197 E.01482
G1 X144.662 Y106.343 E.00503
G3 X143.91 Y107.412 I-3.799 J-1.873 E.04396
G3 X144.693 Y108.597 I-2.645 J2.598 E.04789
G1 X145.136 Y108.597 E.01482
G1 X145.136 Y106.504 E.07014
M204 S10000
G1 X145.543 Y106.444 F60000
G1 F18424.351
M204 S8000
G1 X145.543 Y105.79 E.02193
G1 X144.373 Y105.79 E.0392
G1 X144.29 Y106.178 E.0133
G3 X143.246 Y107.397 I-3.406 J-1.86 E.05418
G3 X144.373 Y109.004 I-1.473 J2.231 E.06735
G1 X145.543 Y109.004 E.0392
G1 X145.543 Y106.504 E.08378
M204 S10000
G1 X145.95 Y106.444 F60000
G1 F18424.351
M204 S8000
G1 X145.95 Y105.383 E.03557
G1 X144.052 Y105.383 E.06358
G3 X142.295 Y107.397 I-2.357 J-.283 E.09514
G3 X144.052 Y109.411 I-.614 J2.31 E.09506
G1 X145.95 Y109.411 E.06358
G1 X145.95 Y106.504 E.09742
M204 S10000
G1 X146.357 Y106.444 F60000
G1 F18424.351
M204 S8000
G1 X146.357 Y104.976 E.04921
G1 X143.705 Y104.976 E.08886
G1 X143.547 Y105.847 E.02967
G3 X142.571 Y106.861 I-2.338 J-1.271 E.04774
; LINE_WIDTH: 0.47312
G1 F17433.752
G1 X142.298 Y106.949 E.01016
; LINE_WIDTH: 0.51938
G1 F15741.091
G1 X142.025 Y107.036 E.01125
; LINE_WIDTH: 0.587198
G1 F13779.737
G1 X141.752 Y107.124 E.01285
G1 X140.059 Y107.124 E.07584
G1 X140.059 Y107.67 E.02446
G1 X141.752 Y107.67 E.07584
; LINE_WIDTH: 0.56564
G1 F14348.027
G1 X142.025 Y107.758 E.01234
; LINE_WIDTH: 0.51938
G1 F15741.091
G1 X142.298 Y107.845 E.01125
; LINE_WIDTH: 0.450764
G1 F18389.379
G3 X143.705 Y109.819 I-.606 J1.921 E.08732
G1 X146.357 Y109.819 E.08903
G1 X146.357 Y106.504 E.11127
M204 S10000
G1 X146.764 Y106.444 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X146.764 Y104.568 E.06285
G1 X143.298 Y104.568 E.11614
G3 X142.389 Y106.497 I-1.823 J.319 E.07615
G3 X141.752 Y106.648 I-.637 J-1.274 E.02214
G1 X139.582 Y106.648 E.07269
G1 X139.582 Y108.146 E.05022
G1 X141.752 Y108.146 E.07269
G3 X143.298 Y109.693 I-.069 J1.616 E.08048
G1 X143.298 Y110.226 E.01785
G1 X146.764 Y110.226 E.11614
G1 X146.764 Y106.504 E.1247
M204 S10000
G1 X147.171 Y106.444 F60000
G1 F18424.351
M204 S8000
G1 X147.171 Y104.161 E.07649
G1 X142.891 Y104.161 E.14342
G3 X142.803 Y105.515 I-3.228 J.47 E.0458
G3 X141.752 Y106.241 I-1.18 J-.586 E.04468
G1 X139.175 Y106.241 E.08633
G1 X139.175 Y108.553 E.0775
G1 X141.752 Y108.553 E.08633
G3 X142.891 Y109.693 I-.115 J1.254 E.05858
G1 X142.891 Y110.633 E.03149
G1 X147.171 Y110.633 E.14342
G1 X147.171 Y106.504 E.13834
M204 S10000
G1 X147.578 Y106.444 F60000
G1 F18424.351
M204 S8000
G1 X147.578 Y103.754 E.09014
G1 X142.484 Y103.754 E.1707
G1 X142.484 Y105.101 E.04513
G3 X141.752 Y105.833 I-.77 J-.038 E.03805
G1 X138.768 Y105.833 E.09997
G1 X138.768 Y108.961 E.10479
G1 X141.752 Y108.961 E.09997
G3 X142.484 Y109.693 I-.038 J.77 E.03805
G1 X142.484 Y111.04 E.04513
G1 X147.578 Y111.04 E.1707
G1 X147.578 Y106.504 E.15199
M204 S10000
G1 X147.985 Y106.444 F60000
G1 F18424.351
M204 S8000
G1 X147.985 Y103.347 E.10378
G1 X142.077 Y103.347 E.19798
G1 X142.077 Y105.101 E.05877
G3 X141.752 Y105.426 I-.54 J-.214 E.01585
G1 X138.361 Y105.426 E.11361
G1 X138.361 Y109.368 E.13207
G1 X141.752 Y109.368 E.11361
G3 X142.077 Y109.693 I-.163 J.489 E.01598
G1 X142.077 Y111.447 E.05877
G1 X147.985 Y111.447 E.19798
G1 X147.985 Y106.504 E.16563
M204 S10000
G1 X139.227 Y104.213 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.55502
G1 F14645.578
M204 S8000
G1 X140.803 Y104.213 E.06646
M204 S10000
G1 X141.308 Y104.657 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X141.308 Y103.768 E.0276
G1 X138.782 Y103.768 E.0784
G1 X138.782 Y104.657 E.0276
G1 X141.248 Y104.657 E.07653
M204 S10000
G1 X141.674 Y105.034 F60000
G1 F15000
M204 S8000
G2 X141.685 Y103.391 I-59.74 J-1.232 E.05101
G1 X138.405 Y103.391 E.10181
G1 X138.405 Y105.034 E.05101
G1 X141.614 Y105.034 E.09959
; WIPE_START
G1 X140.614 Y105.034 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.68 J-1.009 P1  F60000
G1 X137.321 Y102.814 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F12000
M204 S2000
G1 X137.79 Y103.284 E.02061
G1 X137.924 Y103.417
G1 X137.924 Y103.951
G1 X137.79 Y103.817
G1 X136.788 Y102.814 E.04402
G1 X136.654 Y102.681
G1 X136.121 Y102.681
G1 X136.255 Y102.814
G1 X137.79 Y104.35 E.06742
G1 X137.924 Y104.484
G1 X137.924 Y105.017
G1 X137.79 Y104.884
G1 X135.721 Y102.814 E.09083
G1 X135.588 Y102.681
G1 X135.054 Y102.681
G1 X135.188 Y102.814
G1 X137.79 Y105.417 E.11424
G1 X137.924 Y105.55
G1 X137.924 Y106.084
G1 X137.79 Y105.95
G1 X134.655 Y102.814 E.13765
G1 X134.521 Y102.681
G1 X133.988 Y102.681
G1 X134.121 Y102.814
G1 X137.79 Y106.483 E.16106
G1 X137.924 Y106.617
G1 X137.924 Y107.15
G1 X137.79 Y107.017
G1 X133.588 Y102.814 E.18447
G1 X133.455 Y102.681
G1 X132.921 Y102.681
G1 X133.055 Y102.814
G1 X137.79 Y107.55 E.20788
G1 X137.924 Y107.683
G1 X137.924 Y108.217
G1 X137.79 Y108.083
G1 X132.916 Y103.209 E.21398
G1 X132.782 Y103.075
G1 X132.782 Y103.608
G1 X132.916 Y103.742
G1 X137.79 Y108.616 E.21398
G1 X137.924 Y108.75
G1 X137.924 Y109.283
G1 X137.79 Y109.15
G1 X132.916 Y104.275 E.21398
G1 X132.782 Y104.142
G1 X132.782 Y104.675
G1 X132.916 Y104.808
G1 X137.79 Y109.683 E.21398
G1 X137.924 Y109.817
G1 X137.924 Y110.35
G1 X137.79 Y110.216
G1 X132.916 Y105.342 E.21398
G1 X132.782 Y105.208
G1 X132.782 Y105.741
G1 X132.916 Y105.875
G1 X137.79 Y110.749 E.21398
G1 X137.924 Y110.883
G1 X137.924 Y111.416
G1 X137.79 Y111.283
G1 X132.916 Y106.408 E.21398
G1 X132.782 Y106.275
G1 X132.782 Y106.808
G1 X132.916 Y106.941
G1 X137.79 Y111.816 E.21398
G1 X137.924 Y111.95
G1 X137.555 Y112.113
G1 X137.421 Y111.98
G1 X132.916 Y107.475 E.19776
G1 X132.782 Y107.341
G1 X132.782 Y107.874
G1 X132.916 Y108.008
G1 X136.888 Y111.98 E.17435
G1 X137.021 Y112.113
G1 X136.488 Y112.113
G1 X136.354 Y111.98
G1 X132.916 Y108.541 E.15094
G1 X132.782 Y108.408
G1 X132.782 Y108.941
G1 X132.916 Y109.074
G1 X135.821 Y111.98 E.12753
G1 X135.955 Y112.113
G1 X135.421 Y112.113
G1 X135.288 Y111.98
G1 X132.916 Y109.608 E.10412
G1 X132.782 Y109.474
G1 X132.782 Y110.007
G1 X132.916 Y110.141
G1 X134.755 Y111.98 E.08071
G1 X134.888 Y112.113
G1 X134.355 Y112.113
G1 X134.221 Y111.98
G1 X132.916 Y110.674 E.0573
G1 X132.782 Y110.541
G1 X132.782 Y111.074
G1 X132.916 Y111.208
G1 X133.688 Y111.98 E.03389
; WIPE_START
M204 S8000
G1 X132.981 Y111.273 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.134 J1.21 P1  F60000
G1 X139.227 Y110.581 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.55502
G1 F14645.578
M204 S8000
G1 X140.803 Y110.581 E.06646
M204 S10000
G1 X141.308 Y110.137 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X138.782 Y110.137 E.0784
G1 X138.782 Y111.026 E.0276
G1 X141.308 Y111.026 E.0784
G1 X141.308 Y110.197 E.02574
M204 S10000
M73 P56 R6
G1 X141.685 Y109.779 F60000
G1 F15000
M204 S8000
G2 X138.405 Y109.76 I-2.051 J69.843 E.10182
G1 X138.405 Y111.403 E.05101
G1 X141.685 Y111.403 E.10181
G1 X141.685 Y109.839 E.04855
; WIPE_START
G1 X141.685 Y110.839 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.156 J1.207 P1  F60000
G1 X164.098 Y107.95 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.36131
G1 F21000
M204 S8000
G3 X164.468 Y107.397 I1.895 J.871 E.01751
G1 X164.098 Y106.844 E.01744
G1 X164.098 Y107.89 E.02739
M204 S10000
G1 X163.735 Y108.597 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X164.177 Y108.597 E.01482
G1 X164.208 Y108.451 E.00503
G3 X164.978 Y107.397 I2.915 J1.321 E.04402
G3 X164.177 Y106.197 I2.593 J-2.596 E.04866
G1 X163.735 Y106.197 E.01482
G1 X163.735 Y108.537 E.07843
M204 S10000
G1 X163.328 Y109.004 F60000
G1 F18424.351
M204 S8000
G1 X164.498 Y109.004 E.0392
G1 X164.58 Y108.616 E.0133
G3 X165.624 Y107.397 I3.406 J1.86 E.05418
G3 X164.498 Y105.79 I1.473 J-2.231 E.06735
G1 X163.328 Y105.79 E.0392
G1 X163.328 Y108.944 E.10571
M204 S10000
G1 X162.921 Y109.411 F60000
G1 F18424.351
M204 S8000
G1 X164.818 Y109.411 E.06358
G3 X166.575 Y107.397 I2.357 J.283 E.09514
G3 X164.818 Y105.383 I.614 J-2.31 E.09506
G1 X162.921 Y105.383 E.06358
G1 X162.921 Y109.351 E.13299
M204 S10000
G1 X162.514 Y109.819 F60000
G1 F18424.351
M204 S8000
G1 X165.165 Y109.819 E.08886
G1 X165.324 Y108.947 E.02967
G3 X166.3 Y107.933 I2.338 J1.271 E.04774
; LINE_WIDTH: 0.474504
G1 F17377.872
G1 X166.517 Y107.846 E.00832
; LINE_WIDTH: 0.52353
G1 F15605.168
G1 X166.735 Y107.76 E.00927
; LINE_WIDTH: 0.588232
G1 F13753.597
G3 X167.119 Y107.67 I.311 J.465 E.01808
G1 X168.812 Y107.67 E.07599
G1 X168.812 Y107.124 E.0245
G3 X166.953 Y107.121 I-.846 J-49.953 E.08345
; LINE_WIDTH: 0.572557
G1 F14160.651
G1 X166.735 Y107.034 E.01022
; LINE_WIDTH: 0.52353
G1 F15605.168
G1 X166.517 Y106.948 E.00927
; LINE_WIDTH: 0.450566
G1 F18398.351
G3 X165.165 Y104.976 I.726 J-1.947 E.0855
G1 X162.514 Y104.976 E.08898
G1 X162.514 Y109.759 E.1605
M204 S10000
G1 X162.107 Y110.226 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X165.573 Y110.226 E.11614
G3 X166.482 Y108.297 I1.823 J-.319 E.07615
G3 X167.119 Y108.146 I.637 J1.274 E.02214
G1 X169.288 Y108.146 E.07269
G1 X169.288 Y106.648 E.05022
G1 X167.119 Y106.648 E.07269
G3 X165.573 Y105.101 I.069 J-1.616 E.08048
G1 X165.573 Y104.568 E.01785
G1 X162.107 Y104.568 E.11614
G1 X162.107 Y110.166 E.18756
M204 S10000
G1 X161.7 Y110.633 F60000
G1 F18424.351
M204 S8000
G1 X165.98 Y110.633 E.14342
G3 X166.068 Y109.279 I3.228 J-.47 E.0458
G3 X167.119 Y108.553 I1.18 J.586 E.04468
G1 X169.695 Y108.553 E.08633
G1 X169.695 Y106.241 E.0775
G1 X167.119 Y106.241 E.08633
G3 X165.98 Y105.101 I.115 J-1.254 E.05858
G1 X165.98 Y104.161 E.03149
G1 X161.7 Y104.161 E.14342
G1 X161.7 Y110.573 E.21484
M204 S10000
G1 X161.293 Y111.04 F60000
G1 F18424.351
M204 S8000
G1 X166.387 Y111.04 E.1707
G1 X166.387 Y109.693 E.04513
G3 X167.119 Y108.961 I.77 J.038 E.03805
G1 X170.102 Y108.961 E.09997
G1 X170.102 Y105.833 E.10479
G1 X167.119 Y105.833 E.09997
G3 X166.387 Y105.101 I.038 J-.77 E.03805
G1 X166.387 Y103.754 E.04513
G1 X161.293 Y103.754 E.1707
G1 X161.293 Y110.98 E.24212
M204 S10000
G1 X160.885 Y111.447 F60000
G1 F18424.351
M204 S8000
G1 X166.794 Y111.447 E.19798
G1 X166.794 Y109.693 E.05877
G3 X167.119 Y109.368 I.54 J.214 E.01585
G1 X170.509 Y109.368 E.11361
G1 X170.509 Y105.426 E.13207
G1 X167.119 Y105.426 E.11361
G3 X166.794 Y105.101 I.163 J-.489 E.01598
G1 X166.794 Y103.347 E.05877
G1 X160.885 Y103.347 E.19798
G1 X160.885 Y111.387 E.2694
M204 S10000
G1 X168.007 Y110.581 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.55502
G1 F14645.578
M204 S8000
G1 X169.584 Y110.581 E.06646
M204 S10000
G1 X167.563 Y110.137 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X167.563 Y111.026 E.0276
G1 X170.088 Y111.026 E.0784
G1 X170.088 Y110.137 E.0276
G1 X167.623 Y110.137 E.07653
M204 S10000
G1 X167.197 Y109.76 F60000
G1 F15000
M204 S8000
G2 X167.186 Y111.403 I59.74 J1.232 E.05101
G1 X170.466 Y111.403 E.10181
G1 X170.466 Y109.76 E.05101
G1 X167.257 Y109.76 E.09959
M204 S10000
G1 X168.007 Y104.213 F60000
; LINE_WIDTH: 0.55502
G1 F14645.578
M204 S8000
G1 X169.584 Y104.213 E.06646
M204 S10000
G1 X167.563 Y104.657 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X170.088 Y104.657 E.0784
G1 X170.088 Y103.768 E.0276
G1 X167.563 Y103.768 E.0784
G1 X167.563 Y104.597 E.02574
M204 S10000
G1 X167.186 Y105.023 F60000
G1 F15000
M204 S8000
G2 X170.466 Y105.034 I2.051 J-119.238 E.10181
G1 X170.466 Y103.391 E.05101
G1 X167.186 Y103.391 E.10181
G1 X167.186 Y104.963 E.0488
; WIPE_START
G1 X167.186 Y103.963 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.173 J1.205 P1  F60000
G1 X175.182 Y102.814 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F12000
M204 S2000
G1 X175.955 Y103.587 E.0339
G1 X176.088 Y103.72
G1 X176.088 Y104.254
G1 X175.955 Y104.12
G1 X174.649 Y102.814 E.05731
G1 X174.515 Y102.681
G1 X173.982 Y102.681
G1 X174.116 Y102.814
G1 X175.955 Y104.653 E.08072
G1 X176.088 Y104.787
G1 X176.088 Y105.32
G1 X175.955 Y105.186
G1 X173.583 Y102.814 E.10413
G1 X173.449 Y102.681
G1 X172.916 Y102.681
G1 X173.049 Y102.814
G1 X175.955 Y105.72 E.12754
G1 X176.088 Y105.853
G1 X176.088 Y106.387
G1 X175.955 Y106.253
G1 X172.516 Y102.814 E.15095
G1 X172.382 Y102.681
G1 X171.849 Y102.681
G1 X171.983 Y102.814
G1 X175.955 Y106.786 E.17435
G1 X176.088 Y106.92
G1 X176.088 Y107.453
G1 X175.955 Y107.319
G1 X171.45 Y102.814 E.19776
G1 X171.316 Y102.681
G1 X170.946 Y102.845
G1 X171.08 Y102.978
G1 X175.955 Y107.853 E.21398
G1 X176.088 Y107.986
G1 X176.088 Y108.52
G1 X175.955 Y108.386
G1 X171.08 Y103.511 E.21398
G1 X170.946 Y103.378
G1 X170.946 Y103.911
G1 X171.08 Y104.045
G1 X175.955 Y108.919 E.21398
G1 X176.088 Y109.053
G1 X176.088 Y109.586
G1 X175.955 Y109.452
G1 X171.08 Y104.578 E.21398
G1 X170.946 Y104.444
G1 X170.946 Y104.978
G1 X171.08 Y105.111
G1 X175.955 Y109.986 E.21398
G1 X176.088 Y110.119
G1 X176.088 Y110.653
G1 X175.955 Y110.519
G1 X171.08 Y105.645 E.21398
G1 X170.946 Y105.511
G1 X170.946 Y106.044
G1 X171.08 Y106.178
G1 X175.955 Y111.052 E.21398
G1 X176.088 Y111.186
G1 X176.088 Y111.719
G1 X175.955 Y111.585
G1 X171.08 Y106.711 E.21398
G1 X170.946 Y106.577
G1 X170.946 Y107.111
G1 X171.08 Y107.244
G1 X175.815 Y111.98 E.20787
G1 X175.949 Y112.113
G1 X175.416 Y112.113
G1 X175.282 Y111.98
G1 X171.08 Y107.778 E.18446
G1 X170.946 Y107.644
G1 X170.946 Y108.177
G1 X171.08 Y108.311
G1 X174.749 Y111.98 E.16106
G1 X174.883 Y112.113
G1 X174.349 Y112.113
G1 X174.216 Y111.98
G1 X171.08 Y108.844 E.13765
G1 X170.946 Y108.71
G1 X170.946 Y109.244
G1 X171.08 Y109.377
G1 X173.682 Y111.98 E.11424
G1 X173.816 Y112.113
G1 X173.283 Y112.113
G1 X173.149 Y111.98
G1 X171.08 Y109.911 E.09083
G1 X170.946 Y109.777
G1 X170.946 Y110.31
G1 X171.08 Y110.444
G1 X172.616 Y111.98 E.06742
G1 X172.75 Y112.113
G1 X172.216 Y112.113
G1 X172.083 Y111.98
G1 X171.08 Y110.977 E.04401
G1 X170.946 Y110.843
G1 X170.946 Y111.377
G1 X171.08 Y111.51
G1 X171.549 Y111.98 E.0206
; WIPE_START
M204 S8000
G1 X171.08 Y111.51 E-.25219
G1 X170.946 Y111.377 E-.07182
G1 X170.946 Y111.229 E-.05599
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U244 V110 Z1.4 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

M204 S10000
G1 X164.711 Y177.922
G1 Z1
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X165.211 Y178.922  
M204 S8000
G3  X162.752 Y180.967   I-4.377 J-2.762 E0.1236 F5400
G3  X160.093 Y179.711   I0.009 J-3.462 E0.1154
G2  X157.389 Y178.922   I-2.710 J4.259 E0.1085
G2  X145.343 Y178.926   I-5.928 J318.375 E0.4578
G2  X141.396 Y180.808   I0.501 J6.129 E0.1699
G3  X139.085 Y180.375   I-0.852 J-1.839 E0.0953
G3  X136.023 Y177.104   I16.406 J-18.427 E0.1705
G3  X136.857 Y174.149   I2.026 J-1.023 E0.1282
G2  X137.711 Y171.616   I-3.390 J-2.554 E0.1033
G2  X137.708 Y160.058   I-283.960 J-5.694 E0.4393
G2  X136.603 Y157.394   I-4.224 J0.190 E0.1118
G1 E-0.4000 F1800
M204 S10000
G1  X135.798 Y155.198   F600
G1 E0.4000 F1800
M204 S8000
G3  X136.200 Y154.520   I1.906 J0.672 E0.0302 F5400
G3  X139.318 Y151.258   I19.448 J15.469 E0.1717
G3  X142.516 Y151.916   I1.278 J1.891 E0.1383
G2  X145.533 Y152.922   I3.023 J-4.037 E0.1230
G1  X151.461  E0.2253
G1  X152.711  E0.0475
G2  X158.335 Y152.832   I2.339 J-29.659 E0.2141
G2  X161.670 Y150.974   I-2.882 J-9.098 E0.1461
G3  X163.837 Y151.469   I0.711 J1.877 E0.0895
G3  X166.899 Y154.740   I-16.399 J18.421 E0.1705
G3  X166.065 Y157.695   I-2.026 J1.023 E0.1282
G2  X165.211 Y160.228   I3.390 J2.554 E0.1033
G2  X165.214 Y171.786   I283.960 J5.694 E0.4393
G2  X167.057 Y175.351   I6.625 J-1.166 E0.1549
G3  X166.722 Y177.324   I-1.652 J0.734 E0.0806
G1  X165.211 Y178.922   E0.0836
; WIPE_TOWER_END
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
G1 E-.4 F1800
G17
G3 Z1.4 I1.217 J0 P1  F60000
G1 X138.461 Y153.672
G1 Z1
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF0 NF2 ON2 NN1
M632 S2 M N
M400
M104 T0 S180 N0
M106 S255
M633
M204 S8000
G1  X164.461 Y153.672  E2.0691 F7836
G1  Y155.172  E0.1194
G1  X138.461  E2.0691
M632 S2 M N
M204 S10000
G1  Y155.922 
G1  X163.961  F3000
G1  Y154.422 
G1  X138.961 
M633
; NOZZLE_CHANGE_END OF0 NF2 ON2 NN1

G1 E-2 F1800
G17
G3 Z1.4 I1.217 J0 P1  F5400
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

G1 Z4 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X136.211 Y156.422



M620.10 A0 F498.898 L0 H0.4 T240 P220 S1



M620.10 A1 F419.075 L0 H0.4 T240 P230 S1



M620.11 P1 I0 B-1 E-14 F623.623



M620.15 P180
M620.15 C220
M620.11 O1 T18


M620.11 K1 I0 B-1 R10 F623.623


M620.15 C220

M628 S1


M620.11 S1 L0 I0 B-1 R10 D8 E-14 F623.623


M629


;M620.11 H0




T2 H-1
M73 E3

;deretract


M73 P57 R6
;VG1 E4 F523
;VG1 E4 F261



; VFLUSH_START


;VG1 E0 F523


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
M73 P60 R6
G1 Z4 F3000

M204 S25


M621 S2A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F8.75 A0.4 R2
M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4

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
G1 X138.211 Y156.422 F60000
G1 Z1
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X141.211 Y156.422  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X136.711  F600
G1  X138.211  F240
G1  X138.711  F600
G1  Y156.922 
G1  X137.711 
G1  Y155.922 
G1  X139.211 
G1  Y157.422 
G1  X137.211 
G1  Y155.422 
G1  X141.211 Y156.422   F1782
M73 P60 R5
G1 E0.4000 F1800
M400
M104 T0 S230 N0
M204 S8000
G1  X164.711  E0.8931 F1782
G1  Y157.172  E0.0285
G1  X138.211  E1.0072 F2025
G1  Y157.922  E0.0285
G1  X164.711  E1.0072 F2473
G1  Y158.672  E0.0285
M73 P61 R5
G1  X138.211  E1.0072 F4725
G1  Y159.422  E0.0285
G1  X164.711  E1.0072 F4775
G1  Y160.172  E0.0285
G1  X138.211  E1.0072
G1  Y160.922  E0.0285
G1  X164.711  E1.0072
G1  Y161.672  E0.0285
G1  X138.211  E1.0072
G1  Y162.422  E0.0285
G1  X164.711  E1.0072
G1  Y163.172  E0.0285
G1  X138.211  E1.0072
G1  Y163.922  E0.0285
G1  X164.711  E1.0072
G1  Y164.672  E0.0285
G1  X138.211  E1.0072
G1  Y165.422  E0.0285
G1  X164.711  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y178.422   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S8000
G1  X138.211  E1.0072
G1  Y166.172  E0.4656
G1  X164.711  E1.0072
G1  Y178.422  E0.4656
M204 S10000
G1  X139.211 Y166.172  
;--------------------
; CP EMPTY GRID START
; layer #6
M204 S8000
G1  Y178.422  E0.4656
M204 S10000
G1  X147.378 
M204 S8000
G1  Y166.172  E0.4656
M204 S10000
G1  X155.544 
M204 S8000
G1  Y178.422  E0.4656
M204 S10000
G1  X163.711 
M204 S8000
G1  Y166.172  E0.4656
; CP EMPTY GRID END
;------------------






; WIPE_TOWER_END

; WIPE_START
G1 F12000
M204 S8000
G1 X163.711 Y167.172 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.217 J0 P1  F60000
; OBJECT_ID: 671
; COOLING_NODE: 0
M204 S10000
G1 X149.537 Y107.397
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F15476.087
M204 S8000
G1 X149.537 Y102.999 E.14887
G1 X150.858 Y102.999 E.04469
G1 X150.858 Y106.54 E.11987
G1 X154.213 Y109.896 E.16062
G1 X154.213 Y105.151 E.16062
G1 X152.061 Y102.999 E.10299
G1 X156.809 Y102.999 E.16071
G1 X154.658 Y105.151 E.10299
G1 X154.658 Y109.896 E.16062
G1 X158.013 Y106.54 E.16062
G1 X158.013 Y102.999 E.11987
G1 X159.333 Y102.999 E.04469
G1 X159.333 Y111.795 E.29773
G1 X149.537 Y111.795 E.33158
G1 X149.537 Y107.457 E.14683
; COOLING_NODE: 0
M204 S250
G1 X149.145 Y107.397 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X149.145 Y102.607 E.15019
G1 X159.725 Y102.607 E.33173
G1 X159.725 Y112.187 E.30037
G1 X149.145 Y112.187 E.33173
G1 X149.145 Y107.457 E.14831
; WIPE_START
M204 S8000
G1 X149.145 Y106.457 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.107 J.506 P1  F60000
G1 X150.426 Y103.659 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.49952
G1 F12000
M204 S8000
G1 X150.426 Y103.431 E.00867
G1 X149.969 Y103.431 E.01734
G1 X149.969 Y103.943 E.01946
G1 X150.426 Y104.4 E.02452
G1 X150.426 Y103.719 E.02585
; WIPE_START
G1 X150.426 Y104.4 E-.25874
G1 X150.2 Y104.174 E-.12126
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.921 J.795 P1  F60000
G1 X151.267 Y102.939 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.40912
G1 F12000
M204 S8000
G1 X151.199 Y102.979 E.00241
G1 X151.255 Y103.011 E.00198
; WIPE_START
G1 X151.199 Y102.979 E-.17129
G1 X151.267 Y102.939 E-.20871
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.621 J1.047 P1  F60000
G1 X154.435 Y104.818 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X155.863 Y103.391 E.06329
G1 X153.008 Y103.391 E.08951
G1 X154.393 Y104.776 E.06141
M204 S10000
G1 X154.435 Y104.267 F60000
; LINE_WIDTH: 0.44561
G1 F15000
M204 S8000
G1 X154.921 Y103.781 E.02302
G1 X153.949 Y103.781 E.03255
G1 X154.393 Y104.225 E.02101
; WIPE_START
G1 X153.949 Y103.781 E-.23843
G1 X154.322 Y103.781 E-.14157
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-1.198 J-.216 P1  F60000
G1 X153.99 Y105.619 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F12000
M204 S2000
G1 X151.464 Y103.093 E.11202
G1 X151.331 Y102.959
G1 X150.992 Y103.154
G1 X151.126 Y103.288
G1 X153.99 Y106.152 E.12702
G1 X154.124 Y106.286
G1 X154.124 Y106.819
G1 X153.99 Y106.686
M73 P62 R5
G1 X151.08 Y103.775 E.12905
G1 X150.946 Y103.642
G1 X150.946 Y104.175
G1 X151.08 Y104.309
G1 X153.99 Y107.219 E.12905
G1 X154.124 Y107.353
G1 X154.124 Y107.886
G1 X153.99 Y107.752
G1 X151.08 Y104.842 E.12905
G1 X150.946 Y104.708
G1 X150.946 Y105.241
G1 X151.08 Y105.375
G1 X153.99 Y108.285 E.12905
G1 X154.124 Y108.419
G1 X153.856 Y108.684
G1 X153.722 Y108.55
G1 X151.08 Y105.908 E.11715
; WIPE_START
M204 S8000
G1 X151.787 Y106.615 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.619 J1.048 P1  F60000
G1 X154.009 Y105.303 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.139228
G1 F15000
M204 S8000
G1 X151.727 Y103.021 E.02584
; WIPE_START
G1 X152.434 Y103.728 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-1.194 J.238 P1  F60000
G1 X153.417 Y108.662 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.254968
G1 F15000
M204 S8000
G1 X151.061 Y106.306 E.05874
; WIPE_START
G1 X151.768 Y107.013 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-1.066 J.588 P1  F60000
G1 X152.914 Y109.089 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45576
G1 F15260.165
M204 S8000
G2 X150.564 Y106.75 I-410.307 J409.774 E.11383
; LINE_WIDTH: 0.488075
G1 F14152.373
G1 X150.509 Y106.675 E.00341
; LINE_WIDTH: 0.557823
G1 F12235.329
G1 X150.455 Y106.6 E.00395
G1 X150.455 Y105.042 E.06674
G1 X150.353 Y105.015 E.00451
G1 X149.94 Y104.601 E.02504
G1 X149.94 Y106.6 E.08559
; LINE_WIDTH: 0.534905
G1 F12805.268
G1 X149.916 Y106.814 E.00879
; LINE_WIDTH: 0.488075
G1 F14152.373
G1 X149.893 Y107.027 E.00795
; LINE_WIDTH: 0.451963
G1 F15401.814
G2 X149.886 Y111.447 I784.165 J3.514 E.15031
G1 X152.847 Y111.447 E.10073
G1 X152.88 Y109.139 E.0785
M204 S10000
G1 X152.44 Y109.191 F60000
; LINE_WIDTH: 0.44999
G1 F15476.455
M204 S8000
G1 X150.293 Y107.044 E.10279
G1 X150.293 Y111.04 E.13525
G1 X152.44 Y111.04 E.07268
G1 X152.44 Y109.251 E.06054
M204 S10000
G1 X152.033 Y109.36 F60000
G1 F15476.455
M204 S8000
G1 X150.7 Y108.026 E.06382
G1 X150.7 Y110.633 E.08821
G1 X152.033 Y110.633 E.04513
G1 X152.033 Y109.42 E.04105
M204 S10000
G1 X151.598 Y109.54 F60000
; LINE_WIDTH: 0.50597
G1 F13605.442
M204 S8000
G1 X151.135 Y109.077 E.02521
G1 X151.135 Y110.197 E.04315
G1 X151.598 Y110.197 E.01783
G1 X151.598 Y109.6 E.02301
; WIPE_START
G1 X151.598 Y110.197 E-.2271
G1 X151.195 Y110.197 E-.1529
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.588 J1.066 P1  F60000
G1 X153.796 Y108.763 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.53048
G1 F12921.488
M204 S8000
G2 X153.796 Y108.868 I-.025 J.052 E.00948
; WIPE_START
G1 X153.735 Y108.868 E-.09556
G1 X153.705 Y108.816 E-.09481
G1 X153.735 Y108.763 E-.09481
G1 X153.796 Y108.763 E-.09481
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I0 J1.217 P1  F60000
G1 X155.135 Y108.763 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.53046
G1 F12922.017
M204 S8000
G2 X155.136 Y108.868 I-.025 J.052 E.00948
M204 S10000
G1 X155.957 Y109.089 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.451951
G1 F15402.27
M204 S8000
G1 X156.023 Y109.189 E.00409
G1 X156.023 Y111.447 E.07678
G1 X158.985 Y111.447 E.10072
G2 X158.978 Y107.027 I-785.238 J-.905 E.15031
; LINE_WIDTH: 0.488075
G1 F14152.373
G1 X158.954 Y106.814 E.00795
; LINE_WIDTH: 0.557193
G1 F12250.301
G3 X158.931 Y104.601 I43.493 J-1.567 E.09463
G1 X158.517 Y105.015 E.02501
G1 X158.415 Y105.042 E.0045
G1 X158.415 Y106.6 E.06666
; LINE_WIDTH: 0.534905
G1 F12805.268
G1 X158.361 Y106.675 E.00377
; LINE_WIDTH: 0.488075
G1 F14152.373
G1 X158.307 Y106.75 E.00341
; LINE_WIDTH: 0.455866
G1 F15256.237
G2 X155.999 Y109.047 I404.68 J408.818 E.1118
M204 S10000
G1 X156.431 Y109.191 F60000
; LINE_WIDTH: 0.44999
G1 F15476.455
M204 S8000
G1 X156.431 Y111.04 E.06257
G1 X158.578 Y111.04 E.07268
G1 X158.578 Y107.044 E.13525
G1 X156.473 Y109.149 E.10076
M204 S10000
G1 X156.838 Y109.36 F60000
G1 F15476.455
M204 S8000
G1 X156.838 Y110.633 E.04309
G1 X158.171 Y110.633 E.04513
G1 X158.171 Y108.026 E.08821
G1 X156.88 Y109.317 E.06179
M204 S10000
G1 X157.273 Y109.54 F60000
; LINE_WIDTH: 0.50597
G1 F13605.442
M204 S8000
G1 X157.273 Y110.197 E.02532
G1 X157.736 Y110.197 E.01783
G1 X157.736 Y109.077 E.04315
G1 X157.315 Y109.497 E.0229
M204 S10000
G1 X155.255 Y110.385 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41863
G1 F15000
M204 S8000
G1 X154.835 Y110.805 E.01857
; LINE_WIDTH: 0.434785
G1 X154.687 Y110.9 E.00572
; LINE_WIDTH: 0.454943
G1 X154.538 Y110.994 E.00602
G1 X155.067 Y111.026 E.01815
; LINE_WIDTH: 0.41862
G1 X155.255 Y111.026 E.00587
G1 X155.255 Y110.445 E.01816
M204 S10000
G1 X153.615 Y110.385 F60000
; LINE_WIDTH: 0.41863
G1 F15000
M204 S8000
G1 X153.615 Y111.026 E.02004
; LINE_WIDTH: 0.432533
G1 X154.025 Y111.013 E.01329
; LINE_WIDTH: 0.453113
G1 X154.435 Y110.999 E.01399
G1 X154.036 Y110.805 E.01514
; LINE_WIDTH: 0.41863
G1 X153.658 Y110.428 E.01669
M204 S10000
G1 X153.239 Y109.476 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X153.239 Y111.403 E.0604
G1 X155.631 Y111.403 E.07501
G1 X155.631 Y109.476 E.0604
G1 X154.569 Y110.539 E.04713
G1 X154.435 Y110.594 E.00452
G1 X154.302 Y110.539 E.00452
G1 X153.282 Y109.519 E.04525
; WIPE_START
G1 X153.989 Y110.226 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.123 J.468 P1  F60000
G1 X156.913 Y103.209 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F12000
M204 S2000
G1 X157.79 Y104.087 E.03889
G1 X157.924 Y104.22
G1 X157.924 Y104.753
G1 X157.79 Y104.62
G1 X156.647 Y103.476 E.05071
G1 X156.513 Y103.342
G1 X156.246 Y103.609
G1 X156.38 Y103.743
G1 X157.79 Y105.153 E.06254
G1 X157.924 Y105.287
G1 X157.924 Y105.82
G1 X157.79 Y105.686
G1 X156.113 Y104.009 E.07436
G1 X155.98 Y103.876
G1 X155.713 Y104.142
G1 X155.847 Y104.276
G1 X157.79 Y106.22 E.08618
G1 X157.924 Y106.353
G1 X157.772 Y106.734
G1 X157.638 Y106.601
G1 X155.58 Y104.543 E.09125
G1 X155.447 Y104.409
G1 X155.18 Y104.676
G1 X155.314 Y104.809
G1 X157.372 Y106.867 E.09125
G1 X157.505 Y107.001
G1 X157.239 Y107.267
G1 X157.105 Y107.134
G1 X155.047 Y105.076 E.09125
G1 X154.913 Y104.942
G1 X154.746 Y105.309
G1 X154.88 Y105.442
G1 X156.838 Y107.4 E.08683
G1 X156.972 Y107.534
G1 X156.705 Y107.801
G1 X156.572 Y107.667
G1 X154.88 Y105.975 E.07501
G1 X154.746 Y105.842
G1 X154.746 Y106.375
G1 X154.88 Y106.509
G1 X156.305 Y107.934 E.06318
G1 X156.439 Y108.067
G1 X156.172 Y108.334
G1 X156.038 Y108.2
G1 X154.88 Y107.042 E.05136
G1 X154.746 Y106.908
G1 X154.746 Y107.442
G1 X154.88 Y107.575
G1 X155.772 Y108.467 E.03954
G1 X155.905 Y108.601
G1 X155.541 Y108.77
G1 X155.407 Y108.636
G1 X154.88 Y108.109 E.02338
; WIPE_START
M204 S8000
G1 X155.407 Y108.636 E-.28341
G1 X155.541 Y108.77 E-.07182
G1 X155.6 Y108.742 E-.02477
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.119 J.478 P1  F60000
G1 X157.809 Y103.566 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.394406
G1 F15000
M204 S8000
G2 X157.455 Y103.262 I-2.5 J2.555 E.01365
; LINE_WIDTH: 0.342721
G1 X157.09 Y103.016 E.01098
M204 S10000
G1 X157.651 Y102.937 F60000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.40516
G1 F12000
M204 S8000
G1 X157.583 Y102.977 E.00236
G1 X157.638 Y103.009 E.00192
; WIPE_START
G1 X157.583 Y102.977 E-.17031
G1 X157.651 Y102.937 E-.20969
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.608 J1.054 P1  F60000
G1 X158.901 Y103.659 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.49952
G1 F12000
M204 S8000
G1 X158.901 Y103.431 E.00867
G1 X158.445 Y103.431 E.01734
G1 X158.445 Y104.4 E.0368
G1 X158.901 Y103.943 E.02452
G1 X158.901 Y103.719 E.00851
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F12000
G1 X158.901 Y103.943 E-.08522
G1 X158.445 Y104.4 E-.24538
G1 X158.445 Y104.27 E-.0494
; WIPE_END
G1 E-.02 F1800
; layer num/total_layer_count: 6/14
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
M204 S10000
G17
G3 Z1.4 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U244 V110 Z1.6 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #4
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
M204 S10000
G1 X138.461 Y153.672
G1 Z1.2
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF2 NF0 ON1 NN2
M632 S0 M N
M400
M104 T0 S180 N0
M106 S255
M633
M204 S8000
G1  X164.461 Y153.672  E2.0691 F6583
G1  Y155.172  E0.1194
G1  X138.461  E2.0691
M632 S0 M N
M204 S10000
G1  Y155.922 
G1  X163.961  F3000
G1  Y154.422 
G1  X138.961 
M633
; NOZZLE_CHANGE_END OF2 NF0 ON1 NN2

G1 E-2 F1800
G17
G3 Z1.6 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O5
M620 S0A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4.2 F1200
M632 S1 W
M400
M104 T1 S140 N0 ;Multi extruder pre heating
M633

M400
M106 P1 S0
M106 P2 S0




    M620.14 X166.711 Y165.422



M620.10 A0 F419.075 L0 H0.4 T240 P230 S1



M620.10 A1 F498.898 L0 H0.4 T240 P220 S1



M620.11 P1 I2 B-1 E-14 F523.843



M620.15 P180
M620.15 C210
M620.11 O1 T18


M620.11 K1 I2 B-1 R10 F523.843


M620.15 C210

M628 S1


M620.11 S1 L0 I2 B-1 R10 D8 E-14 F523.843


M629


;M620.11 H0




T0 H-1
M73 E2

;deretract


;VG1 E4 F623
;VG1 E4 F311



; VFLUSH_START


;VG1 E0 F523


SYNC T0

; compensate for heating and cooling


; VFLUSH_END

M1002 set_filament_type:PLA

M400
M83



M620.10 R2


M628 S0

;VM109 S220

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F10.4167 A0.4 R2


M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
M73 P66 R5
G1 Z4.2 F3000

M204 S25


M621 S0A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.2

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I0 H-1 W1 ;enable ams air printing detect
M620 O5
M1002 gcode_claim_action : 0
M106 S160.65
M106 P2 S191

; filament start gcode
G1 X164.711 Y165.422 F60000
G1 Z1.2
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X161.711 Y165.422  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X166.211  F600
G1  X164.711  F240
G1  X165.211  F600
G1  Y165.922 
G1  X164.211 
G1  Y164.922 
G1  X165.711 
G1  Y166.422 
G1  X163.711 
G1  Y164.422 
G1  X161.711 Y165.422   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X138.211  E0.8931 F1782
G1  Y164.672  E0.0285
G1  X164.711  E1.0072 F2025
G1  Y163.922  E0.0285
G1  X138.211  E1.0072 F2473
G1  Y163.172  E0.0285
G1  X164.711  E1.0072 F4725
G1  Y162.422  E0.0285
G1  X138.211  E1.0072 F4775
G1  Y161.672  E0.0285
G1  X164.711  E1.0072
G1  Y160.922  E0.0285
G1  X138.211  E1.0072
G1  Y160.172  E0.0285
G1  X164.711  E1.0072
G1  Y159.422  E0.0285
M73 P67 R5
G1  X138.211  E1.0072
G1  Y158.672  E0.0285
G1  X164.711  E1.0072
G1  Y157.922  E0.0285
G1  X138.211  E1.0072
G1  Y157.172  E0.0285
G1  X164.711  E1.0072
G1  Y156.422  E0.0285
G1  X138.211  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  X164.711 Y177.922   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X165.061 Y179.080  
M204 S8000
G3  X162.283 Y180.999   I-3.470 J-2.054 E0.1324
G3  X159.930 Y179.612   I1.442 J-5.134 E0.1049
G2  X157.389 Y178.922   I-2.569 J4.438 E0.1012
G2  X145.343 Y178.926   I-5.928 J318.375 E0.4578
M73 P67 R4
G2  X141.396 Y180.808   I0.501 J6.129 E0.1699
G3  X139.085 Y180.375   I-0.852 J-1.839 E0.0953
G3  X136.023 Y177.104   I16.406 J-18.427 E0.1705
G3  X136.857 Y174.149   I2.026 J-1.023 E0.1282
G2  X137.711 Y171.616   I-3.390 J-2.554 E0.1033
G2  X137.708 Y160.058   I-283.960 J-5.694 E0.4393
G2  X135.865 Y156.493   I-6.625 J1.166 E0.1549
G3  X136.200 Y154.520   I1.652 J-0.734 E0.0806
G3  X139.318 Y151.258   I19.448 J15.469 E0.1717
G3  X142.516 Y151.916   I1.278 J1.891 E0.1383
G2  X145.533 Y152.922   I3.023 J-4.037 E0.1230
G1  X151.461  E0.2253
G1  X152.711  E0.0475
G2  X158.335 Y152.832   I2.339 J-29.659 E0.2141
G2  X161.670 Y150.974   I-2.882 J-9.098 E0.1461
G3  X163.837 Y151.469   I0.711 J1.877 E0.0895
G3  X166.899 Y154.740   I-16.399 J18.421 E0.1705
G3  X166.065 Y157.695   I-2.026 J1.023 E0.1282
G2  X165.211 Y160.228   I3.390 J2.554 E0.1033
G1  Y164.172  E0.1499
G1 E-0.4000 F1800
M204 S10000
G1  Y166.672  F600
G1 E0.4000 F1800
M204 S8000
G2  X165.266 Y172.294   I34.504 J2.472 E0.2139 F5400
G2  X167.057 Y175.351   I6.530 J-1.771 E0.1363
G3  X166.776 Y177.261   I-1.648 J0.734 E0.0774
; WIPE_TOWER_END

; WIPE_START
G1 F12000
M204 S8000
G1 X166.815 Y177.218 E-.02219
G1 X166.899 Y177.105 E-.05374
G1 X166.974 Y176.985 E-.05373
G1 X167.04 Y176.86 E-.05373
G1 X167.095 Y176.73 E-.05373
G1 X167.141 Y176.596 E-.05373
G1 X167.175 Y176.458 E-.05374
G1 X167.191 Y176.367 E-.0354
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.217 J0 P1  F60000
; OBJECT_ID: 671
; COOLING_NODE: 0
M204 S10000
G1 X148.333 Y104.999
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X148.333 Y109.795 E.16071
G1 X137.537 Y109.795 E.36177
G1 X137.537 Y104.999 E.16071
G1 X148.273 Y104.999 E.35976
; COOLING_NODE: 0
M204 S250
G1 X148.725 Y104.607 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X148.725 Y110.187 E.17321
G1 X137.145 Y110.187 E.35945
G1 X137.145 Y104.607 E.17321
G1 X148.665 Y104.607 E.35759
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X148.676 Y105.607 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-.552 J1.085 P1  F60000
G1 X152.587 Y107.597 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X152.858 Y107.868 E.01283
G1 X152.858 Y111.795 E.1316
G1 X152.537 Y111.795 E.01073
G1 X152.537 Y107.548 E.14233
G1 X152.544 Y107.555 E.00033
; COOLING_NODE: 0
; WIPE_START
G1 X152.858 Y107.868 E-.16834
G1 X152.858 Y108.425 E-.21166
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.217 J0 P1  F60000
G1 X152.858 Y103.459 Z1.6
G1 Z1.2
G1 E.4 F1800
G1 F6000
M204 S8000
G1 X152.858 Y104.468 E.03382
G1 X152.537 Y104.148 E.01518
G1 X152.537 Y102.999 E.03849
G1 X152.858 Y102.999 E.01073
G1 X152.858 Y103.399 E.01339
; COOLING_NODE: 0
; WIPE_START
G1 X152.858 Y104.399 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I.318 J1.175 P1  F60000
G1 X156.333 Y103.459 Z1.6
G1 Z1.2
G1 E.4 F1800
G1 F6000
M204 S8000
G1 X156.333 Y104.148 E.02309
G1 X156.013 Y104.468 E.01518
G1 X156.013 Y102.999 E.04922
G1 X156.333 Y102.999 E.01073
G1 X156.333 Y103.399 E.01339
; COOLING_NODE: 0
; WIPE_START
G1 X156.333 Y104.148 E-.28466
G1 X156.156 Y104.325 E-.09535
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-1.215 J.067 P1  F60000
G1 X156.333 Y107.548 Z1.6
G1 Z1.2
G1 E.4 F1800
G1 F6000
M204 S8000
G1 X156.333 Y111.795 E.14233
G1 X156.013 Y111.795 E.01073
G1 X156.013 Y107.868 E.1316
G1 X156.291 Y107.59 E.01317
; COOLING_NODE: 0
; WIPE_START
G1 X156.301 Y108.59 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.213 J.1 P1  F60000
G1 X156.725 Y103.459 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X156.725 Y104.31 E.02643
G1 X155.525 Y105.51 E.05268
G1 X155.525 Y107.801 E.07111
G1 X156.725 Y106.601 E.05268
G1 X156.725 Y112.187 E.17339
G1 X152.145 Y112.187 E.14217
G1 X152.145 Y106.601 E.17339
G1 X153.345 Y107.801 E.05268
G1 X153.345 Y105.51 E.07111
G1 X152.145 Y104.31 E.05268
G1 X152.145 Y102.607 E.05286
G1 X156.725 Y102.607 E.14217
G1 X156.725 Y103.399 E.02457
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X156.725 Y104.31 E-.34637
G1 X156.663 Y104.373 E-.03363
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-.194 J1.201 P1  F60000
G1 X160.537 Y104.999 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X171.333 Y104.999 E.36177
G1 X171.333 Y109.795 E.16071
G1 X160.537 Y109.795 E.36177
G1 X160.537 Y105.059 E.1587
; COOLING_NODE: 0
M204 S250
G1 X160.145 Y104.607 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X171.725 Y104.607 E.35945
G1 X171.725 Y110.187 E.17321
G1 X160.145 Y110.187 E.35945
G1 X160.145 Y104.667 E.17135
; WIPE_START
M204 S8000
G1 X161.145 Y104.662 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-1.018 J.666 P1  F60000
G1 X162.935 Y107.397 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.47884
G1 F17204.992
M204 S8000
G1 X168.875 Y107.397 E.21315
M204 S10000
G1 X162.514 Y107.819 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X169.357 Y107.819 E.22931
G1 X169.357 Y106.976 E.02825
G1 X162.514 Y106.976 E.22931
G1 X162.514 Y107.759 E.02624
M204 S10000
G1 X162.107 Y108.226 F60000
G1 F18424.351
M204 S8000
G1 X169.764 Y108.226 E.25659
G1 X169.764 Y106.568 E.05553
G1 X162.107 Y106.568 E.25659
G1 X162.107 Y108.166 E.05352
M204 S10000
G1 X161.7 Y108.633 F60000
G1 F18424.351
M204 S8000
G1 X170.171 Y108.633 E.28387
G1 X170.171 Y106.161 E.08281
G1 X161.7 Y106.161 E.28387
G1 X161.7 Y108.573 E.0808
M204 S10000
G1 X161.293 Y109.04 F60000
M73 P68 R4
G1 F18424.351
M204 S8000
G1 X170.578 Y109.04 E.31115
G1 X170.578 Y105.754 E.11009
G1 X161.293 Y105.754 E.31115
G1 X161.293 Y108.98 E.10808
M204 S10000
G1 X160.885 Y109.447 F60000
G1 F18424.351
M204 S8000
G1 X170.985 Y109.447 E.33843
G1 X170.985 Y105.347 E.13737
G1 X160.885 Y105.347 E.33843
G1 X160.885 Y109.387 E.13536
; WIPE_START
G1 X160.885 Y108.387 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-.628 J-1.043 P1  F60000
G1 X154.919 Y111.98 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F12000
M204 S2000
G1 X155.79 Y111.108 E.03828
G1 X155.924 Y110.974
G1 X155.924 Y110.441
G1 X155.79 Y110.574
G1 X154.385 Y111.98 E.06168
G1 X154.252 Y112.113
G1 X153.718 Y112.113
G1 X153.852 Y111.98
G1 X155.79 Y110.041 E.08509
G1 X155.924 Y109.908
G1 X155.924 Y109.374
G1 X155.79 Y109.508
G1 X153.319 Y111.98 E.1085
G1 X153.185 Y112.113
G1 X152.946 Y111.819
G1 X153.08 Y111.685
G1 X155.79 Y108.975 E.11898
G1 X155.924 Y108.841
G1 X155.924 Y108.308
G1 X155.79 Y108.441
G1 X153.08 Y111.152 E.11898
G1 X152.946 Y111.285
G1 X152.946 Y110.752
G1 X153.08 Y110.619
G1 X155.79 Y107.908 E.11898
G1 X155.924 Y107.775
G1 X155.452 Y107.714
G1 X155.318 Y107.847
G1 X153.08 Y110.085 E.09824
G1 X152.946 Y110.219
G1 X152.946 Y109.686
G1 X153.08 Y109.552
G1 X155.318 Y107.314 E.09824
G1 X155.452 Y107.181
G1 X155.452 Y106.647
G1 X155.318 Y106.781
G1 X153.08 Y109.019 E.09824
G1 X152.946 Y109.152
G1 X152.946 Y108.619
G1 X153.08 Y108.485
G1 X153.408 Y108.157 E.01441
G1 X153.553 Y108.013
G1 X155.318 Y106.248 E.07749
G1 X155.452 Y106.114
G1 X155.452 Y105.581
G1 X155.318 Y105.714
G1 X153.553 Y107.48 E.07749
G1 X153.419 Y107.613
G1 X153.419 Y107.08
G1 X153.553 Y106.946
G1 X155.79 Y104.709 E.09824
G1 X155.924 Y104.575
G1 X155.924 Y104.042
G1 X155.79 Y104.175
G1 X153.553 Y106.413 E.09824
G1 X153.419 Y106.547
G1 X153.419 Y106.014
G1 X153.553 Y105.88
G1 X155.79 Y103.642 E.09824
G1 X155.924 Y103.508
G1 X155.924 Y102.975
G1 X155.79 Y103.109
G1 X153.514 Y105.385 E.09994
G1 X153.38 Y105.519
G1 X153.114 Y105.252
G1 X153.247 Y105.119
G1 X155.552 Y102.814 E.10116
G1 X155.685 Y102.681
G1 X155.152 Y102.681
G1 X155.018 Y102.814
G1 X153.08 Y104.753 E.08509
G1 X152.946 Y104.886
G1 X152.946 Y104.353
G1 X153.08 Y104.219
G1 X154.485 Y102.814 E.06168
G1 X154.619 Y102.681
G1 X154.086 Y102.681
G1 X153.952 Y102.814
G1 X153.08 Y103.686 E.03827
; WIPE_START
M204 S8000
G1 X153.787 Y102.979 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-.37 J-1.159 P1  F60000
G1 X139.935 Y107.397 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.47884
G1 F17204.992
M204 S8000
G1 X145.875 Y107.397 E.21315
M204 S10000
G1 X146.357 Y107.397 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X146.357 Y106.976 E.01412
G1 X139.514 Y106.976 E.22931
G1 X139.514 Y107.819 E.02825
G1 X146.357 Y107.819 E.22931
G1 X146.357 Y107.457 E.01211
M204 S10000
G1 X146.764 Y107.397 F60000
G1 F18424.351
M204 S8000
G1 X146.764 Y106.568 E.02776
G1 X139.107 Y106.568 E.25659
G1 X139.107 Y108.226 E.05553
G1 X146.764 Y108.226 E.25659
G1 X146.764 Y107.457 E.02575
M204 S10000
G1 X147.171 Y107.397 F60000
G1 F18424.351
M204 S8000
G1 X147.171 Y106.161 E.04141
G1 X138.7 Y106.161 E.28387
G1 X138.7 Y108.633 E.08281
G1 X147.171 Y108.633 E.28387
G1 X147.171 Y107.457 E.0394
M204 S10000
G1 X147.578 Y107.397 F60000
G1 F18424.351
M204 S8000
G1 X147.578 Y105.754 E.05505
G1 X138.293 Y105.754 E.31115
G1 X138.293 Y109.04 E.11009
G1 X147.578 Y109.04 E.31115
G1 X147.578 Y107.457 E.05304
M204 S10000
G1 X147.985 Y107.397 F60000
G1 F18424.351
M204 S8000
G1 X147.985 Y105.347 E.06869
G1 X137.885 Y105.347 E.33843
G1 X137.885 Y109.447 E.13737
G1 X147.985 Y109.447 E.33843
G1 X147.985 Y107.457 E.06668
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
G1 X147.985 Y108.457 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.217 J0 P1  F60000
G1 X138.461 Y166.422
G1 Z1.2
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF0 NF1 ON2 NN0
M204 S8000
G1  X164.461 Y166.422  E2.0691 F7836
G1  Y167.922  E0.1194
G1  X138.461  E2.0691
; NOZZLE_CHANGE_END OF0 NF1 ON2 NN0
M400
M104 T0 S25 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S8000
G1 X139.461 Y167.922 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S10000
G17
G3 Z1.6 I1.217 J0 P1  F5400
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

G1 Z4.2 F1200

M400
; Turn the fans off
M106 P1 S0
M106 P2 S0

M628 S1


M629

;M620.11 H0


T1 H-1
M73 E1

;deretract


;VG1 E4 F623
;VG1 E4 F311



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
M73 P70 R4
G1 X170.213 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.2 F3000

M204 S8000


M621 S1A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R0
M400

G387 Y320 J1 F10000
G1 X170.213 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.2 F3000

M204 S8000

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I1 H-1 W1 ;enable ams air printing detect
M620 O6
M1002 gcode_claim_action : 0
M106 S58.65
M106 P2 S102
G1 E-.4 F1800
G1 X169.213 Y178.172 F600
M204 S1000
G1 Z1.2

; filament start gcode
M109 S145;
G17
G3 Z1.6 I0 J-1.217 P1
G1 X164.711 Y178.172 Z1.6
G1 Z1.2
G1 E.6 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S25
M73 P71 R4
G1  X161.711 Y178.172  E0.1140 F1782
G1 E-0.4000 F1800
M204 S1000
G1  X166.211  F600
G1  X164.711  F240
G1  X165.211  F600
G1  Y178.672 
G1  X164.211 
G1  Y177.672 
G1  X165.711 
G1  Y179.172 
G1  X163.711 
G1  Y177.172 
G1  X161.711 Y178.172   F1782
G1 E0.4000 F1800
M400
M104 T1 S150 N0
M204 S25
G1  X138.211  E0.8931 F1782
G1  Y177.422  E0.0285
G1  X164.711  E1.0072 F2025
G1  Y176.672  E0.0285
G1  X138.211  E1.0072 F2473
G1  Y175.922  E0.0285
G1  X164.711  E1.0072 F4725
G1  Y175.172  E0.0285
G1  X138.211  E1.0072 F4775
G1  Y174.422  E0.0285
M73 P72 R4
G1  X164.711  E1.0072
G1  Y173.672  E0.0285
G1  X138.211  E1.0072
G1  Y172.922  E0.0285
G1  X164.711  E1.0072
G1  Y172.172  E0.0285
G1  X138.211  E1.0072
G1  Y171.422  E0.0285
G1  X164.711  E1.0072
G1  Y170.672  E0.0285
G1  X138.211  E1.0072
G1  Y169.922  E0.0285
M73 P73 R4
G1  X164.711  E1.0072
G1  Y169.172  E0.0285
G1  X138.211  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------



; WIPE_START
G1 F5400
M204 S25
G1 X139.211 Y169.172 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I1.217 J0 P1  F600
; OBJECT_ID: 671
; COOLING_NODE: 0
M204 S1000
G1 X159.333 Y103.795
G1 Z1.2
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
M73 P74 R3
G1 X159.333 Y110.999 E.24141
G1 X171.333 Y110.999 E.40212
G1 X171.333 Y111.795 E.02667
G1 X157.537 Y111.795 E.4623
G1 X157.537 Y102.999 E.29475
G1 X171.333 Y102.999 E.4623
G1 X171.333 Y103.795 E.02667
G1 X159.393 Y103.795 E.40011
; COOLING_NODE: 0
G1 X159.725 Y104.187
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P75 R3
G1 X159.725 Y110.607 E.19928
G1 X171.725 Y110.607 E.37249
G1 X171.725 Y112.187 E.04904
G1 X157.145 Y112.187 E.45257
G1 X157.145 Y102.607 E.29737
G1 X171.725 Y102.607 E.45257
G1 X171.725 Y104.187 E.04904
G1 X159.785 Y104.187 E.37063
; COOLING_NODE: 0
; WIPE_START
G1 X159.776 Y105.187 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I.164 J-1.206 P1  F600
G1 X149.537 Y103.795 Z1.6
G1 Z1.2
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P76 R3
G1 F600
M204 S25
G1 X137.537 Y103.795 E.40212
G1 X137.537 Y102.999 E.02667
G1 X151.333 Y102.999 E.4623
G1 X151.333 Y111.795 E.29475
G1 X137.537 Y111.795 E.4623
G1 X137.537 Y110.999 E.02667
G1 X149.537 Y110.999 E.40212
G1 X149.537 Y103.855 E.2394
; COOLING_NODE: 0
G1 X149.145 Y104.187
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X137.145 Y104.187 E.37249
G1 X137.145 Y102.607 E.04904
G1 X151.725 Y102.607 E.45257
G1 X151.725 Y112.187 E.29737
M73 P77 R3
G1 X137.145 Y112.187 E.45257
G1 X137.145 Y110.607 E.04904
G1 X149.145 Y110.607 E.37249
G1 X149.145 Y104.247 E.19742
M204 S1000
G1 X149.741 Y103.397
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M204 S25
G1 X137.741 Y103.397 E.38406
; WIPE_START
G1 X138.741 Y103.397 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I-1.208 J-.151 P1  F600
G1 X137.741 Y111.397 Z1.6
G1 Z1.2
G1 E.6 F1800
M73 P78 R3
G1 F600
M204 S25
G1 X149.741 Y111.397 E.38406
M204 S1000
G1 X150.941 Y103.795
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.419988
G1 F480
M204 S25
G1 X150.941 Y103.391 E.01255
G1 X150.133 Y103.391 E.02509
G1 X150.13 Y103.849 E.01421
G1 X150.078 Y103.95 E.00352
G1 X149.929 Y104.02 E.00509
G1 X149.929 Y110.789 E.21011
G1 X150.078 Y110.844 E.00491
G1 X150.133 Y110.999 E.00509
G1 X150.133 Y111.403 E.01255
G1 X150.941 Y111.403 E.02509
G1 X150.941 Y103.855 E.23428
M204 S1000
G1 X150.484 Y104.112 F600
; LINE_WIDTH: 0.561777
G1 F480
M204 S25
G1 X150.499 Y104.026 E.00371
; LINE_WIDTH: 0.52673
G1 X150.513 Y103.94 E.00346
; LINE_WIDTH: 0.491684
G1 X150.527 Y103.854 E.00321
M204 S1000
G1 X150.484 Y104.112 F600
; LINE_WIDTH: 0.557396
G1 F480
M204 S25
G1 X150.506 Y104.19 E.00346
; LINE_WIDTH: 0.513588
G1 X150.528 Y104.269 E.00317
; LINE_WIDTH: 0.46978
G1 X150.55 Y104.348 E.00287
; LINE_WIDTH: 0.425972
G1 X150.572 Y104.427 E.00258
; Slow Down Start
; LINE_WIDTH: 0.364913
G1 F600;_EXTRUDE_SET_SPEED
G1 X150.594 Y104.505 E.00217
G1 X150.594 Y104.809 E.00804
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.379244
;_EXTRUDE_SET_SPEED
G1 X150.594 Y106.701 E.0524
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.41721
;_EXTRUDE_SET_SPEED
G1 X150.594 Y108.594 E.05831
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.455177
;_EXTRUDE_SET_SPEED
G1 X150.594 Y110.486 E.06423
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.386919
;_EXTRUDE_SET_SPEED
G1 X150.537 Y110.978 E.014
G1 X150.323 Y110.599 E.01232
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.36026
;_EXTRUDE_SET_SPEED
G1 X150.277 Y110.579 E.00131
G1 X150.277 Y104.574 E.15688
; Slow Down End
; LINE_WIDTH: 0.379884
G1 F480
G1 X150.277 Y104.557 E.00047
; LINE_WIDTH: 0.419132
G1 X150.277 Y104.54 E.00053
; LINE_WIDTH: 0.458379
G1 X150.277 Y104.523 E.00059
; LINE_WIDTH: 0.497627
G1 X150.277 Y104.505 E.00064
; LINE_WIDTH: 0.382164
G1 X150.292 Y104.466 E.00119
; LINE_WIDTH: 0.425972
G1 X150.308 Y104.426 E.00134
; LINE_WIDTH: 0.46978
G1 X150.324 Y104.387 E.0015
; LINE_WIDTH: 0.513588
G1 X150.339 Y104.347 E.00165
; LINE_WIDTH: 0.550061
G3 X150.451 Y104.162 I.5 J.175 E.00911
; WIPE_START
G1 X150.339 Y104.347 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I.046 J1.216 P1  F600
G1 X158.941 Y104.02 Z1.6
G1 Z1.2
G1 E.6 F1800
; LINE_WIDTH: 0.41999
G1 F480
M204 S25
G1 X158.941 Y104.227 E.00642
; Slow Down Start
G1 F600;_EXTRUDE_SET_SPEED
G1 X158.941 Y110.774 E.20323
G1 X158.793 Y110.844 E.00509
G1 X158.738 Y110.978 E.00448
G1 X158.738 Y111.403 E.0132
M73 P79 R3
G1 X157.929 Y111.403 E.02509
G1 X157.929 Y106.829 E.14198
; Slow Down End
G1 F480
G1 X157.929 Y103.391 E.10671
G1 X158.738 Y103.391 E.02509
G1 X158.761 Y103.907 E.01602
G1 X158.89 Y103.988 E.00474
M204 S1000
G1 X158.515 Y104.261 F600
; LINE_WIDTH: 0.497643
G1 F480
M204 S25
G1 X158.535 Y104.322 E.00241
; LINE_WIDTH: 0.458388
G1 X158.555 Y104.383 E.0022
; LINE_WIDTH: 0.419133
G1 X158.574 Y104.444 E.00199
; LINE_WIDTH: 0.369759
G3 X158.594 Y104.574 I-.192 J.095 E.00358
; Slow Down Start
; LINE_WIDTH: 0.36025
G1 F600;_EXTRUDE_SET_SPEED
G1 X158.594 Y110.579 E.15688
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.379235
;_EXTRUDE_SET_SPEED
G1 X158.578 Y110.586 E.00046
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.417205
;_EXTRUDE_SET_SPEED
G1 X158.563 Y110.592 E.00052
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.455175
;_EXTRUDE_SET_SPEED
G1 X158.547 Y110.599 E.00057
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.390544
;_EXTRUDE_SET_SPEED
G1 X158.334 Y110.978 E.01245
G1 X158.277 Y110.486 E.01415
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.36025
;_EXTRUDE_SET_SPEED
G1 X158.277 Y104.809 E.14832
; Slow Down End
; LINE_WIDTH: 0.380179
G1 F480
G1 X158.277 Y104.733 E.0021
; LINE_WIDTH: 0.420037
G1 X158.277 Y104.657 E.00235
; LINE_WIDTH: 0.459894
G1 X158.277 Y104.581 E.0026
; LINE_WIDTH: 0.448297
G1 X158.277 Y104.505 E.00253
G1 X158.386 Y104.112 E.01364
; LINE_WIDTH: 0.518475
G1 X158.476 Y104.215 E.00538
M204 S1000
G1 X158.334 Y103.795 F600
; LINE_WIDTH: 0.49692
G1 F480
M204 S25
G1 X158.376 Y104.052 E.00974
M204 S1000
G1 X159.13 Y103.397 F600
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M204 S25
G1 X171.13 Y103.397 E.38406
; WIPE_START
G1 X170.13 Y103.397 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I-1.208 J.151 P1  F600
G1 X171.13 Y111.397 Z1.6
G1 Z1.2
G1 E.6 F1800
G1 F600
M204 S25
G1 X159.13 Y111.397 E.38406
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 7/14
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
M106 S61.2
; OBJECT_ID: 671
; COOLING_NODE: 0
; WIPE_START
G1 F600
G1 X160.13 Y111.397 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I.468 J-1.124 P1  F600
G1 X151.333 Y107.736 Z1.6
G1 Z1.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
M73 P80 R3
G1 X151.333 Y111.795 E.13602
G1 X142.125 Y111.795 E.30857
G1 X142.125 Y110.999 E.02667
G1 X149.537 Y110.999 E.24839
G1 X149.537 Y103.795 E.24141
G1 X142.125 Y103.795 E.24839
G1 X142.125 Y102.999 E.02667
G1 X151.333 Y102.999 E.30857
G1 X151.333 Y107.676 E.15673
; COOLING_NODE: 0
M73 P80 R2
G1 X151.725 Y107.736
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X151.725 Y112.187 E.13816
G1 X137.145 Y112.187 E.45257
G1 X137.145 Y110.607 E.04904
G1 X149.145 Y110.607 E.37249
G1 X149.145 Y104.187 E.19928
G1 X137.145 Y104.187 E.37249
G1 X137.145 Y102.607 E.04904
G1 X151.725 Y102.607 E.45257
M73 P81 R2
G1 X151.725 Y107.676 E.15735
; WIPE_START
G1 X151.725 Y108.676 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I1.202 J-.193 P1  F600
G1 X150.941 Y103.795 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.419988
G1 F600
M204 S25
G1 X150.941 Y103.391 E.01255
G1 X150.133 Y103.391 E.02509
G1 X150.13 Y103.849 E.01421
G1 X150.078 Y103.95 E.00352
G1 X149.929 Y104.02 E.00509
G1 X149.929 Y110.789 E.21011
G1 X150.078 Y110.844 E.00491
G1 X150.133 Y110.999 E.00509
G1 X150.133 Y111.403 E.01255
G1 X150.941 Y111.403 E.02509
G1 X150.941 Y103.855 E.23428
M204 S1000
G1 X150.484 Y104.112
; LINE_WIDTH: 0.561777
M204 S25
G1 X150.499 Y104.026 E.00371
; LINE_WIDTH: 0.52673
G1 X150.513 Y103.94 E.00346
; LINE_WIDTH: 0.491684
G1 X150.527 Y103.854 E.00321
M204 S1000
G1 X150.594 Y104.505
; LINE_WIDTH: 0.382164
M204 S25
G1 X150.572 Y104.427 E.00228
; LINE_WIDTH: 0.425972
G1 X150.55 Y104.348 E.00258
; LINE_WIDTH: 0.46978
G1 X150.528 Y104.269 E.00287
; LINE_WIDTH: 0.513588
G1 X150.506 Y104.19 E.00317
; LINE_WIDTH: 0.550631
G1 X150.484 Y104.112 E.00342
G1 X150.355 Y104.308 E.00982
; LINE_WIDTH: 0.497627
G1 X150.335 Y104.357 E.00199
; LINE_WIDTH: 0.458379
G1 X150.316 Y104.406 E.00182
; LINE_WIDTH: 0.419132
G1 X150.296 Y104.456 E.00165
; LINE_WIDTH: 0.360429
G1 X150.277 Y104.505 E.00139
G1 X150.277 Y110.579 E.15876
G1 X150.323 Y110.599 E.00131
; LINE_WIDTH: 0.379244
G1 X150.394 Y110.725 E.00401
; LINE_WIDTH: 0.41721
G1 X150.466 Y110.851 E.00447
; LINE_WIDTH: 0.455177
G1 X150.537 Y110.978 E.00492
G1 X150.556 Y110.814 E.00559
; LINE_WIDTH: 0.41721
G1 X150.575 Y110.65 E.00508
; LINE_WIDTH: 0.360774
G1 X150.594 Y110.486 E.00431
G1 X150.594 Y104.565 E.15493
M204 S1000
G1 X149.741 Y103.397
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
M204 S25
G1 X142.329 Y103.397 E.23723
M204 S1000
G1 X141.054 Y102.814
; FEATURE: Top surface
; LINE_WIDTH: 0.42
M204 S25
G1 X141.903 Y103.663 E.03726
G1 X142.036 Y103.797
G1 X141.819 Y104.113
M73 P82 R2
G1 X141.686 Y103.98
G1 X140.521 Y102.814 E.05115
G1 X140.387 Y102.681
G1 X139.854 Y102.681
G1 X139.987 Y102.814
G1 X141.153 Y103.98 E.05115
G1 X141.286 Y104.113
G1 X140.753 Y104.113
G1 X140.619 Y103.98
G1 X139.454 Y102.814 E.05115
G1 X139.32 Y102.681
G1 X138.787 Y102.681
G1 X138.921 Y102.814
G1 X140.086 Y103.98 E.05115
G1 X140.22 Y104.113
G1 X139.686 Y104.113
G1 X139.553 Y103.98
G1 X138.388 Y102.814 E.05115
G1 X138.254 Y102.681
G1 X137.721 Y102.681
G1 X137.854 Y102.814
G1 X139.019 Y103.98 E.05115
G1 X139.153 Y104.113
G1 X138.62 Y104.113
G1 X138.486 Y103.98
G1 X137.353 Y102.846 E.04976
G1 X137.219 Y102.712
G1 X137.219 Y103.246
G1 X137.353 Y103.379
G1 X137.953 Y103.98 E.02635
; WIPE_START
G1 X137.353 Y103.379 E-.32263
G1 X137.246 Y103.273 E-.05737
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I-1.086 J.549 P1  F600
G1 X141.055 Y110.814 Z1.8
G1 Z1.4
G1 E.6 F1800
G1 F600
M204 S25
G1 X141.903 Y111.662 E.03721
G1 X142.036 Y111.796
G1 X141.821 Y112.113
G1 X141.687 Y111.98
G1 X140.522 Y110.814 E.05115
G1 X140.388 Y110.681
G1 X139.855 Y110.681
G1 X139.988 Y110.814
G1 X141.154 Y111.98 E.05115
G1 X141.287 Y112.113
G1 X140.754 Y112.113
G1 X140.62 Y111.98
G1 X139.455 Y110.814 E.05115
G1 X139.322 Y110.681
G1 X138.788 Y110.681
G1 X138.922 Y110.814
G1 X140.087 Y111.98 E.05115
G1 X140.221 Y112.113
G1 X139.688 Y112.113
G1 X139.554 Y111.98
G1 X138.389 Y110.814 E.05115
G1 X138.255 Y110.681
G1 X137.722 Y110.681
G1 X137.855 Y110.814
G1 X139.021 Y111.98 E.05115
G1 X139.154 Y112.113
G1 X138.621 Y112.113
G1 X138.487 Y111.98
G1 X137.353 Y110.845 E.04981
G1 X137.219 Y110.711
G1 X137.219 Y111.244
G1 X137.353 Y111.378
G1 X137.954 Y111.98 E.02641
; WIPE_START
G1 X137.353 Y111.378 E-.32325
G1 X137.247 Y111.273 E-.05675
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I-.03 J1.217 P1  F600
G1 X142.329 Y111.397 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F600
M204 S25
G1 X149.741 Y111.397 E.23723
; COOLING_NODE: 0
; WIPE_START
G1 X148.741 Y111.397 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I.468 J1.124 P1  F600
G1 X157.537 Y107.736 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
M73 P83 R2
G1 X157.537 Y102.999 E.15874
G1 X166.745 Y102.999 E.30857
G1 X166.745 Y103.795 E.02667
G1 X159.333 Y103.795 E.24839
G1 X159.333 Y110.999 E.24141
G1 X166.745 Y110.999 E.24839
G1 X166.745 Y111.795 E.02667
G1 X157.537 Y111.795 E.30857
G1 X157.537 Y107.796 E.134
; COOLING_NODE: 0
G1 X157.145 Y107.736
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X157.145 Y102.607 E.15921
G1 X171.725 Y102.607 E.45257
G1 X171.725 Y104.187 E.04904
G1 X159.725 Y104.187 E.37249
G1 X159.725 Y110.607 E.19928
G1 X171.725 Y110.607 E.37249
G1 X171.725 Y112.187 E.04904
M73 P84 R2
G1 X157.145 Y112.187 E.45257
G1 X157.145 Y107.796 E.1363
; WIPE_START
G1 X157.145 Y106.796 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I-1.117 J.482 P1  F600
G1 X159.13 Y111.397 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F600
M204 S25
G1 X166.542 Y111.397 E.23723
; WIPE_START
G1 X165.542 Y111.397 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I.131 J1.21 P1  F600
G1 X170.917 Y110.814 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F600
M204 S25
G1 X171.518 Y111.415 E.02636
G1 X171.652 Y111.549
G1 X171.652 Y112.082
G1 X171.518 Y111.948
G1 X170.384 Y110.814 E.04977
G1 X170.251 Y110.681
G1 X169.717 Y110.681
G1 X169.851 Y110.814
G1 X171.016 Y111.98 E.05115
G1 X171.15 Y112.113
G1 X170.616 Y112.113
G1 X170.483 Y111.98
G1 X169.318 Y110.814 E.05115
G1 X169.184 Y110.681
G1 X168.651 Y110.681
G1 X168.784 Y110.814
G1 X169.95 Y111.98 E.05115
G1 X170.083 Y112.113
G1 X169.55 Y112.113
G1 X169.416 Y111.98
G1 X168.251 Y110.814 E.05115
G1 X168.117 Y110.681
G1 X167.584 Y110.681
G1 X167.718 Y110.814
M73 P85 R2
G1 X168.883 Y111.98 E.05115
G1 X169.017 Y112.113
G1 X168.483 Y112.113
G1 X168.35 Y111.98
G1 X167.185 Y110.814 E.05115
G1 X167.051 Y110.681
G1 X166.834 Y110.997
G1 X166.968 Y111.131
G1 X167.817 Y111.98 E.03725
; WIPE_START
G1 X167.109 Y111.273 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I1.214 J-.087 P1  F600
G1 X166.542 Y103.397 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F600
M204 S25
G1 X159.13 Y103.397 E.23723
M204 S1000
G1 X158.334 Y103.795
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.49692
M204 S25
G1 X158.376 Y104.052 E.00974
M204 S1000
G1 X158.277 Y104.505
; LINE_WIDTH: 0.36025
M204 S25
G1 X158.277 Y110.486 E.15624
; LINE_WIDTH: 0.379235
G1 X158.296 Y110.65 E.00456
; LINE_WIDTH: 0.417205
G1 X158.315 Y110.814 E.00508
; LINE_WIDTH: 0.455175
G1 X158.334 Y110.978 E.00559
G1 X158.405 Y110.851 E.00492
; LINE_WIDTH: 0.417205
G1 X158.476 Y110.725 E.00447
; LINE_WIDTH: 0.36069
G1 X158.547 Y110.599 E.00379
G1 X158.594 Y110.579 E.00132
G1 X158.594 Y104.505 E.15888
; LINE_WIDTH: 0.379878
G1 X158.574 Y104.444 E.00178
; LINE_WIDTH: 0.419133
G1 X158.555 Y104.383 E.00199
; LINE_WIDTH: 0.458388
G1 X158.535 Y104.322 E.0022
; LINE_WIDTH: 0.513355
G1 X158.515 Y104.261 E.00249
G1 X158.386 Y104.112 E.00764
; LINE_WIDTH: 0.499752
G1 X158.363 Y104.196 E.00328
; LINE_WIDTH: 0.459894
G1 X158.339 Y104.28 E.00299
; LINE_WIDTH: 0.420037
G1 X158.316 Y104.364 E.00271
; LINE_WIDTH: 0.380179
G1 X158.293 Y104.448 E.00242
M204 S1000
G1 X157.929 Y104.505
; LINE_WIDTH: 0.41999
M204 S25
G1 X157.929 Y111.403 E.2141
G1 X158.738 Y111.403 E.02509
G1 X158.738 Y110.978 E.0132
G1 X158.793 Y110.844 E.00448
G1 X158.941 Y110.774 E.00509
M632 S0 N R W
M400
M104 T0 S210 N0 ;Multi extruder pre heating
M633
G1 X158.941 Y104.02 E.20965
G1 X158.761 Y103.907 E.00661
G1 X158.738 Y103.391 E.01602
G1 X157.929 Y103.391 E.02509
G1 X157.929 Y104.445 E.03273
; WIPE_START
G1 X157.929 Y103.445 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I.059 J1.216 P1  F600
G1 X170.916 Y102.814 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F600
M204 S25
G1 X171.518 Y103.416 E.02641
G1 X171.652 Y103.55
G1 X171.652 Y104.083
G1 X171.518 Y103.949
M73 P86 R2
G1 X170.383 Y102.814 E.04982
G1 X170.249 Y102.681
G1 X169.716 Y102.681
G1 X169.85 Y102.814
G1 X171.015 Y103.98 E.05115
G1 X171.149 Y104.113
G1 X170.615 Y104.113
G1 X170.482 Y103.98
G1 X169.316 Y102.814 E.05115
G1 X169.183 Y102.681
G1 X168.65 Y102.681
G1 X168.783 Y102.814
G1 X169.948 Y103.98 E.05115
G1 X170.082 Y104.113
G1 X169.549 Y104.113
G1 X169.415 Y103.98
G1 X168.25 Y102.814 E.05115
G1 X168.116 Y102.681
G1 X167.583 Y102.681
G1 X167.717 Y102.814
G1 X168.882 Y103.98 E.05115
G1 X169.016 Y104.113
G1 X168.482 Y104.113
G1 X168.349 Y103.98
G1 X167.183 Y102.814 E.05115
G1 X167.05 Y102.681
G1 X166.834 Y102.999
G1 X166.968 Y103.132
G1 X167.815 Y103.98 E.0372
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #6
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
; WIPE_START
M204 S25
G1 X167.108 Y103.273 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I1.217 J0 P1  F600
G1 X138.461 Y161.172
G1 Z1.4
G1 E.6 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF1 NF0 ON0 NN2
M204 S25
G1  X164.461 Y161.172  E2.0691 F7836
; NOZZLE_CHANGE_END OF1 NF0 ON0 NN2
M400
M104 T1 S25 N0 ;Multi extruder pre cooling

; WIPE_START
M73 P87 R1
G1 F5400
M204 S25
G1 X163.461 Y161.172 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S1000
G17
G3 Z1.8 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O7
M620 S0A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4.4 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X166.711 Y162.422



M620.10 A0 F498.898 L0 H0.4 T180 P150 S1



M620.10 A1 F498.898 L0 H0.4 T240 P220 S1



M620.11 P1 I1 B-1 E-14 F623.623



M620.15 P180
M620.15 C210
M620.11 O1 T18


M620.11 K1 I1 B-1 R10 F623.623


M620.15 C210

M628 S1


M620.11 S1 L0 I1 B-1 R10 D8 E-14 F623.623


M629


;M620.11 H0




T0 H-1
M73 E0

;deretract


;VG1 E4 F623
;VG1 E4 F311



; VFLUSH_START


;VG1 E0 F623


SYNC T0

; compensate for heating and cooling


; VFLUSH_END

M1002 set_filament_type:PLA

M400
M83



M620.10 R2


M628 S0

;VM109 S220

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F10.4167 A0.4 R2


M400

G387 Y320 J1 F10000
G1 X170.213 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.4 F3000

M204 S25


M621 S0A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y320 J1 F10000
G1 X170.213 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.4 F3000

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I0 H-1 W1 ;enable ams air printing detect
M620 O7
M1002 gcode_claim_action : 0
M106 S163.2
M106 P2 S191
G1 X169.213 Y162.422 F60000
M204 S10000
G1 Z1.4

; filament start gcode
G17
G3 Z1.8 I0 J-1.217 P1
G1 X164.711 Y162.422 Z1.8
G1 Z1.4
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X161.711 Y162.422  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
M73 P88 R1
G1  X166.211  F600
G1  X164.711  F240
G1  X165.211  F600
G1  Y162.922 
G1  X164.211 
G1  Y161.922 
G1  X165.711 
G1  Y163.422 
G1  X163.711 
G1  Y161.422 
G1  X161.711 Y162.422   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X138.211  E0.8931 F1782
G1  Y163.172  E0.0285
G1  X164.711  E1.0072 F2025
G1  Y163.922  E0.0285
G1  X138.211  E1.0072 F2473
G1  Y164.672  E0.0285
G1  X164.711  E1.0072 F4725
G1  Y165.422  E0.0285
G1  X138.211  E1.0072 F4775
G1  Y166.172  E0.0285
G1  X164.711  E1.0072
G1  Y166.922  E0.0285
G1  X138.211  E1.0072
G1  Y167.672  E0.0285
G1  X164.711  E1.0072
G1  Y168.422  E0.0285
G1  X138.211  E1.0072
G1  Y169.172  E0.0285
G1  X164.711  E1.0072
G1  Y169.922  E0.0285
G1  X138.211  E1.0072
G1  Y170.672  E0.0285
G1  X164.711  E1.0072
G1  Y171.422  E0.0285
G1  X138.211  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y171.172   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X138.286 Y172.423  
M204 S8000
G2  X137.711 Y172.422   I-0.299 J4.803 E0.0219
G1  Y160.422  E0.4561
G2  X139.113 Y160.291   I0.553 J-1.647 E0.0551
G2  X139.091 Y159.732   I-0.299 J-0.268 E0.0235
G3  X136.115 Y156.842   I10.719 J-14.017 E0.1580
G3  X136.337 Y154.375   I1.682 J-1.092 E0.1014
G3  X139.318 Y151.258   I18.593 J14.797 E0.1641
G3  X141.912 Y151.389   I1.219 J1.610 E0.1072
G1  X146.868 Y156.075   E0.2592
G2  X150.256 Y159.245   I19.728 J-17.690 E0.1766
G2  X152.914 Y159.043   I1.203 J-1.766 E0.1094
G1  X161.010 Y151.389   E0.4234
G3  X163.837 Y151.469   I1.373 J1.475 E0.1192
G3  X166.782 Y154.620   I-15.816 J17.735 E0.1641
G3  X166.506 Y157.203   I-1.676 J1.127 E0.1072
G2  X163.798 Y159.766   I20.164 J24.007 E0.1418
G2  X164.106 Y160.422   I0.308 J0.255 E0.0344
G1  X165.211  E0.0420
G1  Y161.172  E0.0285
G1 E-0.4000 F1800
M204 S10000
G1  Y163.672  F600
G1 E0.4000 F1800
M204 S8000
G1  Y172.422  E0.3326 F5400
G2  X164.492 Y172.730   I-0.276 J0.349 E0.0363
G1  X164.506 Y172.749   E0.0009
G3  X166.888 Y175.137   I-6.374 J8.738 E0.1287
M73 P89 R1
G3  X166.585 Y177.469   I-1.788 J0.953 E0.0953
G3  X163.604 Y180.586   I-18.599 J-14.802 E0.1641
G3  X161.010 Y180.455   I-1.219 J-1.610 E0.1072
G2  X153.099 Y172.985   I-102.603 J100.743 E0.4136
G2  X149.680 Y173.111   I-1.635 J2.088 E0.1413
G1  X141.912 Y180.455   E0.4063
G3  X139.085 Y180.375   I-1.373 J-1.475 E0.1192
G3  X136.140 Y177.224   I15.823 J-17.741 E0.1641
G3  X136.416 Y174.641   I1.676 J-1.127 E0.1072
G2  X138.430 Y172.730   I-5.832 J-8.159 E0.1059
G1  X138.286 Y172.423   E0.0129
; WIPE_TOWER_END

; WIPE_START
M204 S8000
G1 X138.309 Y172.428 E-.00903
G1 X138.332 Y172.435 E-.00903
G1 X138.354 Y172.445 E-.00903
G1 X138.374 Y172.457 E-.00902
G1 X138.393 Y172.471 E-.00903
G1 X138.41 Y172.488 E-.00903
G1 X138.425 Y172.506 E-.00903
G1 X138.437 Y172.527 E-.00903
G1 X138.447 Y172.548 E-.00903
G1 X138.455 Y172.571 E-.00903
G1 X138.46 Y172.594 E-.00903
G1 X138.461 Y172.618 E-.00903
G1 X138.461 Y172.641 E-.00903
G1 X138.457 Y172.665 E-.00903
G1 X138.45 Y172.688 E-.00903
G1 X138.441 Y172.71 E-.00903
G1 X138.429 Y172.73 E-.00903
G1 X138.415 Y172.75 E-.00903
G1 X138.399 Y172.767 E-.00902
G1 X138.001 Y173.144 E-.20844
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.217 J0 P1  F60000
; OBJECT_ID: 671
; COOLING_NODE: 0
M204 S10000
G1 X148.333 Y104.999
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X148.333 Y109.795 E.16071
G1 X137.537 Y109.795 E.36177
G1 X137.537 Y104.999 E.16071
G1 X148.273 Y104.999 E.35976
; COOLING_NODE: 0
M204 S250
G1 X148.725 Y104.607 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X148.725 Y110.187 E.17321
G1 X137.145 Y110.187 E.35945
G1 X137.145 Y104.607 E.17321
G1 X148.665 Y104.607 E.35759
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X148.676 Y105.607 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-.852 J.869 P1  F60000
G1 X152.537 Y109.394 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X152.537 Y107.548 E.06188
G1 X153.333 Y108.343 E.03772
G1 X153.333 Y111.795 E.11566
G1 X152.537 Y111.795 E.02667
G1 X152.537 Y109.454 E.07844
; COOLING_NODE: 0
; WIPE_START
G1 X152.537 Y108.454 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.187 J.269 P1  F60000
G1 X153.333 Y104.943 Z1.8
G1 Z1.4
G1 E.4 F1800
G1 F6000
M204 S8000
G1 X152.537 Y104.148 E.03772
G1 X152.537 Y102.999 E.03849
G1 X153.333 Y102.999 E.02667
G1 X153.333 Y104.883 E.06315
; COOLING_NODE: 0
; WIPE_START
G1 X152.599 Y104.205 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-1.212 J-.106 P1  F60000
G1 X152.145 Y109.394 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X152.145 Y106.601 E.0867
G1 X153.345 Y107.801 E.05268
G1 X153.345 Y105.51 E.07111
G1 X152.145 Y104.31 E.05268
G1 X152.145 Y102.607 E.05286
G1 X153.725 Y102.607 E.04904
G1 X153.725 Y112.187 E.29737
G1 X152.145 Y112.187 E.04904
G1 X152.145 Y109.454 E.08483
; WIPE_START
M204 S8000
G1 X152.145 Y108.454 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I.327 J1.172 P1  F60000
G1 X152.935 Y108.233 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F15000
M204 S8000
G1 X152.935 Y111.591 E.10748
; WIPE_START
G1 X152.935 Y110.591 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.217 J0 P1  F60000
G1 X152.935 Y104.258 Z1.8
G1 Z1.4
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X152.935 Y103.203 E.03377
; WIPE_START
G1 X152.935 Y104.203 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-.29 J-1.182 P1  F60000
G1 X139.935 Y107.397 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.47884
G1 F17204.992
M204 S8000
G1 X145.875 Y107.397 E.21315
M204 S10000
G1 X146.357 Y107.397 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X146.357 Y106.976 E.01412
G1 X139.514 Y106.976 E.22931
G1 X139.514 Y107.819 E.02825
G1 X146.357 Y107.819 E.22931
G1 X146.357 Y107.457 E.01211
M204 S10000
G1 X146.764 Y107.397 F60000
G1 F18424.351
M204 S8000
G1 X146.764 Y106.568 E.02776
G1 X139.107 Y106.568 E.25659
G1 X139.107 Y108.226 E.05553
G1 X146.764 Y108.226 E.25659
G1 X146.764 Y107.457 E.02575
M204 S10000
G1 X147.171 Y107.397 F60000
G1 F18424.351
M204 S8000
G1 X147.171 Y106.161 E.04141
G1 X138.7 Y106.161 E.28387
G1 X138.7 Y108.633 E.08281
G1 X147.171 Y108.633 E.28387
G1 X147.171 Y107.457 E.0394
M204 S10000
G1 X147.578 Y107.397 F60000
G1 F18424.351
M204 S8000
G1 X147.578 Y105.754 E.05505
G1 X138.293 Y105.754 E.31115
G1 X138.293 Y109.04 E.11009
G1 X147.578 Y109.04 E.31115
G1 X147.578 Y107.457 E.05304
M204 S10000
G1 X147.985 Y107.397 F60000
G1 F18424.351
M204 S8000
G1 X147.985 Y105.347 E.06869
G1 X137.885 Y105.347 E.33843
G1 X137.885 Y109.447 E.13737
G1 X147.985 Y109.447 E.33843
G1 X147.985 Y107.457 E.06668
; COOLING_NODE: 0
; WIPE_START
G1 X147.985 Y108.457 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I.625 J1.044 P1  F60000
G1 X156.333 Y103.459 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X156.333 Y104.148 E.02309
G1 X155.537 Y104.943 E.03772
G1 X155.537 Y102.999 E.06516
G1 X156.333 Y102.999 E.02667
G1 X156.333 Y103.399 E.01339
; COOLING_NODE: 0
; WIPE_START
G1 X156.333 Y104.148 E-.28466
G1 X156.156 Y104.325 E-.09535
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-1.215 J.067 P1  F60000
G1 X156.333 Y107.548 Z1.8
G1 Z1.4
G1 E.4 F1800
G1 F6000
M204 S8000
G1 X156.333 Y111.795 E.14233
G1 X155.537 Y111.795 E.02667
G1 X155.537 Y108.343 E.11566
G1 X156.291 Y107.59 E.03571
; COOLING_NODE: 0
; WIPE_START
G1 X156.301 Y108.59 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.213 J.1 P1  F60000
G1 X156.725 Y103.459 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X156.725 Y104.31 E.02643
G1 X155.525 Y105.51 E.05268
G1 X155.525 Y107.801 E.07111
G1 X156.725 Y106.601 E.05268
G1 X156.725 Y112.187 E.17339
G1 X155.145 Y112.187 E.04904
G1 X155.145 Y102.607 E.29737
G1 X156.725 Y102.607 E.04904
G1 X156.725 Y103.399 E.02457
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X156.725 Y104.31 E-.34637
G1 X156.663 Y104.373 E-.03363
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-.194 J1.201 P1  F60000
G1 X160.537 Y104.999 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X171.333 Y104.999 E.36177
G1 X171.333 Y109.795 E.16071
G1 X160.537 Y109.795 E.36177
G1 X160.537 Y105.059 E.1587
; COOLING_NODE: 0
M204 S250
G1 X160.145 Y104.607 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X171.725 Y104.607 E.35945
G1 X171.725 Y110.187 E.17321
G1 X160.145 Y110.187 E.35945
G1 X160.145 Y104.667 E.17135
; WIPE_START
M204 S8000
G1 X161.145 Y104.662 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-1.018 J.666 P1  F60000
G1 X162.935 Y107.397 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.47884
G1 F17204.992
M204 S8000
G1 X168.875 Y107.397 E.21315
M204 S10000
G1 X162.514 Y107.819 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X169.357 Y107.819 E.22931
G1 X169.357 Y106.976 E.02825
G1 X162.514 Y106.976 E.22931
G1 X162.514 Y107.759 E.02624
M204 S10000
G1 X162.107 Y108.226 F60000
G1 F18424.351
M204 S8000
G1 X169.764 Y108.226 E.25659
G1 X169.764 Y106.568 E.05553
G1 X162.107 Y106.568 E.25659
G1 X162.107 Y108.166 E.05352
M204 S10000
G1 X161.7 Y108.633 F60000
G1 F18424.351
M204 S8000
G1 X170.171 Y108.633 E.28387
G1 X170.171 Y106.161 E.08281
G1 X161.7 Y106.161 E.28387
G1 X161.7 Y108.573 E.0808
M204 S10000
G1 X161.293 Y109.04 F60000
G1 F18424.351
M204 S8000
G1 X170.578 Y109.04 E.31115
G1 X170.578 Y105.754 E.11009
G1 X161.293 Y105.754 E.31115
G1 X161.293 Y108.98 E.10808
M204 S10000
G1 X160.885 Y109.447 F60000
G1 F18424.351
M204 S8000
G1 X170.985 Y109.447 E.33843
G1 X170.985 Y105.347 E.13737
G1 X160.885 Y105.347 E.33843
G1 X160.885 Y109.387 E.13536
; WIPE_START
G1 X160.885 Y108.387 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-.661 J-1.022 P1  F60000
G1 X155.935 Y111.591 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F15000
M204 S8000
G1 X155.935 Y108.233 E.10748
; WIPE_START
G1 X155.935 Y109.233 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.217 J0 P1  F60000
G1 X155.935 Y104.258 Z1.8
G1 Z1.4
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X155.935 Y103.203 E.03377
; WIPE_START
G1 X155.935 Y104.203 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U244 V110 Z1.8 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 8/14
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
M106 S201.45
; OBJECT_ID: 671
; COOLING_NODE: 0
G1 X153.333 Y104.943 F60000
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X151.389 Y102.999 E.09215
G1 X153.333 Y102.999 E.06516
G1 X153.333 Y104.883 E.06315
; COOLING_NODE: 0
; WIPE_START
G1 X152.615 Y104.188 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-1.193 J.241 P1  F60000
G1 X153.345 Y107.801 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X151.725 Y106.181 E.07111
G1 X151.725 Y103.89 E.07111
M73 P90 R1
G1 X153.345 Y105.51 E.07111
G1 X153.345 Y107.741 E.06925
; COOLING_NODE: 0
M204 S10000
G1 X153.068 Y108.078 F60000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X153.333 Y108.343 E.01257
G1 X153.333 Y111.795 E.11566
G1 X141.649 Y111.795 E.39153
G1 X141.649 Y109.795 E.06702
G1 X137.537 Y109.795 E.1378
G1 X137.537 Y104.999 E.16071
G1 X141.649 Y104.999 E.1378
G1 X141.649 Y102.999 E.06702
G1 X151.333 Y102.999 E.32451
G1 X151.333 Y106.343 E.11207
G1 X153.026 Y108.036 E.0802
; COOLING_NODE: 0
; WIPE_START
G1 X153.333 Y108.343 E-.16531
G1 X153.333 Y108.908 E-.21469
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-.128 J-1.21 P1  F60000
G1 X141.257 Y110.187 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X137.145 Y110.187 E.12764
G1 X137.145 Y104.607 E.17321
G1 X141.257 Y104.607 E.12764
G1 X141.257 Y102.607 E.06208
G1 X153.725 Y102.607 E.38701
G1 X153.725 Y112.187 E.29737
G1 X141.257 Y112.187 E.38701
G1 X141.257 Y110.247 E.06022
; WIPE_START
M204 S8000
G1 X140.257 Y110.232 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.638 J1.036 P1  F60000
G1 X150.201 Y104.113 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.44078
G1 F15000
M204 S8000
G1 X150.127 Y104.156 E.00282
G1 X150.193 Y104.194 E.00249
M204 S10000
G1 X150.564 Y105.091 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X150.564 Y103.768 E.04106
G1 X149.241 Y103.768 E.04106
G1 X150.522 Y105.049 E.05621
M204 S10000
G1 X150.941 Y106.001 F60000
G1 F15000
M204 S8000
G1 X150.941 Y103.391 E.08102
G1 X148.331 Y103.391 E.08102
G1 X150.899 Y105.959 E.11272
; WIPE_START
G1 X150.192 Y105.252 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.5 J1.11 P1  F60000
G1 X152.947 Y104.01 Z2
G1 Z1.6
G1 E.4 F1800
; LINE_WIDTH: 0.4089
G1 F15000
M204 S8000
G1 X152.947 Y103.386 E.01882
G1 X152.322 Y103.386 E.01882
G1 X152.904 Y103.968 E.02481
; WIPE_START
G1 X152.322 Y103.386 E-.31296
G1 X152.498 Y103.386 E-.06705
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-1.211 J.116 P1  F60000
G1 X152.985 Y108.488 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X151.018 Y106.52 E.09323
G1 X150.867 Y106.482 E.00521
G1 X147.851 Y103.465 E.14296
G1 X147.827 Y103.347 E.00403
G1 X141.998 Y103.347 E.19534
G1 X141.998 Y105.144 E.0602
G3 X141.794 Y105.347 I-.204 J0 E.01071
G1 X137.885 Y105.347 E.13097
G1 X137.885 Y109.447 E.13737
G1 X141.794 Y109.447 E.13097
G3 X141.998 Y109.65 I0 J.204 E.01071
G1 X141.998 Y111.447 E.0602
G1 X152.985 Y111.447 E.36818
G1 X152.985 Y108.548 E.09715
M204 S10000
G1 X152.578 Y108.656 F60000
G1 F18424.351
M204 S8000
G1 X150.788 Y106.866 E.08484
G3 X150.579 Y106.77 I-.032 J-.204 E.00816
G1 X147.564 Y103.754 E.14289
G1 X142.405 Y103.754 E.17289
G1 X142.405 Y105.144 E.04656
G3 X141.794 Y105.754 I-.611 J0 E.03214
G1 X138.293 Y105.754 E.11733
G1 X138.293 Y109.04 E.11009
G1 X141.794 Y109.04 E.11733
G3 X142.405 Y109.65 I0 J.611 E.03214
G1 X142.405 Y111.04 E.04656
G1 X152.578 Y111.04 E.3409
G1 X152.578 Y108.716 E.07786
M204 S10000
G1 X152.171 Y108.825 F60000
G1 F18424.351
M204 S8000
G1 X150.558 Y107.212 E.07645
G3 X150.291 Y107.057 I-.018 J-.276 E.01093
G1 X147.395 Y104.161 E.13724
G1 X142.812 Y104.161 E.1536
G3 X142.756 Y105.475 I-3.954 J.491 E.04426
G3 X141.794 Y106.161 I-1.117 J-.548 E.04127
G1 X138.7 Y106.161 E.10369
G1 X138.7 Y108.633 E.08281
G1 X141.794 Y108.633 E.10369
G3 X142.812 Y109.65 I-.037 J1.054 E.05307
G1 X142.812 Y110.633 E.03292
G1 X152.171 Y110.633 E.31362
G1 X152.171 Y108.885 E.05857
M204 S10000
G1 X151.764 Y108.993 F60000
G1 F18424.351
M204 S8000
G1 X150.328 Y107.557 E.06806
G1 X150.004 Y107.345 E.01298
G1 X147.227 Y104.568 E.13159
G1 X143.219 Y104.568 E.1343
G3 X142.934 Y105.998 I-2.242 J.297 E.04974
G3 X141.794 Y106.568 I-1.3 J-1.174 E.04372
G1 X139.107 Y106.568 E.09005
G1 X139.107 Y108.226 E.05553
G1 X141.794 Y108.226 E.09005
G3 X143.219 Y109.65 I0 J1.425 E.07499
G1 X143.219 Y110.226 E.01928
G1 X151.764 Y110.226 E.28634
G1 X151.764 Y109.053 E.03928
M204 S10000
G1 X151.357 Y109.162 F60000
G1 F18424.351
M204 S8000
G1 X150.098 Y107.903 E.05966
G1 X149.716 Y107.633 E.01567
G1 X147.058 Y104.976 E.12594
G1 X143.626 Y104.976 E.11501
G3 X142.939 Y106.574 I-2.056 J.063 E.06019
G3 X141.794 Y106.976 I-1.226 J-1.66 E.04126
G1 X139.514 Y106.976 E.07641
G1 X139.514 Y107.819 E.02825
G1 X141.794 Y107.819 E.07641
G3 X143.626 Y109.819 I-.027 J1.863 E.10178
G1 X151.357 Y109.819 E.25906
G1 X151.357 Y109.222 E.01998
M204 S10000
G1 X145.401 Y107.397 F60000
; LINE_WIDTH: 0.40814
G1 F20535.567
M204 S8000
G1 X145.995 Y107.397 E.01785
M204 S10000
G1 X144.934 Y107.397 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X145.161 Y107.783 E.01501
G1 X146.987 Y107.783 E.06122
G1 X146.215 Y107.011 E.0366
G1 X145.161 Y107.011 E.03534
G1 X144.964 Y107.345 E.013
M204 S10000
G1 X144.413 Y107.397 F60000
G1 F18424.351
M204 S8000
G3 X144.907 Y108.19 I-1.722 J1.621 E.03151
G1 X147.97 Y108.19 E.10266
G1 X146.384 Y106.604 E.07518
G1 X144.907 Y106.604 E.0495
G3 X144.449 Y107.349 I-2.078 J-.762 E.02949
M204 S10000
G1 X143.843 Y107.397 F60000
G1 F18424.351
M204 S8000
G3 X144.653 Y108.597 I-1.924 J2.172 E.04904
G1 X148.98 Y108.597 E.14501
G1 X146.552 Y106.197 E.1144
G1 X144.653 Y106.197 E.06366
G3 X143.887 Y107.356 I-3.135 J-1.238 E.0469
M204 S10000
G1 X143.163 Y107.397 F60000
G1 F18424.351
M204 S8000
G3 X144.332 Y109.004 I-1.212 J2.111 E.06861
G1 X150.048 Y109.004 E.19153
G3 X146.721 Y105.79 I45.926 J-50.854 E.15505
G1 X144.332 Y105.79 E.08005
G3 X143.213 Y107.364 I-2.483 J-.58 E.06638
M204 S10000
G1 X141.794 Y107.397 F60000
; LINE_WIDTH: 0.450715
G1 F18391.624
M204 S8000
G3 X143.993 Y109.411 I-.026 J2.236 E.10958
G1 X150.95 Y109.411 E.23353
G2 X150.933 Y109.314 I-.126 J-.029 E.00341
G1 X149.868 Y108.249 E.05057
G1 X149.428 Y107.921 E.01842
G1 X146.89 Y105.383 E.12051
G1 X143.993 Y105.383 E.09723
G3 X141.853 Y107.388 I-2.204 J-.207 E.10759
M204 S10000
G1 X139.935 Y107.397 F60000
; LINE_WIDTH: 0.47884
G1 F17204.992
M204 S8000
G1 X141.734 Y107.397 E.06455
; COOLING_NODE: 0
; WIPE_START
G1 X140.734 Y107.397 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-.033 J1.217 P1  F60000
G1 X155.525 Y107.801 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X155.525 Y105.51 E.07111
G1 X157.145 Y103.89 E.07111
G1 X157.145 Y106.181 E.07111
G1 X155.568 Y107.759 E.06925
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X155.549 Y106.759 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I1.217 J-.008 P1  F60000
G1 X155.537 Y104.943 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X155.537 Y102.999 E.06516
G1 X157.482 Y102.999 E.06516
G1 X155.58 Y104.901 E.09014
; COOLING_NODE: 0
; WIPE_START
G1 X155.557 Y103.901 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-.549 J1.086 P1  F60000
G1 X167.221 Y109.795 Z2
G1 Z1.6
G1 E.4 F1800
G1 F6000
M204 S8000
G1 X167.221 Y111.795 E.06702
G1 X155.537 Y111.795 E.39153
G1 X155.537 Y108.343 E.11566
G1 X157.537 Y106.343 E.09478
G1 X157.537 Y102.999 E.11207
G1 X167.221 Y102.999 E.32451
G1 X167.221 Y104.999 E.06702
G1 X171.333 Y104.999 E.1378
G1 X171.333 Y109.795 E.16071
G1 X167.281 Y109.795 E.13579
; COOLING_NODE: 0
M204 S250
G1 X167.613 Y110.187 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X167.613 Y112.187 E.06208
G1 X155.145 Y112.187 E.38701
G1 X155.145 Y102.607 E.29737
G1 X167.613 Y102.607 E.38701
G1 X167.613 Y104.607 E.06208
G1 X171.725 Y104.607 E.12764
G1 X171.725 Y110.187 E.17321
G1 X167.673 Y110.187 E.12578
; WIPE_START
M204 S8000
G1 X167.643 Y111.187 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.756 J-.954 P1  F60000
G1 X158.719 Y104.113 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4408
G1 F15000
M204 S8000
G1 X158.644 Y104.156 E.00282
G1 X158.71 Y104.194 E.00248
M204 S10000
G1 X158.306 Y105.091 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X159.629 Y103.768 E.05807
G1 X158.306 Y103.768 E.04106
G1 X158.306 Y105.031 E.0392
M204 S10000
G1 X157.929 Y106.001 F60000
G1 F15000
M204 S8000
G1 X160.54 Y103.391 E.11458
G1 X157.929 Y103.391 E.08102
G1 X157.929 Y105.941 E.07916
; WIPE_START
G1 X157.929 Y104.941 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.512 J-1.104 P1  F60000
G1 X155.924 Y104.01 Z2
G1 Z1.6
G1 E.4 F1800
; LINE_WIDTH: 0.4089
G1 F15000
M204 S8000
G1 X156.549 Y103.386 E.02662
G1 X155.924 Y103.386 E.01882
G1 X155.924 Y103.95 E.01701
; WIPE_START
G1 X155.924 Y103.386 E-.21461
G1 X156.359 Y103.386 E-.16539
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-1.212 J-.112 P1  F60000
G1 X155.885 Y108.488 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X155.885 Y111.447 E.09916
G1 X166.873 Y111.447 E.36818
G1 X166.873 Y109.65 E.0602
G3 X167.076 Y109.447 I.204 J0 E.01071
G1 X170.985 Y109.447 E.13097
G1 X170.985 Y105.347 E.13737
G1 X167.076 Y105.347 E.13097
G3 X166.873 Y105.144 I0 J-.204 E.01071
G1 X166.873 Y103.347 E.0602
G1 X161.043 Y103.347 E.19534
G1 X161.02 Y103.465 E.00403
G1 X158.003 Y106.482 E.14295
G1 X157.853 Y106.52 E.00521
G1 X155.928 Y108.445 E.09123
M204 S10000
G1 X156.293 Y108.656 F60000
G1 F18424.351
M204 S8000
G1 X156.293 Y111.04 E.07987
G1 X166.466 Y111.04 E.3409
G1 X166.466 Y109.65 E.04656
G3 X167.076 Y109.04 I.611 J0 E.03214
G1 X170.578 Y109.04 E.11733
G1 X170.578 Y105.754 E.11009
G1 X167.076 Y105.754 E.11733
G3 X166.466 Y105.144 I0 J-.611 E.03214
G1 X166.466 Y103.754 E.04656
G1 X161.307 Y103.754 E.17289
G1 X158.291 Y106.77 E.14289
G3 X158.083 Y106.866 I-.176 J-.108 E.00816
G1 X156.335 Y108.614 E.08283
M204 S10000
G1 X156.7 Y108.825 F60000
G1 F18424.351
M204 S8000
M73 P91 R1
G1 X156.7 Y110.633 E.06058
G1 X166.059 Y110.633 E.31362
G3 X166.114 Y109.319 I3.954 J-.491 E.04426
G3 X167.076 Y108.633 I.962 J.331 E.04226
G1 X170.171 Y108.633 E.10369
G1 X170.171 Y106.161 E.08281
G1 X167.076 Y106.161 E.10369
G3 X166.059 Y105.144 I.037 J-1.054 E.05307
G1 X166.059 Y104.161 E.03292
G1 X161.475 Y104.161 E.1536
G1 X158.579 Y107.057 E.13724
G3 X158.313 Y107.212 I-.249 J-.122 E.01093
G1 X156.742 Y108.782 E.07444
M204 S10000
G1 X157.107 Y108.993 F60000
G1 F18424.351
M204 S8000
G1 X157.107 Y110.226 E.04129
G1 X165.652 Y110.226 E.28634
G3 X165.936 Y108.796 I2.242 J-.297 E.04974
G3 X167.076 Y108.226 I1.3 J1.174 E.04372
G1 X169.764 Y108.226 E.09005
G1 X169.764 Y106.568 E.05553
G1 X167.076 Y106.568 E.09005
G3 X165.652 Y105.144 I0 J-1.425 E.07499
G1 X165.652 Y104.568 E.01928
G1 X161.644 Y104.568 E.1343
G1 X158.867 Y107.345 E.13159
G1 X158.543 Y107.557 E.01298
G1 X157.149 Y108.951 E.06605
M204 S10000
G1 X157.514 Y109.162 F60000
G1 F18424.351
M204 S8000
G1 X157.514 Y109.819 E.022
G1 X165.245 Y109.819 E.25906
G3 X165.932 Y108.22 I2.055 J-.063 E.06019
G3 X167.076 Y107.819 I1.226 J1.66 E.04126
G1 X169.357 Y107.819 E.07641
G1 X169.357 Y106.976 E.02825
G1 X167.076 Y106.976 E.07641
G3 X165.245 Y104.976 I.027 J-1.863 E.10178
G1 X161.812 Y104.976 E.11501
G1 X159.155 Y107.633 E.12594
G2 X157.556 Y109.12 I5.483 J7.499 E.07332
M204 S10000
G1 X162.815 Y107.397 F60000
; LINE_WIDTH: 0.40814
G1 F20535.567
M204 S8000
G1 X163.409 Y107.397 E.01785
M204 S10000
G1 X163.937 Y107.397 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X163.71 Y107.011 E.01501
G1 X162.655 Y107.011 E.03534
G1 X161.883 Y107.783 E.0366
G1 X163.71 Y107.783 E.06122
G1 X163.906 Y107.449 E.013
M204 S10000
G1 X164.457 Y107.397 F60000
G1 F18424.351
M204 S8000
G3 X163.964 Y106.604 I1.722 J-1.62 E.03151
G1 X162.487 Y106.604 E.0495
G1 X160.9 Y108.19 E.07518
G1 X163.964 Y108.19 E.10266
G3 X164.421 Y107.445 I2.078 J.762 E.02949
M204 S10000
G1 X165.028 Y107.397 F60000
G1 F18424.351
M204 S8000
G3 X164.218 Y106.197 I1.924 J-2.172 E.04904
G1 X162.318 Y106.197 E.06366
G1 X159.891 Y108.597 E.1144
G1 X164.218 Y108.597 E.14501
G3 X164.984 Y107.438 I3.135 J1.238 E.0469
M204 S10000
G1 X165.708 Y107.397 F60000
G1 F18424.351
M204 S8000
G3 X164.539 Y105.79 I1.212 J-2.111 E.06861
G1 X162.15 Y105.79 E.08005
G1 X159.73 Y108.209 E.11464
G2 X158.823 Y109.004 I3.238 J4.609 E.04052
G1 X164.539 Y109.004 E.19153
G3 X165.658 Y107.43 I2.483 J.58 E.06638
M204 S10000
G1 X166.879 Y107.397 F60000
; LINE_WIDTH: 0.450756
G1 F18389.76
M204 S8000
G3 X164.878 Y105.383 I.26 J-2.26 E.10297
G1 X161.981 Y105.383 E.09724
G1 X159.443 Y107.921 E.12052
G1 X159.029 Y108.247 E.01766
G2 X157.921 Y109.331 I4.026 J5.226 E.05218
G1 X157.921 Y109.411 E.00271
G1 X164.878 Y109.411 E.23355
G3 X166.821 Y107.411 I2.226 J.218 E.1011
M204 S10000
G1 X166.879 Y107.397 F60000
; LINE_WIDTH: 0.47969
G1 F17171.535
M204 S8000
G1 X168.875 Y107.397 E.07176
; WIPE_START
G1 X167.875 Y107.397 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U244 V110 Z2 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 9/14
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
; OBJECT_ID: 671
; COOLING_NODE: 0
G1 X152.732 Y108.415 F60000
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X153.333 Y109.016 E.0285
G1 X153.333 Y111.795 E.09312
G1 X141.649 Y111.795 E.39153
G1 X141.649 Y109.795 E.06702
G1 X137.537 Y109.795 E.1378
G1 X137.537 Y104.999 E.16071
G1 X141.649 Y104.999 E.1378
G1 X141.649 Y102.999 E.06702
G1 X147.316 Y102.999 E.1899
G1 X152.689 Y108.372 E.25463
; COOLING_NODE: 0
M204 S250
G1 X153.345 Y107.801 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X151.725 Y106.181 E.07111
G1 X151.725 Y103.89 E.07111
G1 X153.345 Y105.51 E.07111
G1 X153.345 Y107.741 E.06925
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X152.625 Y107.047 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I1.179 J.301 P1  F60000
G1 X153.333 Y104.271 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X152.061 Y102.999 E.06027
G1 X153.333 Y102.999 E.04262
G1 X153.333 Y104.211 E.04061
; COOLING_NODE: 0
; WIPE_START
G1 X152.609 Y103.521 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-.616 J-1.049 P1  F60000
G1 X141.257 Y110.187 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X137.145 Y110.187 E.12764
G1 X137.145 Y104.607 E.17321
G1 X141.257 Y104.607 E.12764
G1 X141.257 Y102.607 E.06208
G1 X153.725 Y102.607 E.38701
G1 X153.725 Y112.187 E.29737
G1 X141.257 Y112.187 E.38701
G1 X141.257 Y110.247 E.06022
; WIPE_START
M204 S8000
G1 X140.257 Y110.232 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.303 J1.179 P1  F60000
G1 X152.123 Y107.181 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.51842
G1 F12000
M204 S8000
G1 X152.769 Y107.828 E.03579
; WIPE_START
G1 X152.123 Y107.181 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-1.116 J.486 P1  F60000
G1 X152.985 Y109.16 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X147.172 Y103.347 E.27548
G1 X141.998 Y103.347 E.17339
G1 X141.998 Y105.144 E.0602
G3 X141.794 Y105.347 I-.204 J0 E.01071
G1 X137.885 Y105.347 E.13097
G1 X137.885 Y109.447 E.13737
G1 X141.794 Y109.447 E.13097
G3 X141.998 Y109.65 I0 J.204 E.01071
G1 X141.998 Y111.447 E.0602
G1 X152.985 Y111.447 E.36818
G1 X152.985 Y109.22 E.07461
M204 S10000
G1 X152.578 Y109.329 F60000
G1 F18424.351
M204 S8000
G1 X147.003 Y103.754 E.26418
G1 X142.405 Y103.754 E.1541
G1 X142.405 Y105.144 E.04656
G3 X141.794 Y105.754 I-.611 J0 E.03214
G1 X138.293 Y105.754 E.11733
G1 X138.293 Y109.04 E.11009
G1 X141.794 Y109.04 E.11733
G3 X142.405 Y109.65 I0 J.611 E.03214
G1 X142.405 Y111.04 E.04656
G1 X152.578 Y111.04 E.3409
G1 X152.578 Y109.389 E.05532
M204 S10000
G1 X152.171 Y109.497 F60000
G1 F18424.351
M204 S8000
G1 X146.835 Y104.161 E.25288
G1 X142.812 Y104.161 E.13481
G3 X142.756 Y105.475 I-3.954 J.491 E.04426
G3 X141.794 Y106.161 I-1.117 J-.548 E.04127
G1 X138.7 Y106.161 E.10369
G1 X138.7 Y108.633 E.08281
G1 X141.794 Y108.633 E.10369
G3 X142.812 Y109.65 I-.037 J1.054 E.05307
G1 X142.812 Y110.633 E.03292
G1 X152.171 Y110.633 E.31362
G1 X152.171 Y109.557 E.03603
M204 S10000
G1 X151.764 Y109.666 F60000
G1 F18424.351
M204 S8000
G1 X146.666 Y104.568 E.24158
G1 X143.219 Y104.568 E.11552
G3 X142.934 Y105.998 I-2.242 J.297 E.04974
G3 X141.794 Y106.568 I-1.3 J-1.174 E.04372
G1 X139.107 Y106.568 E.09005
G1 X139.107 Y108.226 E.05553
G1 X141.794 Y108.226 E.09005
G3 X143.219 Y109.65 I0 J1.425 E.07499
G1 X143.219 Y110.226 E.01928
G1 X151.764 Y110.226 E.28634
G1 X151.764 Y109.726 E.01674
M204 S10000
G1 X151.341 Y109.819 F60000
G1 F18424.351
M204 S8000
G1 X146.498 Y104.976 E.22951
G1 X143.626 Y104.976 E.09623
G3 X142.939 Y106.574 I-2.056 J.063 E.06019
G3 X141.794 Y106.976 I-1.226 J-1.66 E.04126
G1 X139.514 Y106.976 E.07641
G1 X139.514 Y107.819 E.02825
G1 X141.794 Y107.819 E.07641
G3 X143.626 Y109.819 I-.027 J1.863 E.10178
G1 X151.281 Y109.819 E.2565
M204 S10000
G1 X145.401 Y107.397 F60000
; LINE_WIDTH: 0.40814
G1 F20535.567
M204 S8000
G1 X145.435 Y107.397 E.00099
M204 S10000
G1 X144.934 Y107.397 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X145.161 Y107.783 E.01501
G1 X146.427 Y107.783 E.04243
G1 X145.654 Y107.011 E.0366
G1 X145.161 Y107.011 E.01655
G1 X144.964 Y107.345 E.013
M204 S10000
G1 X144.413 Y107.397 F60000
G1 F18424.351
M204 S8000
G3 X144.907 Y108.19 I-1.722 J1.621 E.03151
G1 X147.41 Y108.19 E.08387
G1 X145.823 Y106.604 E.07518
G1 X144.907 Y106.604 E.03071
G3 X144.449 Y107.349 I-2.078 J-.762 E.02949
M204 S10000
G1 X143.843 Y107.397 F60000
G1 F18424.351
M204 S8000
G3 X144.653 Y108.597 I-1.924 J2.172 E.04904
G1 X148.392 Y108.597 E.12532
G1 X145.992 Y106.197 E.11376
G1 X144.653 Y106.197 E.04487
G3 X143.887 Y107.356 I-3.135 J-1.238 E.0469
M204 S10000
G1 X143.163 Y107.397 F60000
G1 F18424.351
M204 S8000
G3 X144.332 Y109.004 I-1.212 J2.111 E.06861
G1 X149.375 Y109.004 E.16899
G1 X146.16 Y105.79 E.15234
G1 X144.332 Y105.79 E.06127
G3 X143.213 Y107.364 I-2.483 J-.58 E.06638
M204 S10000
G1 X141.794 Y107.397 F60000
; LINE_WIDTH: 0.450756
G1 F18389.744
M204 S8000
G3 X143.993 Y109.411 I-.026 J2.236 E.10959
G1 X150.358 Y109.411 E.21368
G1 X146.329 Y105.383 E.19129
G1 X143.993 Y105.383 E.07842
G3 X141.853 Y107.388 I-2.204 J-.207 E.1076
M204 S10000
G1 X139.935 Y107.397 F60000
; LINE_WIDTH: 0.47884
G1 F17204.992
M204 S8000
G1 X141.734 Y107.397 E.06455
; WIPE_START
G1 X140.734 Y107.397 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.321 J1.174 P1  F60000
G1 X152.544 Y104.172 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F12000
M204 S2000
G1 X151.186 Y102.814 E.05961
G1 X151.052 Y102.681
G1 X151.652 Y103.813
G1 X151.518 Y103.68
G1 X150.652 Y102.814 E.03799
G1 X150.519 Y102.681
G1 X149.986 Y102.681
G1 X150.119 Y102.814
G1 X151.518 Y104.213 E.0614
G1 X151.652 Y104.347
G1 X151.652 Y104.88
G1 X151.518 Y104.746
G1 X149.586 Y102.814 E.08481
G1 X149.452 Y102.681
G1 X148.919 Y102.681
G1 X149.053 Y102.814
G1 X151.518 Y105.28 E.10822
G1 X151.651 Y105.413
G1 X151.651 Y105.946
G1 X151.518 Y105.813
G1 X148.519 Y102.814 E.13163
G1 X148.386 Y102.681
G1 X147.853 Y102.681
G1 X147.986 Y102.814
G1 X152.075 Y106.903 E.17947
M204 S10000
G1 X151.811 Y107.056 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.254968
G1 F15000
M204 S8000
G1 X147.551 Y102.796 E.10517
; WIPE_START
G1 X148.258 Y103.503 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-.135 J1.209 P1  F60000
G1 X152.644 Y103.993 Z2.2
G1 Z1.8
G1 E.4 F1800
; LINE_WIDTH: 0.138731
G1 F15000
M204 S8000
G1 X152.619 Y103.913 E.00066
G1 X151.502 Y102.796 E.01247
; WIPE_START
G1 X152.209 Y103.503 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.258 J1.189 P1  F60000
G1 X152.982 Y103.335 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.38292
G1 F15000
M204 S8000
G1 X152.918 Y103.372 E.00206
G1 X152.967 Y103.4 E.00157
; COOLING_NODE: 0
; WIPE_START
G1 X152.918 Y103.372 E-.16439
G1 X152.982 Y103.335 E-.21561
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-1.058 J.602 P1  F60000
G1 X155.525 Y107.801 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X155.525 Y105.51 E.07111
G1 X157.145 Y103.89 E.07111
G1 X157.145 Y106.181 E.07111
G1 X155.568 Y107.759 E.06925
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X155.549 Y106.759 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I1.217 J-.006 P1  F60000
G1 X155.537 Y104.271 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X155.537 Y102.999 E.04262
G1 X156.809 Y102.999 E.04262
G1 X155.58 Y104.228 E.05826
; COOLING_NODE: 0
; WIPE_START
G1 X155.545 Y103.229 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-.597 J1.061 P1  F60000
G1 X167.221 Y109.795 Z2.2
G1 Z1.8
G1 E.4 F1800
M73 P92 R1
G1 F6000
M204 S8000
G1 X167.221 Y111.795 E.06702
G1 X155.537 Y111.795 E.39153
G1 X155.537 Y109.016 E.09312
G1 X161.554 Y102.999 E.28515
G1 X167.221 Y102.999 E.1899
G1 X167.221 Y104.999 E.06702
G1 X171.333 Y104.999 E.1378
G1 X171.333 Y109.795 E.16071
G1 X167.281 Y109.795 E.13579
; COOLING_NODE: 0
M204 S250
G1 X167.613 Y110.187 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X167.613 Y112.187 E.06208
G1 X155.145 Y112.187 E.38701
G1 X155.145 Y102.607 E.29737
G1 X167.613 Y102.607 E.38701
G1 X167.613 Y104.607 E.06208
G1 X171.725 Y104.607 E.12764
G1 X171.725 Y110.187 E.17321
G1 X167.673 Y110.187 E.12578
; WIPE_START
M204 S8000
G1 X167.643 Y111.187 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.941 J-.771 P1  F60000
G1 X160.784 Y102.814 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X161.104 Y103.134 E.01405
G1 X161.238 Y103.268
G1 X160.971 Y103.535
G1 X160.838 Y103.401
G1 X160.251 Y102.814 E.02575
G1 X160.117 Y102.681
G1 X159.584 Y102.681
G1 X159.718 Y102.814
G1 X160.571 Y103.668 E.03746
G1 X160.705 Y103.801
G1 X160.438 Y104.068
G1 X160.304 Y103.934
G1 X159.185 Y102.814 E.04916
G1 X159.051 Y102.681
G1 X158.518 Y102.681
G1 X158.651 Y102.814
G1 X160.038 Y104.201 E.06087
G1 X160.171 Y104.335
G1 X159.905 Y104.601
G1 X159.771 Y104.468
G1 X158.118 Y102.814 E.07257
G1 X157.984 Y102.681
G1 X157.451 Y102.681
G1 X157.585 Y102.814
G1 X159.505 Y104.734 E.08427
G1 X159.638 Y104.868
G1 X159.372 Y105.134
G1 X159.238 Y105.001
G1 X157.446 Y103.209 E.07867
G1 X157.312 Y103.075
G1 X157.219 Y103.515
G1 X157.353 Y103.649
G1 X158.971 Y105.267 E.07106
G1 X159.105 Y105.401
G1 X158.838 Y105.668
G1 X158.705 Y105.534
G1 X157.353 Y104.182 E.05935
G1 X157.219 Y104.048
G1 X157.219 Y104.582
G1 X157.353 Y104.715
G1 X158.438 Y105.801 E.04765
G1 X158.572 Y105.934
G1 X158.305 Y106.201
G1 X158.171 Y106.067
G1 X157.353 Y105.249 E.03594
G1 X157.219 Y105.115
G1 X157.219 Y105.648
G1 X157.353 Y105.782
G1 X157.905 Y106.334 E.02424
G1 X158.038 Y106.468
G1 X157.772 Y106.734
G1 X157.638 Y106.601
G1 X157.329 Y106.291 E.01359
G1 X157.195 Y106.157
G1 X156.928 Y106.424
G1 X157.062 Y106.558
G1 X157.372 Y106.867 E.01359
; WIPE_START
M204 S8000
G1 X157.062 Y106.558 E-.16636
G1 X156.928 Y106.424 E-.07182
G1 X157.192 Y106.16 E-.14182
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I1.212 J.104 P1  F60000
G1 X157.446 Y103.209 Z2.2
G1 Z1.8
G1 E.4 F1800
G1 F12000
M204 S2000
G1 X157.18 Y102.943 E.01167
G1 X157.046 Y102.809
G1 X156.78 Y103.076
G1 X156.913 Y103.209
G1 X157.223 Y103.519 E.01359
G1 X157.357 Y103.653
G1 X157.09 Y103.919
G1 X156.956 Y103.786
G1 X156.647 Y103.476 E.01359
G1 X156.513 Y103.342
G1 X156.246 Y103.609
G1 X156.38 Y103.743
G1 X156.69 Y104.052 E.01359
M204 S10000
G1 X156.5 Y104.269 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.255687
G1 F15000
M204 S8000
G1 X156.419 Y104.199 E.00188
; LINE_WIDTH: 0.241353
G1 X156.31 Y104.047 E.00305
; LINE_WIDTH: 0.21262
G1 X156.202 Y103.895 E.00261
M204 S10000
G1 X155.931 Y103.335 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.38292
G1 F15000
M204 S8000
G1 X155.867 Y103.372 E.00206
G1 X155.916 Y103.4 E.00157
; WIPE_START
G1 X155.867 Y103.372 E-.16437
G1 X155.931 Y103.335 E-.21563
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-1.216 J.034 P1  F60000
G1 X156.059 Y107.87 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.5184
G1 F12000
M204 S8000
G1 X156.715 Y107.214 E.03634
; WIPE_START
G1 X156.059 Y107.87 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-1.206 J-.162 P1  F60000
G1 X155.885 Y109.16 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X155.885 Y111.447 E.07662
G1 X166.873 Y111.447 E.36818
G1 X166.873 Y109.65 E.0602
G3 X167.076 Y109.447 I.204 J0 E.01071
G1 X170.985 Y109.447 E.13097
G1 X170.985 Y105.347 E.13737
G1 X167.076 Y105.347 E.13097
G3 X166.873 Y105.144 I0 J-.204 E.01071
G1 X166.873 Y103.347 E.0602
G1 X161.699 Y103.347 E.17339
G1 X155.928 Y109.118 E.27347
M204 S10000
G1 X156.293 Y109.329 F60000
G1 F18424.351
M204 S8000
G1 X156.293 Y111.04 E.05733
G1 X166.466 Y111.04 E.3409
G1 X166.466 Y109.65 E.04656
G3 X167.076 Y109.04 I.611 J0 E.03214
G1 X170.578 Y109.04 E.11733
G1 X170.578 Y105.754 E.11009
G1 X167.076 Y105.754 E.11733
G3 X166.466 Y105.144 I0 J-.611 E.03214
G1 X166.466 Y103.754 E.04656
G1 X161.867 Y103.754 E.1541
G1 X156.335 Y109.286 E.26217
M204 S10000
G1 X156.7 Y109.497 F60000
G1 F18424.351
M204 S8000
G1 X156.7 Y110.633 E.03804
G1 X166.059 Y110.633 E.31362
G3 X166.114 Y109.319 I3.954 J-.491 E.04426
G3 X167.076 Y108.633 I.962 J.331 E.04226
G1 X170.171 Y108.633 E.10369
G1 X170.171 Y106.161 E.08281
G1 X167.076 Y106.161 E.10369
G3 X166.059 Y105.144 I.037 J-1.054 E.05307
G1 X166.059 Y104.161 E.03292
G1 X162.036 Y104.161 E.13481
G1 X156.742 Y109.455 E.25087
M204 S10000
G1 X157.107 Y109.666 F60000
G1 F18424.351
M204 S8000
G1 X157.107 Y110.226 E.01875
G1 X165.652 Y110.226 E.28634
G3 X165.936 Y108.796 I2.242 J-.297 E.04974
G3 X167.076 Y108.226 I1.3 J1.174 E.04372
G1 X169.764 Y108.226 E.09005
G1 X169.764 Y106.568 E.05553
G1 X167.076 Y106.568 E.09005
G3 X165.652 Y105.144 I0 J-1.425 E.07499
G1 X165.652 Y104.568 E.01928
G1 X162.204 Y104.568 E.11552
G1 X157.149 Y109.624 E.23957
M204 S10000
G1 X157.53 Y109.819 F60000
G1 F18424.351
M204 S8000
G1 X165.245 Y109.819 E.25851
G3 X165.932 Y108.22 I2.055 J-.063 E.06019
G3 X167.076 Y107.819 I1.226 J1.66 E.04126
G1 X169.357 Y107.819 E.07641
G1 X169.357 Y106.976 E.02825
G1 X167.076 Y106.976 E.07641
G3 X165.245 Y104.976 I.027 J-1.863 E.10178
G1 X162.373 Y104.976 E.09623
G1 X157.572 Y109.776 E.2275
M204 S10000
G1 X163.376 Y107.397 F60000
; LINE_WIDTH: 0.40814
G1 F20535.567
M204 S8000
G1 X163.409 Y107.397 E.00099
M204 S10000
G1 X163.937 Y107.397 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X163.71 Y107.011 E.01501
G1 X163.216 Y107.011 E.01655
G1 X162.444 Y107.783 E.0366
G1 X163.71 Y107.783 E.04243
G1 X163.906 Y107.449 E.013
M204 S10000
G1 X164.457 Y107.397 F60000
G1 F18424.351
M204 S8000
G3 X163.964 Y106.604 I1.722 J-1.62 E.03151
G1 X163.047 Y106.604 E.03071
G1 X161.461 Y108.19 E.07518
G1 X163.964 Y108.19 E.08387
G3 X164.421 Y107.445 I2.078 J.762 E.02949
M204 S10000
G1 X165.028 Y107.397 F60000
G1 F18424.351
M204 S8000
G3 X164.218 Y106.197 I1.924 J-2.172 E.04904
G1 X162.879 Y106.197 E.04487
G1 X160.478 Y108.597 E.11376
G1 X164.218 Y108.597 E.12532
G3 X164.984 Y107.438 I3.135 J1.238 E.0469
M204 S10000
G1 X165.708 Y107.397 F60000
G1 F18424.351
M204 S8000
G3 X164.539 Y105.79 I1.212 J-2.111 E.06861
G1 X162.71 Y105.79 E.06127
G1 X159.495 Y109.004 E.15234
G1 X164.539 Y109.004 E.16899
G3 X165.658 Y107.43 I2.483 J.58 E.06638
M204 S10000
G1 X166.879 Y107.397 F60000
; LINE_WIDTH: 0.47969
G1 F17171.535
M204 S8000
G1 X168.875 Y107.397 E.07176
M204 S10000
G1 X166.879 Y107.397 F60000
; LINE_WIDTH: 0.450801
G1 F18387.735
M204 S8000
G3 X164.878 Y105.383 I.26 J-2.26 E.10298
G1 X162.542 Y105.383 E.07843
G1 X158.513 Y109.411 E.19131
G1 X164.878 Y109.411 E.21371
G3 X166.821 Y107.411 I2.226 J.218 E.10111
; WIPE_START
G1 X166.022 Y107.675 E-.31963
G1 X165.896 Y107.772 E-.06037
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U244 V110 Z2.2 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 10/14
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
; OBJECT_ID: 671
; COOLING_NODE: 0
G1 X153.333 Y108.525 F60000
G1 Z2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X153.333 Y111.795 E.10956
G1 X141.649 Y111.795 E.39153
G1 X141.649 Y109.795 E.06702
G1 X137.537 Y109.795 E.1378
G1 X137.537 Y104.999 E.16071
G1 X141.649 Y104.999 E.1378
G1 X141.649 Y102.999 E.06702
G1 X147.989 Y102.999 E.21243
G1 X153.333 Y108.343 E.25327
G1 X153.333 Y108.465 E.00409
; COOLING_NODE: 0
; WIPE_START
G1 X153.333 Y109.465 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I1.217 J0 P1  F60000
G1 X153.333 Y104.943 Z2.4
G1 Z2
G1 E.4 F1800
G1 F6000
M204 S8000
G1 X151.389 Y102.999 E.09215
G1 X153.333 Y102.999 E.06516
G1 X153.333 Y104.883 E.06315
; COOLING_NODE: 0
; WIPE_START
G1 X152.615 Y104.188 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I-1.193 J.241 P1  F60000
G1 X153.345 Y107.801 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6282
M204 S5000
G1 X153.345 Y105.51 E.07111
G1 X150.442 Y102.607 E.12744
G1 X153.725 Y102.607 E.10191
G1 X153.725 Y112.187 E.29737
G1 X141.257 Y112.187 E.38701
G1 X141.257 Y110.187 E.06208
G1 X137.145 Y110.187 E.12764
G1 X137.145 Y104.607 E.17321
G1 X141.257 Y104.607 E.12764
G1 X141.257 Y102.607 E.06208
G1 X148.151 Y102.607 E.21399
G1 X153.303 Y107.759 E.22615
; WIPE_START
G1 F12000
M204 S8000
G1 X153.322 Y106.759 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I1.206 J-.165 P1  F60000
G1 X152.947 Y104.01 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4089
G1 F15000
M204 S8000
G1 X152.947 Y103.386 E.01882
G1 X152.322 Y103.386 E.01882
G1 X152.904 Y103.968 E.02481
; WIPE_START
G1 X152.322 Y103.386 E-.31295
G1 X152.498 Y103.386 E-.06705
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I-1.217 J-.014 P1  F60000
G1 X152.402 Y111.631 Z2.4
G1 Z2
G1 E.4 F1800
; LINE_WIDTH: 0.42257
G1 F15000
M204 S8000
G1 X153 Y111.033 E.02643
G1 X153 Y110.497 E.01678
G1 X152.035 Y111.462 E.04266
G1 X151.498 Y111.462 E.01678
G1 X153 Y109.96 E.06639
G1 X153 Y109.423 E.01678
G1 X150.961 Y111.462 E.09012
G1 X150.424 Y111.462 E.01678
G1 X153 Y108.886 E.11385
G1 X153 Y108.481 E.01264
G1 X152.934 Y108.415 E.00293
G1 X149.887 Y111.462 E.13465
G1 X149.35 Y111.462 E.01678
G1 X152.665 Y108.147 E.14652
G1 X152.397 Y107.878 E.01186
G1 X148.813 Y111.462 E.15838
G1 X148.276 Y111.462 E.01678
G1 X152.128 Y107.61 E.17025
G1 X151.86 Y107.341 E.01187
G1 X147.74 Y111.462 E.18211
G1 X147.203 Y111.462 E.01678
G1 X151.591 Y107.073 E.19398
G1 X151.323 Y106.804 E.01187
G1 X146.666 Y111.462 E.20584
G1 X146.129 Y111.462 E.01678
G1 X151.055 Y106.536 E.21771
G1 X150.786 Y106.268 E.01187
G1 X145.592 Y111.462 E.22957
M73 P93 R1
G1 X145.055 Y111.462 E.01678
G1 X150.518 Y105.999 E.24144
G1 X150.249 Y105.731 E.01186
G1 X144.518 Y111.462 E.2533
G1 X143.981 Y111.462 E.01678
G1 X149.981 Y105.462 E.26517
G1 X149.712 Y105.194 E.01186
G1 X143.444 Y111.462 E.27703
G1 X142.907 Y111.462 E.01678
G1 X149.444 Y104.925 E.2889
G1 X149.175 Y104.657 E.01187
G1 X142.37 Y111.462 E.30076
G1 X141.983 Y111.462 E.01212
G1 X141.983 Y111.313 E.00466
G1 X148.907 Y104.388 E.30604
G1 X148.638 Y104.12 E.01187
G1 X141.983 Y110.776 E.29417
G1 X141.983 Y110.239 E.01678
G1 X148.37 Y103.851 E.28231
G1 X148.102 Y103.583 E.01187
G1 X141.983 Y109.702 E.27044
G1 X141.983 Y109.462 E.00751
G1 X141.686 Y109.462 E.00927
G1 X147.815 Y103.332 E.27091
G1 X147.279 Y103.332 E.01678
G1 X141.149 Y109.462 E.27091
G1 X140.612 Y109.462 E.01678
G1 X146.742 Y103.332 E.27091
G1 X146.205 Y103.332 E.01678
G1 X140.075 Y109.462 E.27091
G1 X139.538 Y109.462 E.01678
G1 X145.668 Y103.332 E.27091
G1 X145.131 Y103.332 E.01678
G1 X139.001 Y109.462 E.27091
G1 X138.464 Y109.462 E.01678
G1 X144.594 Y103.332 E.27091
G1 X144.057 Y103.332 E.01678
G1 X137.928 Y109.462 E.27091
G1 X137.87 Y109.462 E.00178
G1 X137.87 Y108.982 E.015
G1 X141.52 Y105.332 E.16131
G1 X140.983 Y105.332 E.01678
G1 X137.87 Y108.445 E.13758
G1 X137.87 Y107.908 E.01678
G1 X140.446 Y105.332 E.11385
G1 X139.91 Y105.332 E.01678
G1 X137.87 Y107.371 E.09012
G1 X137.87 Y106.834 E.01678
G1 X139.373 Y105.332 E.06639
G1 X138.836 Y105.332 E.01678
G1 X137.87 Y106.297 E.04266
G1 X137.87 Y105.761 E.01678
G1 X138.468 Y105.163 E.02643
M204 S10000
G1 X141.813 Y105.04 F60000
G1 F15000
M204 S8000
G1 X143.52 Y103.332 E.07546
G1 X142.983 Y103.332 E.01678
G1 X141.983 Y104.333 E.04423
G1 X141.983 Y103.796 E.01678
G1 X142.616 Y103.163 E.028
; COOLING_NODE: 0
; WIPE_START
G1 X141.983 Y103.796 E-.34044
G1 X141.983 Y103.9 E-.03956
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I-.093 J1.213 P1  F60000
G1 X155.537 Y104.943 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X155.537 Y102.999 E.06516
G1 X157.482 Y102.999 E.06516
G1 X155.58 Y104.901 E.09014
; COOLING_NODE: 0
; WIPE_START
G1 X155.557 Y103.901 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I-1.217 J-.005 P1  F60000
G1 X155.537 Y109.038 Z2.4
G1 Z2
G1 E.4 F1800
G1 F6000
M204 S8000
G1 X155.537 Y108.343 E.02327
G1 X160.882 Y102.999 E.25327
G1 X167.221 Y102.999 E.21243
G1 X167.221 Y104.999 E.06702
G1 X171.333 Y104.999 E.1378
G1 X171.333 Y109.795 E.16071
G1 X167.221 Y109.795 E.1378
G1 X167.221 Y111.795 E.06702
G1 X155.537 Y111.795 E.39153
G1 X155.537 Y109.098 E.09038
; COOLING_NODE: 0
; WIPE_START
G1 X155.537 Y108.343 E-.28664
G1 X155.711 Y108.17 E-.09336
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I1.087 J-.548 P1  F60000
G1 X155.525 Y107.801 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6282
M204 S5000
G1 X160.719 Y102.607 E.22801
G1 X167.613 Y102.607 E.21399
G1 X167.613 Y104.607 E.06208
G1 X171.725 Y104.607 E.12764
G1 X171.725 Y110.187 E.17321
G1 X167.613 Y110.187 E.12764
G1 X167.613 Y112.187 E.06208
G1 X155.145 Y112.187 E.38701
G1 X155.145 Y102.607 E.29737
G1 X158.428 Y102.607 E.10191
G1 X155.525 Y105.51 E.12744
G1 X155.525 Y107.741 E.06925
M204 S10000
G1 X155.701 Y108.655 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42506
G1 F15000
M204 S8000
G1 X161.024 Y103.332 E.23679
G1 X161.564 Y103.332 E.017
G1 X155.87 Y109.026 E.25329
G1 X155.87 Y109.566 E.017
G1 X162.104 Y103.332 E.27733
G1 X162.645 Y103.332 E.017
G1 X155.87 Y110.107 E.30137
G1 X155.87 Y110.647 E.017
G1 X163.185 Y103.332 E.32541
G1 X163.726 Y103.332 E.017
G1 X155.87 Y111.187 E.34946
G1 X155.87 Y111.462 E.00863
G1 X156.137 Y111.462 E.00837
G1 X164.266 Y103.332 E.36166
G1 X164.807 Y103.332 E.017
G1 X156.677 Y111.462 E.36166
G1 X157.217 Y111.462 E.017
M73 P93 R0
G1 X165.347 Y103.332 E.36166
G1 X165.887 Y103.332 E.017
G1 X157.758 Y111.462 E.36166
G1 X158.298 Y111.462 E.017
G1 X166.428 Y103.332 E.36166
G1 X166.888 Y103.332 E.01447
G1 X166.888 Y103.413 E.00253
G1 X158.839 Y111.462 E.35809
G1 X159.379 Y111.462 E.017
G1 X166.888 Y103.953 E.33405
G1 X166.888 Y104.493 E.017
G1 X159.92 Y111.462 E.31
G1 X160.46 Y111.462 E.017
G1 X166.888 Y105.034 E.28596
G1 X166.888 Y105.332 E.00939
G1 X167.13 Y105.332 E.00761
G1 X161 Y111.462 E.27269
G1 X161.541 Y111.462 E.017
G1 X167.67 Y105.332 E.27269
G1 X168.211 Y105.332 E.017
G1 X162.081 Y111.462 E.27269
G1 X162.622 Y111.462 E.017
G1 X168.751 Y105.332 E.27269
G1 X169.292 Y105.332 E.017
G1 X163.162 Y111.462 E.27269
G1 X163.703 Y111.462 E.017
G1 X169.832 Y105.332 E.27269
G1 X170.373 Y105.332 E.017
G1 X164.073 Y111.631 E.28024
M204 S10000
G1 X167.058 Y110.809 F60000
G1 F15000
M204 S8000
G1 X166.405 Y111.462 E.02905
G1 X165.864 Y111.462 E.017
G1 X166.888 Y110.438 E.04554
G1 X166.888 Y109.898 E.017
G1 X165.324 Y111.462 E.06958
G1 X164.783 Y111.462 E.017
G1 X170.913 Y105.332 E.27269
G1 X171 Y105.332 E.00274
G1 X171 Y105.786 E.01426
G1 X167.324 Y109.462 E.16355
G1 X167.864 Y109.462 E.017
G1 X171 Y106.326 E.1395
G1 X171 Y106.866 E.017
G1 X168.405 Y109.462 E.11546
G1 X168.945 Y109.462 E.017
G1 X171 Y107.407 E.09142
G1 X171 Y107.947 E.017
G1 X169.486 Y109.462 E.06738
G1 X170.026 Y109.462 E.017
G1 X171 Y108.488 E.04333
G1 X171 Y109.028 E.017
G1 X170.397 Y109.631 E.02684
; WIPE_START
G1 X171 Y109.028 E-.32423
G1 X171 Y108.881 E-.05577
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I.374 J-1.158 P1  F60000
G1 X155.924 Y104.01 Z2.4
G1 Z2
G1 E.4 F1800
; LINE_WIDTH: 0.40889
G1 F15000
M204 S8000
G1 X156.549 Y103.386 E.02662
G1 X155.924 Y103.386 E.01882
G1 X155.924 Y103.95 E.01701
; WIPE_START
G1 X155.924 Y103.386 E-.21462
G1 X156.359 Y103.386 E-.16538
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U244 V110 Z2.4 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 11/14
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
; OBJECT_ID: 671
; COOLING_NODE: 0
G1 X153.333 Y108.525 F60000
G1 Z2.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X153.333 Y111.795 E.10956
G1 X141.649 Y111.795 E.39153
G1 X141.649 Y109.795 E.06702
G1 X137.537 Y109.795 E.1378
G1 X137.537 Y104.999 E.16071
G1 X141.649 Y104.999 E.1378
G1 X141.649 Y102.999 E.06702
G1 X147.989 Y102.999 E.21243
G1 X153.333 Y108.343 E.25327
G1 X153.333 Y108.465 E.00409
; COOLING_NODE: 0
; WIPE_START
G1 X153.333 Y109.465 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I1.217 J0 P1  F60000
G1 X153.333 Y104.943 Z2.6
G1 Z2.2
G1 E.4 F1800
G1 F6000
M204 S8000
G1 X151.389 Y102.999 E.09215
G1 X153.333 Y102.999 E.06516
G1 X153.333 Y104.883 E.06315
; COOLING_NODE: 0
; WIPE_START
G1 X152.615 Y104.188 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-1.193 J.241 P1  F60000
G1 X153.345 Y107.801 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6393
M204 S5000
G1 X153.345 Y105.51 E.07111
G1 X150.442 Y102.607 E.12744
G1 X153.725 Y102.607 E.10191
G1 X153.725 Y112.187 E.29737
G1 X141.257 Y112.187 E.38701
G1 X141.257 Y110.187 E.06208
G1 X137.145 Y110.187 E.12764
G1 X137.145 Y104.607 E.17321
G1 X141.257 Y104.607 E.12764
G1 X141.257 Y102.607 E.06208
G1 X148.151 Y102.607 E.21399
G1 X153.303 Y107.759 E.22615
M204 S10000
G1 X153.17 Y108.655 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42506
G1 F15000
M204 S8000
G1 X147.847 Y103.332 E.23679
G1 X147.307 Y103.332 E.017
G1 X153 Y109.026 E.25328
G1 X153 Y109.566 E.017
G1 X146.766 Y103.332 E.27732
G1 X146.226 Y103.332 E.017
G1 X153 Y110.106 E.30137
G1 X153 Y110.647 E.017
G1 X145.685 Y103.332 E.32541
G1 X145.145 Y103.332 E.017
G1 X153 Y111.187 E.34945
G1 X153 Y111.462 E.00864
M73 P94 R0
G1 X152.734 Y111.462 E.00836
G1 X144.605 Y103.332 E.36166
G1 X144.064 Y103.332 E.017
G1 X152.194 Y111.462 E.36166
G1 X151.653 Y111.462 E.017
G1 X143.524 Y103.332 E.36166
G1 X142.983 Y103.332 E.017
G1 X151.113 Y111.462 E.36166
G1 X150.572 Y111.462 E.017
G1 X142.443 Y103.332 E.36166
G1 X141.983 Y103.332 E.01448
G1 X141.983 Y103.412 E.00252
G1 X150.032 Y111.462 E.3581
G1 X149.492 Y111.462 E.017
G1 X141.983 Y103.953 E.33405
G1 X141.983 Y104.493 E.017
G1 X148.951 Y111.462 E.31001
G1 X148.411 Y111.462 E.017
G1 X141.983 Y105.034 E.28597
G1 X141.983 Y105.332 E.00939
G1 X141.741 Y105.332 E.00761
G1 X147.87 Y111.462 E.27269
G1 X147.33 Y111.462 E.017
G1 X141.2 Y105.332 E.27269
G1 X140.66 Y105.332 E.017
G1 X146.789 Y111.462 E.27269
G1 X146.249 Y111.462 E.017
G1 X140.119 Y105.332 E.27269
G1 X139.579 Y105.332 E.017
G1 X145.709 Y111.462 E.27269
G1 X145.168 Y111.462 E.017
G1 X139.039 Y105.332 E.27269
G1 X138.498 Y105.332 E.017
G1 X144.628 Y111.462 E.27269
G1 X144.087 Y111.462 E.017
G1 X137.958 Y105.332 E.27269
G1 X137.87 Y105.332 E.00274
G1 X137.87 Y105.785 E.01426
G1 X141.547 Y109.462 E.16355
G1 X141.006 Y109.462 E.017
G1 X137.87 Y106.326 E.13951
G1 X137.87 Y106.866 E.017
G1 X140.466 Y109.462 E.11547
G1 X139.926 Y109.462 E.017
G1 X137.87 Y107.407 E.09143
G1 X137.87 Y107.947 E.017
G1 X139.385 Y109.462 E.06738
G1 X138.845 Y109.462 E.017
G1 X137.87 Y108.488 E.04334
G1 X137.87 Y109.028 E.017
G1 X138.474 Y109.631 E.02685
; WIPE_START
G1 X137.87 Y109.028 E-.32432
G1 X137.87 Y108.881 E-.05568
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-.534 J1.093 P1  F60000
G1 X141.813 Y110.809 Z2.6
G1 Z2.2
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X142.466 Y111.462 E.02905
G1 X143.006 Y111.462 E.017
G1 X141.983 Y110.438 E.04555
G1 X141.983 Y109.898 E.017
G1 X143.717 Y111.631 E.07714
; WIPE_START
G1 X143.009 Y110.924 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I.695 J.999 P1  F60000
G1 X152.947 Y104.01 Z2.6
G1 Z2.2
G1 E.4 F1800
; LINE_WIDTH: 0.4089
G1 F15000
M204 S8000
G1 X152.947 Y103.386 E.01882
G1 X152.322 Y103.386 E.01882
G1 X152.904 Y103.968 E.02481
; COOLING_NODE: 0
; WIPE_START
G1 X152.322 Y103.386 E-.31295
G1 X152.498 Y103.386 E-.06705
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-.555 J1.083 P1  F60000
G1 X155.537 Y104.943 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X155.537 Y102.999 E.06516
G1 X157.482 Y102.999 E.06516
G1 X155.58 Y104.901 E.09014
; COOLING_NODE: 0
; WIPE_START
G1 X155.557 Y103.901 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-1.217 J-.005 P1  F60000
G1 X155.537 Y109.038 Z2.6
G1 Z2.2
G1 E.4 F1800
G1 F6000
M204 S8000
G1 X155.537 Y108.343 E.02327
G1 X160.882 Y102.999 E.25327
G1 X167.221 Y102.999 E.21243
G1 X167.221 Y104.999 E.06702
G1 X171.333 Y104.999 E.1378
G1 X171.333 Y109.795 E.16071
G1 X167.221 Y109.795 E.1378
G1 X167.221 Y111.795 E.06702
G1 X155.537 Y111.795 E.39153
G1 X155.537 Y109.098 E.09038
; COOLING_NODE: 0
; WIPE_START
G1 X155.537 Y108.343 E-.28664
G1 X155.711 Y108.17 E-.09336
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I1.087 J-.548 P1  F60000
G1 X155.525 Y107.801 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6393
M204 S5000
G1 X160.719 Y102.607 E.22801
G1 X167.613 Y102.607 E.21399
G1 X167.613 Y104.607 E.06208
G1 X171.725 Y104.607 E.12764
G1 X171.725 Y110.187 E.17321
G1 X167.613 Y110.187 E.12764
G1 X167.613 Y112.187 E.06208
G1 X155.145 Y112.187 E.38701
G1 X155.145 Y102.607 E.29737
G1 X158.428 Y102.607 E.10191
G1 X155.525 Y105.51 E.12744
G1 X155.525 Y107.741 E.06925
; WIPE_START
G1 F12000
M204 S8000
G1 X156.236 Y107.038 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I1.211 J-.125 P1  F60000
G1 X155.924 Y104.01 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.40889
G1 F15000
M204 S8000
G1 X156.549 Y103.386 E.02662
G1 X155.924 Y103.386 E.01882
G1 X155.924 Y103.95 E.01701
; WIPE_START
G1 X155.924 Y103.386 E-.21462
G1 X156.359 Y103.386 E-.16538
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-1.217 J.016 P1  F60000
G1 X156.468 Y111.631 Z2.6
G1 Z2.2
G1 E.4 F1800
; LINE_WIDTH: 0.42257
G1 F15000
M204 S8000
G1 X155.87 Y111.033 E.02643
G1 X155.87 Y110.497 E.01678
G1 X156.836 Y111.462 E.04266
G1 X157.373 Y111.462 E.01678
G1 X155.87 Y109.96 E.06639
G1 X155.87 Y109.423 E.01678
G1 X157.91 Y111.462 E.09012
G1 X158.446 Y111.462 E.01678
G1 X155.87 Y108.886 E.11385
G1 X155.87 Y108.481 E.01264
G1 X155.937 Y108.415 E.00293
G1 X158.983 Y111.462 E.13465
G1 X159.52 Y111.462 E.01678
G1 X156.205 Y108.147 E.14652
G1 X156.474 Y107.878 E.01186
G1 X160.057 Y111.462 E.15838
G1 X160.594 Y111.462 E.01678
G1 X156.742 Y107.61 E.17025
G1 X157.011 Y107.341 E.01187
G1 X161.131 Y111.462 E.18211
G1 X161.668 Y111.462 E.01678
G1 X157.279 Y107.073 E.19398
G1 X157.547 Y106.804 E.01187
G1 X162.205 Y111.462 E.20584
G1 X162.742 Y111.462 E.01678
G1 X157.816 Y106.536 E.21771
G1 X158.084 Y106.268 E.01186
G1 X163.279 Y111.462 E.22957
G1 X163.815 Y111.462 E.01678
G1 X158.353 Y105.999 E.24144
G1 X158.621 Y105.731 E.01187
G1 X164.352 Y111.462 E.2533
G1 X164.889 Y111.462 E.01678
G1 X158.89 Y105.462 E.26517
G1 X159.158 Y105.194 E.01187
G1 X165.426 Y111.462 E.27703
G1 X165.963 Y111.462 E.01678
G1 X159.427 Y104.925 E.2889
G1 X159.695 Y104.657 E.01187
G1 X166.5 Y111.462 E.30076
G1 X166.888 Y111.462 E.01212
G1 X166.888 Y111.313 E.00466
G1 X159.964 Y104.388 E.30604
G1 X160.232 Y104.12 E.01187
G1 X166.888 Y110.776 E.29418
G1 X166.888 Y110.239 E.01678
G1 X160.5 Y103.851 E.28231
G1 X160.769 Y103.583 E.01186
G1 X166.888 Y109.702 E.27045
G1 X166.888 Y109.462 E.00751
G1 X167.185 Y109.462 E.00927
G1 X161.055 Y103.332 E.27091
G1 X161.592 Y103.332 E.01678
G1 X167.721 Y109.462 E.27091
G1 X168.258 Y109.462 E.01678
G1 X162.129 Y103.332 E.27091
G1 X162.666 Y103.332 E.01678
G1 X168.795 Y109.462 E.27091
G1 X169.332 Y109.462 E.01678
G1 X163.203 Y103.332 E.27091
G1 X163.74 Y103.332 E.01678
G1 X169.869 Y109.462 E.27091
G1 X170.406 Y109.462 E.01678
G1 X164.276 Y103.332 E.27091
G1 X164.813 Y103.332 E.01678
G1 X171.113 Y109.631 E.27841
M204 S10000
G1 X171.17 Y105.93 F60000
G1 F15000
M204 S8000
G1 X170.572 Y105.332 E.02643
G1 X170.035 Y105.332 E.01678
G1 X171 Y106.297 E.04266
G1 X171 Y106.834 E.01678
G1 X169.498 Y105.332 E.06639
G1 X168.961 Y105.332 E.01678
G1 X171 Y107.371 E.09012
G1 X171 Y107.908 E.01678
G1 X168.424 Y105.332 E.11385
G1 X167.887 Y105.332 E.01678
G1 X171 Y108.445 E.13758
G1 X171 Y108.982 E.01678
G1 X167.35 Y105.332 E.16131
G1 X166.888 Y105.332 E.01445
G1 X166.888 Y104.87 E.01445
G1 X165.35 Y103.332 E.06796
G1 X165.887 Y103.332 E.01678
G1 X166.888 Y104.333 E.04423
G1 X166.888 Y103.796 E.01678
G1 X166.254 Y103.163 E.028
; WIPE_START
G1 X166.888 Y103.796 E-.34047
G1 X166.888 Y103.9 E-.03953
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U244 V110 Z2.6 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 12/14
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
; OBJECT_ID: 671
; COOLING_NODE: 0
G1 X153.333 Y108.525 F60000
G1 Z2.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X153.333 Y111.795 E.10956
G1 X141.649 Y111.795 E.39153
G1 X141.649 Y109.795 E.06702
G1 X137.537 Y109.795 E.1378
G1 X137.537 Y104.999 E.16071
G1 X141.649 Y104.999 E.1378
G1 X141.649 Y102.999 E.06702
G1 X147.989 Y102.999 E.21243
G1 X153.333 Y108.343 E.25327
G1 X153.333 Y108.465 E.00409
; COOLING_NODE: 0
; WIPE_START
G1 X153.333 Y109.465 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I1.217 J0 P1  F60000
G1 X153.333 Y104.943 Z2.8
G1 Z2.4
G1 E.4 F1800
G1 F6000
M204 S8000
G1 X151.389 Y102.999 E.09215
G1 X153.333 Y102.999 E.06516
G1 X153.333 Y104.883 E.06315
; COOLING_NODE: 0
; WIPE_START
G1 X152.615 Y104.188 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I-1.193 J.241 P1  F60000
G1 X153.345 Y107.801 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6493
M204 S5000
G1 X153.345 Y105.51 E.07111
G1 X150.442 Y102.607 E.12744
G1 X153.725 Y102.607 E.10191
G1 X153.725 Y112.187 E.29737
G1 X141.257 Y112.187 E.38701
G1 X141.257 Y110.187 E.06208
G1 X137.145 Y110.187 E.12764
G1 X137.145 Y104.607 E.17321
M73 P95 R0
G1 X141.257 Y104.607 E.12764
G1 X141.257 Y102.607 E.06208
G1 X148.151 Y102.607 E.21399
G1 X153.303 Y107.759 E.22615
; WIPE_START
G1 F12000
M204 S8000
G1 X153.322 Y106.759 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I1.206 J-.165 P1  F60000
G1 X152.947 Y104.01 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4089
G1 F15000
M204 S8000
G1 X152.947 Y103.386 E.01882
G1 X152.322 Y103.386 E.01882
G1 X152.904 Y103.968 E.02481
; WIPE_START
G1 X152.322 Y103.386 E-.31295
G1 X152.498 Y103.386 E-.06705
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I-1.217 J-.014 P1  F60000
G1 X152.402 Y111.631 Z2.8
G1 Z2.4
G1 E.4 F1800
; LINE_WIDTH: 0.42257
G1 F15000
M204 S8000
G1 X153 Y111.033 E.02643
G1 X153 Y110.497 E.01678
G1 X152.035 Y111.462 E.04266
G1 X151.498 Y111.462 E.01678
G1 X153 Y109.96 E.06639
G1 X153 Y109.423 E.01678
G1 X150.961 Y111.462 E.09012
G1 X150.424 Y111.462 E.01678
G1 X153 Y108.886 E.11385
G1 X153 Y108.481 E.01264
G1 X152.934 Y108.415 E.00293
G1 X149.887 Y111.462 E.13465
G1 X149.35 Y111.462 E.01678
G1 X152.665 Y108.147 E.14652
G1 X152.397 Y107.878 E.01186
G1 X148.813 Y111.462 E.15838
G1 X148.276 Y111.462 E.01678
G1 X152.128 Y107.61 E.17025
G1 X151.86 Y107.341 E.01187
G1 X147.74 Y111.462 E.18211
G1 X147.203 Y111.462 E.01678
G1 X151.591 Y107.073 E.19398
G1 X151.323 Y106.804 E.01187
G1 X146.666 Y111.462 E.20584
G1 X146.129 Y111.462 E.01678
G1 X151.055 Y106.536 E.21771
G1 X150.786 Y106.268 E.01187
G1 X145.592 Y111.462 E.22957
G1 X145.055 Y111.462 E.01678
G1 X150.518 Y105.999 E.24144
G1 X150.249 Y105.731 E.01186
G1 X144.518 Y111.462 E.2533
G1 X143.981 Y111.462 E.01678
G1 X149.981 Y105.462 E.26517
G1 X149.712 Y105.194 E.01186
G1 X143.444 Y111.462 E.27703
G1 X142.907 Y111.462 E.01678
G1 X149.444 Y104.925 E.2889
G1 X149.175 Y104.657 E.01187
G1 X142.37 Y111.462 E.30076
G1 X141.983 Y111.462 E.01212
G1 X141.983 Y111.313 E.00466
G1 X148.907 Y104.388 E.30604
G1 X148.638 Y104.12 E.01187
G1 X141.983 Y110.776 E.29417
G1 X141.983 Y110.239 E.01678
G1 X148.37 Y103.851 E.28231
G1 X148.102 Y103.583 E.01187
G1 X141.983 Y109.702 E.27044
G1 X141.983 Y109.462 E.00751
G1 X141.686 Y109.462 E.00927
G1 X147.815 Y103.332 E.27091
G1 X147.279 Y103.332 E.01678
G1 X141.149 Y109.462 E.27091
G1 X140.612 Y109.462 E.01678
G1 X146.742 Y103.332 E.27091
G1 X146.205 Y103.332 E.01678
G1 X140.075 Y109.462 E.27091
G1 X139.538 Y109.462 E.01678
G1 X145.668 Y103.332 E.27091
G1 X145.131 Y103.332 E.01678
G1 X139.001 Y109.462 E.27091
G1 X138.464 Y109.462 E.01678
G1 X144.594 Y103.332 E.27091
G1 X144.057 Y103.332 E.01678
G1 X137.928 Y109.462 E.27091
G1 X137.87 Y109.462 E.00178
G1 X137.87 Y108.982 E.015
G1 X141.52 Y105.332 E.16131
G1 X140.983 Y105.332 E.01678
G1 X137.87 Y108.445 E.13758
G1 X137.87 Y107.908 E.01678
G1 X140.446 Y105.332 E.11385
G1 X139.91 Y105.332 E.01678
G1 X137.87 Y107.371 E.09012
G1 X137.87 Y106.834 E.01678
G1 X139.373 Y105.332 E.06639
G1 X138.836 Y105.332 E.01678
G1 X137.87 Y106.297 E.04266
G1 X137.87 Y105.761 E.01678
G1 X138.468 Y105.163 E.02643
M204 S10000
G1 X141.813 Y105.04 F60000
G1 F15000
M204 S8000
G1 X143.52 Y103.332 E.07546
G1 X142.983 Y103.332 E.01678
G1 X141.983 Y104.333 E.04423
G1 X141.983 Y103.796 E.01678
G1 X142.616 Y103.163 E.028
; COOLING_NODE: 0
; WIPE_START
G1 X141.983 Y103.796 E-.34044
G1 X141.983 Y103.9 E-.03956
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I-.093 J1.213 P1  F60000
G1 X155.537 Y104.943 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X155.537 Y102.999 E.06516
G1 X157.482 Y102.999 E.06516
G1 X155.58 Y104.901 E.09014
; COOLING_NODE: 0
; WIPE_START
G1 X155.557 Y103.901 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I-1.217 J-.005 P1  F60000
G1 X155.537 Y109.038 Z2.8
G1 Z2.4
G1 E.4 F1800
G1 F6000
M204 S8000
G1 X155.537 Y108.343 E.02327
G1 X160.882 Y102.999 E.25327
G1 X167.221 Y102.999 E.21243
G1 X167.221 Y104.999 E.06702
G1 X171.333 Y104.999 E.1378
G1 X171.333 Y109.795 E.16071
G1 X167.221 Y109.795 E.1378
G1 X167.221 Y111.795 E.06702
G1 X155.537 Y111.795 E.39153
G1 X155.537 Y109.098 E.09038
; COOLING_NODE: 0
; WIPE_START
G1 X155.537 Y108.343 E-.28664
G1 X155.711 Y108.17 E-.09336
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I1.087 J-.548 P1  F60000
G1 X155.525 Y107.801 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6493
M204 S5000
G1 X160.719 Y102.607 E.22801
G1 X167.613 Y102.607 E.21399
G1 X167.613 Y104.607 E.06208
G1 X171.725 Y104.607 E.12764
G1 X171.725 Y110.187 E.17321
G1 X167.613 Y110.187 E.12764
G1 X167.613 Y112.187 E.06208
G1 X155.145 Y112.187 E.38701
G1 X155.145 Y102.607 E.29737
G1 X158.428 Y102.607 E.10191
G1 X155.525 Y105.51 E.12744
G1 X155.525 Y107.741 E.06925
M204 S10000
G1 X155.701 Y108.655 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42506
G1 F15000
M204 S8000
G1 X161.024 Y103.332 E.23679
G1 X161.564 Y103.332 E.017
G1 X155.87 Y109.026 E.25329
G1 X155.87 Y109.566 E.017
G1 X162.104 Y103.332 E.27733
G1 X162.645 Y103.332 E.017
G1 X155.87 Y110.107 E.30137
G1 X155.87 Y110.647 E.017
G1 X163.185 Y103.332 E.32541
G1 X163.726 Y103.332 E.017
G1 X155.87 Y111.187 E.34946
G1 X155.87 Y111.462 E.00863
G1 X156.137 Y111.462 E.00837
G1 X164.266 Y103.332 E.36166
G1 X164.807 Y103.332 E.017
G1 X156.677 Y111.462 E.36166
G1 X157.217 Y111.462 E.017
G1 X165.347 Y103.332 E.36166
G1 X165.887 Y103.332 E.017
G1 X157.758 Y111.462 E.36166
G1 X158.298 Y111.462 E.017
G1 X166.428 Y103.332 E.36166
G1 X166.888 Y103.332 E.01447
G1 X166.888 Y103.413 E.00253
G1 X158.839 Y111.462 E.35809
G1 X159.379 Y111.462 E.017
G1 X166.888 Y103.953 E.33405
G1 X166.888 Y104.493 E.017
G1 X159.92 Y111.462 E.31
G1 X160.46 Y111.462 E.017
G1 X166.888 Y105.034 E.28596
G1 X166.888 Y105.332 E.00939
G1 X167.13 Y105.332 E.00761
G1 X161 Y111.462 E.27269
G1 X161.541 Y111.462 E.017
G1 X167.67 Y105.332 E.27269
G1 X168.211 Y105.332 E.017
G1 X162.081 Y111.462 E.27269
G1 X162.622 Y111.462 E.017
G1 X168.751 Y105.332 E.27269
G1 X169.292 Y105.332 E.017
G1 X163.162 Y111.462 E.27269
G1 X163.703 Y111.462 E.017
G1 X169.832 Y105.332 E.27269
G1 X170.373 Y105.332 E.017
G1 X164.073 Y111.631 E.28024
M204 S10000
G1 X167.058 Y110.809 F60000
G1 F15000
M204 S8000
G1 X166.405 Y111.462 E.02905
G1 X165.864 Y111.462 E.017
G1 X166.888 Y110.438 E.04554
G1 X166.888 Y109.898 E.017
G1 X165.324 Y111.462 E.06958
G1 X164.783 Y111.462 E.017
G1 X170.913 Y105.332 E.27269
G1 X171 Y105.332 E.00274
G1 X171 Y105.786 E.01426
G1 X167.324 Y109.462 E.16355
G1 X167.864 Y109.462 E.017
G1 X171 Y106.326 E.1395
G1 X171 Y106.866 E.017
G1 X168.405 Y109.462 E.11546
G1 X168.945 Y109.462 E.017
G1 X171 Y107.407 E.09142
G1 X171 Y107.947 E.017
G1 X169.486 Y109.462 E.06738
G1 X170.026 Y109.462 E.017
G1 X171 Y108.488 E.04333
G1 X171 Y109.028 E.017
G1 X170.397 Y109.631 E.02684
; WIPE_START
G1 X171 Y109.028 E-.32423
G1 X171 Y108.881 E-.05577
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I.374 J-1.158 P1  F60000
G1 X155.924 Y104.01 Z2.8
G1 Z2.4
G1 E.4 F1800
; LINE_WIDTH: 0.40889
G1 F15000
M204 S8000
G1 X156.549 Y103.386 E.02662
G1 X155.924 Y103.386 E.01882
G1 X155.924 Y103.95 E.01701
; WIPE_START
G1 X155.924 Y103.386 E-.21462
G1 X156.359 Y103.386 E-.16538
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U244 V110 Z2.8 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 13/14
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
; OBJECT_ID: 671
; COOLING_NODE: 0
G1 X153.333 Y108.525 F60000
G1 Z2.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X153.333 Y111.795 E.10956
G1 X141.649 Y111.795 E.39153
G1 X141.649 Y109.795 E.06702
G1 X137.537 Y109.795 E.1378
G1 X137.537 Y104.999 E.16071
G1 X141.649 Y104.999 E.1378
G1 X141.649 Y102.999 E.06702
G1 X147.989 Y102.999 E.21243
G1 X153.333 Y108.343 E.25327
G1 X153.333 Y108.465 E.00409
; COOLING_NODE: 0
; WIPE_START
G1 X153.333 Y109.465 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I1.217 J0 P1  F60000
G1 X153.333 Y104.943 Z3
G1 Z2.6
G1 E.4 F1800
G1 F6000
M204 S8000
M73 P96 R0
G1 X151.389 Y102.999 E.09215
G1 X153.333 Y102.999 E.06516
G1 X153.333 Y104.883 E.06315
; COOLING_NODE: 0
; WIPE_START
G1 X152.615 Y104.188 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I-1.193 J.241 P1  F60000
G1 X153.345 Y107.801 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6572
M204 S5000
G1 X153.345 Y105.51 E.07111
G1 X150.442 Y102.607 E.12744
G1 X153.725 Y102.607 E.10191
G1 X153.725 Y112.187 E.29737
G1 X141.257 Y112.187 E.38701
G1 X141.257 Y110.187 E.06208
G1 X137.145 Y110.187 E.12764
G1 X137.145 Y104.607 E.17321
G1 X141.257 Y104.607 E.12764
G1 X141.257 Y102.607 E.06208
G1 X148.151 Y102.607 E.21399
G1 X153.303 Y107.759 E.22615
M204 S10000
G1 X153.17 Y108.655 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42506
G1 F15000
M204 S8000
G1 X147.847 Y103.332 E.23679
G1 X147.307 Y103.332 E.017
G1 X153 Y109.026 E.25328
G1 X153 Y109.566 E.017
G1 X146.766 Y103.332 E.27732
G1 X146.226 Y103.332 E.017
G1 X153 Y110.106 E.30137
G1 X153 Y110.647 E.017
G1 X145.685 Y103.332 E.32541
G1 X145.145 Y103.332 E.017
G1 X153 Y111.187 E.34945
G1 X153 Y111.462 E.00864
G1 X152.734 Y111.462 E.00836
G1 X144.605 Y103.332 E.36166
G1 X144.064 Y103.332 E.017
G1 X152.194 Y111.462 E.36166
G1 X151.653 Y111.462 E.017
G1 X143.524 Y103.332 E.36166
G1 X142.983 Y103.332 E.017
G1 X151.113 Y111.462 E.36166
G1 X150.572 Y111.462 E.017
G1 X142.443 Y103.332 E.36166
G1 X141.983 Y103.332 E.01448
G1 X141.983 Y103.412 E.00252
G1 X150.032 Y111.462 E.3581
G1 X149.492 Y111.462 E.017
G1 X141.983 Y103.953 E.33405
G1 X141.983 Y104.493 E.017
G1 X148.951 Y111.462 E.31001
G1 X148.411 Y111.462 E.017
G1 X141.983 Y105.034 E.28597
G1 X141.983 Y105.332 E.00939
G1 X141.741 Y105.332 E.00761
G1 X147.87 Y111.462 E.27269
G1 X147.33 Y111.462 E.017
G1 X141.2 Y105.332 E.27269
G1 X140.66 Y105.332 E.017
G1 X146.789 Y111.462 E.27269
G1 X146.249 Y111.462 E.017
G1 X140.119 Y105.332 E.27269
G1 X139.579 Y105.332 E.017
G1 X145.709 Y111.462 E.27269
G1 X145.168 Y111.462 E.017
G1 X139.039 Y105.332 E.27269
G1 X138.498 Y105.332 E.017
G1 X144.628 Y111.462 E.27269
G1 X144.087 Y111.462 E.017
G1 X137.958 Y105.332 E.27269
G1 X137.87 Y105.332 E.00274
G1 X137.87 Y105.785 E.01426
G1 X141.547 Y109.462 E.16355
G1 X141.006 Y109.462 E.017
G1 X137.87 Y106.326 E.13951
G1 X137.87 Y106.866 E.017
G1 X140.466 Y109.462 E.11547
G1 X139.926 Y109.462 E.017
G1 X137.87 Y107.407 E.09143
G1 X137.87 Y107.947 E.017
G1 X139.385 Y109.462 E.06738
G1 X138.845 Y109.462 E.017
G1 X137.87 Y108.488 E.04334
G1 X137.87 Y109.028 E.017
G1 X138.474 Y109.631 E.02685
; WIPE_START
G1 X137.87 Y109.028 E-.32432
G1 X137.87 Y108.881 E-.05568
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I-.534 J1.093 P1  F60000
G1 X141.813 Y110.809 Z3
G1 Z2.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X142.466 Y111.462 E.02905
G1 X143.006 Y111.462 E.017
G1 X141.983 Y110.438 E.04555
G1 X141.983 Y109.898 E.017
G1 X143.717 Y111.631 E.07714
; WIPE_START
G1 X143.009 Y110.924 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I.695 J.999 P1  F60000
G1 X152.947 Y104.01 Z3
G1 Z2.6
G1 E.4 F1800
; LINE_WIDTH: 0.4089
G1 F15000
M204 S8000
G1 X152.947 Y103.386 E.01882
G1 X152.322 Y103.386 E.01882
G1 X152.904 Y103.968 E.02481
; COOLING_NODE: 0
; WIPE_START
G1 X152.322 Y103.386 E-.31295
G1 X152.498 Y103.386 E-.06705
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I-.555 J1.083 P1  F60000
G1 X155.537 Y104.943 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X155.537 Y102.999 E.06516
G1 X157.482 Y102.999 E.06516
G1 X155.58 Y104.901 E.09014
; COOLING_NODE: 0
; WIPE_START
G1 X155.557 Y103.901 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I-1.217 J-.005 P1  F60000
G1 X155.537 Y109.038 Z3
G1 Z2.6
G1 E.4 F1800
G1 F6000
M204 S8000
G1 X155.537 Y108.343 E.02327
G1 X160.882 Y102.999 E.25327
G1 X167.221 Y102.999 E.21243
G1 X167.221 Y104.999 E.06702
G1 X171.333 Y104.999 E.1378
G1 X171.333 Y109.795 E.16071
G1 X167.221 Y109.795 E.1378
G1 X167.221 Y111.795 E.06702
G1 X155.537 Y111.795 E.39153
G1 X155.537 Y109.098 E.09038
; COOLING_NODE: 0
; WIPE_START
G1 X155.537 Y108.343 E-.28664
G1 X155.711 Y108.17 E-.09336
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I1.087 J-.548 P1  F60000
G1 X155.525 Y107.801 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6572
M204 S5000
G1 X160.719 Y102.607 E.22801
G1 X167.613 Y102.607 E.21399
G1 X167.613 Y104.607 E.06208
G1 X171.725 Y104.607 E.12764
G1 X171.725 Y110.187 E.17321
G1 X167.613 Y110.187 E.12764
G1 X167.613 Y112.187 E.06208
G1 X155.145 Y112.187 E.38701
G1 X155.145 Y102.607 E.29737
G1 X158.428 Y102.607 E.10191
G1 X155.525 Y105.51 E.12744
G1 X155.525 Y107.741 E.06925
; WIPE_START
G1 F12000
M204 S8000
G1 X156.236 Y107.038 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I1.211 J-.125 P1  F60000
G1 X155.924 Y104.01 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.40889
G1 F15000
M204 S8000
G1 X156.549 Y103.386 E.02662
G1 X155.924 Y103.386 E.01882
G1 X155.924 Y103.95 E.01701
; WIPE_START
G1 X155.924 Y103.386 E-.21462
G1 X156.359 Y103.386 E-.16538
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I-1.217 J.016 P1  F60000
G1 X156.468 Y111.631 Z3
G1 Z2.6
G1 E.4 F1800
; LINE_WIDTH: 0.42257
G1 F15000
M204 S8000
G1 X155.87 Y111.033 E.02643
G1 X155.87 Y110.497 E.01678
G1 X156.836 Y111.462 E.04266
G1 X157.373 Y111.462 E.01678
G1 X155.87 Y109.96 E.06639
G1 X155.87 Y109.423 E.01678
G1 X157.91 Y111.462 E.09012
G1 X158.446 Y111.462 E.01678
G1 X155.87 Y108.886 E.11385
G1 X155.87 Y108.481 E.01264
G1 X155.937 Y108.415 E.00293
G1 X158.983 Y111.462 E.13465
G1 X159.52 Y111.462 E.01678
G1 X156.205 Y108.147 E.14652
G1 X156.474 Y107.878 E.01186
G1 X160.057 Y111.462 E.15838
G1 X160.594 Y111.462 E.01678
G1 X156.742 Y107.61 E.17025
G1 X157.011 Y107.341 E.01187
G1 X161.131 Y111.462 E.18211
G1 X161.668 Y111.462 E.01678
G1 X157.279 Y107.073 E.19398
G1 X157.547 Y106.804 E.01187
G1 X162.205 Y111.462 E.20584
G1 X162.742 Y111.462 E.01678
G1 X157.816 Y106.536 E.21771
G1 X158.084 Y106.268 E.01186
G1 X163.279 Y111.462 E.22957
G1 X163.815 Y111.462 E.01678
G1 X158.353 Y105.999 E.24144
G1 X158.621 Y105.731 E.01187
G1 X164.352 Y111.462 E.2533
G1 X164.889 Y111.462 E.01678
G1 X158.89 Y105.462 E.26517
G1 X159.158 Y105.194 E.01187
G1 X165.426 Y111.462 E.27703
G1 X165.963 Y111.462 E.01678
G1 X159.427 Y104.925 E.2889
G1 X159.695 Y104.657 E.01187
G1 X166.5 Y111.462 E.30076
G1 X166.888 Y111.462 E.01212
G1 X166.888 Y111.313 E.00466
G1 X159.964 Y104.388 E.30604
G1 X160.232 Y104.12 E.01187
G1 X166.888 Y110.776 E.29418
G1 X166.888 Y110.239 E.01678
G1 X160.5 Y103.851 E.28231
G1 X160.769 Y103.583 E.01186
G1 X166.888 Y109.702 E.27045
G1 X166.888 Y109.462 E.00751
G1 X167.185 Y109.462 E.00927
G1 X161.055 Y103.332 E.27091
G1 X161.592 Y103.332 E.01678
G1 X167.721 Y109.462 E.27091
G1 X168.258 Y109.462 E.01678
G1 X162.129 Y103.332 E.27091
G1 X162.666 Y103.332 E.01678
G1 X168.795 Y109.462 E.27091
G1 X169.332 Y109.462 E.01678
G1 X163.203 Y103.332 E.27091
G1 X163.74 Y103.332 E.01678
G1 X169.869 Y109.462 E.27091
G1 X170.406 Y109.462 E.01678
G1 X164.276 Y103.332 E.27091
G1 X164.813 Y103.332 E.01678
G1 X171.113 Y109.631 E.27841
M204 S10000
G1 X171.17 Y105.93 F60000
G1 F15000
M204 S8000
G1 X170.572 Y105.332 E.02643
G1 X170.035 Y105.332 E.01678
G1 X171 Y106.297 E.04266
G1 X171 Y106.834 E.01678
G1 X169.498 Y105.332 E.06639
G1 X168.961 Y105.332 E.01678
G1 X171 Y107.371 E.09012
G1 X171 Y107.908 E.01678
G1 X168.424 Y105.332 E.11385
G1 X167.887 Y105.332 E.01678
G1 X171 Y108.445 E.13758
G1 X171 Y108.982 E.01678
G1 X167.35 Y105.332 E.16131
G1 X166.888 Y105.332 E.01445
G1 X166.888 Y104.87 E.01445
G1 X165.35 Y103.332 E.06796
G1 X165.887 Y103.332 E.01678
G1 X166.888 Y104.333 E.04423
G1 X166.888 Y103.796 E.01678
G1 X166.254 Y103.163 E.028
; WIPE_START
G1 X166.888 Y103.796 E-.34047
G1 X166.888 Y103.9 E-.03953
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U244 V110 Z3 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 14/14
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
; OBJECT_ID: 671
; COOLING_NODE: 0
G1 X153.345 Y107.801 F60000
G1 Z2.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P97 R0
G1 F6625
M204 S5000
G1 X153.345 Y105.51 E.07111
G1 X150.442 Y102.607 E.12744
G1 X153.725 Y102.607 E.10191
G1 X153.725 Y112.187 E.29737
G1 X141.257 Y112.187 E.38701
G1 X141.257 Y110.187 E.06208
G1 X137.145 Y110.187 E.12764
G1 X137.145 Y104.607 E.17321
G1 X141.257 Y104.607 E.12764
G1 X141.257 Y102.607 E.06208
G1 X148.151 Y102.607 E.21399
G1 X153.303 Y107.759 E.22615
; WIPE_START
G1 F12000
M204 S8000
G1 X153.322 Y106.759 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I1.198 J-.214 P1  F60000
G1 X152.981 Y104.852 Z3.2
G1 Z2.8
G1 E.4 F1800
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X153.518 Y104.315 E.02358
G1 X153.652 Y104.181
G1 X153.652 Y103.648
G1 X153.518 Y103.782
G1 X152.714 Y104.586 E.03529
G1 X152.58 Y104.719
G1 X152.314 Y104.453
G1 X152.447 Y104.319
G1 X153.518 Y103.248 E.04699
G1 X153.652 Y103.115
G1 X153.552 Y102.681
G1 X153.419 Y102.814
G1 X152.181 Y104.052 E.05434
G1 X152.047 Y104.186
G1 X151.78 Y103.919
G1 X151.914 Y103.786
G1 X152.885 Y102.814 E.04264
G1 X153.019 Y102.681
G1 X152.486 Y102.681
G1 X152.352 Y102.814
G1 X151.647 Y103.519 E.03093
G1 X151.514 Y103.653
G1 X151.247 Y103.386
G1 X151.381 Y103.252
G1 X151.819 Y102.814 E.01923
; WIPE_START
M204 S8000
G1 X151.381 Y103.252 E-.23537
G1 X151.247 Y103.386 E-.07182
G1 X151.383 Y103.521 E-.07281
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I-1.201 J.199 P1  F60000
G1 X152.785 Y111.98 Z3.2
G1 Z2.8
G1 E.4 F1800
G1 F12000
M204 S2000
G1 X153.518 Y111.247 E.03215
G1 X153.652 Y111.114
G1 X153.652 Y110.58
G1 X153.518 Y110.714
G1 X152.252 Y111.98 E.05556
G1 X152.119 Y112.113
G1 X151.585 Y112.113
G1 X151.719 Y111.98
G1 X153.518 Y110.181 E.07897
G1 X153.652 Y110.047
G1 X153.652 Y109.514
G1 X153.518 Y109.647
G1 X151.186 Y111.98 E.10238
G1 X151.052 Y112.113
G1 X150.519 Y112.113
G1 X150.652 Y111.98
G1 X153.518 Y109.114 E.12579
G1 X153.652 Y108.981
G1 X153.652 Y108.447
G1 X153.518 Y108.581
G1 X150.119 Y111.98 E.1492
G1 X149.986 Y112.113
G1 X149.452 Y112.113
G1 X149.586 Y111.98
G1 X153.408 Y108.157 E.16779
G1 X153.542 Y108.024
G1 X153.275 Y107.757
G1 X153.142 Y107.891
G1 X149.053 Y111.98 E.1795
G1 X148.919 Y112.113
G1 X148.386 Y112.113
G1 X148.519 Y111.98
G1 X152.875 Y107.624 E.1912
G1 X153.009 Y107.49
G1 X152.742 Y107.224
G1 X152.608 Y107.357
G1 X147.986 Y111.98 E.20291
G1 X147.853 Y112.113
G1 X147.319 Y112.113
G1 X147.453 Y111.98
G1 X152.342 Y107.091 E.21461
G1 X152.475 Y106.957
G1 X152.209 Y106.691
G1 X152.075 Y106.824
G1 X146.92 Y111.98 E.22632
G1 X146.786 Y112.113
G1 X146.253 Y112.113
G1 X146.386 Y111.98
G1 X151.808 Y106.558 E.23802
G1 X151.942 Y106.424
G1 X151.675 Y106.157
G1 X151.542 Y106.291
G1 X145.853 Y111.98 E.24973
G1 X145.719 Y112.113
G1 X145.186 Y112.113
G1 X145.32 Y111.98
G1 X151.275 Y106.024 E.26143
G1 X151.409 Y105.891
G1 X151.142 Y105.624
G1 X151.009 Y105.758
G1 X144.787 Y111.98 E.27313
G1 X144.653 Y112.113
G1 X144.12 Y112.113
G1 X144.253 Y111.98
G1 X150.742 Y105.491 E.28484
G1 X150.876 Y105.357
G1 X150.609 Y105.091
G1 X150.475 Y105.224
G1 X143.72 Y111.98 E.29654
G1 X143.586 Y112.113
G1 X143.053 Y112.113
G1 X143.187 Y111.98
G1 X150.209 Y104.958 E.30825
G1 X150.342 Y104.824
G1 X150.076 Y104.558
G1 X149.942 Y104.691
G1 X142.654 Y111.98 E.31995
G1 X142.52 Y112.113
G1 X141.987 Y112.113
G1 X142.12 Y111.98
G1 X149.675 Y104.425 E.33166
G1 X149.809 Y104.291
G1 X149.542 Y104.024
G1 X149.409 Y104.158
G1 X141.587 Y111.98 E.34336
G1 X141.453 Y112.113
G1 X141.331 Y111.702
G1 X141.465 Y111.569
G1 X149.142 Y103.891 E.33703
G1 X149.276 Y103.758
G1 X149.009 Y103.491
G1 X148.876 Y103.625
G1 X141.465 Y111.035 E.32532
G1 X141.331 Y111.169
G1 X141.331 Y110.636
G1 X141.465 Y110.502
G1 X148.609 Y103.358 E.31362
G1 X148.743 Y103.224
G1 X148.476 Y102.958
G1 X148.342 Y103.091
G1 X141.454 Y109.98 E.30238
G1 X141.32 Y110.113
G1 X140.787 Y110.113
G1 X140.921 Y109.98
G1 X148.076 Y102.825 E.31409
G1 X148.209 Y102.691
G1 X147.686 Y102.681
G1 X147.553 Y102.814
G1 X140.388 Y109.98 E.31454
G1 X140.254 Y110.113
G1 X139.721 Y110.113
G1 X139.854 Y109.98
G1 X147.02 Y102.814 E.31454
G1 X147.153 Y102.681
G1 X146.62 Y102.681
G1 X146.486 Y102.814
G1 X139.321 Y109.98 E.31454
G1 X139.187 Y110.113
G1 X138.654 Y110.113
G1 X138.788 Y109.98
G1 X145.953 Y102.814 E.31454
G1 X146.087 Y102.681
G1 X145.553 Y102.681
G1 X145.42 Y102.814
G1 X138.254 Y109.98 E.31454
G1 X138.121 Y110.113
G1 X137.588 Y110.113
G1 X137.721 Y109.98
G1 X144.886 Y102.814 E.31454
G1 X145.02 Y102.681
G1 X144.487 Y102.681
G1 X144.353 Y102.814
G1 X137.353 Y109.815 E.30731
G1 X137.219 Y109.949
G1 X137.219 Y109.415
G1 X137.353 Y109.282
G1 X143.82 Y102.814 E.28391
G1 X143.954 Y102.681
G1 X143.42 Y102.681
G1 X143.287 Y102.814
G1 X141.465 Y104.636 E.07998
G1 X141.331 Y104.77
G1 X141.331 Y104.237
G1 X141.465 Y104.103
G1 X142.753 Y102.814 E.05657
G1 X142.887 Y102.681
G1 X142.354 Y102.681
G1 X142.22 Y102.814
G1 X141.465 Y103.57 E.03316
G1 X141.331 Y103.703
G1 X141.42 Y104.681
G1 X141.287 Y104.814
G1 X137.353 Y108.748 E.1727
G1 X137.219 Y108.882
G1 X137.219 Y108.349
G1 X137.353 Y108.215
G1 X140.753 Y104.814 E.14929
G1 X140.887 Y104.681
G1 X140.354 Y104.681
G1 X140.22 Y104.814
G1 X137.353 Y107.682 E.12588
G1 X137.219 Y107.816
G1 X137.219 Y107.282
G1 X137.353 Y107.149
G1 X139.687 Y104.814 E.10247
G1 X139.821 Y104.681
G1 X139.287 Y104.681
G1 X139.154 Y104.814
G1 X137.353 Y106.615 E.07906
G1 X137.219 Y106.749
G1 X137.219 Y106.216
G1 X137.353 Y106.082
G1 X138.62 Y104.814 E.05565
G1 X138.754 Y104.681
G1 X138.221 Y104.681
G1 X138.087 Y104.814
G1 X137.353 Y105.549 E.03225
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X138.06 Y104.842 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I-.203 J1.2 P1  F60000
G1 X155.525 Y107.801 Z3.2
G1 Z2.8
G1 E.4 F1800
; FEATURE: Outer wall
G1 F6625
M204 S5000
G1 X160.719 Y102.607 E.22801
G1 X167.613 Y102.607 E.21399
G1 X167.613 Y104.607 E.06208
G1 X171.725 Y104.607 E.12764
G1 X171.725 Y110.187 E.17321
G1 X167.613 Y110.187 E.12764
G1 X167.613 Y112.187 E.06208
G1 X155.145 Y112.187 E.38701
G1 X155.145 Y102.607 E.29737
G1 X158.428 Y102.607 E.10191
G1 X155.525 Y105.51 E.12744
G1 X155.525 Y107.741 E.06925
; WIPE_START
G1 F12000
M204 S8000
G1 X156.236 Y107.038 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I1.103 J-.515 P1  F60000
G1 X155.353 Y105.146 Z3.2
G1 Z2.8
G1 E.4 F1800
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X157.685 Y102.814 E.10237
G1 X157.818 Y102.681
G1 X157.285 Y102.681
G1 X157.151 Y102.814
G1 X155.353 Y104.613 E.07896
G1 X155.219 Y104.747
G1 X155.219 Y104.214
G1 X155.353 Y104.08
G1 X156.618 Y102.814 E.05555
G1 X156.752 Y102.681
G1 X156.219 Y102.681
G1 X156.085 Y102.814
G1 X155.353 Y103.547 E.03215
; WIPE_START
M204 S8000
G1 X156.06 Y102.84 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I-.466 J1.124 P1  F60000
G1 X171.518 Y109.245 Z3.2
G1 Z2.8
G1 E.4 F1800
G1 F12000
M204 S2000
G1 X170.783 Y109.98 E.03225
G1 X170.65 Y110.113
G1 X170.116 Y110.113
G1 X170.25 Y109.98
G1 X171.518 Y108.712 E.05566
G1 X171.652 Y108.578
G1 X171.652 Y108.045
G1 X171.518 Y108.178
G1 X169.717 Y109.98 E.07907
G1 X169.583 Y110.113
G1 X169.05 Y110.113
G1 X169.183 Y109.98
G1 X171.518 Y107.645 E.10248
G1 X171.652 Y107.512
G1 X171.652 Y106.978
G1 X171.518 Y107.112
G1 X168.65 Y109.98 E.12589
G1 X168.517 Y110.113
G1 X167.983 Y110.113
G1 X168.117 Y109.98
G1 X171.518 Y106.579 E.1493
G1 X171.652 Y106.445
G1 X171.652 Y105.912
G1 X171.518 Y106.045
G1 X167.584 Y109.98 E.17271
G1 X167.45 Y110.113
G1 X167.539 Y111.09
G1 X167.406 Y111.224
G1 X166.65 Y111.98 E.03317
G1 X166.517 Y112.113
G1 X165.983 Y112.113
G1 X166.117 Y111.98
G1 X167.406 Y110.691 E.05658
G1 X167.539 Y110.557
G1 X167.539 Y110.024
G1 X167.406 Y110.158
G1 X165.584 Y111.98 E.07999
G1 X165.45 Y112.113
G1 X164.917 Y112.113
G1 X165.05 Y111.98
G1 X171.518 Y105.512 E.28391
G1 X171.652 Y105.379
M73 P98 R0
G1 X171.652 Y104.845
G1 X171.518 Y104.979
G1 X164.517 Y111.98 E.30732
G1 X164.384 Y112.113
G1 X163.85 Y112.113
G1 X163.984 Y111.98
G1 X171.149 Y104.814 E.31454
G1 X171.283 Y104.681
G1 X170.75 Y104.681
G1 X170.616 Y104.814
G1 X163.451 Y111.98 E.31454
G1 X163.317 Y112.113
G1 X162.784 Y112.113
G1 X162.917 Y111.98
G1 X170.083 Y104.814 E.31454
G1 X170.216 Y104.681
G1 X169.683 Y104.681
G1 X169.549 Y104.814
G1 X162.384 Y111.98 E.31454
G1 X162.25 Y112.113
G1 X161.717 Y112.113
G1 X161.851 Y111.98
G1 X169.016 Y104.814 E.31454
G1 X169.15 Y104.681
G1 X168.616 Y104.681
G1 X168.483 Y104.814
G1 X161.318 Y111.98 E.31454
G1 X161.184 Y112.113
G1 X160.651 Y112.113
G1 X160.784 Y111.98
G1 X167.95 Y104.814 E.31454
G1 X168.083 Y104.681
G1 X167.55 Y104.681
G1 X167.416 Y104.814
G1 X160.251 Y111.98 E.31454
G1 X160.117 Y112.113
G1 X159.584 Y112.113
G1 X159.718 Y111.98
G1 X167.406 Y104.292 E.33749
G1 X167.539 Y104.158
G1 X167.539 Y103.625
G1 X167.406 Y103.758
G1 X159.185 Y111.98 E.3609
G1 X159.051 Y112.113
G1 X158.518 Y112.113
G1 X158.651 Y111.98
G1 X167.406 Y103.225 E.38431
G1 X167.539 Y103.092
G1 X167.417 Y102.681
G1 X167.283 Y102.814
G1 X158.118 Y111.98 E.40234
G1 X157.984 Y112.113
G1 X157.451 Y112.113
G1 X157.585 Y111.98
G1 X166.75 Y102.814 E.40234
G1 X166.884 Y102.681
G1 X166.35 Y102.681
G1 X166.217 Y102.814
G1 X157.052 Y111.98 E.40234
G1 X156.918 Y112.113
G1 X156.385 Y112.113
G1 X156.518 Y111.98
G1 X165.684 Y102.814 E.40234
G1 X165.817 Y102.681
G1 X165.284 Y102.681
G1 X165.15 Y102.814
G1 X155.985 Y111.98 E.40234
G1 X155.851 Y112.113
G1 X155.318 Y112.113
G1 X155.452 Y111.98
G1 X164.617 Y102.814 E.40234
G1 X164.751 Y102.681
G1 X164.217 Y102.681
G1 X164.084 Y102.814
G1 X155.353 Y111.546 E.38328
G1 X155.219 Y111.679
G1 X155.219 Y111.146
G1 X155.353 Y111.012
G1 X163.551 Y102.814 E.35987
G1 X163.684 Y102.681
G1 X163.151 Y102.681
G1 X163.017 Y102.814
G1 X155.353 Y110.479 E.33646
G1 X155.219 Y110.613
G1 X155.219 Y110.079
G1 X155.353 Y109.946
G1 X162.484 Y102.814 E.31305
G1 X162.618 Y102.681
G1 X162.084 Y102.681
G1 X161.951 Y102.814
G1 X155.353 Y109.412 E.28965
G1 X155.219 Y109.546
G1 X155.219 Y109.013
G1 X155.353 Y108.879
G1 X161.417 Y102.814 E.26624
M204 S10000
G1 X160.983 Y102.796 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.30607
G1 F15000
M204 S8000
G1 X155.334 Y108.445 E.17308
; WIPE_START
G1 X156.041 Y107.738 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U244 V110 Z3.2 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

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
G1 Z3.2 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z12.8 F900 ; lower z a little

G90
M141 S0 ; turn off chamber heating
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan
M106 P9 S0 ; turn off ext toodhead cooling fan

; pull back filament to AMS
M620 S65535

M620.11 P1 I0 B-1 E-14 F623.623



M620.11 K1 I0 B-1 R10 F623.623


M620.11 P1 I0 B-1 E-14
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

    
        G1 Z101.4 F600
        G1 Z99.4
    

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

