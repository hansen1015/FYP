; HEADER_BLOCK_START
; BambuStudio 02.06.00.51
; model printing time: 25m 5s; total estimated time: 30m 13s
; total layer number: 14
; total filament length [mm] : 696.88,140.71,140.37
; total filament volume [cm^3] : 1676.19,338.45,337.63
; total filament weight [g] : 2.11,0.43,0.42
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
; different_settings_to_system = bridge_speed;default_acceleration;enable_overhang_speed;enable_support_ironing;gap_infill_speed;initial_layer_acceleration;initial_layer_infill_speed;initial_layer_speed;initial_layer_travel_acceleration;inner_wall_acceleration;inner_wall_speed;internal_solid_infill_speed;outer_wall_acceleration;outer_wall_speed;skeleton_infill_density;skin_infill_density;small_perimeter_threshold;sparse_infill_density;sparse_infill_pattern;sparse_infill_speed;support_interface_speed;support_speed;top_surface_acceleration;top_surface_speed;travel_acceleration;travel_short_distance_acceleration;travel_speed;;additional_cooling_fan_speed;fan_max_speed;fan_min_speed;filament_change_length;filament_change_length_nc;filament_retract_restart_extra;filament_retract_when_changing_layer;filament_retraction_minimum_travel;filament_start_gcode;nozzle_temperature;nozzle_temperature_initial_layer;nozzle_temperature_range_high;nozzle_temperature_range_low;nozzle_temperature;nozzle_temperature_initial_layer;
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
; inner_wall_acceleration = 0,50
; inner_wall_jerk = 9
; inner_wall_line_width = 0.45
; inner_wall_speed = 10,50
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
; outer_wall_acceleration = 25,50
; outer_wall_jerk = 9
; outer_wall_line_width = 0.42
; outer_wall_speed = 10,50
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
; wipe_tower_x = 165,40,40,135.746,40,140.428,165,148.593
; wipe_tower_y = 250,200,200,150.855,200,62.841,250,168.713
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
M73 P0 R30
M73 C7
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




    M620.14 X182.06 Y183.749



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
    
M73 P0 R29
M73 C6
    G1 E-3 F1800
    M400 P500
    G150.2
    G150.1


G91
M73 P1 R29
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
M73 P16 R25
M73 C2
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
    G29 A1 O X136.564 Y89.0685 I62.0062 J109.759 R 
    M400
M623
    
M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X136.564 Y89.0685 I62.0062 J109.759 R
    
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
G1 E-.4 F1800
; layer num/total_layer_count: 1/14
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
M106 P2 S0
; OBJECT_ID: 756
M73 C1
G1 X145.857 Y91.818 F60000
M204 S6000
G1 Z1
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
; LAYER_HEIGHT: 0.2
G1 F3000
M204 S500
G1 X145.857 Y92.276 E.0172
G1 X158.271 Y92.276 E.4671
G1 X158.271 Y89.926 E.08842
G1 X176.857 Y89.926 E.69932
G1 X176.857 Y92.276 E.08842
G1 X189.271 Y92.276 E.4671
G1 X189.271 Y89.926 E.08842
M73 P17 R25
G1 X197.707 Y89.926 E.31741
G1 X197.707 Y98.211 E.31177
G1 X189.271 Y98.211 E.31741
G1 X189.271 Y95.861 E.08842
G1 X176.857 Y95.861 E.4671
G1 X176.857 Y98.211 E.08842
G1 X137.421 Y98.211 E1.48382
G1 X137.421 Y89.926 E.31177
G1 X145.857 Y89.926 E.31741
G1 X145.857 Y91.758 E.06897
M204 S6000
G1 X146.314 Y91.818 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X157.814 Y91.818 E.4327
G1 X157.814 Y89.468 E.08842
G1 X177.314 Y89.468 E.73371
G1 X177.314 Y91.818 E.08842
G1 X188.814 Y91.818 E.4327
G1 X188.814 Y89.468 E.08842
G1 X198.164 Y89.468 E.35181
G1 X198.164 Y98.668 E.34616
G1 X188.814 Y98.668 E.35181
G1 X188.814 Y96.318 E.08842
G1 X177.314 Y96.318 E.4327
G1 X177.314 Y98.668 E.08842
M73 P17 R24
G1 X136.964 Y98.668 E1.51822
G1 X136.964 Y89.468 E.34616
G1 X146.314 Y89.468 E.35181
G1 X146.314 Y91.758 E.08616
; WIPE_START
G1 X147.314 Y91.764 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I.041 J1.216 P1  F60000
G1 X196.599 Y90.108 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50039
G1 F6300
M204 S500
G1 X197.318 Y90.827 E.0383
G1 X197.318 Y91.474 E.02436
G1 X196.158 Y90.314 E.0618
G1 X195.511 Y90.314 E.02436
G1 X197.318 Y92.121 E.09625
G1 X197.318 Y92.768 E.02436
G1 X194.864 Y90.314 E.13071
G1 X194.217 Y90.314 E.02436
G1 X197.318 Y93.415 E.16516
G1 X197.318 Y94.062 E.02436
G1 X193.57 Y90.314 E.19962
G1 X192.923 Y90.314 E.02436
G1 X197.318 Y94.709 E.23407
G1 X197.318 Y95.356 E.02436
G1 X192.276 Y90.314 E.26853
G1 X191.629 Y90.314 E.02436
G1 X197.318 Y96.003 E.30299
G1 X197.318 Y96.65 E.02436
G1 X190.982 Y90.314 E.33744
G1 X190.335 Y90.314 E.02436
G1 X197.318 Y97.297 E.3719
G1 X197.318 Y97.823 E.0198
G1 X197.197 Y97.823 E.00456
G1 X189.688 Y90.314 E.3999
G1 X189.659 Y90.314 E.00109
G1 X189.659 Y90.932 E.02328
G1 X196.55 Y97.823 E.36698
G1 X195.903 Y97.823 E.02436
G1 X189.659 Y91.579 E.33253
G1 X189.659 Y92.226 E.02436
G1 X195.256 Y97.823 E.29807
G1 X194.609 Y97.823 E.02436
G1 X189.45 Y92.664 E.27475
G1 X188.803 Y92.664 E.02436
G1 X193.962 Y97.823 E.27475
G1 X193.315 Y97.823 E.02436
G1 X188.156 Y92.664 E.27475
G1 X187.509 Y92.664 E.02436
G1 X192.668 Y97.823 E.27475
G1 X192.021 Y97.823 E.02436
G1 X186.863 Y92.664 E.27475
G1 X186.216 Y92.664 E.02436
G1 X189.024 Y95.473 E.14959
G1 X189.659 Y95.473 E.02391
G1 X189.659 Y96.108 E.02391
G1 X191.374 Y97.823 E.09134
G1 X190.727 Y97.823 E.02436
G1 X189.659 Y96.755 E.05688
G1 X189.659 Y97.402 E.02436
G1 X190.286 Y98.029 E.03338
; WIPE_START
G1 X189.659 Y97.402 E-.33685
G1 X189.659 Y97.288 E-.04315
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.012 J-.676 P1  F60000
G1 X188.583 Y95.679 Z.6
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X185.569 Y92.664 E.16055
G1 X184.922 Y92.664 E.02436
G1 X187.731 Y95.473 E.14959
G1 X187.084 Y95.473 E.02436
G1 X184.275 Y92.664 E.14959
G1 X183.628 Y92.664 E.02436
G1 X186.437 Y95.473 E.14959
G1 X185.79 Y95.473 E.02436
G1 X182.981 Y92.664 E.14959
G1 X182.334 Y92.664 E.02436
G1 X185.143 Y95.473 E.14959
G1 X184.496 Y95.473 E.02436
G1 X181.687 Y92.664 E.14959
G1 X181.04 Y92.664 E.02436
G1 X183.849 Y95.473 E.14959
G1 X183.202 Y95.473 E.02436
G1 X180.393 Y92.664 E.14959
G1 X179.746 Y92.664 E.02436
G1 X182.555 Y95.473 E.14959
G1 X181.908 Y95.473 E.02436
G1 X179.099 Y92.664 E.14959
G1 X178.452 Y92.664 E.02436
G1 X181.261 Y95.473 E.14959
G1 X180.614 Y95.473 E.02436
G1 X177.805 Y92.664 E.14959
G1 X177.158 Y92.664 E.02436
G1 X180.173 Y95.679 E.16055
; WIPE_START
G1 X179.466 Y94.971 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.005 J-.687 P1  F60000
G1 X176.674 Y90.886 Z.6
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X176.102 Y90.314 E.03045
G1 X175.455 Y90.314 E.02436
G1 X176.468 Y91.327 E.05396
G1 X176.468 Y91.974 E.02436
G1 X174.808 Y90.314 E.08841
G1 X174.161 Y90.314 E.02436
G1 X179.32 Y95.473 E.27474
G1 X178.673 Y95.473 E.02436
G1 X173.514 Y90.314 E.27474
G1 X172.867 Y90.314 E.02436
G1 X178.026 Y95.473 E.27474
G1 X177.379 Y95.473 E.02436
G1 X172.22 Y90.314 E.27474
G1 X171.573 Y90.314 E.02436
G1 X176.732 Y95.473 E.27474
G1 X176.468 Y95.473 E.00994
G1 X176.468 Y95.856 E.01442
G1 X170.926 Y90.314 E.29514
G1 X170.279 Y90.314 E.02436
G1 X176.468 Y96.503 E.3296
G1 X176.468 Y97.15 E.02436
M73 P18 R24
G1 X169.632 Y90.314 E.36405
G1 X168.985 Y90.314 E.02436
G1 X176.468 Y97.797 E.39851
G1 X176.468 Y97.823 E.00098
G1 X175.847 Y97.823 E.02338
G1 X168.339 Y90.314 E.3999
G1 X167.692 Y90.314 E.02436
G1 X175.2 Y97.823 E.3999
G1 X174.553 Y97.823 E.02436
G1 X167.045 Y90.314 E.3999
G1 X166.398 Y90.314 E.02436
G1 X173.906 Y97.823 E.3999
G1 X173.26 Y97.823 E.02436
G1 X165.751 Y90.314 E.3999
G1 X165.104 Y90.314 E.02436
G1 X172.613 Y97.823 E.3999
G1 X171.966 Y97.823 E.02436
G1 X164.457 Y90.314 E.3999
G1 X163.81 Y90.314 E.02436
G1 X171.319 Y97.823 E.3999
G1 X170.672 Y97.823 E.02436
G1 X163.163 Y90.314 E.3999
G1 X162.516 Y90.314 E.02436
G1 X170.025 Y97.823 E.3999
G1 X169.378 Y97.823 E.02436
G1 X161.869 Y90.314 E.3999
G1 X161.222 Y90.314 E.02436
G1 X168.731 Y97.823 E.3999
G1 X168.084 Y97.823 E.02436
G1 X160.575 Y90.314 E.3999
G1 X159.928 Y90.314 E.02436
G1 X167.437 Y97.823 E.3999
G1 X166.79 Y97.823 E.02436
G1 X159.281 Y90.314 E.3999
G1 X158.659 Y90.314 E.02341
G1 X158.659 Y90.339 E.00095
G1 X166.143 Y97.823 E.39855
G1 X165.496 Y97.823 E.02436
G1 X158.659 Y90.986 E.3641
G1 X158.659 Y91.633 E.02436
G1 X164.849 Y97.823 E.32964
G1 X164.202 Y97.823 E.02436
G1 X158.659 Y92.28 E.29519
G1 X158.659 Y92.664 E.01446
G1 X158.396 Y92.664 E.00991
G1 X163.555 Y97.823 E.27475
G1 X162.908 Y97.823 E.02436
G1 X157.749 Y92.664 E.27475
G1 X157.102 Y92.664 E.02436
G1 X162.261 Y97.823 E.27475
G1 X161.614 Y97.823 E.02436
G1 X156.455 Y92.664 E.27475
G1 X155.808 Y92.664 E.02436
G1 X160.967 Y97.823 E.27475
G1 X160.32 Y97.823 E.02436
G1 X155.161 Y92.664 E.27475
G1 X154.515 Y92.664 E.02436
G1 X159.673 Y97.823 E.27475
G1 X159.026 Y97.823 E.02436
G1 X153.868 Y92.664 E.27474
G1 X153.221 Y92.664 E.02436
G1 X158.379 Y97.823 E.27474
G1 X157.732 Y97.823 E.02436
G1 X152.574 Y92.664 E.27474
G1 X151.927 Y92.664 E.02436
G1 X157.086 Y97.823 E.27474
G1 X156.439 Y97.823 E.02436
G1 X151.28 Y92.664 E.27474
G1 X150.633 Y92.664 E.02436
G1 X155.792 Y97.823 E.27474
G1 X155.145 Y97.823 E.02436
G1 X149.986 Y92.664 E.27474
G1 X149.339 Y92.664 E.02436
G1 X154.498 Y97.823 E.27474
G1 X153.851 Y97.823 E.02436
G1 X148.692 Y92.664 E.27474
G1 X148.045 Y92.664 E.02436
G1 X153.204 Y97.823 E.27474
G1 X152.557 Y97.823 E.02436
G1 X147.398 Y92.664 E.27474
G1 X146.751 Y92.664 E.02436
G1 X152.116 Y98.029 E.2857
; WIPE_START
G1 X151.408 Y97.321 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I.905 J-.813 P1  F60000
G1 X145.674 Y90.94 Z.6
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X145.048 Y90.314 E.03334
G1 X144.401 Y90.314 E.02436
G1 X145.674 Y91.587 E.06779
; WIPE_START
G1 X144.967 Y90.88 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I.581 J-1.069 P1  F60000
G1 X143.548 Y90.108 Z.6
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X145.468 Y92.028 E.10225
G1 X145.468 Y92.664 E.02394
G1 X146.104 Y92.664 E.02394
G1 X151.263 Y97.823 E.27474
G1 X150.616 Y97.823 E.02436
G1 X143.107 Y90.314 E.3999
G1 X142.46 Y90.314 E.02436
G1 X149.969 Y97.823 E.3999
G1 X149.322 Y97.823 E.02436
G1 X141.813 Y90.314 E.3999
G1 X141.166 Y90.314 E.02436
G1 X148.675 Y97.823 E.3999
G1 X148.028 Y97.823 E.02436
G1 X140.519 Y90.314 E.3999
G1 X139.872 Y90.314 E.02436
G1 X147.381 Y97.823 E.3999
G1 X146.734 Y97.823 E.02436
G1 X139.225 Y90.314 E.3999
G1 X138.578 Y90.314 E.02436
G1 X146.087 Y97.823 E.3999
G1 X145.44 Y97.823 E.02436
G1 X137.931 Y90.314 E.3999
G1 X137.809 Y90.314 E.0046
G1 X137.809 Y90.839 E.01977
G1 X144.793 Y97.823 E.37194
G1 X144.146 Y97.823 E.02436
G1 X137.809 Y91.486 E.33749
G1 X137.809 Y92.133 E.02436
G1 X143.499 Y97.823 E.30303
G1 X142.852 Y97.823 E.02436
G1 X137.809 Y92.78 E.26858
G1 X137.809 Y93.427 E.02436
G1 X142.205 Y97.823 E.23412
G1 X141.558 Y97.823 E.02436
G1 X137.809 Y94.074 E.19967
G1 X137.809 Y94.721 E.02436
G1 X140.912 Y97.823 E.16521
G1 X140.265 Y97.823 E.02436
G1 X137.809 Y95.368 E.13076
G1 X137.809 Y96.015 E.02436
G1 X139.618 Y97.823 E.0963
G1 X138.971 Y97.823 E.02436
G1 X137.809 Y96.662 E.06185
G1 X137.809 Y97.309 E.02436
G1 X138.529 Y98.029 E.03834
; WIPE_START
G1 X137.822 Y97.321 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
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
    

    

    
        M9711 M0 E0 U266 V97 Z0.6 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

M204 S6000
G1 X177.558 Y195.749
G1 Z.2
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S6000
G1  X178.058 Y196.749  
M204 S500
G3  X175.599 Y198.794   I-4.377 J-2.762 E0.1236 F3000
G3  X172.940 Y197.538   I0.009 J-3.462 E0.1154
G2  X170.236 Y196.749   I-2.710 J4.259 E0.1085
G2  X158.190 Y196.753   I-5.928 J318.375 E0.4578
M73 P19 R24
G2  X154.243 Y198.635   I0.501 J6.129 E0.1699
G3  X151.932 Y198.202   I-0.852 J-1.839 E0.0953
G3  X148.870 Y194.931   I16.406 J-18.427 E0.1705
G3  X149.704 Y191.976   I2.026 J-1.023 E0.1282
G2  X150.558 Y189.443   I-3.390 J-2.554 E0.1033
G2  X150.555 Y177.885   I-283.960 J-5.694 E0.4393
G2  X149.450 Y175.221   I-4.224 J0.190 E0.1118
G1 E-0.4000 F1800
M204 S6000
G1  X148.645 Y173.025   F600
G1 E0.4000 F1800
M204 S500
G3  X149.047 Y172.347   I1.906 J0.672 E0.0302 F3000
G3  X152.165 Y169.085   I19.448 J15.469 E0.1717
G3  X155.363 Y169.743   I1.278 J1.891 E0.1383
G2  X158.380 Y170.749   I3.023 J-4.037 E0.1230
G1  X164.308  E0.2253
G1  X165.558  E0.0475
G2  X171.182 Y170.659   I2.339 J-29.659 E0.2141
G2  X174.517 Y168.801   I-2.882 J-9.098 E0.1461
G3  X176.684 Y169.296   I0.711 J1.877 E0.0895
G3  X179.746 Y172.567   I-16.399 J18.421 E0.1705
G3  X178.912 Y175.522   I-2.026 J1.023 E0.1282
G2  X178.058 Y178.055   I3.390 J2.554 E0.1033
G2  X178.061 Y189.613   I283.960 J5.694 E0.4393
G2  X179.904 Y193.178   I6.625 J-1.166 E0.1549
G3  X179.569 Y195.151   I-1.652 J0.734 E0.0806
G1  X178.058 Y196.749   E0.0836
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
G3 Z.6 I1.217 J0 P1  F60000
G1 X151.308 Y171.499
G1 Z.2
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
M204 S500
G1  X177.308 Y171.499  E2.0691 F7836
G1  Y172.499  E0.0796
G1  X151.308  E2.0691
G1  Y173.499  E0.0796
G1  X177.308  E2.0691
M632 S2 M N
M204 S6000
G1  Y173.999 
G1  X151.808  F4500
G1  Y172.999 
G1  X176.808 
G1  Y171.999 
G1  X151.808 
M633
; NOZZLE_CHANGE_END OF0 NF2 ON2 NN1

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
M620 S2A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z3.2 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X149.058 Y174.249



M620.10 A0 F498.898 L0 H0.4 T240 P220 S1



M620.10 A1 F419.075 L0 H0.4 T240 P230 S1



M620.11 P1 I0 B-1 E-14 F623.623



M620.15 P180
M620.15 C230
M620.11 O1 T18


M620.11 K1 I0 B-1 R10 F623.623


M620.15 C230

M628 S1


M620.11 S1 L0 I0 B-1 R10 D8 E-14 F623.623


M629


;M620.11 H0




T2 H-1
M73 E13

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
M73 P21 R23
G1 Z3.2 F3000

M204 S25


M621 S2A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F8.75 A0.4 R2
M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.2

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I2 H-1 W1 ;enable ams air printing detect
M620 O2
M1002 gcode_claim_action : 0
M106 S0
M106 P2 S0

; filament start gcode
G1 X151.058 Y174.249 F60000
G1 Z.2
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL1
; LINE_WIDTH: 0.500000
; LINE_WIDTH: 0.500000
M204 S500
G1  X154.058 Y174.249  E0.1140 F990
G1 E-0.4000 F1800
M204 S6000
G1  X149.558  F600
G1  X151.058  F240
G1  X151.558  F600
G1  Y174.749 
G1  X150.558 
G1  Y173.749 
G1  X152.058 
G1  Y175.249 
G1  X150.058 
G1  Y173.249 
G1  X154.058 Y174.249   F990
G1 E0.4000 F1800
M204 S500
G1  X177.558  E0.8931 F990
G1  Y174.749  E0.0190
G1  X151.058  E1.0072 F1125
G1  Y175.249  E0.0190
G1  X177.558  E1.0072 F1374
G1  Y175.749  E0.0190
G1  X151.058  E1.0072 F2625
G1  Y176.249  E0.0190
G1  X177.558  E1.0072 F2675
G1  Y176.749  E0.0190
G1  X151.058  E1.0072
G1  Y177.249  E0.0190
G1  X177.558  E1.0072
G1  Y177.749  E0.0190
G1  X151.058  E1.0072
G1  Y178.249  E0.0190
G1  X177.558  E1.0072
G1  Y178.749  E0.0190
G1  X151.058  E1.0072
G1  Y179.249  E0.0190
G1  X177.558  E1.0072
G1  Y179.749  E0.0190
G1  X151.058  E1.0072
G1  Y180.249  E0.0190
G1  X177.558  E1.0072
G1  Y180.749  E0.0190
G1  X151.058  E1.0072
G1  Y181.249  E0.0190
G1  X177.558  E1.0072
G1  Y181.749  E0.0190
G1  X151.058  E1.0072
G1  Y182.249  E0.0190
G1  X177.558  E1.0072
G1  Y182.749  E0.0190
G1  X151.058  E1.0072
G1  Y183.249  E0.0190
M73 P22 R23
G1  X177.558  E1.0072
; LINE_WIDTH: 0.500000
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y196.249   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S500
G1  X151.058  E1.0072 F3000
G1  Y183.999  E0.4656
G1  X177.558  E1.0072
G1  Y196.249  E0.4656
M204 S6000
G1  X152.058 Y183.999  
;--------------------
; CP EMPTY GRID START
; layer #2
M204 S500
G1  Y184.499  E0.0190
G1  X177.058  E0.9502
G1  Y185.010  E0.0194
G1  X151.558  E0.9692
G1  Y185.522  E0.0194
G1  X177.058  E0.9692
G1  Y186.033  E0.0194
G1  X151.558  E0.9692
G1  Y186.544  E0.0194
G1  X177.058  E0.9692
G1  Y187.056  E0.0194
G1  X151.558  E0.9692
G1  Y187.567  E0.0194
G1  X177.058  E0.9692
G1  Y188.079  E0.0194
G1  X151.558  E0.9692
G1  Y188.590  E0.0194
G1  X177.058  E0.9692
G1  Y189.101  E0.0194
G1  X151.558  E0.9692
G1  Y189.613  E0.0194
G1  X177.058  E0.9692
G1  Y190.124  E0.0194
G1  X151.558  E0.9692
G1  Y190.635  E0.0194
G1  X177.058  E0.9692
G1  Y191.147  E0.0194
G1  X151.558  E0.9692
G1  Y191.658  E0.0194
G1  X177.058  E0.9692
G1  Y192.169  E0.0194
G1  X151.558  E0.9692
G1  Y192.681  E0.0194
G1  X177.058  E0.9692
G1  Y193.192  E0.0194
G1  X151.558  E0.9692
G1  Y193.704  E0.0194
G1  X177.058  E0.9692
G1  Y194.215  E0.0194
G1  X151.558  E0.9692
G1  Y194.726  E0.0194
G1  X177.058  E0.9692
G1  Y195.238  E0.0194
G1  X151.558  E0.9692
G1  Y195.749  E0.0194
G1  X177.058  E0.9692
G1  Y196.249  E0.0190
; CP EMPTY GRID END
;------------------






; WIPE_TOWER_END

; WIPE_START
M73 P23 R23
G1 F6300
M204 S500
G1 X176.337 Y195.556 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.217 J0 P1  F60000
; OBJECT_ID: 756
M204 S6000
G1 X156.857 Y90.861
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
; LAYER_HEIGHT: 0.2
G1 F3000
M204 S500
G1 X147.271 Y90.861 E.36432
G1 X147.271 Y89.926 E.03557
G1 X156.857 Y89.926 E.36432
G1 X156.857 Y90.801 E.03329
M204 S6000
G1 X157.314 Y91.318 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X146.814 Y91.318 E.39907
G1 X146.814 Y89.468 E.07031
G1 X157.314 Y89.468 E.39907
G1 X157.314 Y91.258 E.06803
; WIPE_START
G1 X156.314 Y91.264 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I.022 J1.217 P1  F60000
G1 X178.271 Y90.861 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X178.271 Y89.926 E.03557
G1 X187.857 Y89.926 E.36432
G1 X187.857 Y90.861 E.03557
G1 X178.331 Y90.861 E.36204
M204 S6000
G1 X177.814 Y91.318 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X177.814 Y89.468 E.07031
G1 X188.314 Y89.468 E.39907
G1 X188.314 Y91.318 E.07031
G1 X177.874 Y91.318 E.39679
; WIPE_START
G1 X177.841 Y90.319 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I-.694 J1 P1  F60000
G1 X187.857 Y97.276 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X187.857 Y98.211 E.03557
G1 X178.271 Y98.211 E.36432
G1 X178.271 Y97.276 E.03557
G1 X187.797 Y97.276 E.36204
M204 S6000
G1 X188.314 Y96.818 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X188.314 Y98.668 E.07031
G1 X177.814 Y98.668 E.39907
G1 X177.814 Y96.818 E.07031
G1 X188.254 Y96.818 E.39679
; WIPE_START
G1 X188.286 Y97.818 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I.137 J-1.209 P1  F60000
G1 X187.628 Y97.743 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.52172
G1 F3000
M204 S500
G1 X178.499 Y97.743 E.36344
; WIPE_START
G1 X179.499 Y97.743 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.206 J-.164 P1  F60000
G1 X178.499 Y90.393 Z.6
G1 Z.2
G1 E.4 F1800
G1 F3000
M204 S500
G1 X187.628 Y90.393 E.36344
; WIPE_START
G1 X186.628 Y90.393 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I0 J-1.217 P1  F60000
G1 X156.628 Y90.393 Z.6
G1 Z.2
G1 E.4 F1800
G1 F3000
M204 S500
G1 X147.499 Y90.393 E.36344
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
M73 C0
G1 X148.499 Y90.393 E-.38
; WIPE_END
G1 E-.02 F1800
; layer num/total_layer_count: 2/14
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
M106 S255
M106 P2 S191
; open powerlost recovery
M1003 S1
; PAUSE_PRINTING
M400 U1

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
    

    

    
        M9711 M0 E0 U266 V97 Z0.8 S11 C10 O0 T3000
    

    
    
    
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
G1 X151.308 Y171.499
G1 Z.4
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
G1  X177.308 Y171.499  E2.0691 F6583
G1  Y172.999  E0.1194
G1  X151.308  E2.0691
M632 S0 M N
M204 S10000
G1  Y173.749 
G1  X176.808  F3000
G1  Y172.249 
G1  X151.808 
M633
; NOZZLE_CHANGE_END OF2 NF0 ON1 NN2

G1 E-2 F1800
G17
G3 Z.8 I1.217 J0 P1  F5400
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

G1 Z3.4 F1200

M400
M106 P1 S0
M106 P2 S0


; get travel path for change filament
;M620.1 X54 Y0 F21000 P0
;M620.1 X54 Y0 F21000 P1
;M620.1 X54 Y245 F21000 P2



    M620.14 X179.558 Y183.249



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
M73 E12

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
M73 P25 R22
G1 Z3.4 F3000

M204 S25


M621 S0A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
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


M620.6 I0 H-1 W1 ;enable ams air printing detect
M620 O3
M1002 gcode_claim_action : 0
M106 S153
M106 P2 S191

; filament start gcode
G1 X177.558 Y183.249 F60000
G1 Z.4
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X174.558 Y183.249  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X179.058  F600
G1  X177.558  F240
G1  X178.058  F600
G1  Y183.749 
G1  X177.058 
G1  Y182.749 
G1  X178.558 
G1  Y184.249 
G1  X176.558 
G1  Y182.249 
G1  X174.558 Y183.249   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X151.058  E0.8931 F1782
G1  Y182.499  E0.0285
G1  X177.558  E1.0072 F2025
G1  Y181.749  E0.0285
G1  X151.058  E1.0072 F2473
G1  Y180.999  E0.0285
G1  X177.558  E1.0072 F4725
G1  Y180.249  E0.0285
G1  X151.058  E1.0072 F4775
G1  Y179.499  E0.0285
G1  X177.558  E1.0072
G1  Y178.749  E0.0285
G1  X151.058  E1.0072
G1  Y177.999  E0.0285
G1  X177.558  E1.0072
G1  Y177.249  E0.0285
G1  X151.058  E1.0072
G1  Y176.499  E0.0285
G1  X177.558  E1.0072
G1  Y175.749  E0.0285
G1  X151.058  E1.0072
G1  Y174.999  E0.0285
G1  X177.558  E1.0072
G1  Y174.249  E0.0285
G1  X151.058  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  X177.558 Y195.749   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X177.908 Y196.907  
M204 S8000
G3  X175.130 Y198.826   I-3.470 J-2.054 E0.1324
G3  X172.777 Y197.439   I1.442 J-5.134 E0.1049
G2  X170.236 Y196.749   I-2.569 J4.438 E0.1012
G2  X158.190 Y196.753   I-5.928 J318.375 E0.4578
G2  X154.243 Y198.635   I0.501 J6.129 E0.1699
G3  X151.932 Y198.202   I-0.852 J-1.839 E0.0953
G3  X148.870 Y194.931   I16.406 J-18.427 E0.1705
M632 S1 W
M400
M104 T1 S140 N0 ;Multi extruder pre heating
M633
G3  X149.704 Y191.976   I2.026 J-1.023 E0.1282
G2  X150.558 Y189.443   I-3.390 J-2.554 E0.1033
G2  X150.555 Y177.885   I-283.960 J-5.694 E0.4393
G2  X148.712 Y174.320   I-6.625 J1.166 E0.1549
G3  X149.047 Y172.347   I1.652 J-0.734 E0.0806
G3  X152.165 Y169.085   I19.448 J15.469 E0.1717
G3  X155.363 Y169.743   I1.278 J1.891 E0.1383
G2  X158.380 Y170.749   I3.023 J-4.037 E0.1230
G1  X164.308  E0.2253
G1  X165.558  E0.0475
G2  X171.182 Y170.659   I2.339 J-29.659 E0.2141
G2  X174.517 Y168.801   I-2.882 J-9.098 E0.1461
G3  X176.684 Y169.296   I0.711 J1.877 E0.0895
G3  X179.746 Y172.567   I-16.399 J18.421 E0.1705
G3  X178.912 Y175.522   I-2.026 J1.023 E0.1282
G2  X178.058 Y178.055   I3.390 J2.554 E0.1033
G1  Y181.999  E0.1499
G1 E-0.4000 F1800
M204 S10000
G1  Y184.499  F600
G1 E0.4000 F1800
M204 S8000
G2  X178.113 Y190.121   I34.504 J2.472 E0.2139 F5400
G2  X179.904 Y193.178   I6.530 J-1.771 E0.1363
G3  X179.623 Y195.088   I-1.648 J0.734 E0.0774
; WIPE_TOWER_END

; WIPE_START
G1 F3000
M204 S8000
G1 X179.661 Y195.045 E-.02221
G1 X179.746 Y194.931 E-.05374
G1 X179.821 Y194.812 E-.05374
G1 X179.887 Y194.686 E-.05372
G1 X179.942 Y194.556 E-.05373
G1 X179.987 Y194.422 E-.05374
G1 X180.022 Y194.285 E-.05374
G1 X180.038 Y194.193 E-.03538
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.217 J0 P1  F60000
; OBJECT_ID: 756
M204 S10000
G1 X181.166 Y95.966
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F3000
M204 S50
G1 X158.962 Y95.966 E.74407
G1 X158.962 Y98.466 E.08378
G1 X137.166 Y98.466 E.73039
G1 X137.166 Y89.671 E.29475
M73 P26 R22
G1 X141.462 Y89.671 E.14396
G1 X141.462 Y92.171 E.08378
G1 X150.166 Y92.171 E.29168
G1 X150.166 Y89.671 E.08378
G1 X153.962 Y89.671 E.1272
G1 X153.962 Y92.171 E.08378
G1 X181.166 Y92.171 E.91162
G1 X181.166 Y89.671 E.08378
G1 X184.962 Y89.671 E.1272
G1 X184.962 Y92.171 E.08378
G1 X194.166 Y92.171 E.30843
G1 X194.166 Y89.671 E.08378
G1 X197.962 Y89.671 E.1272
G1 X197.962 Y98.466 E.29475
G1 X194.166 Y98.466 E.1272
G1 X194.166 Y95.966 E.08378
G1 X184.962 Y95.966 E.30843
G1 X184.962 Y98.466 E.08378
G1 X181.166 Y98.466 E.1272
G1 X181.166 Y96.026 E.08177
M204 S250
G1 X180.774 Y96.358 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3000
M204 S50
G1 X159.354 Y96.358 E.66489
G1 X159.354 Y98.858 E.0776
G1 X136.774 Y98.858 E.7009
G1 X136.774 Y89.278 E.29737
G1 X141.854 Y89.278 E.15769
G1 X141.854 Y91.778 E.0776
G1 X149.774 Y91.778 E.24584
G1 X149.774 Y89.278 E.0776
G1 X154.354 Y89.278 E.14217
G1 X154.354 Y91.778 E.0776
G1 X180.774 Y91.778 E.8201
G1 X180.774 Y89.278 E.0776
G1 X185.354 Y89.278 E.14217
G1 X185.354 Y91.778 E.0776
G1 X193.774 Y91.778 E.26136
G1 X193.774 Y89.278 E.0776
G1 X198.354 Y89.278 E.14217
G1 X198.354 Y98.858 E.29737
G1 X193.774 Y98.858 E.14217
G1 X193.774 Y96.358 E.0776
G1 X185.354 Y96.358 E.26136
G1 X185.354 Y98.858 E.0776
G1 X180.774 Y98.858 E.14217
G1 X180.774 Y96.418 E.07574
; WIPE_START
M204 S8000
M73 P27 R22
G1 X179.774 Y96.416 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-.894 J.826 P1  F60000
G1 X181.519 Y98.303 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42121
G1 F15000
M204 S8000
G1 X187.318 Y92.504 E.25538
G1 X186.783 Y92.504 E.01666
G1 X181.499 Y97.788 E.23269
G1 X181.499 Y97.253 E.01666
G1 X186.248 Y92.504 E.20913
G1 X185.713 Y92.504 E.01666
G1 X181.499 Y96.718 E.18557
G1 X181.499 Y96.183 E.01666
G1 X185.178 Y92.504 E.16201
G1 X184.643 Y92.504 E.01666
G1 X181.499 Y95.648 E.13845
G1 X181.499 Y95.633 E.00045
G1 X180.979 Y95.633 E.01621
G1 X184.628 Y91.983 E.16074
G1 X184.628 Y91.448 E.01666
G1 X180.444 Y95.633 E.1843
G1 X179.909 Y95.633 E.01666
G1 X184.628 Y90.913 E.20786
G1 X184.628 Y90.378 E.01666
G1 X179.374 Y95.633 E.23142
G1 X178.839 Y95.633 E.01666
G1 X184.468 Y90.004 E.24791
G1 X183.933 Y90.004 E.01666
G1 X178.304 Y95.633 E.24791
G1 X177.769 Y95.633 E.01666
G1 X180.898 Y92.504 E.13781
G1 X180.363 Y92.504 E.01666
G1 X177.234 Y95.633 E.13781
G1 X176.699 Y95.633 E.01666
G1 X179.828 Y92.504 E.13781
G1 X179.293 Y92.504 E.01666
G1 X176.164 Y95.633 E.13781
G1 X175.629 Y95.633 E.01666
G1 X178.758 Y92.504 E.13781
G1 X178.223 Y92.504 E.01666
G1 X175.094 Y95.633 E.13781
G1 X174.559 Y95.633 E.01666
G1 X177.688 Y92.504 E.13781
G1 X177.153 Y92.504 E.01666
G1 X174.024 Y95.633 E.13781
G1 X173.489 Y95.633 E.01666
G1 X176.618 Y92.504 E.13781
G1 X176.083 Y92.504 E.01666
G1 X172.954 Y95.633 E.13781
G1 X172.419 Y95.633 E.01666
G1 X175.548 Y92.504 E.13781
G1 X175.013 Y92.504 E.01666
G1 X171.884 Y95.633 E.13781
G1 X171.349 Y95.633 E.01666
G1 X174.478 Y92.504 E.13781
G1 X173.943 Y92.504 E.01666
G1 X170.814 Y95.633 E.13781
G1 X170.279 Y95.633 E.01666
G1 X173.408 Y92.504 E.13781
G1 X172.873 Y92.504 E.01666
G1 X169.744 Y95.633 E.13781
G1 X169.209 Y95.633 E.01666
G1 X172.338 Y92.504 E.13781
G1 X171.803 Y92.504 E.01666
G1 X168.674 Y95.633 E.13781
G1 X168.139 Y95.633 E.01666
G1 X171.268 Y92.504 E.13781
G1 X170.733 Y92.504 E.01666
G1 X167.604 Y95.633 E.13781
G1 X167.069 Y95.633 E.01666
G1 X170.198 Y92.504 E.13781
G1 X169.663 Y92.504 E.01666
G1 X166.534 Y95.633 E.13781
G1 X165.999 Y95.633 E.01666
G1 X169.128 Y92.504 E.13781
G1 X168.593 Y92.504 E.01666
G1 X165.464 Y95.633 E.13781
G1 X164.929 Y95.633 E.01666
G1 X168.058 Y92.504 E.13781
G1 X167.523 Y92.504 E.01666
G1 X164.394 Y95.633 E.13781
G1 X163.859 Y95.633 E.01666
G1 X166.989 Y92.504 E.13781
G1 X166.454 Y92.504 E.01666
G1 X163.324 Y95.633 E.13781
G1 X162.789 Y95.633 E.01666
G1 X165.919 Y92.504 E.13781
G1 X165.384 Y92.504 E.01666
G1 X162.254 Y95.633 E.13781
G1 X161.719 Y95.633 E.01666
G1 X164.849 Y92.504 E.13781
G1 X164.314 Y92.504 E.01666
G1 X161.184 Y95.633 E.13781
G1 X160.649 Y95.633 E.01666
G1 X163.779 Y92.504 E.13781
G1 X163.244 Y92.504 E.01666
G1 X160.114 Y95.633 E.13781
G1 X159.579 Y95.633 E.01666
G1 X162.709 Y92.504 E.13781
G1 X162.174 Y92.504 E.01666
G1 X159.044 Y95.633 E.13781
G1 X158.628 Y95.633 E.01295
G1 X158.628 Y96.049 E.01295
G1 X156.544 Y98.133 E.09179
G1 X157.079 Y98.133 E.01666
M73 P27 R21
G1 X158.628 Y96.584 E.06822
G1 X158.628 Y97.119 E.01666
G1 X157.614 Y98.133 E.04466
G1 X158.149 Y98.133 E.01666
G1 X158.798 Y97.484 E.02858
M204 S10000
G1 X155.84 Y98.303 F60000
G1 F15000
M204 S8000
G1 X161.639 Y92.504 E.25538
G1 X161.104 Y92.504 E.01666
G1 X155.474 Y98.133 E.24791
G1 X154.939 Y98.133 E.01666
G1 X160.569 Y92.504 E.24791
G1 X160.034 Y92.504 E.01666
G1 X154.404 Y98.133 E.24791
G1 X153.869 Y98.133 E.01666
G1 X159.499 Y92.504 E.24791
G1 X158.964 Y92.504 E.01666
G1 X153.334 Y98.133 E.24791
G1 X152.799 Y98.133 E.01666
G1 X158.429 Y92.504 E.24791
G1 X157.894 Y92.504 E.01666
G1 X152.264 Y98.133 E.24791
G1 X151.729 Y98.133 E.01666
G1 X157.359 Y92.504 E.24791
G1 X156.824 Y92.504 E.01666
G1 X151.194 Y98.133 E.24791
G1 X150.659 Y98.133 E.01666
G1 X156.289 Y92.504 E.24791
G1 X155.754 Y92.504 E.01666
G1 X150.125 Y98.133 E.24791
G1 X149.59 Y98.133 E.01666
G1 X155.219 Y92.504 E.24791
G1 X154.684 Y92.504 E.01666
G1 X149.055 Y98.133 E.24791
G1 X148.52 Y98.133 E.01666
G1 X154.149 Y92.504 E.24791
G1 X153.628 Y92.504 E.01621
G1 X153.628 Y92.489 E.00045
G1 X147.985 Y98.133 E.24855
G1 X147.45 Y98.133 E.01666
G1 X153.628 Y91.954 E.27211
G1 X153.628 Y91.419 E.01666
G1 X146.915 Y98.133 E.29567
G1 X146.38 Y98.133 E.01666
G1 X153.628 Y90.884 E.31923
G1 X153.628 Y90.349 E.01666
G1 X145.845 Y98.133 E.34279
G1 X145.31 Y98.133 E.01666
G1 X153.439 Y90.004 E.35801
G1 X152.904 Y90.004 E.01666
G1 X144.775 Y98.133 E.35801
G1 X144.24 Y98.133 E.01666
G1 X149.869 Y92.504 E.24791
G1 X149.334 Y92.504 E.01666
G1 X143.705 Y98.133 E.24791
G1 X143.17 Y98.133 E.01666
G1 X148.799 Y92.504 E.24791
G1 X148.264 Y92.504 E.01666
G1 X142.635 Y98.133 E.24791
G1 X142.1 Y98.133 E.01666
G1 X147.729 Y92.504 E.24791
G1 X147.194 Y92.504 E.01666
G1 X141.565 Y98.133 E.24791
G1 X141.03 Y98.133 E.01666
G1 X146.659 Y92.504 E.24791
G1 X146.124 Y92.504 E.01666
G1 X140.495 Y98.133 E.24791
G1 X139.96 Y98.133 E.01666
G1 X145.589 Y92.504 E.24791
G1 X145.054 Y92.504 E.01666
G1 X139.425 Y98.133 E.24791
G1 X138.89 Y98.133 E.01666
G1 X144.519 Y92.504 E.24791
G1 X143.984 Y92.504 E.01666
G1 X138.355 Y98.133 E.24791
G1 X137.82 Y98.133 E.01666
G1 X143.449 Y92.504 E.24791
G1 X142.914 Y92.504 E.01666
G1 X137.499 Y97.919 E.23848
G1 X137.499 Y97.384 E.01666
G1 X142.379 Y92.504 E.21492
G1 X141.844 Y92.504 E.01666
G1 X137.499 Y96.849 E.19136
G1 X137.499 Y96.314 E.01666
G1 X141.309 Y92.504 E.1678
G1 X141.128 Y92.504 E.00563
G1 X141.128 Y92.15 E.01103
G1 X137.499 Y95.779 E.15983
G1 X137.499 Y95.244 E.01666
G1 X141.128 Y91.615 E.15983
G1 X141.128 Y91.08 E.01666
G1 X137.499 Y94.709 E.15983
G1 X137.499 Y94.174 E.01666
G1 X141.128 Y90.545 E.15983
G1 X141.128 Y90.01 E.01666
G1 X137.499 Y93.639 E.15983
G1 X137.499 Y93.104 E.01666
G1 X140.599 Y90.004 E.13654
G1 X140.064 Y90.004 E.01666
G1 X137.499 Y92.569 E.11297
G1 X137.499 Y92.034 E.01666
G1 X139.529 Y90.004 E.08941
G1 X138.994 Y90.004 E.01666
G1 X137.499 Y91.499 E.06585
G1 X137.499 Y90.964 E.01666
G1 X138.459 Y90.004 E.04229
G1 X137.925 Y90.004 E.01666
G1 X137.329 Y90.599 E.02621
; WIPE_START
G1 X137.925 Y90.004 E-.31979
G1 X138.083 Y90.004 E-.06021
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-.043 J1.216 P1  F60000
G1 X150.329 Y90.438 Z.8
G1 Z.4
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X150.764 Y90.004 E.01914
G1 X151.299 Y90.004 E.01666
G1 X150.499 Y90.804 E.03523
G1 X150.499 Y91.339 E.01666
G1 X151.834 Y90.004 E.05879
G1 X152.369 Y90.004 E.01666
G1 X150.329 Y92.043 E.08982
; WIPE_START
G1 X151.037 Y91.336 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I.035 J1.216 P1  F60000
G1 X181.329 Y90.467 Z.8
G1 Z.4
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X181.793 Y90.004 E.02042
G1 X182.328 Y90.004 E.01666
G1 X181.499 Y90.833 E.03651
G1 X181.499 Y91.368 E.01666
G1 X182.863 Y90.004 E.06007
G1 X183.398 Y90.004 E.01666
G1 X181.329 Y92.072 E.0911
M204 S10000
G1 X184.194 Y98.303 F60000
G1 F15000
M204 S8000
G1 X184.628 Y97.868 E.01915
G1 X184.628 Y97.333 E.01666
G1 X183.828 Y98.133 E.03523
G1 X183.293 Y98.133 E.01666
G1 X184.628 Y96.798 E.05879
G1 X184.628 Y96.263 E.01666
G1 X182.758 Y98.133 E.08235
G1 X182.223 Y98.133 E.01666
G1 X187.853 Y92.504 E.24791
G1 X188.388 Y92.504 E.01666
G1 X185.258 Y95.633 E.13781
G1 X185.793 Y95.633 E.01666
G1 X188.923 Y92.504 E.13781
G1 X189.458 Y92.504 E.01666
G1 X186.328 Y95.633 E.13781
G1 X186.863 Y95.633 E.01666
G1 X189.993 Y92.504 E.13781
G1 X190.528 Y92.504 E.01666
G1 X187.398 Y95.633 E.13781
G1 X187.933 Y95.633 E.01666
G1 X191.063 Y92.504 E.13781
G1 X191.598 Y92.504 E.01666
G1 X188.468 Y95.633 E.13781
G1 X189.003 Y95.633 E.01666
G1 X192.133 Y92.504 E.13781
G1 X192.668 Y92.504 E.01666
G1 X189.538 Y95.633 E.13781
G1 X190.073 Y95.633 E.01666
G1 X193.203 Y92.504 E.13781
G1 X193.738 Y92.504 E.01666
G1 X190.439 Y95.803 E.14529
; WIPE_START
G1 X191.146 Y95.096 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-.582 J1.069 P1  F60000
G1 X197.033 Y98.303 Z.8
G1 Z.4
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X197.628 Y97.708 E.02621
G1 X197.628 Y97.173 E.01666
G1 X196.668 Y98.133 E.0423
G1 X196.133 Y98.133 E.01666
G1 X197.628 Y96.638 E.06586
G1 X197.628 Y96.103 E.01666
G1 X195.598 Y98.133 E.08942
G1 X195.063 Y98.133 E.01666
G1 X197.628 Y95.568 E.11298
G1 X197.628 Y95.033 E.01666
G1 X194.528 Y98.133 E.13654
G1 X194.499 Y98.133 E.0009
G1 X194.499 Y97.627 E.01576
G1 X197.628 Y94.498 E.13781
G1 X197.628 Y93.963 E.01666
G1 X194.499 Y97.092 E.13781
G1 X194.499 Y96.557 E.01666
G1 X197.628 Y93.428 E.13781
G1 X197.628 Y92.893 E.01666
G1 X194.499 Y96.022 E.13781
G1 X194.499 Y95.633 E.01211
G1 X194.353 Y95.633 E.00455
G1 X197.628 Y92.358 E.14424
G1 X197.628 Y91.823 E.01666
G1 X193.818 Y95.633 E.1678
G1 X193.283 Y95.633 E.01666
G1 X197.628 Y91.288 E.19136
G1 X197.628 Y90.753 E.01666
G1 X192.748 Y95.633 E.21492
G1 X192.213 Y95.633 E.01666
G1 X197.628 Y90.218 E.23848
G1 X197.628 Y90.004 E.00667
G1 X197.308 Y90.004 E.00999
G1 X191.678 Y95.633 E.24791
G1 X191.143 Y95.633 E.01666
G1 X196.773 Y90.004 E.24791
G1 X196.238 Y90.004 E.01666
G1 X194.499 Y91.742 E.07656
G1 X194.499 Y91.207 E.01666
G1 X195.703 Y90.004 E.053
G1 X195.168 Y90.004 E.01666
G1 X194.499 Y90.672 E.02944
G1 X194.499 Y90.137 E.01666
G1 X194.802 Y89.834 E.01336
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
G1 X194.499 Y90.137 E-.16297
G1 X194.499 Y90.672 E-.20329
G1 X194.525 Y90.647 E-.01373
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.217 J0 P1  F60000
G1 X151.308 Y184.249
G1 Z.4
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF0 NF1 ON2 NN0
M204 S8000
G1  X177.308 Y184.249  E2.0691 F7836
G1  Y185.749  E0.1194
G1  X151.308  E2.0691
; NOZZLE_CHANGE_END OF0 NF1 ON2 NN0
M400
M104 T0 S25 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S8000
G1 X152.308 Y185.749 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S10000
G17
G3 Z.8 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O4
M620 S1A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z3.4 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X179.558 Y195.999



M620.10 A0 F498.898 L0 H0.4 T240 P220 S1



M620.10 A1 F498.898 L0 H0.4 T180 P150 S1


T1 H-1        ; actual nozzle swap command - switches to extruder 1, hotend -1
SYNC T0       ; waits for the toolchange motion to complete before continuing

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
M73 P28 R21
G1 X183.06 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.4 F3000

M204 S8000


M621 S1A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R0
M400

G387 Y320 J1 F10000
G1 X183.06 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.4 F3000

M204 S8000

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I1 H-1 W1 ;enable ams air printing detect
M620 O4
M1002 gcode_claim_action : 0
M106 S51
M106 P2 S102
G1 E-.4 F1800
G1 X182.06 Y195.999 F600
M204 S1000
G1 Z.4

; filament start gcode
M109 S145;
G17
G3 Z.8 I0 J-1.217 P1
G1 X177.558 Y195.999 Z.8
G1 Z.4
G1 E.6 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S25
G1  X174.558 Y195.999  E0.1140 F1782
G1 E-0.4000 F1800
M204 S1000
G1  X179.058  F600
G1  X177.558  F240
G1  X178.058  F600
M73 P29 R21
G1  Y196.499 
G1  X177.058 
G1  Y195.499 
G1  X178.558 
G1  Y196.999 
G1  X176.558 
G1  Y194.999 
G1  X174.558 Y195.999   F1782
G1 E0.4000 F1800
M400
M104 T1 S150 N0
M204 S25
G1  X151.058  E0.8931 F1782
G1  Y195.249  E0.0285
G1  X177.558  E1.0072 F2025
G1  Y194.499  E0.0285
G1  X151.058  E1.0072 F2473
G1  Y193.749  E0.0285
G1  X177.558  E1.0072 F4725
G1  Y192.999  E0.0285
G1  X151.058  E1.0072 F4775
G1  Y192.249  E0.0285
G1  X177.558  E1.0072
G1  Y191.499  E0.0285
G1  X151.058  E1.0072
G1  Y190.749  E0.0285
G1  X177.558  E1.0072
G1  Y189.999  E0.0285
G1  X151.058  E1.0072
G1  Y189.249  E0.0285
G1  X177.558  E1.0072
G1  Y188.499  E0.0285
G1  X151.058  E1.0072
G1  Y187.749  E0.0285
G1  X177.558  E1.0072
G1  Y186.999  E0.0285
M73 P30 R21
G1  X151.058  E1.0072
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
G1 X152.058 Y186.999 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z.8 I1.217 J0 P1  F600
; OBJECT_ID: 756
M204 S1000
G1 X148.962 Y90.966
G1 Z.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
M73 P30 R20
G1 X142.672 Y90.966 E.21077
G1 X142.672 Y89.671 E.04343
G1 X148.962 Y89.671 E.21077
G1 X148.962 Y90.906 E.04141
G1 X149.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X142.28 Y91.358 E.21958
G1 X142.28 Y89.278 E.06457
G1 X149.354 Y89.278 E.21958
G1 X149.354 Y91.298 E.0627
; WIPE_START
G1 X148.354 Y91.307 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z.8 I.013 J1.217 P1  F600
G1 X179.962 Y90.966 Z.8
G1 Z.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P31 R20
G1 F600
M204 S25
G1 X155.172 Y90.966 E.83071
G1 X155.172 Y89.671 E.04343
G1 X179.962 Y89.671 E.83071
G1 X179.962 Y90.906 E.04141
G1 X180.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X154.78 Y91.358 E.79383
G1 X154.78 Y89.278 E.06457
G1 X180.354 Y89.278 E.79383
G1 X180.354 Y91.298 E.0627
; WIPE_START
G1 X179.354 Y91.301 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z.8 I-1.21 J.125 P1  F600
G1 X179.962 Y97.171 Z.8
G1 Z.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X179.962 Y98.466 E.04343
G1 X160.172 Y98.466 E.66316
G1 X160.172 Y97.171 E.04343
G1 X179.902 Y97.171 E.66115
G1 X180.354 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P32 R20
G1 X180.354 Y98.858 E.06457
G1 X159.78 Y98.858 E.63863
G1 X159.78 Y96.778 E.06457
G1 X180.294 Y96.778 E.63676
; WIPE_START
G1 X180.323 Y97.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z.8 I.058 J1.216 P1  F600
G1 X192.962 Y97.171 Z.8
G1 Z.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X192.962 Y98.466 E.04343
G1 X186.172 Y98.466 E.22752
G1 X186.172 Y97.171 E.04343
G1 X192.902 Y97.171 E.22551
G1 X193.354 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X193.354 Y98.858 E.06457
G1 X185.78 Y98.858 E.2351
G1 X185.78 Y96.778 E.06457
G1 X193.294 Y96.778 E.23323
; WIPE_START
G1 X193.323 Y97.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z.8 I1.215 J-.064 P1  F600
G1 X192.962 Y90.966 Z.8
G1 Z.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X186.172 Y90.966 E.22752
G1 X186.172 Y89.671 E.04343
G1 X192.962 Y89.671 E.22752
G1 X192.962 Y90.906 E.04141
G1 X193.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X185.78 Y91.358 E.2351
G1 X185.78 Y89.278 E.06457
G1 X193.354 Y89.278 E.2351
G1 X193.354 Y91.298 E.0627
; WIPE_START
G1 X192.354 Y91.306 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z.8 I.16 J-1.206 P1  F600
G1 X186.598 Y90.541 Z.8
M73 P33 R20
G1 Z.4
G1 E.6 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.487325
G1 F600
M204 S25
G1 X192.536 Y90.541 E.21724
G1 X192.536 Y90.096 E.01626
G1 X186.598 Y90.096 E.21724
G1 X186.598 Y90.481 E.01406
; WIPE_START
G1 X186.598 Y90.096 E-.14608
G1 X187.213 Y90.096 E-.23392
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z.8 I-1.213 J-.1 P1  F600
G1 X186.598 Y97.596 Z.8
G1 Z.4
G1 E.6 F1800
; LINE_WIDTH: 0.48732
G1 F600
M204 S25
G1 X186.598 Y98.041 E.01626
G1 X192.536 Y98.041 E.21723
G1 X192.536 Y97.596 E.01626
G1 X186.658 Y97.596 E.21504
; WIPE_START
G1 X187.658 Y97.596 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z.8 I0 J-1.217 P1  F600
G1 X160.598 Y97.596 Z.8
G1 Z.4
G1 E.6 F1800
; LINE_WIDTH: 0.487325
G1 F600
M204 S25
G1 X160.598 Y98.041 E.01626
G1 X179.536 Y98.041 E.69281
G1 X179.536 Y97.596 E.01626
G1 X160.658 Y97.596 E.69062
; WIPE_START
G1 X161.658 Y97.596 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z.8 I.923 J-.793 P1  F600
G1 X155.598 Y90.541 Z.8
G1 Z.4
G1 E.6 F1800
G1 F600
M204 S25
G1 X179.536 Y90.541 E.87573
M73 P33 R19
G1 X179.536 Y90.096 E.01626
G1 X155.598 Y90.096 E.87573
G1 X155.598 Y90.481 E.01406
; WIPE_START
G1 X155.598 Y90.096 E-.14608
G1 X156.213 Y90.096 E-.23393
; WIPE_END
M73 P34 R19
G1 E-.02 F1800
M204 S1000
G17
G3 Z.8 I-.07 J-1.215 P1  F600
G1 X148.536 Y90.541 Z.8
G1 Z.4
G1 E.6 F1800
G1 F600
M204 S25
G1 X148.536 Y90.096 E.01626
G1 X143.098 Y90.096 E.19894
G1 X143.098 Y90.541 E.01626
G1 X148.476 Y90.541 E.19675
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 3/14
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S1000
G1 X148.962 Y90.966 Z.6 F600
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
M204 S25
G1 X142.672 Y90.966 E.21077
G1 X142.672 Y89.671 E.04343
G1 X148.962 Y89.671 E.21077
G1 X148.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X149.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X142.28 Y91.358 E.21958
G1 X142.28 Y89.278 E.06457
G1 X149.354 Y89.278 E.21958
G1 X149.354 Y91.298 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X148.354 Y91.307 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I.013 J1.217 P1  F600
G1 X179.962 Y90.966 Z1
G1 Z.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X155.172 Y90.966 E.83071
G1 X155.172 Y89.671 E.04343
G1 X179.962 Y89.671 E.83071
G1 X179.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X180.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X154.78 Y91.358 E.79383
G1 X154.78 Y89.278 E.06457
G1 X180.354 Y89.278 E.79383
G1 X180.354 Y91.298 E.0627
; COOLING_NODE: 0
; WIPE_START
M73 P35 R19
G1 X179.354 Y91.301 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I-1.21 J.125 P1  F600
G1 X179.962 Y97.171 Z1
G1 Z.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X179.962 Y98.466 E.04343
G1 X160.172 Y98.466 E.66316
G1 X160.172 Y97.171 E.04343
G1 X179.902 Y97.171 E.66115
; COOLING_NODE: 0
G1 X180.354 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X180.354 Y98.858 E.06457
G1 X159.78 Y98.858 E.63863
G1 X159.78 Y96.778 E.06457
G1 X180.294 Y96.778 E.63676
; COOLING_NODE: 0
; WIPE_START
G1 X180.323 Y97.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I.058 J1.216 P1  F600
G1 X192.962 Y97.171 Z1
G1 Z.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X192.962 Y98.466 E.04343
G1 X186.172 Y98.466 E.22752
G1 X186.172 Y97.171 E.04343
G1 X192.902 Y97.171 E.22551
; COOLING_NODE: 0
G1 X193.354 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P36 R19
G1 X193.354 Y98.858 E.06457
G1 X185.78 Y98.858 E.2351
G1 X185.78 Y96.778 E.06457
G1 X193.294 Y96.778 E.23323
; COOLING_NODE: 0
; WIPE_START
G1 X193.323 Y97.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I1.215 J-.064 P1  F600
G1 X192.962 Y90.966 Z1
G1 Z.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X186.172 Y90.966 E.22752
G1 X186.172 Y89.671 E.04343
G1 X192.962 Y89.671 E.22752
G1 X192.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X193.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X185.78 Y91.358 E.2351
G1 X185.78 Y89.278 E.06457
G1 X193.354 Y89.278 E.2351
G1 X193.354 Y91.298 E.0627
; WIPE_START
G1 X192.354 Y91.306 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I.16 J-1.206 P1  F600
G1 X186.598 Y90.541 Z1
G1 Z.6
G1 E.6 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.487325
G1 F600
M204 S25
G1 X192.536 Y90.541 E.21724
G1 X192.536 Y90.096 E.01626
G1 X186.598 Y90.096 E.21724
G1 X186.598 Y90.481 E.01406
; WIPE_START
G1 X186.598 Y90.096 E-.14608
G1 X187.213 Y90.096 E-.23392
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I-1.213 J-.1 P1  F600
G1 X186.598 Y97.596 Z1
G1 Z.6
G1 E.6 F1800
; LINE_WIDTH: 0.48732
G1 F600
M204 S25
G1 X186.598 Y98.041 E.01626
G1 X192.536 Y98.041 E.21723
G1 X192.536 Y97.596 E.01626
G1 X186.658 Y97.596 E.21504
; WIPE_START
G1 X187.658 Y97.596 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I0 J-1.217 P1  F600
G1 X160.598 Y97.596 Z1
G1 Z.6
G1 E.6 F1800
; LINE_WIDTH: 0.487325
G1 F600
M204 S25
M73 P37 R19
G1 X160.598 Y98.041 E.01626
G1 X179.536 Y98.041 E.69281
G1 X179.536 Y97.596 E.01626
G1 X160.658 Y97.596 E.69062
; WIPE_START
G1 X161.658 Y97.596 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I.923 J-.793 P1  F600
M73 P37 R18
G1 X155.598 Y90.541 Z1
G1 Z.6
G1 E.6 F1800
G1 F600
M204 S25
G1 X179.536 Y90.541 E.87573
G1 X179.536 Y90.096 E.01626
G1 X155.598 Y90.096 E.87573
G1 X155.598 Y90.481 E.01406
; WIPE_START
G1 X155.598 Y90.096 E-.14608
G1 X156.213 Y90.096 E-.23393
; WIPE_END
G1 E-.02 F1800
M632 S0 N R W
M400
M104 T0 S210 N0 ;Multi extruder pre heating
M633
M204 S1000
G17
G3 Z1 I-.07 J-1.215 P1  F600
G1 X148.536 Y90.541 Z1
G1 Z.6
G1 E.6 F1800
G1 F600
M204 S25
G1 X148.536 Y90.096 E.01626
G1 X143.098 Y90.096 E.19894
G1 X143.098 Y90.541 E.01626
G1 X148.476 Y90.541 E.19675
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
; WIPE_START
M204 S25
G1 X147.476 Y90.541 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I1.217 J0 P1  F600
G1 X151.308 Y171.499
G1 Z.6
G1 E.6 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF1 NF0 ON0 NN2
M204 S25
G1  X177.308 Y171.499  E2.0691 F7836
; NOZZLE_CHANGE_END OF1 NF0 ON0 NN2
M400
M104 T1 S56 N0 ;Multi extruder pre cooling

; WIPE_START
M73 P38 R18
G1 F5400
M204 S25
G1 X176.308 Y171.499 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S1000
G17
G3 Z1 I1.217 J0 P1  F5400
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

G1 Z3.6 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X179.558 Y172.749



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
M73 E10

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
G1 X183.06 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.6 F3000

M204 S25


M621 S0A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y320 J1 F10000
G1 X183.06 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.6 F3000

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I0 H-1 W1 ;enable ams air printing detect
M620 O5
M1002 gcode_claim_action : 0
M106 S153
M106 P2 S191
G1 X182.06 Y172.749 F60000
M204 S10000
G1 Z.6

; filament start gcode
G17
G3 Z1 I0 J-1.217 P1
G1 X177.558 Y172.749 Z1
G1 Z.6
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X174.558 Y172.749  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X179.058  F600
G1  X177.558  F240
G1  X178.058  F600
G1  Y173.249 
G1  X177.058 
G1  Y172.249 
G1  X178.558 
G1  Y173.749 
G1  X176.558 
G1  Y171.749 
G1  X174.558 Y172.749   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X151.058  E0.8931 F1782
G1  Y173.499  E0.0285
G1  X177.558  E1.0072 F2025
G1  Y174.249  E0.0285
G1  X151.058  E1.0072 F2473
G1  Y174.999  E0.0285
G1  X177.558  E1.0072 F4725
G1  Y175.749  E0.0285
M73 P39 R18
G1  X151.058  E1.0072 F4775
G1  Y176.499  E0.0285
G1  X177.558  E1.0072
G1  Y177.249  E0.0285
G1  X151.058  E1.0072
G1  Y177.999  E0.0285
G1  X177.558  E1.0072
G1  Y178.749  E0.0285
G1  X151.058  E1.0072
G1  Y179.499  E0.0285
G1  X177.558  E1.0072
G1  Y180.249  E0.0285
G1  X151.058  E1.0072
G1  Y180.999  E0.0285
G1  X177.558  E1.0072
G1  Y181.749  E0.0285
G1  X151.058  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y196.249   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S8000
G1  Y182.499  E0.5226
G1  X177.558  E1.0072
G1  Y196.249  E0.5226
G1  X151.058  E1.0072
M204 S10000
G1  X152.058 Y182.499  
;--------------------
; CP EMPTY GRID START
; layer #4
M204 S8000
G1  Y196.249  E0.5226
M204 S10000
G1  X160.225 
M204 S8000
G1  Y182.499  E0.5226
M204 S10000
G1  X168.391 
M204 S8000
G1  Y196.249  E0.5226
M204 S10000
G1  X176.558 
M204 S8000
G1  Y182.499  E0.5226
; CP EMPTY GRID END
;------------------






; WIPE_TOWER_END
G1  X151.058 Y195.749
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X148.870 Y194.931  
M204 S8000
G3  X149.704 Y191.976   I2.026 J-1.023 E0.1282
G2  X150.558 Y189.443   I-3.390 J-2.554 E0.1033
G2  X150.555 Y177.885   I-283.960 J-5.694 E0.4393
G2  X148.712 Y174.320   I-6.625 J1.166 E0.1549
G3  X149.047 Y172.347   I1.652 J-0.734 E0.0806
G3  X152.165 Y169.085   I19.448 J15.469 E0.1717
G3  X155.363 Y169.743   I1.278 J1.891 E0.1383
G2  X158.380 Y170.749   I3.023 J-4.037 E0.1230
G1  X164.308  E0.2253
G1  X165.558  E0.0475
G2  X171.182 Y170.659   I2.339 J-29.659 E0.2141
G2  X174.517 Y168.801   I-2.882 J-9.098 E0.1461
G3  X176.684 Y169.296   I0.711 J1.877 E0.0895
G1  X179.050 Y171.798   E0.1309
G1 E-0.4000 F1800
M204 S10000
G1  X180.020 Y173.962   F600
G1 E0.4000 F1800
M204 S8000
G3  X178.399 Y176.401   I-22.773 J-13.378 E0.1113 F5400
G2  X178.058 Y178.055   I4.011 J1.689 E0.0646
G2  X178.061 Y189.613   I283.960 J5.694 E0.4393
G2  X179.904 Y193.178   I6.625 J-1.166 E0.1549
G3  X179.569 Y195.151   I-1.652 J0.734 E0.0806
G1  X178.058 Y196.749   E0.0836
G3  X175.599 Y198.794   I-4.377 J-2.762 E0.1236
G3  X172.940 Y197.538   I0.009 J-3.462 E0.1154
G2  X170.236 Y196.749   I-2.710 J4.259 E0.1085
G2  X158.190 Y196.753   I-5.928 J318.375 E0.4578
G2  X154.243 Y198.635   I0.501 J6.129 E0.1699
G3  X151.932 Y198.202   I-0.852 J-1.839 E0.0953
G3  X148.870 Y194.931   I16.406 J-18.427 E0.1705
; WIPE_TOWER_END

; WIPE_START
M204 S8000
G1 X148.954 Y195.045 E-.05374
G1 X149.047 Y195.151 E-.05374
G1 X149.539 Y195.672 E-.27253
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I1.217 J0 P1  F60000
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S10000
G1 X181.166 Y95.966
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F3000
M204 S50
G1 X158.962 Y95.966 E.74407
G1 X158.962 Y98.466 E.08378
G1 X137.166 Y98.466 E.73039
G1 X137.166 Y89.671 E.29475
G1 X141.462 Y89.671 E.14396
G1 X141.462 Y92.171 E.08378
G1 X150.166 Y92.171 E.29168
G1 X150.166 Y89.671 E.08378
G1 X153.962 Y89.671 E.1272
G1 X153.962 Y92.171 E.08378
G1 X181.166 Y92.171 E.91162
G1 X181.166 Y89.671 E.08378
G1 X184.962 Y89.671 E.1272
G1 X184.962 Y92.171 E.08378
G1 X194.166 Y92.171 E.30843
G1 X194.166 Y89.671 E.08378
G1 X197.962 Y89.671 E.1272
G1 X197.962 Y98.466 E.29475
G1 X194.166 Y98.466 E.1272
G1 X194.166 Y95.966 E.08378
G1 X184.962 Y95.966 E.30843
G1 X184.962 Y98.466 E.08378
G1 X181.166 Y98.466 E.1272
G1 X181.166 Y96.026 E.08177
; COOLING_NODE: 0
M204 S250
G1 X180.774 Y96.358 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2145
M204 S50
G1 X159.354 Y96.358 E.66489
M73 P40 R18
G1 X159.354 Y98.858 E.0776
G1 X136.774 Y98.858 E.7009
G1 X136.774 Y89.278 E.29737
G1 X141.854 Y89.278 E.15769
G1 X141.854 Y91.778 E.0776
G1 X149.774 Y91.778 E.24584
G1 X149.774 Y89.278 E.0776
G1 X154.354 Y89.278 E.14217
G1 X154.354 Y91.778 E.0776
G1 X180.774 Y91.778 E.8201
G1 X180.774 Y89.278 E.0776
G1 X185.354 Y89.278 E.14217
G1 X185.354 Y91.778 E.0776
G1 X193.774 Y91.778 E.26136
G1 X193.774 Y89.278 E.0776
G1 X198.354 Y89.278 E.14217
G1 X198.354 Y98.858 E.29737
G1 X193.774 Y98.858 E.14217
G1 X193.774 Y96.358 E.0776
G1 X185.354 Y96.358 E.26136
G1 X185.354 Y98.858 E.0776
M73 P40 R17
G1 X180.774 Y98.858 E.14217
G1 X180.774 Y96.418 E.07574
M204 S10000
G1 X181.068 Y95.803 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42121
G1 F15000
M204 S8000
G1 X177.769 Y92.504 E.14529
G1 X177.234 Y92.504 E.01666
G1 X180.363 Y95.633 E.13781
G1 X179.828 Y95.633 E.01666
G1 X176.699 Y92.504 E.13781
G1 X176.164 Y92.504 E.01666
G1 X179.293 Y95.633 E.13781
G1 X178.758 Y95.633 E.01666
G1 X175.629 Y92.504 E.13781
G1 X175.094 Y92.504 E.01666
G1 X178.223 Y95.633 E.13781
G1 X177.688 Y95.633 E.01666
G1 X174.559 Y92.504 E.13781
G1 X174.024 Y92.504 E.01666
G1 X177.153 Y95.633 E.13781
G1 X176.618 Y95.633 E.01666
G1 X173.489 Y92.504 E.13781
G1 X172.954 Y92.504 E.01666
G1 X176.083 Y95.633 E.13781
G1 X175.548 Y95.633 E.01666
G1 X172.419 Y92.504 E.13781
G1 X171.884 Y92.504 E.01666
G1 X175.013 Y95.633 E.13781
G1 X174.478 Y95.633 E.01666
G1 X171.349 Y92.504 E.13781
G1 X170.814 Y92.504 E.01666
G1 X173.943 Y95.633 E.13781
G1 X173.408 Y95.633 E.01666
G1 X170.279 Y92.504 E.13781
G1 X169.744 Y92.504 E.01666
G1 X172.873 Y95.633 E.13781
G1 X172.338 Y95.633 E.01666
G1 X169.209 Y92.504 E.13781
G1 X168.674 Y92.504 E.01666
G1 X171.803 Y95.633 E.13781
G1 X171.268 Y95.633 E.01666
G1 X168.139 Y92.504 E.13781
G1 X167.604 Y92.504 E.01666
G1 X170.733 Y95.633 E.13781
G1 X170.198 Y95.633 E.01666
G1 X167.069 Y92.504 E.13781
G1 X166.534 Y92.504 E.01666
G1 X169.663 Y95.633 E.13781
G1 X169.128 Y95.633 E.01666
G1 X165.999 Y92.504 E.13781
G1 X165.464 Y92.504 E.01666
G1 X168.593 Y95.633 E.13781
G1 X168.058 Y95.633 E.01666
G1 X164.929 Y92.504 E.13781
G1 X164.394 Y92.504 E.01666
G1 X167.523 Y95.633 E.13781
G1 X166.989 Y95.633 E.01666
G1 X163.859 Y92.504 E.13781
G1 X163.324 Y92.504 E.01666
G1 X166.454 Y95.633 E.13781
G1 X165.919 Y95.633 E.01666
G1 X162.789 Y92.504 E.13781
G1 X162.254 Y92.504 E.01666
G1 X165.384 Y95.633 E.13781
G1 X164.849 Y95.633 E.01666
G1 X161.719 Y92.504 E.13781
G1 X161.184 Y92.504 E.01666
G1 X164.314 Y95.633 E.13781
G1 X163.779 Y95.633 E.01666
G1 X160.649 Y92.504 E.13781
G1 X160.114 Y92.504 E.01666
G1 X163.244 Y95.633 E.13781
G1 X162.709 Y95.633 E.01666
G1 X159.579 Y92.504 E.13781
G1 X159.044 Y92.504 E.01666
G1 X162.174 Y95.633 E.13781
G1 X161.639 Y95.633 E.01666
G1 X158.509 Y92.504 E.13781
G1 X157.974 Y92.504 E.01666
G1 X161.104 Y95.633 E.13781
G1 X160.569 Y95.633 E.01666
G1 X157.439 Y92.504 E.13781
G1 X156.904 Y92.504 E.01666
G1 X160.034 Y95.633 E.13781
G1 X159.499 Y95.633 E.01666
G1 X156.369 Y92.504 E.13781
G1 X155.834 Y92.504 E.01666
G1 X158.964 Y95.633 E.13781
G1 X158.628 Y95.633 E.01044
G1 X158.628 Y95.833 E.00622
G1 X155.299 Y92.504 E.14661
G1 X154.764 Y92.504 E.01666
G1 X158.628 Y96.368 E.17017
G1 X158.628 Y96.903 E.01666
G1 X154.06 Y92.334 E.2012
M204 S10000
G1 X153.798 Y92.072 F60000
G1 F15000
M204 S8000
G1 X151.729 Y90.004 E.0911
G1 X152.264 Y90.004 E.01666
G1 X153.628 Y91.368 E.06007
G1 X153.628 Y90.833 E.01666
G1 X152.799 Y90.004 E.03651
G1 X153.334 Y90.004 E.01666
G1 X153.798 Y90.468 E.02042
; WIPE_START
G1 X153.334 Y90.004 E-.24922
G1 X152.99 Y90.004 E-.13078
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I-.967 J.739 P1  F60000
G1 X158.798 Y97.607 Z1
G1 Z.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X151.194 Y90.004 E.33486
G1 X150.659 Y90.004 E.01666
G1 X158.628 Y97.973 E.35095
G1 X158.628 Y98.133 E.00499
G1 X158.254 Y98.133 E.01167
G1 X150.499 Y90.378 E.34151
G1 X150.499 Y90.913 E.01666
G1 X157.719 Y98.133 E.31795
G1 X157.184 Y98.133 E.01666
G1 X150.499 Y91.448 E.29439
G1 X150.499 Y91.983 E.01666
G1 X156.649 Y98.133 E.27083
G1 X156.114 Y98.133 E.01666
G1 X150.485 Y92.504 E.24791
G1 X149.95 Y92.504 E.01666
G1 X155.579 Y98.133 E.24791
G1 X155.044 Y98.133 E.01666
G1 X149.415 Y92.504 E.24791
G1 X148.88 Y92.504 E.01666
G1 X154.509 Y98.133 E.24791
G1 X153.974 Y98.133 E.01666
G1 X148.345 Y92.504 E.24791
G1 X147.81 Y92.504 E.01666
G1 X153.439 Y98.133 E.24791
G1 X152.904 Y98.133 E.01666
G1 X147.275 Y92.504 E.24791
G1 X146.74 Y92.504 E.01666
G1 X152.369 Y98.133 E.24791
G1 X151.834 Y98.133 E.01666
G1 X146.205 Y92.504 E.24791
G1 X145.67 Y92.504 E.01666
G1 X151.299 Y98.133 E.24791
G1 X150.764 Y98.133 E.01666
G1 X145.135 Y92.504 E.24791
G1 X144.6 Y92.504 E.01666
G1 X150.229 Y98.133 E.24791
G1 X149.694 Y98.133 E.01666
G1 X144.065 Y92.504 E.24791
G1 X143.53 Y92.504 E.01666
G1 X149.159 Y98.133 E.24791
G1 X148.624 Y98.133 E.01666
G1 X142.995 Y92.504 E.24791
G1 X142.46 Y92.504 E.01666
G1 X148.089 Y98.133 E.24791
G1 X147.554 Y98.133 E.01666
G1 X141.755 Y92.334 E.25538
M204 S10000
G1 X141.298 Y91.877 F60000
G1 F15000
M204 S8000
G1 X139.425 Y90.004 E.0825
G1 X139.96 Y90.004 E.01666
G1 X141.128 Y91.172 E.05147
G1 X141.128 Y90.637 E.01666
G1 X140.495 Y90.004 E.02791
G1 X141.03 Y90.004 E.01666
G1 X141.298 Y90.272 E.01182
M204 S10000
G1 X138.094 Y98.303 F60000
G1 F15000
M204 S8000
G1 X137.499 Y97.708 E.02621
G1 X137.499 Y97.173 E.01666
G1 X138.46 Y98.133 E.04229
G1 X138.994 Y98.133 E.01666
G1 X137.499 Y96.638 E.06586
G1 X137.499 Y96.103 E.01666
G1 X139.529 Y98.133 E.08942
G1 X140.064 Y98.133 E.01666
G1 X137.499 Y95.568 E.11298
G1 X137.499 Y95.033 E.01666
G1 X140.599 Y98.133 E.13654
G1 X141.134 Y98.133 E.01666
G1 X137.499 Y94.498 E.1601
G1 X137.499 Y93.963 E.01666
G1 X141.669 Y98.133 E.18366
G1 X142.204 Y98.133 E.01666
G1 X137.499 Y93.428 E.20722
G1 X137.499 Y92.893 E.01666
G1 X142.739 Y98.133 E.23078
G1 X143.274 Y98.133 E.01666
G1 X137.499 Y92.358 E.25434
G1 X137.499 Y91.823 E.01666
G1 X143.809 Y98.133 E.2779
G1 X144.344 Y98.133 E.01666
G1 X137.499 Y91.288 E.30146
G1 X137.499 Y90.753 E.01666
G1 X144.879 Y98.133 E.32502
G1 X145.414 Y98.133 E.01666
G1 X137.499 Y90.218 E.34858
G1 X137.499 Y90.004 E.00667
G1 X137.82 Y90.004 E.00999
G1 X145.949 Y98.133 E.35801
G1 X146.484 Y98.133 E.01666
G1 X138.355 Y90.004 E.35801
G1 X138.89 Y90.004 E.01666
G1 X147.189 Y98.303 E.36548
; WIPE_START
G1 X146.482 Y97.596 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I-.024 J1.217 P1  F60000
G1 X181.963 Y98.303 Z1
G1 Z.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X181.499 Y97.839 E.02042
G1 X181.499 Y97.304 E.01666
G1 X182.328 Y98.133 E.03651
G1 X182.863 Y98.133 E.01666
G1 X181.499 Y96.769 E.06007
G1 X181.499 Y96.234 E.01666
G1 X183.398 Y98.133 E.08363
G1 X183.933 Y98.133 E.01666
G1 X178.304 Y92.504 E.24791
G1 X178.839 Y92.504 E.01666
G1 X184.468 Y98.133 E.24791
G1 X184.628 Y98.133 E.005
G1 X184.628 Y97.759 E.01166
G1 X179.374 Y92.504 E.23142
G1 X179.909 Y92.504 E.01666
G1 X184.628 Y97.224 E.20786
G1 X184.628 Y96.689 E.01666
G1 X180.444 Y92.504 E.1843
G1 X180.979 Y92.504 E.01666
G1 X184.628 Y96.154 E.16074
G1 X184.628 Y95.633 E.01621
G1 X184.643 Y95.633 E.00045
G1 X181.499 Y92.489 E.13845
G1 X181.499 Y91.954 E.01666
G1 X185.178 Y95.633 E.16201
G1 X185.713 Y95.633 E.01666
G1 X181.499 Y91.419 E.18557
G1 X181.499 Y90.884 E.01666
G1 X186.248 Y95.633 E.20913
G1 X186.783 Y95.633 E.01666
G1 X181.499 Y90.349 E.23269
G1 X181.499 Y90.004 E.01076
G1 X181.688 Y90.004 E.0059
G1 X187.488 Y95.803 E.25539
; WIPE_START
G1 X186.78 Y95.096 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I1.092 J-.537 P1  F60000
G1 X184.194 Y89.834 Z1
G1 Z.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X184.628 Y90.269 E.01915
G1 X184.628 Y90.804 E.01666
G1 X183.828 Y90.004 E.03523
G1 X183.293 Y90.004 E.01666
G1 X184.628 Y91.339 E.05879
G1 X184.628 Y91.874 E.01666
G1 X182.758 Y90.004 E.08235
G1 X182.223 Y90.004 E.01666
G1 X187.853 Y95.633 E.24791
G1 X188.388 Y95.633 E.01666
G1 X185.258 Y92.504 E.13782
G1 X185.793 Y92.504 E.01666
G1 X188.923 Y95.633 E.13782
G1 X189.458 Y95.633 E.01666
G1 X186.328 Y92.504 E.13782
G1 X186.863 Y92.504 E.01666
G1 X189.993 Y95.633 E.13781
G1 X190.528 Y95.633 E.01666
G1 X187.398 Y92.504 E.13781
M73 P41 R17
G1 X187.933 Y92.504 E.01666
G1 X191.063 Y95.633 E.13781
G1 X191.598 Y95.633 E.01666
G1 X188.468 Y92.504 E.13781
G1 X189.003 Y92.504 E.01666
G1 X192.133 Y95.633 E.13781
G1 X192.668 Y95.633 E.01666
G1 X189.538 Y92.504 E.13781
G1 X190.073 Y92.504 E.01666
G1 X193.203 Y95.633 E.13781
G1 X193.738 Y95.633 E.01666
G1 X190.608 Y92.504 E.13781
G1 X191.143 Y92.504 E.01666
G1 X196.773 Y98.133 E.24791
G1 X197.308 Y98.133 E.01666
G1 X191.678 Y92.504 E.24791
G1 X192.213 Y92.504 E.01666
G1 X197.628 Y97.919 E.23848
G1 X197.628 Y97.384 E.01666
G1 X192.748 Y92.504 E.21492
G1 X193.283 Y92.504 E.01666
G1 X197.628 Y96.849 E.19136
G1 X197.628 Y96.314 E.01666
G1 X193.818 Y92.504 E.1678
G1 X194.353 Y92.504 E.01666
G1 X197.628 Y95.779 E.14424
G1 X197.628 Y95.244 E.01666
G1 X194.499 Y92.115 E.13781
G1 X194.499 Y91.58 E.01666
G1 X197.628 Y94.709 E.13781
G1 X197.628 Y94.174 E.01666
G1 X194.499 Y91.045 E.13781
G1 X194.499 Y90.51 E.01666
G1 X197.628 Y93.639 E.13781
G1 X197.628 Y93.104 E.01666
G1 X194.528 Y90.004 E.13654
G1 X195.063 Y90.004 E.01666
G1 X197.628 Y92.569 E.11298
G1 X197.628 Y92.034 E.01666
G1 X195.598 Y90.004 E.08942
G1 X196.133 Y90.004 E.01666
G1 X197.628 Y91.499 E.06586
G1 X197.628 Y90.964 E.01666
G1 X196.668 Y90.004 E.0423
G1 X197.203 Y90.004 E.01666
G1 X197.798 Y90.599 E.02621
M204 S10000
G1 X196.407 Y98.303 F60000
G1 F15000
M204 S8000
G1 X194.499 Y96.395 E.08404
G1 X194.499 Y96.93 E.01666
G1 X195.703 Y98.133 E.053
G1 X195.168 Y98.133 E.01666
G1 X194.499 Y97.465 E.02944
G1 X194.499 Y98 E.01666
G1 X194.802 Y98.303 E.01335
; WIPE_START
G1 X194.499 Y98 E-.16297
G1 X194.499 Y97.465 E-.20329
G1 X194.525 Y97.49 E-.01374
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
    

    

    
        M9711 M0 E0 U266 V97 Z1 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 4/14
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
M106 S165.75
; OBJECT_ID: 756
; COOLING_NODE: 0
G1 X176.166 Y92.171 F60000
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F3000
M204 S50
G1 X176.166 Y89.671 E.08378
G1 X184.581 Y89.671 E.28201
G1 X184.981 Y89.671 E.0134
G1 F2501.458
G1 X185.381 Y89.671 E.0134
G1 F1920
G1 X185.752 Y89.671 E.01243
G1 F2501.458
G1 X186.152 Y89.671 E.0134
G1 F3000
G1 X186.552 Y89.671 E.0134
G1 X190.462 Y89.671 E.131
G1 X190.462 Y92.171 E.08378
G1 X194.166 Y92.171 E.12413
G1 X194.166 Y89.671 E.08378
G1 X197.962 Y89.671 E.1272
G1 X197.962 Y98.466 E.29475
G1 X194.166 Y98.466 E.1272
G1 X194.166 Y95.966 E.08378
G1 X190.462 Y95.966 E.12413
G1 X190.462 Y98.466 E.08378
G1 X186.552 Y98.466 E.131
G1 X186.152 Y98.466 E.0134
G1 F2501.458
G1 X185.752 Y98.466 E.0134
G1 F1920
G1 X185.381 Y98.466 E.01243
G1 F2501.458
G1 X184.981 Y98.466 E.0134
G1 F3000
G1 X184.581 Y98.466 E.0134
G1 X162.666 Y98.466 E.7344
G1 X162.666 Y95.966 E.08378
G1 X158.962 Y95.966 E.12413
G1 X158.962 Y98.466 E.08378
G1 X137.166 Y98.466 E.73039
G1 X137.166 Y89.671 E.29475
G1 X141.462 Y89.671 E.14396
G1 X141.462 Y92.171 E.08378
G1 X145.166 Y92.171 E.12413
G1 X145.166 Y89.671 E.08378
G1 X153.581 Y89.671 E.28201
G1 X153.981 Y89.671 E.0134
G1 F2501.458
G1 X154.381 Y89.671 E.0134
G1 F1920
G1 X154.752 Y89.671 E.01243
G1 F2501.458
G1 X155.152 Y89.671 E.0134
G1 F3000
G1 X155.552 Y89.671 E.0134
G1 X172.462 Y89.671 E.56664
G1 X172.462 Y92.171 E.08378
G1 X176.106 Y92.171 E.12212
M632 S1 W
M400
M104 T1 S140 N0 ;Multi extruder pre heating
M633
; COOLING_NODE: 0
M204 S250
G1 X175.774 Y91.778 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2043
M204 S50
G1 X175.774 Y89.278 E.0776
G1 X184.595 Y89.278 E.27381
G1 X184.995 Y89.278 E.01242
G1 X185.395 Y89.278 E.01242
G1 F2040
G1 X185.739 Y89.278 E.01068
G1 F2043
G1 X186.139 Y89.278 E.01242
G1 X186.539 Y89.278 E.01242
G1 X190.854 Y89.278 E.13394
G1 X190.854 Y91.778 E.0776
G1 X193.774 Y91.778 E.09064
G1 X193.774 Y89.278 E.0776
G1 X198.354 Y89.278 E.14217
G1 X198.354 Y98.858 E.29737
G1 X193.774 Y98.858 E.14217
G1 X193.774 Y96.358 E.0776
G1 X190.854 Y96.358 E.09064
G1 X190.854 Y98.858 E.0776
G1 X186.539 Y98.858 E.13394
G1 X186.139 Y98.858 E.01242
G1 X185.739 Y98.858 E.01242
G1 F2040
G1 X185.395 Y98.858 E.01068
G1 F2043
G1 X184.995 Y98.858 E.01242
G1 X184.595 Y98.858 E.01242
G1 X162.274 Y98.858 E.69286
G1 X162.274 Y96.358 E.0776
G1 X159.354 Y96.358 E.09064
G1 X159.354 Y98.858 E.0776
G1 X136.774 Y98.858 E.7009
G1 X136.774 Y89.278 E.29737
G1 X141.854 Y89.278 E.15769
G1 X141.854 Y91.778 E.0776
G1 X144.774 Y91.778 E.09064
M73 P42 R17
G1 X144.774 Y89.278 E.0776
G1 X153.595 Y89.278 E.27381
G1 X153.995 Y89.278 E.01242
G1 X154.395 Y89.278 E.01242
G1 F2040
G1 X154.739 Y89.278 E.01068
G1 F2043
G1 X155.139 Y89.278 E.01242
G1 X155.539 Y89.278 E.01242
G1 X172.854 Y89.278 E.53747
G1 X172.854 Y91.778 E.0776
G1 X175.714 Y91.778 E.08878
; WIPE_START
G1 F3000
M204 S8000
G1 X175.738 Y90.779 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I-1.009 J.681 P1  F60000
G1 X180.661 Y98.074 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X185.473 Y98.074 E.14938
G1 X185.473 Y90.063 E.24868
G1 X180.661 Y90.063 E.14938
G1 X180.661 Y98.014 E.24682
M204 S10000
G1 X181.038 Y97.697 F60000
G1 F15000
M204 S8000
G1 X185.096 Y97.697 E.12597
G1 X185.096 Y90.44 E.22528
G1 X181.038 Y90.44 E.12597
G1 X181.038 Y97.637 E.22341
M204 S10000
G1 X181.415 Y97.32 F60000
G1 F15000
M204 S8000
G1 X184.719 Y97.32 E.10257
G1 X184.719 Y90.817 E.20187
G1 X181.415 Y90.817 E.10257
G1 X181.415 Y97.26 E.20001
M204 S10000
G1 X181.792 Y96.943 F60000
G1 F15000
M204 S8000
G1 X184.342 Y96.943 E.07916
G1 X184.342 Y91.194 E.17846
G1 X181.792 Y91.194 E.07916
G1 X181.792 Y96.883 E.1766
M204 S10000
G1 X182.169 Y96.566 F60000
G1 F15000
M204 S8000
G1 X183.965 Y96.566 E.05575
G1 X183.965 Y91.571 E.15505
G1 X182.169 Y91.571 E.05575
G1 X182.169 Y96.506 E.15319
M204 S10000
G1 X182.546 Y96.189 F60000
G1 F15000
M204 S8000
G1 X183.588 Y96.189 E.03234
G1 X183.588 Y91.948 E.13164
G1 X182.546 Y91.948 E.03234
G1 X182.546 Y96.129 E.12978
M204 S10000
G1 X182.901 Y95.834 F60000
; LINE_WIDTH: 0.37532
G1 F15000
M204 S8000
G1 X183.233 Y95.834 E.0091
G1 X183.233 Y92.303 E.09663
G1 X182.901 Y92.303 E.0091
G1 X182.901 Y95.774 E.09499
M204 S10000
G1 X195.645 Y94.035 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.35548
G1 F21000
M204 S8000
G1 X195.586 Y94.068 E.00174
G1 X195.627 Y94.092 E.0012
M204 S10000
G1 X194.743 Y94.068 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G3 X195.927 Y94.96 I-.412 J1.778 E.05112
G1 X195.985 Y95.194 E.00808
G1 X195.985 Y93.007 E.07326
G1 X195.927 Y93.177 E.00602
G1 X195.41 Y93.781 E.02663
G3 X194.802 Y94.058 I-.719 J-.772 E.02275
M204 S10000
G1 X187.989 Y92.143 F60000
; LINE_WIDTH: 0.64524
G1 F12451.854
M204 S8000
G1 X188.005 Y92.66 E.02567
M204 S10000
G1 X188.347 Y94.022 F60000
; LINE_WIDTH: 0.47378
G1 F17407.048
M204 S8000
G2 X188.293 Y94.115 I-.02 J.051 E.00551
G1 X188.34 Y94.115 E.00169
M204 S10000
G1 X188.973 Y94.068 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X188.634 Y93.792 E.01465
G1 X188.232 Y93.129 E.02599
; LINE_WIDTH: 0.471279
G1 F17508.681
G1 X188.187 Y93.048 E.00329
; LINE_WIDTH: 0.513857
G1 F15925.697
G1 X188.142 Y92.966 E.00362
; LINE_WIDTH: 0.556435
G1 F14605.221
G1 X188.097 Y92.884 E.00395
; LINE_WIDTH: 0.599013
G1 F13486.953
G1 X188.052 Y92.802 E.00427
; LINE_WIDTH: 0.641591
G1 F12527.748
G1 X188.007 Y92.72 E.0046
G1 X187.986 Y92.815 E.00476
; LINE_WIDTH: 0.599013
G1 F13486.953
G1 X187.964 Y92.909 E.00442
; LINE_WIDTH: 0.556435
G1 F14605.221
G1 X187.943 Y93.003 E.00409
; LINE_WIDTH: 0.513857
G1 F15925.697
G1 X187.922 Y93.098 E.00375
; LINE_WIDTH: 0.451103
G1 F18374.145
G1 X187.901 Y94.945 E.06209
; LINE_WIDTH: 0.472189
G1 F17471.571
G1 X187.923 Y95.164 E.00778
; LINE_WIDTH: 0.516587
G1 F15833.934
G1 X187.945 Y95.383 E.00859
; LINE_WIDTH: 0.560984
G1 F14476.984
G1 X187.967 Y95.603 E.00939
; LINE_WIDTH: 0.605382
G1 F13334.252
G1 X187.989 Y95.822 E.0102
G1 X188.05 Y95.618 E.00983
; LINE_WIDTH: 0.560984
G1 F14476.984
G1 X188.11 Y95.415 E.00906
; LINE_WIDTH: 0.516587
G1 F15833.934
G1 X188.171 Y95.211 E.00828
; LINE_WIDTH: 0.453444
G1 F18269.352
G3 X188.927 Y94.106 I2.465 J.876 E.04574
M204 S10000
G1 X189.928 Y94.068 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G3 X188.513 Y92.632 I.325 J-1.735 E.07194
G1 X188.485 Y91.647 E.03301
G1 X187.494 Y91.647 E.03323
G1 X187.494 Y96.49 E.16229
G1 X188.485 Y96.49 E.03323
G3 X188.611 Y95.155 I3.606 J-.334 E.04518
G3 X189.871 Y94.086 I1.694 J.719 E.05743
M204 S10000
G1 X187.989 Y95.994 F60000
; LINE_WIDTH: 0.62759
G1 F12827.749
M204 S8000
G1 X187.989 Y95.882 E.00541
M204 S10000
G1 X187.086 Y96.897 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X188.892 Y96.897 E.06051
G3 X188.99 Y95.304 I4.28 J-.538 E.05381
G3 X189.612 Y94.584 I1.327 J.518 E.0325
; LINE_WIDTH: 0.471944
G1 F17481.567
G1 X189.804 Y94.501 E.00737
; LINE_WIDTH: 0.51585
G1 F15858.584
G1 X189.995 Y94.419 E.00812
; LINE_WIDTH: 0.574385
G1 F14111.935
G3 X190.317 Y94.335 I.264 J.352 E.01492
G1 X194.311 Y94.335 E.17471
; LINE_WIDTH: 0.554182
G1 F14669.593
G1 X194.477 Y94.386 E.00734
; LINE_WIDTH: 0.512505
G1 F15971.55
G1 X194.644 Y94.437 E.00674
; LINE_WIDTH: 0.453027
G1 F18287.925
G3 X195.568 Y95.151 I-.467 J1.558 E.04032
; LINE_WIDTH: 0.470827
G1 F17527.185
G1 X195.644 Y95.375 E.00832
; LINE_WIDTH: 0.5125
G1 F15971.72
G1 X195.721 Y95.598 E.00913
; LINE_WIDTH: 0.573248
G1 F14142.2
G1 X195.798 Y95.822 E.01032
G1 X195.798 Y96.835 E.04421
G1 X196.33 Y96.835 E.02323
G1 X196.33 Y95.822 E.04421
; LINE_WIDTH: 0.554174
G1 F14669.832
G1 X196.351 Y95.53 E.01233
; LINE_WIDTH: 0.5125
G1 F15971.72
G1 X196.372 Y95.237 E.01132
; LINE_WIDTH: 0.452974
G1 F18290.311
G2 X196.392 Y93.192 I-14.331 J-1.169 E.06911
; LINE_WIDTH: 0.47304
G1 F17436.996
G1 X196.369 Y93.001 E.00679
; LINE_WIDTH: 0.51914
G1 F15749.024
G1 X196.346 Y92.811 E.00752
; LINE_WIDTH: 0.577071
G1 F14040.984
G3 X196.33 Y91.302 I23.759 J-1.013 E.06634
G1 X195.798 Y91.302 E.0234
G3 X195.782 Y92.573 I-10.376 J.506 E.05592
; LINE_WIDTH: 0.56524
G1 F14359.014
G1 X195.71 Y92.711 E.00666
; LINE_WIDTH: 0.51914
G1 F15749.024
G1 X195.639 Y92.848 E.00607
; LINE_WIDTH: 0.453023
G1 F18288.101
G3 X194.811 Y93.649 I-1.8 J-1.033 E.03942
; LINE_WIDTH: 0.470829
G1 F17527.12
G1 X194.644 Y93.7 E.00614
; LINE_WIDTH: 0.512505
G1 F15971.55
G1 X194.477 Y93.751 E.00674
; LINE_WIDTH: 0.574276
G1 F14114.843
G1 X194.311 Y93.802 E.00763
G3 X190.187 Y93.8 I-1.997 J-115.954 E.18037
; LINE_WIDTH: 0.559757
G1 F14511.355
G1 X189.995 Y93.718 E.00888
; LINE_WIDTH: 0.51585
G1 F15858.584
G1 X189.804 Y93.635 E.00812
; LINE_WIDTH: 0.45044
G1 F18404.003
G3 X188.892 Y92.315 I.496 J-1.317 E.05726
G1 X188.892 Y91.24 E.03607
G1 X187.086 Y91.24 E.06058
G1 X187.086 Y96.837 E.18776
M204 S10000
G1 X186.679 Y97.304 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X189.299 Y97.304 E.0878
G1 X189.299 Y95.822 E.04967
G3 X190.317 Y94.804 I1.018 J0 E.05357
G1 X194.311 Y94.804 E.13382
G3 X195.328 Y95.822 I0 J1.018 E.05357
G1 X195.328 Y97.304 E.04967
G1 X196.799 Y97.304 E.0493
G1 X196.799 Y90.833 E.21685
G1 X195.328 Y90.833 E.0493
G3 X195.313 Y92.491 I-9.536 J.741 E.05564
G3 X194.311 Y93.333 I-1.002 J-.176 E.04765
G1 X190.317 Y93.333 E.13382
G3 X189.299 Y92.315 I0 J-1.018 E.05357
G1 X189.299 Y90.833 E.04967
G1 X186.679 Y90.833 E.0878
G1 X186.679 Y97.244 E.21484
M204 S10000
G1 X186.272 Y97.711 F60000
G1 F18424.351
M204 S8000
G1 X189.707 Y97.711 E.11508
G1 X189.707 Y95.822 E.06331
G3 X190.317 Y95.211 I.714 J.103 E.03102
G1 X194.311 Y95.211 E.13382
G3 X194.921 Y95.822 I-.119 J.73 E.0309
G1 X194.921 Y97.711 E.06331
G1 X197.207 Y97.711 E.07658
G1 X197.207 Y90.426 E.24413
G1 X194.921 Y90.426 E.07658
G1 X194.921 Y92.315 E.06331
G3 X194.311 Y92.926 I-.73 J-.119 E.0309
G1 X190.317 Y92.926 E.13382
G3 X189.707 Y92.143 I.046 J-.666 E.03752
G1 X189.707 Y90.426 E.05754
G1 X186.272 Y90.426 E.11508
G1 X186.272 Y97.651 E.24212
M204 S10000
G1 X185.865 Y98.118 F60000
G1 F18424.351
M204 S8000
G1 X190.114 Y98.118 E.14236
G1 X190.114 Y95.822 E.07695
G3 X190.317 Y95.618 I.204 J0 E.01071
G1 X194.311 Y95.618 E.13382
G3 X194.514 Y95.822 I0 J.204 E.01071
G1 X194.514 Y98.118 E.07695
G1 X197.614 Y98.118 E.10386
G1 X197.614 Y90.019 E.27141
G1 X194.514 Y90.019 E.10386
G1 X194.514 Y92.315 E.07695
G3 X194.311 Y92.519 I-.204 J0 E.01071
G1 X190.317 Y92.519 E.13382
G3 X190.114 Y92.315 I0 J-.204 E.01071
G1 X190.114 Y90.019 E.07695
G1 X185.865 Y90.019 E.14236
G1 X185.865 Y98.058 E.2694
M204 S10000
G1 X157.758 Y92.912 F60000
; LINE_WIDTH: 0.513647
G1 F15932.813
M204 S8000
G1 X157.937 Y92.888 E.00698
; LINE_WIDTH: 0.46662
G1 F17701.206
G1 X158.116 Y92.865 E.00628
; LINE_WIDTH: 0.419594
G1 F19911.152
G1 X158.294 Y92.841 E.00559
; LINE_WIDTH: 0.353198
G1 F21000
G3 X162.81 Y92.818 I2.52 J51.886 E.11539
; LINE_WIDTH: 0.37556
G1 X163.168 Y92.842 E.00981
; LINE_WIDTH: 0.42556
G1 F19600.67
G1 X163.526 Y92.865 E.01129
M204 S10000
G1 X163.586 Y92.868 F60000
; LINE_WIDTH: 0.450037
G1 F18422.236
M204 S8000
G3 X165.797 Y95.269 I-.764 J2.922 E.11554
G1 X171.542 Y95.268 E.19255
G3 X169.331 Y92.868 I.764 J-2.922 E.11554
G1 X163.646 Y92.868 E.19054
M204 S10000
G1 X165.151 Y93.275 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G3 X166.124 Y94.862 I-2.592 J2.682 E.06304
G1 X169.977 Y94.862 E.12911
G3 X169.004 Y93.275 I2.592 J-2.682 E.06304
G1 X165.211 Y93.275 E.1271
M204 S10000
G1 X166.021 Y93.682 F60000
G1 F18424.351
M204 S8000
G3 X166.412 Y94.455 I-1.827 J1.412 E.02919
G1 X169.107 Y94.455 E.0903
G3 X168.715 Y93.682 I1.827 J-1.412 E.02919
G1 X166.081 Y93.682 E.08829
M204 S10000
G1 X166.686 Y94.068 F60000
; LINE_WIDTH: 0.40814
G1 F20535.567
M204 S8000
G1 X168.382 Y94.068 E.051
M204 S10000
G1 X169.689 Y92.461 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X157.308 Y92.461 E.41489
G1 X157.313 Y93.639 E.03948
G3 X158.817 Y93.176 I1.587 J2.479 E.0534
G1 X162.81 Y93.176 E.13382
G3 X165.439 Y95.676 I-.026 J2.659 E.13376
G1 X177.826 Y95.676 E.4151
G1 X177.826 Y94.481 E.04003
G3 X176.311 Y94.961 I-1.587 J-2.381 E.05399
G1 X172.317 Y94.961 E.13382
G3 X169.696 Y92.521 I.024 J-2.653 E.13173
M204 S10000
G1 X170.078 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.078 Y92.054 E.00875
G1 X156.901 Y92.054 E.44158
G1 X156.901 Y94.723 E.08943
G3 X158.817 Y93.583 I1.96 J1.114 E.07816
G1 X162.81 Y93.583 E.13382
G3 X165.049 Y96.083 I-.036 J2.285 E.1263
G1 X178.233 Y96.083 E.44179
G1 X178.233 Y93.403 E.08981
G3 X176.311 Y94.554 I-1.966 J-1.103 E.0786
G1 X172.317 Y94.554 E.13382
G3 X170.085 Y92.375 I.027 J-2.26 E.11536
M204 S10000
G1 X170.485 Y92.315 F60000
; LINE_WIDTH: 0.453962
G1 F18246.328
M204 S8000
G1 X170.485 Y91.647 E.02261
G1 X156.494 Y91.647 E.47343
G2 X156.515 Y96.469 I313.384 J1.036 E.16316
G1 X156.964 Y96.469 E.01521
G3 X157.385 Y94.679 I2.765 J-.294 E.06341
G3 X158.817 Y93.99 I1.432 J1.143 E.05561
G1 X162.81 Y93.99 E.13512
G3 X164.642 Y95.822 I-.026 J1.858 E.09699
G1 X164.642 Y96.49 E.02261
G1 X178.64 Y96.49 E.47365
G2 X178.618 Y91.67 I-356.407 J-.727 E.1631
G1 X178.165 Y91.67 E.01532
G1 X178.165 Y92.315 E.02184
; LINE_WIDTH: 0.493286
G1 F16653.149
G3 X178.036 Y92.937 I-1.124 J.091 E.02388
; LINE_WIDTH: 0.450151
G1 F18417.075
G3 X176.311 Y94.147 I-1.779 J-.701 E.07482
G1 X172.317 Y94.147 E.13387
G3 X170.492 Y92.375 I.021 J-1.847 E.09405
M204 S10000
G1 X170.892 Y92.315 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X170.892 Y91.24 E.03603
G1 X156.086 Y91.24 E.49614
G1 X156.086 Y96.897 E.18957
G1 X157.392 Y96.897 E.04376
G3 X157.477 Y95.338 I4.496 J-.538 E.05259
G3 X158.817 Y94.397 I1.34 J.484 E.05844
G1 X162.81 Y94.397 E.13382
G3 X164.235 Y95.822 I-.02 J1.445 E.07471
G1 X164.235 Y96.897 E.03603
G1 X179.048 Y96.897 E.49635
G1 X179.048 Y91.24 E.18957
G1 X177.735 Y91.24 E.04397
G3 X177.651 Y92.798 I-4.501 J.538 E.05256
G3 X176.311 Y93.74 I-1.34 J-.483 E.05848
G1 X172.317 Y93.74 E.13382
G3 X170.9 Y92.375 I.015 J-1.435 E.07267
M204 S10000
G1 X171.299 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X171.299 Y90.833 E.04967
G1 X155.679 Y90.833 E.52342
G1 X155.679 Y97.304 E.21685
G1 X157.799 Y97.304 E.07104
G1 X157.799 Y95.822 E.04967
G3 X158.817 Y94.804 I1.045 J.027 E.05319
G1 X162.81 Y94.804 E.13382
G3 X163.828 Y95.822 I-.018 J1.036 E.05332
G1 X163.828 Y97.304 E.04967
G1 X179.455 Y97.304 E.52363
G1 X179.455 Y90.833 E.21685
G1 X177.328 Y90.833 E.07126
G1 X177.328 Y92.315 E.04967
G3 X176.311 Y93.333 I-1.045 J-.027 E.05319
G1 X172.317 Y93.333 E.13382
G3 X171.312 Y92.374 I.012 J-1.019 E.05122
M204 S10000
G1 X171.707 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X171.707 Y90.426 E.06331
G1 X155.272 Y90.426 E.5507
G1 X155.272 Y97.711 E.24413
G1 X158.206 Y97.711 E.09832
G1 X158.206 Y95.822 E.06331
G3 X158.817 Y95.211 I.611 J0 E.03214
G1 X162.81 Y95.211 E.13382
G3 X163.421 Y95.822 I0 J.611 E.03214
G1 X163.421 Y97.711 E.06331
G1 X179.862 Y97.711 E.55092
G1 X179.862 Y90.426 E.24413
G1 X176.921 Y90.426 E.09854
G1 X176.921 Y92.315 E.06331
G3 X176.311 Y92.926 I-.611 J0 E.03214
G1 X172.317 Y92.926 E.13382
G3 X171.714 Y92.375 I-.002 J-.604 E.03007
M204 S10000
G1 X172.114 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X172.114 Y90.019 E.07695
G1 X154.865 Y90.019 E.57798
G1 X154.865 Y98.118 E.27141
G1 X158.614 Y98.118 E.1256
G1 X158.614 Y95.822 E.07695
G3 X158.817 Y95.618 I.249 J.045 E.01026
G1 X162.81 Y95.618 E.13382
G3 X163.014 Y95.822 I0 J.204 E.01071
G1 X163.014 Y98.118 E.07695
G1 X180.269 Y98.118 E.5782
G1 X180.269 Y90.019 E.27141
G1 X176.514 Y90.019 E.12582
G1 X176.514 Y92.315 E.07695
G3 X176.311 Y92.519 I-.249 J-.045 E.01026
G1 X172.317 Y92.519 E.13382
G3 X172.138 Y92.37 I-.015 J-.164 E.00867
M204 S10000
G1 X171.542 Y95.268 F60000
; LINE_WIDTH: 0.42556
G1 F19600.67
M204 S8000
G1 X171.93 Y95.293 E.01223
; LINE_WIDTH: 0.354968
G1 F21000
G1 X172.317 Y95.318 E.00998
G2 X176.833 Y95.296 I1.997 J-51.909 E.11605
; LINE_WIDTH: 0.419917
G1 F19894.074
G1 X176.994 Y95.274 E.00503
; LINE_WIDTH: 0.46759
G1 F17660.773
G1 X177.155 Y95.253 E.00566
; LINE_WIDTH: 0.515264
G1 F15878.282
G1 X177.315 Y95.232 E.0063
M204 S10000
G1 X154.473 Y92.469 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X154.473 Y90.063 E.07469
G1 X149.661 Y90.063 E.14938
G1 X149.661 Y98.074 E.24868
G1 X154.473 Y98.074 E.14938
G1 X154.473 Y92.529 E.17213
M204 S10000
G1 X154.096 Y92.469 F60000
G1 F15000
M204 S8000
G1 X154.096 Y90.44 E.06299
G1 X150.038 Y90.44 E.12597
G1 X150.038 Y97.697 E.22528
G1 X154.096 Y97.697 E.12597
G1 X154.096 Y92.529 E.16043
M204 S10000
G1 X153.719 Y92.469 F60000
G1 F15000
M204 S8000
G1 X153.719 Y90.817 E.05128
G1 X150.415 Y90.817 E.10257
G1 X150.415 Y97.32 E.20187
G1 X153.719 Y97.32 E.10257
G1 X153.719 Y92.529 E.14872
M204 S10000
G1 X153.342 Y92.469 F60000
G1 F15000
M204 S8000
G1 X153.342 Y91.194 E.03958
G1 X150.792 Y91.194 E.07916
G1 X150.792 Y96.943 E.17846
G1 X153.342 Y96.943 E.07916
G1 X153.342 Y92.529 E.13702
M204 S10000
G1 X152.965 Y92.469 F60000
G1 F15000
M204 S8000
G1 X152.965 Y91.571 E.02787
G1 X151.169 Y91.571 E.05575
G1 X151.169 Y96.566 E.15505
G1 X152.965 Y96.566 E.05575
G1 X152.965 Y92.529 E.12531
M204 S10000
G1 X152.588 Y92.469 F60000
G1 F15000
M204 S8000
G1 X152.588 Y91.948 E.01617
G1 X151.546 Y91.948 E.03234
G1 X151.546 Y96.189 E.13164
G1 X152.588 Y96.189 E.03234
G1 X152.588 Y92.529 E.11361
M204 S10000
G1 X152.233 Y92.469 F60000
; LINE_WIDTH: 0.37533
G1 F15000
M204 S8000
G1 X152.233 Y92.303 E.00455
G1 X151.901 Y92.303 E.0091
G1 X151.901 Y95.834 E.09664
G1 X152.233 Y95.834 E.0091
G1 X152.233 Y92.529 E.09045
M204 S10000
G1 X140.386 Y95.246 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.470827
G1 F17527.185
M204 S8000
G1 X140.696 Y95.27 E.01097
; LINE_WIDTH: 0.42272
G1 F19747.235
G1 X141.007 Y95.294 E.00973
; LINE_WIDTH: 0.354578
G1 F21000
G1 X141.317 Y95.318 E.00799
G2 X145.833 Y95.296 I1.997 J-51.909 E.1159
; LINE_WIDTH: 0.419917
G1 F19894.074
G1 X145.994 Y95.274 E.00503
; LINE_WIDTH: 0.46759
G1 F17660.773
G1 X146.155 Y95.253 E.00566
; LINE_WIDTH: 0.515264
G1 F15878.282
G1 X146.315 Y95.232 E.0063
M204 S10000
G1 X146.826 Y94.481 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G3 X145.31 Y94.961 I-1.587 J-2.381 E.05399
G1 X141.317 Y94.961 E.13382
G3 X139.956 Y94.575 I-.018 J-2.527 E.04803
G1 X139.956 Y95.676 E.03688
G1 X146.826 Y95.676 E.23021
G1 X146.826 Y94.541 E.03802
M204 S10000
G1 X147.233 Y93.403 F60000
G1 F18424.351
M204 S8000
G3 X145.31 Y94.554 I-1.966 J-1.103 E.0786
G1 X141.317 Y94.554 E.13382
G3 X139.549 Y93.662 I-.009 J-2.18 E.06887
G1 X139.549 Y96.083 E.08111
G1 X147.233 Y96.083 E.25749
G1 X147.233 Y93.463 E.0878
M204 S10000
G1 X147.618 Y91.896 F60000
; LINE_WIDTH: 0.497073
G1 F16514.264
M204 S8000
G1 X147.618 Y91.67 E.00846
G1 X147.165 Y91.67 E.01692
G3 X147.145 Y92.637 I-7.749 J.323 E.03619
; LINE_WIDTH: 0.497185
G1 F16510.187
G1 X147.091 Y92.787 E.00597
; LINE_WIDTH: 0.45014
G1 F18417.598
G3 X145.31 Y94.147 I-1.797 J-.507 E.08053
G1 X141.317 Y94.147 E.13387
G3 X139.521 Y92.63 I.052 J-1.883 E.08509
; LINE_WIDTH: 0.44613
G1 F18600.746
G3 X139.501 Y91.631 I20.453 J-.905 E.03318
G1 X139.126 Y91.631 E.01245
G3 X139.142 Y96.49 I-729.634 J4.838 E.16128
G1 X147.64 Y96.49 E.28207
G2 X147.638 Y93.042 I-513.785 J-1.36 E.11443
; LINE_WIDTH: 0.481919
G1 F17084.34
G3 X147.618 Y91.956 I19.421 J-.907 E.03927
M204 S10000
G1 X148.048 Y91.896 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X148.048 Y91.24 E.02199
G1 X146.735 Y91.24 E.04397
G3 X146.651 Y92.798 I-4.501 J.538 E.05256
G3 X145.31 Y93.74 I-1.34 J-.483 E.05847
G1 X141.317 Y93.74 E.13382
G3 X139.892 Y92.315 I.041 J-1.466 E.07444
G1 X139.892 Y91.24 E.03603
G1 X138.735 Y91.24 E.03877
G1 X138.735 Y96.897 E.18957
G1 X148.048 Y96.897 E.31205
G1 X148.048 Y91.956 E.16557
M204 S10000
G1 X148.455 Y91.896 F60000
G1 F18424.351
M204 S8000
G1 X148.455 Y90.833 E.03563
G1 X146.328 Y90.833 E.07126
G1 X146.328 Y92.315 E.04967
G3 X145.31 Y93.333 I-1.045 J-.027 E.05319
G1 X141.317 Y93.333 E.13382
G3 X140.299 Y92.315 I.029 J-1.047 E.05317
G1 X140.299 Y90.833 E.04967
G1 X138.328 Y90.833 E.06606
G1 X138.328 Y97.304 E.21685
G1 X148.455 Y97.304 E.33933
G1 X148.455 Y91.956 E.17921
M204 S10000
G1 X148.862 Y91.896 F60000
G1 F18424.351
M204 S8000
G1 X148.862 Y90.426 E.04927
G1 X145.921 Y90.426 E.09854
G1 X145.921 Y92.315 E.06331
G3 X145.31 Y92.926 I-.611 J0 E.03214
G1 X141.317 Y92.926 E.13382
G3 X140.716 Y92.421 I.02 J-.634 E.02838
G3 X140.706 Y90.426 I65.427 J-1.299 E.06685
G1 X137.921 Y90.426 E.09334
G1 X137.921 Y97.711 E.24413
G1 X148.862 Y97.711 E.36661
G1 X148.862 Y91.956 E.19285
M204 S10000
G1 X149.269 Y91.896 F60000
G1 F18424.351
M204 S8000
G1 X149.269 Y90.019 E.06291
G1 X145.514 Y90.019 E.12582
G1 X145.514 Y92.315 E.07695
G3 X145.31 Y92.519 I-.249 J-.045 E.01026
G1 X141.317 Y92.519 E.13382
G3 X141.114 Y92.315 I0 J-.204 E.01071
G1 X141.114 Y90.019 E.07695
G1 X137.514 Y90.019 E.12062
G1 X137.514 Y98.118 E.27141
G1 X149.269 Y98.118 E.39389
G1 X149.269 Y91.956 E.20649
; WIPE_START
G1 X149.269 Y92.956 E-.38
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
    

    

    
        M9711 M0 E0 U266 V97 Z1.2 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

M204 S10000
G1 X151.058 Y195.749
G1 Z.8
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X148.870 Y194.931  
M204 S8000
G3  X149.704 Y191.976   I2.026 J-1.023 E0.1282 F5400
G2  X150.558 Y189.443   I-3.390 J-2.554 E0.1033
G1  Y184.499  E0.1879
G1 E-0.4000 F1800
M204 S10000
G1  Y181.999  F600
G1 E0.4000 F1800
M204 S8000
G2  X150.434 Y177.044   I-20.265 J-1.972 E0.1888 F5400
G2  X148.659 Y174.188   I-11.353 J5.076 E0.1282
G3  X149.047 Y172.347   I1.734 J-0.596 E0.0751
G3  X152.165 Y169.085   I19.448 J15.469 E0.1717
G3  X155.363 Y169.743   I1.278 J1.891 E0.1383
G2  X158.380 Y170.749   I3.023 J-4.037 E0.1230
G1  X164.308  E0.2253
G1  X165.558  E0.0475
G2  X171.182 Y170.659   I2.339 J-29.659 E0.2141
G2  X174.517 Y168.801   I-2.882 J-9.098 E0.1461
G3  X176.684 Y169.296   I0.711 J1.877 E0.0895
G3  X179.746 Y172.567   I-16.399 J18.421 E0.1705
G3  X178.912 Y175.522   I-2.026 J1.023 E0.1282
G2  X178.058 Y178.055   I3.390 J2.554 E0.1033
G2  X178.061 Y189.613   I283.960 J5.694 E0.4393
G2  X179.904 Y193.178   I6.625 J-1.166 E0.1549
G3  X179.569 Y195.151   I-1.652 J0.734 E0.0806
G1  X178.058 Y196.749   E0.0836
G3  X175.599 Y198.794   I-4.377 J-2.762 E0.1236
G3  X172.940 Y197.538   I0.009 J-3.462 E0.1154
G2  X170.236 Y196.749   I-2.710 J4.259 E0.1085
G2  X158.190 Y196.753   I-5.928 J318.375 E0.4578
G2  X154.243 Y198.635   I0.501 J6.129 E0.1699
G3  X151.932 Y198.202   I-0.852 J-1.839 E0.0953
G3  X148.870 Y194.931   I16.406 J-18.427 E0.1705
; WIPE_TOWER_END
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
G1 E-.4 F1800
G17
G3 Z1.2 I1.217 J0 P1  F60000
G1 X151.308 Y171.499
G1 Z.8
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF0 NF1 ON2 NN0
M204 S8000
G1  X177.308 Y171.499  E2.0691 F7836
G1  Y172.999  E0.1194
G1  X151.308  E2.0691
; NOZZLE_CHANGE_END OF0 NF1 ON2 NN0
M400
M104 T0 S25 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S8000
G1 X152.308 Y172.999 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S10000
G17
G3 Z1.2 I1.217 J0 P1  F5400
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

G1 Z3.8 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X149.058 Y183.249



M620.10 A0 F498.898 L0 H0.4 T240 P220 S1



M620.10 A1 F498.898 L0 H0.4 T180 P150 S1



M620.11 P1 I0 B-1 E-14 F623.623



M620.15 P180
M620.15 C140
M620.11 O1 T18


M620.11 K1 I0 B-1 R10 F623.623


M620.15 C140

M628 S1


M620.11 S1 L0 I0 B-1 R10 D8 E-14 F623.623


M629


;M620.11 H0




T1 H-1
M73 E9

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

;VM109 S150

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F10.4167 A0.4 R2


M400

G387 Y320 J1 F10000
M73 P43 R17
G1 X183.06 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.8 F3000

M204 S8000


M621 S1A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y320 J1 F10000
G1 X183.06 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.8 F3000

M204 S8000

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I1 H-1 W1 ;enable ams air printing detect
M620 O6
M1002 gcode_claim_action : 0
M106 S63.75
M106 P2 S102
G1 X154.405 Y200.828 F600
M204 S1000
G1 Z.8
G17
G3 Z1.2 I0 J-1.217 P1
G1 X146.555 Y200.828 Z1.2
G1 X146.555 Y183.249

; filament start gcode
M109 S145;
G1 X151.058 Y183.249
G1 Z.8
G1 E2.2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S25
G1  X154.058 Y183.249  E0.1140 F1782
M73 P43 R16
G1 E-0.4000 F1800
M204 S1000
G1  X149.558  F600
G1  X151.058  F240
G1  X151.558  F600
G1  Y183.749 
G1  X150.558 
G1  Y182.749 
G1  X152.058 
G1  Y184.249 
G1  X150.058 
G1  Y182.249 
G1  X154.058 Y183.249   F1782
G1 E0.4000 F1800
M400
M104 T1 S150 N0
M204 S25
G1  X177.558  E0.8931 F1782
G1  Y182.499  E0.0285
G1  X151.058  E1.0072 F2025
G1  Y181.749  E0.0285
G1  X177.558  E1.0072 F2473
M73 P44 R16
G1  Y180.999  E0.0285
G1  X151.058  E1.0072 F4725
G1  Y180.249  E0.0285
G1  X177.558  E1.0072 F4775
G1  Y179.499  E0.0285
G1  X151.058  E1.0072
G1  Y178.749  E0.0285
G1  X177.558  E1.0072
G1  Y177.999  E0.0285
G1  X151.058  E1.0072
G1  Y177.249  E0.0285
G1  X177.558  E1.0072
G1  Y176.499  E0.0285
G1  X151.058  E1.0072
G1  Y175.749  E0.0285
G1  X177.558  E1.0072
G1  Y174.999  E0.0285
G1  X151.058  E1.0072
G1  Y174.249  E0.0285
G1  X177.558  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y196.249   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S25
G1  X151.058  E1.0072
M73 P45 R16
G1  Y183.999  E0.4656
G1  X177.558  E1.0072
G1  Y196.249  E0.4656
M204 S1000
G1  X152.058 Y183.999  
;--------------------
; CP EMPTY GRID START
; layer #5
M204 S25
G1  Y196.249  E0.4656
M204 S1000
G1  X160.225 
M204 S25
G1  Y183.999  E0.4656
M204 S1000
G1  X168.391 
M204 S25
G1  Y196.249  E0.4656
M204 S1000
G1  X176.558 
M204 S25
G1  Y183.999  E0.4656
; CP EMPTY GRID END
;------------------






; WIPE_TOWER_END

; WIPE_START
M204 S25
G1 X176.558 Y184.999 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I1.217 J0 P1  F600
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S1000
G1 X143.962 Y90.966
G1 Z.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
M73 P46 R16
G1 X142.672 Y90.966 E.04322
G1 X142.672 Y89.671 E.04343
G1 X143.962 Y89.671 E.04322
G1 X143.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X144.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X142.28 Y91.358 E.06437
G1 X142.28 Y89.278 E.06457
G1 X144.354 Y89.278 E.06437
G1 X144.354 Y91.298 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X143.354 Y91.327 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I-.374 J1.158 P1  F600
G1 X161.462 Y97.171 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X161.462 Y98.466 E.04343
G1 X160.172 Y98.466 E.04322
G1 X160.172 Y97.171 E.04343
G1 X161.402 Y97.171 E.04121
; COOLING_NODE: 0
G1 X161.854 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X161.854 Y98.858 E.06457
G1 X159.78 Y98.858 E.06437
G1 X159.78 Y96.778 E.06457
G1 X161.794 Y96.778 E.06251
; COOLING_NODE: 0
; WIPE_START
G1 X161.823 Y97.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I.56 J1.08 P1  F600
G1 X174.962 Y90.966 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X173.672 Y90.966 E.04322
G1 X173.672 Y89.671 E.04343
G1 X174.962 Y89.671 E.04322
G1 X174.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X175.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X173.28 Y91.358 E.06437
G1 X173.28 Y89.278 E.06457
G1 X175.354 Y89.278 E.06437
G1 X175.354 Y91.298 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X174.354 Y91.327 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I.024 J1.217 P1  F600
G1 X192.962 Y90.966 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X191.672 Y90.966 E.04322
G1 X191.672 Y89.671 E.04343
G1 X192.962 Y89.671 E.04322
G1 X192.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X193.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X191.28 Y91.358 E.06437
G1 X191.28 Y89.278 E.06457
G1 X193.354 Y89.278 E.06437
G1 X193.354 Y91.298 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X192.354 Y91.327 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I-1.21 J.126 P1  F600
G1 X192.962 Y97.171 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P47 R16
G1 F600
M204 S25
G1 X192.962 Y98.466 E.04343
G1 X191.672 Y98.466 E.04322
G1 X191.672 Y97.171 E.04343
G1 X192.902 Y97.171 E.04121
; COOLING_NODE: 0
G1 X193.354 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X193.354 Y98.858 E.06457
G1 X191.28 Y98.858 E.06437
G1 X191.28 Y96.778 E.06457
M73 P47 R15
G1 X193.294 Y96.778 E.06251
M204 S1000
G1 X192.096 Y97.595
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48422
M204 S25
G1 X192.096 Y98.042 E.01626
G1 X192.538 Y98.042 E.01603
G1 X192.538 Y97.595 E.01626
G1 X192.156 Y97.595 E.01385
; WIPE_START
G1 X192.538 Y97.595 E-.14489
G1 X192.538 Y98.042 E-.17005
G1 X192.366 Y98.042 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I1.216 J-.044 P1  F600
G1 X192.096 Y90.542 Z1.2
G1 Z.8
G1 E.6 F1800
G1 F600
M204 S25
G1 X192.538 Y90.542 E.01603
G1 X192.538 Y90.095 E.01626
G1 X192.096 Y90.095 E.01603
G1 X192.096 Y90.482 E.01408
; WIPE_START
G1 X192.096 Y90.095 E-.14725
G1 X192.538 Y90.095 E-.16769
G1 X192.538 Y90.266 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I-.018 J-1.217 P1  F600
G1 X174.096 Y90.542 Z1.2
G1 Z.8
G1 E.6 F1800
G1 F600
M204 S25
G1 X174.538 Y90.542 E.01603
G1 X174.538 Y90.095 E.01626
G1 X174.096 Y90.095 E.01603
G1 X174.096 Y90.482 E.01408
; WIPE_START
G1 X174.096 Y90.095 E-.14725
G1 X174.538 Y90.095 E-.16769
G1 X174.538 Y90.266 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I-.581 J-1.07 P1  F600
G1 X161.038 Y97.595 Z1.2
G1 Z.8
G1 E.6 F1800
G1 F600
M204 S25
G1 X160.596 Y97.595 E.01603
G1 X160.596 Y98.042 E.01626
G1 X161.038 Y98.042 E.01603
G1 X161.038 Y97.655 E.01408
; WIPE_START
G1 X161.038 Y98.042 E-.14725
G1 X160.596 Y98.042 E-.16769
G1 X160.596 Y97.871 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I.48 J-1.118 P1  F600
G1 X143.538 Y90.542 Z1.2
G1 Z.8
G1 E.6 F1800
G1 F600
M204 S25
G1 X143.538 Y90.095 E.01626
G1 X143.096 Y90.095 E.01603
G1 X143.096 Y90.542 E.01626
G1 X143.478 Y90.542 E.01385
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 5/14
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
M106 S61.2
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S1000
G1 X143.962 Y90.966 Z1 F600
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
M204 S25
G1 X142.672 Y90.966 E.04322
G1 X142.672 Y89.671 E.04343
G1 X143.962 Y89.671 E.04322
G1 X143.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X144.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X142.28 Y91.358 E.06437
G1 X142.28 Y89.278 E.06457
G1 X144.354 Y89.278 E.06437
G1 X144.354 Y91.298 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X143.354 Y91.327 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I-.374 J1.158 P1  F600
G1 X161.462 Y97.171 Z1.4
G1 Z1
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X161.462 Y98.466 E.04343
G1 X160.172 Y98.466 E.04322
G1 X160.172 Y97.171 E.04343
G1 X161.402 Y97.171 E.04121
; COOLING_NODE: 0
G1 X161.854 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X161.854 Y98.858 E.06457
M73 P48 R15
G1 X159.78 Y98.858 E.06437
G1 X159.78 Y96.778 E.06457
G1 X161.794 Y96.778 E.06251
; COOLING_NODE: 0
; WIPE_START
G1 X161.823 Y97.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I.56 J1.08 P1  F600
G1 X174.962 Y90.966 Z1.4
G1 Z1
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X173.672 Y90.966 E.04322
G1 X173.672 Y89.671 E.04343
G1 X174.962 Y89.671 E.04322
G1 X174.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X175.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X173.28 Y91.358 E.06437
G1 X173.28 Y89.278 E.06457
G1 X175.354 Y89.278 E.06437
G1 X175.354 Y91.298 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X174.354 Y91.327 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I.024 J1.217 P1  F600
G1 X192.962 Y90.966 Z1.4
G1 Z1
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X191.672 Y90.966 E.04322
G1 X191.672 Y89.671 E.04343
G1 X192.962 Y89.671 E.04322
G1 X192.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X193.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X191.28 Y91.358 E.06437
G1 X191.28 Y89.278 E.06457
G1 X193.354 Y89.278 E.06437
G1 X193.354 Y91.298 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X192.354 Y91.327 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I-1.21 J.126 P1  F600
G1 X192.962 Y97.171 Z1.4
G1 Z1
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X192.962 Y98.466 E.04343
G1 X191.672 Y98.466 E.04322
G1 X191.672 Y97.171 E.04343
G1 X192.902 Y97.171 E.04121
; COOLING_NODE: 0
G1 X193.354 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X193.354 Y98.858 E.06457
G1 X191.28 Y98.858 E.06437
G1 X191.28 Y96.778 E.06457
G1 X193.294 Y96.778 E.06251
M204 S1000
G1 X192.096 Y97.595
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48422
M204 S25
G1 X192.096 Y98.042 E.01626
G1 X192.538 Y98.042 E.01603
G1 X192.538 Y97.595 E.01626
G1 X192.156 Y97.595 E.01385
; WIPE_START
G1 X192.538 Y97.595 E-.14489
G1 X192.538 Y98.042 E-.17005
G1 X192.366 Y98.042 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I1.216 J-.044 P1  F600
G1 X192.096 Y90.542 Z1.4
G1 Z1
G1 E.6 F1800
G1 F600
M204 S25
G1 X192.538 Y90.542 E.01603
G1 X192.538 Y90.095 E.01626
G1 X192.096 Y90.095 E.01603
G1 X192.096 Y90.482 E.01408
; WIPE_START
G1 X192.096 Y90.095 E-.14725
G1 X192.538 Y90.095 E-.16769
G1 X192.538 Y90.266 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I-.018 J-1.217 P1  F600
G1 X174.096 Y90.542 Z1.4
G1 Z1
G1 E.6 F1800
G1 F600
M204 S25
G1 X174.538 Y90.542 E.01603
G1 X174.538 Y90.095 E.01626
G1 X174.096 Y90.095 E.01603
G1 X174.096 Y90.482 E.01408
; WIPE_START
G1 X174.096 Y90.095 E-.14725
G1 X174.538 Y90.095 E-.16769
G1 X174.538 Y90.266 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I-.581 J-1.07 P1  F600
G1 X161.038 Y97.595 Z1.4
G1 Z1
G1 E.6 F1800
M73 P49 R15
G1 F600
M204 S25
G1 X160.596 Y97.595 E.01603
G1 X160.596 Y98.042 E.01626
G1 X161.038 Y98.042 E.01603
G1 X161.038 Y97.655 E.01408
; WIPE_START
G1 X161.038 Y98.042 E-.14725
G1 X160.596 Y98.042 E-.16769
G1 X160.596 Y97.871 E-.06505
; WIPE_END
G1 E-.02 F1800
M632 S0 N R W
M400
M104 T0 S210 N0 ;Multi extruder pre heating
M633
M204 S1000
G17
G3 Z1.4 I.48 J-1.118 P1  F600
G1 X143.538 Y90.542 Z1.4
G1 Z1
G1 E.6 F1800
G1 F600
M204 S25
G1 X143.538 Y90.095 E.01626
G1 X143.096 Y90.095 E.01603
G1 X143.096 Y90.542 E.01626
G1 X143.478 Y90.542 E.01385
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
G1 X143.096 Y90.542 E-.14489
G1 X143.096 Y90.095 E-.17005
G1 X143.267 Y90.095 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I1.217 J0 P1  F600
G1 X151.308 Y171.499
G1 Z1
G1 E.6 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF1 NF0 ON0 NN2
M204 S25
G1  X177.308 Y171.499  E2.0691 F7836
; NOZZLE_CHANGE_END OF1 NF0 ON0 NN2
M400
M104 T1 S25 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S25
G1 X176.308 Y171.499 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S1000
G17
G3 Z1.4 I1.217 J0 P1  F5400
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

G1 Z4 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X149.058 Y172.749



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
M73 E8

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
M73 P50 R15
G1 X183.06 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4 F3000

M204 S25


M621 S0A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y320 J1 F10000
G1 X183.06 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4 F3000

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
G1 X157.666 Y200.828 F60000
M204 S10000
G1 Z1
G17
G3 Z1.4 I0 J-1.217 P1
G1 X146.555 Y200.828 Z1.4
G1 X146.555 Y172.749

; filament start gcode
G1 X151.058 Y172.749
G1 Z1
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X154.058 Y172.749  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X149.558  F600
G1  X151.058  F240
G1  X151.558  F600
G1  Y173.249 
M73 P50 R14
G1  X150.558 
G1  Y172.249 
G1  X152.058 
G1  Y173.749 
G1  X150.058 
G1  Y171.749 
G1  X154.058 Y172.749   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X177.558  E0.8931 F1782
G1  Y173.499  E0.0285
G1  X151.058  E1.0072 F2025
G1  Y174.249  E0.0285
G1  X177.558  E1.0072 F2473
G1  Y174.999  E0.0285
G1  X151.058  E1.0072 F4725
G1  Y175.749  E0.0285
G1  X177.558  E1.0072 F4775
G1  Y176.499  E0.0285
G1  X151.058  E1.0072
G1  Y177.249  E0.0285
G1  X177.558  E1.0072
G1  Y177.999  E0.0285
G1  X151.058  E1.0072
G1  Y178.749  E0.0285
G1  X177.558  E1.0072
G1  Y179.499  E0.0285
G1  X151.058  E1.0072
G1  Y180.249  E0.0285
G1  X177.558  E1.0072
G1  Y180.999  E0.0285
G1  X151.058  E1.0072
G1  Y181.749  E0.0285
G1  X177.558  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  X151.058 Y195.749   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X148.870 Y194.931  
M204 S8000
G3  X149.704 Y191.976   I2.026 J-1.023 E0.1282
G2  X150.558 Y189.443   I-3.390 J-2.554 E0.1033
G1  Y186.749  E0.1024
G1 E-0.4000 F1800
M204 S10000
G1  Y184.249  F600
G1 E0.4000 F1800
M204 S8000
G2  X150.527 Y177.546   I-54.891 J-3.097 E0.2549 F5400
G2  X148.712 Y174.320   I-6.407 J1.481 E0.1426
G3  X148.596 Y173.962   I1.776 J-0.772 E0.0143
G1 E-0.4000 F1800
M204 S10000
G1  X149.566 Y171.798   F600
G1 E0.4000 F1800
M204 S8000
G3  X152.293 Y168.994   I13.207 J10.117 E0.1490 F5400
G3  X155.518 Y169.854   I1.084 J2.411 E0.1373
G2  X158.380 Y170.749   I2.887 J-4.208 E0.1157
G1  X164.308  E0.2253
G1  X165.558  E0.0475
G2  X171.182 Y170.659   I2.339 J-29.659 E0.2141
G2  X174.517 Y168.801   I-2.882 J-9.098 E0.1461
G3  X176.684 Y169.296   I0.711 J1.877 E0.0895
G3  X179.746 Y172.567   I-16.399 J18.421 E0.1705
G3  X178.912 Y175.522   I-2.026 J1.023 E0.1282
G2  X178.058 Y178.055   I3.390 J2.554 E0.1033
G2  X178.061 Y189.613   I283.960 J5.694 E0.4393
G2  X179.904 Y193.178   I6.625 J-1.166 E0.1549
G3  X179.569 Y195.151   I-1.652 J0.734 E0.0806
G1  X178.058 Y196.749   E0.0836
G3  X175.599 Y198.794   I-4.377 J-2.762 E0.1236
G3  X172.940 Y197.538   I0.009 J-3.462 E0.1154
G2  X170.236 Y196.749   I-2.710 J4.259 E0.1085
G2  X158.190 Y196.753   I-5.928 J318.375 E0.4578
G2  X154.243 Y198.635   I0.501 J6.129 E0.1699
G3  X151.932 Y198.202   I-0.852 J-1.839 E0.0953
G3  X148.870 Y194.931   I16.406 J-18.427 E0.1705
; WIPE_TOWER_END

; WIPE_START
M204 S8000
G1 X148.954 Y195.045 E-.05374
G1 X149.047 Y195.151 E-.05374
G1 X149.539 Y195.672 E-.27253
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.217 J0 P1  F60000
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S10000
G1 X194.166 Y92.171
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1500
M204 S50
G1 X194.166 Y89.671 E.08378
G1 X197.962 Y89.671 E.1272
G1 X197.962 Y98.466 E.29475
G1 X194.166 Y98.466 E.1272
G1 X194.166 Y95.966 E.08378
G1 X190.462 Y95.966 E.12413
M73 P51 R14
G1 X190.462 Y98.466 E.08378
G1 X186.166 Y98.466 E.14396
G1 X186.166 Y89.671 E.29475
G1 X190.462 Y89.671 E.14396
G1 X190.462 Y92.171 E.08378
G1 X194.106 Y92.171 E.12212
; COOLING_NODE: 0
M204 S250
G1 X193.774 Y91.778 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X193.774 Y89.278 E.0776
G1 X198.354 Y89.278 E.14217
G1 X198.354 Y98.858 E.29737
G1 X193.774 Y98.858 E.14217
G1 X193.774 Y96.358 E.0776
G1 X190.854 Y96.358 E.09064
G1 X190.854 Y98.858 E.0776
G1 X185.774 Y98.858 E.15769
G1 X185.774 Y89.278 E.29737
G1 X190.854 Y89.278 E.15769
G1 X190.854 Y91.778 E.0776
G1 X193.714 Y91.778 E.08878
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X193.738 Y90.779 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.096 J-1.213 P1  F60000
G1 X176.166 Y92.171 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3000
M204 S50
G1 X176.166 Y89.671 E.08378
G1 X179.962 Y89.671 E.1272
G1 X179.962 Y98.466 E.29475
G1 X162.666 Y98.466 E.57959
G1 X162.666 Y95.966 E.08378
G1 X158.962 Y95.966 E.12413
G1 X158.962 Y98.466 E.08378
G1 X155.166 Y98.466 E.1272
G1 X155.166 Y89.671 E.29475
G1 X172.462 Y89.671 E.57959
G1 X172.462 Y92.171 E.08378
G1 X176.106 Y92.171 E.12212
; COOLING_NODE: 0
M204 S250
G1 X175.774 Y91.778 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1957
M204 S50
G1 X175.774 Y89.278 E.0776
G1 X180.354 Y89.278 E.14217
G1 X180.354 Y98.858 E.29737
G1 X162.274 Y98.858 E.56122
G1 X162.274 Y96.358 E.0776
G1 X159.354 Y96.358 E.09064
G1 X159.354 Y98.858 E.0776
G1 X154.774 Y98.858 E.14217
G1 X154.774 Y89.278 E.29737
G1 X172.854 Y89.278 E.56122
G1 X172.854 Y91.778 E.0776
G1 X175.714 Y91.778 E.08878
; COOLING_NODE: 0
; WIPE_START
G1 F3000
M204 S8000
G1 X175.738 Y90.779 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.055 J-1.216 P1  F60000
G1 X145.166 Y92.171 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X145.166 Y89.671 E.08378
G1 X148.962 Y89.671 E.1272
G1 X148.962 Y98.466 E.29475
G1 X137.166 Y98.466 E.39528
G1 X137.166 Y89.671 E.29475
G1 X141.462 Y89.671 E.14396
M73 P52 R14
G1 X141.462 Y92.171 E.08378
G1 X145.106 Y92.171 E.12212
; COOLING_NODE: 0
M204 S250
G1 X144.774 Y91.778 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X144.774 Y89.278 E.0776
G1 X149.354 Y89.278 E.14217
G1 X149.354 Y98.858 E.29737
G1 X136.774 Y98.858 E.39049
G1 X136.774 Y89.278 E.29737
G1 X141.854 Y89.278 E.15769
G1 X141.854 Y91.778 E.0776
G1 X144.714 Y91.778 E.08878
; WIPE_START
M204 S8000
G1 X144.738 Y90.779 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.872 J-.849 P1  F60000
G1 X140.386 Y95.246 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.470827
G1 F17527.185
M204 S8000
G1 X140.696 Y95.27 E.01097
; LINE_WIDTH: 0.42272
G1 F19747.235
G1 X141.007 Y95.294 E.00973
; LINE_WIDTH: 0.353891
G1 F21000
G1 X141.317 Y95.318 E.00797
G2 X145.734 Y95.301 I1.997 J-54.85 E.11311
M204 S10000
G1 X146.171 Y94.793 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G3 X145.31 Y94.961 I-.811 J-1.864 E.02962
G1 X141.317 Y94.961 E.13382
G3 X139.956 Y94.575 I-.018 J-2.527 E.04803
G1 X139.956 Y95.676 E.03688
G1 X146.171 Y95.676 E.20825
G1 X146.171 Y94.853 E.02758
M204 S10000
G1 X146.578 Y94.123 F60000
G1 F18424.351
M204 S8000
G3 X145.31 Y94.554 I-1.361 J-1.924 E.04549
G1 X141.317 Y94.554 E.13382
G3 X139.549 Y93.662 I-.009 J-2.18 E.06887
G1 X139.549 Y96.083 E.08111
G1 X146.578 Y96.083 E.23553
G1 X146.578 Y94.183 E.06365
M204 S10000
G1 X146.984 Y93.061 F60000
; LINE_WIDTH: 0.447112
G1 F18555.575
M204 S8000
G3 X145.31 Y94.147 I-1.675 J-.75 E.07019
G1 X141.317 Y94.147 E.13287
G3 X139.521 Y92.63 I.052 J-1.883 E.08446
G3 X139.501 Y91.631 I20.453 J-.905 E.03326
G1 X139.126 Y91.631 E.01248
G3 X139.142 Y96.49 I-729.634 J4.838 E.16167
G1 X146.985 Y96.49 E.26096
G2 X146.985 Y93.121 I-1520.331 J-1.341 E.11209
M204 S10000
G1 X147.33 Y91.568 F60000
; LINE_WIDTH: 0.57584
G1 F14073.415
M204 S8000
G1 X147.33 Y91.302 E.01167
G1 X146.798 Y91.302 E.02334
G3 X146.782 Y92.573 I-10.376 J.506 E.05579
; LINE_WIDTH: 0.56524
G1 F14359.014
G1 X146.725 Y92.681 E.00522
; LINE_WIDTH: 0.51914
G1 F15749.024
G1 X146.669 Y92.788 E.00476
; LINE_WIDTH: 0.450089
G1 F18419.888
G3 X145.31 Y93.74 I-1.437 J-.606 E.05861
G1 X141.317 Y93.74 E.13385
G3 X139.892 Y92.315 I.041 J-1.466 E.07445
G1 X139.892 Y91.24 E.03604
G1 X138.735 Y91.24 E.03878
G1 X138.735 Y96.897 E.18961
G1 X147.392 Y96.897 E.29017
G1 X147.392 Y93.061 E.12857
; LINE_WIDTH: 0.47304
G1 F17436.996
G1 X147.369 Y92.914 E.00526
; LINE_WIDTH: 0.51914
G1 F15749.024
G1 X147.346 Y92.767 E.00583
; LINE_WIDTH: 0.579511
G1 F13977.136
G3 X147.329 Y91.628 I3.477 J-.621 E.05053
M204 S10000
G1 X147.799 Y91.568 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X147.799 Y90.833 E.02465
G1 X146.328 Y90.833 E.0493
G1 X146.328 Y92.315 E.04967
G3 X145.31 Y93.333 I-1.018 J0 E.05357
G1 X141.317 Y93.333 E.13382
G3 X140.299 Y92.315 I.029 J-1.047 E.05317
G1 X140.299 Y90.833 E.04967
G1 X138.328 Y90.833 E.06606
G1 X138.328 Y97.304 E.21685
G1 X147.799 Y97.304 E.31738
G1 X147.799 Y91.628 E.19019
M204 S10000
G1 X148.206 Y91.568 F60000
G1 F18424.351
M204 S8000
G1 X148.206 Y90.426 E.03829
G1 X145.921 Y90.426 E.07658
G1 X145.921 Y92.315 E.06331
G3 X145.31 Y92.926 I-.726 J-.116 E.03093
G1 X141.317 Y92.926 E.13382
G3 X140.716 Y92.421 I.02 J-.634 E.02838
G3 X140.706 Y90.426 I65.427 J-1.299 E.06685
G1 X137.921 Y90.426 E.09334
G1 X137.921 Y97.711 E.24413
G1 X148.206 Y97.711 E.34466
G1 X148.206 Y91.628 E.20383
M204 S10000
G1 X148.614 Y91.568 F60000
G1 F18424.351
M204 S8000
G1 X148.614 Y90.019 E.05193
G1 X145.514 Y90.019 E.10386
G1 X145.514 Y92.315 E.07695
G3 X145.31 Y92.519 I-.204 J0 E.01071
G1 X141.317 Y92.519 E.13382
G3 X141.114 Y92.315 I0 J-.204 E.01071
G1 X141.114 Y90.019 E.07695
G1 X137.514 Y90.019 E.12062
G1 X137.514 Y98.118 E.27141
G1 X148.614 Y98.118 E.37194
G1 X148.614 Y91.628 E.21747
; WIPE_START
G1 X148.614 Y92.628 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.026 J1.217 P1  F60000
G1 X158.333 Y92.838 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.352667
G1 F21000
M204 S8000
G3 X162.81 Y92.818 I2.481 J55.589 E.11419
; LINE_WIDTH: 0.37556
G1 X163.168 Y92.842 E.00981
; LINE_WIDTH: 0.42556
G1 F19600.67
G1 X163.526 Y92.865 E.01129
M204 S10000
G1 X163.586 Y92.868 F60000
; LINE_WIDTH: 0.450037
G1 F18422.236
M204 S8000
G3 X165.797 Y95.269 I-.764 J2.922 E.11554
G1 X171.542 Y95.268 E.19255
G3 X169.331 Y92.868 I.764 J-2.922 E.11554
G1 X163.646 Y92.868 E.19054
M204 S10000
G1 X165.151 Y93.275 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G3 X166.124 Y94.862 I-2.592 J2.682 E.06304
G1 X169.977 Y94.862 E.12911
G3 X169.004 Y93.275 I2.592 J-2.682 E.06304
G1 X165.211 Y93.275 E.1271
M204 S10000
G1 X166.021 Y93.682 F60000
G1 F18424.351
M204 S8000
G3 X166.412 Y94.455 I-1.827 J1.412 E.02919
G1 X169.107 Y94.455 E.0903
G3 X168.715 Y93.682 I1.827 J-1.412 E.02919
G1 X166.081 Y93.682 E.08829
M204 S10000
G1 X166.686 Y94.068 F60000
; LINE_WIDTH: 0.40814
G1 F20535.567
M204 S8000
G1 X168.382 Y94.068 E.051
M204 S10000
G1 X169.689 Y92.461 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X157.956 Y92.461 E.39315
G1 X157.956 Y93.344 E.02959
G3 X158.817 Y93.176 I.811 J1.864 E.02962
G1 X162.81 Y93.176 E.13382
G3 X165.439 Y95.676 I-.026 J2.659 E.13376
G1 X177.171 Y95.676 E.39315
G1 X177.171 Y94.793 E.02959
G3 X176.311 Y94.961 I-.811 J-1.864 E.02962
G1 X172.317 Y94.961 E.13382
G3 X169.696 Y92.521 I.024 J-2.653 E.13173
M204 S10000
G1 X170.078 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.078 Y92.054 E.00875
G1 X157.549 Y92.054 E.41984
G1 X157.549 Y94.014 E.06566
G3 X158.817 Y93.583 I1.361 J1.924 E.04549
G1 X162.81 Y93.583 E.13382
G3 X165.049 Y96.083 I-.036 J2.285 E.1263
G1 X177.578 Y96.083 E.41984
G1 X177.578 Y94.123 E.06566
G3 X176.311 Y94.554 I-1.361 J-1.924 E.04549
G1 X172.317 Y94.554 E.13382
G3 X170.085 Y92.375 I.027 J-2.26 E.11536
M204 S10000
G1 X170.485 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.485 Y91.647 E.02239
G1 X157.142 Y91.647 E.44712
G2 X157.143 Y95.076 I1540.835 J1.341 E.1149
G3 X158.817 Y93.99 I1.675 J.75 E.07069
G1 X162.81 Y93.99 E.13382
G3 X164.642 Y95.822 I-.026 J1.858 E.09606
G1 X164.642 Y96.49 E.02239
G1 X177.985 Y96.49 E.44712
G2 X177.984 Y93.061 I-1540.839 J-1.341 E.1149
G3 X176.311 Y94.147 I-1.675 J-.75 E.07069
G1 X172.317 Y94.147 E.13382
G3 X170.492 Y92.375 I.021 J-1.847 E.09402
M204 S10000
G1 X170.892 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.892 Y91.24 E.03603
G1 X156.735 Y91.24 E.4744
G1 X156.735 Y95.076 E.12854
; LINE_WIDTH: 0.470827
G1 F17527.185
G1 X156.756 Y95.324 E.00879
; LINE_WIDTH: 0.5125
G1 F15971.72
G1 X156.777 Y95.573 E.00965
; LINE_WIDTH: 0.573158
G1 F14144.599
G3 X156.798 Y96.835 I-7.519 J.755 E.05513
G1 X157.33 Y96.835 E.02323
G1 X157.33 Y95.822 E.04421
; LINE_WIDTH: 0.554174
G1 F14669.832
G1 X157.392 Y95.628 E.00854
; LINE_WIDTH: 0.5125
G1 F15971.72
G1 X157.454 Y95.435 E.00785
; LINE_WIDTH: 0.450146
G1 F18417.296
G3 X158.817 Y94.397 I1.419 J.449 E.06121
G1 X162.81 Y94.397 E.13387
G3 X164.235 Y95.822 I-.02 J1.445 E.07474
G1 X164.235 Y96.897 E.03605
G1 X178.392 Y96.897 E.47458
G1 X178.392 Y93.061 E.12859
; LINE_WIDTH: 0.47304
G1 F17436.996
G1 X178.369 Y92.914 E.00526
; LINE_WIDTH: 0.51914
G1 F15749.024
G1 X178.346 Y92.767 E.00583
; LINE_WIDTH: 0.577227
G1 F14036.88
G3 X178.33 Y91.302 I21.844 J-.977 E.06445
G1 X177.798 Y91.302 E.0234
G3 X177.782 Y92.573 I-10.376 J.506 E.05594
; LINE_WIDTH: 0.56524
G1 F14359.014
G1 X177.725 Y92.681 E.00522
; LINE_WIDTH: 0.51914
G1 F15749.024
G1 X177.669 Y92.788 E.00476
; LINE_WIDTH: 0.450343
G1 F18408.386
G3 X176.311 Y93.74 I-1.437 J-.605 E.05865
G1 X172.317 Y93.74 E.13393
G3 X170.9 Y92.375 I.015 J-1.435 E.07274
M204 S10000
G1 X171.299 Y92.315 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X171.299 Y90.833 E.04967
G1 X156.328 Y90.833 E.50168
G1 X156.328 Y97.304 E.21685
G1 X157.799 Y97.304 E.0493
G1 X157.799 Y95.822 E.04967
G3 X158.817 Y94.804 I1.018 J0 E.05357
G1 X162.81 Y94.804 E.13382
G3 X163.828 Y95.822 I-.018 J1.036 E.05332
G1 X163.828 Y97.304 E.04967
G1 X178.799 Y97.304 E.50168
G1 X178.799 Y90.833 E.21685
G1 X177.328 Y90.833 E.0493
G1 X177.328 Y92.315 E.04967
G3 X176.311 Y93.333 I-1.018 J0 E.05357
G1 X172.317 Y93.333 E.13382
G3 X171.312 Y92.374 I.012 J-1.019 E.05122
M204 S10000
G1 X171.707 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X171.707 Y90.426 E.06331
G1 X155.921 Y90.426 E.52896
G1 X155.921 Y97.711 E.24413
G1 X158.206 Y97.711 E.07658
G1 X158.206 Y95.822 E.06331
G3 X158.817 Y95.211 I.726 J.116 E.03093
G1 X162.81 Y95.211 E.13382
G3 X163.421 Y95.822 I0 J.611 E.03214
G1 X163.421 Y97.711 E.06331
G1 X179.207 Y97.711 E.52896
G1 X179.207 Y90.426 E.24413
G1 X176.921 Y90.426 E.07658
G1 X176.921 Y92.315 E.06331
G3 X176.311 Y92.926 I-.726 J-.116 E.03093
G1 X172.317 Y92.926 E.13382
G3 X171.714 Y92.375 I-.002 J-.604 E.03007
M204 S10000
G1 X172.114 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X172.114 Y90.019 E.07695
G1 X155.514 Y90.019 E.55624
G1 X155.514 Y98.118 E.27141
G1 X158.614 Y98.118 E.10386
G1 X158.614 Y95.822 E.07695
G3 X158.817 Y95.618 I.204 J0 E.01071
G1 X162.81 Y95.618 E.13382
G3 X163.014 Y95.822 I0 J.204 E.01071
G1 X163.014 Y98.118 E.07695
G1 X179.614 Y98.118 E.55624
G1 X179.614 Y90.019 E.27141
G1 X176.514 Y90.019 E.10386
G1 X176.514 Y92.315 E.07695
G3 X176.311 Y92.519 I-.203 J0 E.01071
G1 X172.317 Y92.519 E.13382
G3 X172.138 Y92.37 I-.015 J-.164 E.00867
M204 S10000
G1 X171.542 Y95.268 F60000
; LINE_WIDTH: 0.42556
G1 F19600.67
M204 S8000
G1 X171.93 Y95.293 E.01223
; LINE_WIDTH: 0.3543
G1 F21000
G1 X172.317 Y95.318 E.00995
G2 X176.734 Y95.301 I1.997 J-54.849 E.11326
; WIPE_START
G1 X175.734 Y95.305 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.024 J1.217 P1  F60000
G1 X194.574 Y95.68 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.570119
G1 F14226.143
M204 S8000
G1 X194.574 Y96.207 E.02288
G1 X197.554 Y96.207 E.1293
G1 X197.554 Y95.68 E.02288
G1 X194.634 Y95.68 E.1267
M204 S10000
G1 X194.574 Y92.457 F60000
; LINE_WIDTH: 0.570114
G1 F14226.269
M204 S8000
G1 X197.554 Y92.457 E.1293
G1 X197.554 Y91.93 E.02288
G1 X194.574 Y91.93 E.1293
G1 X194.574 Y92.397 E.02028
M204 S10000
G1 X188.638 Y93.928 F60000
; LINE_WIDTH: 0.62778
G1 F12823.583
M204 S8000
G1 X188.638 Y94.149 E.01067
M204 S10000
G1 X188.126 Y96.506 F60000
; LINE_WIDTH: 0.435767
G1 F19091.412
M204 S8000
G1 X188.501 Y96.506 E.01213
G3 X188.628 Y95.113 I3.963 J-.342 E.04546
G1 X188.996 Y94.553 E.02168
G1 X189.134 Y94.494 E.00486
G1 X189.134 Y93.643 E.02752
G1 X188.996 Y93.584 E.00486
G3 X188.501 Y91.818 I1.65 J-1.414 E.06121
G1 X188.501 Y91.631 E.00606
G1 X188.126 Y91.631 E.01213
G3 X188.126 Y96.446 I-180.756 J2.408 E.15572
M204 S10000
G1 X187.735 Y96.897 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X188.892 Y96.897 E.03877
G3 X189.003 Y95.271 I4.097 J-.538 E.05499
G1 X189.29 Y94.835 E.01747
G1 X189.541 Y94.728 E.00917
G1 X189.541 Y93.409 E.04417
G1 X189.29 Y93.302 E.00917
G3 X188.892 Y91.818 I1.382 J-1.165 E.05316
G1 X188.892 Y91.24 E.01939
G1 X187.735 Y91.24 E.03877
G1 X187.735 Y96.837 E.18756
M204 S10000
G1 X187.328 Y97.304 F60000
G1 F18424.351
M204 S8000
G1 X189.299 Y97.304 E.06606
G1 X189.299 Y95.822 E.04967
G3 X189.948 Y94.961 I.874 J-.016 E.03892
G1 X189.948 Y93.176 E.05983
G3 X189.299 Y92.315 I.225 J-.845 E.03892
G1 X189.299 Y90.833 E.04967
G1 X187.328 Y90.833 E.06606
G1 X187.328 Y97.244 E.21484
M204 S10000
G1 X186.921 Y97.711 F60000
G1 F18424.351
M204 S8000
G1 X189.707 Y97.711 E.09334
G1 X189.707 Y95.822 E.06331
G3 X189.877 Y95.399 I.611 J0 E.01566
G1 X190.355 Y95.211 E.01723
G1 X190.355 Y92.926 E.07658
G1 X189.877 Y92.738 E.01723
G1 X189.716 Y92.421 E.01193
G3 X189.707 Y90.426 I65.427 J-1.299 E.06685
G1 X186.921 Y90.426 E.09334
G1 X186.921 Y97.651 E.24212
M204 S10000
G1 X186.514 Y98.118 F60000
G1 F18424.351
M204 S8000
G1 X190.114 Y98.118 E.12062
G1 X190.114 Y95.822 E.07695
G3 X190.317 Y95.618 I.204 J0 E.01071
G1 X191.002 Y95.618 E.02295
G3 X190.763 Y95.295 I.271 J-.451 E.01385
G1 X190.763 Y92.842 E.08217
G3 X191.002 Y92.519 I.51 J.127 E.01385
G1 X190.317 Y92.519 E.02295
G3 X190.114 Y92.315 I0 J-.204 E.01071
G1 X190.114 Y90.019 E.07695
G1 X186.514 Y90.019 E.12062
G1 X186.514 Y98.058 E.2694
; WIPE_START
G1 X186.514 Y97.058 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.034 J1.216 P1  F60000
G1 X197.57 Y97.367 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F12000
M204 S8000
G1 X197.57 Y96.659 E.02196
G1 X194.558 Y96.659 E.09348
G1 X194.558 Y98.074 E.04393
G1 X197.57 Y98.074 E.09348
G1 X197.57 Y97.427 E.0201
M204 S10000
G1 X197.122 Y97.367 F60000
; LINE_WIDTH: 0.56197
G1 F12000
M204 S8000
G1 X197.122 Y97.107 E.01109
G1 X195.006 Y97.107 E.0904
G1 X195.006 Y97.626 E.02218
G1 X197.122 Y97.626 E.0904
G1 X197.122 Y97.427 E.00853
M204 S10000
G1 X197.57 Y94.069 F60000
; LINE_WIDTH: 0.41999
G1 F12000
M204 S8000
G1 X197.57 Y92.909 E.03599
G1 X191.166 Y92.909 E.19878
G1 X191.154 Y92.928 E.00069
G1 X191.154 Y95.216 E.07102
G1 X191.174 Y95.228 E.00069
G1 X197.57 Y95.228 E.19853
G1 X197.57 Y94.129 E.03413
M204 S10000
G1 X197.193 Y94.069 F60000
G1 F12000
M204 S8000
G1 X197.193 Y93.286 E.02428
G1 X191.532 Y93.286 E.17572
G1 X191.532 Y94.851 E.04856
G1 X197.193 Y94.851 E.17572
G1 X197.193 Y94.129 E.02242
M204 S10000
G1 X196.816 Y94.069 F60000
G1 F12000
M204 S8000
G1 X196.816 Y93.663 E.01258
G1 X191.909 Y93.663 E.15231
G1 X191.909 Y94.474 E.02515
G1 X196.816 Y94.474 E.15231
G1 X196.816 Y94.129 E.01072
M204 S10000
G1 X192.314 Y94.068 F60000
; Slow Down Start
; LINE_WIDTH: 0.47618
G1 F3000;_EXTRUDE_SET_SPEED
M204 S8000
G1 X196.35 Y94.069 E.14396
; Slow Down End
M204 S10000
G1 X197.57 Y90.77 F60000
; LINE_WIDTH: 0.41999
G1 F12000
M204 S8000
G1 X197.57 Y90.063 E.02197
G1 X194.558 Y90.063 E.09348
G1 X194.558 Y91.478 E.04393
G1 X197.57 Y91.478 E.09348
G1 X197.57 Y90.83 E.0201
M204 S10000
G1 X197.122 Y90.77 F60000
; LINE_WIDTH: 0.56204
G1 F12000
M204 S8000
G1 X197.122 Y90.511 E.01109
G1 X195.006 Y90.511 E.0904
G1 X195.006 Y91.03 E.02218
G1 X197.122 Y91.03 E.0904
G1 X197.122 Y90.83 E.00853
; WIPE_START
G1 X197.122 Y91.03 E-.07584
G1 X196.321 Y91.03 E-.30416
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
    

    

    
        M9711 M0 E0 U266 V97 Z1.4 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

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
G1 X151.308 Y182.749
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
G1  X177.308 Y182.749  E2.0691 F7836
G1  Y184.249  E0.1194
G1  X151.308  E2.0691
M632 S2 M N
M204 S10000
G1  Y184.999 
G1  X176.808  F3000
G1  Y183.499 
G1  X151.808 
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


M620 O8
M620 S2A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X149.058 Y185.499



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
M73 E7

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
M73 P54 R13
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
M620 O8
M1002 gcode_claim_action : 0
M106 S255
M106 P2 S191

; filament start gcode
G1 X151.058 Y185.499 F60000
G1 Z1
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X154.058 Y185.499  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X149.558  F600
G1  X151.058  F240
G1  X151.558  F600
G1  Y185.999 
G1  X150.558 
G1  Y184.999 
G1  X152.058 
G1  Y186.499 
G1  X150.058 
G1  Y184.499 
G1  X154.058 Y185.499   F1782
G1 E0.4000 F1800
M400
M104 T0 S230 N0
M204 S8000
G1  X177.558  E0.8931 F1782
G1  Y186.249  E0.0285
G1  X151.058  E1.0072 F2025
G1  Y186.999  E0.0285
G1  X177.558  E1.0072 F2473
G1  Y187.749  E0.0285
G1  X151.058  E1.0072 F4725
G1  Y188.499  E0.0285
G1  X177.558  E1.0072 F4775
G1  Y189.249  E0.0285
M73 P55 R13
G1  X151.058  E1.0072
G1  Y189.999  E0.0285
G1  X177.558  E1.0072
G1  Y190.749  E0.0285
G1  X151.058  E1.0072
G1  Y191.499  E0.0285
G1  X177.558  E1.0072
G1  Y192.249  E0.0285
G1  X151.058  E1.0072
G1  Y192.999  E0.0285
G1  X177.558  E1.0072
G1  Y193.749  E0.0285
G1  X151.058  E1.0072
G1  Y194.499  E0.0285
G1  X177.558  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y196.249   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S8000
G1  X151.058  E1.0072
G1  Y195.249  E0.0380
G1  X177.558  E1.0072
G1  Y196.249  E0.0380
; WIPE_TOWER_END

; WIPE_START
G1 F12000
M204 S8000
G1 X176.558 Y196.249 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.217 J0 P1  F60000
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S10000
G1 X184.962 Y94.068
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1500
M204 S50
G1 X184.962 Y98.466 E.14887
G1 X181.166 Y98.466 E.12849
G1 X181.166 Y89.671 E.29773
G1 X184.962 Y89.671 E.12849
G1 X184.962 Y94.008 E.14683
; COOLING_NODE: 0
M204 S250
G1 X185.354 Y94.068 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X185.354 Y98.858 E.15019
G1 X180.774 Y98.858 E.1436
G1 X180.774 Y89.278 E.30037
G1 X185.354 Y89.278 E.1436
G1 X185.354 Y94.008 E.14831
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X185.354 Y95.008 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.036 J-1.216 P1  F60000
G1 X153.962 Y94.068 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X153.962 Y98.466 E.14887
G1 X150.166 Y98.466 E.12849
G1 X150.166 Y89.671 E.29773
G1 X153.962 Y89.671 E.12849
G1 X153.962 Y94.008 E.14683
; COOLING_NODE: 0
M204 S250
G1 X154.354 Y94.068 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X154.354 Y98.858 E.15019
G1 X149.774 Y98.858 E.1436
G1 X149.774 Y89.278 E.30037
G1 X154.354 Y89.278 E.1436
G1 X154.354 Y94.008 E.14831
; WIPE_START
M204 S8000
G1 X154.354 Y95.008 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.685 J-1.006 P1  F60000
G1 X152.064 Y96.568 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F15000
M204 S8000
G1 X152.064 Y91.628 E.15291
M204 S10000
G1 X152.438 Y91.568 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X152.438 Y91.194 E.01175
G1 X151.689 Y91.194 E.02349
G1 X151.689 Y96.943 E.18026
G1 X152.438 Y96.943 E.02349
G1 X152.438 Y91.628 E.16663
M204 S10000
G1 X152.816 Y91.568 F60000
G1 F15000
M204 S8000
G1 X152.816 Y90.817 E.02357
G1 X151.312 Y90.817 E.04714
G1 X151.312 Y97.32 E.20391
G1 X152.816 Y97.32 E.04714
G1 X152.816 Y91.628 E.17846
M204 S10000
G1 X153.193 Y91.568 F60000
G1 F15000
M204 S8000
G1 X153.193 Y90.44 E.03539
G1 X150.935 Y90.44 E.07078
G1 X150.935 Y97.697 E.22755
G1 X153.193 Y97.697 E.07078
G1 X153.193 Y91.628 E.19028
M204 S10000
G1 X153.57 Y91.568 F60000
G1 F15000
M204 S8000
G1 X153.57 Y90.063 E.04721
G1 X150.558 Y90.063 E.09443
G1 X150.558 Y98.074 E.2512
G1 X153.57 Y98.074 E.09443
G1 X153.57 Y91.628 E.2021
; WIPE_START
G1 X153.57 Y92.628 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.161 J1.206 P1  F60000
G1 X183.064 Y96.568 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.41516
G1 F15000
M204 S8000
G1 X183.064 Y91.628 E.1529
M204 S10000
G1 X182.689 Y91.194 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X182.689 Y96.943 E.18026
G1 X183.438 Y96.943 E.02349
G1 X183.438 Y91.194 E.18026
G1 X182.749 Y91.194 E.02161
M204 S10000
G1 X182.312 Y90.817 F60000
G1 F15000
M204 S8000
G1 X182.312 Y97.32 E.20391
G1 X183.816 Y97.32 E.04714
G1 X183.816 Y90.817 E.20391
G1 X182.372 Y90.817 E.04526
M204 S10000
G1 X181.935 Y90.44 F60000
G1 F15000
M204 S8000
G1 X181.935 Y97.697 E.22755
G1 X184.193 Y97.697 E.07078
G1 X184.193 Y90.44 E.22755
G1 X181.995 Y90.44 E.0689
M204 S10000
G1 X181.558 Y90.063 F60000
G1 F15000
M204 S8000
G1 X181.558 Y98.074 E.2512
G1 X184.57 Y98.074 E.09443
G1 X184.57 Y90.063 E.2512
G1 X181.618 Y90.063 E.09255
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X182.618 Y90.063 E-.38
; WIPE_END
G1 E-.02 F1800
; layer num/total_layer_count: 6/14
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.4 I-.814 J-.905 P1  F60000
G1 X178.166 Y94.068 Z1.4
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1500
M204 S50
G1 X178.166 Y89.671 E.14887
G1 X187.962 Y89.671 E.33158
G1 X187.962 Y98.466 E.29773
G1 X178.166 Y98.466 E.33158
G1 X178.166 Y94.128 E.14683
; COOLING_NODE: 0
M204 S250
G1 X177.774 Y94.068 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X177.774 Y89.278 E.15019
G1 X188.354 Y89.278 E.33173
G1 X188.354 Y98.858 E.30037
G1 X177.774 Y98.858 E.33173
G1 X177.774 Y94.128 E.14831
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X177.774 Y93.128 E-.38
; WIPE_END
M73 P56 R13
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-.037 J-1.216 P1  F60000
G1 X147.166 Y94.068 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X147.166 Y89.671 E.14887
G1 X156.962 Y89.671 E.33158
G1 X156.962 Y98.466 E.29773
G1 X147.166 Y98.466 E.33158
G1 X147.166 Y94.128 E.14683
; COOLING_NODE: 0
M204 S250
G1 X146.774 Y94.068 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X146.774 Y89.278 E.15019
G1 X157.354 Y89.278 E.33173
G1 X157.354 Y98.858 E.30037
G1 X146.774 Y98.858 E.33173
G1 X146.774 Y94.128 E.14831
; WIPE_START
M204 S8000
G1 X146.774 Y93.128 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.128 J.458 P1  F60000
G1 X148.111 Y89.834 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42888
G1 F15000
M204 S8000
G1 X147.499 Y90.446 E.02776
G1 X147.499 Y90.992 E.01752
G1 X148.487 Y90.004 E.04484
G1 X149.033 Y90.004 E.01752
G1 X147.499 Y91.538 E.06961
G1 X147.499 Y92.083 E.01752
G1 X149.579 Y90.004 E.09438
G1 X150.125 Y90.004 E.01752
G1 X147.499 Y92.629 E.11916
G1 X147.499 Y93.175 E.01752
G1 X150.67 Y90.004 E.14393
G1 X151.216 Y90.004 E.01752
G1 X147.499 Y93.721 E.1687
G1 X147.499 Y94.267 E.01752
G1 X151.762 Y90.004 E.19347
G1 X152.308 Y90.004 E.01752
G1 X147.499 Y94.812 E.21825
G1 X147.499 Y95.358 E.01752
G1 X152.854 Y90.004 E.24302
G1 X153.399 Y90.004 E.01752
G1 X147.499 Y95.904 E.26779
G1 X147.499 Y96.45 E.01752
G1 X153.945 Y90.004 E.29257
G1 X154.491 Y90.004 E.01752
G1 X147.499 Y96.996 E.31734
G1 X147.499 Y97.542 E.01752
G1 X155.037 Y90.004 E.34211
G1 X155.583 Y90.004 E.01752
G1 X147.499 Y98.087 E.36689
G1 X147.499 Y98.133 E.00147
G1 X147.999 Y98.133 E.01605
G1 X156.129 Y90.004 E.36896
G1 X156.628 Y90.004 E.01604
G1 X156.628 Y90.05 E.00148
G1 X148.545 Y98.133 E.36687
G1 X149.091 Y98.133 E.01752
G1 X156.628 Y90.596 E.3421
G1 X156.628 Y91.141 E.01752
G1 X149.637 Y98.133 E.31733
G1 X150.183 Y98.133 E.01752
G1 X156.628 Y91.687 E.29255
G1 X156.628 Y92.233 E.01752
G1 X150.728 Y98.133 E.26778
G1 X151.274 Y98.133 E.01752
G1 X156.628 Y92.779 E.24301
G1 X156.628 Y93.325 E.01752
G1 X151.82 Y98.133 E.21823
G1 X152.366 Y98.133 E.01752
G1 X156.628 Y93.871 E.19346
G1 X156.628 Y94.416 E.01752
G1 X152.912 Y98.133 E.16869
G1 X153.458 Y98.133 E.01752
G1 X156.628 Y94.962 E.14391
G1 X156.628 Y95.508 E.01752
G1 X154.003 Y98.133 E.11914
G1 X154.549 Y98.133 E.01752
G1 X156.628 Y96.054 E.09437
G1 X156.628 Y96.6 E.01752
G1 X155.095 Y98.133 E.0696
G1 X155.641 Y98.133 E.01752
G1 X156.628 Y97.146 E.04482
G1 X156.628 Y97.691 E.01752
G1 X156.017 Y98.303 E.02775
; WIPE_START
G1 X156.628 Y97.691 E-.32859
G1 X156.628 Y97.556 E-.05142
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I.395 J1.151 P1  F60000
G1 X179.111 Y89.834 Z1.6
G1 Z1.2
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X178.499 Y90.446 E.02776
G1 X178.499 Y90.992 E.01752
G1 X179.487 Y90.004 E.04484
G1 X180.033 Y90.004 E.01752
G1 X178.499 Y91.537 E.06961
G1 X178.499 Y92.083 E.01752
G1 X180.579 Y90.004 E.09438
G1 X181.125 Y90.004 E.01752
G1 X178.499 Y92.629 E.11916
G1 X178.499 Y93.175 E.01752
G1 X181.67 Y90.004 E.14393
G1 X182.216 Y90.004 E.01752
G1 X178.499 Y93.721 E.1687
G1 X178.499 Y94.267 E.01752
G1 X182.762 Y90.004 E.19347
G1 X183.308 Y90.004 E.01752
G1 X178.499 Y94.812 E.21825
G1 X178.499 Y95.358 E.01752
G1 X183.854 Y90.004 E.24302
G1 X184.399 Y90.004 E.01752
G1 X178.499 Y95.904 E.26779
G1 X178.499 Y96.45 E.01752
G1 X184.945 Y90.004 E.29257
G1 X185.491 Y90.004 E.01752
G1 X178.499 Y96.996 E.31734
G1 X178.499 Y97.542 E.01752
G1 X186.037 Y90.004 E.34211
G1 X186.583 Y90.004 E.01752
G1 X178.499 Y98.087 E.36689
G1 X178.499 Y98.133 E.00147
G1 X178.999 Y98.133 E.01605
G1 X187.129 Y90.004 E.36896
G1 X187.628 Y90.004 E.01604
G1 X187.628 Y90.05 E.00148
G1 X179.545 Y98.133 E.36687
G1 X180.091 Y98.133 E.01752
G1 X187.628 Y90.596 E.3421
G1 X187.628 Y91.141 E.01752
G1 X180.637 Y98.133 E.31733
G1 X181.183 Y98.133 E.01752
G1 X187.628 Y91.687 E.29255
G1 X187.628 Y92.233 E.01752
G1 X181.728 Y98.133 E.26778
G1 X182.274 Y98.133 E.01752
G1 X187.628 Y92.779 E.24301
G1 X187.628 Y93.325 E.01752
G1 X182.82 Y98.133 E.21823
G1 X183.366 Y98.133 E.01752
G1 X187.628 Y93.871 E.19346
G1 X187.628 Y94.416 E.01752
G1 X183.912 Y98.133 E.16869
G1 X184.458 Y98.133 E.01752
G1 X187.628 Y94.962 E.14391
G1 X187.628 Y95.508 E.01752
G1 X185.003 Y98.133 E.11914
G1 X185.549 Y98.133 E.01752
G1 X187.628 Y96.054 E.09437
G1 X187.628 Y96.6 E.01752
G1 X186.095 Y98.133 E.0696
G1 X186.641 Y98.133 E.01752
G1 X187.628 Y97.146 E.04482
G1 X187.628 Y97.691 E.01752
G1 X187.017 Y98.303 E.02775
; WIPE_START
G1 X187.628 Y97.691 E-.32859
G1 X187.628 Y97.556 E-.05142
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U266 V97 Z1.6 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #8
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
M204 S10000
G1 X151.308 Y171.499
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
G1  X177.308 Y171.499  E2.0691 F6583
G1  Y172.999  E0.1194
G1  X151.308  E2.0691
M632 S0 M N
M204 S10000
G1  Y173.749 
G1  X176.808  F3000
G1  Y172.249 
G1  X151.808 
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


M620 O9
M620 S0A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4.2 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X179.558 Y183.249



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
M73 E6

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
M73 P58 R12
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
M620 O9
M1002 gcode_claim_action : 0
M106 S160.65
M106 P2 S191

; filament start gcode
G1 X177.558 Y183.249 F60000
G1 Z1.2
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X174.558 Y183.249  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X179.058  F600
G1  X177.558  F240
G1  X178.058  F600
G1  Y183.749 
G1  X177.058 
G1  Y182.749 
G1  X178.558 
G1  Y184.249 
G1  X176.558 
G1  Y182.249 
G1  X174.558 Y183.249   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X151.058  E0.8931 F1782
G1  Y182.499  E0.0285
G1  X177.558  E1.0072 F2025
G1  Y181.749  E0.0285
G1  X151.058  E1.0072 F2473
G1  Y180.999  E0.0285
G1  X177.558  E1.0072 F4725
G1  Y180.249  E0.0285
G1  X151.058  E1.0072 F4775
G1  Y179.499  E0.0285
G1  X177.558  E1.0072
G1  Y178.749  E0.0285
G1  X151.058  E1.0072
G1  Y177.999  E0.0285
G1  X177.558  E1.0072
G1  Y177.249  E0.0285
G1  X151.058  E1.0072
G1  Y176.499  E0.0285
G1  X177.558  E1.0072
G1  Y175.749  E0.0285
G1  X151.058  E1.0072
G1  Y174.999  E0.0285
G1  X177.558  E1.0072
G1  Y174.249  E0.0285
G1  X151.058  E1.0072
M632 S1 W
M400
M104 T1 S140 N0 ;Multi extruder pre heating
M633
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  X177.558 Y195.749   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X177.908 Y196.907  
M204 S8000
M73 P59 R12
G3  X175.130 Y198.826   I-3.470 J-2.054 E0.1324
G3  X172.777 Y197.439   I1.442 J-5.134 E0.1049
G2  X170.236 Y196.749   I-2.569 J4.438 E0.1012
G2  X158.190 Y196.753   I-5.928 J318.375 E0.4578
G2  X154.243 Y198.635   I0.501 J6.129 E0.1699
G3  X151.932 Y198.202   I-0.852 J-1.839 E0.0953
G3  X148.870 Y194.931   I16.406 J-18.427 E0.1705
G3  X149.704 Y191.976   I2.026 J-1.023 E0.1282
G2  X150.558 Y189.443   I-3.390 J-2.554 E0.1033
G2  X150.555 Y177.885   I-283.960 J-5.694 E0.4393
G2  X148.712 Y174.320   I-6.625 J1.166 E0.1549
G3  X149.047 Y172.347   I1.652 J-0.734 E0.0806
G3  X152.165 Y169.085   I19.448 J15.469 E0.1717
G3  X155.363 Y169.743   I1.278 J1.891 E0.1383
G2  X158.380 Y170.749   I3.023 J-4.037 E0.1230
G1  X164.308  E0.2253
G1  X165.558  E0.0475
G2  X171.182 Y170.659   I2.339 J-29.659 E0.2141
G2  X174.517 Y168.801   I-2.882 J-9.098 E0.1461
G3  X176.684 Y169.296   I0.711 J1.877 E0.0895
G3  X179.746 Y172.567   I-16.399 J18.421 E0.1705
G3  X178.912 Y175.522   I-2.026 J1.023 E0.1282
G2  X178.058 Y178.055   I3.390 J2.554 E0.1033
G1  Y181.999  E0.1499
G1 E-0.4000 F1800
M204 S10000
G1  Y184.499  F600
G1 E0.4000 F1800
M204 S8000
G2  X178.113 Y190.121   I34.504 J2.472 E0.2139 F5400
G2  X179.904 Y193.178   I6.530 J-1.771 E0.1363
G3  X179.623 Y195.088   I-1.648 J0.734 E0.0774
; WIPE_TOWER_END

; WIPE_START
G1 F15000
M204 S8000
G1 X179.661 Y195.045 E-.02221
G1 X179.746 Y194.931 E-.05374
G1 X179.821 Y194.812 E-.05374
G1 X179.887 Y194.686 E-.05372
G1 X179.942 Y194.556 E-.05373
G1 X179.987 Y194.422 E-.05374
G1 X180.022 Y194.285 E-.05374
G1 X180.038 Y194.193 E-.03538
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.217 J0 P1  F60000
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S10000
G1 X194.166 Y95.966
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1500
M204 S50
G1 X190.462 Y95.966 E.12413
G1 X190.462 Y98.466 E.08378
G1 X189.166 Y98.466 E.04343
G1 X189.166 Y89.671 E.29475
G1 X190.462 Y89.671 E.04343
G1 X190.462 Y92.171 E.08378
G1 X194.166 Y92.171 E.12413
G1 X194.166 Y89.671 E.08378
G1 X197.962 Y89.671 E.1272
G1 X197.962 Y98.466 E.29475
G1 X194.166 Y98.466 E.1272
G1 X194.166 Y96.026 E.08177
; COOLING_NODE: 0
M204 S250
G1 X193.774 Y96.358 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X190.854 Y96.358 E.09064
G1 X190.854 Y98.858 E.0776
G1 X188.774 Y98.858 E.06457
G1 X188.774 Y89.278 E.29737
G1 X190.854 Y89.278 E.06457
G1 X190.854 Y91.778 E.0776
G1 X193.774 Y91.778 E.09064
G1 X193.774 Y89.278 E.0776
G1 X198.354 Y89.278 E.14217
G1 X198.354 Y98.858 E.29737
G1 X193.774 Y98.858 E.14217
G1 X193.774 Y96.418 E.07574
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X192.774 Y96.398 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I.3 J-1.179 P1  F60000
G1 X176.166 Y92.171 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3000
M204 S50
G1 X176.166 Y89.671 E.08378
G1 X176.962 Y89.671 E.02667
G1 X176.962 Y98.466 E.29475
G1 X162.666 Y98.466 E.47906
G1 X162.666 Y95.966 E.08378
G1 X158.962 Y95.966 E.12413
G1 X158.962 Y98.466 E.08378
G1 X158.166 Y98.466 E.02667
G1 X158.166 Y89.671 E.29475
G1 X172.462 Y89.671 E.47906
G1 X172.462 Y92.171 E.08378
G1 X176.106 Y92.171 E.12212
; COOLING_NODE: 0
M204 S250
G1 X175.774 Y91.778 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1862
M204 S50
G1 X175.774 Y89.278 E.0776
G1 X177.354 Y89.278 E.04904
G1 X177.354 Y98.858 E.29737
G1 X162.274 Y98.858 E.4681
G1 X162.274 Y96.358 E.0776
G1 X159.354 Y96.358 E.09064
G1 X159.354 Y98.858 E.0776
G1 X157.774 Y98.858 E.04904
G1 X157.774 Y89.278 E.29737
G1 X172.854 Y89.278 E.4681
G1 X172.854 Y91.778 E.0776
G1 X175.714 Y91.778 E.08878
; COOLING_NODE: 0
; WIPE_START
G1 F3000
M204 S8000
G1 X175.738 Y90.779 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
M73 P60 R12
G3 Z1.6 I-.055 J-1.216 P1  F60000
G1 X145.166 Y92.171 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X145.166 Y89.671 E.08378
G1 X145.962 Y89.671 E.02667
G1 X145.962 Y98.466 E.29475
G1 X137.166 Y98.466 E.29475
G1 X137.166 Y89.671 E.29475
G1 X141.462 Y89.671 E.14396
G1 X141.462 Y92.171 E.08378
G1 X145.106 Y92.171 E.12212
; COOLING_NODE: 0
M204 S250
G1 X144.774 Y91.778 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X144.774 Y89.278 E.0776
G1 X146.354 Y89.278 E.04904
G1 X146.354 Y98.858 E.29737
G1 X136.774 Y98.858 E.29737
G1 X136.774 Y89.278 E.29737
G1 X141.854 Y89.278 E.15769
G1 X141.854 Y91.778 E.0776
G1 X144.714 Y91.778 E.08878
; WIPE_START
M204 S8000
G1 X144.738 Y90.779 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
M73 P60 R11
G3 Z1.6 I-1.081 J.56 P1  F60000
G1 X145.564 Y92.374 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F15000
M204 S8000
G1 X145.564 Y89.874 E.08001
; WIPE_START
G1 X145.564 Y90.874 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-.785 J-.93 P1  F60000
G1 X140.386 Y95.246 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.470827
G1 F17527.185
M204 S8000
G1 X140.696 Y95.27 E.01097
; LINE_WIDTH: 0.42272
G1 F19747.235
G1 X141.007 Y95.294 E.00973
; LINE_WIDTH: 0.354844
G1 F21000
G2 X142.754 Y95.318 I1.029 J-11.256 E.04491
M204 S10000
G1 X143.171 Y94.961 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X141.317 Y94.961 E.06213
G3 X139.956 Y94.575 I-.018 J-2.527 E.04803
G1 X139.956 Y95.676 E.03688
G1 X143.171 Y95.676 E.10772
G1 X143.171 Y95.021 E.02194
M204 S10000
G1 X143.578 Y94.554 F60000
G1 F18424.351
M204 S8000
G1 X141.317 Y94.554 E.07577
G3 X139.549 Y93.662 I-.009 J-2.18 E.06887
G1 X139.549 Y96.083 E.08111
G1 X143.578 Y96.083 E.135
G1 X143.578 Y94.614 E.04922
M204 S10000
G1 X143.985 Y94.147 F60000
; LINE_WIDTH: 0.445947
G1 F18609.169
M204 S8000
G1 X141.317 Y94.147 E.08852
G3 X139.521 Y92.63 I.052 J-1.883 E.08422
G3 X139.501 Y91.631 I20.453 J-.905 E.03316
G1 X139.126 Y91.631 E.01244
G3 X139.142 Y96.49 I-729.634 J4.838 E.16121
G1 X143.985 Y96.49 E.16067
G1 X143.985 Y94.207 E.07574
M204 S10000
G1 X144.392 Y93.74 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X141.317 Y93.74 E.10305
G3 X139.892 Y92.315 I.041 J-1.466 E.07444
G1 X139.892 Y91.24 E.03603
G1 X138.735 Y91.24 E.03877
G1 X138.735 Y96.897 E.18957
G1 X144.392 Y96.897 E.18957
G1 X144.392 Y93.8 E.10378
M204 S10000
G1 X144.799 Y93.419 F60000
G1 F18424.351
M204 S8000
G3 X144.634 Y93.333 I-.039 J-.126 E.00694
G1 X141.317 Y93.333 E.11116
G3 X140.299 Y92.315 I.029 J-1.047 E.05317
G1 X140.299 Y90.833 E.04967
G1 X138.328 Y90.833 E.06606
G1 X138.328 Y97.304 E.21685
G1 X144.799 Y97.304 E.21685
G1 X144.799 Y93.479 E.12816
M204 S10000
G1 X145.203 Y93.132 F60000
G1 F18424.351
M204 S8000
G1 X144.877 Y93.035 E.0114
G1 X144.817 Y92.926 E.00418
G1 X141.317 Y92.926 E.11728
G3 X140.716 Y92.421 I.02 J-.634 E.02838
G3 X140.706 Y90.426 I65.427 J-1.299 E.06685
G1 X137.921 Y90.426 E.09334
G1 X137.921 Y97.711 E.24413
G1 X145.206 Y97.711 E.24413
G2 X145.204 Y93.192 I-342.619 J-2.039 E.15142
M204 S10000
G1 X145.614 Y93.132 F60000
G1 F18424.351
M204 S8000
G1 X145.614 Y92.722 E.01375
G1 X145.095 Y92.691 E.01742
G1 X145 Y92.519 E.00658
G1 X141.317 Y92.519 E.1234
G3 X141.114 Y92.315 I0 J-.204 E.01071
G1 X141.114 Y90.019 E.07695
G1 X137.514 Y90.019 E.12062
G1 X137.514 Y98.118 E.27141
G1 X145.614 Y98.118 E.27141
G1 X145.614 Y93.192 E.16506
; WIPE_START
G1 X145.614 Y94.192 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-.147 J1.208 P1  F60000
G1 X158.564 Y95.763 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F15000
M204 S8000
G1 X158.564 Y98.263 E.08001
; WIPE_START
G1 X158.564 Y97.263 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I.185 J1.203 P1  F60000
G1 X171.542 Y95.268 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.42556
G1 F19600.67
M204 S8000
G1 X171.93 Y95.293 E.01223
; LINE_WIDTH: 0.35588
G1 F21000
G2 X173.754 Y95.318 I1.106 J-14.126 E.04703
M204 S10000
G1 X172.114 Y92.315 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X172.114 Y90.019 E.07695
G1 X158.514 Y90.019 E.45571
G1 X158.514 Y95.415 E.18082
G1 X159.033 Y95.446 E.01742
G1 X159.128 Y95.618 E.00658
G1 X162.81 Y95.618 E.1234
G3 X163.014 Y95.822 I0 J.204 E.01071
G1 X163.014 Y98.118 E.07695
G1 X176.614 Y98.118 E.45571
G1 X176.614 Y92.722 E.18082
G1 X176.095 Y92.691 E.01742
G1 X176 Y92.519 E.00658
G1 X172.317 Y92.519 E.1234
G3 X172.138 Y92.37 I-.015 J-.164 E.00867
M204 S10000
G1 X171.707 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X171.707 Y90.426 E.06331
G1 X158.921 Y90.426 E.42843
G2 X158.924 Y95.004 I347.767 J2.039 E.15343
G1 X159.25 Y95.102 E.0114
G1 X159.311 Y95.211 E.00418
G1 X162.81 Y95.211 E.11728
G3 X163.421 Y95.822 I0 J.611 E.03214
G1 X163.421 Y97.711 E.06331
G1 X176.207 Y97.711 E.42843
G2 X176.203 Y93.132 I-347.767 J-2.039 E.15343
G1 X175.877 Y93.035 E.0114
G1 X175.817 Y92.926 E.00418
G1 X172.317 Y92.926 E.11728
G3 X171.714 Y92.375 I-.002 J-.604 E.03007
M204 S10000
G1 X171.299 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X171.299 Y90.833 E.04967
G1 X159.328 Y90.833 E.40115
G1 X159.328 Y94.717 E.13017
G3 X159.493 Y94.804 I.039 J.126 E.00694
G1 X162.81 Y94.804 E.11116
G3 X163.828 Y95.822 I-.018 J1.036 E.05332
G1 X163.828 Y97.304 E.04967
G1 X175.799 Y97.304 E.40115
G1 X175.799 Y93.419 E.13017
G3 X175.634 Y93.333 I-.039 J-.126 E.00694
G1 X172.317 Y93.333 E.11116
G3 X171.312 Y92.374 I.012 J-1.019 E.05122
M204 S10000
G1 X170.892 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.892 Y91.24 E.03603
G1 X159.735 Y91.24 E.37387
G1 X159.735 Y94.397 E.10579
G1 X162.81 Y94.397 E.10305
G3 X164.235 Y95.822 I-.02 J1.445 E.07471
G1 X164.235 Y96.897 E.03603
G1 X175.392 Y96.897 E.37387
G1 X175.392 Y93.74 E.10579
G1 X172.317 Y93.74 E.10305
G3 X170.9 Y92.375 I.015 J-1.435 E.07267
M204 S10000
G1 X170.485 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.485 Y91.647 E.02239
G1 X160.142 Y91.647 E.34659
G1 X160.142 Y93.99 E.07851
G1 X162.81 Y93.99 E.08941
G3 X164.642 Y95.822 I-.026 J1.858 E.09606
G1 X164.642 Y96.49 E.02239
G1 X174.985 Y96.49 E.34659
G1 X174.985 Y94.147 E.07851
G1 X172.317 Y94.147 E.08941
G3 X170.492 Y92.375 I.021 J-1.847 E.09402
M204 S10000
G1 X170.078 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.078 Y92.054 E.00875
G1 X160.549 Y92.054 E.31931
G1 X160.549 Y93.583 E.05123
G1 X162.81 Y93.583 E.07577
G3 X165.049 Y96.083 I-.036 J2.285 E.1263
G1 X174.578 Y96.083 E.31931
G1 X174.578 Y94.554 E.05123
G1 X172.317 Y94.554 E.07577
G3 X170.085 Y92.375 I.027 J-2.26 E.11536
M204 S10000
G1 X169.689 Y92.461 F60000
G1 F18424.351
M204 S8000
G1 X160.956 Y92.461 E.29262
G1 X160.956 Y93.176 E.02395
G1 X162.81 Y93.176 E.06213
G3 X165.439 Y95.676 I-.026 J2.659 E.13376
G1 X174.171 Y95.676 E.29262
G1 X174.171 Y94.961 E.02395
G1 X172.317 Y94.961 E.06213
G3 X169.696 Y92.521 I.024 J-2.653 E.13173
M204 S10000
G1 X166.686 Y94.068 F60000
; LINE_WIDTH: 0.40814
G1 F20535.567
M204 S8000
G1 X168.382 Y94.068 E.051
M204 S10000
G1 X166.021 Y93.682 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G3 X166.412 Y94.455 I-1.827 J1.412 E.02919
G1 X169.107 Y94.455 E.0903
G3 X168.715 Y93.682 I1.827 J-1.412 E.02919
G1 X166.081 Y93.682 E.08829
M204 S10000
G1 X165.151 Y93.275 F60000
G1 F18424.351
M204 S8000
G3 X166.124 Y94.862 I-2.592 J2.682 E.06304
G1 X169.977 Y94.862 E.12911
G3 X169.004 Y93.275 I2.592 J-2.682 E.06304
G1 X165.211 Y93.275 E.1271
M204 S10000
G1 X163.586 Y92.868 F60000
; LINE_WIDTH: 0.450037
G1 F18422.236
M204 S8000
G3 X165.797 Y95.269 I-.764 J2.922 E.11554
G1 X171.542 Y95.268 E.19255
G3 X169.331 Y92.868 I.764 J-2.922 E.11554
G1 X163.646 Y92.868 E.19054
M204 S10000
G1 X161.314 Y92.818 F60000
; LINE_WIDTH: 0.35056
G1 F21000
M204 S8000
G1 X162.81 Y92.818 E.0379
; LINE_WIDTH: 0.37556
G1 X163.168 Y92.842 E.00981
; LINE_WIDTH: 0.42556
G1 F19600.67
G1 X163.526 Y92.865 E.01129
M204 S10000
G1 X176.564 Y92.374 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F15000
M204 S8000
G1 X176.564 Y89.874 E.08001
; WIPE_START
G1 X176.564 Y90.874 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-.319 J1.174 P1  F60000
G1 X194.558 Y95.763 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F12000
M204 S8000
G1 X194.558 Y98.074 E.07175
G1 X197.57 Y98.074 E.09348
G1 X197.57 Y90.063 E.24868
G1 X194.558 Y90.063 E.09348
G1 X194.558 Y92.374 E.07175
G1 X194.483 Y92.525 E.00523
G1 X194.369 Y92.563 E.0037
G1 X190.258 Y92.563 E.12761
; LINE_WIDTH: 0.437668
G1 X190.148 Y92.488 E.00433
; LINE_WIDTH: 0.486965
G1 X190.038 Y92.413 E.00487
G1 X190.036 Y90.096 E.08467
G1 X189.592 Y90.096 E.01624
G1 X189.592 Y92.374 E.08326
; LINE_WIDTH: 0.470488
G1 X189.575 Y92.818 E.01565
; LINE_WIDTH: 0.423631
G2 X189.558 Y94.874 I27.115 J1.25 E.06444
; LINE_WIDTH: 0.436823
G1 X189.575 Y95.318 E.01442
; LINE_WIDTH: 0.485945
G1 X189.592 Y95.763 E.01622
G1 X189.592 Y98.041 E.08307
G1 X190.036 Y98.041 E.01621
G1 X190.036 Y95.763 E.08307
; LINE_WIDTH: 0.470488
G1 X190.147 Y95.669 E.00513
; LINE_WIDTH: 0.420537
G1 X190.258 Y95.574 E.00453
G1 X194.369 Y95.574 E.1278
G1 X194.483 Y95.612 E.00371
G1 X194.531 Y95.709 E.00338
M204 S10000
G1 X197.193 Y91.568 F60000
; LINE_WIDTH: 0.41999
G1 F12000
M204 S8000
G1 X197.193 Y90.44 E.03504
G1 X194.935 Y90.44 E.07008
G1 X194.935 Y92.374 E.06004
G1 X194.868 Y92.64 E.00852
G1 X194.709 Y92.827 E.00762
G3 X194.369 Y92.94 I-.339 J-.452 E.0113
G1 X190.258 Y92.94 E.12761
G1 X189.935 Y92.668 E.0131
G1 X189.935 Y95.52 E.08853
G1 X190.258 Y95.197 E.01419
G1 X194.369 Y95.197 E.12761
G3 X194.868 Y95.497 I-.022 J.603 E.01885
G1 X194.935 Y95.763 E.00852
G1 X194.935 Y97.697 E.06004
G1 X197.193 Y97.697 E.07008
G1 X197.193 Y91.628 E.18838
M204 S10000
G1 X196.816 Y91.568 F60000
G1 F12000
M204 S8000
G1 X196.816 Y90.817 E.02333
G1 X195.312 Y90.817 E.04667
G1 X195.312 Y92.374 E.04834
G3 X195.201 Y92.818 I-.943 J0 E.01434
G1 X194.935 Y93.128 E.0127
G1 X194.7 Y93.257 E.0083
G1 X194.369 Y93.317 E.01044
G1 X190.312 Y93.317 E.12594
G1 X190.312 Y94.82 E.04667
G1 X194.369 Y94.82 E.12594
G1 X194.7 Y94.88 E.01044
G1 X194.935 Y95.009 E.0083
G1 X195.201 Y95.319 E.0127
G1 X195.312 Y95.763 E.01419
G1 X195.312 Y97.32 E.04834
G1 X196.816 Y97.32 E.04667
G1 X196.816 Y91.628 E.17667
M204 S10000
G1 X196.438 Y91.568 F60000
G1 F12000
M204 S8000
G1 X196.438 Y91.194 E.01163
G1 X195.689 Y91.194 E.02326
G1 X195.689 Y92.374 E.03664
G1 X195.669 Y92.602 E.0071
G1 X195.534 Y92.995 E.0129
G1 X195.161 Y93.43 E.01777
G1 X194.833 Y93.61 E.01162
G1 X194.369 Y93.694 E.01462
G1 X190.689 Y93.694 E.11424
G1 X190.689 Y94.443 E.02326
G1 X194.369 Y94.443 E.11424
G1 X194.833 Y94.527 E.01462
G1 X195.161 Y94.707 E.01162
G1 X195.534 Y95.142 E.01777
G1 X195.689 Y95.763 E.01987
G1 X195.689 Y96.943 E.03664
G1 X196.438 Y96.943 E.02326
G1 X196.438 Y91.628 E.16497
M204 S10000
G1 X196.051 Y92.669 F60000
; LINE_WIDTH: 0.429143
G1 F12000
M204 S8000
G1 X196.063 Y91.628 E.03309
M204 S10000
G1 X196.051 Y92.669 F60000
; LINE_WIDTH: 0.420982
G1 F12000
M204 S8000
G1 X196.052 Y92.721 E.0016
G3 X196.064 Y95.763 I-293.703 J2.666 E.09468
G1 X195.867 Y94.964 E.0256
G1 X195.387 Y94.405 E.02291
G1 X194.965 Y94.174 E.01499
G1 X194.369 Y94.068 E.01883
G1 X194.965 Y93.963 E.01883
G1 X195.387 Y93.732 E.01499
G1 X195.867 Y93.173 E.02291
G1 X196.03 Y92.725 E.01482
M204 S10000
G1 X195.669 Y94.018 F60000
; LINE_WIDTH: 0.50824
G1 F12000
M204 S8000
G2 X195.667 Y94.119 I-.029 J.05 E.0092
M204 S10000
G1 X196.064 Y96.568 F60000
; LINE_WIDTH: 0.415179
G1 F12000
M204 S8000
G1 X196.064 Y95.823 E.02285
M204 S10000
G1 X191.064 Y94.068 F60000
; LINE_WIDTH: 0.41518
G1 F12000
M204 S8000
G1 X194.309 Y94.068 E.09946
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #9
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
; WIPE_START
M204 S8000
G1 X193.309 Y94.068 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.217 J0 P1  F60000
G1 X151.308 Y184.249
G1 Z1.2
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF0 NF1 ON2 NN0
M204 S8000
G1  X177.308 Y184.249  E2.0691 F7836
G1  Y185.749  E0.1194
G1  X151.308  E2.0691
; NOZZLE_CHANGE_END OF0 NF1 ON2 NN0
M400
M104 T0 S25 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S8000
G1 X152.308 Y185.749 E-1.9
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


M620 O10
M620 S1A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4.2 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X179.558 Y195.999



M620.10 A0 F498.898 L0 H0.4 T240 P220 S1



M620.10 A1 F498.898 L0 H0.4 T180 P150 S1



M620.11 P1 I0 B-1 E-14 F623.623



M620.15 P180
M620.15 C140
M620.11 O1 T18


M620.11 K1 I0 B-1 R10 F623.623


M620.15 C140

M628 S1


M620.11 S1 L0 I0 B-1 R10 D8 E-14 F623.623


M629


;M620.11 H0




T1 H-1
M73 E5

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

;VM109 S150

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F10.4167 A0.4 R2


M400

G387 Y320 J1 F10000
M73 P61 R11
G1 X183.06 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.2 F3000

M204 S8000


M621 S1A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y320 J1 F10000
G1 X183.06 F30000

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
M620 O10
M1002 gcode_claim_action : 0
M106 S58.65
M106 P2 S102
G1 X182.06 Y195.999 F600
M204 S1000
G1 Z1.2

; filament start gcode
M109 S145;
G17
G3 Z1.6 I0 J-1.217 P1
G1 X177.558 Y195.999 Z1.6
G1 Z1.2
G1 E2.2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S25
G1  X174.558 Y195.999  E0.1140 F1782
G1 E-0.4000 F1800
M204 S1000
G1  X179.058  F600
G1  X177.558  F240
G1  X178.058  F600
G1  Y196.499 
G1  X177.058 
G1  Y195.499 
G1  X178.558 
G1  Y196.999 
G1  X176.558 
G1  Y194.999 
G1  X174.558 Y195.999   F1782
G1 E0.4000 F1800
M400
M104 T1 S150 N0
M204 S25
G1  X151.058  E0.8931 F1782
G1  Y195.249  E0.0285
G1  X177.558  E1.0072 F2025
G1  Y194.499  E0.0285
G1  X151.058  E1.0072 F2473
G1  Y193.749  E0.0285
G1  X177.558  E1.0072 F4725
G1  Y192.999  E0.0285
G1  X151.058  E1.0072 F4775
G1  Y192.249  E0.0285
G1  X177.558  E1.0072
G1  Y191.499  E0.0285
G1  X151.058  E1.0072
G1  Y190.749  E0.0285
G1  X177.558  E1.0072
G1  Y189.999  E0.0285
M73 P62 R11
G1  X151.058  E1.0072
G1  Y189.249  E0.0285
G1  X177.558  E1.0072
G1  Y188.499  E0.0285
G1  X151.058  E1.0072
G1  Y187.749  E0.0285
G1  X177.558  E1.0072
G1  Y186.999  E0.0285
G1  X151.058  E1.0072
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
G1 X152.058 Y186.999 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I1.217 J0 P1  F600
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S1000
G1 X143.962 Y90.966
G1 Z1.2
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
M73 P63 R11
G1 X142.672 Y90.966 E.04322
G1 X142.672 Y89.671 E.04343
G1 X143.962 Y89.671 E.04322
G1 X143.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X144.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X142.28 Y91.358 E.06437
G1 X142.28 Y89.278 E.06457
G1 X144.354 Y89.278 E.06437
G1 X144.354 Y91.298 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X143.354 Y91.327 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I-.374 J1.158 P1  F600
G1 X161.462 Y97.171 Z1.6
G1 Z1.2
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X161.462 Y98.466 E.04343
G1 X160.172 Y98.466 E.04322
G1 X160.172 Y97.171 E.04343
G1 X161.402 Y97.171 E.04121
; COOLING_NODE: 0
G1 X161.854 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X161.854 Y98.858 E.06457
G1 X159.78 Y98.858 E.06437
G1 X159.78 Y96.778 E.06457
G1 X161.794 Y96.778 E.06251
; COOLING_NODE: 0
; WIPE_START
G1 X161.823 Y97.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I.56 J1.08 P1  F600
G1 X174.962 Y90.966 Z1.6
G1 Z1.2
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X173.672 Y90.966 E.04322
G1 X173.672 Y89.671 E.04343
G1 X174.962 Y89.671 E.04322
G1 X174.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X175.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X173.28 Y91.358 E.06437
G1 X173.28 Y89.278 E.06457
G1 X175.354 Y89.278 E.06437
M73 P63 R10
G1 X175.354 Y91.298 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X174.354 Y91.327 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I.024 J1.217 P1  F600
G1 X192.962 Y90.966 Z1.6
G1 Z1.2
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X191.672 Y90.966 E.04322
G1 X191.672 Y89.671 E.04343
G1 X192.962 Y89.671 E.04322
G1 X192.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X193.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X191.28 Y91.358 E.06437
G1 X191.28 Y89.278 E.06457
G1 X193.354 Y89.278 E.06437
G1 X193.354 Y91.298 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X192.354 Y91.327 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I-1.21 J.126 P1  F600
G1 X192.962 Y97.171 Z1.6
G1 Z1.2
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X192.962 Y98.466 E.04343
G1 X191.672 Y98.466 E.04322
G1 X191.672 Y97.171 E.04343
G1 X192.902 Y97.171 E.04121
; COOLING_NODE: 0
M73 P64 R10
G1 X193.354 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X193.354 Y98.858 E.06457
G1 X191.28 Y98.858 E.06437
G1 X191.28 Y96.778 E.06457
G1 X193.294 Y96.778 E.06251
M204 S1000
G1 X192.096 Y97.595
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48422
M204 S25
G1 X192.096 Y98.042 E.01626
G1 X192.538 Y98.042 E.01603
G1 X192.538 Y97.595 E.01626
G1 X192.156 Y97.595 E.01385
; WIPE_START
G1 X192.538 Y97.595 E-.14489
G1 X192.538 Y98.042 E-.17005
G1 X192.366 Y98.042 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I1.216 J-.044 P1  F600
G1 X192.096 Y90.542 Z1.6
G1 Z1.2
G1 E.6 F1800
G1 F600
M204 S25
G1 X192.538 Y90.542 E.01603
G1 X192.538 Y90.095 E.01626
G1 X192.096 Y90.095 E.01603
G1 X192.096 Y90.482 E.01408
; WIPE_START
G1 X192.096 Y90.095 E-.14725
G1 X192.538 Y90.095 E-.16769
G1 X192.538 Y90.266 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I-.018 J-1.217 P1  F600
G1 X174.096 Y90.542 Z1.6
G1 Z1.2
G1 E.6 F1800
G1 F600
M204 S25
G1 X174.538 Y90.542 E.01603
G1 X174.538 Y90.095 E.01626
G1 X174.096 Y90.095 E.01603
G1 X174.096 Y90.482 E.01408
; WIPE_START
G1 X174.096 Y90.095 E-.14725
G1 X174.538 Y90.095 E-.16769
G1 X174.538 Y90.266 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I-.581 J-1.07 P1  F600
G1 X161.038 Y97.595 Z1.6
G1 Z1.2
G1 E.6 F1800
G1 F600
M204 S25
G1 X160.596 Y97.595 E.01603
G1 X160.596 Y98.042 E.01626
G1 X161.038 Y98.042 E.01603
G1 X161.038 Y97.655 E.01408
; WIPE_START
G1 X161.038 Y98.042 E-.14725
G1 X160.596 Y98.042 E-.16769
G1 X160.596 Y97.871 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I.48 J-1.118 P1  F600
G1 X143.538 Y90.542 Z1.6
G1 Z1.2
G1 E.6 F1800
G1 F600
M204 S25
G1 X143.538 Y90.095 E.01626
G1 X143.096 Y90.095 E.01603
G1 X143.096 Y90.542 E.01626
G1 X143.478 Y90.542 E.01385
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 7/14
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
M106 S61.2
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S1000
G1 X143.962 Y90.966 Z1.4 F600
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
M204 S25
G1 X142.672 Y90.966 E.04322
G1 X142.672 Y89.671 E.04343
G1 X143.962 Y89.671 E.04322
G1 X143.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X144.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X142.28 Y91.358 E.06437
G1 X142.28 Y89.278 E.06457
G1 X144.354 Y89.278 E.06437
G1 X144.354 Y91.298 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X143.354 Y91.327 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I-.374 J1.158 P1  F600
G1 X161.462 Y97.171 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X161.462 Y98.466 E.04343
G1 X160.172 Y98.466 E.04322
G1 X160.172 Y97.171 E.04343
G1 X161.402 Y97.171 E.04121
; COOLING_NODE: 0
G1 X161.854 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X161.854 Y98.858 E.06457
G1 X159.78 Y98.858 E.06437
G1 X159.78 Y96.778 E.06457
G1 X161.794 Y96.778 E.06251
; COOLING_NODE: 0
; WIPE_START
G1 X161.823 Y97.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I.56 J1.08 P1  F600
M73 P65 R10
G1 X174.962 Y90.966 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X173.672 Y90.966 E.04322
G1 X173.672 Y89.671 E.04343
G1 X174.962 Y89.671 E.04322
G1 X174.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X175.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X173.28 Y91.358 E.06437
G1 X173.28 Y89.278 E.06457
G1 X175.354 Y89.278 E.06437
G1 X175.354 Y91.298 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X174.354 Y91.327 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I.024 J1.217 P1  F600
G1 X192.962 Y90.966 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X191.672 Y90.966 E.04322
G1 X191.672 Y89.671 E.04343
G1 X192.962 Y89.671 E.04322
G1 X192.962 Y90.906 E.04141
; COOLING_NODE: 0
G1 X193.354 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X191.28 Y91.358 E.06437
G1 X191.28 Y89.278 E.06457
G1 X193.354 Y89.278 E.06437
G1 X193.354 Y91.298 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X192.354 Y91.327 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I-1.21 J.126 P1  F600
G1 X192.962 Y97.171 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X192.962 Y98.466 E.04343
G1 X191.672 Y98.466 E.04322
G1 X191.672 Y97.171 E.04343
G1 X192.902 Y97.171 E.04121
; COOLING_NODE: 0
G1 X193.354 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X193.354 Y98.858 E.06457
G1 X191.28 Y98.858 E.06437
G1 X191.28 Y96.778 E.06457
G1 X193.294 Y96.778 E.06251
M204 S1000
G1 X192.096 Y97.595
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48422
M204 S25
G1 X192.096 Y98.042 E.01626
G1 X192.538 Y98.042 E.01603
G1 X192.538 Y97.595 E.01626
G1 X192.156 Y97.595 E.01385
; WIPE_START
G1 X192.538 Y97.595 E-.14489
G1 X192.538 Y98.042 E-.17005
G1 X192.366 Y98.042 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I1.216 J-.044 P1  F600
G1 X192.096 Y90.542 Z1.8
G1 Z1.4
G1 E.6 F1800
G1 F600
M204 S25
G1 X192.538 Y90.542 E.01603
G1 X192.538 Y90.095 E.01626
G1 X192.096 Y90.095 E.01603
G1 X192.096 Y90.482 E.01408
; WIPE_START
G1 X192.096 Y90.095 E-.14725
G1 X192.538 Y90.095 E-.16769
G1 X192.538 Y90.266 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I-.018 J-1.217 P1  F600
G1 X174.096 Y90.542 Z1.8
G1 Z1.4
G1 E.6 F1800
G1 F600
M204 S25
G1 X174.538 Y90.542 E.01603
G1 X174.538 Y90.095 E.01626
G1 X174.096 Y90.095 E.01603
G1 X174.096 Y90.482 E.01408
; WIPE_START
G1 X174.096 Y90.095 E-.14725
G1 X174.538 Y90.095 E-.16769
G1 X174.538 Y90.266 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I-.581 J-1.07 P1  F600
G1 X161.038 Y97.595 Z1.8
G1 Z1.4
G1 E.6 F1800
G1 F600
M204 S25
M73 P66 R10
G1 X160.596 Y97.595 E.01603
G1 X160.596 Y98.042 E.01626
G1 X161.038 Y98.042 E.01603
G1 X161.038 Y97.655 E.01408
; WIPE_START
G1 X161.038 Y98.042 E-.14725
G1 X160.596 Y98.042 E-.16769
G1 X160.596 Y97.871 E-.06505
; WIPE_END
G1 E-.02 F1800
M632 S0 N R W
M400
M104 T0 S210 N0 ;Multi extruder pre heating
M633
M204 S1000
G17
G3 Z1.8 I.48 J-1.118 P1  F600
G1 X143.538 Y90.542 Z1.8
G1 Z1.4
G1 E.6 F1800
G1 F600
M204 S25
G1 X143.538 Y90.095 E.01626
G1 X143.096 Y90.095 E.01603
G1 X143.096 Y90.542 E.01626
G1 X143.478 Y90.542 E.01385
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #10
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
; WIPE_START
M204 S25
G1 X143.096 Y90.542 E-.14489
G1 X143.096 Y90.095 E-.17005
G1 X143.267 Y90.095 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I1.217 J0 P1  F600
G1 X151.308 Y171.499
G1 Z1.4
G1 E.6 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF1 NF0 ON0 NN2
M204 S25
G1  X177.308 Y171.499  E2.0691 F7836
; NOZZLE_CHANGE_END OF1 NF0 ON0 NN2
M400
M104 T1 S25 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S25
G1 X176.308 Y171.499 E-1.9
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


M620 O11
M620 S0A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4.4 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X179.558 Y172.749



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
M73 E4

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
M73 P67 R9
G1 X183.06 F30000

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
G1 X183.06 F30000

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
M620 O11
M1002 gcode_claim_action : 0
M106 S163.2
M106 P2 S191
G1 X182.06 Y172.749 F60000
M204 S10000
G1 Z1.4

; filament start gcode
G17
G3 Z1.8 I0 J-1.217 P1
G1 X177.558 Y172.749 Z1.8
G1 Z1.4
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X174.558 Y172.749  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X179.058  F600
G1  X177.558  F240
G1  X178.058  F600
G1  Y173.249 
G1  X177.058 
G1  Y172.249 
G1  X178.558 
G1  Y173.749 
G1  X176.558 
G1  Y171.749 
G1  X174.558 Y172.749   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X151.058  E0.8931 F1782
G1  Y173.499  E0.0285
G1  X177.558  E1.0072 F2025
G1  Y174.249  E0.0285
G1  X151.058  E1.0072 F2473
G1  Y174.999  E0.0285
G1  X177.558  E1.0072 F4725
G1  Y175.749  E0.0285
G1  X151.058  E1.0072 F4775
G1  Y176.499  E0.0285
G1  X177.558  E1.0072
G1  Y177.249  E0.0285
G1  X151.058  E1.0072
G1  Y177.999  E0.0285
G1  X177.558  E1.0072
G1  Y178.749  E0.0285
G1  X151.058  E1.0072
G1  Y179.499  E0.0285
G1  X177.558  E1.0072
G1  Y180.249  E0.0285
G1  X151.058  E1.0072
G1  Y180.999  E0.0285
G1  X177.558  E1.0072
G1  Y181.749  E0.0285
G1  X151.058  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  X177.558 Y195.749   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X178.058 Y196.749  
M204 S8000
G3  X175.599 Y198.794   I-4.377 J-2.762 E0.1236
G3  X172.940 Y197.538   I0.009 J-3.462 E0.1154
G2  X170.236 Y196.749   I-2.710 J4.259 E0.1085
G2  X158.190 Y196.753   I-5.928 J318.375 E0.4578
G2  X154.243 Y198.635   I0.501 J6.129 E0.1699
G3  X151.932 Y198.202   I-0.852 J-1.839 E0.0953
G3  X148.870 Y194.931   I16.406 J-18.427 E0.1705
G3  X149.704 Y191.976   I2.026 J-1.023 E0.1282
G2  X150.558 Y189.443   I-3.390 J-2.554 E0.1033
G2  X150.555 Y177.885   I-283.960 J-5.694 E0.4393
G2  X148.712 Y174.320   I-6.625 J1.166 E0.1549
G3  X149.047 Y172.347   I1.652 J-0.734 E0.0806
G3  X152.165 Y169.085   I19.448 J15.469 E0.1717
G3  X155.363 Y169.743   I1.278 J1.891 E0.1383
G2  X158.380 Y170.749   I3.023 J-4.037 E0.1230
G1  X164.308  E0.2253
G1  X165.558  E0.0475
G2  X171.182 Y170.659   I2.339 J-29.659 E0.2141
G2  X174.517 Y168.801   I-2.882 J-9.098 E0.1461
G3  X176.684 Y169.296   I0.711 J1.877 E0.0895
G1  X179.050 Y171.798   E0.1309
G1 E-0.4000 F1800
M204 S10000
G1  X180.020 Y173.962   F600
G1 E0.4000 F1800
M204 S8000
G3  X178.399 Y176.401   I-22.773 J-13.378 E0.1113 F5400
G2  X178.058 Y178.055   I4.011 J1.689 E0.0646
G1  Y184.249  E0.2354
G1 E-0.4000 F1800
M204 S10000
G1  Y186.749  F600
G1 E0.4000 F1800
M204 S8000
G2  X178.629 Y191.552   I9.158 J1.347 E0.1860 F5400
G3  X180.060 Y193.863   I-3.474 J3.751 E0.1046
G3  X179.569 Y195.151   I-1.871 J0.023 E0.0536
G1  X178.058 Y196.749   E0.0836
; WIPE_TOWER_END

; WIPE_START
M204 S8000
G1 X178.058 Y196.749 E0
G1 X178.745 Y196.023 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.217 J0 P1  F60000
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S10000
G1 X194.166 Y95.966
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1500
M204 S50
G1 X190.462 Y95.966 E.12413
G1 X190.462 Y98.466 E.08378
G1 X189.166 Y98.466 E.04343
G1 X189.166 Y89.671 E.29475
G1 X190.462 Y89.671 E.04343
G1 X190.462 Y92.171 E.08378
G1 X194.166 Y92.171 E.12413
G1 X194.166 Y89.671 E.08378
G1 X197.962 Y89.671 E.1272
G1 X197.962 Y98.466 E.29475
G1 X194.166 Y98.466 E.1272
G1 X194.166 Y96.026 E.08177
; COOLING_NODE: 0
M204 S250
G1 X193.774 Y96.358 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X190.854 Y96.358 E.09064
G1 X190.854 Y98.858 E.0776
G1 X188.774 Y98.858 E.06457
G1 X188.774 Y89.278 E.29737
G1 X190.854 Y89.278 E.06457
M73 P68 R9
G1 X190.854 Y91.778 E.0776
G1 X193.774 Y91.778 E.09064
G1 X193.774 Y89.278 E.0776
G1 X198.354 Y89.278 E.14217
G1 X198.354 Y98.858 E.29737
G1 X193.774 Y98.858 E.14217
G1 X193.774 Y96.418 E.07574
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X192.774 Y96.398 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I.3 J-1.179 P1  F60000
G1 X176.166 Y92.171 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3000
M204 S50
G1 X176.166 Y89.671 E.08378
G1 X176.962 Y89.671 E.02667
G1 X176.962 Y98.466 E.29475
G1 X162.666 Y98.466 E.47906
G1 X162.666 Y95.966 E.08378
G1 X158.962 Y95.966 E.12413
G1 X158.962 Y98.466 E.08378
G1 X158.166 Y98.466 E.02667
G1 X158.166 Y89.671 E.29475
G1 X172.462 Y89.671 E.47906
G1 X172.462 Y92.171 E.08378
G1 X176.106 Y92.171 E.12212
; COOLING_NODE: 0
M204 S250
G1 X175.774 Y91.778 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1777
M204 S50
G1 X175.774 Y89.278 E.0776
G1 X177.354 Y89.278 E.04904
G1 X177.354 Y98.858 E.29737
G1 X162.274 Y98.858 E.4681
G1 X162.274 Y96.358 E.0776
G1 X159.354 Y96.358 E.09064
G1 X159.354 Y98.858 E.0776
G1 X157.774 Y98.858 E.04904
G1 X157.774 Y89.278 E.29737
G1 X172.854 Y89.278 E.4681
G1 X172.854 Y91.778 E.0776
G1 X175.714 Y91.778 E.08878
; COOLING_NODE: 0
; WIPE_START
G1 F3000
M204 S8000
G1 X175.738 Y90.779 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-.055 J-1.216 P1  F60000
G1 X145.166 Y92.171 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X145.166 Y89.671 E.08378
G1 X145.962 Y89.671 E.02667
G1 X145.962 Y98.466 E.29475
G1 X137.166 Y98.466 E.29475
G1 X137.166 Y89.671 E.29475
G1 X141.462 Y89.671 E.14396
G1 X141.462 Y92.171 E.08378
G1 X145.106 Y92.171 E.12212
; COOLING_NODE: 0
M204 S250
G1 X144.774 Y91.778 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X144.774 Y89.278 E.0776
G1 X146.354 Y89.278 E.04904
G1 X146.354 Y98.858 E.29737
G1 X136.774 Y98.858 E.29737
G1 X136.774 Y89.278 E.29737
G1 X141.854 Y89.278 E.15769
G1 X141.854 Y91.778 E.0776
G1 X144.714 Y91.778 E.08878
; WIPE_START
M204 S8000
G1 X144.738 Y90.779 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-1.081 J.56 P1  F60000
M73 P69 R9
G1 X145.564 Y92.374 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F15000
M204 S8000
G1 X145.564 Y89.874 E.08001
; WIPE_START
G1 X145.564 Y90.874 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-.785 J-.93 P1  F60000
G1 X140.386 Y95.246 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.470827
G1 F17527.185
M204 S8000
G1 X140.696 Y95.27 E.01097
; LINE_WIDTH: 0.42272
G1 F19747.235
G1 X141.007 Y95.294 E.00973
; LINE_WIDTH: 0.354844
G1 F21000
G2 X142.754 Y95.318 I1.029 J-11.256 E.04491
M204 S10000
G1 X143.171 Y94.961 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X141.317 Y94.961 E.06213
G3 X139.956 Y94.575 I-.018 J-2.527 E.04803
G1 X139.956 Y95.676 E.03688
G1 X143.171 Y95.676 E.10772
G1 X143.171 Y95.021 E.02194
M204 S10000
G1 X143.578 Y94.554 F60000
G1 F18424.351
M204 S8000
G1 X141.317 Y94.554 E.07577
G3 X139.549 Y93.662 I-.009 J-2.18 E.06887
G1 X139.549 Y96.083 E.08111
G1 X143.578 Y96.083 E.135
G1 X143.578 Y94.614 E.04922
M204 S10000
G1 X143.985 Y94.147 F60000
; LINE_WIDTH: 0.445947
G1 F18609.169
M204 S8000
G1 X141.317 Y94.147 E.08852
G3 X139.521 Y92.63 I.052 J-1.883 E.08422
G3 X139.501 Y91.631 I20.453 J-.905 E.03316
G1 X139.126 Y91.631 E.01244
G3 X139.142 Y96.49 I-729.634 J4.838 E.16121
G1 X143.985 Y96.49 E.16067
G1 X143.985 Y94.207 E.07574
M204 S10000
G1 X144.392 Y93.74 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X141.317 Y93.74 E.10305
G3 X139.892 Y92.315 I.041 J-1.466 E.07444
G1 X139.892 Y91.24 E.03603
G1 X138.735 Y91.24 E.03877
G1 X138.735 Y96.897 E.18957
G1 X144.392 Y96.897 E.18957
G1 X144.392 Y93.8 E.10378
M204 S10000
G1 X144.799 Y93.419 F60000
G1 F18424.351
M204 S8000
G3 X144.634 Y93.333 I-.039 J-.126 E.00694
G1 X141.317 Y93.333 E.11116
G3 X140.299 Y92.315 I.029 J-1.047 E.05317
G1 X140.299 Y90.833 E.04967
G1 X138.328 Y90.833 E.06606
G1 X138.328 Y97.304 E.21685
G1 X144.799 Y97.304 E.21685
G1 X144.799 Y93.479 E.12816
M204 S10000
G1 X145.203 Y93.132 F60000
G1 F18424.351
M204 S8000
G1 X144.877 Y93.035 E.0114
G1 X144.817 Y92.926 E.00418
G1 X141.317 Y92.926 E.11728
G3 X140.716 Y92.421 I.02 J-.634 E.02838
G3 X140.706 Y90.426 I65.427 J-1.299 E.06685
G1 X137.921 Y90.426 E.09334
G1 X137.921 Y97.711 E.24413
G1 X145.206 Y97.711 E.24413
G2 X145.204 Y93.192 I-342.619 J-2.039 E.15142
M204 S10000
G1 X145.614 Y93.132 F60000
G1 F18424.351
M204 S8000
G1 X145.614 Y92.722 E.01375
G1 X145.095 Y92.691 E.01742
G1 X145 Y92.519 E.00658
G1 X141.317 Y92.519 E.1234
G3 X141.114 Y92.315 I0 J-.204 E.01071
G1 X141.114 Y90.019 E.07695
G1 X137.514 Y90.019 E.12062
G1 X137.514 Y98.118 E.27141
G1 X145.614 Y98.118 E.27141
G1 X145.614 Y93.192 E.16506
; WIPE_START
G1 X145.614 Y94.192 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-.147 J1.208 P1  F60000
G1 X158.564 Y95.763 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F15000
M204 S8000
G1 X158.564 Y98.263 E.08001
; WIPE_START
G1 X158.564 Y97.263 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I.185 J1.203 P1  F60000
G1 X171.542 Y95.268 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.42556
G1 F19600.67
M204 S8000
G1 X171.93 Y95.293 E.01223
; LINE_WIDTH: 0.35588
G1 F21000
G2 X173.754 Y95.318 I1.106 J-14.126 E.04703
M204 S10000
G1 X172.114 Y92.315 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X172.114 Y90.019 E.07695
G1 X158.514 Y90.019 E.45571
G1 X158.514 Y95.415 E.18082
G1 X159.033 Y95.446 E.01742
G1 X159.128 Y95.618 E.00658
G1 X162.81 Y95.618 E.1234
G3 X163.014 Y95.822 I0 J.204 E.01071
G1 X163.014 Y98.118 E.07695
G1 X176.614 Y98.118 E.45571
G1 X176.614 Y92.722 E.18082
G1 X176.095 Y92.691 E.01742
G1 X176 Y92.519 E.00658
G1 X172.317 Y92.519 E.1234
G3 X172.138 Y92.37 I-.015 J-.164 E.00867
M204 S10000
G1 X171.707 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X171.707 Y90.426 E.06331
G1 X158.921 Y90.426 E.42843
G2 X158.924 Y95.004 I347.767 J2.039 E.15343
G1 X159.25 Y95.102 E.0114
G1 X159.311 Y95.211 E.00418
G1 X162.81 Y95.211 E.11728
G3 X163.421 Y95.822 I0 J.611 E.03214
G1 X163.421 Y97.711 E.06331
G1 X176.207 Y97.711 E.42843
G2 X176.203 Y93.132 I-347.767 J-2.039 E.15343
G1 X175.877 Y93.035 E.0114
G1 X175.817 Y92.926 E.00418
G1 X172.317 Y92.926 E.11728
G3 X171.714 Y92.375 I-.002 J-.604 E.03007
M204 S10000
G1 X171.299 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X171.299 Y90.833 E.04967
G1 X159.328 Y90.833 E.40115
G1 X159.328 Y94.717 E.13017
G3 X159.493 Y94.804 I.039 J.126 E.00694
G1 X162.81 Y94.804 E.11116
G3 X163.828 Y95.822 I-.018 J1.036 E.05332
G1 X163.828 Y97.304 E.04967
G1 X175.799 Y97.304 E.40115
G1 X175.799 Y93.419 E.13017
G3 X175.634 Y93.333 I-.039 J-.126 E.00694
G1 X172.317 Y93.333 E.11116
G3 X171.312 Y92.374 I.012 J-1.019 E.05122
M204 S10000
G1 X170.892 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.892 Y91.24 E.03603
G1 X159.735 Y91.24 E.37387
G1 X159.735 Y94.397 E.10579
G1 X162.81 Y94.397 E.10305
G3 X164.235 Y95.822 I-.02 J1.445 E.07471
G1 X164.235 Y96.897 E.03603
G1 X175.392 Y96.897 E.37387
G1 X175.392 Y93.74 E.10579
G1 X172.317 Y93.74 E.10305
G3 X170.9 Y92.375 I.015 J-1.435 E.07267
M204 S10000
G1 X170.485 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.485 Y91.647 E.02239
G1 X160.142 Y91.647 E.34659
G1 X160.142 Y93.99 E.07851
G1 X162.81 Y93.99 E.08941
G3 X164.642 Y95.822 I-.026 J1.858 E.09606
G1 X164.642 Y96.49 E.02239
G1 X174.985 Y96.49 E.34659
G1 X174.985 Y94.147 E.07851
G1 X172.317 Y94.147 E.08941
G3 X170.492 Y92.375 I.021 J-1.847 E.09402
M204 S10000
G1 X170.078 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.078 Y92.054 E.00875
G1 X160.549 Y92.054 E.31931
G1 X160.549 Y93.583 E.05123
G1 X162.81 Y93.583 E.07577
G3 X165.049 Y96.083 I-.036 J2.285 E.1263
G1 X174.578 Y96.083 E.31931
G1 X174.578 Y94.554 E.05123
G1 X172.317 Y94.554 E.07577
G3 X170.085 Y92.375 I.027 J-2.26 E.11536
M204 S10000
G1 X169.689 Y92.461 F60000
G1 F18424.351
M204 S8000
G1 X160.956 Y92.461 E.29262
G1 X160.956 Y93.176 E.02395
G1 X162.81 Y93.176 E.06213
G3 X165.439 Y95.676 I-.026 J2.659 E.13376
G1 X174.171 Y95.676 E.29262
G1 X174.171 Y94.961 E.02395
G1 X172.317 Y94.961 E.06213
G3 X169.696 Y92.521 I.024 J-2.653 E.13173
M204 S10000
G1 X166.686 Y94.068 F60000
; LINE_WIDTH: 0.40814
G1 F20535.567
M204 S8000
G1 X168.382 Y94.068 E.051
M204 S10000
G1 X166.021 Y93.682 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G3 X166.412 Y94.455 I-1.827 J1.412 E.02919
G1 X169.107 Y94.455 E.0903
G3 X168.715 Y93.682 I1.827 J-1.412 E.02919
G1 X166.081 Y93.682 E.08829
M204 S10000
G1 X165.151 Y93.275 F60000
G1 F18424.351
M204 S8000
G3 X166.124 Y94.862 I-2.592 J2.682 E.06304
G1 X169.977 Y94.862 E.12911
G3 X169.004 Y93.275 I2.592 J-2.682 E.06304
G1 X165.211 Y93.275 E.1271
M204 S10000
G1 X163.586 Y92.868 F60000
; LINE_WIDTH: 0.450037
G1 F18422.236
M204 S8000
G3 X165.797 Y95.269 I-.764 J2.922 E.11554
G1 X171.542 Y95.268 E.19255
G3 X169.331 Y92.868 I.764 J-2.922 E.11554
G1 X163.646 Y92.868 E.19054
M204 S10000
G1 X161.314 Y92.818 F60000
; LINE_WIDTH: 0.35056
G1 F21000
M204 S8000
G1 X162.81 Y92.818 E.0379
; LINE_WIDTH: 0.37556
G1 X163.168 Y92.842 E.00981
; LINE_WIDTH: 0.42556
G1 F19600.67
G1 X163.526 Y92.865 E.01129
M204 S10000
G1 X176.564 Y92.374 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F15000
M204 S8000
G1 X176.564 Y89.874 E.08001
; WIPE_START
G1 X176.564 Y90.874 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-.358 J1.163 P1  F60000
G1 X189.558 Y94.874 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.436823
G1 F15000
M204 S8000
G1 X189.575 Y95.318 E.01442
; LINE_WIDTH: 0.485945
G1 X189.592 Y95.763 E.01622
G1 X189.592 Y98.041 E.08307
G1 X190.036 Y98.041 E.01621
G1 X190.036 Y95.763 E.08307
; LINE_WIDTH: 0.470488
G1 X190.147 Y95.669 E.00513
; LINE_WIDTH: 0.420079
G1 X190.258 Y95.574 E.00452
G1 X194.369 Y95.574 E.12764
G1 X194.483 Y95.612 E.0037
G1 X194.558 Y95.763 E.00524
G1 X194.558 Y98.074 E.07176
G1 X197.57 Y98.074 E.09351
G1 X197.57 Y90.063 E.24874
G1 X194.558 Y90.063 E.09351
G1 X194.558 Y92.374 E.07176
G1 X194.483 Y92.525 E.00524
G1 X194.369 Y92.563 E.0037
G1 X190.258 Y92.563 E.12764
; LINE_WIDTH: 0.437668
G1 X190.148 Y92.488 E.00433
; LINE_WIDTH: 0.486965
G1 X190.038 Y92.413 E.00487
G1 X190.036 Y90.096 E.08467
G1 X189.592 Y90.096 E.01624
G1 X189.592 Y92.374 E.08326
; LINE_WIDTH: 0.470488
G1 X189.575 Y92.818 E.01565
; LINE_WIDTH: 0.423741
G2 X189.558 Y94.814 I26.323 J1.22 E.06258
M204 S10000
G1 X190.312 Y94.82 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X194.369 Y94.82 E.12594
G1 X194.7 Y94.88 E.01044
G1 X194.935 Y95.009 E.0083
G1 X195.201 Y95.319 E.0127
G1 X195.312 Y95.763 E.01419
G1 X195.312 Y97.32 E.04834
G1 X196.816 Y97.32 E.04667
G1 X196.816 Y90.817 E.20187
G1 X195.312 Y90.817 E.04667
G1 X195.312 Y92.374 E.04834
G3 X195.201 Y92.818 I-.943 J0 E.01434
G1 X194.935 Y93.128 E.0127
G1 X194.7 Y93.257 E.0083
G1 X194.369 Y93.317 E.01044
G1 X190.312 Y93.317 E.12594
G1 X190.312 Y94.76 E.04481
M204 S10000
G1 X190.689 Y94.443 F60000
G1 F15000
M204 S8000
G1 X194.369 Y94.443 E.11424
G1 X194.833 Y94.527 E.01462
G1 X195.161 Y94.707 E.01162
G1 X195.534 Y95.142 E.01777
G1 X195.689 Y95.763 E.01987
G1 X195.689 Y96.943 E.03664
G1 X196.438 Y96.943 E.02326
G1 X196.438 Y91.194 E.17846
G1 X195.689 Y91.194 E.02326
G1 X195.689 Y92.374 E.03664
G1 X195.669 Y92.602 E.0071
G1 X195.534 Y92.995 E.0129
G1 X195.161 Y93.43 E.01777
G1 X194.833 Y93.61 E.01162
G1 X194.369 Y93.694 E.01462
G1 X190.689 Y93.694 E.11424
G1 X190.689 Y94.383 E.0214
M204 S10000
G1 X191.064 Y94.068 F60000
; LINE_WIDTH: 0.41518
G1 F15000
M204 S8000
G1 X194.309 Y94.068 E.09946
M204 S10000
G1 X189.935 Y92.668 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X189.935 Y95.52 E.08853
G1 X190.258 Y95.197 E.01419
G1 X194.369 Y95.197 E.12761
G3 X194.868 Y95.497 I-.022 J.603 E.01885
G1 X194.935 Y95.763 E.00852
G1 X194.935 Y97.697 E.06004
G1 X197.193 Y97.697 E.07008
G1 X197.193 Y90.44 E.22528
G1 X194.935 Y90.44 E.07008
G1 X194.935 Y92.374 E.06004
G1 X194.868 Y92.64 E.00852
G1 X194.709 Y92.827 E.00762
G3 X194.369 Y92.94 I-.339 J-.452 E.0113
G1 X190.258 Y92.94 E.12761
G1 X189.981 Y92.707 E.01124
M204 S10000
G1 X196.051 Y92.669 F60000
; LINE_WIDTH: 0.428
G1 F15000
M204 S8000
G1 X196.063 Y91.628 E.03299
M204 S10000
G1 X195.669 Y94.018 F60000
; LINE_WIDTH: 0.50824
G1 F15000
M204 S8000
G2 X195.667 Y94.119 I-.029 J.05 E.0092
M204 S10000
G1 X194.369 Y94.068 F60000
; LINE_WIDTH: 0.420555
G1 F15000
M204 S8000
G1 X194.965 Y94.174 E.01881
G1 X195.387 Y94.405 E.01497
G1 X195.867 Y94.964 E.02289
G1 X196.064 Y95.763 E.02557
G2 X196.051 Y92.669 I-256.821 J-.482 E.09618
G1 X195.867 Y93.173 E.01667
G1 X195.387 Y93.732 E.02289
G1 X194.965 Y93.963 E.01497
G1 X194.428 Y94.058 E.01694
M204 S10000
G1 X196.064 Y96.568 F60000
; LINE_WIDTH: 0.41517
G1 F15000
M204 S8000
G1 X196.064 Y95.823 E.02285
; WIPE_START
G1 X196.064 Y96.568 E-.38
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
    

    

    
        M9711 M0 E0 U266 V97 Z1.8 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #11
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
M204 S10000
G1 X151.308 Y182.749
G1 Z1.4
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
G1  X177.308 Y182.749  E2.0691 F7836
G1  Y184.249  E0.1194
G1  X151.308  E2.0691
M632 S2 M N
M204 S10000
G1  Y184.999 
G1  X176.808  F3000
G1  Y183.499 
G1  X151.808 
M633
; NOZZLE_CHANGE_END OF0 NF2 ON2 NN1

G1 E-2 F1800
G17
G3 Z1.8 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O12
M620 S2A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4.4 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X179.558 Y185.499



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
M73 P71 R8
G1 Z4.4 F3000

M204 S25


M621 S2A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F8.75 A0.4 R2
M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.4

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I2 H-1 W1 ;enable ams air printing detect
M620 O12
M1002 gcode_claim_action : 0
M106 S255
M106 P2 S191

; filament start gcode
G1 X177.558 Y185.499 F60000
G1 Z1.4
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X174.558 Y185.499  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X179.058  F600
G1  X177.558  F240
G1  X178.058  F600
G1  Y185.999 
G1  X177.058 
G1  Y184.999 
G1  X178.558 
G1  Y186.499 
G1  X176.558 
G1  Y184.499 
G1  X174.558 Y185.499   F1782
G1 E0.4000 F1800
M400
M104 T0 S230 N0
M204 S8000
G1  X151.058  E0.8931 F1782
G1  Y186.249  E0.0285
G1  X177.558  E1.0072 F2025
G1  Y186.999  E0.0285
G1  X151.058  E1.0072 F2473
G1  Y187.749  E0.0285
G1  X177.558  E1.0072 F4725
G1  Y188.499  E0.0285
G1  X151.058  E1.0072 F4775
G1  Y189.249  E0.0285
G1  X177.558  E1.0072
G1  Y189.999  E0.0285
G1  X151.058  E1.0072
G1  Y190.749  E0.0285
G1  X177.558  E1.0072
G1  Y191.499  E0.0285
G1  X151.058  E1.0072
G1  Y192.249  E0.0285
G1  X177.558  E1.0072
G1  Y192.999  E0.0285
G1  X151.058  E1.0072
G1  Y193.749  E0.0285
G1  X177.558  E1.0072
G1  Y194.499  E0.0285
G1  X151.058  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y196.249   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S8000
G1  Y195.249  E0.0380
G1  X177.558  E1.0072
G1  Y196.249  E0.0380
G1  X151.058  E1.0072
; WIPE_TOWER_END

; WIPE_START
G1 F15000
M204 S8000
G1 X151.058 Y195.249 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.217 J0 P1  F60000
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S10000
G1 X187.962 Y94.068
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1500
M204 S50
G1 X187.962 Y98.466 E.14887
G1 X178.166 Y98.466 E.33158
G1 X178.166 Y89.671 E.29773
G1 X187.962 Y89.671 E.33158
G1 X187.962 Y94.008 E.14683
; COOLING_NODE: 0
M204 S250
G1 X188.354 Y94.068 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
M73 P72 R8
G1 X188.354 Y98.858 E.15019
G1 X177.774 Y98.858 E.33173
G1 X177.774 Y89.278 E.30037
G1 X188.354 Y89.278 E.33173
G1 X188.354 Y94.008 E.14831
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X188.354 Y95.008 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I.036 J-1.216 P1  F60000
G1 X156.962 Y94.068 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X156.962 Y98.466 E.14887
G1 X147.166 Y98.466 E.33158
G1 X147.166 Y89.671 E.29773
G1 X156.962 Y89.671 E.33158
G1 X156.962 Y94.008 E.14683
; COOLING_NODE: 0
M204 S250
G1 X157.354 Y94.068 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X157.354 Y98.858 E.15019
G1 X146.774 Y98.858 E.33173
G1 X146.774 Y89.278 E.30037
G1 X157.354 Y89.278 E.33173
G1 X157.354 Y94.008 E.14831
; WIPE_START
M204 S8000
G1 X157.354 Y95.008 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.207 J-.153 P1  F60000
G1 X156.798 Y90.615 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42888
G1 F15000
M204 S8000
G1 X156.187 Y90.004 E.02775
G1 X155.641 Y90.004 E.01752
G1 X156.628 Y90.991 E.04482
G1 X156.628 Y91.537 E.01752
G1 X155.095 Y90.004 E.0696
G1 X154.549 Y90.004 E.01752
G1 X156.628 Y92.083 E.09437
G1 X156.628 Y92.629 E.01752
G1 X154.003 Y90.004 E.11914
G1 X153.458 Y90.004 E.01752
G1 X156.628 Y93.175 E.14391
G1 X156.628 Y93.721 E.01752
G1 X152.912 Y90.004 E.16869
G1 X152.366 Y90.004 E.01752
G1 X156.628 Y94.266 E.19346
G1 X156.628 Y94.812 E.01752
G1 X151.82 Y90.004 E.21823
G1 X151.274 Y90.004 E.01752
G1 X156.628 Y95.358 E.24301
G1 X156.628 Y95.904 E.01752
G1 X150.728 Y90.004 E.26778
G1 X150.183 Y90.004 E.01752
G1 X156.628 Y96.45 E.29255
G1 X156.628 Y96.995 E.01752
G1 X149.637 Y90.004 E.31733
G1 X149.091 Y90.004 E.01752
G1 X156.628 Y97.541 E.3421
G1 X156.628 Y98.087 E.01752
G1 X148.545 Y90.004 E.36687
G1 X147.999 Y90.004 E.01752
G1 X156.129 Y98.133 E.36896
G1 X155.583 Y98.133 E.01752
G1 X147.499 Y90.049 E.36689
G1 X147.499 Y90.595 E.01752
G1 X155.037 Y98.133 E.34211
G1 X154.491 Y98.133 E.01752
G1 X147.499 Y91.141 E.31734
G1 X147.499 Y91.687 E.01752
G1 X153.945 Y98.133 E.29257
G1 X153.399 Y98.133 E.01752
G1 X147.499 Y92.233 E.26779
G1 X147.499 Y92.779 E.01752
G1 X152.854 Y98.133 E.24302
G1 X152.308 Y98.133 E.01752
G1 X147.499 Y93.324 E.21825
G1 X147.499 Y93.87 E.01752
G1 X151.762 Y98.133 E.19347
G1 X151.216 Y98.133 E.01752
G1 X147.499 Y94.416 E.1687
G1 X147.499 Y94.962 E.01752
G1 X150.67 Y98.133 E.14393
G1 X150.125 Y98.133 E.01752
G1 X147.499 Y95.508 E.11916
G1 X147.499 Y96.054 E.01752
G1 X149.579 Y98.133 E.09438
G1 X149.033 Y98.133 E.01752
G1 X147.499 Y96.599 E.06961
G1 X147.499 Y97.145 E.01752
G1 X148.487 Y98.133 E.04484
G1 X147.941 Y98.133 E.01752
G1 X147.329 Y97.521 E.02776
; WIPE_START
G1 X147.941 Y98.133 E-.32875
G1 X148.076 Y98.133 E-.05125
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I.025 J1.217 P1  F60000
G1 X178.329 Y97.521 Z1.8
G1 Z1.4
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X178.941 Y98.133 E.02776
G1 X179.487 Y98.133 E.01752
G1 X178.499 Y97.145 E.04484
G1 X178.499 Y96.599 E.01752
G1 X180.033 Y98.133 E.06961
G1 X180.579 Y98.133 E.01752
G1 X178.499 Y96.054 E.09438
G1 X178.499 Y95.508 E.01752
G1 X181.125 Y98.133 E.11916
G1 X181.67 Y98.133 E.01752
G1 X178.499 Y94.962 E.14393
G1 X178.499 Y94.416 E.01752
G1 X182.216 Y98.133 E.1687
G1 X182.762 Y98.133 E.01752
G1 X178.499 Y93.87 E.19347
G1 X178.499 Y93.324 E.01752
G1 X183.308 Y98.133 E.21825
G1 X183.854 Y98.133 E.01752
G1 X178.499 Y92.779 E.24302
G1 X178.499 Y92.233 E.01752
G1 X184.399 Y98.133 E.26779
G1 X184.945 Y98.133 E.01752
G1 X178.499 Y91.687 E.29257
G1 X178.499 Y91.141 E.01752
G1 X185.491 Y98.133 E.31734
G1 X186.037 Y98.133 E.01752
G1 X178.499 Y90.595 E.34211
G1 X178.499 Y90.049 E.01752
G1 X186.583 Y98.133 E.36688
G1 X187.129 Y98.133 E.01752
G1 X178.999 Y90.004 E.36896
G1 X179.545 Y90.004 E.01752
G1 X187.628 Y98.087 E.36687
G1 X187.628 Y97.541 E.01752
G1 X180.091 Y90.004 E.3421
G1 X180.637 Y90.004 E.01752
G1 X187.628 Y96.996 E.31733
G1 X187.628 Y96.45 E.01752
G1 X181.183 Y90.004 E.29255
G1 X181.728 Y90.004 E.01752
G1 X187.628 Y95.904 E.26778
G1 X187.628 Y95.358 E.01752
G1 X182.274 Y90.004 E.24301
G1 X182.82 Y90.004 E.01752
G1 X187.628 Y94.812 E.21823
G1 X187.628 Y94.266 E.01752
G1 X183.366 Y90.004 E.19346
G1 X183.912 Y90.004 E.01752
G1 X187.628 Y93.721 E.16869
G1 X187.628 Y93.175 E.01752
G1 X184.458 Y90.004 E.14391
G1 X185.003 Y90.004 E.01752
G1 X187.628 Y92.629 E.11914
G1 X187.628 Y92.083 E.01752
G1 X185.549 Y90.004 E.09437
G1 X186.095 Y90.004 E.01752
G1 X187.628 Y91.537 E.0696
G1 X187.628 Y90.991 E.01752
G1 X186.641 Y90.004 E.04482
G1 X187.187 Y90.004 E.01752
G1 X187.798 Y90.615 E.02775
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X187.187 Y90.004 E-.32859
G1 X187.051 Y90.004 E-.05141
; WIPE_END
G1 E-.02 F1800
; layer num/total_layer_count: 8/14
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
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
    

    

    
        M9711 M0 E0 U266 V97 Z2 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #12
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
M204 S10000
G1 X151.308 Y171.499
G1 Z1.6
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
G1  X177.308 Y171.499  E2.0691 F6583
G1  Y172.999  E0.1194
G1  X151.308  E2.0691
M632 S0 M N
M204 S10000
G1  Y173.749 
G1  X176.808  F3000
G1  Y172.249 
G1  X151.808 
M633
; NOZZLE_CHANGE_END OF2 NF0 ON1 NN2

G1 E-2 F1800
G17
G3 Z2 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O13
M620 S0A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4.6 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X149.058 Y183.249



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
M73 P74 R7
G1 Z4.6 F3000

M204 S25


M621 S0A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.6

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I0 H-1 W1 ;enable ams air printing detect
M620 O13
M1002 gcode_claim_action : 0
M106 S153
M106 P2 S191

; filament start gcode
G1 X151.058 Y183.249 F60000
G1 Z1.6
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X154.058 Y183.249  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X149.558  F600
G1  X151.058  F240
G1  X151.558  F600
G1  Y183.749 
G1  X150.558 
G1  Y182.749 
G1  X152.058 
G1  Y184.249 
G1  X150.058 
G1  Y182.249 
G1  X154.058 Y183.249   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X177.558  E0.8931 F1782
G1  Y182.499  E0.0285
G1  X151.058  E1.0072 F2025
G1  Y181.749  E0.0285
G1  X177.558  E1.0072 F2473
G1  Y180.999  E0.0285
G1  X151.058  E1.0072 F4725
G1  Y180.249  E0.0285
G1  X177.558  E1.0072 F4775
G1  Y179.499  E0.0285
G1  X151.058  E1.0072
G1  Y178.749  E0.0285
G1  X177.558  E1.0072
G1  Y177.999  E0.0285
G1  X151.058  E1.0072
G1  Y177.249  E0.0285
G1  X177.558  E1.0072
G1  Y176.499  E0.0285
G1  X151.058  E1.0072
G1  Y175.749  E0.0285
G1  X177.558  E1.0072
G1  Y174.999  E0.0285
M73 P75 R7
G1  X151.058  E1.0072
G1  Y174.249  E0.0285
G1  X177.558  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  X151.058 Y195.749   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X148.993 Y195.088  
M204 S8000
G3  X149.598 Y192.109   I1.586 J-1.229 E0.1311
G2  X150.558 Y189.443   I-3.235 J-2.671 E0.1099
G1  Y184.499  E0.1879
G1 E-0.4000 F1800
M204 S10000
G1  Y181.999  F600
G1 E0.4000 F1800
M204 S8000
G2  X150.434 Y177.044   I-20.265 J-1.972 E0.1888 F5400
G2  X148.659 Y174.188   I-11.353 J5.076 E0.1282
G3  X149.047 Y172.347   I1.734 J-0.596 E0.0751
G3  X152.165 Y169.085   I19.448 J15.469 E0.1717
G3  X155.363 Y169.743   I1.278 J1.891 E0.1383
G2  X158.380 Y170.749   I3.023 J-4.037 E0.1230
G1  X164.308  E0.2253
G1  X165.558  E0.0475
G2  X171.182 Y170.659   I2.339 J-29.659 E0.2141
G2  X174.517 Y168.801   I-2.882 J-9.098 E0.1461
G3  X176.684 Y169.296   I0.711 J1.877 E0.0895
G3  X179.746 Y172.567   I-16.399 J18.421 E0.1705
G3  X178.912 Y175.522   I-2.026 J1.023 E0.1282
G2  X178.058 Y178.055   I3.390 J2.554 E0.1033
G2  X178.061 Y189.613   I283.960 J5.694 E0.4393
G2  X179.904 Y193.178   I6.625 J-1.166 E0.1549
G3  X179.569 Y195.151   I-1.652 J0.734 E0.0806
G1  X178.058 Y196.749   E0.0836
G3  X175.599 Y198.794   I-4.377 J-2.762 E0.1236
G3  X172.940 Y197.538   I0.009 J-3.462 E0.1154
G2  X170.236 Y196.749   I-2.710 J4.259 E0.1085
G2  X158.190 Y196.753   I-5.928 J318.375 E0.4578
G2  X154.243 Y198.635   I0.501 J6.129 E0.1699
G3  X151.932 Y198.202   I-0.852 J-1.839 E0.0953
G1  X150.708 Y196.907   E0.0677
; WIPE_TOWER_END

; WIPE_START
G1 F15000
M204 S8000
G1 X151.394 Y197.634 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I1.217 J0 P1  F60000
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S10000
G1 X144.104 Y92.171
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1500
M204 S50
G1 X145.962 Y92.171 E.06226
G1 X145.962 Y98.466 E.21098
G1 X137.166 Y98.466 E.29475
M632 S1 W
M400
M104 T1 S140 N0 ;Multi extruder pre heating
M633
G1 X137.166 Y89.671 E.29475
G1 X141.462 Y89.671 E.14396
G1 X141.462 Y92.171 E.08378
G1 X144.044 Y92.171 E.08653
; COOLING_NODE: 0
M204 S250
G1 X144.104 Y91.778 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X146.354 Y91.778 E.06984
G1 X146.354 Y98.858 E.21977
G1 X136.774 Y98.858 E.29737
G1 X136.774 Y89.278 E.29737
G1 X141.854 Y89.278 E.15769
G1 X141.854 Y91.778 E.0776
G1 X144.044 Y91.778 E.06798
; COOLING_NODE: 9
; WIPE_START
M204 S8000
G1 X145.044 Y91.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-.53 J1.095 P1  F60000
G1 X149.774 Y94.068 Z2
G1 Z1.6
G1 E.4 F1800
G1 F1500
M204 S50
G1 X149.774 Y89.278 E.14869
G1 X154.354 Y89.278 E.14217
G1 X154.354 Y98.858 E.29737
G1 X149.774 Y98.858 E.14217
G1 X149.774 Y94.128 E.14682
; WIPE_START
M204 S8000
G1 X149.774 Y93.128 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-.996 J.699 P1  F60000
G1 X153.652 Y98.651 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X154.146 Y98.157 E.02169
G1 X154.28 Y98.023
G1 X154.28 Y97.49
G1 X154.146 Y97.624
G1 X153.119 Y98.651 E.0451
G1 X152.985 Y98.785
G1 X152.452 Y98.785
G1 X152.586 Y98.651
G1 X154.146 Y97.09 E.06851
G1 X154.28 Y96.957
G1 X154.28 Y96.423
G1 X154.146 Y96.557
G1 X152.052 Y98.651 E.09192
G1 X151.919 Y98.785
G1 X151.386 Y98.785
G1 X151.519 Y98.651
G1 X154.146 Y96.024 E.11533
G1 X154.28 Y95.89
G1 X154.28 Y95.357
G1 X154.146 Y95.491
G1 X150.986 Y98.651 E.13874
G1 X150.852 Y98.785
G1 X150.319 Y98.785
G1 X150.453 Y98.651
G1 X154.146 Y94.957 E.16215
G1 X154.28 Y94.824
G1 X154.28 Y94.29
G1 X154.146 Y94.424
G1 X149.981 Y98.589 E.18285
G1 X149.848 Y98.723
G1 X149.848 Y98.19
G1 X149.981 Y98.056
G1 X154.146 Y93.891 E.18285
G1 X154.28 Y93.757
G1 X154.28 Y93.224
G1 X154.146 Y93.358
G1 X149.981 Y97.523 E.18285
G1 X149.848 Y97.656
G1 X149.848 Y97.123
G1 X149.981 Y96.99
G1 X154.146 Y92.824 E.18285
G1 X154.28 Y92.691
G1 X154.28 Y92.157
G1 X154.146 Y92.291
G1 X149.981 Y96.456 E.18285
G1 X149.848 Y96.59
G1 X149.848 Y96.057
G1 X149.981 Y95.923
G1 X154.146 Y91.758 E.18285
G1 X154.28 Y91.624
G1 X154.28 Y91.091
G1 X154.146 Y91.225
G1 X149.981 Y95.39 E.18285
G1 X149.848 Y95.523
G1 X149.848 Y94.99
G1 X149.981 Y94.857
G1 X154.146 Y90.691 E.18285
G1 X154.28 Y90.558
G1 X154.28 Y90.024
G1 X154.146 Y90.158
G1 X149.981 Y94.323 E.18285
G1 X149.848 Y94.457
G1 X149.848 Y93.924
G1 X149.981 Y93.79
G1 X154.146 Y89.625 E.18285
G1 X154.28 Y89.491
G1 X153.886 Y89.352
G1 X153.752 Y89.486
G1 X149.981 Y93.257 E.16554
G1 X149.848 Y93.39
G1 X149.848 Y92.857
G1 X149.981 Y92.723
G1 X153.219 Y89.486 E.14213
G1 X153.352 Y89.352
G1 X152.819 Y89.352
G1 X152.686 Y89.486
G1 X149.981 Y92.19 E.11872
G1 X149.848 Y92.324
G1 X149.848 Y91.791
G1 X149.981 Y91.657
G1 X152.152 Y89.486 E.09531
G1 X152.286 Y89.352
G1 X151.753 Y89.352
G1 X151.619 Y89.486
G1 X149.981 Y91.124 E.0719
G1 X149.848 Y91.257
G1 X149.848 Y90.724
G1 X149.981 Y90.59
G1 X151.086 Y89.486 E.04849
G1 X151.219 Y89.352
G1 X150.686 Y89.352
G1 X150.553 Y89.486
G1 X149.981 Y90.057 E.02508
; WIPE_START
M204 S8000
G1 X150.553 Y89.486 E-.30704
G1 X150.686 Y89.352 E-.07182
G1 X150.689 Y89.352 E-.00114
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-.604 J-1.056 P1  F60000
G1 X140.386 Y95.246 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.470827
G1 F17527.185
M204 S8000
G1 X140.696 Y95.27 E.01097
; LINE_WIDTH: 0.42272
G1 F19747.235
G1 X141.007 Y95.294 E.00973
; LINE_WIDTH: 0.354844
G1 F21000
G2 X142.754 Y95.318 I1.029 J-11.256 E.04491
M204 S10000
G1 X143.171 Y95.318 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X143.171 Y94.961 E.01197
G1 X141.317 Y94.961 E.06213
G3 X139.956 Y94.575 I-.018 J-2.527 E.04803
G1 X139.956 Y95.676 E.03688
G1 X143.171 Y95.676 E.10772
G1 X143.171 Y95.378 E.00996
M204 S10000
G1 X143.578 Y95.318 F60000
G1 F18424.351
M204 S8000
G1 X143.578 Y94.554 E.02562
G1 X141.317 Y94.554 E.07577
G3 X139.549 Y93.662 I-.009 J-2.18 E.06887
G1 X139.549 Y96.083 E.08111
G1 X143.578 Y96.083 E.135
G1 X143.578 Y95.378 E.02361
M204 S10000
G1 X143.985 Y95.318 F60000
; LINE_WIDTH: 0.445947
G1 F18609.169
M204 S8000
G1 X143.985 Y94.147 E.03887
G1 X141.317 Y94.147 E.08852
G3 X139.521 Y92.63 I.052 J-1.883 E.08422
G3 X139.501 Y91.631 I20.453 J-.905 E.03316
G1 X139.126 Y91.631 E.01244
G3 X139.142 Y96.49 I-729.634 J4.838 E.16121
G1 X143.985 Y96.49 E.16067
G1 X143.985 Y95.378 E.03688
M204 S10000
G1 X144.392 Y95.318 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X144.392 Y93.74 E.0529
G1 X141.317 Y93.74 E.10305
G3 X139.892 Y92.315 I.041 J-1.466 E.07444
G1 X139.892 Y91.24 E.03603
G1 X138.735 Y91.24 E.03877
G1 X138.735 Y96.897 E.18957
G1 X144.392 Y96.897 E.18957
G1 X144.392 Y95.378 E.05089
M204 S10000
G1 X144.799 Y95.318 F60000
G1 F18424.351
M204 S8000
G1 X144.799 Y93.333 E.06654
G1 X141.317 Y93.333 E.11669
G3 X140.299 Y92.315 I.029 J-1.047 E.05317
G1 X140.299 Y90.833 E.04967
G1 X138.328 Y90.833 E.06606
G1 X138.328 Y97.304 E.21685
G1 X144.799 Y97.304 E.21685
G1 X144.799 Y95.378 E.06453
M204 S10000
G1 X145.206 Y95.318 F60000
G1 F18424.351
M204 S8000
G1 X145.206 Y92.926 E.08018
G1 X141.317 Y92.926 E.13033
G3 X140.716 Y92.421 I.02 J-.634 E.02838
G3 X140.706 Y90.426 I65.427 J-1.299 E.06685
G1 X137.921 Y90.426 E.09334
G1 X137.921 Y97.711 E.24413
G1 X145.206 Y97.711 E.24413
G1 X145.206 Y95.378 E.07817
M204 S10000
G1 X145.614 Y95.318 F60000
G1 F18424.351
M204 S8000
G1 X145.614 Y92.519 E.09382
G1 X141.317 Y92.519 E.14397
G3 X141.114 Y92.315 I0 J-.204 E.01071
G1 X141.114 Y90.019 E.07695
G1 X137.514 Y90.019 E.12062
G1 X137.514 Y98.118 E.27141
G1 X145.614 Y98.118 E.27141
G1 X145.614 Y95.378 E.09181
; COOLING_NODE: 0
; WIPE_START
G1 X145.614 Y96.378 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.029 J1.217 P1  F60000
G1 X162.666 Y95.966 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X158.166 Y95.966 E.1508
G1 X158.166 Y89.671 E.21098
G1 X172.462 Y89.671 E.47906
G1 X172.462 Y92.171 E.08378
G1 X176.962 Y92.171 E.1508
G1 X176.962 Y98.466 E.21098
G1 X162.666 Y98.466 E.47906
G1 X162.666 Y96.026 E.08177
; COOLING_NODE: 0
M204 S250
G1 X162.274 Y96.358 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
M73 P76 R7
G1 X157.774 Y96.358 E.13968
G1 X157.774 Y89.278 E.21977
G1 X172.854 Y89.278 E.4681
G1 X172.854 Y91.778 E.0776
G1 X177.354 Y91.778 E.13968
G1 X177.354 Y98.858 E.21977
G1 X162.274 Y98.858 E.4681
G1 X162.274 Y96.418 E.07574
; COOLING_NODE: 10
; WIPE_START
M204 S8000
G1 X161.274 Y96.405 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.145 J1.208 P1  F60000
G1 X180.774 Y94.068 Z2
G1 Z1.6
G1 E.4 F1800
G1 F1500
M204 S50
G1 X180.774 Y89.278 E.14869
G1 X185.354 Y89.278 E.14217
G1 X185.354 Y98.858 E.29737
G1 X180.774 Y98.858 E.14217
G1 X180.774 Y94.128 E.14682
; WIPE_START
M204 S8000
G1 X180.774 Y93.128 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-.913 J.805 P1  F60000
G1 X185.146 Y98.086 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X184.581 Y98.651 E.02481
G1 X184.448 Y98.785
G1 X183.914 Y98.785
G1 X184.048 Y98.651
G1 X185.146 Y97.553 E.04822
G1 X185.28 Y97.419
G1 X185.28 Y96.886
G1 X185.146 Y97.019
G1 X183.515 Y98.651 E.07163
G1 X183.381 Y98.785
G1 X182.848 Y98.785
G1 X182.981 Y98.651
G1 X185.146 Y96.486 E.09504
G1 X185.28 Y96.352
G1 X185.28 Y95.819
G1 X185.146 Y95.953
G1 X182.448 Y98.651 E.11845
G1 X182.314 Y98.785
G1 X181.781 Y98.785
G1 X181.915 Y98.651
G1 X185.146 Y95.42 E.14186
G1 X185.28 Y95.286
G1 X185.28 Y94.753
G1 X185.146 Y94.886
G1 X181.382 Y98.651 E.16527
G1 X181.248 Y98.785
G1 X180.848 Y98.652
G1 X180.981 Y98.518
G1 X185.146 Y94.353 E.18285
G1 X185.28 Y94.219
G1 X185.28 Y93.686
G1 X185.146 Y93.82
G1 X180.981 Y97.985 E.18285
G1 X180.848 Y98.119
G1 X180.848 Y97.585
G1 X180.981 Y97.452
G1 X185.146 Y93.286 E.18285
G1 X185.28 Y93.153
G1 X185.28 Y92.62
G1 X185.146 Y92.753
G1 X180.981 Y96.918 E.18285
G1 X180.848 Y97.052
G1 X180.848 Y96.519
G1 X180.981 Y96.385
G1 X185.146 Y92.22 E.18285
G1 X185.28 Y92.086
G1 X185.28 Y91.553
G1 X185.146 Y91.687
G1 X180.981 Y95.852 E.18285
G1 X180.848 Y95.986
G1 X180.848 Y95.452
G1 X180.981 Y95.319
G1 X185.146 Y91.153 E.18285
G1 X185.28 Y91.02
G1 X185.28 Y90.487
G1 X185.146 Y90.62
G1 X180.981 Y94.785 E.18285
G1 X180.848 Y94.919
G1 X180.848 Y94.386
G1 X180.981 Y94.252
G1 X185.146 Y90.087 E.18285
G1 X185.28 Y89.953
G1 X185.28 Y89.42
G1 X185.146 Y89.554
G1 X180.981 Y93.719 E.18285
G1 X180.848 Y93.853
G1 X180.848 Y93.319
G1 X180.981 Y93.186
G1 X184.681 Y89.486 E.16242
G1 X184.815 Y89.352
G1 X184.281 Y89.352
G1 X184.148 Y89.486
G1 X180.981 Y92.652 E.13901
G1 X180.848 Y92.786
G1 X180.848 Y92.253
G1 X180.981 Y92.119
G1 X183.614 Y89.486 E.1156
G1 X183.748 Y89.352
G1 X183.215 Y89.352
G1 X183.081 Y89.486
G1 X180.981 Y91.586 E.09219
G1 X180.848 Y91.72
G1 X180.848 Y91.186
G1 X180.981 Y91.053
G1 X182.548 Y89.486 E.06878
G1 X182.682 Y89.352
G1 X182.148 Y89.352
G1 X182.015 Y89.486
G1 X180.981 Y90.519 E.04537
G1 X180.848 Y90.653
G1 X180.848 Y90.12
G1 X180.981 Y89.986
G1 X181.481 Y89.486 E.02196
; WIPE_START
M204 S8000
G1 X180.981 Y89.986 E-.26885
G1 X180.848 Y90.12 E-.07182
G1 X180.848 Y90.223 E-.03933
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-.58 J-1.07 P1  F60000
G1 X171.542 Y95.268 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.42556
G1 F19600.67
M204 S8000
G1 X171.93 Y95.293 E.01223
; LINE_WIDTH: 0.35588
G1 F21000
G2 X173.754 Y95.318 I1.106 J-14.126 E.04703
M204 S10000
G1 X172.114 Y92.315 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X172.114 Y90.019 E.07695
G1 X158.514 Y90.019 E.45571
G1 X158.514 Y95.618 E.18764
G1 X162.81 Y95.618 E.14397
G3 X163.014 Y95.822 I0 J.204 E.01071
G1 X163.014 Y98.118 E.07695
G1 X176.614 Y98.118 E.45571
G1 X176.614 Y92.519 E.18764
G1 X172.317 Y92.519 E.14397
G3 X172.138 Y92.37 I-.015 J-.164 E.00867
M204 S10000
G1 X171.707 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X171.707 Y90.426 E.06331
G1 X158.921 Y90.426 E.42843
G1 X158.921 Y95.211 E.16036
G1 X162.81 Y95.211 E.13033
G3 X163.421 Y95.822 I0 J.611 E.03214
G1 X163.421 Y97.711 E.06331
G1 X176.207 Y97.711 E.42843
G1 X176.207 Y92.926 E.16036
G1 X172.317 Y92.926 E.13033
G3 X171.714 Y92.375 I-.002 J-.604 E.03007
M204 S10000
G1 X171.299 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X171.299 Y90.833 E.04967
G1 X159.328 Y90.833 E.40115
G1 X159.328 Y94.804 E.13308
G1 X162.81 Y94.804 E.11669
G3 X163.828 Y95.822 I-.018 J1.036 E.05332
G1 X163.828 Y97.304 E.04967
G1 X175.799 Y97.304 E.40115
G1 X175.799 Y93.333 E.13308
G1 X172.317 Y93.333 E.11669
G3 X171.312 Y92.374 I.012 J-1.019 E.05122
M204 S10000
G1 X170.892 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.892 Y91.24 E.03603
G1 X159.735 Y91.24 E.37387
G1 X159.735 Y94.397 E.10579
G1 X162.81 Y94.397 E.10305
G3 X164.235 Y95.822 I-.02 J1.445 E.07471
G1 X164.235 Y96.897 E.03603
G1 X175.392 Y96.897 E.37387
G1 X175.392 Y93.74 E.10579
G1 X172.317 Y93.74 E.10305
G3 X170.9 Y92.375 I.015 J-1.435 E.07267
M204 S10000
G1 X170.485 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.485 Y91.647 E.02239
G1 X160.142 Y91.647 E.34659
G1 X160.142 Y93.99 E.07851
G1 X162.81 Y93.99 E.08941
G3 X164.642 Y95.822 I-.026 J1.858 E.09606
G1 X164.642 Y96.49 E.02239
G1 X174.985 Y96.49 E.34659
G1 X174.985 Y94.147 E.07851
G1 X172.317 Y94.147 E.08941
G3 X170.492 Y92.375 I.021 J-1.847 E.09402
M204 S10000
G1 X170.078 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.078 Y92.054 E.00875
G1 X160.549 Y92.054 E.31931
G1 X160.549 Y93.583 E.05123
G1 X162.81 Y93.583 E.07577
G3 X165.049 Y96.083 I-.036 J2.285 E.1263
G1 X174.578 Y96.083 E.31931
G1 X174.578 Y94.554 E.05123
G1 X172.317 Y94.554 E.07577
G3 X170.085 Y92.375 I.027 J-2.26 E.11536
M204 S10000
G1 X169.689 Y92.461 F60000
G1 F18424.351
M204 S8000
G1 X160.956 Y92.461 E.29262
G1 X160.956 Y93.176 E.02395
G1 X162.81 Y93.176 E.06213
G3 X165.439 Y95.676 I-.026 J2.659 E.13376
G1 X174.171 Y95.676 E.29262
G1 X174.171 Y94.961 E.02395
G1 X172.317 Y94.961 E.06213
G3 X169.696 Y92.521 I.024 J-2.653 E.13173
M204 S10000
G1 X166.686 Y94.068 F60000
; LINE_WIDTH: 0.40814
G1 F20535.567
M204 S8000
G1 X168.382 Y94.068 E.051
M204 S10000
G1 X166.021 Y93.682 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G3 X166.412 Y94.455 I-1.827 J1.412 E.02919
G1 X169.107 Y94.455 E.0903
G3 X168.715 Y93.682 I1.827 J-1.412 E.02919
G1 X166.081 Y93.682 E.08829
M204 S10000
G1 X165.151 Y93.275 F60000
G1 F18424.351
M204 S8000
G3 X166.124 Y94.862 I-2.592 J2.682 E.06304
G1 X169.977 Y94.862 E.12911
G3 X169.004 Y93.275 I2.592 J-2.682 E.06304
G1 X165.211 Y93.275 E.1271
M204 S10000
G1 X163.586 Y92.868 F60000
; LINE_WIDTH: 0.450037
G1 F18422.236
M204 S8000
G3 X165.797 Y95.269 I-.764 J2.922 E.11554
G1 X171.542 Y95.268 E.19255
G3 X169.331 Y92.868 I.764 J-2.922 E.11554
G1 X163.646 Y92.868 E.19054
M204 S10000
G1 X161.314 Y92.818 F60000
; LINE_WIDTH: 0.35056
G1 F21000
M204 S8000
G1 X162.81 Y92.818 E.0379
; LINE_WIDTH: 0.37556
G1 X163.168 Y92.842 E.00981
; LINE_WIDTH: 0.42556
G1 F19600.67
G1 X163.526 Y92.865 E.01129
; COOLING_NODE: 0
; WIPE_START
G1 X163.168 Y92.842 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.029 J1.217 P1  F60000
G1 X189.166 Y92.216 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X189.166 Y89.671 E.08531
G1 X190.462 Y89.671 E.04343
G1 X190.462 Y92.216 E.08531
G1 X189.226 Y92.216 E.04141
; COOLING_NODE: 0
M204 S250
G1 X188.774 Y92.608 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X188.774 Y89.278 E.10337
G1 X190.854 Y89.278 E.06457
G1 X190.854 Y91.778 E.0776
G1 X198.354 Y91.778 E.23281
G1 X198.354 Y92.608 E.02576
G1 X188.834 Y92.608 E.29551
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X188.816 Y91.609 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-1.213 J.098 P1  F60000
G1 X189.166 Y95.921 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X190.462 Y95.921 E.04343
G1 X190.462 Y98.466 E.08531
G1 X189.166 Y98.466 E.04343
G1 X189.166 Y95.981 E.0833
; COOLING_NODE: 0
M204 S250
G1 X188.774 Y95.528 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P76 R6
G1 F1500
M204 S50
G1 X198.354 Y95.528 E.29737
G1 X198.354 Y96.358 E.02576
G1 X190.854 Y96.358 E.23281
G1 X190.854 Y98.858 E.0776
G1 X188.774 Y98.858 E.06457
G1 X188.774 Y95.588 E.1015
; WIPE_START
M204 S8000
G1 X189.774 Y95.582 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-1.184 J-.282 P1  F60000
G1 X189.592 Y96.346 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48732
G1 F15000
M204 S8000
G1 X189.592 Y98.041 E.06199
M73 P77 R6
G1 X190.036 Y98.041 E.01626
G1 X190.036 Y96.346 E.06199
G1 X189.652 Y96.346 E.01406
; WIPE_START
G1 X190.036 Y96.346 E-.14607
G1 X190.036 Y96.962 E-.23393
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I1.039 J.634 P1  F60000
G1 X190.658 Y95.943 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.48086
G1 F15000
M204 S8000
G1 X198.158 Y95.943 E.27038
; WIPE_START
G1 X197.158 Y95.943 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I1.176 J.314 P1  F60000
G1 X198.158 Y92.193 Z2
G1 Z1.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X190.658 Y92.193 E.27038
; WIPE_START
G1 X191.658 Y92.193 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.233 J-1.194 P1  F60000
G1 X189.592 Y91.791 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48732
G1 F15000
M204 S8000
G1 X190.036 Y91.791 E.01626
G1 X190.036 Y90.096 E.06199
G1 X189.592 Y90.096 E.01626
G1 X189.592 Y91.731 E.05979
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #13
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
; WIPE_START
M204 S8000
G1 X189.592 Y90.731 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I1.217 J0 P1  F60000
G1 X151.308 Y184.249
G1 Z1.6
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF0 NF1 ON2 NN0
M204 S8000
G1  X177.308 Y184.249  E2.0691 F7836
G1  Y185.749  E0.1194
G1  X151.308  E2.0691
; NOZZLE_CHANGE_END OF0 NF1 ON2 NN0
M400
M104 T0 S25 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S8000
G1 X152.308 Y185.749 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S10000
G17
G3 Z2 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O14
M620 S1A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4.6 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X149.058 Y195.999



M620.10 A0 F498.898 L0 H0.4 T240 P220 S1



M620.10 A1 F498.898 L0 H0.4 T180 P150 S1



M620.11 P1 I0 B-1 E-14 F623.623



M620.15 P180
M620.15 C140
M620.11 O1 T18


M620.11 K1 I0 B-1 R10 F623.623


M620.15 C140

M628 S1


M620.11 S1 L0 I0 B-1 R10 D8 E-14 F623.623


M629


;M620.11 H0




T1 H-1
M73 E1

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

;VM109 S150

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F10.4167 A0.4 R2


M400

G387 Y320 J1 F10000
G1 X183.06 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.6 F3000

M204 S8000


M621 S1A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y320 J1 F10000
G1 X183.06 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.6 F3000

M204 S8000

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I1 H-1 W1 ;enable ams air printing detect
M620 O14
M1002 gcode_claim_action : 0
M106 S51
M106 P2 S102
G1 X149.11 Y200.828 F600
M204 S1000
G1 Z1.6
G1 X146.555 Y200.828
G17
G3 Z2 I1.217 J0 P1
G1 X146.555 Y195.999 Z2

; filament start gcode
M109 S145;
G1 X151.058 Y195.999
G1 Z1.6
G1 E2.2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S25
G1  X154.058 Y195.999  E0.1140 F1782
G1 E-0.4000 F1800
M204 S1000
G1  X149.558  F600
G1  X151.058  F240
G1  X151.558  F600
G1  Y196.499 
G1  X150.558 
G1  Y195.499 
G1  X152.058 
G1  Y196.999 
G1  X150.058 
G1  Y194.999 
G1  X154.058 Y195.999   F1782
G1 E0.4000 F1800
M400
M104 T1 S150 N0
M204 S25
G1  X177.558  E0.8931 F1782
G1  Y195.249  E0.0285
G1  X151.058  E1.0072 F2025
G1  Y194.499  E0.0285
G1  X177.558  E1.0072 F2473
G1  Y193.749  E0.0285
M73 P78 R6
G1  X151.058  E1.0072 F4725
G1  Y192.999  E0.0285
G1  X177.558  E1.0072 F4775
G1  Y192.249  E0.0285
G1  X151.058  E1.0072
G1  Y191.499  E0.0285
G1  X177.558  E1.0072
G1  Y190.749  E0.0285
G1  X151.058  E1.0072
G1  Y189.999  E0.0285
G1  X177.558  E1.0072
G1  Y189.249  E0.0285
G1  X151.058  E1.0072
G1  Y188.499  E0.0285
G1  X177.558  E1.0072
G1  Y187.749  E0.0285
G1  X151.058  E1.0072
G1  Y186.999  E0.0285
G1  X177.558  E1.0072
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
G1 X176.558 Y186.999 E-.38
; WIPE_END
M73 P79 R6
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I1.217 J0 P1  F600
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S1000
G1 X144.452 Y90.966
G1 Z1.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
G1 X142.672 Y90.966 E.05965
G1 X142.672 Y89.671 E.04343
G1 X148.962 Y89.671 E.21077
G1 X148.962 Y98.466 E.29475
G1 X147.172 Y98.466 E.05997
G1 X147.172 Y90.966 E.25133
G1 X144.512 Y90.966 E.08914
; COOLING_NODE: 0
G1 X144.452 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X142.28 Y91.358 E.06742
G1 X142.28 Y89.278 E.06457
G1 X149.354 Y89.278 E.21958
G1 X149.354 Y98.858 E.29737
G1 X146.78 Y98.858 E.07989
G1 X146.78 Y91.358 E.23281
G1 X144.512 Y91.358 E.0704
; WIPE_START
G1 X143.512 Y91.358 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I.183 J1.203 P1  F600
G1 X148.613 Y90.584 Z2
M73 P80 R6
G1 Z1.6
G1 E.6 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.44999
G1 F600
M204 S25
G1 X148.613 Y90.019 E.01895
G1 X148.048 Y90.019 E.01895
; LINE_WIDTH: 0.474023
G1 X147.682 Y90.043 E.013
; LINE_WIDTH: 0.54518
G1 X143.068 Y90.067 E.19077
G1 X143.068 Y90.57 E.02081
G1 X147.317 Y90.57 E.17565
; LINE_WIDTH: 0.522088
G1 X147.414 Y90.664 E.00533
; LINE_WIDTH: 0.450193
G3 X147.52 Y90.822 I-.052 J.15 E.00683
G1 X147.52 Y98.118 E.24462
G1 X148.613 Y98.118 E.03665
G1 X148.613 Y90.644 E.25057
M204 S1000
G1 X148.229 Y90.584
; LINE_WIDTH: 0.387662
M204 S25
M73 P80 R5
G1 X148.229 Y90.403 E.00513
G1 X147.55 Y90.403 E.01927
G1 X147.876 Y90.64 E.01143
G1 X147.895 Y90.822 E.00518
G1 X147.895 Y97.743 E.19642
G1 X148.238 Y97.743 E.00973
G1 X148.231 Y90.644 E.20146
; COOLING_NODE: 0
; WIPE_START
G1 X148.232 Y91.644 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I-.469 J1.123 P1  F600
G1 X161.462 Y97.171 Z2
G1 Z1.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X161.462 Y98.466 E.04343
G1 X155.172 Y98.466 E.21077
G1 X155.172 Y89.671 E.29475
G1 X156.962 Y89.671 E.05997
G1 X156.962 Y97.171 E.25133
G1 X161.402 Y97.171 E.14879
; COOLING_NODE: 0
G1 X161.854 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X161.854 Y98.858 E.06457
G1 X154.78 Y98.858 E.21958
G1 X154.78 Y89.278 E.29737
G1 X157.354 Y89.278 E.07989
G1 X157.354 Y96.778 E.23281
G1 X161.794 Y96.778 E.13782
; COOLING_NODE: 0
; WIPE_START
G1 X161.823 Y97.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I.537 J1.092 P1  F600
G1 X175.672 Y90.966 Z2
G1 Z1.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X173.672 Y90.966 E.06702
G1 X173.672 Y89.671 E.04343
G1 X179.962 Y89.671 E.21077
G1 X179.962 Y98.466 E.29475
G1 X178.172 Y98.466 E.05997
G1 X178.172 Y90.966 E.25133
M73 P81 R5
G1 X175.732 Y90.966 E.08176
; COOLING_NODE: 0
G1 X175.672 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X173.28 Y91.358 E.07425
G1 X173.28 Y89.278 E.06457
G1 X180.354 Y89.278 E.21958
G1 X180.354 Y98.858 E.29737
G1 X177.78 Y98.858 E.07989
G1 X177.78 Y91.358 E.23281
G1 X175.732 Y91.358 E.06357
M204 S1000
G1 X174.068 Y90.57
; FEATURE: Sparse infill
; LINE_WIDTH: 0.54612
M204 S25
G1 X178.317 Y90.57 E.17598
; LINE_WIDTH: 0.522088
G1 X178.414 Y90.664 E.00533
; LINE_WIDTH: 0.450179
G3 X178.52 Y90.822 I-.052 J.15 E.00683
G1 X178.52 Y98.118 E.24462
G1 X179.613 Y98.118 E.03665
G1 X179.613 Y90.019 E.27153
G1 X179.048 Y90.019 E.01895
; LINE_WIDTH: 0.474023
G1 X178.682 Y90.043 E.013
; LINE_WIDTH: 0.544379
G1 X174.068 Y90.067 E.19047
G1 X174.068 Y90.51 E.0183
M204 S1000
G1 X178.55 Y90.403
; LINE_WIDTH: 0.387626
M204 S25
G1 X178.876 Y90.64 E.01143
G1 X178.895 Y90.822 E.00518
G1 X178.895 Y97.743 E.1964
G1 X179.238 Y97.743 E.00973
G1 X179.238 Y90.822 E.1964
G3 X179.229 Y90.403 I5.281 J-.328 E.01188
G1 X178.61 Y90.403 E.01756
; WIPE_START
G1 X179.229 Y90.403 E-.23517
G1 X179.238 Y90.784 E-.14484
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I-.426 J-1.14 P1  F600
G1 X161.065 Y97.567 Z2
G1 Z1.6
G1 E.6 F1800
; LINE_WIDTH: 0.54612
G1 F600
M204 S25
G1 X156.817 Y97.567 E.17598
; LINE_WIDTH: 0.522088
G1 X156.717 Y97.459 E.00582
; LINE_WIDTH: 0.450196
G3 X156.613 Y97.315 I.041 J-.138 E.00638
G1 X156.613 Y90.019 E.24463
G1 X155.52 Y90.019 E.03665
G1 X155.52 Y98.118 E.27154
G1 X156.086 Y98.118 E.01895
; LINE_WIDTH: 0.474023
G1 X156.451 Y98.094 E.013
; LINE_WIDTH: 0.544379
G1 X161.065 Y98.07 E.19047
G1 X161.065 Y97.627 E.0183
M204 S1000
G1 X156.584 Y97.734
; LINE_WIDTH: 0.387521
M204 S25
G1 X156.258 Y97.497 E.01143
G1 X156.238 Y97.315 E.00518
G1 X156.238 Y90.394 E.19634
G1 X155.895 Y90.394 E.00973
G2 X155.905 Y97.734 I163.186 J3.461 E.20823
G1 X156.524 Y97.734 E.01756
; COOLING_NODE: 0
; WIPE_START
G1 X155.905 Y97.734 E-.23517
G1 X155.904 Y97.353 E-.14483
; WIPE_END
M73 P82 R5
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I.006 J1.217 P1  F600
G1 X194.82 Y97.171 Z2
G1 Z1.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X197.968 Y97.171 E.10549
G1 X197.968 Y98.466 E.04343
G1 X191.672 Y98.466 E.21098
G1 X191.672 Y97.171 E.04343
G1 X194.76 Y97.171 E.10348
; COOLING_NODE: 0
G1 X194.82 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X198.36 Y96.778 E.10988
G1 X198.36 Y98.858 E.06457
G1 X191.28 Y98.858 E.21977
G1 X191.28 Y96.778 E.06457
G1 X194.76 Y96.778 E.10802
; COOLING_NODE: 0
; WIPE_START
G1 X195.76 Y96.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I.527 J-1.097 P1  F600
G1 X187.962 Y93.028 Z2
G1 Z1.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X187.962 Y93.421 E.01314
G1 X197.968 Y93.421 E.33531
G1 X197.968 Y94.716 E.04343
G1 X187.962 Y94.716 E.33531
G1 X187.962 Y98.466 E.12566
G1 X186.172 Y98.466 E.05997
G1 X186.172 Y89.671 E.29475
G1 X187.962 Y89.671 E.05997
G1 X187.962 Y92.968 E.11052
; COOLING_NODE: 0
G1 X188.354 Y93.028
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X198.36 Y93.028 E.3106
G1 X198.36 Y95.108 E.06457
G1 X188.354 Y95.108 E.3106
G1 X188.354 Y98.858 E.1164
G1 X185.78 Y98.858 E.07989
G1 X185.78 Y89.278 E.29737
G1 X188.354 Y89.278 E.07989
G1 X188.354 Y92.968 E.11454
; COOLING_NODE: 0
; WIPE_START
G1 X189.354 Y92.974 E-.38
; WIPE_END
M73 P83 R5
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I.42 J1.142 P1  F600
G1 X194.82 Y90.966 Z2
G1 Z1.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X191.672 Y90.966 E.10549
G1 X191.672 Y89.671 E.04343
G1 X197.968 Y89.671 E.21098
G1 X197.968 Y90.966 E.04343
G1 X194.88 Y90.966 E.10348
; COOLING_NODE: 0
G1 X194.82 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X191.28 Y91.358 E.10988
G1 X191.28 Y89.278 E.06457
G1 X198.36 Y89.278 E.21977
G1 X198.36 Y91.358 E.06457
G1 X194.88 Y91.358 E.10802
M204 S1000
G1 X192.098 Y90.541
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.487325
M204 S25
G1 X197.542 Y90.541 E.19917
G1 X197.542 Y90.096 E.01626
G1 X192.098 Y90.096 E.19917
G1 X192.098 Y90.481 E.01406
; WIPE_START
G1 X192.098 Y90.096 E-.14608
G1 X192.713 Y90.096 E-.23392
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I-1.072 J-.576 P1  F600
G1 X190.46 Y94.291 Z2
G1 Z1.6
G1 E.6 F1800
; LINE_WIDTH: 0.48733
G1 F600
M204 S25
G1 X197.542 Y94.291 E.25909
G1 X197.542 Y93.846 E.01626
M73 P83 R4
G1 X190.46 Y93.846 E.25909
G1 X190.46 Y94.231 E.01406
; WIPE_START
G1 X190.46 Y93.846 E-.14608
G1 X191.076 Y93.846 E-.23392
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I-1.174 J.32 P1  F600
G1 X192.098 Y97.596 Z2
G1 Z1.6
G1 E.6 F1800
; LINE_WIDTH: 0.48732
G1 F600
M204 S25
G1 X192.098 Y98.041 E.01626
G1 X197.542 Y98.041 E.19917
G1 X197.542 Y97.596 E.01626
G1 X192.158 Y97.596 E.19698
; WIPE_START
G1 X193.158 Y97.596 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I-.095 J-1.213 P1  F600
G1 X186.52 Y98.118 Z2
G1 Z1.6
G1 E.6 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.450552
G1 F600
M204 S25
G1 X187.613 Y98.118 E.03668
G1 X187.613 Y94.572 E.119
G1 X187.697 Y94.391 E.0067
; LINE_WIDTH: 0.494463
G1 X187.757 Y94.355 E.00258
; LINE_WIDTH: 0.545887
G1 X189.986 Y94.32 E.09231
G1 X189.986 Y93.817 E.02084
G1 X187.817 Y93.817 E.08981
; LINE_WIDTH: 0.528908
G1 X187.757 Y93.782 E.00278
; LINE_WIDTH: 0.494463
G1 X187.697 Y93.746 E.00258
; LINE_WIDTH: 0.450201
G1 X187.613 Y93.565 E.00669
G1 X187.613 Y90.019 E.1189
G1 X186.52 Y90.019 E.03665
G1 X186.52 Y98.058 E.26953
M204 S1000
G1 X186.895 Y97.743
; LINE_WIDTH: 0.38594
M204 S25
G1 X187.238 Y97.743 E.00969
G1 X187.238 Y94.572 E.08955
; LINE_WIDTH: 0.40704
G1 X187.28 Y94.385 E.00575
; LINE_WIDTH: 0.463221
G3 X187.459 Y94.068 I.322 J-.027 E.01335
G1 X187.322 Y93.94 E.00651
; LINE_WIDTH: 0.44924
G1 X187.28 Y93.752 E.00641
; LINE_WIDTH: 0.386529
G1 X187.238 Y90.394 E.09501
G1 X186.895 Y90.394 E.0097
G1 X186.895 Y93.565 E.0897
; LINE_WIDTH: 0.40704
G1 X186.916 Y93.817 E.00757
; LINE_WIDTH: 0.435174
G3 X186.895 Y94.572 I-2.245 J.315 E.0245
; LINE_WIDTH: 0.38594
G1 X186.895 Y97.683 E.08786
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 9/14
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
; OBJECT_ID: 756
; COOLING_NODE: 0
; WIPE_START
M73 P84 R4
G1 F600
G1 X186.895 Y96.683 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I-.015 J1.217 P1  F600
G1 X194.82 Y96.778 Z2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
G1 X198.36 Y96.778 E.10988
G1 X198.36 Y98.858 E.06457
G1 X191.28 Y98.858 E.21977
G1 X191.28 Y96.778 E.06457
G1 X194.76 Y96.778 E.10802
; COOLING_NODE: 0
; WIPE_START
G1 X195.76 Y96.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I.527 J-1.097 P1  F600
G1 X187.962 Y93.028 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X187.962 Y93.421 E.01314
G1 X189.986 Y93.421 E.06784
G1 X189.986 Y94.716 E.04343
G1 X187.962 Y94.716 E.06784
G1 X187.962 Y98.466 E.12566
G1 X186.172 Y98.466 E.05997
G1 X186.172 Y89.671 E.29475
G1 X187.962 Y89.671 E.05997
G1 X187.962 Y92.968 E.11052
; COOLING_NODE: 0
G1 X188.354 Y93.028
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X198.36 Y93.028 E.3106
G1 X198.36 Y95.108 E.06457
G1 X188.354 Y95.108 E.3106
G1 X188.354 Y98.858 E.1164
G1 X185.78 Y98.858 E.07989
G1 X185.78 Y89.278 E.29737
G1 X188.354 Y89.278 E.07989
G1 X188.354 Y92.968 E.11454
; COOLING_NODE: 0
; WIPE_START
G1 X189.354 Y92.974 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I.345 J1.167 P1  F600
G1 X194.82 Y91.358 Z2.2
G1 Z1.8
G1 E.6 F1800
G1 F600
M204 S25
G1 X191.28 Y91.358 E.10988
G1 X191.28 Y89.278 E.06457
G1 X198.36 Y89.278 E.21977
G1 X198.36 Y91.358 E.06457
G1 X194.88 Y91.358 E.10802
; WIPE_START
G1 X193.88 Y91.358 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I-.573 J1.074 P1  F600
G1 X197.397 Y93.236 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Top surface
G1 F600
M204 S25
G1 X198.153 Y93.992 E.03319
G1 X198.286 Y94.126
G1 X198.286 Y94.659
G1 X198.153 Y94.525
G1 X196.863 Y93.236 E.0566
G1 X196.73 Y93.102
G1 X196.196 Y93.102
G1 X196.33 Y93.236
M73 P85 R4
G1 X197.995 Y94.901 E.0731
G1 X198.129 Y95.035
G1 X197.596 Y95.035
G1 X197.462 Y94.901
G1 X195.797 Y93.236 E.0731
G1 X195.663 Y93.102
G1 X195.13 Y93.102
G1 X195.263 Y93.236
G1 X196.929 Y94.901 E.0731
G1 X197.062 Y95.035
G1 X196.529 Y95.035
G1 X196.395 Y94.901
G1 X194.73 Y93.236 E.0731
G1 X194.597 Y93.102
G1 X194.063 Y93.102
G1 X194.197 Y93.236
G1 X195.862 Y94.901 E.0731
G1 X195.996 Y95.035
G1 X195.463 Y95.035
G1 X195.329 Y94.901
G1 X193.664 Y93.236 E.0731
G1 X193.53 Y93.102
G1 X192.997 Y93.102
G1 X193.13 Y93.236
G1 X194.796 Y94.901 E.0731
G1 X194.929 Y95.035
G1 X194.396 Y95.035
G1 X194.262 Y94.901
G1 X192.597 Y93.236 E.0731
G1 X192.464 Y93.102
G1 X191.93 Y93.102
G1 X192.064 Y93.236
G1 X193.729 Y94.901 E.0731
G1 X193.863 Y95.035
G1 X193.33 Y95.035
G1 X193.196 Y94.901
G1 X191.531 Y93.236 E.0731
G1 X191.397 Y93.102
G1 X190.864 Y93.102
G1 X190.997 Y93.236
G1 X192.663 Y94.901 E.0731
G1 X192.796 Y95.035
G1 X192.263 Y95.035
G1 X192.129 Y94.901
G1 X190.464 Y93.236 E.0731
G1 X190.331 Y93.102
G1 X190.075 Y93.38
G1 X190.209 Y93.514
G1 X191.596 Y94.901 E.06091
G1 X191.73 Y95.035
G1 X191.197 Y95.035
G1 X191.063 Y94.901
G1 X190.209 Y94.047 E.0375
M204 S1000
G1 X189.56 Y94.068
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.488083
G1 F480
M204 S25
G1 X189.56 Y93.846 E.00814
G1 X187.739 Y93.846 E.06675
; LINE_WIDTH: 0.471763
G1 X187.672 Y93.79 E.00308
; LINE_WIDTH: 0.420191
G3 X187.57 Y93.624 I.081 J-.164 E.00638
G1 X187.57 Y90.063 E.11061
G1 X186.564 Y90.063 E.03123
G1 X186.564 Y98.074 E.24882
G1 X187.57 Y98.074 E.03123
G1 X187.57 Y94.513 E.11061
G1 X187.644 Y94.349 E.00559
; LINE_WIDTH: 0.485948
G1 X187.758 Y94.291 E.00468
G1 X189.56 Y94.291 E.06573
G1 X189.56 Y94.128 E.00592
M204 S1000
G1 X187.409 Y94.068 F600
; Slow Down Start
; LINE_WIDTH: 0.410715
;_EXTRUDE_SET_SPEED
M204 S25
G1 X187.352 Y94.125 E.00242
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.389457
;_EXTRUDE_SET_SPEED
G1 X187.295 Y94.181 E.00228
G1 X187.224 Y94.513 E.00969
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.35715
;_EXTRUDE_SET_SPEED
G1 X187.224 Y97.729 E.08318
G1 X186.91 Y97.729 E.00813
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.375005
;_EXTRUDE_SET_SPEED
G1 X186.91 Y96.121 E.04396
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.397976
;_EXTRUDE_SET_SPEED
G1 X186.91 Y94.513 E.047
G2 X186.91 Y93.624 I-2.747 J-.444 E.02609
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.35715
;_EXTRUDE_SET_SPEED
G1 X186.91 Y90.408 E.08318
G1 X187.224 Y90.408 E.00813
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.375005
;_EXTRUDE_SET_SPEED
G1 X187.224 Y92.016 E.04396
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.407602
;_EXTRUDE_SET_SPEED
G1 X187.224 Y93.624 E.04827
G1 X187.295 Y93.956 E.01019
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.42857
;_EXTRUDE_SET_SPEED
G1 X187.366 Y94.026 E.00317
; Slow Down End
; WIPE_START
G1 X187.295 Y93.956 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I-.399 J1.15 P1  F600
G1 X198.153 Y97.725 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F600
M204 S25
G1 X197.414 Y96.986 E.03244
G1 X197.28 Y96.852
G1 X196.747 Y96.852
G1 X196.88 Y96.986
G1 X198.153 Y98.258 E.05585
G1 X198.286 Y98.392
G1 X198.146 Y98.785
G1 X198.012 Y98.651
G1 X196.347 Y96.986 E.0731
G1 X196.214 Y96.852
G1 X195.68 Y96.852
G1 X195.814 Y96.986
G1 X197.479 Y98.651 E.0731
G1 X197.613 Y98.785
G1 X197.08 Y98.785
G1 X196.946 Y98.651
G1 X195.281 Y96.986 E.0731
G1 X195.147 Y96.852
G1 X194.614 Y96.852
G1 X194.747 Y96.986
G1 X196.413 Y98.651 E.0731
G1 X196.546 Y98.785
G1 X196.013 Y98.785
G1 X195.879 Y98.651
G1 X194.214 Y96.986 E.0731
G1 X194.081 Y96.852
G1 X193.547 Y96.852
G1 X193.681 Y96.986
G1 X195.346 Y98.651 E.0731
G1 X195.48 Y98.785
G1 X194.947 Y98.785
G1 X194.813 Y98.651
G1 X193.148 Y96.986 E.0731
G1 X193.014 Y96.852
G1 X192.481 Y96.852
G1 X192.614 Y96.986
G1 X194.28 Y98.651 E.0731
G1 X194.413 Y98.785
G1 X193.88 Y98.785
G1 X193.746 Y98.651
G1 X192.081 Y96.986 E.0731
G1 X191.948 Y96.852
G1 X191.414 Y96.852
G1 X191.548 Y96.986
G1 X193.213 Y98.651 E.0731
G1 X193.347 Y98.785
G1 X192.814 Y98.785
G1 X192.68 Y98.651
G1 X191.487 Y97.459 E.05235
G1 X191.354 Y97.325
G1 X191.354 Y97.858
G1 X191.487 Y97.992
G1 X192.147 Y98.651 E.02894
; WIPE_START
G1 X191.487 Y97.992 E-.35426
G1 X191.439 Y97.944 E-.02574
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I.917 J.801 P1  F600
G1 X198.153 Y90.259 Z2.2
G1 Z1.8
G1 E.6 F1800
G1 F600
M204 S25
G1 X197.379 Y89.486 E.03395
G1 X197.246 Y89.352
G1 X196.712 Y89.352
G1 X196.846 Y89.486
G1 X198.153 Y90.792 E.05736
G1 X198.286 Y90.926
G1 X198.112 Y91.285
G1 X197.978 Y91.151
G1 X196.313 Y89.486 E.0731
G1 X196.179 Y89.352
G1 X195.646 Y89.352
G1 X195.78 Y89.486
G1 X197.445 Y91.151 E.0731
G1 X197.578 Y91.285
G1 X197.045 Y91.285
G1 X196.912 Y91.151
G1 X195.246 Y89.486 E.0731
G1 X195.113 Y89.352
G1 X194.579 Y89.352
G1 X194.713 Y89.486
M73 P86 R4
G1 X196.378 Y91.151 E.0731
G1 X196.512 Y91.285
G1 X195.979 Y91.285
G1 X195.845 Y91.151
G1 X194.18 Y89.486 E.0731
G1 X194.046 Y89.352
G1 X193.513 Y89.352
G1 X193.647 Y89.486
G1 X195.312 Y91.151 E.0731
G1 X195.445 Y91.285
G1 X194.912 Y91.285
G1 X194.778 Y91.151
G1 X193.113 Y89.486 E.0731
G1 X192.98 Y89.352
G1 X192.446 Y89.352
G1 X192.58 Y89.486
G1 X194.245 Y91.151 E.0731
G1 X194.379 Y91.285
G1 X193.846 Y91.285
G1 X193.712 Y91.151
G1 X192.047 Y89.486 E.0731
G1 X191.913 Y89.352
G1 X191.38 Y89.352
G1 X191.513 Y89.486
G1 X193.179 Y91.151 E.0731
G1 X193.312 Y91.285
G1 X192.779 Y91.285
G1 X192.645 Y91.151
G1 X191.487 Y89.993 E.05084
G1 X191.354 Y89.859
G1 X191.354 Y90.393
G1 X191.487 Y90.526
G1 X192.112 Y91.151 E.02743
; COOLING_NODE: 0
; WIPE_START
G1 X191.487 Y90.526 E-.33577
G1 X191.405 Y90.444 E-.04424
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I-.267 J-1.187 P1  F600
G1 X161.462 Y97.171 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X161.462 Y98.466 E.04343
G1 X155.172 Y98.466 E.21077
G1 X155.172 Y89.671 E.29475
G1 X156.962 Y89.671 E.05997
G1 X156.962 Y97.171 E.25133
G1 X161.402 Y97.171 E.14879
; COOLING_NODE: 0
G1 X161.854 Y96.778
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X161.854 Y98.858 E.06457
G1 X154.78 Y98.858 E.21958
G1 X154.78 Y89.278 E.29737
G1 X157.354 Y89.278 E.07989
G1 X157.354 Y96.778 E.23281
G1 X161.794 Y96.778 E.13782
; COOLING_NODE: 0
; WIPE_START
G1 X161.823 Y97.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I.538 J1.092 P1  F600
G1 X175.643 Y90.966 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
M73 P86 R3
G1 X173.672 Y90.966 E.06605
G1 X173.672 Y89.671 E.04343
G1 X179.968 Y89.671 E.21098
G1 X179.968 Y98.466 E.29475
G1 X178.172 Y98.466 E.06018
G1 X178.172 Y90.966 E.25133
G1 X175.703 Y90.966 E.08274
; COOLING_NODE: 0
G1 X175.643 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X173.28 Y91.358 E.07335
M73 P87 R3
G1 X173.28 Y89.278 E.06457
G1 X180.36 Y89.278 E.21977
G1 X180.36 Y98.858 E.29737
G1 X177.78 Y98.858 E.08009
G1 X177.78 Y91.358 E.23281
G1 X175.703 Y91.358 E.06447
M204 S1000
G1 X174.068 Y90.57
; FEATURE: Sparse infill
; LINE_WIDTH: 0.54612
M204 S25
G1 X178.317 Y90.57 E.17598
; LINE_WIDTH: 0.522088
G1 X178.414 Y90.665 E.00535
; LINE_WIDTH: 0.450179
G3 X178.52 Y90.822 I-.052 J.15 E.00681
G1 X178.52 Y98.118 E.24462
G1 X179.62 Y98.118 E.03686
G1 X179.62 Y90.019 E.27153
G1 X179.052 Y90.019 E.01904
; LINE_WIDTH: 0.474023
G1 X178.684 Y90.043 E.01307
; LINE_WIDTH: 0.544371
G1 X174.068 Y90.067 E.19054
G1 X174.068 Y90.51 E.01829
M204 S1000
G1 X178.553 Y90.405
; LINE_WIDTH: 0.390689
M204 S25
G1 X178.878 Y90.642 E.01154
G1 X178.897 Y90.822 E.00516
G1 X178.897 Y97.742 E.1981
G1 X179.243 Y97.742 E.00991
G1 X179.243 Y90.822 E.1981
G3 X179.234 Y90.405 I5.343 J-.326 E.01195
G1 X178.613 Y90.405 E.01779
; WIPE_START
G1 X179.234 Y90.405 E-.2361
G1 X179.242 Y90.783 E-.1439
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I-.426 J-1.14 P1  F600
G1 X161.065 Y97.567 Z2.2
G1 Z1.8
G1 E.6 F1800
; LINE_WIDTH: 0.54612
G1 F600
M204 S25
G1 X156.817 Y97.567 E.17598
; LINE_WIDTH: 0.522088
G1 X156.717 Y97.459 E.00582
; LINE_WIDTH: 0.450196
G3 X156.613 Y97.315 I.041 J-.138 E.00638
G1 X156.613 Y90.019 E.24463
G1 X155.52 Y90.019 E.03665
G1 X155.52 Y98.118 E.27154
G1 X156.086 Y98.118 E.01895
; LINE_WIDTH: 0.474023
G1 X156.451 Y98.094 E.013
; LINE_WIDTH: 0.544379
G1 X161.065 Y98.07 E.19047
G1 X161.065 Y97.627 E.0183
M204 S1000
G1 X156.584 Y97.734
; LINE_WIDTH: 0.387521
M204 S25
G1 X156.258 Y97.497 E.01143
G1 X156.238 Y97.315 E.00518
G1 X156.238 Y90.394 E.19634
G1 X155.895 Y90.394 E.00973
G2 X155.905 Y97.734 I163.186 J3.461 E.20823
G1 X156.524 Y97.734 E.01756
; COOLING_NODE: 0
; WIPE_START
G1 X155.905 Y97.734 E-.23517
G1 X155.904 Y97.353 E-.14483
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I.594 J-1.062 P1  F600
G1 X144.48 Y90.966 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
M73 P88 R3
G1 X142.672 Y90.966 E.06059
G1 X142.672 Y89.671 E.04343
G1 X148.968 Y89.671 E.21098
G1 X148.968 Y98.466 E.29475
G1 X147.172 Y98.466 E.06018
G1 X147.172 Y90.966 E.25133
G1 X144.54 Y90.966 E.0882
; COOLING_NODE: 0
G1 X144.48 Y91.358
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X142.28 Y91.358 E.06829
G1 X142.28 Y89.278 E.06457
G1 X149.36 Y89.278 E.21977
G1 X149.36 Y98.858 E.29737
G1 X146.78 Y98.858 E.08009
G1 X146.78 Y91.358 E.23281
G1 X144.54 Y91.358 E.06953
; WIPE_START
G1 X143.54 Y91.358 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I.183 J1.203 P1  F600
G1 X148.62 Y90.587 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.44999
G1 F600
M204 S25
G1 X148.62 Y90.019 E.01903
G1 X148.052 Y90.019 E.01903
; LINE_WIDTH: 0.474023
G1 X147.684 Y90.043 E.01307
; LINE_WIDTH: 0.545176
G1 X143.068 Y90.067 E.19085
G1 X143.068 Y90.57 E.0208
G1 X147.317 Y90.57 E.17565
; LINE_WIDTH: 0.522088
G1 X147.414 Y90.665 E.00535
; LINE_WIDTH: 0.450193
G3 X147.52 Y90.822 I-.052 J.15 E.00681
G1 X147.52 Y98.118 E.24462
G1 X148.62 Y98.118 E.03686
M632 S0 N R W
M400
M104 T0 S210 N0 ;Multi extruder pre heating
M633
G1 X148.62 Y90.647 E.25049
M204 S1000
G1 X148.234 Y90.587
; LINE_WIDTH: 0.390723
M204 S25
G1 X148.234 Y90.405 E.00522
G1 X147.553 Y90.405 E.01951
G1 X147.878 Y90.642 E.01154
G1 X147.897 Y90.822 E.00517
G1 X147.897 Y97.742 E.19812
G1 X148.243 Y97.742 E.00991
G1 X148.236 Y90.647 E.20313
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
;--------------------
; CP TOOLCHANGE START
; toolchange #14
; material : PLA -> PLA
;--------------------
M220 B
M220 S100
; WIPE_TOWER_START
; WIPE_START
M204 S25
G1 X148.237 Y91.647 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I1.217 J0 P1  F600
G1 X151.308 Y178.999
G1 Z1.8
G1 E.6 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF1 NF0 ON0 NN2
M204 S25
G1  X177.308 Y178.999  E2.0691 F7836
; NOZZLE_CHANGE_END OF1 NF0 ON0 NN2
M400
M104 T1 S25 N0 ;Multi extruder pre cooling

; WIPE_START
M73 P89 R3
G1 F5400
M204 S25
G1 X176.308 Y178.999 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S1000
G17
G3 Z2.2 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O15
M620 S0A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4.8 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X149.058 Y180.249



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
G1 X183.06 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.8 F3000

M204 S25


M621 S0A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y320 J1 F10000
G1 X183.06 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.8 F3000

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I0 H-1 W1 ;enable ams air printing detect
M620 O15
M1002 gcode_claim_action : 0
M106 S153
M106 P2 S191
G1 X155.419 Y200.828 F60000
M204 S10000
G1 Z1.8
G17
G3 Z2.2 I0 J-1.217 P1
G1 X146.555 Y200.828 Z2.2
G1 X146.555 Y180.249

; filament start gcode
G1 X151.058 Y180.249
G1 Z1.8
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X154.058 Y180.249  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X149.558  F600
G1  X151.058  F240
G1  X151.558  F600
G1  Y180.749 
G1  X150.558 
G1  Y179.749 
G1  X152.058 
G1  Y181.249 
G1  X150.058 
G1  Y179.249 
G1  X154.058 Y180.249   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X177.558  E0.8931 F1782
G1  Y180.999  E0.0285
G1  X151.058  E1.0072 F2025
G1  Y181.749  E0.0285
M73 P90 R3
G1  X177.558  E1.0072 F2473
G1  Y182.499  E0.0285
G1  X151.058  E1.0072 F4725
G1  Y183.249  E0.0285
M73 P90 R2
G1  X177.558  E1.0072 F4775
G1  Y183.999  E0.0285
G1  X151.058  E1.0072
G1  Y184.749  E0.0285
G1  X177.558  E1.0072
G1  Y185.499  E0.0285
G1  X151.058  E1.0072
G1  Y186.249  E0.0285
G1  X177.558  E1.0072
G1  Y186.999  E0.0285
G1  X151.058  E1.0072
G1  Y187.749  E0.0285
G1  X177.558  E1.0072
G1  Y188.499  E0.0285
G1  X151.058  E1.0072
G1  Y189.249  E0.0285
G1  X177.558  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y188.999   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X178.058 Y190.249  
M204 S8000
G2  X177.339 Y190.557   I-0.276 J0.349 E0.0363
G1  X177.353 Y190.576   E0.0009
G3  X179.735 Y192.964   I-6.374 J8.738 E0.1287
G3  X179.432 Y195.296   I-1.788 J0.953 E0.0953
G3  X176.451 Y198.413   I-18.599 J-14.802 E0.1641
G3  X173.857 Y198.282   I-1.219 J-1.610 E0.1072
G2  X165.946 Y190.812   I-102.603 J100.743 E0.4136
G2  X162.527 Y190.938   I-1.635 J2.088 E0.1413
G1  X154.759 Y198.282   E0.4063
G3  X151.932 Y198.202   I-1.373 J-1.475 E0.1192
G3  X148.987 Y195.051   I15.823 J-17.741 E0.1641
G3  X149.263 Y192.468   I1.676 J-1.127 E0.1072
G2  X151.277 Y190.557   I-5.832 J-8.159 E0.1059
G1  X151.133 Y190.250   E0.0129
G2  X150.558 Y190.249   I-0.299 J4.803 E0.0219
G1  Y181.499  E0.3326
G1 E-0.4000 F1800
M204 S10000
G1  Y178.999  F600
G1 E0.4000 F1800
M204 S8000
G1  Y178.249  E0.0285 F5400
G2  X151.960 Y178.118   I0.553 J-1.647 E0.0551
G2  X151.938 Y177.559   I-0.299 J-0.268 E0.0235
G3  X148.962 Y174.669   I10.719 J-14.017 E0.1580
G3  X149.184 Y172.202   I1.682 J-1.092 E0.1014
G3  X152.165 Y169.085   I18.593 J14.797 E0.1641
G3  X154.759 Y169.216   I1.219 J1.610 E0.1072
G1  X159.715 Y173.902   E0.2592
G2  X163.103 Y177.072   I19.728 J-17.690 E0.1766
G2  X165.761 Y176.870   I1.203 J-1.766 E0.1094
G1  X173.857 Y169.216   E0.4234
G3  X176.684 Y169.296   I1.373 J1.475 E0.1192
G3  X179.629 Y172.447   I-15.816 J17.735 E0.1641
G3  X179.353 Y175.030   I-1.676 J1.127 E0.1072
G2  X176.645 Y177.593   I20.164 J24.007 E0.1418
G2  X176.953 Y178.249   I0.308 J0.255 E0.0344
G1  X178.058  E0.0420
G1  Y190.249  E0.4561
; WIPE_TOWER_END

; WIPE_START
M204 S8000
G1 X178.058 Y189.249 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I1.217 J0 P1  F60000
; OBJECT_ID: 756
; COOLING_NODE: 0
M204 S10000
G1 X189.166 Y92.216
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1500
M204 S50
G1 X189.166 Y89.671 E.08531
G1 X190.462 Y89.671 E.04343
G1 X190.462 Y92.216 E.08531
G1 X189.226 Y92.216 E.04141
; COOLING_NODE: 0
M204 S250
G1 X188.774 Y92.608 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X188.774 Y89.278 E.10337
G1 X190.854 Y89.278 E.06457
G1 X190.854 Y91.778 E.0776
G1 X198.354 Y91.778 E.23281
G1 X198.354 Y92.608 E.02576
G1 X188.834 Y92.608 E.29551
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X188.816 Y91.609 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-1.213 J.098 P1  F60000
G1 X189.166 Y95.921 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X190.462 Y95.921 E.04343
G1 X190.462 Y98.466 E.08531
G1 X189.166 Y98.466 E.04343
G1 X189.166 Y95.981 E.0833
; COOLING_NODE: 0
M204 S250
G1 X188.774 Y95.528 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X198.354 Y95.528 E.29737
G1 X198.354 Y96.358 E.02576
G1 X190.854 Y96.358 E.23281
G1 X190.854 Y98.858 E.0776
G1 X188.774 Y98.858 E.06457
G1 X188.774 Y95.588 E.1015
; WIPE_START
M204 S8000
G1 X189.774 Y95.582 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-1.184 J-.282 P1  F60000
G1 X189.592 Y96.346 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48732
G1 F15000
M204 S8000
G1 X189.592 Y98.041 E.06199
G1 X190.036 Y98.041 E.01626
G1 X190.036 Y96.346 E.06199
G1 X189.652 Y96.346 E.01406
; WIPE_START
G1 X190.036 Y96.346 E-.14607
G1 X190.036 Y96.962 E-.23393
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I1.039 J.634 P1  F60000
G1 X190.658 Y95.943 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.48086
G1 F15000
M204 S8000
G1 X198.158 Y95.943 E.27038
; WIPE_START
G1 X197.158 Y95.943 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I1.176 J.314 P1  F60000
G1 X198.158 Y92.193 Z2.2
G1 Z1.8
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X190.658 Y92.193 E.27038
; WIPE_START
G1 X191.658 Y92.193 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.233 J-1.194 P1  F60000
G1 X189.592 Y91.791 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48732
G1 F15000
M204 S8000
G1 X190.036 Y91.791 E.01626
G1 X190.036 Y90.096 E.06199
G1 X189.592 Y90.096 E.01626
G1 X189.592 Y91.731 E.05979
; COOLING_NODE: 0
; WIPE_START
G1 X189.592 Y90.731 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-.232 J-1.195 P1  F60000
G1 X162.666 Y95.966 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X158.166 Y95.966 E.1508
G1 X158.166 Y89.671 E.21098
G1 X172.462 Y89.671 E.47906
G1 X172.462 Y92.171 E.08378
G1 X176.962 Y92.171 E.1508
G1 X176.962 Y98.466 E.21098
G1 X162.666 Y98.466 E.47906
G1 X162.666 Y96.026 E.08177
; COOLING_NODE: 0
M204 S250
G1 X162.274 Y96.358 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X157.774 Y96.358 E.13968
G1 X157.774 Y89.278 E.21977
G1 X172.854 Y89.278 E.4681
G1 X172.854 Y91.778 E.0776
M73 P91 R2
G1 X177.354 Y91.778 E.13968
G1 X177.354 Y98.858 E.21977
G1 X162.274 Y98.858 E.4681
G1 X162.274 Y96.418 E.07574
; WIPE_START
M204 S8000
G1 X161.274 Y96.405 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.134 J1.21 P1  F60000
G1 X171.542 Y95.268 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.42556
G1 F19600.67
M204 S8000
G1 X171.93 Y95.293 E.01223
; LINE_WIDTH: 0.35588
G1 F21000
G2 X173.754 Y95.318 I1.106 J-14.126 E.04703
M204 S10000
G1 X172.114 Y92.315 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X172.114 Y90.019 E.07695
G1 X158.514 Y90.019 E.45571
G1 X158.514 Y95.618 E.18764
G1 X162.81 Y95.618 E.14397
G3 X163.014 Y95.822 I0 J.204 E.01071
G1 X163.014 Y98.118 E.07695
G1 X176.614 Y98.118 E.45571
G1 X176.614 Y92.519 E.18764
G1 X172.317 Y92.519 E.14397
G3 X172.138 Y92.37 I-.015 J-.164 E.00867
M204 S10000
G1 X171.707 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X171.707 Y90.426 E.06331
G1 X158.921 Y90.426 E.42843
G1 X158.921 Y95.211 E.16036
G1 X162.81 Y95.211 E.13033
G3 X163.421 Y95.822 I0 J.611 E.03214
G1 X163.421 Y97.711 E.06331
G1 X176.207 Y97.711 E.42843
G1 X176.207 Y92.926 E.16036
G1 X172.317 Y92.926 E.13033
G3 X171.714 Y92.375 I-.002 J-.604 E.03007
M204 S10000
G1 X171.299 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X171.299 Y90.833 E.04967
G1 X159.328 Y90.833 E.40115
G1 X159.328 Y94.804 E.13308
G1 X162.81 Y94.804 E.11669
G3 X163.828 Y95.822 I-.018 J1.036 E.05332
G1 X163.828 Y97.304 E.04967
G1 X175.799 Y97.304 E.40115
G1 X175.799 Y93.333 E.13308
G1 X172.317 Y93.333 E.11669
G3 X171.312 Y92.374 I.012 J-1.019 E.05122
M204 S10000
G1 X170.892 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.892 Y91.24 E.03603
G1 X159.735 Y91.24 E.37387
G1 X159.735 Y94.397 E.10579
G1 X162.81 Y94.397 E.10305
G3 X164.235 Y95.822 I-.02 J1.445 E.07471
G1 X164.235 Y96.897 E.03603
G1 X175.392 Y96.897 E.37387
G1 X175.392 Y93.74 E.10579
G1 X172.317 Y93.74 E.10305
G3 X170.9 Y92.375 I.015 J-1.435 E.07267
M204 S10000
G1 X170.485 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.485 Y91.647 E.02239
G1 X160.142 Y91.647 E.34659
G1 X160.142 Y93.99 E.07851
G1 X162.81 Y93.99 E.08941
G3 X164.642 Y95.822 I-.026 J1.858 E.09606
G1 X164.642 Y96.49 E.02239
G1 X174.985 Y96.49 E.34659
G1 X174.985 Y94.147 E.07851
G1 X172.317 Y94.147 E.08941
G3 X170.492 Y92.375 I.021 J-1.847 E.09402
M204 S10000
G1 X170.078 Y92.315 F60000
G1 F18424.351
M204 S8000
G1 X170.078 Y92.054 E.00875
G1 X160.549 Y92.054 E.31931
G1 X160.549 Y93.583 E.05123
G1 X162.81 Y93.583 E.07577
G3 X165.049 Y96.083 I-.036 J2.285 E.1263
G1 X174.578 Y96.083 E.31931
G1 X174.578 Y94.554 E.05123
G1 X172.317 Y94.554 E.07577
G3 X170.085 Y92.375 I.027 J-2.26 E.11536
M204 S10000
G1 X169.689 Y92.461 F60000
G1 F18424.351
M204 S8000
G1 X160.956 Y92.461 E.29262
G1 X160.956 Y93.176 E.02395
G1 X162.81 Y93.176 E.06213
G3 X165.439 Y95.676 I-.026 J2.659 E.13376
G1 X174.171 Y95.676 E.29262
G1 X174.171 Y94.961 E.02395
G1 X172.317 Y94.961 E.06213
G3 X169.696 Y92.521 I.024 J-2.653 E.13173
M204 S10000
G1 X166.686 Y94.068 F60000
; LINE_WIDTH: 0.40814
G1 F20535.567
M204 S8000
G1 X168.382 Y94.068 E.051
M204 S10000
G1 X166.021 Y93.682 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G3 X166.412 Y94.455 I-1.827 J1.412 E.02919
G1 X169.107 Y94.455 E.0903
G3 X168.715 Y93.682 I1.827 J-1.412 E.02919
G1 X166.081 Y93.682 E.08829
M204 S10000
G1 X165.151 Y93.275 F60000
G1 F18424.351
M204 S8000
G3 X166.124 Y94.862 I-2.592 J2.682 E.06304
G1 X169.977 Y94.862 E.12911
G3 X169.004 Y93.275 I2.592 J-2.682 E.06304
G1 X165.211 Y93.275 E.1271
M204 S10000
G1 X163.586 Y92.868 F60000
; LINE_WIDTH: 0.450037
G1 F18422.236
M204 S8000
G3 X165.797 Y95.269 I-.764 J2.922 E.11554
G1 X171.542 Y95.268 E.19255
G3 X169.331 Y92.868 I.764 J-2.922 E.11554
G1 X163.646 Y92.868 E.19054
M204 S10000
G1 X161.314 Y92.818 F60000
; LINE_WIDTH: 0.35056
G1 F21000
M204 S8000
G1 X162.81 Y92.818 E.0379
; LINE_WIDTH: 0.37556
G1 X163.168 Y92.842 E.00981
; LINE_WIDTH: 0.42556
G1 F19600.67
G1 X163.526 Y92.865 E.01129
; COOLING_NODE: 0
; WIPE_START
G1 X163.168 Y92.842 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.043 J-1.216 P1  F60000
G1 X144.104 Y92.171 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X145.962 Y92.171 E.06226
G1 X145.962 Y98.466 E.21098
G1 X137.166 Y98.466 E.29475
G1 X137.166 Y89.671 E.29475
G1 X141.462 Y89.671 E.14396
G1 X141.462 Y92.171 E.08378
G1 X144.044 Y92.171 E.08653
; COOLING_NODE: 0
M204 S250
G1 X144.104 Y91.778 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X146.354 Y91.778 E.06984
G1 X146.354 Y98.858 E.21977
G1 X136.774 Y98.858 E.29737
G1 X136.774 Y89.278 E.29737
G1 X141.854 Y89.278 E.15769
G1 X141.854 Y91.778 E.0776
G1 X144.044 Y91.778 E.06798
; WIPE_START
M204 S8000
G1 X145.044 Y91.778 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-.727 J-.976 P1  F60000
G1 X140.386 Y95.246 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.470827
G1 F17527.185
M204 S8000
G1 X140.696 Y95.27 E.01097
; LINE_WIDTH: 0.42272
G1 F19747.235
G1 X141.007 Y95.294 E.00973
; LINE_WIDTH: 0.354844
G1 F21000
G2 X142.754 Y95.318 I1.029 J-11.256 E.04491
M204 S10000
G1 X143.171 Y95.318 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X143.171 Y94.961 E.01197
G1 X141.317 Y94.961 E.06213
G3 X139.956 Y94.575 I-.018 J-2.527 E.04803
G1 X139.956 Y95.676 E.03688
G1 X143.171 Y95.676 E.10772
G1 X143.171 Y95.378 E.00996
M204 S10000
G1 X143.578 Y95.318 F60000
G1 F18424.351
M204 S8000
G1 X143.578 Y94.554 E.02562
G1 X141.317 Y94.554 E.07577
G3 X139.549 Y93.662 I-.009 J-2.18 E.06887
G1 X139.549 Y96.083 E.08111
G1 X143.578 Y96.083 E.135
G1 X143.578 Y95.378 E.02361
M204 S10000
G1 X143.985 Y95.318 F60000
; LINE_WIDTH: 0.445947
G1 F18609.169
M204 S8000
G1 X143.985 Y94.147 E.03887
G1 X141.317 Y94.147 E.08852
G3 X139.521 Y92.63 I.052 J-1.883 E.08422
G3 X139.501 Y91.631 I20.453 J-.905 E.03316
G1 X139.126 Y91.631 E.01244
G3 X139.142 Y96.49 I-729.634 J4.838 E.16121
G1 X143.985 Y96.49 E.16067
G1 X143.985 Y95.378 E.03688
M204 S10000
G1 X144.392 Y95.318 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X144.392 Y93.74 E.0529
G1 X141.317 Y93.74 E.10305
G3 X139.892 Y92.315 I.041 J-1.466 E.07444
G1 X139.892 Y91.24 E.03603
G1 X138.735 Y91.24 E.03877
G1 X138.735 Y96.897 E.18957
G1 X144.392 Y96.897 E.18957
G1 X144.392 Y95.378 E.05089
M204 S10000
G1 X144.799 Y95.318 F60000
G1 F18424.351
M204 S8000
G1 X144.799 Y93.333 E.06654
G1 X141.317 Y93.333 E.11669
G3 X140.299 Y92.315 I.029 J-1.047 E.05317
G1 X140.299 Y90.833 E.04967
G1 X138.328 Y90.833 E.06606
G1 X138.328 Y97.304 E.21685
G1 X144.799 Y97.304 E.21685
G1 X144.799 Y95.378 E.06453
M204 S10000
G1 X145.206 Y95.318 F60000
G1 F18424.351
M204 S8000
G1 X145.206 Y92.926 E.08018
G1 X141.317 Y92.926 E.13033
G3 X140.716 Y92.421 I.02 J-.634 E.02838
G3 X140.706 Y90.426 I65.427 J-1.299 E.06685
G1 X137.921 Y90.426 E.09334
G1 X137.921 Y97.711 E.24413
G1 X145.206 Y97.711 E.24413
G1 X145.206 Y95.378 E.07817
M204 S10000
G1 X145.614 Y95.318 F60000
G1 F18424.351
M204 S8000
G1 X145.614 Y92.519 E.09382
G1 X141.317 Y92.519 E.14397
G3 X141.114 Y92.315 I0 J-.204 E.01071
G1 X141.114 Y90.019 E.07695
G1 X137.514 Y90.019 E.12062
G1 X137.514 Y98.118 E.27141
G1 X145.614 Y98.118 E.27141
G1 X145.614 Y95.378 E.09181
; WIPE_START
G1 X145.614 Y96.378 E-.38
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
    

    

    
        M9711 M0 E0 U266 V97 Z2.2 S11 C10 O0 T3000
    

    
    
    
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
M106 S196.35
; OBJECT_ID: 756
; COOLING_NODE: 0
G1 X148.962 Y89.671 F60000
G1 Z2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1500
M204 S50
G1 X148.962 Y98.466 E.29475
G1 X147.552 Y98.466 E.04723
G1 X147.152 Y98.466 E.0134
G1 X146.752 Y98.466 E.0134
G1 X146.381 Y98.466 E.01243
G1 X145.981 Y98.466 E.0134
G1 X145.581 Y98.466 E.0134
G1 X137.166 Y98.466 E.28201
G1 X137.166 Y89.671 E.29475
G1 X141.081 Y89.671 E.13121
G1 X141.481 Y89.671 E.0134
G1 X141.881 Y89.671 E.0134
G1 X142.252 Y89.671 E.01243
G1 X142.652 Y89.671 E.0134
G1 X143.052 Y89.671 E.0134
G1 X148.902 Y89.671 E.19601
; COOLING_NODE: 0
M204 S250
G1 X149.354 Y89.278 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X149.354 Y98.858 E.29737
G1 X147.539 Y98.858 E.05634
G1 X147.139 Y98.858 E.01242
G1 X146.739 Y98.858 E.01242
G1 X146.395 Y98.858 E.01068
G1 X145.995 Y98.858 E.01242
G1 X145.595 Y98.858 E.01242
G1 X136.774 Y98.858 E.27381
G1 X136.774 Y89.278 E.29737
G1 X141.095 Y89.278 E.13413
G1 X141.495 Y89.278 E.01242
G1 X141.895 Y89.278 E.01242
M73 P92 R2
G1 X142.239 Y89.278 E.01068
G1 X142.639 Y89.278 E.01242
G1 X143.039 Y89.278 E.01242
G1 X149.294 Y89.278 E.19416
; WIPE_START
M204 S8000
G1 X149.3 Y90.278 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I-1.202 J-.191 P1  F60000
G1 X148.025 Y98.303 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42539
G1 F15000
M204 S8000
G1 X148.629 Y97.699 E.02689
G1 X148.629 Y97.158 E.01703
G1 X147.653 Y98.133 E.04342
G1 X147.112 Y98.133 E.01703
G1 X148.629 Y96.617 E.06751
G1 X148.629 Y96.076 E.01703
G1 X146.572 Y98.133 E.09159
G1 X146.031 Y98.133 E.01703
G1 X148.629 Y95.535 E.11567
G1 X148.629 Y94.994 E.01703
G1 X145.49 Y98.133 E.13976
G1 X144.949 Y98.133 E.01703
G1 X148.629 Y94.454 E.16384
G1 X148.629 Y93.913 E.01703
G1 X144.408 Y98.133 E.18793
G1 X143.867 Y98.133 E.01703
G1 X148.629 Y93.372 E.21201
G1 X148.629 Y92.831 E.01703
G1 X143.326 Y98.133 E.23609
G1 X142.785 Y98.133 E.01703
G1 X148.629 Y92.29 E.26018
G1 X148.629 Y91.749 E.01703
G1 X142.244 Y98.133 E.28426
G1 X141.703 Y98.133 E.01703
G1 X148.629 Y91.208 E.30834
G1 X148.629 Y90.667 E.01703
G1 X141.163 Y98.133 E.33243
G1 X140.622 Y98.133 E.01703
G1 X148.629 Y90.126 E.35651
G1 X148.629 Y90.004 E.00386
G1 X148.21 Y90.004 E.01317
G1 X140.081 Y98.133 E.36198
G1 X139.54 Y98.133 E.01703
G1 X147.669 Y90.004 E.36198
G1 X147.129 Y90.004 E.01703
G1 X138.999 Y98.133 E.36198
G1 X138.458 Y98.133 E.01703
G1 X146.588 Y90.004 E.36198
G1 X146.047 Y90.004 E.01703
G1 X137.917 Y98.133 E.36198
G1 X137.499 Y98.133 E.01317
G1 X137.499 Y98.011 E.00386
G1 X145.506 Y90.004 E.35651
G1 X144.965 Y90.004 E.01703
G1 X137.499 Y97.47 E.33243
G1 X137.499 Y96.929 E.01703
G1 X144.424 Y90.004 E.30835
G1 X143.883 Y90.004 E.01703
G1 X137.499 Y96.388 E.28426
G1 X137.499 Y95.847 E.01703
G1 X143.342 Y90.004 E.26018
G1 X142.801 Y90.004 E.01703
G1 X137.499 Y95.306 E.23609
G1 X137.499 Y94.765 E.01703
G1 X142.261 Y90.004 E.21201
G1 X141.72 Y90.004 E.01703
G1 X137.499 Y94.224 E.18793
G1 X137.499 Y93.683 E.01703
G1 X141.179 Y90.004 E.16384
G1 X140.638 Y90.004 E.01703
G1 X137.499 Y93.143 E.13976
G1 X137.499 Y92.602 E.01703
G1 X140.097 Y90.004 E.11568
G1 X139.556 Y90.004 E.01703
G1 X137.499 Y92.061 E.09159
G1 X137.499 Y91.52 E.01703
G1 X139.015 Y90.004 E.06751
G1 X138.474 Y90.004 E.01703
G1 X137.499 Y90.979 E.04342
G1 X137.499 Y90.438 E.01703
G1 X138.103 Y89.834 E.0269
; COOLING_NODE: 0
; WIPE_START
G1 X137.499 Y90.438 E-.32461
G1 X137.499 Y90.584 E-.05539
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I.063 J1.215 P1  F60000
G1 X155.166 Y89.671 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3000
M204 S50
G1 X172.081 Y89.671 E.56685
G1 X172.481 Y89.671 E.0134
G1 F2501.458
G1 X172.881 Y89.671 E.0134
G1 F1920
G1 X173.252 Y89.671 E.01243
G1 F2501.458
G1 X173.652 Y89.671 E.0134
G1 F3000
G1 X174.052 Y89.671 E.0134
G1 X179.962 Y89.671 E.19802
G1 X179.962 Y98.466 E.29475
G1 X178.552 Y98.466 E.04723
G1 X178.152 Y98.466 E.0134
G1 F2501.458
G1 X177.752 Y98.466 E.0134
G1 F1920
G1 X177.381 Y98.466 E.01243
G1 F2501.458
G1 X176.981 Y98.466 E.0134
G1 F3000
G1 X176.581 Y98.466 E.0134
G1 X155.166 Y98.466 E.71764
G1 X155.166 Y89.731 E.29274
; COOLING_NODE: 0
M204 S250
G1 X154.774 Y89.278 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1784
M204 S50
G1 X172.095 Y89.278 E.53766
G1 X172.495 Y89.278 E.01242
G1 X172.895 Y89.278 E.01242
G1 X173.239 Y89.278 E.01068
G1 X173.639 Y89.278 E.01242
G1 X174.039 Y89.278 E.01242
G1 X180.354 Y89.278 E.19602
G1 X180.354 Y98.858 E.29737
G1 X178.539 Y98.858 E.05634
G1 X178.139 Y98.858 E.01242
G1 X177.739 Y98.858 E.01242
G1 X177.395 Y98.858 E.01068
G1 X176.995 Y98.858 E.01242
G1 X176.595 Y98.858 E.01242
G1 X154.774 Y98.858 E.67734
G1 X154.774 Y89.338 E.29551
; WIPE_START
G1 F3000
M204 S8000
G1 X155.774 Y89.335 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I-1.015 J.671 P1  F60000
G1 X156.104 Y89.834 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F15000
M204 S8000
G1 X155.499 Y90.439 E.02695
G1 X155.499 Y90.98 E.01705
G1 X156.475 Y90.004 E.0435
G1 X157.017 Y90.004 E.01705
G1 X155.499 Y91.521 E.06761
G1 X155.499 Y92.062 E.01705
G1 X157.558 Y90.004 E.09172
G1 X158.099 Y90.004 E.01705
G1 X155.499 Y92.604 E.11583
G1 X155.499 Y93.145 E.01705
G1 X158.64 Y90.004 E.13994
G1 X159.181 Y90.004 E.01705
G1 X155.499 Y93.686 E.16405
G1 X155.499 Y94.227 E.01705
G1 X159.723 Y90.004 E.18816
G1 X160.264 Y90.004 E.01705
G1 X155.499 Y94.768 E.21227
G1 X155.499 Y95.31 E.01705
G1 X160.805 Y90.004 E.23638
G1 X161.346 Y90.004 E.01705
G1 X155.499 Y95.851 E.26049
G1 X155.499 Y96.392 E.01705
G1 X161.887 Y90.004 E.2846
G1 X162.429 Y90.004 E.01705
G1 X155.499 Y96.933 E.30871
G1 X155.499 Y97.474 E.01705
G1 X162.97 Y90.004 E.33282
G1 X163.511 Y90.004 E.01705
G1 X155.499 Y98.016 E.35693
G1 X155.499 Y98.133 E.00371
G1 X155.923 Y98.133 E.01334
G1 X164.052 Y90.004 E.36217
G1 X164.593 Y90.004 E.01705
G1 X156.464 Y98.133 E.36217
G1 X157.005 Y98.133 E.01705
G1 X165.134 Y90.004 E.36217
G1 X165.676 Y90.004 E.01705
G1 X157.546 Y98.133 E.36217
G1 X158.087 Y98.133 E.01705
G1 X166.217 Y90.004 E.36217
G1 X166.758 Y90.004 E.01705
G1 X158.628 Y98.133 E.36217
G1 X159.17 Y98.133 E.01705
G1 X167.299 Y90.004 E.36217
G1 X167.84 Y90.004 E.01705
G1 X159.711 Y98.133 E.36217
G1 X160.252 Y98.133 E.01705
G1 X168.382 Y90.004 E.36217
G1 X168.923 Y90.004 E.01705
G1 X160.793 Y98.133 E.36217
G1 X161.334 Y98.133 E.01705
G1 X169.464 Y90.004 E.36217
G1 X170.005 Y90.004 E.01705
G1 X161.876 Y98.133 E.36217
G1 X162.417 Y98.133 E.01705
G1 X170.546 Y90.004 E.36217
G1 X171.088 Y90.004 E.01705
G1 X162.958 Y98.133 E.36217
G1 X163.499 Y98.133 E.01705
G1 X171.629 Y90.004 E.36217
G1 X172.17 Y90.004 E.01705
G1 X164.04 Y98.133 E.36217
G1 X164.582 Y98.133 E.01705
G1 X172.711 Y90.004 E.36217
G1 X173.252 Y90.004 E.01705
G1 X165.123 Y98.133 E.36217
G1 X165.664 Y98.133 E.01705
G1 X173.794 Y90.004 E.36217
G1 X174.335 Y90.004 E.01705
G1 X166.205 Y98.133 E.36217
G1 X166.746 Y98.133 E.01705
G1 X174.876 Y90.004 E.36217
G1 X175.417 Y90.004 E.01705
G1 X167.288 Y98.133 E.36217
G1 X167.829 Y98.133 E.01705
G1 X175.958 Y90.004 E.36217
G1 X176.5 Y90.004 E.01705
G1 X168.37 Y98.133 E.36217
G1 X168.911 Y98.133 E.01705
G1 X177.041 Y90.004 E.36217
G1 X177.582 Y90.004 E.01705
G1 X169.452 Y98.133 E.36217
G1 X169.994 Y98.133 E.01705
G1 X178.123 Y90.004 E.36217
G1 X178.664 Y90.004 E.01705
G1 X170.535 Y98.133 E.36217
G1 X171.076 Y98.133 E.01705
G1 X179.205 Y90.004 E.36217
G1 X179.629 Y90.004 E.01333
G1 X179.629 Y90.122 E.00372
G1 X171.617 Y98.133 E.35691
G1 X172.158 Y98.133 E.01705
G1 X179.629 Y90.663 E.3328
G1 X179.629 Y91.204 E.01705
G1 X172.699 Y98.133 E.30869
G1 X173.241 Y98.133 E.01705
G1 X179.629 Y91.745 E.28458
G1 X179.629 Y92.287 E.01705
G1 X173.782 Y98.133 E.26047
G1 X174.323 Y98.133 E.01705
G1 X179.629 Y92.828 E.23636
G1 X179.629 Y93.369 E.01705
G1 X174.864 Y98.133 E.21225
G1 X175.405 Y98.133 E.01705
G1 X179.629 Y93.91 E.18814
G1 X179.629 Y94.451 E.01705
G1 X175.947 Y98.133 E.16403
G1 X176.488 Y98.133 E.01705
G1 X179.629 Y94.992 E.13992
G1 X179.629 Y95.534 E.01705
G1 X177.029 Y98.133 E.11581
G1 X177.57 Y98.133 E.01705
G1 X179.629 Y96.075 E.0917
G1 X179.629 Y96.616 E.01705
G1 X178.111 Y98.133 E.06759
G1 X178.653 Y98.133 E.01705
G1 X179.629 Y97.157 E.04348
G1 X179.629 Y97.698 E.01705
G1 X179.024 Y98.303 E.02693
; COOLING_NODE: 0
; WIPE_START
G1 X179.629 Y97.698 E-.32485
G1 X179.629 Y97.553 E-.05515
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I.538 J1.092 P1  F60000
G1 X190.462 Y92.216 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X190.462 Y98.466 E.20944
G1 X186.166 Y98.466 E.14396
G1 X186.166 Y89.671 E.29475
G1 X190.462 Y89.671 E.14396
G1 X190.462 Y92.156 E.0833
; COOLING_NODE: 0
M204 S250
G1 X190.854 Y92.608 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X190.854 Y95.528 E.09064
G1 X198.354 Y95.528 E.23281
G1 X198.354 Y96.358 E.02576
G1 X190.854 Y96.358 E.23281
G1 X190.854 Y98.858 E.0776
G1 X185.774 Y98.858 E.15769
G1 X185.774 Y89.278 E.29737
M73 P93 R2
G1 X190.854 Y89.278 E.15769
G1 X190.854 Y91.778 E.0776
G1 X198.354 Y91.778 E.23281
G1 X198.354 Y92.608 E.02576
G1 X190.914 Y92.608 E.23094
M204 S10000
G1 X190.658 Y92.193 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.48086
G1 F15000
M204 S8000
G1 X198.158 Y92.193 E.27038
; WIPE_START
G1 X197.158 Y92.193 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I-1.176 J.314 P1  F60000
G1 X198.158 Y95.943 Z2.4
G1 Z2
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X190.658 Y95.943 E.27038
; WIPE_START
G1 X191.658 Y95.943 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I-.2 J-1.2 P1  F60000
G1 X188.096 Y96.537 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47904
G1 F15000
M204 S8000
G1 X188.532 Y96.537 E.01566
G1 X188.532 Y91.6 E.17721
G1 X188.096 Y91.6 E.01566
G1 X188.096 Y96.477 E.17506
M204 S10000
G1 X187.689 Y96.943 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X188.938 Y96.943 E.03878
G1 X188.938 Y91.194 E.17846
G1 X187.689 Y91.194 E.03878
G1 X187.689 Y96.883 E.1766
M204 S10000
G1 X187.312 Y97.32 F60000
G1 F15000
M204 S8000
G1 X189.316 Y97.32 E.06219
G1 X189.316 Y90.817 E.20187
G1 X187.312 Y90.817 E.06219
G1 X187.312 Y97.26 E.20001
M204 S10000
G1 X186.935 Y97.697 F60000
G1 F15000
M204 S8000
G1 X189.693 Y97.697 E.0856
G1 X189.693 Y90.44 E.22528
G1 X186.935 Y90.44 E.0856
G1 X186.935 Y97.637 E.22341
M204 S10000
G1 X186.558 Y98.074 F60000
G1 F15000
M204 S8000
G1 X190.07 Y98.074 E.109
G1 X190.07 Y90.063 E.24868
G1 X186.558 Y90.063 E.109
G1 X186.558 Y98.014 E.24682
; WIPE_START
G1 X186.558 Y97.014 E-.38
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
    

    

    
        M9711 M0 E0 U266 V97 Z2.4 S11 C10 O0 T3000
    

    
    
    
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
; OBJECT_ID: 756
; COOLING_NODE: 0
G1 X148.962 Y89.671 F60000
G1 Z2.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1500
M204 S50
G1 X148.962 Y98.466 E.29475
G1 X137.166 Y98.466 E.39528
G1 X137.166 Y89.671 E.29475
G1 X148.902 Y89.671 E.39327
; COOLING_NODE: 0
M204 S250
G1 X149.354 Y89.278 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X149.354 Y98.858 E.29737
G1 X136.774 Y98.858 E.39049
G1 X136.774 Y89.278 E.29737
G1 X149.294 Y89.278 E.38863
; WIPE_START
M204 S8000
M73 P93 R1
G1 X149.3 Y90.278 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-.668 J-1.018 P1  F60000
G1 X148.798 Y90.608 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42539
G1 F15000
M204 S8000
G1 X148.194 Y90.004 E.02689
G1 X147.653 Y90.004 E.01703
G1 X148.629 Y90.979 E.04342
G1 X148.629 Y91.52 E.01703
G1 X147.112 Y90.004 E.06751
G1 X146.572 Y90.004 E.01703
G1 X148.629 Y92.061 E.09159
G1 X148.629 Y92.602 E.01703
G1 X146.031 Y90.004 E.11567
G1 X145.49 Y90.004 E.01703
G1 X148.629 Y93.143 E.13976
G1 X148.629 Y93.683 E.01703
G1 X144.949 Y90.004 E.16384
G1 X144.408 Y90.004 E.01703
G1 X148.629 Y94.224 E.18793
G1 X148.629 Y94.765 E.01703
G1 X143.867 Y90.004 E.21201
G1 X143.326 Y90.004 E.01703
G1 X148.629 Y95.306 E.23609
G1 X148.629 Y95.847 E.01703
G1 X142.785 Y90.004 E.26018
G1 X142.244 Y90.004 E.01703
G1 X148.629 Y96.388 E.28426
G1 X148.629 Y96.929 E.01703
G1 X141.703 Y90.004 E.30834
G1 X141.163 Y90.004 E.01703
G1 X148.629 Y97.47 E.33243
G1 X148.629 Y98.011 E.01703
G1 X140.622 Y90.004 E.35651
G1 X140.081 Y90.004 E.01703
G1 X148.21 Y98.133 E.36198
G1 X147.669 Y98.133 E.01703
G1 X139.54 Y90.004 E.36198
G1 X138.999 Y90.004 E.01703
G1 X147.129 Y98.133 E.36198
G1 X146.588 Y98.133 E.01703
G1 X138.458 Y90.004 E.36198
G1 X137.917 Y90.004 E.01703
G1 X146.047 Y98.133 E.36198
G1 X145.506 Y98.133 E.01703
G1 X137.499 Y90.126 E.35651
G1 X137.499 Y90.667 E.01703
G1 X144.965 Y98.133 E.33243
G1 X144.424 Y98.133 E.01703
G1 X137.499 Y91.208 E.30835
G1 X137.499 Y91.749 E.01703
G1 X143.883 Y98.133 E.28426
G1 X143.342 Y98.133 E.01703
G1 X137.499 Y92.29 E.26018
G1 X137.499 Y92.831 E.01703
G1 X142.801 Y98.133 E.23609
G1 X142.261 Y98.133 E.01703
G1 X137.499 Y93.372 E.21201
G1 X137.499 Y93.913 E.01703
G1 X141.72 Y98.133 E.18793
G1 X141.179 Y98.133 E.01703
G1 X137.499 Y94.454 E.16384
G1 X137.499 Y94.994 E.01703
G1 X140.638 Y98.133 E.13976
G1 X140.097 Y98.133 E.01703
G1 X137.499 Y95.535 E.11568
G1 X137.499 Y96.076 E.01703
G1 X139.556 Y98.133 E.09159
G1 X139.015 Y98.133 E.01703
G1 X137.499 Y96.617 E.06751
G1 X137.499 Y97.158 E.01703
G1 X138.474 Y98.133 E.04342
G1 X137.933 Y98.133 E.01703
G1 X137.329 Y97.529 E.0269
; COOLING_NODE: 0
; WIPE_START
G1 X137.933 Y98.133 E-.32461
G1 X138.079 Y98.133 E-.05539
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I.54 J1.091 P1  F60000
G1 X155.166 Y89.671 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3000
M204 S50
G1 X179.962 Y89.671 E.83092
G1 X179.962 Y98.466 E.29475
G1 X155.166 Y98.466 E.83092
G1 X155.166 Y89.731 E.29274
; COOLING_NODE: 0
M204 S250
G1 X154.774 Y89.278 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1855
M204 S50
G1 X180.354 Y89.278 E.79402
G1 X180.354 Y98.858 E.29737
G1 X154.774 Y98.858 E.79402
G1 X154.774 Y89.338 E.29551
; WIPE_START
G1 F3000
M204 S8000
G1 X155.774 Y89.336 E-.38
; WIPE_END
M73 P94 R1
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-1.215 J-.066 P1  F60000
G1 X155.329 Y97.528 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F15000
M204 S8000
G1 X155.934 Y98.133 E.02695
G1 X156.475 Y98.133 E.01705
G1 X155.499 Y97.157 E.0435
G1 X155.499 Y96.616 E.01705
G1 X157.017 Y98.133 E.06761
G1 X157.558 Y98.133 E.01705
G1 X155.499 Y96.074 E.09172
G1 X155.499 Y95.533 E.01705
G1 X158.099 Y98.133 E.11583
G1 X158.64 Y98.133 E.01705
G1 X155.499 Y94.992 E.13994
G1 X155.499 Y94.451 E.01705
G1 X159.181 Y98.133 E.16405
G1 X159.723 Y98.133 E.01705
G1 X155.499 Y93.91 E.18816
G1 X155.499 Y93.368 E.01705
G1 X160.264 Y98.133 E.21227
G1 X160.805 Y98.133 E.01705
G1 X155.499 Y92.827 E.23638
G1 X155.499 Y92.286 E.01705
G1 X161.346 Y98.133 E.26049
G1 X161.887 Y98.133 E.01705
G1 X155.499 Y91.745 E.2846
G1 X155.499 Y91.204 E.01705
G1 X162.429 Y98.133 E.30871
G1 X162.97 Y98.133 E.01705
G1 X155.499 Y90.663 E.33282
G1 X155.499 Y90.121 E.01705
G1 X163.511 Y98.133 E.35693
G1 X164.052 Y98.133 E.01705
G1 X155.923 Y90.004 E.36217
G1 X156.464 Y90.004 E.01705
G1 X164.593 Y98.133 E.36217
G1 X165.134 Y98.133 E.01705
G1 X157.005 Y90.004 E.36217
G1 X157.546 Y90.004 E.01705
G1 X165.676 Y98.133 E.36217
G1 X166.217 Y98.133 E.01705
G1 X158.087 Y90.004 E.36217
G1 X158.629 Y90.004 E.01705
G1 X166.758 Y98.133 E.36217
G1 X167.299 Y98.133 E.01705
G1 X159.17 Y90.004 E.36217
G1 X159.711 Y90.004 E.01705
G1 X167.84 Y98.133 E.36217
G1 X168.382 Y98.133 E.01705
G1 X160.252 Y90.004 E.36217
G1 X160.793 Y90.004 E.01705
G1 X168.923 Y98.133 E.36217
G1 X169.464 Y98.133 E.01705
G1 X161.334 Y90.004 E.36217
G1 X161.876 Y90.004 E.01705
G1 X170.005 Y98.133 E.36217
G1 X170.546 Y98.133 E.01705
G1 X162.417 Y90.004 E.36217
G1 X162.958 Y90.004 E.01705
G1 X171.088 Y98.133 E.36217
G1 X171.629 Y98.133 E.01705
G1 X163.499 Y90.004 E.36217
G1 X164.04 Y90.004 E.01705
G1 X172.17 Y98.133 E.36217
G1 X172.711 Y98.133 E.01705
G1 X164.582 Y90.004 E.36217
G1 X165.123 Y90.004 E.01705
G1 X173.252 Y98.133 E.36217
G1 X173.794 Y98.133 E.01705
G1 X165.664 Y90.004 E.36217
G1 X166.205 Y90.004 E.01705
G1 X174.335 Y98.133 E.36217
G1 X174.876 Y98.133 E.01705
G1 X166.746 Y90.004 E.36217
G1 X167.288 Y90.004 E.01705
G1 X175.417 Y98.133 E.36217
G1 X175.958 Y98.133 E.01705
G1 X167.829 Y90.004 E.36217
G1 X168.37 Y90.004 E.01705
G1 X176.5 Y98.133 E.36217
G1 X177.041 Y98.133 E.01705
G1 X168.911 Y90.004 E.36217
G1 X169.452 Y90.004 E.01705
G1 X177.582 Y98.133 E.36217
G1 X178.123 Y98.133 E.01705
G1 X169.994 Y90.004 E.36217
G1 X170.535 Y90.004 E.01705
G1 X178.664 Y98.133 E.36217
G1 X179.205 Y98.133 E.01705
G1 X171.076 Y90.004 E.36217
G1 X171.617 Y90.004 E.01705
G1 X179.629 Y98.015 E.35691
G1 X179.629 Y97.474 E.01705
G1 X172.158 Y90.004 E.3328
G1 X172.699 Y90.004 E.01705
G1 X179.629 Y96.933 E.30869
G1 X179.629 Y96.392 E.01705
G1 X173.241 Y90.004 E.28458
G1 X173.782 Y90.004 E.01705
G1 X179.629 Y95.85 E.26047
G1 X179.629 Y95.309 E.01705
G1 X174.323 Y90.004 E.23636
G1 X174.864 Y90.004 E.01705
G1 X179.629 Y94.768 E.21225
G1 X179.629 Y94.227 E.01705
G1 X175.405 Y90.004 E.18814
G1 X175.947 Y90.004 E.01705
G1 X179.629 Y93.686 E.16403
G1 X179.629 Y93.144 E.01705
G1 X176.488 Y90.004 E.13992
G1 X177.029 Y90.004 E.01705
G1 X179.629 Y92.603 E.11581
G1 X179.629 Y92.062 E.01705
G1 X177.57 Y90.004 E.0917
G1 X178.111 Y90.004 E.01705
G1 X179.629 Y91.521 E.06759
G1 X179.629 Y90.98 E.01705
G1 X178.653 Y90.004 E.04348
G1 X179.194 Y90.004 E.01705
G1 X179.798 Y90.608 E.02693
; COOLING_NODE: 0
; WIPE_START
G1 X179.194 Y90.004 E-.32485
G1 X179.049 Y90.004 E-.05515
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-.232 J1.195 P1  F60000
G1 X190.462 Y92.216 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X190.462 Y98.466 E.20944
G1 X186.166 Y98.466 E.14396
G1 X186.166 Y89.671 E.29475
G1 X190.462 Y89.671 E.14396
G1 X190.462 Y92.156 E.0833
; COOLING_NODE: 0
M204 S250
G1 X190.854 Y92.608 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X190.854 Y95.528 E.09064
G1 X198.354 Y95.528 E.23281
G1 X198.354 Y96.358 E.02576
G1 X190.854 Y96.358 E.23281
G1 X190.854 Y98.858 E.0776
G1 X185.774 Y98.858 E.15769
G1 X185.774 Y89.278 E.29737
G1 X190.854 Y89.278 E.15769
G1 X190.854 Y91.778 E.0776
G1 X198.354 Y91.778 E.23281
G1 X198.354 Y92.608 E.02576
G1 X190.914 Y92.608 E.23094
M204 S10000
G1 X190.658 Y92.193 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.48086
G1 F15000
M204 S8000
G1 X198.158 Y92.193 E.27038
; WIPE_START
G1 X197.158 Y92.193 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-1.176 J.314 P1  F60000
G1 X198.158 Y95.943 Z2.6
G1 Z2.2
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X190.658 Y95.943 E.27038
; WIPE_START
G1 X191.658 Y95.943 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-.2 J-1.2 P1  F60000
G1 X188.096 Y96.537 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47904
G1 F15000
M204 S8000
G1 X188.532 Y96.537 E.01566
G1 X188.532 Y91.6 E.17721
G1 X188.096 Y91.6 E.01566
G1 X188.096 Y96.477 E.17506
M204 S10000
G1 X187.689 Y96.943 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X188.938 Y96.943 E.03878
G1 X188.938 Y91.194 E.17846
G1 X187.689 Y91.194 E.03878
G1 X187.689 Y96.883 E.1766
M204 S10000
G1 X187.312 Y97.32 F60000
G1 F15000
M204 S8000
G1 X189.316 Y97.32 E.06219
G1 X189.316 Y90.817 E.20187
G1 X187.312 Y90.817 E.06219
G1 X187.312 Y97.26 E.20001
M204 S10000
G1 X186.935 Y97.697 F60000
G1 F15000
M204 S8000
G1 X189.693 Y97.697 E.0856
G1 X189.693 Y90.44 E.22528
G1 X186.935 Y90.44 E.0856
G1 X186.935 Y97.637 E.22341
M204 S10000
G1 X186.558 Y98.074 F60000
G1 F15000
M204 S8000
G1 X190.07 Y98.074 E.109
G1 X190.07 Y90.063 E.24868
G1 X186.558 Y90.063 E.109
G1 X186.558 Y98.014 E.24682
; WIPE_START
G1 X186.558 Y97.014 E-.38
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
    

    

    
        M9711 M0 E0 U266 V97 Z2.6 S11 C10 O0 T3000
    

    
    
    
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
; OBJECT_ID: 756
; COOLING_NODE: 0
G1 X148.962 Y89.671 F60000
G1 Z2.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1500
M204 S50
G1 X148.962 Y98.466 E.29475
G1 X137.166 Y98.466 E.39528
G1 X137.166 Y89.671 E.29475
G1 X148.902 Y89.671 E.39327
; COOLING_NODE: 0
M204 S250
G1 X149.354 Y89.278 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X149.354 Y98.858 E.29737
G1 X136.774 Y98.858 E.39049
G1 X136.774 Y89.278 E.29737
G1 X149.294 Y89.278 E.38863
; WIPE_START
M204 S8000
G1 X149.3 Y90.278 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I-1.202 J-.191 P1  F60000
M73 P95 R1
G1 X148.025 Y98.303 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42539
G1 F15000
M204 S8000
G1 X148.629 Y97.699 E.02689
G1 X148.629 Y97.158 E.01703
G1 X147.653 Y98.133 E.04342
G1 X147.112 Y98.133 E.01703
G1 X148.629 Y96.617 E.06751
G1 X148.629 Y96.076 E.01703
G1 X146.572 Y98.133 E.09159
G1 X146.031 Y98.133 E.01703
G1 X148.629 Y95.535 E.11567
G1 X148.629 Y94.994 E.01703
G1 X145.49 Y98.133 E.13976
G1 X144.949 Y98.133 E.01703
G1 X148.629 Y94.454 E.16384
G1 X148.629 Y93.913 E.01703
G1 X144.408 Y98.133 E.18793
G1 X143.867 Y98.133 E.01703
G1 X148.629 Y93.372 E.21201
G1 X148.629 Y92.831 E.01703
G1 X143.326 Y98.133 E.23609
G1 X142.785 Y98.133 E.01703
G1 X148.629 Y92.29 E.26018
G1 X148.629 Y91.749 E.01703
G1 X142.244 Y98.133 E.28426
G1 X141.703 Y98.133 E.01703
G1 X148.629 Y91.208 E.30834
G1 X148.629 Y90.667 E.01703
G1 X141.163 Y98.133 E.33243
G1 X140.622 Y98.133 E.01703
G1 X148.629 Y90.126 E.35651
G1 X148.629 Y90.004 E.00386
G1 X148.21 Y90.004 E.01317
G1 X140.081 Y98.133 E.36198
G1 X139.54 Y98.133 E.01703
G1 X147.669 Y90.004 E.36198
G1 X147.129 Y90.004 E.01703
G1 X138.999 Y98.133 E.36198
G1 X138.458 Y98.133 E.01703
G1 X146.588 Y90.004 E.36198
G1 X146.047 Y90.004 E.01703
G1 X137.917 Y98.133 E.36198
G1 X137.499 Y98.133 E.01317
G1 X137.499 Y98.011 E.00386
G1 X145.506 Y90.004 E.35651
G1 X144.965 Y90.004 E.01703
G1 X137.499 Y97.47 E.33243
G1 X137.499 Y96.929 E.01703
G1 X144.424 Y90.004 E.30835
G1 X143.883 Y90.004 E.01703
G1 X137.499 Y96.388 E.28426
G1 X137.499 Y95.847 E.01703
G1 X143.342 Y90.004 E.26018
G1 X142.801 Y90.004 E.01703
G1 X137.499 Y95.306 E.23609
G1 X137.499 Y94.765 E.01703
G1 X142.261 Y90.004 E.21201
G1 X141.72 Y90.004 E.01703
G1 X137.499 Y94.224 E.18793
G1 X137.499 Y93.683 E.01703
G1 X141.179 Y90.004 E.16384
G1 X140.638 Y90.004 E.01703
G1 X137.499 Y93.143 E.13976
G1 X137.499 Y92.602 E.01703
G1 X140.097 Y90.004 E.11568
G1 X139.556 Y90.004 E.01703
G1 X137.499 Y92.061 E.09159
G1 X137.499 Y91.52 E.01703
G1 X139.015 Y90.004 E.06751
G1 X138.474 Y90.004 E.01703
G1 X137.499 Y90.979 E.04342
G1 X137.499 Y90.438 E.01703
G1 X138.103 Y89.834 E.0269
; COOLING_NODE: 0
; WIPE_START
G1 X137.499 Y90.438 E-.32461
G1 X137.499 Y90.584 E-.05539
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I.063 J1.215 P1  F60000
G1 X155.166 Y89.671 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3000
M204 S50
G1 X179.962 Y89.671 E.83092
G1 X179.962 Y98.466 E.29475
G1 X155.166 Y98.466 E.83092
G1 X155.166 Y89.731 E.29274
; COOLING_NODE: 0
M204 S250
G1 X154.774 Y89.278 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1927
M204 S50
G1 X180.354 Y89.278 E.79402
G1 X180.354 Y98.858 E.29737
G1 X154.774 Y98.858 E.79402
G1 X154.774 Y89.338 E.29551
; WIPE_START
G1 F3000
M204 S8000
G1 X155.774 Y89.336 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I-1.014 J.673 P1  F60000
G1 X156.104 Y89.834 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F15000
M204 S8000
G1 X155.499 Y90.439 E.02695
G1 X155.499 Y90.98 E.01705
G1 X156.475 Y90.004 E.0435
G1 X157.017 Y90.004 E.01705
G1 X155.499 Y91.521 E.06761
G1 X155.499 Y92.062 E.01705
G1 X157.558 Y90.004 E.09172
G1 X158.099 Y90.004 E.01705
G1 X155.499 Y92.604 E.11583
G1 X155.499 Y93.145 E.01705
G1 X158.64 Y90.004 E.13994
G1 X159.181 Y90.004 E.01705
G1 X155.499 Y93.686 E.16405
G1 X155.499 Y94.227 E.01705
G1 X159.723 Y90.004 E.18816
G1 X160.264 Y90.004 E.01705
G1 X155.499 Y94.768 E.21227
G1 X155.499 Y95.31 E.01705
G1 X160.805 Y90.004 E.23638
G1 X161.346 Y90.004 E.01705
G1 X155.499 Y95.851 E.26049
G1 X155.499 Y96.392 E.01705
G1 X161.887 Y90.004 E.2846
G1 X162.429 Y90.004 E.01705
G1 X155.499 Y96.933 E.30871
G1 X155.499 Y97.474 E.01705
G1 X162.97 Y90.004 E.33282
G1 X163.511 Y90.004 E.01705
G1 X155.499 Y98.016 E.35693
G1 X155.499 Y98.133 E.00371
G1 X155.923 Y98.133 E.01334
G1 X164.052 Y90.004 E.36217
G1 X164.593 Y90.004 E.01705
G1 X156.464 Y98.133 E.36217
G1 X157.005 Y98.133 E.01705
G1 X165.134 Y90.004 E.36217
G1 X165.676 Y90.004 E.01705
G1 X157.546 Y98.133 E.36217
G1 X158.087 Y98.133 E.01705
G1 X166.217 Y90.004 E.36217
G1 X166.758 Y90.004 E.01705
G1 X158.628 Y98.133 E.36217
G1 X159.17 Y98.133 E.01705
G1 X167.299 Y90.004 E.36217
G1 X167.84 Y90.004 E.01705
G1 X159.711 Y98.133 E.36217
G1 X160.252 Y98.133 E.01705
G1 X168.382 Y90.004 E.36217
G1 X168.923 Y90.004 E.01705
G1 X160.793 Y98.133 E.36217
G1 X161.334 Y98.133 E.01705
G1 X169.464 Y90.004 E.36217
G1 X170.005 Y90.004 E.01705
G1 X161.876 Y98.133 E.36217
G1 X162.417 Y98.133 E.01705
G1 X170.546 Y90.004 E.36217
G1 X171.088 Y90.004 E.01705
G1 X162.958 Y98.133 E.36217
G1 X163.499 Y98.133 E.01705
G1 X171.629 Y90.004 E.36217
G1 X172.17 Y90.004 E.01705
G1 X164.04 Y98.133 E.36217
G1 X164.582 Y98.133 E.01705
G1 X172.711 Y90.004 E.36217
G1 X173.252 Y90.004 E.01705
G1 X165.123 Y98.133 E.36217
G1 X165.664 Y98.133 E.01705
G1 X173.794 Y90.004 E.36217
G1 X174.335 Y90.004 E.01705
G1 X166.205 Y98.133 E.36217
G1 X166.746 Y98.133 E.01705
G1 X174.876 Y90.004 E.36217
G1 X175.417 Y90.004 E.01705
G1 X167.288 Y98.133 E.36217
G1 X167.829 Y98.133 E.01705
G1 X175.958 Y90.004 E.36217
G1 X176.5 Y90.004 E.01705
G1 X168.37 Y98.133 E.36217
G1 X168.911 Y98.133 E.01705
G1 X177.041 Y90.004 E.36217
G1 X177.582 Y90.004 E.01705
G1 X169.452 Y98.133 E.36217
G1 X169.994 Y98.133 E.01705
G1 X178.123 Y90.004 E.36217
G1 X178.664 Y90.004 E.01705
G1 X170.535 Y98.133 E.36217
G1 X171.076 Y98.133 E.01705
G1 X179.205 Y90.004 E.36217
G1 X179.629 Y90.004 E.01333
G1 X179.629 Y90.122 E.00372
G1 X171.617 Y98.133 E.35691
G1 X172.158 Y98.133 E.01705
G1 X179.629 Y90.663 E.3328
G1 X179.629 Y91.204 E.01705
G1 X172.699 Y98.133 E.30869
G1 X173.241 Y98.133 E.01705
G1 X179.629 Y91.745 E.28458
G1 X179.629 Y92.287 E.01705
G1 X173.782 Y98.133 E.26047
G1 X174.323 Y98.133 E.01705
G1 X179.629 Y92.828 E.23636
G1 X179.629 Y93.369 E.01705
G1 X174.864 Y98.133 E.21225
G1 X175.405 Y98.133 E.01705
G1 X179.629 Y93.91 E.18814
G1 X179.629 Y94.451 E.01705
G1 X175.947 Y98.133 E.16403
G1 X176.488 Y98.133 E.01705
G1 X179.629 Y94.992 E.13992
G1 X179.629 Y95.534 E.01705
G1 X177.029 Y98.133 E.11581
G1 X177.57 Y98.133 E.01705
G1 X179.629 Y96.075 E.0917
G1 X179.629 Y96.616 E.01705
G1 X178.111 Y98.133 E.06759
G1 X178.653 Y98.133 E.01705
G1 X179.629 Y97.157 E.04348
G1 X179.629 Y97.698 E.01705
G1 X179.024 Y98.303 E.02693
; COOLING_NODE: 0
; WIPE_START
G1 X179.629 Y97.698 E-.32485
G1 X179.629 Y97.553 E-.05515
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I.538 J1.092 P1  F60000
G1 X190.462 Y92.216 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X190.462 Y98.466 E.20944
G1 X186.166 Y98.466 E.14396
G1 X186.166 Y89.671 E.29475
G1 X190.462 Y89.671 E.14396
G1 X190.462 Y92.156 E.0833
; COOLING_NODE: 0
M204 S250
G1 X190.854 Y92.608 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X190.854 Y95.528 E.09064
G1 X198.354 Y95.528 E.23281
G1 X198.354 Y96.358 E.02576
G1 X190.854 Y96.358 E.23281
G1 X190.854 Y98.858 E.0776
G1 X185.774 Y98.858 E.15769
G1 X185.774 Y89.278 E.29737
M73 P96 R1
G1 X190.854 Y89.278 E.15769
G1 X190.854 Y91.778 E.0776
G1 X198.354 Y91.778 E.23281
G1 X198.354 Y92.608 E.02576
G1 X190.914 Y92.608 E.23094
M204 S10000
G1 X190.658 Y92.193 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.48086
G1 F15000
M204 S8000
G1 X198.158 Y92.193 E.27038
; WIPE_START
G1 X197.158 Y92.193 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I-1.176 J.314 P1  F60000
G1 X198.158 Y95.943 Z2.8
G1 Z2.4
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X190.658 Y95.943 E.27038
; WIPE_START
G1 X191.658 Y95.943 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I-.2 J-1.2 P1  F60000
G1 X188.096 Y96.537 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47904
G1 F15000
M204 S8000
G1 X188.532 Y96.537 E.01566
G1 X188.532 Y91.6 E.17721
G1 X188.096 Y91.6 E.01566
G1 X188.096 Y96.477 E.17506
M204 S10000
G1 X187.689 Y96.943 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X188.938 Y96.943 E.03878
G1 X188.938 Y91.194 E.17846
G1 X187.689 Y91.194 E.03878
G1 X187.689 Y96.883 E.1766
M204 S10000
G1 X187.312 Y97.32 F60000
G1 F15000
M204 S8000
G1 X189.316 Y97.32 E.06219
G1 X189.316 Y90.817 E.20187
G1 X187.312 Y90.817 E.06219
G1 X187.312 Y97.26 E.20001
M204 S10000
G1 X186.935 Y97.697 F60000
G1 F15000
M204 S8000
G1 X189.693 Y97.697 E.0856
G1 X189.693 Y90.44 E.22528
G1 X186.935 Y90.44 E.0856
G1 X186.935 Y97.637 E.22341
M204 S10000
G1 X186.558 Y98.074 F60000
G1 F15000
M204 S8000
G1 X190.07 Y98.074 E.109
G1 X190.07 Y90.063 E.24868
G1 X186.558 Y90.063 E.109
G1 X186.558 Y98.014 E.24682
; WIPE_START
G1 X186.558 Y97.014 E-.38
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
    

    

    
        M9711 M0 E0 U266 V97 Z2.8 S11 C10 O0 T3000
    

    
    
    
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
; OBJECT_ID: 756
; COOLING_NODE: 0
G1 X148.962 Y89.671 F60000
G1 Z2.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1500
M204 S50
G1 X148.962 Y98.466 E.29475
G1 X137.166 Y98.466 E.39528
G1 X137.166 Y89.671 E.29475
G1 X148.902 Y89.671 E.39327
; COOLING_NODE: 0
M204 S250
G1 X149.354 Y89.278 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X149.354 Y98.858 E.29737
G1 X136.774 Y98.858 E.39049
G1 X136.774 Y89.278 E.29737
G1 X149.294 Y89.278 E.38863
; WIPE_START
M204 S8000
G1 X149.3 Y90.278 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I-.668 J-1.018 P1  F60000
G1 X148.798 Y90.608 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42539
G1 F15000
M204 S8000
G1 X148.194 Y90.004 E.02689
G1 X147.653 Y90.004 E.01703
G1 X148.629 Y90.979 E.04342
G1 X148.629 Y91.52 E.01703
G1 X147.112 Y90.004 E.06751
G1 X146.572 Y90.004 E.01703
G1 X148.629 Y92.061 E.09159
G1 X148.629 Y92.602 E.01703
G1 X146.031 Y90.004 E.11567
G1 X145.49 Y90.004 E.01703
G1 X148.629 Y93.143 E.13976
G1 X148.629 Y93.683 E.01703
G1 X144.949 Y90.004 E.16384
G1 X144.408 Y90.004 E.01703
G1 X148.629 Y94.224 E.18793
G1 X148.629 Y94.765 E.01703
G1 X143.867 Y90.004 E.21201
G1 X143.326 Y90.004 E.01703
G1 X148.629 Y95.306 E.23609
G1 X148.629 Y95.847 E.01703
G1 X142.785 Y90.004 E.26018
G1 X142.244 Y90.004 E.01703
G1 X148.629 Y96.388 E.28426
G1 X148.629 Y96.929 E.01703
G1 X141.703 Y90.004 E.30834
G1 X141.163 Y90.004 E.01703
G1 X148.629 Y97.47 E.33243
G1 X148.629 Y98.011 E.01703
G1 X140.622 Y90.004 E.35651
G1 X140.081 Y90.004 E.01703
G1 X148.21 Y98.133 E.36198
G1 X147.669 Y98.133 E.01703
G1 X139.54 Y90.004 E.36198
G1 X138.999 Y90.004 E.01703
G1 X147.129 Y98.133 E.36198
G1 X146.588 Y98.133 E.01703
G1 X138.458 Y90.004 E.36198
G1 X137.917 Y90.004 E.01703
G1 X146.047 Y98.133 E.36198
G1 X145.506 Y98.133 E.01703
G1 X137.499 Y90.126 E.35651
G1 X137.499 Y90.667 E.01703
G1 X144.965 Y98.133 E.33243
G1 X144.424 Y98.133 E.01703
G1 X137.499 Y91.208 E.30835
G1 X137.499 Y91.749 E.01703
G1 X143.883 Y98.133 E.28426
G1 X143.342 Y98.133 E.01703
G1 X137.499 Y92.29 E.26018
G1 X137.499 Y92.831 E.01703
G1 X142.801 Y98.133 E.23609
G1 X142.261 Y98.133 E.01703
G1 X137.499 Y93.372 E.21201
G1 X137.499 Y93.913 E.01703
G1 X141.72 Y98.133 E.18793
G1 X141.179 Y98.133 E.01703
G1 X137.499 Y94.454 E.16384
G1 X137.499 Y94.994 E.01703
G1 X140.638 Y98.133 E.13976
G1 X140.097 Y98.133 E.01703
G1 X137.499 Y95.535 E.11568
G1 X137.499 Y96.076 E.01703
G1 X139.556 Y98.133 E.09159
G1 X139.015 Y98.133 E.01703
G1 X137.499 Y96.617 E.06751
G1 X137.499 Y97.158 E.01703
G1 X138.474 Y98.133 E.04342
G1 X137.933 Y98.133 E.01703
G1 X137.329 Y97.529 E.0269
; COOLING_NODE: 0
; WIPE_START
G1 X137.933 Y98.133 E-.32461
G1 X138.079 Y98.133 E-.05539
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I.54 J1.091 P1  F60000
G1 X155.166 Y89.671 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3000
M204 S50
G1 X179.962 Y89.671 E.83092
G1 X179.962 Y98.466 E.29475
G1 X155.166 Y98.466 E.83092
G1 X155.166 Y89.731 E.29274
; COOLING_NODE: 0
M204 S250
M73 P96 R0
G1 X154.774 Y89.278 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1987
M204 S50
G1 X180.354 Y89.278 E.79402
G1 X180.354 Y98.858 E.29737
G1 X154.774 Y98.858 E.79402
G1 X154.774 Y89.338 E.29551
; WIPE_START
G1 F3000
M204 S8000
G1 X155.774 Y89.336 E-.38
; WIPE_END
M73 P97 R0
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I-1.215 J-.066 P1  F60000
G1 X155.329 Y97.528 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4256
G1 F15000
M204 S8000
G1 X155.934 Y98.133 E.02695
G1 X156.475 Y98.133 E.01705
G1 X155.499 Y97.157 E.0435
G1 X155.499 Y96.616 E.01705
G1 X157.017 Y98.133 E.06761
G1 X157.558 Y98.133 E.01705
G1 X155.499 Y96.074 E.09172
G1 X155.499 Y95.533 E.01705
G1 X158.099 Y98.133 E.11583
G1 X158.64 Y98.133 E.01705
G1 X155.499 Y94.992 E.13994
G1 X155.499 Y94.451 E.01705
G1 X159.181 Y98.133 E.16405
G1 X159.723 Y98.133 E.01705
G1 X155.499 Y93.91 E.18816
G1 X155.499 Y93.368 E.01705
G1 X160.264 Y98.133 E.21227
G1 X160.805 Y98.133 E.01705
G1 X155.499 Y92.827 E.23638
G1 X155.499 Y92.286 E.01705
G1 X161.346 Y98.133 E.26049
G1 X161.887 Y98.133 E.01705
G1 X155.499 Y91.745 E.2846
G1 X155.499 Y91.204 E.01705
G1 X162.429 Y98.133 E.30871
G1 X162.97 Y98.133 E.01705
G1 X155.499 Y90.663 E.33282
G1 X155.499 Y90.121 E.01705
G1 X163.511 Y98.133 E.35693
G1 X164.052 Y98.133 E.01705
G1 X155.923 Y90.004 E.36217
G1 X156.464 Y90.004 E.01705
G1 X164.593 Y98.133 E.36217
G1 X165.134 Y98.133 E.01705
G1 X157.005 Y90.004 E.36217
G1 X157.546 Y90.004 E.01705
G1 X165.676 Y98.133 E.36217
G1 X166.217 Y98.133 E.01705
G1 X158.087 Y90.004 E.36217
G1 X158.629 Y90.004 E.01705
G1 X166.758 Y98.133 E.36217
G1 X167.299 Y98.133 E.01705
G1 X159.17 Y90.004 E.36217
G1 X159.711 Y90.004 E.01705
G1 X167.84 Y98.133 E.36217
G1 X168.382 Y98.133 E.01705
G1 X160.252 Y90.004 E.36217
G1 X160.793 Y90.004 E.01705
G1 X168.923 Y98.133 E.36217
G1 X169.464 Y98.133 E.01705
G1 X161.334 Y90.004 E.36217
G1 X161.876 Y90.004 E.01705
G1 X170.005 Y98.133 E.36217
G1 X170.546 Y98.133 E.01705
G1 X162.417 Y90.004 E.36217
G1 X162.958 Y90.004 E.01705
G1 X171.088 Y98.133 E.36217
G1 X171.629 Y98.133 E.01705
G1 X163.499 Y90.004 E.36217
G1 X164.04 Y90.004 E.01705
G1 X172.17 Y98.133 E.36217
G1 X172.711 Y98.133 E.01705
G1 X164.582 Y90.004 E.36217
G1 X165.123 Y90.004 E.01705
G1 X173.252 Y98.133 E.36217
G1 X173.794 Y98.133 E.01705
G1 X165.664 Y90.004 E.36217
G1 X166.205 Y90.004 E.01705
G1 X174.335 Y98.133 E.36217
G1 X174.876 Y98.133 E.01705
G1 X166.746 Y90.004 E.36217
G1 X167.288 Y90.004 E.01705
G1 X175.417 Y98.133 E.36217
G1 X175.958 Y98.133 E.01705
G1 X167.829 Y90.004 E.36217
G1 X168.37 Y90.004 E.01705
G1 X176.5 Y98.133 E.36217
G1 X177.041 Y98.133 E.01705
G1 X168.911 Y90.004 E.36217
G1 X169.452 Y90.004 E.01705
G1 X177.582 Y98.133 E.36217
G1 X178.123 Y98.133 E.01705
G1 X169.994 Y90.004 E.36217
G1 X170.535 Y90.004 E.01705
G1 X178.664 Y98.133 E.36217
G1 X179.205 Y98.133 E.01705
G1 X171.076 Y90.004 E.36217
G1 X171.617 Y90.004 E.01705
G1 X179.629 Y98.015 E.35691
G1 X179.629 Y97.474 E.01705
G1 X172.158 Y90.004 E.3328
G1 X172.699 Y90.004 E.01705
G1 X179.629 Y96.933 E.30869
G1 X179.629 Y96.392 E.01705
G1 X173.241 Y90.004 E.28458
G1 X173.782 Y90.004 E.01705
G1 X179.629 Y95.85 E.26047
G1 X179.629 Y95.309 E.01705
G1 X174.323 Y90.004 E.23636
G1 X174.864 Y90.004 E.01705
G1 X179.629 Y94.768 E.21225
G1 X179.629 Y94.227 E.01705
G1 X175.405 Y90.004 E.18814
G1 X175.947 Y90.004 E.01705
G1 X179.629 Y93.686 E.16403
G1 X179.629 Y93.144 E.01705
G1 X176.488 Y90.004 E.13992
G1 X177.029 Y90.004 E.01705
G1 X179.629 Y92.603 E.11581
G1 X179.629 Y92.062 E.01705
G1 X177.57 Y90.004 E.0917
G1 X178.111 Y90.004 E.01705
G1 X179.629 Y91.521 E.06759
G1 X179.629 Y90.98 E.01705
G1 X178.653 Y90.004 E.04348
G1 X179.194 Y90.004 E.01705
G1 X179.798 Y90.608 E.02693
; COOLING_NODE: 0
; WIPE_START
G1 X179.194 Y90.004 E-.32485
G1 X179.049 Y90.004 E-.05515
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I-.232 J1.195 P1  F60000
G1 X190.462 Y92.216 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1500
M204 S50
G1 X190.462 Y98.466 E.20944
G1 X186.166 Y98.466 E.14396
G1 X186.166 Y89.671 E.29475
G1 X190.462 Y89.671 E.14396
G1 X190.462 Y92.156 E.0833
; COOLING_NODE: 0
M204 S250
G1 X190.854 Y92.608 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X190.854 Y95.528 E.09064
G1 X198.354 Y95.528 E.23281
G1 X198.354 Y96.358 E.02576
G1 X190.854 Y96.358 E.23281
G1 X190.854 Y98.858 E.0776
G1 X185.774 Y98.858 E.15769
G1 X185.774 Y89.278 E.29737
G1 X190.854 Y89.278 E.15769
G1 X190.854 Y91.778 E.0776
G1 X198.354 Y91.778 E.23281
G1 X198.354 Y92.608 E.02576
G1 X190.914 Y92.608 E.23094
M204 S10000
G1 X190.658 Y92.193 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.48086
G1 F15000
M204 S8000
G1 X198.158 Y92.193 E.27038
; WIPE_START
G1 X197.158 Y92.193 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I-1.176 J.314 P1  F60000
G1 X198.158 Y95.943 Z3
G1 Z2.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X190.658 Y95.943 E.27038
; WIPE_START
G1 X191.658 Y95.943 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I-.2 J-1.2 P1  F60000
G1 X188.096 Y96.537 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47904
G1 F15000
M204 S8000
G1 X188.532 Y96.537 E.01566
G1 X188.532 Y91.6 E.17721
G1 X188.096 Y91.6 E.01566
G1 X188.096 Y96.477 E.17506
M204 S10000
G1 X187.689 Y96.943 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X188.938 Y96.943 E.03878
G1 X188.938 Y91.194 E.17846
G1 X187.689 Y91.194 E.03878
G1 X187.689 Y96.883 E.1766
M204 S10000
G1 X187.312 Y97.32 F60000
G1 F15000
M204 S8000
G1 X189.316 Y97.32 E.06219
G1 X189.316 Y90.817 E.20187
G1 X187.312 Y90.817 E.06219
G1 X187.312 Y97.26 E.20001
M204 S10000
G1 X186.935 Y97.697 F60000
G1 F15000
M204 S8000
G1 X189.693 Y97.697 E.0856
G1 X189.693 Y90.44 E.22528
G1 X186.935 Y90.44 E.0856
G1 X186.935 Y97.637 E.22341
M204 S10000
G1 X186.558 Y98.074 F60000
G1 F15000
M204 S8000
G1 X190.07 Y98.074 E.109
G1 X190.07 Y90.063 E.24868
G1 X186.558 Y90.063 E.109
G1 X186.558 Y98.014 E.24682
; WIPE_START
G1 X186.558 Y97.014 E-.38
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
    

    

    
        M9711 M0 E0 U266 V97 Z3 S11 C10 O0 T3000
    

    
    
    
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
M106 S198.9
; OBJECT_ID: 756
; COOLING_NODE: 0
G1 X149.354 Y89.278 F60000
G1 Z2.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1500
M204 S50
G1 X149.354 Y98.858 E.29737
G1 X136.774 Y98.858 E.39049
G1 X136.774 Y89.278 E.29737
G1 X149.294 Y89.278 E.38863
; WIPE_START
M204 S8000
G1 X149.3 Y90.278 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I-1.217 J-.025 P1  F60000
G1 X149.146 Y97.824 Z3.2
G1 Z2.8
G1 E.4 F1800
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X148.32 Y98.651 E.03629
G1 X148.186 Y98.785
G1 X147.653 Y98.785
G1 X147.786 Y98.651
G1 X149.146 Y97.291 E.0597
G1 X149.28 Y97.157
G1 X149.28 Y96.624
G1 X149.146 Y96.758
G1 X147.253 Y98.651 E.08311
G1 X147.119 Y98.785
G1 X146.586 Y98.785
G1 X146.72 Y98.651
G1 X149.146 Y96.225 E.10652
G1 X149.28 Y96.091
G1 X149.28 Y95.558
G1 X149.146 Y95.691
G1 X146.187 Y98.651 E.12993
G1 X146.053 Y98.785
G1 X145.52 Y98.785
G1 X145.653 Y98.651
G1 X149.146 Y95.158 E.15334
G1 X149.28 Y95.024
G1 X149.28 Y94.491
G1 X149.146 Y94.625
G1 X145.12 Y98.651 E.17675
G1 X144.986 Y98.785
G1 X144.453 Y98.785
G1 X144.587 Y98.651
G1 X149.146 Y94.091 E.20016
G1 X149.28 Y93.958
G1 X149.28 Y93.425
G1 X149.146 Y93.558
G1 X144.054 Y98.651 E.22357
G1 X143.92 Y98.785
G1 X143.387 Y98.785
G1 X143.52 Y98.651
G1 X149.146 Y93.025 E.24698
G1 X149.28 Y92.891
G1 X149.28 Y92.358
G1 X149.146 Y92.492
G1 X142.987 Y98.651 E.27039
G1 X142.853 Y98.785
G1 X142.32 Y98.785
G1 X142.454 Y98.651
G1 X149.146 Y91.958 E.2938
G1 X149.28 Y91.825
G1 X149.28 Y91.292
G1 X149.146 Y91.425
G1 X141.921 Y98.651 E.3172
G1 X141.787 Y98.785
G1 X141.254 Y98.785
G1 X141.387 Y98.651
G1 X149.146 Y90.892 E.34061
G1 X149.28 Y90.758
G1 X149.28 Y90.225
G1 X149.146 Y90.359
G1 X140.854 Y98.651 E.36402
G1 X140.72 Y98.785
G1 X140.187 Y98.785
G1 X140.321 Y98.651
G1 X149.146 Y89.825 E.38743
G1 X149.28 Y89.692
G1 X149.086 Y89.352
G1 X148.953 Y89.486
G1 X139.787 Y98.651 E.40234
G1 X139.654 Y98.785
G1 X139.121 Y98.785
G1 X139.254 Y98.651
G1 X148.419 Y89.486 E.40234
G1 X148.553 Y89.352
M73 P98 R0
G1 X148.02 Y89.352
G1 X147.886 Y89.486
G1 X138.721 Y98.651 E.40234
G1 X138.587 Y98.785
G1 X138.054 Y98.785
G1 X138.188 Y98.651
G1 X147.353 Y89.486 E.40234
G1 X147.487 Y89.352
G1 X146.953 Y89.352
G1 X146.82 Y89.486
G1 X137.654 Y98.651 E.40234
G1 X137.521 Y98.785
G1 X136.988 Y98.785
G1 X137.121 Y98.651
G1 X146.286 Y89.486 E.40234
G1 X146.42 Y89.352
G1 X145.887 Y89.352
G1 X145.753 Y89.486
G1 X136.981 Y98.258 E.38508
G1 X136.848 Y98.392
G1 X136.848 Y97.858
G1 X136.981 Y97.725
G1 X145.22 Y89.486 E.36167
G1 X145.354 Y89.352
G1 X144.82 Y89.352
G1 X144.687 Y89.486
G1 X136.981 Y97.191 E.33826
G1 X136.848 Y97.325
G1 X136.848 Y96.792
G1 X136.981 Y96.658
G1 X144.153 Y89.486 E.31485
G1 X144.287 Y89.352
G1 X143.754 Y89.352
G1 X143.62 Y89.486
G1 X136.981 Y96.125 E.29144
G1 X136.848 Y96.258
G1 X136.848 Y95.725
G1 X136.981 Y95.592
G1 X143.087 Y89.486 E.26803
G1 X143.221 Y89.352
G1 X142.687 Y89.352
G1 X142.554 Y89.486
G1 X136.981 Y95.058 E.24462
G1 X136.848 Y95.192
G1 X136.848 Y94.659
G1 X136.981 Y94.525
G1 X142.02 Y89.486 E.22121
G1 X142.154 Y89.352
G1 X141.621 Y89.352
G1 X141.487 Y89.486
G1 X136.981 Y93.992 E.1978
G1 X136.848 Y94.125
G1 X136.848 Y93.592
G1 X136.981 Y93.459
G1 X140.954 Y89.486 E.1744
G1 X141.088 Y89.352
G1 X140.554 Y89.352
G1 X140.421 Y89.486
G1 X136.981 Y92.925 E.15099
G1 X136.848 Y93.059
G1 X136.848 Y92.526
G1 X136.981 Y92.392
G1 X139.887 Y89.486 E.12758
G1 X140.021 Y89.352
G1 X139.488 Y89.352
G1 X139.354 Y89.486
G1 X136.981 Y91.859 E.10417
G1 X136.848 Y91.992
G1 X136.848 Y91.459
G1 X136.981 Y91.326
G1 X138.821 Y89.486 E.08076
G1 X138.955 Y89.352
G1 X138.421 Y89.352
G1 X138.288 Y89.486
G1 X136.981 Y90.792 E.05735
G1 X136.848 Y90.926
G1 X136.848 Y90.393
G1 X136.981 Y90.259
G1 X137.754 Y89.486 E.03394
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X137.047 Y90.193 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I.063 J1.215 P1  F60000
G1 X154.774 Y89.278 Z3.2
G1 Z2.8
G1 E.4 F1800
; FEATURE: Outer wall
G1 F2028
M204 S50
G1 X180.354 Y89.278 E.79402
G1 X180.354 Y98.858 E.29737
G1 X154.774 Y98.858 E.79402
G1 X154.774 Y89.338 E.29551
; WIPE_START
G1 F3000
M204 S8000
G1 X155.774 Y89.336 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I-.44 J1.135 P1  F60000
G1 X179.782 Y98.651 Z3.2
G1 Z2.8
G1 E.4 F1800
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X180.146 Y98.286 E.01601
G1 X180.28 Y98.153
G1 X180.28 Y97.62
G1 X180.146 Y97.753
G1 X179.249 Y98.651 E.03941
G1 X179.115 Y98.785
G1 X178.582 Y98.785
G1 X178.715 Y98.651
G1 X180.146 Y97.22 E.06282
G1 X180.28 Y97.086
G1 X180.28 Y96.553
G1 X180.146 Y96.687
G1 X178.182 Y98.651 E.08623
G1 X178.048 Y98.785
G1 X177.515 Y98.785
G1 X177.649 Y98.651
G1 X180.146 Y96.153 E.10964
G1 X180.28 Y96.02
G1 X180.28 Y95.487
G1 X180.146 Y95.62
G1 X177.116 Y98.651 E.13305
G1 X176.982 Y98.785
G1 X176.449 Y98.785
G1 X176.582 Y98.651
G1 X180.146 Y95.087 E.15646
G1 X180.28 Y94.953
G1 X180.28 Y94.42
G1 X180.146 Y94.554
G1 X176.049 Y98.651 E.17987
G1 X175.915 Y98.785
G1 X175.382 Y98.785
G1 X175.516 Y98.651
G1 X180.146 Y94.02 E.20328
G1 X180.28 Y93.887
G1 X180.28 Y93.354
G1 X180.146 Y93.487
G1 X174.982 Y98.651 E.22669
G1 X174.849 Y98.785
G1 X174.316 Y98.785
G1 X174.449 Y98.651
G1 X180.146 Y92.954 E.2501
G1 X180.28 Y92.82
G1 X180.28 Y92.287
G1 X180.146 Y92.421
G1 X173.916 Y98.651 E.27351
G1 X173.782 Y98.785
G1 X173.249 Y98.785
G1 X173.383 Y98.651
G1 X180.146 Y91.887 E.29691
G1 X180.28 Y91.754
G1 X180.28 Y91.22
G1 X180.146 Y91.354
G1 X172.849 Y98.651 E.32032
G1 X172.716 Y98.785
G1 X172.183 Y98.785
G1 X172.316 Y98.651
G1 X180.146 Y90.821 E.34373
G1 X180.28 Y90.687
G1 X180.28 Y90.154
G1 X180.146 Y90.288
G1 X171.783 Y98.651 E.36714
G1 X171.649 Y98.785
G1 X171.116 Y98.785
G1 X171.25 Y98.651
G1 X180.146 Y89.754 E.39055
G1 X180.28 Y89.621
G1 X180.015 Y89.352
G1 X179.882 Y89.486
G1 X170.716 Y98.651 E.40234
G1 X170.583 Y98.785
G1 X170.05 Y98.785
G1 X170.183 Y98.651
G1 X179.348 Y89.486 E.40234
G1 X179.482 Y89.352
G1 X178.949 Y89.352
G1 X178.815 Y89.486
G1 X169.65 Y98.651 E.40234
G1 X169.516 Y98.785
G1 X168.983 Y98.785
G1 X169.117 Y98.651
G1 X178.282 Y89.486 E.40234
G1 X178.416 Y89.352
G1 X177.882 Y89.352
G1 X177.749 Y89.486
G1 X168.583 Y98.651 E.40234
G1 X168.45 Y98.785
G1 X167.917 Y98.785
G1 X168.05 Y98.651
G1 X177.215 Y89.486 E.40234
G1 X177.349 Y89.352
G1 X176.816 Y89.352
G1 X176.682 Y89.486
G1 X167.517 Y98.651 E.40234
G1 X167.383 Y98.785
G1 X166.85 Y98.785
G1 X166.984 Y98.651
G1 X176.149 Y89.486 E.40234
G1 X176.283 Y89.352
G1 X175.749 Y89.352
G1 X175.616 Y89.486
G1 X166.45 Y98.651 E.40234
G1 X166.317 Y98.785
G1 X165.783 Y98.785
G1 X165.917 Y98.651
G1 X175.082 Y89.486 E.40234
G1 X175.216 Y89.352
G1 X174.683 Y89.352
G1 X174.549 Y89.486
G1 X165.384 Y98.651 E.40234
G1 X165.25 Y98.785
G1 X164.717 Y98.785
G1 X164.851 Y98.651
G1 X174.016 Y89.486 E.40234
G1 X174.15 Y89.352
G1 X173.616 Y89.352
G1 X173.483 Y89.486
G1 X164.317 Y98.651 E.40234
G1 X164.184 Y98.785
G1 X163.65 Y98.785
G1 X163.784 Y98.651
G1 X172.949 Y89.486 E.40234
G1 X173.083 Y89.352
G1 X172.55 Y89.352
G1 X172.416 Y89.486
G1 X163.251 Y98.651 E.40234
G1 X163.117 Y98.785
G1 X162.584 Y98.785
G1 X162.718 Y98.651
G1 X171.883 Y89.486 E.40234
G1 X172.016 Y89.352
G1 X171.483 Y89.352
G1 X171.35 Y89.486
G1 X162.184 Y98.651 E.40234
G1 X162.051 Y98.785
G1 X161.517 Y98.785
G1 X161.651 Y98.651
G1 X170.816 Y89.486 E.40234
G1 X170.95 Y89.352
G1 X170.417 Y89.352
G1 X170.283 Y89.486
G1 X161.118 Y98.651 E.40234
G1 X160.984 Y98.785
G1 X160.451 Y98.785
G1 X160.585 Y98.651
G1 X169.75 Y89.486 E.40234
G1 X169.883 Y89.352
G1 X169.35 Y89.352
G1 X169.217 Y89.486
G1 X160.051 Y98.651 E.40234
G1 X159.918 Y98.785
G1 X159.384 Y98.785
G1 X159.518 Y98.651
G1 X168.683 Y89.486 E.40234
G1 X168.817 Y89.352
G1 X168.284 Y89.352
G1 X168.15 Y89.486
G1 X158.985 Y98.651 E.40234
G1 X158.851 Y98.785
G1 X158.318 Y98.785
G1 X158.452 Y98.651
G1 X167.617 Y89.486 E.40234
G1 X167.75 Y89.352
G1 X167.217 Y89.352
G1 X167.084 Y89.486
G1 X157.918 Y98.651 E.40234
G1 X157.785 Y98.785
G1 X157.251 Y98.785
G1 X157.385 Y98.651
G1 X166.55 Y89.486 E.40234
G1 X166.684 Y89.352
G1 X166.151 Y89.352
G1 X166.017 Y89.486
G1 X156.852 Y98.651 E.40234
G1 X156.718 Y98.785
G1 X156.185 Y98.785
G1 X156.318 Y98.651
G1 X165.484 Y89.486 E.40234
G1 X165.617 Y89.352
G1 X165.084 Y89.352
G1 X164.95 Y89.486
G1 X155.785 Y98.651 E.40234
G1 X155.652 Y98.785
G1 X155.118 Y98.785
G1 X155.252 Y98.651
G1 X164.417 Y89.486 E.40234
G1 X164.551 Y89.352
G1 X164.018 Y89.352
G1 X163.884 Y89.486
G1 X154.981 Y98.389 E.39082
G1 X154.848 Y98.522
G1 X154.848 Y97.989
G1 X154.981 Y97.855
G1 X163.351 Y89.486 E.36741
G1 X163.484 Y89.352
G1 X162.951 Y89.352
G1 X162.817 Y89.486
G1 X154.981 Y97.322 E.344
G1 X154.848 Y97.456
G1 X154.848 Y96.922
G1 X154.981 Y96.789
G1 X162.284 Y89.486 E.32059
G1 X162.418 Y89.352
G1 X161.885 Y89.352
G1 X161.751 Y89.486
G1 X154.981 Y96.256 E.29718
G1 X154.848 Y96.389
G1 X154.848 Y95.856
G1 X154.981 Y95.722
G1 X161.218 Y89.486 E.27377
G1 X161.351 Y89.352
G1 X160.818 Y89.352
G1 X160.684 Y89.486
M73 P99 R0
G1 X154.981 Y95.189 E.25036
G1 X154.848 Y95.323
G1 X154.848 Y94.789
G1 X154.981 Y94.656
G1 X160.151 Y89.486 E.22695
G1 X160.285 Y89.352
G1 X159.752 Y89.352
G1 X159.618 Y89.486
G1 X154.981 Y94.123 E.20354
G1 X154.848 Y94.256
G1 X154.848 Y93.723
G1 X154.981 Y93.589
G1 X159.085 Y89.486 E.18014
G1 X159.218 Y89.352
G1 X158.685 Y89.352
G1 X158.551 Y89.486
G1 X154.981 Y93.056 E.15673
G1 X154.848 Y93.19
G1 X154.848 Y92.656
G1 X154.981 Y92.523
G1 X158.018 Y89.486 E.13332
G1 X158.152 Y89.352
G1 X157.619 Y89.352
G1 X157.485 Y89.486
G1 X154.981 Y91.99 E.10991
G1 X154.848 Y92.123
G1 X154.848 Y91.59
G1 X154.981 Y91.456
G1 X156.952 Y89.486 E.0865
G1 X157.085 Y89.352
G1 X156.552 Y89.352
G1 X156.418 Y89.486
G1 X154.981 Y90.923 E.06309
G1 X154.848 Y91.057
G1 X154.848 Y90.523
G1 X154.981 Y90.39
G1 X155.885 Y89.486 E.03968
G1 X156.019 Y89.352
G1 X155.485 Y89.352
G1 X155.352 Y89.486
G1 X154.981 Y89.857 E.01627
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X155.352 Y89.486 E-.1992
G1 X155.485 Y89.352 E-.07182
G1 X155.772 Y89.352 E-.10898
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I-.112 J1.212 P1  F60000
G1 X190.854 Y92.608 Z3.2
G1 Z2.8
G1 E.4 F1800
; FEATURE: Outer wall
G1 F1500
M204 S50
G1 X190.854 Y95.528 E.09064
G1 X198.354 Y95.528 E.23281
G1 X198.354 Y96.358 E.02576
G1 X190.854 Y96.358 E.23281
G1 X190.854 Y98.858 E.0776
G1 X185.774 Y98.858 E.15769
G1 X185.774 Y89.278 E.29737
G1 X190.854 Y89.278 E.15769
G1 X190.854 Y91.778 E.0776
G1 X198.354 Y91.778 E.23281
G1 X198.354 Y92.608 E.02576
G1 X190.914 Y92.608 E.23094
M204 S10000
G1 X190.658 Y92.193 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.48086
G1 F15000
M204 S8000
G1 X198.158 Y92.193 E.27038
; WIPE_START
G1 X197.158 Y92.193 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I-1.176 J.314 P1  F60000
G1 X198.158 Y95.943 Z3.2
G1 Z2.8
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X190.658 Y95.943 E.27038
; WIPE_START
G1 X191.658 Y95.943 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I-1.023 J-.659 P1  F60000
G1 X189.914 Y98.651 Z3.2
G1 Z2.8
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F12000
M204 S2000
G1 X190.646 Y97.918 E.03216
G1 X190.78 Y97.785
G1 X190.78 Y97.251
G1 X190.646 Y97.385
G1 X189.38 Y98.651 E.05557
G1 X189.247 Y98.785
G1 X188.714 Y98.785
G1 X188.847 Y98.651
G1 X190.646 Y96.852 E.07898
G1 X190.78 Y96.718
G1 X190.707 Y96.258
G1 X190.574 Y96.391
G1 X188.314 Y98.651 E.0992
G1 X188.18 Y98.785
G1 X187.647 Y98.785
G1 X187.781 Y98.651
G1 X190.45 Y95.981 E.1172
G1 X190.584 Y95.848
G1 X190.78 Y95.118
G1 X190.646 Y95.252
G1 X187.247 Y98.651 E.14921
G1 X187.114 Y98.785
G1 X186.581 Y98.785
G1 X186.714 Y98.651
G1 X190.646 Y94.719 E.17262
G1 X190.78 Y94.585
G1 X190.78 Y94.052
G1 X190.646 Y94.186
G1 X186.181 Y98.651 E.19603
G1 X186.047 Y98.785
G1 X185.848 Y98.451
G1 X185.981 Y98.318
G1 X190.646 Y93.652 E.2048
G1 X190.78 Y93.519
G1 X190.78 Y92.985
G1 X190.646 Y93.119
G1 X185.981 Y97.784 E.2048
G1 X185.848 Y97.918
G1 X185.848 Y97.385
G1 X185.981 Y97.251
G1 X190.591 Y92.641 E.20236
G1 X190.724 Y92.508
G1 X190.584 Y92.115
G1 X190.45 Y92.248
G1 X185.981 Y96.718 E.1962
G1 X185.848 Y96.851
G1 X185.848 Y96.318
G1 X185.981 Y96.185
G1 X190.646 Y91.519 E.2048
G1 X190.78 Y91.386
G1 X190.78 Y90.852
G1 X190.646 Y90.986
G1 X185.981 Y95.651 E.2048
G1 X185.848 Y95.785
G1 X185.848 Y95.252
G1 X185.981 Y95.118
G1 X190.646 Y90.453 E.2048
G1 X190.78 Y90.319
G1 X190.78 Y89.786
G1 X190.646 Y89.92
G1 X185.981 Y94.585 E.2048
G1 X185.848 Y94.718
G1 X185.848 Y94.185
G1 X185.981 Y94.052
G1 X190.547 Y89.486 E.20043
G1 X190.68 Y89.352
G1 X190.147 Y89.352
G1 X190.014 Y89.486
G1 X185.981 Y93.518 E.17702
G1 X185.848 Y93.652
G1 X185.848 Y93.119
G1 X185.981 Y92.985
G1 X189.48 Y89.486 E.15361
G1 X189.614 Y89.352
G1 X189.081 Y89.352
G1 X188.947 Y89.486
G1 X185.981 Y92.452 E.1302
G1 X185.848 Y92.585
G1 X185.848 Y92.052
G1 X185.981 Y91.918
G1 X188.414 Y89.486 E.10679
G1 X188.547 Y89.352
G1 X188.014 Y89.352
G1 X187.881 Y89.486
G1 X185.981 Y91.385 E.08338
G1 X185.848 Y91.519
G1 X185.848 Y90.986
G1 X185.981 Y90.852
G1 X187.347 Y89.486 E.05997
G1 X187.481 Y89.352
G1 X186.948 Y89.352
G1 X186.814 Y89.486
G1 X185.981 Y90.319 E.03656
; WIPE_START
M204 S8000
G1 X186.688 Y89.612 E-.38
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
    

    

    
        M9711 M0 E0 U266 V97 Z3.2 S11 C10 O0 T3000
    

    
    
    
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

