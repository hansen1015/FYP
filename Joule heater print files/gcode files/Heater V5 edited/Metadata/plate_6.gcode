; HEADER_BLOCK_START
; BambuStudio 02.06.00.51
; model printing time: 17m 55s; total estimated time: 23m 3s
; total layer number: 12
; total filament length [mm] : 481.48,113.84,160.31
; total filament volume [cm^3] : 1158.09,273.82,385.58
; total filament weight [g] : 1.46,0.35,0.48
; filament_density: 1.26,1.26,1.25
; filament_diameter: 1.75,1.75,1.75
; max_z_height: 2.40
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
M73 P0 R23
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




    M620.14 X173.895 Y77.8773



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
    
M73 P1 R22
    G1 E-3 F1800
    M400 P500
    G150.2
    G150.1


G91
M73 P2 R22
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
M73 P21 R18
M73 C3
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
    G29 A1 O X137.935 Y25.904 I46 J67.0519 R 
    M400
M623
    
M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X137.935 Y25.904 I46 J67.0519 R
    
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
M73 C2
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
; layer num/total_layer_count: 1/12
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
M106 P2 S0
; OBJECT_ID: 423
M73 P22 R17
G1 X178.642 Y32.697 F60000
M204 S6000
G1 Z1
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
; LAYER_HEIGHT: 0.2
G1 F3000
M204 S500
G1 X166.228 Y32.697 E.4671
G1 X166.228 Y35.047 E.08842
G1 X138.792 Y35.047 E1.03231
G1 X138.792 Y26.761 E.31177
G1 X143.228 Y26.761 E.16691
G1 X143.228 Y29.111 E.08842
G1 X155.642 Y29.111 E.4671
G1 X155.642 Y26.761 E.08842
G1 X166.228 Y26.761 E.39831
G1 X166.228 Y29.111 E.08842
G1 X178.642 Y29.111 E.4671
G1 X178.642 Y26.761 E.08842
G1 X183.078 Y26.761 E.16691
G1 X183.078 Y35.047 E.31177
G1 X178.642 Y35.047 E.16691
G1 X178.642 Y32.757 E.08616
M204 S6000
G1 X178.185 Y33.154 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X166.685 Y33.154 E.4327
G1 X166.685 Y35.504 E.08842
G1 X138.335 Y35.504 E1.06671
G1 X138.335 Y26.304 E.34616
G1 X143.685 Y26.304 E.2013
G1 X143.685 Y28.654 E.08842
G1 X155.185 Y28.654 E.4327
G1 X155.185 Y26.304 E.08842
G1 X166.685 Y26.304 E.4327
G1 X166.685 Y28.654 E.08842
G1 X178.185 Y28.654 E.4327
G1 X178.185 Y26.304 E.08842
G1 X183.535 Y26.304 E.2013
G1 X183.535 Y35.504 E.34616
G1 X178.185 Y35.504 E.2013
G1 X178.185 Y33.214 E.08616
; WIPE_START
G1 X177.185 Y33.209 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I.831 J.889 P1  F60000
G1 X182.895 Y27.872 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50193
G1 F6300
M204 S500
G1 X182.172 Y27.15 E.0386
G1 X181.523 Y27.15 E.02453
G1 X182.689 Y28.315 E.0623
G1 X182.689 Y28.965 E.02453
G1 X180.874 Y27.15 E.09699
G1 X180.225 Y27.15 E.02453
G1 X182.689 Y29.614 E.13167
G1 X182.689 Y30.263 E.02453
G1 X179.576 Y27.15 E.16636
G1 X179.03 Y27.15 E.02062
G1 X179.03 Y27.253 E.00391
G1 X182.689 Y30.912 E.19551
G1 X182.689 Y31.561 E.02453
G1 X179.03 Y27.902 E.19551
G1 X179.03 Y28.551 E.02453
G1 X182.689 Y32.21 E.19551
G1 X182.689 Y32.859 E.02453
G1 X179.03 Y29.2 E.19551
G1 X179.03 Y29.5 E.0113
G1 X178.68 Y29.5 E.01323
G1 X182.689 Y33.508 E.21422
G1 X182.689 Y34.158 E.02453
G1 X178.031 Y29.5 E.24891
G1 X177.382 Y29.5 E.02453
G1 X182.541 Y34.658 E.27567
G1 X181.892 Y34.658 E.02453
G1 X176.733 Y29.5 E.27567
G1 X176.084 Y29.5 E.02453
G1 X181.242 Y34.658 E.27567
G1 X180.593 Y34.658 E.02453
G1 X179.03 Y33.095 E.08352
G1 X179.03 Y33.744 E.02453
G1 X179.944 Y34.658 E.04884
G1 X179.295 Y34.658 E.02453
G1 X178.825 Y34.188 E.02514
; WIPE_START
G1 X179.295 Y34.658 E-.25283
G1 X179.63 Y34.658 E-.12717
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.066 J-.587 P1  F60000
G1 X178.449 Y32.514 Z.6
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X175.434 Y29.5 E.16109
M73 P23 R17
G1 X174.785 Y29.5 E.02453
G1 X177.594 Y32.308 E.1501
G1 X176.945 Y32.308 E.02453
G1 X174.136 Y29.5 E.1501
G1 X173.487 Y29.5 E.02453
G1 X176.296 Y32.308 E.1501
G1 X175.647 Y32.308 E.02453
G1 X172.838 Y29.5 E.1501
G1 X172.189 Y29.5 E.02453
G1 X174.998 Y32.308 E.1501
G1 X174.348 Y32.308 E.02453
G1 X171.54 Y29.5 E.1501
G1 X170.89 Y29.5 E.02453
G1 X173.699 Y32.308 E.1501
G1 X173.05 Y32.308 E.02453
G1 X170.241 Y29.5 E.1501
G1 X169.592 Y29.5 E.02453
G1 X172.401 Y32.308 E.1501
G1 X171.752 Y32.308 E.02453
G1 X168.943 Y29.5 E.1501
G1 X168.294 Y29.5 E.02453
G1 X171.103 Y32.308 E.1501
G1 X170.454 Y32.308 E.02453
G1 X167.645 Y29.5 E.1501
G1 X166.996 Y29.5 E.02453
G1 X170.01 Y32.514 E.16109
; WIPE_START
G1 X169.303 Y31.807 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I.935 J-.779 P1  F60000
G1 X166.045 Y27.9 Z.6
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X165.295 Y27.15 E.04008
G1 X164.646 Y27.15 E.02453
G1 X166.045 Y28.549 E.07476
; WIPE_START
G1 X165.338 Y27.842 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I.611 J-1.053 P1  F60000
G1 X163.791 Y26.944 Z.6
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X165.839 Y28.992 E.10945
G1 X165.839 Y29.5 E.01917
G1 X166.346 Y29.5 E.01917
G1 X169.155 Y32.308 E.1501
G1 X168.506 Y32.308 E.02453
G1 X163.347 Y27.15 E.27567
G1 X162.698 Y27.15 E.02453
G1 X167.857 Y32.308 E.27567
G1 X167.208 Y32.308 E.02453
G1 X162.049 Y27.15 E.27567
G1 X161.4 Y27.15 E.02453
G1 X166.559 Y32.308 E.27567
G1 X165.91 Y32.308 E.02453
G1 X160.751 Y27.15 E.27567
G1 X160.102 Y27.15 E.02453
G1 X165.839 Y32.887 E.30659
G1 X165.839 Y33.536 E.02453
G1 X159.453 Y27.15 E.34127
G1 X158.803 Y27.15 E.02453
G1 X165.839 Y34.185 E.37596
G1 X165.839 Y34.658 E.01788
G1 X165.663 Y34.658 E.00665
G1 X158.154 Y27.15 E.40125
G1 X157.505 Y27.15 E.02453
G1 X165.014 Y34.658 E.40125
G1 X164.365 Y34.658 E.02453
G1 X156.856 Y27.15 E.40125
G1 X156.207 Y27.15 E.02453
G1 X163.716 Y34.658 E.40125
G1 X163.067 Y34.658 E.02453
G1 X156.03 Y27.622 E.376
G1 X156.03 Y28.271 E.02453
G1 X162.417 Y34.658 E.34131
G1 X161.768 Y34.658 E.02453
G1 X156.03 Y28.92 E.30662
G1 X156.03 Y29.5 E.02189
G1 X155.96 Y29.5 E.00264
G1 X161.119 Y34.658 E.27567
G1 X160.47 Y34.658 E.02453
G1 X155.311 Y29.5 E.27567
G1 X154.662 Y29.5 E.02453
G1 X159.821 Y34.658 E.27567
G1 X159.172 Y34.658 E.02453
G1 X154.013 Y29.5 E.27567
G1 X153.364 Y29.5 E.02453
G1 X158.523 Y34.658 E.27567
G1 X157.873 Y34.658 E.02453
G1 X152.715 Y29.5 E.27567
G1 X152.065 Y29.5 E.02453
G1 X157.224 Y34.658 E.27567
G1 X156.575 Y34.658 E.02453
G1 X151.416 Y29.5 E.27567
G1 X150.767 Y29.5 E.02453
G1 X155.926 Y34.658 E.27567
G1 X155.277 Y34.658 E.02453
G1 X150.118 Y29.5 E.27567
G1 X149.469 Y29.5 E.02453
G1 X154.628 Y34.658 E.27567
G1 X153.979 Y34.658 E.02453
G1 X148.82 Y29.5 E.27567
G1 X148.171 Y29.5 E.02453
G1 X153.329 Y34.658 E.27567
G1 X152.68 Y34.658 E.02453
G1 X147.521 Y29.5 E.27567
G1 X146.872 Y29.5 E.02453
G1 X152.031 Y34.658 E.27567
G1 X151.382 Y34.658 E.02453
G1 X146.223 Y29.5 E.27567
G1 X145.574 Y29.5 E.02453
G1 X150.733 Y34.658 E.27567
G1 X150.084 Y34.658 E.02453
G1 X144.925 Y29.5 E.27567
G1 X144.276 Y29.5 E.02453
G1 X149.435 Y34.658 E.27567
G1 X148.786 Y34.658 E.02453
G1 X143.421 Y29.294 E.28666
; WIPE_START
G1 X144.128 Y30.001 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.108 J-.504 P1  F60000
G1 X143.045 Y27.619 Z.6
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X142.575 Y27.15 E.0251
G1 X141.926 Y27.15 E.02453
G1 X142.839 Y28.063 E.0488
G1 X142.839 Y28.712 E.02453
G1 X141.277 Y27.15 E.08349
G1 X140.628 Y27.15 E.02453
G1 X148.136 Y34.658 E.40125
G1 X147.487 Y34.658 E.02453
G1 X139.978 Y27.15 E.40125
G1 X139.329 Y27.15 E.02453
M73 P24 R17
G1 X146.838 Y34.658 E.40125
G1 X146.189 Y34.658 E.02453
G1 X139.18 Y27.65 E.37452
G1 X139.18 Y28.299 E.02453
G1 X145.54 Y34.658 E.33983
G1 X144.891 Y34.658 E.02453
G1 X139.18 Y28.948 E.30515
G1 X139.18 Y29.597 E.02453
G1 X144.242 Y34.658 E.27046
G1 X143.592 Y34.658 E.02453
G1 X139.18 Y30.246 E.23577
G1 X139.18 Y30.895 E.02453
G1 X142.943 Y34.658 E.20108
G1 X142.294 Y34.658 E.02453
G1 X139.18 Y31.544 E.1664
G1 X139.18 Y32.194 E.02453
G1 X141.645 Y34.658 E.13171
G1 X140.996 Y34.658 E.02453
G1 X139.18 Y32.843 E.09702
G1 X139.18 Y33.492 E.02453
G1 X140.347 Y34.658 E.06233
G1 X139.698 Y34.658 E.02453
G1 X138.975 Y33.935 E.03864
; WIPE_START
G1 X139.682 Y34.642 E-.38
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
    

    

    
        M9711 M0 E0 U252 V34 Z0.6 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

M204 S6000
G1 X169.392 Y89.877
G1 Z.2
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S6000
G1  X169.892 Y90.877  
M204 S500
G3  X167.433 Y92.922   I-4.377 J-2.762 E0.1236 F3000
G3  X164.774 Y91.666   I0.009 J-3.462 E0.1154
G2  X162.070 Y90.877   I-2.710 J4.259 E0.1085
G2  X150.024 Y90.881   I-5.928 J318.375 E0.4578
G2  X146.077 Y92.763   I0.501 J6.129 E0.1699
G3  X143.766 Y92.330   I-0.852 J-1.839 E0.0953
G3  X140.704 Y89.059   I16.406 J-18.427 E0.1705
G3  X141.538 Y86.104   I2.026 J-1.023 E0.1282
G2  X142.392 Y83.571   I-3.390 J-2.554 E0.1033
G2  X142.389 Y72.013   I-283.960 J-5.694 E0.4393
G2  X141.284 Y69.349   I-4.224 J0.190 E0.1118
G1 E-0.4000 F1800
M204 S6000
G1  X140.479 Y67.153   F600
G1 E0.4000 F1800
M204 S500
G3  X140.881 Y66.475   I1.906 J0.672 E0.0302 F3000
G3  X143.999 Y63.213   I19.448 J15.469 E0.1717
G3  X147.197 Y63.871   I1.278 J1.891 E0.1383
G2  X150.214 Y64.877   I3.023 J-4.037 E0.1230
G1  X156.142  E0.2253
G1  X157.392  E0.0475
G2  X163.016 Y64.787   I2.339 J-29.659 E0.2141
G2  X166.351 Y62.929   I-2.882 J-9.098 E0.1461
G3  X168.518 Y63.424   I0.711 J1.877 E0.0895
G3  X171.580 Y66.695   I-16.399 J18.421 E0.1705
G3  X170.746 Y69.650   I-2.026 J1.023 E0.1282
G2  X169.892 Y72.183   I3.390 J2.554 E0.1033
G2  X169.895 Y83.741   I283.960 J5.694 E0.4393
G2  X171.738 Y87.306   I6.625 J-1.166 E0.1549
G3  X171.403 Y89.279   I-1.652 J0.734 E0.0806
G1  X169.892 Y90.877   E0.0836
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
G1 X143.142 Y65.627
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
G1  X169.142 Y65.627  E2.0691 F7836
G1  Y66.627  E0.0796
G1  X143.142  E2.0691
G1  Y67.627  E0.0796
G1  X169.142  E2.0691
M632 S2 M N
M204 S6000
G1  Y68.127 
G1  X143.642  F4500
G1  Y67.127 
G1  X168.642 
G1  Y66.127 
G1  X143.642 
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




    M620.14 X140.892 Y68.3773



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
M73 E12

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
M73 P26 R16
M73 C1
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
M73 P27 R16
G1 X142.892 Y68.377 F60000
G1 Z.2
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL1
; LINE_WIDTH: 0.500000
; LINE_WIDTH: 0.500000
M204 S500
G1  X145.892 Y68.377  E0.1140 F990
G1 E-0.4000 F1800
M204 S6000
G1  X141.392  F600
G1  X142.892  F240
G1  X143.392  F600
G1  Y68.877 
G1  X142.392 
G1  Y67.877 
G1  X143.892 
G1  Y69.377 
G1  X141.892 
G1  Y67.377 
G1  X145.892 Y68.377   F990
G1 E0.4000 F1800
M204 S500
G1  X169.392  E0.8931 F990
G1  Y68.877  E0.0190
G1  X142.892  E1.0072 F1125
G1  Y69.377  E0.0190
G1  X169.392  E1.0072 F1374
G1  Y69.877  E0.0190
G1  X142.892  E1.0072 F2625
G1  Y70.377  E0.0190
G1  X169.392  E1.0072 F2675
G1  Y70.877  E0.0190
G1  X142.892  E1.0072
G1  Y71.377  E0.0190
G1  X169.392  E1.0072
G1  Y71.877  E0.0190
G1  X142.892  E1.0072
G1  Y72.377  E0.0190
G1  X169.392  E1.0072
G1  Y72.877  E0.0190
G1  X142.892  E1.0072
G1  Y73.377  E0.0190
G1  X169.392  E1.0072
G1  Y73.877  E0.0190
G1  X142.892  E1.0072
G1  Y74.377  E0.0190
G1  X169.392  E1.0072
G1  Y74.877  E0.0190
G1  X142.892  E1.0072
G1  Y75.377  E0.0190
M73 P28 R16
G1  X169.392  E1.0072
G1  Y75.877  E0.0190
G1  X142.892  E1.0072
G1  Y76.377  E0.0190
G1  X169.392  E1.0072
G1  Y76.877  E0.0190
G1  X142.892  E1.0072
G1  Y77.377  E0.0190
G1  X169.392  E1.0072
; LINE_WIDTH: 0.500000
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y90.377   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S500
G1  X142.892  E1.0072 F3000
G1  Y78.127  E0.4656
G1  X169.392  E1.0072
G1  Y90.377  E0.4656
M204 S6000
G1  X143.892 Y78.127  
;--------------------
; CP EMPTY GRID START
; layer #2
M204 S500
G1  Y78.627  E0.0190
G1  X168.892  E0.9502
G1  Y79.138  E0.0194
G1  X143.392  E0.9692
G1  Y79.650  E0.0194
G1  X168.892  E0.9692
G1  Y80.161  E0.0194
G1  X143.392  E0.9692
G1  Y80.672  E0.0194
G1  X168.892  E0.9692
G1  Y81.184  E0.0194
G1  X143.392  E0.9692
G1  Y81.695  E0.0194
G1  X168.892  E0.9692
G1  Y82.207  E0.0194
G1  X143.392  E0.9692
G1  Y82.718  E0.0194
G1  X168.892  E0.9692
G1  Y83.229  E0.0194
G1  X143.392  E0.9692
G1  Y83.741  E0.0194
G1  X168.892  E0.9692
G1  Y84.252  E0.0194
G1  X143.392  E0.9692
G1  Y84.763  E0.0194
M73 P29 R16
G1  X168.892  E0.9692
G1  Y85.275  E0.0194
G1  X143.392  E0.9692
G1  Y85.786  E0.0194
G1  X168.892  E0.9692
G1  Y86.297  E0.0194
G1  X143.392  E0.9692
G1  Y86.809  E0.0194
G1  X168.892  E0.9692
G1  Y87.320  E0.0194
G1  X143.392  E0.9692
G1  Y87.832  E0.0194
G1  X168.892  E0.9692
G1  Y88.343  E0.0194
G1  X143.392  E0.9692
G1  Y88.854  E0.0194
G1  X168.892  E0.9692
G1  Y89.366  E0.0194
G1  X143.392  E0.9692
G1  Y89.877  E0.0194
G1  X168.892  E0.9692
G1  Y90.377  E0.0190
; CP EMPTY GRID END
;------------------






; WIPE_TOWER_END

; WIPE_START
G1 F6300
M204 S500
G1 X168.172 Y89.684 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.217 J0 P1  F60000
; OBJECT_ID: 423
M204 S6000
G1 X144.642 Y27.697
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
; LAYER_HEIGHT: 0.2
G1 F3000
M204 S500
G1 X144.642 Y26.761 E.03557
G1 X154.228 Y26.761 E.36432
G1 X154.228 Y27.697 E.03557
G1 X144.702 Y27.697 E.36204
M204 S6000
G1 X144.185 Y28.154 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X144.185 Y26.304 E.07031
G1 X154.685 Y26.304 E.39907
G1 X154.685 Y28.154 E.07031
G1 X144.245 Y28.154 E.39679
; WIPE_START
G1 X144.212 Y27.154 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I-.02 J1.217 P1  F60000
G1 X177.228 Y27.697 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X167.642 Y27.697 E.36432
G1 X167.642 Y26.761 E.03557
G1 X177.228 Y26.761 E.36432
G1 X177.228 Y27.637 E.03329
M204 S6000
G1 X177.685 Y28.154 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X167.185 Y28.154 E.39907
G1 X167.185 Y26.304 E.07031
G1 X177.685 Y26.304 E.39907
G1 X177.685 Y28.094 E.06803
; WIPE_START
G1 X176.685 Y28.1 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I-.674 J-1.013 P1  F60000
G1 X167.642 Y34.111 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X177.228 Y34.111 E.36432
G1 X177.228 Y35.047 E.03557
G1 X167.642 Y35.047 E.36432
G1 X167.642 Y34.171 E.03329
M204 S6000
G1 X167.185 Y33.654 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X177.685 Y33.654 E.39907
G1 X177.685 Y35.504 E.07031
G1 X167.185 Y35.504 E.39907
G1 X167.185 Y33.714 E.06803
; WIPE_START
G1 X168.185 Y33.708 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I-1.145 J-.413 P1  F60000
G1 X167.87 Y34.579 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.52172
G1 F3000
M204 S500
G1 X176.999 Y34.579 E.36344
; WIPE_START
G1 X175.999 Y34.579 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.206 J.164 P1  F60000
G1 X176.999 Y27.229 Z.6
G1 Z.2
G1 E.4 F1800
G1 F3000
M204 S500
G1 X167.87 Y27.229 E.36344
; WIPE_START
G1 X168.87 Y27.229 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I0 J-1.217 P1  F60000
G1 X153.999 Y27.229 Z.6
G1 Z.2
G1 E.4 F1800
M73 P30 R16
G1 F3000
M204 S500
G1 X144.87 Y27.229 E.36344
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X145.87 Y27.229 E-.38
; WIPE_END
G1 E-.02 F1800
; layer num/total_layer_count: 2/12
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
M106 S255
M106 P2 S191
; open powerlost recovery
M1003 S1
; OBJECT_ID: 423
M204 S10000
G17
G3 Z.6 I-.48 J-1.118 P1  F60000
G1 X144.537 Y27.802 Z.6
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X144.537 Y26.506 E.04386
G1 X154.333 Y26.506 E.33158
G1 X154.333 Y27.802 E.04386
G1 X144.597 Y27.802 E.32955
M204 S250
G1 X144.145 Y28.194 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X144.145 Y26.114 E.06522
G1 X154.725 Y26.114 E.33173
G1 X154.725 Y28.194 E.06522
G1 X144.205 Y28.194 E.32985
; WIPE_START
M204 S8000
G1 X144.176 Y27.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-.022 J1.217 P1  F60000
G1 X177.333 Y27.802 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X167.537 Y27.802 E.33158
G1 X167.537 Y26.506 E.04386
G1 X177.333 Y26.506 E.33158
G1 X177.333 Y27.742 E.04183
M204 S250
G1 X177.725 Y28.194 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X167.145 Y28.194 E.33173
G1 X167.145 Y26.114 E.06522
G1 X177.725 Y26.114 E.33173
G1 X177.725 Y28.134 E.06334
; WIPE_START
M204 S8000
G1 X176.725 Y28.14 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-.655 J-1.026 P1  F60000
G1 X167.537 Y34.006 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X177.333 Y34.006 E.33158
G1 X177.333 Y35.302 E.04386
G1 X167.537 Y35.302 E.33158
G1 X167.537 Y34.066 E.04183
M204 S250
G1 X167.145 Y33.614 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X177.725 Y33.614 E.33173
G1 X177.725 Y35.694 E.06522
G1 X167.145 Y35.694 E.33173
G1 X167.145 Y33.674 E.06334
; WIPE_START
M204 S8000
G1 X168.145 Y33.668 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-1.184 J-.282 P1  F60000
G1 X167.962 Y34.432 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.487325
G1 F14176.258
M204 S8000
G1 X167.962 Y34.876 E.01642
G1 X176.907 Y34.876 E.33052
G1 X176.907 Y34.432 E.01642
G1 X168.022 Y34.432 E.3283
; WIPE_START
G1 X169.022 Y34.432 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.203 J-.181 P1  F60000
G1 X167.962 Y27.376 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.48733
G1 F14176.098
M204 S8000
G1 X176.907 Y27.376 E.33052
G1 X176.907 Y26.932 E.01642
G1 X167.962 Y26.932 E.33052
G1 X167.962 Y27.316 E.01421
; WIPE_START
G1 X167.962 Y26.932 E-.14608
G1 X168.578 Y26.932 E-.23392
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-.037 J-1.216 P1  F60000
G1 X153.907 Y27.376 Z.8
G1 Z.4
G1 E.4 F1800
G1 F14176.098
M204 S8000
G1 X153.907 Y26.932 E.01642
G1 X144.962 Y26.932 E.33052
G1 X144.962 Y27.376 E.01642
G1 X153.847 Y27.376 E.3283
; WIPE_START
G1 X152.847 Y27.376 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.217 J0 P1  F60000
;===== machine: H2C timelapse =====
;======== date: 20260122 ========

; SKIPPABLE_START
; SKIPTYPE: timelapse

M1002 judge_flag timelapse_record_flag
M622 J1
    
        M993 A2 B2 C2
        M993 A0 B0 C0
    

    

    
        M9711 M0 E0 U252 V34 Z0.8 S11 C10 O0 T3000
    

    
    
    
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
G1 X143.142 Y65.627
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
G1  X169.142 Y65.627  E2.0691 F6583
G1  Y67.127  E0.1194
G1  X143.142  E2.0691
M632 S0 M N
M204 S10000
G1  Y67.877 
G1  X168.642  F3000
G1  Y66.377 
G1  X143.642 
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



    M620.14 X171.392 Y77.3773



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
M73 E11

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
M73 P32 R15
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
M106 S193.8
M106 P2 S191

; filament start gcode
G1 X169.392 Y77.377 F60000
G1 Z.4
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X166.392 Y77.377  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X170.892  F600
G1  X169.392  F240
G1  X169.892  F600
G1  Y77.877 
G1  X168.892 
G1  Y76.877 
G1  X170.392 
G1  Y78.377 
G1  X168.392 
G1  Y76.377 
G1  X166.392 Y77.377   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X142.892  E0.8931 F1782
M73 P33 R15
G1  Y76.627  E0.0285
M632 S1 W
M400
M104 T1 S140 N0 ;Multi extruder pre heating
M633
G1  X169.392  E1.0072 F2025
G1  Y75.877  E0.0285
G1  X142.892  E1.0072 F2473
G1  Y75.127  E0.0285
G1  X169.392  E1.0072 F4725
G1  Y74.377  E0.0285
G1  X142.892  E1.0072 F4775
G1  Y73.627  E0.0285
G1  X169.392  E1.0072
G1  Y72.877  E0.0285
G1  X142.892  E1.0072
G1  Y72.127  E0.0285
G1  X169.392  E1.0072
G1  Y71.377  E0.0285
G1  X142.892  E1.0072
G1  Y70.627  E0.0285
G1  X169.392  E1.0072
G1  Y69.877  E0.0285
G1  X142.892  E1.0072
G1  Y69.127  E0.0285
G1  X169.392  E1.0072
G1  Y68.377  E0.0285
G1  X142.892  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y90.377   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S8000
G1  Y78.127  E0.4656
G1  X169.392  E1.0072
G1  Y90.377  E0.4656
G1  X142.892  E1.0072
M204 S10000
G1  X143.892 Y78.127  
;--------------------
; CP EMPTY GRID START
; layer #3
M204 S8000
G1  Y90.377  E0.4656
M204 S10000
G1  X152.059 
M204 S8000
G1  Y78.127  E0.4656
M204 S10000
G1  X160.225 
M204 S8000
G1  Y90.377  E0.4656
M204 S10000
G1  X168.392 
M204 S8000
G1  Y78.127  E0.4656
; CP EMPTY GRID END
;------------------






; WIPE_TOWER_END
G1  X142.892 Y89.877
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X140.704 Y89.059  
M204 S8000
G3  X141.538 Y86.104   I2.026 J-1.023 E0.1282
G2  X142.392 Y83.571   I-3.390 J-2.554 E0.1033
G2  X142.389 Y72.013   I-283.960 J-5.694 E0.4393
G2  X140.546 Y68.448   I-6.625 J1.166 E0.1549
G3  X140.881 Y66.475   I1.652 J-0.734 E0.0806
G3  X143.999 Y63.213   I19.448 J15.469 E0.1717
G3  X147.197 Y63.871   I1.278 J1.891 E0.1383
G2  X150.214 Y64.877   I3.023 J-4.037 E0.1230
G1  X156.142  E0.2253
G1  X157.392  E0.0475
G2  X163.016 Y64.787   I2.339 J-29.659 E0.2141
G2  X166.351 Y62.929   I-2.882 J-9.098 E0.1461
G3  X168.518 Y63.424   I0.711 J1.877 E0.0895
G3  X171.580 Y66.695   I-16.399 J18.421 E0.1705
G3  X170.746 Y69.650   I-2.026 J1.023 E0.1282
G2  X169.892 Y72.183   I3.390 J2.554 E0.1033
G1  Y76.127  E0.1499
G1 E-0.4000 F1800
M204 S10000
G1  Y78.627  F600
G1 E0.4000 F1800
M204 S8000
G2  X169.947 Y84.249   I34.504 J2.472 E0.2139 F5400
G2  X171.738 Y87.306   I6.530 J-1.771 E0.1363
G3  X171.403 Y89.279   I-1.652 J0.734 E0.0806
G1  X169.892 Y90.877   E0.0836
G3  X167.433 Y92.922   I-4.377 J-2.762 E0.1236
G3  X164.774 Y91.666   I0.009 J-3.462 E0.1154
G2  X162.070 Y90.877   I-2.710 J4.259 E0.1085
G2  X150.024 Y90.881   I-5.928 J318.375 E0.4578
G2  X146.077 Y92.763   I0.501 J6.129 E0.1699
G3  X143.766 Y92.330   I-0.852 J-1.839 E0.0953
G3  X140.704 Y89.059   I16.406 J-18.427 E0.1705
; WIPE_TOWER_END

; WIPE_START
G1 F14176.098
M204 S8000
G1 X140.789 Y89.173 E-.05374
G1 X140.882 Y89.279 E-.05373
G1 X141.374 Y89.8 E-.27253
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.217 J0 P1  F60000
; OBJECT_ID: 423
M204 S10000
G1 X178.537 Y32.802
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F18000
M204 S8000
G1 X166.333 Y32.802 E.40896
G1 X166.333 Y35.302 E.08378
G1 X138.537 Y35.302 E.93145
G1 X138.537 Y26.506 E.29475
G1 X143.333 Y26.506 E.16071
G1 X143.333 Y29.006 E.08378
G1 X155.537 Y29.006 E.40896
G1 X155.537 Y26.506 E.08378
G1 X166.333 Y26.506 E.36177
G1 X166.333 Y29.006 E.08378
G1 X178.537 Y29.006 E.40896
G1 X178.537 Y26.506 E.08378
G1 X183.333 Y26.506 E.16071
G1 X183.333 Y35.302 E.29475
G1 X178.537 Y35.302 E.16071
G1 X178.537 Y32.862 E.08177
M204 S250
G1 X178.145 Y33.194 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X166.725 Y33.194 E.35449
G1 X166.725 Y35.694 E.0776
G1 X138.145 Y35.694 E.88715
G1 X138.145 Y26.114 E.29737
G1 X143.725 Y26.114 E.17321
G1 X143.725 Y28.614 E.0776
G1 X155.145 Y28.614 E.35449
G1 X155.145 Y26.114 E.0776
G1 X166.725 Y26.114 E.35945
G1 X166.725 Y28.614 E.0776
G1 X178.145 Y28.614 E.35449
G1 X178.145 Y26.114 E.0776
G1 X183.725 Y26.114 E.17321
G1 X183.725 Y35.694 E.29737
G1 X178.145 Y35.694 E.17321
G1 X178.145 Y33.254 E.07574
; WIPE_START
M204 S8000
G1 X177.145 Y33.249 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I.298 J-1.18 P1  F60000
G1 X174.729 Y32.638 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42156
G1 F15000
M204 S8000
G1 X178.028 Y29.339 E.14542
G1 X177.493 Y29.339 E.01669
G1 X174.364 Y32.469 E.13794
G1 X173.828 Y32.469 E.01669
G1 X176.957 Y29.339 E.13794
G1 X176.422 Y29.339 E.01669
G1 X173.293 Y32.469 E.13794
G1 X172.757 Y32.469 E.01669
G1 X175.886 Y29.339 E.13794
G1 X175.351 Y29.339 E.01669
G1 X172.222 Y32.469 E.13794
G1 X171.686 Y32.469 E.01669
G1 X174.816 Y29.339 E.13794
G1 X174.28 Y29.339 E.01669
G1 X171.151 Y32.469 E.13794
G1 X170.615 Y32.469 E.01669
G1 X173.745 Y29.339 E.13794
G1 X173.209 Y29.339 E.01669
G1 X170.08 Y32.469 E.13794
G1 X169.544 Y32.469 E.01669
G1 X172.674 Y29.339 E.13794
G1 X172.138 Y29.339 E.01669
G1 X169.009 Y32.469 E.13794
G1 X168.473 Y32.469 E.01669
G1 X171.603 Y29.339 E.13794
G1 X171.067 Y29.339 E.01669
G1 X167.938 Y32.469 E.13794
G1 X167.402 Y32.469 E.01669
G1 X170.532 Y29.339 E.13794
G1 X169.996 Y29.339 E.01669
G1 X166.697 Y32.638 E.14542
; WIPE_START
G1 X167.404 Y31.931 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-1.089 J-.543 P1  F60000
G1 X165.804 Y35.138 Z.8
M73 P34 R15
G1 Z.4
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X165.999 Y34.943 E.00863
G1 X165.999 Y34.407 E.01669
G1 X165.438 Y34.969 E.02475
G1 X164.902 Y34.969 E.01669
G1 X165.999 Y33.872 E.04836
G1 X165.999 Y33.336 E.01669
G1 X164.367 Y34.969 E.07196
G1 X163.831 Y34.969 E.01669
G1 X169.461 Y29.339 E.24814
G1 X168.925 Y29.339 E.01669
G1 X163.296 Y34.969 E.24814
G1 X162.76 Y34.969 E.01669
G1 X168.39 Y29.339 E.24814
G1 X167.854 Y29.339 E.01669
G1 X162.225 Y34.969 E.24814
G1 X161.689 Y34.969 E.01669
G1 X167.319 Y29.339 E.24814
G1 X166.783 Y29.339 E.01669
G1 X161.154 Y34.969 E.24814
G1 X160.619 Y34.969 E.01669
G1 X166.248 Y29.339 E.24814
G1 X165.999 Y29.339 E.00775
G1 X165.999 Y29.052 E.00894
G1 X160.083 Y34.969 E.26079
G1 X159.548 Y34.969 E.01669
G1 X165.999 Y28.517 E.28439
G1 X165.999 Y27.981 E.01669
G1 X159.012 Y34.969 E.308
G1 X158.477 Y34.969 E.01669
G1 X165.999 Y27.446 E.3316
G1 X165.999 Y26.91 E.01669
G1 X157.941 Y34.969 E.3552
G1 X157.406 Y34.969 E.01669
G1 X165.535 Y26.839 E.35834
G1 X165 Y26.839 E.01669
G1 X156.87 Y34.969 E.35834
G1 X156.335 Y34.969 E.01669
G1 X164.464 Y26.839 E.35834
G1 X163.929 Y26.839 E.01669
G1 X155.799 Y34.969 E.35834
G1 X155.264 Y34.969 E.01669
G1 X163.393 Y26.839 E.35834
G1 X162.858 Y26.839 E.01669
G1 X154.728 Y34.969 E.35834
G1 X154.193 Y34.969 E.01669
G1 X162.322 Y26.839 E.35834
G1 X161.787 Y26.839 E.01669
G1 X153.657 Y34.969 E.35834
G1 X153.122 Y34.969 E.01669
G1 X161.251 Y26.839 E.35834
G1 X160.716 Y26.839 E.01669
G1 X152.586 Y34.969 E.35834
G1 X152.051 Y34.969 E.01669
G1 X160.18 Y26.839 E.35834
G1 X159.645 Y26.839 E.01669
G1 X151.515 Y34.969 E.35834
G1 X150.98 Y34.969 E.01669
G1 X159.109 Y26.839 E.35834
G1 X158.574 Y26.839 E.01669
G1 X150.444 Y34.969 E.35834
G1 X149.909 Y34.969 E.01669
G1 X158.038 Y26.839 E.35834
G1 X157.503 Y26.839 E.01669
G1 X155.87 Y28.472 E.07198
G1 X155.87 Y27.937 E.01669
G1 X156.967 Y26.839 E.04837
G1 X156.432 Y26.839 E.01669
G1 X155.87 Y27.401 E.02477
G1 X155.87 Y26.866 E.01669
G1 X156.066 Y26.67 E.00864
; WIPE_START
G1 X155.87 Y26.866 E-.10539
G1 X155.87 Y27.401 E-.20348
G1 X156.002 Y27.269 E-.07113
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-.921 J-.796 P1  F60000
G1 X149.204 Y35.138 Z.8
G1 Z.4
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X155.003 Y29.339 E.25562
G1 X154.467 Y29.339 E.01669
G1 X148.838 Y34.969 E.24814
G1 X148.303 Y34.969 E.01669
G1 X153.932 Y29.339 E.24814
G1 X153.396 Y29.339 E.01669
G1 X147.767 Y34.969 E.24814
G1 X147.232 Y34.969 E.01669
G1 X152.861 Y29.339 E.24814
G1 X152.325 Y29.339 E.01669
G1 X146.696 Y34.969 E.24814
G1 X146.161 Y34.969 E.01669
G1 X151.79 Y29.339 E.24814
G1 X151.254 Y29.339 E.01669
G1 X145.625 Y34.969 E.24814
G1 X145.09 Y34.969 E.01669
G1 X150.719 Y29.339 E.24814
G1 X150.184 Y29.339 E.01669
G1 X144.554 Y34.969 E.24814
G1 X144.019 Y34.969 E.01669
G1 X149.648 Y29.339 E.24814
G1 X149.113 Y29.339 E.01669
G1 X143.483 Y34.969 E.24814
G1 X142.948 Y34.969 E.01669
G1 X148.577 Y29.339 E.24814
G1 X148.042 Y29.339 E.01669
G1 X142.412 Y34.969 E.24814
G1 X141.877 Y34.969 E.01669
G1 X147.506 Y29.339 E.24814
G1 X146.971 Y29.339 E.01669
G1 X141.341 Y34.969 E.24814
G1 X140.806 Y34.969 E.01669
G1 X146.435 Y29.339 E.24814
G1 X145.9 Y29.339 E.01669
G1 X140.27 Y34.969 E.24814
G1 X139.735 Y34.969 E.01669
G1 X145.364 Y29.339 E.24814
G1 X144.829 Y29.339 E.01669
G1 X139.199 Y34.969 E.24814
G1 X138.87 Y34.969 E.01027
G1 X138.87 Y34.763 E.00642
G1 X144.293 Y29.339 E.23906
G1 X143.758 Y29.339 E.01669
G1 X138.87 Y34.227 E.21546
G1 X138.87 Y33.692 E.01669
G1 X143.222 Y29.339 E.19185
G1 X142.999 Y29.339 E.00695
G1 X142.999 Y29.027 E.00974
G1 X138.87 Y33.156 E.18202
G1 X138.87 Y32.621 E.01669
G1 X142.999 Y28.491 E.18202
G1 X142.999 Y27.956 E.01669
G1 X138.87 Y32.085 E.18202
G1 X138.87 Y31.55 E.01669
G1 X142.999 Y27.42 E.18202
G1 X142.999 Y26.885 E.01669
G1 X138.87 Y31.014 E.18202
G1 X138.87 Y30.479 E.01669
G1 X142.509 Y26.839 E.16043
G1 X141.974 Y26.839 E.01669
G1 X138.87 Y29.943 E.13682
G1 X138.87 Y29.408 E.01669
G1 X141.438 Y26.839 E.11322
G1 X140.903 Y26.839 E.01669
G1 X138.87 Y28.872 E.08962
G1 X138.87 Y28.337 E.01669
G1 X140.368 Y26.839 E.06601
G1 X139.832 Y26.839 E.01669
G1 X138.87 Y27.801 E.04241
G1 X138.87 Y27.266 E.01669
G1 X139.466 Y26.67 E.02629
; WIPE_START
G1 X138.87 Y27.266 E-.32046
G1 X138.87 Y27.423 E-.05955
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I.023 J1.217 P1  F60000
G1 X179.092 Y26.67 Z.8
G1 Z.4
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X178.87 Y26.891 E.00977
G1 X178.87 Y27.427 E.01669
G1 X179.457 Y26.839 E.02589
G1 X179.993 Y26.839 E.01669
G1 X178.87 Y27.962 E.0495
G1 X178.87 Y28.498 E.01669
G1 X180.528 Y26.839 E.0731
G1 X181.064 Y26.839 E.01669
G1 X175.434 Y32.469 E.24814
G1 X175.97 Y32.469 E.01669
G1 X181.599 Y26.839 E.24814
G1 X182.135 Y26.839 E.01669
G1 X176.505 Y32.469 E.24814
G1 X177.041 Y32.469 E.01669
G1 X182.67 Y26.839 E.24814
G1 X182.999 Y26.839 E.01026
G1 X182.999 Y27.046 E.00643
G1 X177.576 Y32.469 E.23904
G1 X178.112 Y32.469 E.01669
G1 X182.999 Y27.581 E.21544
G1 X182.999 Y28.117 E.01669
G1 X178.647 Y32.469 E.19183
G1 X178.87 Y32.469 E.00694
G1 X178.87 Y32.782 E.00975
G1 X182.999 Y28.652 E.18202
G1 X182.999 Y29.188 E.01669
G1 X178.87 Y33.317 E.18202
G1 X178.87 Y33.852 E.01669
G1 X182.999 Y29.723 E.18202
G1 X182.999 Y30.259 E.01669
G1 X178.87 Y34.388 E.18202
G1 X178.87 Y34.923 E.01669
G1 X182.999 Y30.794 E.18202
G1 X182.999 Y31.33 E.01669
G1 X179.36 Y34.969 E.16041
G1 X179.896 Y34.969 E.01669
G1 X182.999 Y31.865 E.13681
G1 X182.999 Y32.4 E.01669
M73 C0
G1 X180.431 Y34.969 E.1132
G1 X180.967 Y34.969 E.01669
G1 X182.999 Y32.936 E.0896
G1 X182.999 Y33.471 E.01669
G1 X181.502 Y34.969 E.066
G1 X182.038 Y34.969 E.01669
G1 X182.999 Y34.007 E.04239
G1 X182.999 Y34.542 E.01669
G1 X182.403 Y35.138 E.02627
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X182.999 Y34.542 E-.32024
G1 X182.999 Y34.385 E-.05976
; WIPE_END
G1 E-.02 F1800
; layer num/total_layer_count: 3/12
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
M106 S163.2
; PAUSE_PRINTING
M400 U1

M220 S10
M204 25

; OBJECT_ID: 423
; COOLING_NODE: 0
M204 S10000
G17
G3 Z.8 I.219 J-1.197 P1  F60000
G1 X174.333 Y32.802 Z.8
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F18000
M204 S8000
G1 X174.333 Y35.302 E.08378
G1 X170.537 Y35.302 E.1272
G1 X170.537 Y32.802 E.08378
G1 X159.833 Y32.802 E.3587
G1 X159.833 Y35.302 E.08378
G1 X138.537 Y35.302 E.71363
G1 X138.537 Y26.506 E.29475
G1 X138.833 Y26.506 E.00991
G1 X138.833 Y33.206 E.22452
G1 X142.537 Y33.206 E.12413
G1 X142.537 Y29.006 E.14074
G1 X147.537 Y29.006 E.16755
G1 X147.537 Y26.506 E.08378
G1 X151.333 Y26.506 E.1272
G1 X151.333 Y29.006 E.08378
G1 X161.833 Y29.006 E.35186
G1 X161.833 Y31.906 E.09718
G1 X165.537 Y31.906 E.12413
G1 X165.537 Y29.006 E.09718
G1 X170.537 Y29.006 E.16755
G1 X170.537 Y26.506 E.08378
G1 X174.333 Y26.506 E.1272
G1 X174.333 Y29.006 E.08378
G1 X182.538 Y29.006 E.27495
G1 X182.538 Y26.506 E.08378
G1 X183.333 Y26.506 E.02664
G1 X183.333 Y35.302 E.29475
G1 X182.538 Y35.302 E.02664
G1 X182.538 Y32.802 E.08378
G1 X174.393 Y32.802 E.27294
; COOLING_NODE: 0
M204 S250
G1 X174.725 Y33.194 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6395
M204 S5000
G1 X174.725 Y35.694 E.0776
G1 X170.145 Y35.694 E.14217
G1 X170.145 Y33.194 E.0776
G1 X160.225 Y33.194 E.30792
G1 X160.225 Y35.694 E.0776
G1 X138.145 Y35.694 E.68538
G1 X138.145 Y26.114 E.29737
G1 X139.225 Y26.114 E.03352
G1 X139.225 Y32.814 E.20797
G1 X142.145 Y32.814 E.09064
G1 X142.145 Y28.614 E.13037
G1 X147.145 Y28.614 E.1552
G1 X147.145 Y26.114 E.0776
G1 X151.725 Y26.114 E.14217
G1 X151.725 Y28.614 E.0776
G1 X162.225 Y28.614 E.32593
G1 X162.225 Y31.514 E.09002
G1 X165.145 Y31.514 E.09064
G1 X165.145 Y28.614 E.09002
G1 X170.145 Y28.614 E.1552
G1 X170.145 Y26.114 E.0776
G1 X174.725 Y26.114 E.14217
G1 X174.725 Y28.614 E.0776
G1 X182.145 Y28.614 E.23035
G1 X182.145 Y26.114 E.0776
G1 X183.725 Y26.114 E.04902
G1 X183.725 Y35.694 E.29737
G1 X182.145 Y35.694 E.04902
G1 X182.145 Y33.194 E.0776
G1 X174.785 Y33.194 E.22848
; WIPE_START
G1 F12000
M204 S8000
G1 X174.761 Y34.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I.391 J-1.152 P1  F60000
G1 X172.435 Y33.404 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41516
G1 F15000
M204 S8000
G1 X172.435 Y32.658 E.02285
M204 S10000
G1 X170.74 Y30.904 F60000
; LINE_WIDTH: 0.420289
G1 F15000
M204 S8000
G1 X171.499 Y31.081 E.0242
G1 X171.94 Y31.399 E.01689
G1 X172.258 Y31.84 E.01689
G1 X172.435 Y32.598 E.0242
G1 X172.611 Y31.84 E.0242
G1 X172.929 Y31.399 E.01689
G1 X173.37 Y31.081 E.01689
G1 X173.981 Y30.904 E.01975
G1 X173.37 Y30.727 E.01975
G1 X172.929 Y30.409 E.01689
G1 X172.611 Y29.968 E.01689
G1 X172.435 Y29.358 E.01975
G1 X172.258 Y29.968 E.01975
G1 X171.94 Y30.409 E.01689
G1 X171.499 Y30.727 E.01689
G1 X170.799 Y30.89 E.02234
M204 S10000
G1 X172.003 Y30.904 F60000
; LINE_WIDTH: 0.55382
G1 F14679.978
M204 S8000
G1 X172.254 Y31.085 E.01299
G1 X172.435 Y31.335 E.01299
G1 X172.615 Y31.085 E.01299
G1 X172.866 Y30.904 E.01299
G1 X172.615 Y30.723 E.01299
G1 X172.435 Y30.473 E.01299
G1 X172.254 Y30.723 E.01299
G1 X172.052 Y30.869 E.01047
M204 S10000
G1 X173.981 Y30.904 F60000
; LINE_WIDTH: 0.41531
G1 F15000
M204 S8000
G1 X181.375 Y30.904 E.22666
; WIPE_START
G1 X180.375 Y30.904 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I.365 J-1.161 P1  F60000
G1 X172.435 Y28.404 Z1
G1 Z.6
G1 E.4 F1800
; LINE_WIDTH: 0.4158
G1 F15000
M204 S8000
G1 X172.435 Y29.298 E.02744
M204 S10000
G1 X167.435 Y30.904 F60000
; LINE_WIDTH: 0.41518
G1 F15000
M204 S8000
G1 X170.68 Y30.904 E.09946
M204 S10000
G1 X167.06 Y31.201 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X167.097 Y31.279 E.00268
G1 X170.74 Y31.279 E.11307
G1 X171.33 Y31.418 E.01882
G1 X171.673 Y31.665 E.01312
G1 X171.921 Y32.008 E.01312
G1 X172.06 Y32.598 E.01882
G1 X172.06 Y33.779 E.03663
G1 X172.809 Y33.779 E.02326
G1 X172.809 Y32.598 E.03663
G1 X172.949 Y32.008 E.01882
G1 X173.196 Y31.665 E.01312
G1 X173.539 Y31.418 E.01312
G1 X174.129 Y31.279 E.01882
G1 X181.809 Y31.279 E.23839
G1 X181.809 Y30.529 E.02326
G1 X174.129 Y30.529 E.23839
G1 X173.539 Y30.39 E.01882
G1 X173.196 Y30.143 E.01312
G1 X172.949 Y29.8 E.01312
G1 X172.809 Y29.21 E.01882
G1 X172.809 Y28.029 E.03663
G1 X172.06 Y28.029 E.02326
G1 X172.06 Y29.21 E.03663
G1 X171.921 Y29.8 E.01882
G1 X171.673 Y30.143 E.01312
G1 X171.33 Y30.39 E.01312
G1 X170.74 Y30.529 E.01882
G1 X167.06 Y30.529 E.11424
G1 X167.06 Y31.141 E.01898
M204 S10000
G1 X166.683 Y31.363 F60000
G1 F15000
M204 S8000
G1 X166.755 Y31.404 E.00256
G1 X166.824 Y31.656 E.0081
G1 X170.74 Y31.656 E.12157
G1 X171.162 Y31.755 E.01345
G1 X171.407 Y31.932 E.00937
G1 X171.583 Y32.177 E.00937
G1 X171.683 Y32.598 E.01345
G1 X171.683 Y34.156 E.04834
G1 X173.186 Y34.156 E.04667
G1 X173.186 Y32.598 E.04834
G1 X173.286 Y32.177 E.01345
G1 X173.462 Y31.932 E.00937
G1 X173.707 Y31.755 E.00937
G1 X174.129 Y31.656 E.01345
G1 X181.981 Y31.656 E.24371
G1 X182.012 Y31.598 E.00205
G1 X182.186 Y31.548 E.00562
G1 X182.186 Y30.26 E.03996
G1 X182.012 Y30.21 E.00562
G1 X181.981 Y30.152 E.00205
G1 X174.129 Y30.152 E.24371
G1 X173.707 Y30.053 E.01345
G1 X173.462 Y29.876 E.00937
G1 X173.286 Y29.631 E.00937
G1 X173.186 Y29.21 E.01345
G1 X173.186 Y27.652 E.04834
G1 X171.683 Y27.652 E.04667
G1 X171.683 Y29.21 E.04834
G1 X171.583 Y29.631 E.01345
G1 X171.407 Y29.876 E.00937
G1 X171.162 Y30.053 E.00937
G1 X170.74 Y30.152 E.01345
G1 X166.683 Y30.152 E.12594
G1 X166.683 Y31.303 E.03572
M204 S10000
G1 X166.306 Y31.525 F60000
G1 F15000
M204 S8000
G1 X166.43 Y31.596 E.00445
G1 X166.509 Y31.884 E.00928
G1 X166.509 Y32.033 E.0046
G1 X170.74 Y32.033 E.13133
G1 X170.993 Y32.092 E.00807
G3 X171.306 Y32.598 I-.299 J.534 E.01928
G1 X171.306 Y34.533 E.06004
G1 X173.563 Y34.533 E.07008
G1 X173.563 Y32.598 E.06004
G1 X173.623 Y32.345 E.00807
G3 X174.129 Y32.033 I.534 J.299 E.01928
G1 X182.15 Y32.033 E.24897
G1 X182.214 Y31.917 E.00411
G1 X182.563 Y31.829 E.01119
G1 X182.563 Y29.979 E.05745
G1 X182.214 Y29.891 E.01119
G1 X182.15 Y29.775 E.00411
G1 X174.129 Y29.775 E.24897
G1 X173.876 Y29.715 E.00807
G3 X173.563 Y29.21 I.299 J-.534 E.01928
G1 X173.563 Y27.275 E.06004
G1 X171.306 Y27.275 E.07008
G1 X171.306 Y29.21 E.06004
G1 X171.246 Y29.462 E.00807
G3 X170.74 Y29.775 I-.534 J-.299 E.01928
G1 X166.306 Y29.775 E.13764
G1 X166.306 Y31.465 E.05246
M204 S10000
G1 X165.929 Y31.696 F60000
G1 F15000
M204 S8000
G1 X166.106 Y31.788 E.0062
G1 X166.132 Y32.41 E.01931
G1 X170.74 Y32.41 E.14303
G1 X170.874 Y32.465 E.00448
G1 X170.929 Y32.598 E.00448
G1 X170.929 Y34.91 E.07175
G1 X173.941 Y34.91 E.09348
G1 X173.941 Y32.598 E.07175
G1 X173.996 Y32.465 E.00448
G1 X174.129 Y32.41 E.00448
G1 X182.327 Y32.41 E.25448
G1 X182.415 Y32.236 E.00606
G1 X182.941 Y32.206 E.01633
G1 X182.941 Y29.602 E.08086
G1 X182.415 Y29.572 E.01633
G1 X182.313 Y29.398 E.00628
G1 X174.129 Y29.398 E.25401
G1 X173.996 Y29.343 E.00448
G1 X173.941 Y29.21 E.00448
G1 X173.941 Y26.898 E.07175
G1 X170.929 Y26.898 E.09348
G1 X170.929 Y29.21 E.07175
G1 X170.874 Y29.343 E.00448
G1 X170.74 Y29.398 E.00448
G1 X165.929 Y29.398 E.14935
G1 X165.929 Y31.636 E.06946
M204 S10000
G1 X165.74 Y32.354 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F15000
M204 S8000
M73 P34 R14
G1 X161.629 Y32.354 E.16542
M204 S10000
G1 X161.669 Y29.938 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42283
G1 F15000
M204 S8000
G1 X161.071 Y29.339 E.02647
G1 X160.533 Y29.339 E.0168
G1 X161.499 Y30.305 E.04273
G1 X161.499 Y30.843 E.0168
G1 X159.996 Y29.339 E.06649
G1 X159.459 Y29.339 E.0168
G1 X161.499 Y31.38 E.09026
G1 X161.499 Y31.755 E.01173
G1 X161.337 Y31.755 E.00508
G1 X158.921 Y29.339 E.10684
G1 X158.384 Y29.339 E.0168
G1 X161.296 Y32.251 E.12878
G1 X161.296 Y32.469 E.00681
G1 X160.976 Y32.469 E.00999
G1 X157.847 Y29.339 E.13841
G1 X157.31 Y29.339 E.0168
G1 X160.439 Y32.469 E.13841
G1 X159.902 Y32.469 E.0168
M73 P35 R14
G1 X156.772 Y29.339 E.13841
G1 X156.235 Y29.339 E.0168
G1 X159.499 Y32.604 E.14438
G1 X159.499 Y33.141 E.0168
G1 X155.698 Y29.339 E.16814
G1 X155.16 Y29.339 E.0168
G1 X159.499 Y33.678 E.1919
G1 X159.499 Y34.215 E.0168
G1 X154.623 Y29.339 E.21566
G1 X154.086 Y29.339 E.0168
G1 X159.499 Y34.753 E.23943
G1 X159.499 Y34.969 E.00676
G1 X159.178 Y34.969 E.01004
G1 X153.549 Y29.339 E.24898
G1 X153.011 Y29.339 E.0168
G1 X158.641 Y34.969 E.24898
G1 X158.104 Y34.969 E.0168
G1 X152.474 Y29.339 E.24898
G1 X151.937 Y29.339 E.0168
G1 X157.566 Y34.969 E.24898
G1 X157.029 Y34.969 E.0168
G1 X151.4 Y29.339 E.24898
G1 X150.999 Y29.339 E.01251
G1 X150.999 Y28.939 E.01251
G1 X148.9 Y26.839 E.09287
G1 X149.437 Y26.839 E.0168
G1 X150.999 Y28.402 E.06911
G1 X150.999 Y27.864 E.0168
G1 X149.974 Y26.839 E.04535
G1 X150.511 Y26.839 E.0168
G1 X151.169 Y27.497 E.02909
; WIPE_START
G1 X150.511 Y26.839 E-.35345
G1 X150.442 Y26.839 E-.02655
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I-.974 J.73 P1  F60000
G1 X156.662 Y35.138 Z1
G1 Z.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X148.362 Y26.839 E.36706
G1 X147.87 Y26.839 E.0154
G1 X147.87 Y26.884 E.0014
G1 X155.955 Y34.969 E.35757
G1 X155.417 Y34.969 E.0168
G1 X147.87 Y27.421 E.33381
G1 X147.87 Y27.959 E.0168
G1 X154.88 Y34.969 E.31004
G1 X154.343 Y34.969 E.0168
G1 X147.87 Y28.496 E.28628
G1 X147.87 Y29.033 E.0168
G1 X153.805 Y34.969 E.26252
G1 X153.268 Y34.969 E.0168
G1 X147.639 Y29.339 E.24898
G1 X147.101 Y29.339 E.0168
G1 X152.731 Y34.969 E.24898
G1 X152.194 Y34.969 E.0168
G1 X146.564 Y29.339 E.24898
G1 X146.027 Y29.339 E.0168
G1 X151.656 Y34.969 E.24898
G1 X151.119 Y34.969 E.0168
G1 X145.49 Y29.339 E.24898
G1 X144.952 Y29.339 E.0168
G1 X150.582 Y34.969 E.24898
G1 X150.045 Y34.969 E.0168
G1 X144.415 Y29.339 E.24898
G1 X143.878 Y29.339 E.0168
G1 X149.507 Y34.969 E.24898
G1 X148.97 Y34.969 E.0168
G1 X143.34 Y29.339 E.24898
G1 X142.87 Y29.339 E.01472
G1 X142.87 Y29.406 E.00208
G1 X148.433 Y34.969 E.24603
G1 X147.895 Y34.969 E.0168
G1 X142.87 Y29.943 E.22227
G1 X142.87 Y30.48 E.0168
G1 X147.358 Y34.969 E.19851
G1 X146.821 Y34.969 E.0168
G1 X142.87 Y31.018 E.17475
G1 X142.87 Y31.555 E.0168
G1 X146.284 Y34.969 E.15098
G1 X145.746 Y34.969 E.0168
G1 X142.87 Y32.092 E.12722
G1 X142.87 Y32.629 E.0168
G1 X145.209 Y34.969 E.10346
G1 X144.672 Y34.969 E.0168
G1 X142.87 Y33.167 E.0797
G1 X142.87 Y33.539 E.01165
G1 X142.705 Y33.539 E.00516
G1 X144.135 Y34.969 E.06323
G1 X143.597 Y34.969 E.0168
G1 X142.168 Y33.539 E.06323
G1 X141.63 Y33.539 E.0168
G1 X143.06 Y34.969 E.06323
G1 X142.523 Y34.969 E.0168
G1 X141.093 Y33.539 E.06323
G1 X140.556 Y33.539 E.0168
G1 X141.985 Y34.969 E.06323
G1 X141.448 Y34.969 E.0168
G1 X140.019 Y33.539 E.06323
G1 X139.481 Y33.539 E.0168
G1 X140.911 Y34.969 E.06323
G1 X140.374 Y34.969 E.0168
G1 X138.944 Y33.539 E.06323
G1 X138.87 Y33.539 E.00232
G1 X138.87 Y34.002 E.01448
G1 X139.836 Y34.969 E.04275
G1 X139.299 Y34.969 E.0168
G1 X138.7 Y34.37 E.02649
; WIPE_START
G1 X139.299 Y34.969 E-.32186
G1 X139.452 Y34.969 E-.05814
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I-.004 J1.217 P1  F60000
G1 X182.935 Y35.098 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43093
G1 F15000
M204 S8000
G1 X182.935 Y32.598 E.07985
M204 S10000
G1 X182.935 Y29.209 F60000
G1 F15000
M204 S8000
G1 X182.935 Y26.71 E.07985
; WIPE_START
G1 X182.935 Y27.71 E-.38
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
    

    

    
        M9711 M0 E0 U252 V34 Z1 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

M204 S10000
G1 X142.892 Y89.877
G1 Z.6
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X140.704 Y89.059  
M204 S8000
G3  X141.538 Y86.104   I2.026 J-1.023 E0.1282 F5400
G2  X142.392 Y83.571   I-3.390 J-2.554 E0.1033
G2  X142.389 Y72.013   I-283.960 J-5.694 E0.4393
G2  X140.546 Y68.448   I-6.625 J1.166 E0.1549
G3  X140.881 Y66.475   I1.652 J-0.734 E0.0806
G3  X143.999 Y63.213   I19.448 J15.469 E0.1717
G3  X147.197 Y63.871   I1.278 J1.891 E0.1383
G2  X150.214 Y64.877   I3.023 J-4.037 E0.1230
G1  X156.142  E0.2253
G1  X157.392  E0.0475
G2  X163.016 Y64.787   I2.339 J-29.659 E0.2141
G2  X166.351 Y62.929   I-2.882 J-9.098 E0.1461
G3  X168.518 Y63.424   I0.711 J1.877 E0.0895
G3  X171.580 Y66.695   I-16.399 J18.421 E0.1705
G3  X171.805 Y67.153   I-2.082 J1.304 E0.0194
G1 E-0.4000 F1800
M204 S10000
G1  X171.000 Y69.349   F600
G1 E0.4000 F1800
M204 S8000
G2  X169.892 Y72.183   I3.079 J2.837 E0.1183 F5400
G2  X169.895 Y83.741   I283.960 J5.694 E0.4393
G2  X171.738 Y87.306   I6.625 J-1.166 E0.1549
G3  X171.403 Y89.279   I-1.652 J0.734 E0.0806
G1  X169.892 Y90.877   E0.0836
G3  X167.433 Y92.922   I-4.377 J-2.762 E0.1236
G3  X164.774 Y91.666   I0.009 J-3.462 E0.1154
G2  X162.070 Y90.877   I-2.710 J4.259 E0.1085
G2  X150.024 Y90.881   I-5.928 J318.375 E0.4578
G2  X146.077 Y92.763   I0.501 J6.129 E0.1699
G3  X143.766 Y92.330   I-0.852 J-1.839 E0.0953
G3  X140.704 Y89.059   I16.406 J-18.427 E0.1705
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
G3 Z1 I1.217 J0 P1  F60000
G1 X143.142 Y65.627
G1 Z.6
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF0 NF1 ON2 NN0
M204 S8000
G1  X169.142 Y65.627  E2.0691 F7836
G1  Y67.127  E0.1194
G1  X143.142  E2.0691
; NOZZLE_CHANGE_END OF0 NF1 ON2 NN0
M400
M104 T0 S25 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S8000
G1 X144.142 Y67.127 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S10000
G17
G3 Z1 I1.217 J0 P1  F5400
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

G1 Z3.6 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X171.392 Y68.3773



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
M73 P36 R14
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.6 F3000

M204 S8000


M621 S1A

; ---------- ACTUAL TOOL CHANGE WITHOUT AMS -------------------

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag


M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I1 H-1 W1 ;enable ams air printing detect
M620 O4
M1002 gcode_claim_action : 0
M106 S61.2
M106 P2 S102
G1 E-.4 F1800
G1 X173.895 Y68.377 F600
M204 S1000
G1 Z.6

; filament start gcode
M109 S145;
G17
G3 Z1 I0 J-1.217 P1
G1 X169.392 Y68.377 Z1
G1 Z.6
G1 E.6 F1800

G4 S0

M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------

M220 S100
M204 8000
G1  Y90.377   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S25
G1  Y78.127  E0.4656
G1  X169.392  E1.0072
G1  Y90.377  E0.4656
G1  X142.892  E1.0072
M204 S1000
G1  X143.892 Y78.127  
;--------------------
; CP EMPTY GRID START
; layer #4
M204 S25
M73 P39 R14
G1  Y90.377  E0.4656
M204 S1000
G1  X152.059 
M204 S25
G1  Y78.127  E0.4656
M204 S1000
G1  X160.225 
M204 S25
G1  Y90.377  E0.4656
M204 S1000
G1  X168.392 
M204 S25
M73 P39 R13
G1  Y78.127  E0.4656
; CP EMPTY GRID END
;------------------






; WIPE_TOWER_END

; WIPE_START
M204 S25
G1 X168.392 Y79.127 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I1.217 J0 P1  F600
; OBJECT_ID: 423
; COOLING_NODE: 0
M204 S1000
G1 X140.037 Y32.002
G1 Z.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
G1 X140.037 Y26.506 E.18417
G1 X146.303 Y26.506 E.20997
G1 X146.303 Y27.802 E.04343
G1 X141.303 Y27.802 E.16755
M73 P40 R13
G1 X141.303 Y32.002 E.14074
G1 X140.097 Y32.002 E.04041
; COOLING_NODE: 0
G1 X139.645 Y32.394
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X139.645 Y26.114 E.19494
G1 X146.695 Y26.114 E.21884
G1 X146.695 Y28.194 E.06457
G1 X141.695 Y28.194 E.1552
G1 X141.695 Y32.394 E.13037
G1 X139.705 Y32.394 E.06177
; COOLING_NODE: 0
; WIPE_START
G1 X139.695 Y31.394 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I.185 J1.203 P1  F600
G1 X163.037 Y27.802 Z1
G1 Z.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X152.537 Y27.802 E.35186
G1 X152.537 Y26.506 E.04343
G1 X169.303 Y26.506 E.56183
G1 X169.303 Y27.802 E.04343
G1 X164.303 Y27.802 E.16755
G1 X164.303 Y30.702 E.09718
G1 X163.037 Y30.702 E.04242
G1 X163.037 Y27.862 E.09517
; COOLING_NODE: 0
G1 X162.645 Y28.194
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X152.145 Y28.194 E.32593
G1 X152.145 Y26.114 E.06457
G1 X169.695 Y26.114 E.54477
G1 X169.695 Y28.194 E.06457
G1 X164.695 Y28.194 E.1552
G1 X164.695 Y31.094 E.09002
M73 P41 R13
G1 X162.645 Y31.094 E.06363
G1 X162.645 Y28.254 E.08816
; COOLING_NODE: 0
; WIPE_START
G1 X161.645 Y28.248 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I-1.21 J-.128 P1  F600
G1 X161.037 Y34.006 Z1
G1 Z.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X169.303 Y34.006 E.27699
G1 X169.303 Y35.302 E.04343
G1 X161.037 Y35.302 E.27699
G1 X161.037 Y34.066 E.04141
; COOLING_NODE: 0
G1 X160.645 Y33.614
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X169.695 Y33.614 E.28092
G1 X169.695 Y35.694 E.06457
G1 X160.645 Y35.694 E.28092
G1 X160.645 Y33.674 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X161.645 Y33.667 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I-.03 J1.217 P1  F600
G1 X175.537 Y34.006 Z1
G1 Z.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X181.303 Y34.006 E.19324
G1 X181.303 Y35.302 E.04343
G1 X175.537 Y35.302 E.19324
G1 X175.537 Y34.066 E.04141
; COOLING_NODE: 0
G1 X175.145 Y33.614
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X181.695 Y33.614 E.20334
G1 X181.695 Y35.694 E.06457
G1 X175.145 Y35.694 E.20334
G1 X175.145 Y33.674 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X176.145 Y33.665 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
M73 P42 R13
G3 Z1 I1.21 J-.126 P1  F600
G1 X175.537 Y27.802 Z1
G1 Z.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X175.537 Y26.506 E.04343
G1 X181.303 Y26.506 E.19324
G1 X181.303 Y27.802 E.04343
G1 X175.597 Y27.802 E.19123
; COOLING_NODE: 0
G1 X175.145 Y28.194
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X175.145 Y26.114 E.06457
G1 X181.695 Y26.114 E.20334
G1 X181.695 Y28.194 E.06457
G1 X175.205 Y28.194 E.20148
M204 S1000
G1 X175.962 Y27.376
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.487325
M204 S25
G1 X180.878 Y27.376 E.17981
G1 X180.878 Y26.932 E.01626
G1 X175.962 Y26.932 E.17981
G1 X175.962 Y27.316 E.01406
; WIPE_START
G1 X175.962 Y26.932 E-.14608
G1 X176.578 Y26.932 E-.23392
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I-1.213 J-.1 P1  F600
G1 X175.962 Y34.432 Z1
G1 Z.6
G1 E.6 F1800
; LINE_WIDTH: 0.48732
G1 F600
M204 S25
G1 X175.962 Y34.876 E.01626
G1 X180.878 Y34.876 E.17981
G1 X180.878 Y34.432 E.01626
G1 X176.022 Y34.432 E.17762
; WIPE_START
G1 X177.022 Y34.432 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I.356 J-1.164 P1  F600
G1 X163.455 Y30.284 Z1
G1 Z.6
G1 E.6 F1800
; LINE_WIDTH: 0.47232
G1 F600
M204 S25
G1 X163.884 Y30.284 E.01518
G1 X163.884 Y27.598 E.09492
; LINE_WIDTH: 0.492109
G1 X163.884 Y27.542 E.0021
; LINE_WIDTH: 0.531685
G1 X163.884 Y27.485 E.00228
; LINE_WIDTH: 0.571262
G1 X163.884 Y27.428 E.00247
; LINE_WIDTH: 0.573764
G1 X163.956 Y27.411 E.00322
; LINE_WIDTH: 0.53919
G1 X164.027 Y27.393 E.00301
; LINE_WIDTH: 0.487452
G1 X164.099 Y27.376 E.00269
G1 X168.877 Y27.376 E.17484
G1 X168.877 Y26.932 E.01626
G1 X164.099 Y26.932 E.17484
; LINE_WIDTH: 0.504617
G1 X163.956 Y26.949 E.00548
; LINE_WIDTH: 0.53919
G1 X163.813 Y26.966 E.00589
; LINE_WIDTH: 0.573764
G1 X163.67 Y26.984 E.0063
G1 X163.527 Y26.966 E.0063
; LINE_WIDTH: 0.53919
G1 X163.383 Y26.949 E.00589
; LINE_WIDTH: 0.487448
G1 X163.24 Y26.932 E.00528
G1 X152.962 Y26.932 E.3761
G1 X152.962 Y27.376 E.01626
G1 X163.24 Y27.376 E.3761
; LINE_WIDTH: 0.504617
G1 X163.312 Y27.393 E.0028
; LINE_WIDTH: 0.53919
M73 P43 R13
G1 X163.383 Y27.411 E.00301
; LINE_WIDTH: 0.573764
G1 X163.455 Y27.428 E.00322
; LINE_WIDTH: 0.571262
G1 X163.455 Y27.485 E.00247
; LINE_WIDTH: 0.531685
G1 X163.455 Y27.542 E.00228
; LINE_WIDTH: 0.472739
G1 X163.455 Y30.224 E.0949
; WIPE_START
G1 X163.455 Y29.224 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I-1.137 J-.435 P1  F600
G1 X161.462 Y34.432 Z1
G1 Z.6
G1 E.6 F1800
; LINE_WIDTH: 0.48732
G1 F600
M204 S25
G1 X161.462 Y34.876 E.01626
G1 X168.877 Y34.876 E.27124
G1 X168.877 Y34.432 E.01626
G1 X161.522 Y34.432 E.26904
; WIPE_START
G1 X162.522 Y34.432 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I.475 J-1.12 P1  F600
G1 X145.877 Y27.376 Z1
G1 Z.6
G1 E.6 F1800
; LINE_WIDTH: 0.48733
G1 F600
M204 S25
G1 X145.877 Y26.932 E.01626
G1 X141.099 Y26.932 E.17479
; LINE_WIDTH: 0.504238
G1 X140.798 Y26.949 E.01146
; LINE_WIDTH: 0.521517
G1 X140.496 Y26.966 E.01189
G1 X140.455 Y27.598 E.02498
; LINE_WIDTH: 0.47233
G1 X140.455 Y31.584 E.14087
G1 X140.884 Y31.584 E.01518
G1 X140.884 Y27.598 E.14087
; LINE_WIDTH: 0.492988
G1 X140.905 Y27.504 E.00357
; LINE_WIDTH: 0.525792
G1 X140.926 Y27.41 E.00383
G1 X141.099 Y27.376 E.00702
; LINE_WIDTH: 0.48733
M73 P43 R12
G1 X145.817 Y27.376 E.17259
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 4/12
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
M106 S76.5
; OBJECT_ID: 423
; COOLING_NODE: 0
; WIPE_START
G1 F600
G1 X144.817 Y27.376 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1 I-.696 J-.999 P1  F600
G1 X140.037 Y30.706 Z1
G1 Z.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
G1 X141.303 Y30.706 E.04242
G1 X141.303 Y32.002 E.04343
G1 X140.037 Y32.002 E.04242
G1 X140.037 Y30.766 E.04141
; COOLING_NODE: 0
G1 X139.645 Y30.314
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X141.695 Y30.314 E.06363
G1 X141.695 Y32.394 E.06457
G1 X139.645 Y32.394 E.06363
G1 X139.645 Y30.374 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X140.644 Y30.345 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I-.215 J1.198 P1  F600
G1 X161.037 Y34.006 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
M73 P44 R12
G1 X162.303 Y34.006 E.04242
G1 X162.303 Y35.302 E.04343
G1 X161.037 Y35.302 E.04242
G1 X161.037 Y34.066 E.04141
; COOLING_NODE: 0
G1 X160.645 Y33.614
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X162.695 Y33.614 E.06363
G1 X162.695 Y35.694 E.06457
G1 X160.645 Y35.694 E.06363
G1 X160.645 Y33.674 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X161.644 Y33.645 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I1.1 J.521 P1  F600
G1 X163.037 Y30.702 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X163.037 Y29.406 E.04343
G1 X164.303 Y29.406 E.04242
G1 X164.303 Y30.702 E.04343
G1 X163.097 Y30.702 E.04041
; COOLING_NODE: 0
G1 X162.645 Y31.094
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X162.645 Y29.014 E.06457
G1 X164.695 Y29.014 E.06363
G1 X164.695 Y31.094 E.06457
G1 X162.705 Y31.094 E.06177
; COOLING_NODE: 0
; WIPE_START
G1 X162.676 Y30.094 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I.159 J1.206 P1  F600
G1 X180.038 Y27.802 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X180.038 Y26.506 E.04343
G1 X181.303 Y26.506 E.04242
G1 X181.303 Y27.802 E.04343
G1 X180.098 Y27.802 E.04041
; COOLING_NODE: 0
G1 X179.645 Y28.194
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X179.645 Y26.114 E.06457
G1 X181.695 Y26.114 E.06363
G1 X181.695 Y28.194 E.06457
G1 X179.705 Y28.194 E.06177
; COOLING_NODE: 0
; WIPE_START
G1 X179.677 Y27.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I-1.215 J.064 P1  F600
G1 X180.038 Y34.006 Z1.2
G1 Z.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X181.303 Y34.006 E.04242
G1 X181.303 Y35.302 E.04343
G1 X180.038 Y35.302 E.04242
G1 X180.038 Y34.066 E.04141
; COOLING_NODE: 0
G1 X179.645 Y33.614
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X181.695 Y33.614 E.06363
G1 X181.695 Y35.694 E.06457
G1 X179.645 Y35.694 E.06363
G1 X179.645 Y33.674 E.0627
M204 S1000
G1 X180.456 Y34.424
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47232
M204 S25
G1 X180.456 Y34.884 E.01624
G1 X180.885 Y34.884 E.01518
G1 X180.885 Y34.424 E.01624
G1 X180.516 Y34.424 E.01306
; WIPE_START
G1 X180.885 Y34.424 E-.14037
G1 X180.885 Y34.884 E-.17458
G1 X180.714 Y34.884 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I1.216 J-.042 P1  F600
G1 X180.456 Y27.384 Z1.2
G1 Z.8
G1 E.6 F1800
M73 P45 R12
G1 F600
M204 S25
G1 X180.885 Y27.384 E.01518
M632 S0 N R W
M400
M104 T0 S210 N0 ;Multi extruder pre heating
M633
G1 X180.885 Y26.924 E.01624
G1 X180.456 Y26.924 E.01518
G1 X180.456 Y27.324 E.01412
; WIPE_START
G1 X180.456 Y26.924 E-.15178
G1 X180.885 Y26.924 E-.16317
G1 X180.885 Y27.095 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I-.219 J-1.197 P1  F600
G1 X163.455 Y30.284 Z1.2
G1 Z.8
G1 E.6 F1800
; LINE_WIDTH: 0.47233
G1 F600
M204 S25
G1 X163.884 Y30.284 E.01518
G1 X163.884 Y29.824 E.01624
G1 X163.455 Y29.824 E.01518
G1 X163.455 Y30.224 E.01412
; WIPE_START
G1 X163.455 Y29.824 E-.15178
G1 X163.884 Y29.824 E-.16318
G1 X163.884 Y29.995 E-.06504
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I-1.067 J-.585 P1  F600
G1 X161.455 Y34.424 Z1.2
G1 Z.8
G1 E.6 F1800
G1 F600
M204 S25
G1 X161.455 Y34.884 E.01624
G1 X161.884 Y34.884 E.01518
G1 X161.884 Y34.424 E.01624
G1 X161.515 Y34.424 E.01306
; WIPE_START
G1 X161.884 Y34.424 E-.14038
G1 X161.884 Y34.884 E-.17458
G1 X161.713 Y34.884 E-.06504
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I.216 J-1.198 P1  F600
G1 X140.884 Y31.124 Z1.2
G1 Z.8
G1 E.6 F1800
G1 F600
M204 S25
G1 X140.455 Y31.124 E.01518
G1 X140.455 Y31.584 E.01624
G1 X140.884 Y31.584 E.01518
G1 X140.884 Y31.184 E.01412
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
G1 X140.884 Y31.584 E-.15178
G1 X140.455 Y31.584 E-.16318
G1 X140.455 Y31.412 E-.06504
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.2 I1.217 J0 P1  F600
G1 X143.142 Y65.627
G1 Z.8
G1 E.6 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF1 NF0 ON0 NN2
M204 S25
G1  X169.142 Y65.627  E2.0691 F7836
; NOZZLE_CHANGE_END OF1 NF0 ON0 NN2
M400
M104 T1 S67 N0 ;Multi extruder pre cooling

; WIPE_START
M73 P46 R12
G1 F5400
M204 S25
G1 X168.142 Y65.627 E-1.9
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


M1015.4 S1 K0 ;disable E air printing detect


M620 O5
M620 S0A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z3.8 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X140.892 Y75.8773



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

;VM109 S220

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F10.4167 A0.4 R2


M400

G387 Y320 J1 F10000
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.8 F3000

M204 S25


M621 S0A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y320 J1 F10000
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z3.8 F3000

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I0 H-1 W1 ;enable ams air printing detect
M620 O5
M1002 gcode_claim_action : 0
M106 S178.5
M106 P2 S191
G1 X142.073 Y94.956 F60000
M204 S10000
G1 Z.8
G17
G3 Z1.2 I0 J-1.217 P1
G1 X138.39 Y94.956 Z1.2
G1 X138.39 Y75.877

; filament start gcode
G1 X142.892 Y75.877
G1 Z.8
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X145.892 Y75.877  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X141.392  F600
G1  X142.892  F240
G1  X143.392  F600
G1  Y76.377 
G1  X142.392 
G1  Y75.377 
G1  X143.892 
G1  Y76.877 
G1  X141.892 
G1  Y74.877 
G1  X145.892 Y75.877   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X169.392  E0.8931 F1782
G1  Y75.127  E0.0285
G1  X142.892  E1.0072 F2025
G1  Y74.377  E0.0285
M73 P47 R12
G1  X169.392  E1.0072 F2473
G1  Y73.627  E0.0285
G1  X142.892  E1.0072 F4725
G1  Y72.877  E0.0285
G1  X169.392  E1.0072 F4775
G1  Y72.127  E0.0285
G1  X142.892  E1.0072
G1  Y71.377  E0.0285
G1  X169.392  E1.0072
G1  Y70.627  E0.0285
G1  X142.892  E1.0072
G1  Y69.877  E0.0285
G1  X169.392  E1.0072
G1  Y69.127  E0.0285
G1  X142.892  E1.0072
G1  Y68.377  E0.0285
G1  X169.392  E1.0072
G1  Y67.627  E0.0285
G1  X142.892  E1.0072
G1  Y66.877  E0.0285
G1  X169.392  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y90.377   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S8000
G1  X142.892  E1.0072
G1  Y76.627  E0.5226
G1  X169.392  E1.0072
G1  Y90.377  E0.5226
M204 S10000
G1  X143.892 Y76.627  
;--------------------
; CP EMPTY GRID START
; layer #5
M204 S8000
G1  Y90.377  E0.5226
M204 S10000
G1  X152.059 
M204 S8000
G1  Y76.627  E0.5226
M204 S10000
G1  X160.225 
M204 S8000
G1  Y90.377  E0.5226
M204 S10000
G1  X168.392 
M204 S8000
G1  Y76.627  E0.5226
; CP EMPTY GRID END
;------------------






; WIPE_TOWER_END
G1  X169.392 Y89.877
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X169.892 Y90.877  
M204 S8000
G3  X167.433 Y92.922   I-4.377 J-2.762 E0.1236
G3  X164.774 Y91.666   I0.009 J-3.462 E0.1154
M106 S255
G2  X162.070 Y90.877   I-2.710 J4.259 E0.1085
G2  X150.024 Y90.881   I-5.928 J318.375 E0.4578
G2  X146.077 Y92.763   I0.501 J6.129 E0.1699
G3  X143.766 Y92.330   I-0.852 J-1.839 E0.0953
G3  X140.704 Y89.059   I16.406 J-18.427 E0.1705
G3  X141.538 Y86.104   I2.026 J-1.023 E0.1282
G2  X142.392 Y83.571   I-3.390 J-2.554 E0.1033
G1  Y77.127  E0.2449
G1 E-0.4000 F1800
M204 S10000
G1  Y74.627  F600
G1 E0.4000 F1800
M204 S8000
G2  X141.638 Y69.787   I-8.063 J-1.222 E0.1891 F5400
G3  X140.462 Y67.204   I1.718 J-2.341 E0.1127
G3  X140.881 Y66.475   I1.923 J0.621 E0.0322
G3  X143.999 Y63.213   I19.448 J15.469 E0.1717
G3  X147.197 Y63.871   I1.278 J1.891 E0.1383
G2  X150.214 Y64.877   I3.023 J-4.037 E0.1230
G1  X156.142  E0.2253
G1  X157.392  E0.0475
G2  X163.016 Y64.787   I2.339 J-29.659 E0.2141
G2  X166.351 Y62.929   I-2.882 J-9.098 E0.1461
G3  X168.518 Y63.424   I0.711 J1.877 E0.0895
G3  X171.580 Y66.695   I-16.399 J18.421 E0.1705
G3  X170.746 Y69.650   I-2.026 J1.023 E0.1282
G2  X169.892 Y72.183   I3.390 J2.554 E0.1033
G2  X169.895 Y83.741   I283.960 J5.694 E0.4393
G2  X171.738 Y87.306   I6.625 J-1.166 E0.1549
G3  X171.403 Y89.279   I-1.652 J0.734 E0.0806
G1  X169.892 Y90.877   E0.0836
; WIPE_TOWER_END

; WIPE_START
M204 S8000
G1 X169.892 Y90.877 E-.00002
G1 X169.892 Y90.877 E0
G1 X170.579 Y90.151 E-.37998
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I1.217 J0 P1  F60000
; OBJECT_ID: 423
; COOLING_NODE: 0
M204 S10000
G1 X161.833 Y31.514
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X161.833 Y28.202 E.11099
G1 X165.537 Y28.202 E.12413
G1 X165.537 Y31.906 E.12413
G1 X161.833 Y31.906 E.12413
G1 X161.833 Y31.574 E.01113
; COOLING_NODE: 0
M204 S250
G1 X162.225 Y31.514 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X162.225 Y30.594 E.02856
G1 X162.225 Y30.194 E.01242
G1 X162.225 Y29.794 E.01242
G1 X162.225 Y29.394 E.01242
G1 X162.225 Y28.994 E.01242
G1 X162.225 Y28.594 E.01242
G1 X162.736 Y28.594 E.01586
G1 F5595.29
G1 X163.136 Y28.594 E.01242
G1 F4706.632
G1 X163.536 Y28.594 E.01242
G1 F3894.774
G1 X163.936 Y28.594 E.01242
G1 F3159.716
G1 X164.336 Y28.594 E.01242
G1 F2501.458
G1 X164.736 Y28.594 E.01242
G1 F1920
G1 X165.104 Y28.594 E.01142
G1 F1976.205
G1 X165.145 Y28.594 E.00128
G1 F2565.554
G1 X165.145 Y28.994 E.01242
G1 F3231.703
G1 X165.145 Y29.394 E.01242
G1 F3974.652
G1 X165.145 Y29.794 E.01242
G1 F4794.401
G1 X165.145 Y30.194 E.01242
G1 F5690.951
G1 X165.145 Y30.594 E.01242
G1 F6000
G1 X165.145 Y30.994 E.01242
G1 X165.145 Y31.514 E.01614
G1 X164.745 Y31.514 E.01242
G1 X164.345 Y31.514 E.01242
G1 X163.945 Y31.514 E.01242
G1 X163.545 Y31.514 E.01242
G1 X162.285 Y31.514 E.03911
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X162.225 Y30.594 E-.35034
G1 X162.225 Y30.516 E-.02966
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I.054 J-1.216 P1  F60000
G1 X139.225 Y29.502 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X139.722 Y29.502 E.01667
G1 F5389.068
G1 X140.122 Y29.502 E.0134
G1 F4517.655
G1 X140.522 Y29.502 E.0134
G1 F3723.041
G1 X140.922 Y29.502 E.0134
G1 F3005.227
G1 X141.322 Y29.502 E.0134
G1 F2364.214
G1 X141.722 Y29.502 E.0134
G1 F1800
G1 X142.117 Y29.502 E.01323
M106 S178.5
M106 S255
G1 F2393.925
G1 X142.537 Y29.502 E.01406
G1 F3038.713
G1 X142.537 Y29.902 E.0134
G1 F3760.302
G1 X142.537 Y30.302 E.0134
G1 F4558.69
G1 X142.537 Y30.702 E.0134
G1 F5433.878
G1 X142.537 Y31.102 E.0134
G1 F6000
G1 X142.537 Y31.502 E.0134
G1 X142.537 Y31.902 E.0134
G1 X142.537 Y32.302 E.0134
G1 X142.537 Y32.702 E.0134
G1 X142.537 Y33.206 E.01689
G1 X142.137 Y33.206 E.0134
G1 X141.737 Y33.206 E.0134
G1 X141.337 Y33.206 E.0134
G1 X140.937 Y33.206 E.0134
G1 X140.537 Y33.206 E.0134
G1 X138.833 Y33.206 E.05711
G1 X138.833 Y29.502 E.12413
G1 X139.165 Y29.502 E.01113
; COOLING_NODE: 0
M204 S250
G1 X139.225 Y29.894 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X139.736 Y29.894 E.01586
G1 F5595.29
G1 X140.136 Y29.894 E.01242
G1 F4706.632
G1 X140.536 Y29.894 E.01242
G1 F3894.774
G1 X140.936 Y29.894 E.01242
G1 F3159.716
G1 X141.336 Y29.894 E.01242
G1 F2501.458
G1 X141.736 Y29.894 E.01242
G1 F1920
G1 X142.104 Y29.894 E.01142
G1 F1976.191
G1 X142.145 Y29.894 E.00128
G1 F2565.538
G1 X142.145 Y30.294 E.01242
G1 F3231.685
G1 X142.145 Y30.694 E.01242
G1 F3974.633
G1 X142.145 Y31.094 E.01242
G1 F4794.38
G1 X142.145 Y31.494 E.01242
G1 F5690.927
G1 X142.145 Y31.894 E.01242
G1 F6000
G1 X142.145 Y32.294 E.01242
G1 X142.145 Y32.814 E.01614
G1 X141.745 Y32.814 E.01242
G1 X141.345 Y32.814 E.01242
G1 X140.945 Y32.814 E.01242
G1 X140.545 Y32.814 E.01242
G1 X139.225 Y32.814 E.04097
G1 X139.225 Y29.954 E.08878
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X139.736 Y29.894 E-.19555
G1 X140.136 Y29.894 E-.152
G1 X140.221 Y29.894 E-.03245
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I-.178 J1.204 P1  F60000
G1 X159.833 Y32.802 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
M204 S8000
G1 X159.833 Y35.302 E.08378
G1 X138.537 Y35.302 E.71363
G1 X138.537 Y26.506 E.29475
G1 X140.722 Y26.506 E.07324
G1 X141.122 Y26.506 E.0134
G1 F16687.791
G1 X141.522 Y26.506 E.0134
G1 F15125.178
G1 X141.922 Y26.506 E.0134
G1 F13639.364
G1 X142.322 Y26.506 E.0134
G1 F12230.35
G1 X142.722 Y26.506 E.0134
G1 F10898.137
G1 X143.122 Y26.506 E.0134
G1 F9642.723
G1 X143.522 Y26.506 E.0134
G1 F8464.109
G1 X143.922 Y26.506 E.0134
G1 F7362.296
G1 X144.322 Y26.506 E.0134
G1 F6337.282
G1 X144.722 Y26.506 E.0134
G1 F5389.068
G1 X145.122 Y26.506 E.0134
G1 F4517.655
G1 X145.522 Y26.506 E.0134
G1 F3723.041
G1 X145.922 Y26.506 E.0134
G1 F3005.227
G1 X146.322 Y26.506 E.0134
G1 F2364.214
G1 X146.722 Y26.506 E.0134
G1 F1800
G1 X147.117 Y26.506 E.01323
M106 S178.5
M106 S255
G1 F2364.214
G1 X147.517 Y26.506 E.0134
G1 F3005.227
G1 X147.917 Y26.506 E.0134
G1 F3723.041
G1 X148.317 Y26.506 E.0134
G1 F4517.655
G1 X148.717 Y26.506 E.0134
G1 F5389.068
G1 X149.117 Y26.506 E.0134
G1 F6337.282
G1 X149.517 Y26.506 E.0134
G1 F7362.296
G1 X149.917 Y26.506 E.0134
G1 F8464.109
G1 X150.317 Y26.506 E.0134
G1 F9642.723
G1 X150.717 Y26.506 E.0134
G1 F10898.137
G1 X151.117 Y26.506 E.0134
G1 F12230.35
G1 X151.517 Y26.506 E.0134
G1 F13639.364
G1 X151.917 Y26.506 E.0134
G1 F15125.178
G1 X152.317 Y26.506 E.0134
G1 F16687.791
G1 X152.717 Y26.506 E.0134
G1 F18000
G1 X153.117 Y26.506 E.0134
G1 X163.722 Y26.506 E.35538
G1 X164.122 Y26.506 E.0134
G1 F16687.791
G1 X164.522 Y26.506 E.0134
G1 F15125.178
G1 X164.922 Y26.506 E.0134
G1 F13639.364
G1 X165.322 Y26.506 E.0134
G1 F12230.35
G1 X165.722 Y26.506 E.0134
G1 F10898.137
G1 X166.122 Y26.506 E.0134
G1 F9642.723
G1 X166.522 Y26.506 E.0134
G1 F8464.109
G1 X166.922 Y26.506 E.0134
G1 F7362.296
G1 X167.322 Y26.506 E.0134
G1 F6337.282
G1 X167.722 Y26.506 E.0134
G1 F5389.068
G1 X168.122 Y26.506 E.0134
G1 F4517.655
G1 X168.522 Y26.506 E.0134
G1 F3723.041
G1 X168.922 Y26.506 E.0134
G1 F3005.227
G1 X169.322 Y26.506 E.0134
G1 F2364.214
G1 X169.722 Y26.506 E.0134
G1 F1800
G1 X170.117 Y26.506 E.01323
M106 S178.5
M106 S255
G1 F2364.214
G1 X170.517 Y26.506 E.0134
G1 F3005.227
G1 X170.917 Y26.506 E.0134
G1 F3723.041
G1 X171.317 Y26.506 E.0134
G1 F4517.655
G1 X171.717 Y26.506 E.0134
G1 F5389.068
G1 X172.117 Y26.506 E.0134
G1 F6337.282
G1 X172.517 Y26.506 E.0134
G1 F7362.296
G1 X172.917 Y26.506 E.0134
G1 F8464.109
G1 X173.317 Y26.506 E.0134
G1 F9642.723
G1 X173.717 Y26.506 E.0134
G1 F10898.137
G1 X174.117 Y26.506 E.0134
G1 F12230.35
G1 X174.517 Y26.506 E.0134
G1 F13639.364
G1 X174.917 Y26.506 E.0134
G1 F15125.178
G1 X175.317 Y26.506 E.0134
G1 F16687.791
G1 X175.717 Y26.506 E.0134
G1 F18000
G1 X176.117 Y26.506 E.0134
G1 X178.833 Y26.506 E.09103
G1 X178.833 Y29.006 E.08378
G1 X182.538 Y29.006 E.12413
G1 X182.538 Y26.506 E.08378
G1 X183.333 Y26.506 E.02664
G1 X183.333 Y35.302 E.29475
G1 X182.538 Y35.302 E.02664
G1 X182.538 Y32.802 E.08378
G1 X178.833 Y32.802 E.12413
G1 X178.833 Y35.302 E.08378
G1 X176.117 Y35.302 E.09103
G1 X175.717 Y35.302 E.0134
G1 F16687.791
G1 X175.317 Y35.302 E.0134
G1 F15125.178
G1 X174.917 Y35.302 E.0134
G1 F13639.364
G1 X174.517 Y35.302 E.0134
G1 F12230.35
G1 X174.117 Y35.302 E.0134
G1 F10898.137
G1 X173.717 Y35.302 E.0134
G1 F9642.723
G1 X173.317 Y35.302 E.0134
G1 F8464.109
G1 X172.917 Y35.302 E.0134
G1 F7362.296
G1 X172.517 Y35.302 E.0134
G1 F6337.282
G1 X172.117 Y35.302 E.0134
G1 F5389.068
G1 X171.717 Y35.302 E.0134
G1 F4517.655
G1 X171.317 Y35.302 E.0134
G1 F3723.041
G1 X170.917 Y35.302 E.0134
G1 F3005.227
G1 X170.517 Y35.302 E.0134
G1 F2364.214
G1 X170.117 Y35.302 E.0134
G1 F1800
G1 X169.722 Y35.302 E.01323
M106 S178.5
G1 F2364.214
G1 X169.322 Y35.302 E.0134
G1 F3005.227
G1 X168.922 Y35.302 E.0134
G1 F3723.041
G1 X168.522 Y35.302 E.0134
G1 F4517.655
G1 X168.122 Y35.302 E.0134
G1 F5389.068
G1 X167.722 Y35.302 E.0134
G1 F6337.282
G1 X167.322 Y35.302 E.0134
G1 F7362.296
G1 X166.922 Y35.302 E.0134
G1 F8464.109
G1 X166.522 Y35.302 E.0134
G1 F9642.723
G1 X166.122 Y35.302 E.0134
G1 F10898.137
G1 X165.722 Y35.302 E.0134
G1 F12230.35
G1 X165.322 Y35.302 E.0134
G1 F13639.364
G1 X164.922 Y35.302 E.0134
G1 F15125.178
G1 X164.522 Y35.302 E.0134
G1 F16687.791
G1 X164.122 Y35.302 E.0134
G1 F18000
G1 X163.537 Y35.302 E.01962
G1 X163.537 Y32.802 E.08378
G1 X159.893 Y32.802 E.12212
; COOLING_NODE: 0
M204 S250
G1 X160.225 Y33.194 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6221
M204 S5000
G1 X160.225 Y35.694 E.0776
G1 X138.145 Y35.694 E.68538
G1 X138.145 Y26.114 E.29737
G1 X142.336 Y26.114 E.1301
G1 X142.736 Y26.114 E.01242
G1 X143.136 Y26.114 E.01242
G1 X143.536 Y26.114 E.01242
G1 X143.936 Y26.114 E.01242
G1 X144.336 Y26.114 E.01242
G1 X144.736 Y26.114 E.01242
G1 F5595.29
G1 X145.136 Y26.114 E.01242
G1 F4706.632
G1 X145.536 Y26.114 E.01242
G1 F3894.774
G1 X145.936 Y26.114 E.01242
G1 F3159.716
G1 X146.336 Y26.114 E.01242
G1 F2501.458
G1 X146.736 Y26.114 E.01242
G1 F1920
G1 X147.104 Y26.114 E.01142
G1 F2501.458
G1 X147.504 Y26.114 E.01242
G1 F3159.716
G1 X147.904 Y26.114 E.01242
G1 F3894.774
G1 X148.304 Y26.114 E.01242
G1 F4706.632
G1 X148.704 Y26.114 E.01242
G1 F5595.29
G1 X149.104 Y26.114 E.01242
G1 F6221
G1 X149.504 Y26.114 E.01242
G1 X149.904 Y26.114 E.01242
G1 X150.304 Y26.114 E.01242
G1 X150.704 Y26.114 E.01242
G1 X151.104 Y26.114 E.01242
G1 X151.504 Y26.114 E.01242
G1 X165.336 Y26.114 E.42936
G1 X165.736 Y26.114 E.01242
G1 X166.136 Y26.114 E.01242
G1 X166.536 Y26.114 E.01242
G1 X166.936 Y26.114 E.01242
G1 X167.336 Y26.114 E.01242
G1 X167.736 Y26.114 E.01242
G1 F5595.29
G1 X168.136 Y26.114 E.01242
G1 F4706.632
G1 X168.536 Y26.114 E.01242
G1 F3894.774
G1 X168.936 Y26.114 E.01242
G1 F3159.716
G1 X169.336 Y26.114 E.01242
G1 F2501.458
G1 X169.736 Y26.114 E.01242
G1 F1920
G1 X170.104 Y26.114 E.01142
G1 F2501.458
G1 X170.504 Y26.114 E.01242
G1 F3159.716
G1 X170.904 Y26.114 E.01242
G1 F3894.774
G1 X171.304 Y26.114 E.01242
G1 F4706.632
G1 X171.704 Y26.114 E.01242
G1 F5595.29
G1 X172.104 Y26.114 E.01242
G1 F6221
G1 X172.504 Y26.114 E.01242
G1 X172.904 Y26.114 E.01242
G1 X173.304 Y26.114 E.01242
G1 X173.704 Y26.114 E.01242
G1 X174.104 Y26.114 E.01242
G1 X174.504 Y26.114 E.01242
G1 X179.225 Y26.114 E.14657
G1 X179.225 Y28.614 E.0776
G1 X182.145 Y28.614 E.09064
G1 X182.145 Y26.114 E.0776
G1 X183.725 Y26.114 E.04902
G1 X183.725 Y35.694 E.29737
G1 X182.145 Y35.694 E.04902
G1 X182.145 Y33.194 E.0776
G1 X179.225 Y33.194 E.09064
M73 P47 R11
G1 X179.225 Y35.694 E.0776
G1 X174.504 Y35.694 E.14657
G1 X174.104 Y35.694 E.01242
G1 X173.704 Y35.694 E.01242
G1 X173.304 Y35.694 E.01242
G1 X172.904 Y35.694 E.01242
G1 X172.504 Y35.694 E.01242
M73 P48 R11
G1 X172.104 Y35.694 E.01242
G1 F5595.29
G1 X171.704 Y35.694 E.01242
G1 F4706.632
G1 X171.304 Y35.694 E.01242
G1 F3894.774
G1 X170.904 Y35.694 E.01242
G1 F3159.716
G1 X170.504 Y35.694 E.01242
G1 F2501.458
G1 X170.104 Y35.694 E.01242
G1 F1920
G1 X169.736 Y35.694 E.01142
G1 F2501.458
G1 X169.336 Y35.694 E.01242
G1 F3159.716
G1 X168.936 Y35.694 E.01242
G1 F3894.774
G1 X168.536 Y35.694 E.01242
G1 F4706.632
G1 X168.136 Y35.694 E.01242
G1 F5595.29
G1 X167.736 Y35.694 E.01242
G1 F6221
G1 X167.336 Y35.694 E.01242
G1 X166.936 Y35.694 E.01242
G1 X166.536 Y35.694 E.01242
G1 X166.136 Y35.694 E.01242
G1 X165.736 Y35.694 E.01242
G1 X165.336 Y35.694 E.01242
G1 X163.145 Y35.694 E.06801
G1 X163.145 Y33.194 E.0776
G1 X160.285 Y33.194 E.08878
; WIPE_START
G1 F12000
M204 S8000
G1 X160.261 Y34.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I.976 J.726 P1  F60000
G1 X161.629 Y32.354 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F15000
M204 S8000
G1 X163.74 Y32.354 E.08494
; WIPE_START
G1 X162.74 Y32.354 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I.535 J-1.093 P1  F60000
G1 X161.484 Y31.74 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X161.484 Y28.057 E.1234
G3 X161.688 Y27.854 I.204 J0 E.01071
G1 X165.681 Y27.854 E.13382
G3 X165.885 Y28.057 I0 J.204 E.01071
G1 X165.885 Y32.051 E.13382
G3 X165.717 Y32.251 I-.204 J0 E.00953
G3 X164.088 Y32.254 I-1.104 J-154.512 E.05456
G3 X164.06 Y32.868 I-1.135 J.255 E.02085
G1 X163.885 Y32.968 E.00675
G1 X163.885 Y34.954 E.06654
G1 X170.993 Y34.954 E.23821
G1 X170.993 Y26.854 E.27141
G1 X150.736 Y26.854 E.67882
G1 X150.736 Y34.954 E.27141
G1 X159.484 Y34.954 E.29316
G1 X159.484 Y32.657 E.07695
G3 X159.688 Y32.454 I.204 J0 E.01071
G1 X161.281 Y32.454 E.05338
G3 X161.309 Y31.84 I1.135 J-.255 E.02085
G1 X161.432 Y31.77 E.00474
M204 S10000
G1 X154.786 Y30.904 F60000
; LINE_WIDTH: 0.40814
G1 F20535.567
M204 S8000
G1 X155.753 Y30.904 E.02908
M204 S10000
G1 X156.492 Y30.518 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X154.4 Y30.518 E.07013
G1 X154.4 Y31.29 E.02588
G1 X156.086 Y31.29 E.05652
G3 X156.461 Y30.569 I1.892 J.527 E.02743
M204 S10000
G1 X157.384 Y30.111 F60000
G1 F18424.351
M204 S8000
G1 X153.992 Y30.111 E.11364
G1 X153.992 Y31.697 E.05316
G1 X156.374 Y31.697 E.07982
G3 X157.341 Y30.153 I3.404 J1.057 E.06174
M204 S10000
G1 X158.635 Y29.704 F60000
G1 F18424.351
M204 S8000
G1 X153.585 Y29.704 E.16921
G1 X153.585 Y32.104 E.08044
G1 X156.702 Y32.104 E.10443
G3 X158.601 Y29.804 I3.065 J.597 E.10422
G1 X158.63 Y29.762 E.0017
M204 S10000
G1 X159.042 Y29.297 F60000
G1 F18424.351
M204 S8000
G1 X153.178 Y29.297 E.19649
G1 X153.178 Y32.511 E.10772
G1 X157.06 Y32.511 E.13006
G3 X159.042 Y30.13 I2.521 J.083 E.1118
G1 X159.042 Y29.357 E.02592
M204 S10000
G1 X159.449 Y28.89 F60000
G1 F18424.351
M204 S8000
G1 X152.771 Y28.89 E.22377
G1 X152.771 Y32.918 E.13501
G1 X157.449 Y32.918 E.15675
G3 X159.449 Y30.462 I2.219 J-.236 E.11801
G1 X159.449 Y28.95 E.05069
M204 S10000
G1 X159.856 Y28.482 F60000
G1 F18424.351
M204 S8000
G1 X152.364 Y28.482 E.25105
G1 X152.364 Y33.325 E.16229
G1 X157.856 Y33.325 E.18403
G3 X158.238 Y31.538 I2.812 J-.334 E.06236
G3 X159.856 Y30.825 I1.534 J1.29 E.06137
G1 X159.856 Y28.542 E.0765
M204 S10000
G1 X160.263 Y28.075 F60000
G1 F18424.351
M204 S8000
G1 X151.957 Y28.075 E.27833
G1 X151.957 Y33.733 E.18957
G1 X158.263 Y33.733 E.21131
G3 X158.39 Y32.07 I3.917 J-.538 E.0563
G3 X159.688 Y31.233 I1.298 J.587 E.05471
G1 X160.255 Y31.233 E.01899
G2 X160.263 Y28.135 I-103.105 J-1.836 E.10379
M204 S10000
G1 X160.8 Y27.668 F60000
G1 F18424.351
M204 S8000
G1 X151.55 Y27.668 E.30996
G1 X151.55 Y34.14 E.21685
G1 X158.67 Y34.14 E.2386
G1 X158.67 Y32.657 E.04967
G3 X159.688 Y31.64 I1.039 J.022 E.05327
G1 X160.55 Y31.64 E.02889
G3 X160.67 Y31.39 I.185 J-.065 E.01032
G1 X160.67 Y28.057 E.11167
G1 X160.781 Y27.725 E.01173
M204 S10000
G1 X161.566 Y27.359 F60000
; LINE_WIDTH: 0.621534
G1 F12962.014
M204 S8000
G1 X161.42 Y27.335 E.00701
; LINE_WIDTH: 0.572522
G1 F14161.599
G1 X161.275 Y27.31 E.00642
; LINE_WIDTH: 0.523509
G1 F15605.86
G1 X161.13 Y27.286 E.00583
; LINE_WIDTH: 0.450097
G1 F18419.504
G1 X151.143 Y27.261 E.33475
G1 X151.143 Y34.547 E.2442
G1 X159.077 Y34.547 E.26595
G1 X159.077 Y32.657 E.06333
G3 X159.688 Y32.047 I.611 J0 E.03215
G1 X160.874 Y32.047 E.03975
G1 X160.959 Y31.632 E.01419
G1 X161.077 Y31.565 E.00456
G1 X161.077 Y28.057 E.11757
G1 X161.199 Y27.691 E.01294
; LINE_WIDTH: 0.474497
G1 F17378.157
G1 X161.28 Y27.618 E.00385
; LINE_WIDTH: 0.523509
G1 F15605.86
G1 X161.36 Y27.545 E.00429
; LINE_WIDTH: 0.572522
G1 F14161.599
G1 X161.441 Y27.472 E.00473
; LINE_WIDTH: 0.621534
G1 F12962.014
G1 X161.521 Y27.4 E.00517
M204 S10000
G1 X161.566 Y27.359 F60000
; LINE_WIDTH: 0.635541
G1 F12655.643
M204 S8000
G1 X165.621 Y27.354 E.19786
M204 S10000
G1 X165.681 Y27.354 F60000
; LINE_WIDTH: 0.612207
G1 F13174.392
M204 S8000
G1 X165.803 Y27.438 E.00695
; LINE_WIDTH: 0.565859
G1 F14342.025
G1 X165.926 Y27.522 E.00639
; LINE_WIDTH: 0.519512
G1 F15736.757
G1 X166.048 Y27.607 E.00582
; LINE_WIDTH: 0.450121
G1 F18418.459
G1 X166.17 Y27.691 E.00497
G1 X166.292 Y28.057 E.01294
G1 X166.292 Y32.051 E.13386
G3 X165.681 Y32.661 I-.659 J-.049 E.03154
G1 X164.495 Y32.661 E.03975
G1 X164.41 Y33.076 E.01419
G1 X164.292 Y33.143 E.00456
G1 X164.292 Y34.547 E.04705
G1 X170.586 Y34.547 E.21099
G1 X170.586 Y27.261 E.24421
G1 X166.385 Y27.261 E.14084
; LINE_WIDTH: 0.473164
G1 F17431.98
G1 X166.224 Y27.282 E.00575
; LINE_WIDTH: 0.519512
G1 F15736.757
G1 X166.063 Y27.304 E.00637
; LINE_WIDTH: 0.565859
G1 F14342.025
G1 X165.902 Y27.325 E.00699
; LINE_WIDTH: 0.612207
G1 F13174.392
G1 X165.741 Y27.346 E.00761
M204 S10000
G1 X166.569 Y27.668 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X166.699 Y28.057 E.01374
G1 X166.699 Y32.051 E.13382
G3 X165.857 Y33.053 I-1.132 J-.096 E.04675
G3 X164.819 Y33.068 I-.83 J-21.109 E.03479
G2 X164.699 Y34.14 I1.498 J.71 E.03679
G1 X170.179 Y34.14 E.18364
G1 X170.179 Y27.668 E.21685
G1 X166.629 Y27.668 E.11896
M204 S10000
G1 X167.106 Y28.075 F60000
G1 F18424.351
M204 S8000
G1 X167.106 Y32.051 E.13321
G3 X166.454 Y33.248 I-1.685 J-.142 E.04701
; LINE_WIDTH: 0.434188
G1 F19168.473
G1 X166.188 Y33.335 E.00902
; LINE_WIDTH: 0.380723
G1 F21000
G3 X165.088 Y33.438 I-.916 J-3.868 E.03084
G1 X165.069 Y33.77 E.00925
G1 X165.681 Y33.77 E.01704
; LINE_WIDTH: 0.393755
G1 X166.139 Y33.751 E.01324
; LINE_WIDTH: 0.449268
G1 F18457.093
G3 X169.772 Y33.733 I2.045 J44.377 E.12156
G1 X169.772 Y28.075 E.18923
G1 X167.166 Y28.075 E.08718
M204 S10000
G1 X167.513 Y28.482 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X167.513 Y32.051 E.11957
G3 X166.922 Y33.325 I-1.645 J.012 E.04866
G1 X169.365 Y33.325 E.08188
G1 X169.365 Y28.482 E.16229
G1 X167.573 Y28.482 E.06005
M204 S10000
G1 X167.92 Y28.89 F60000
G1 F18424.351
M204 S8000
G1 X167.92 Y32.051 E.10593
G3 X167.711 Y32.918 I-1.785 J.028 E.03023
G1 X168.958 Y32.918 E.0418
G1 X168.958 Y28.89 E.13501
G1 X167.98 Y28.89 E.03277
M204 S10000
G1 X168.281 Y29.251 F60000
; LINE_WIDTH: 0.359732
G1 F21000
M204 S8000
G3 X168.267 Y32.369 I-34.637 J1.4 E.08135
G1 X168.208 Y32.552 E.00501
G1 X168.592 Y32.552 E.01001
G2 X168.597 Y29.251 I-579.586 J-2.562 E.08609
G1 X168.341 Y29.251 E.00666
M204 S10000
G1 X172.193 Y34.102 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.52653
G1 F15000
M204 S8000
G1 X172.676 Y34.102 E.01925
G1 X172.676 Y27.705 E.25466
G1 X172.193 Y27.705 E.01925
G1 X172.193 Y34.042 E.25227
M204 S10000
G1 X171.762 Y34.533 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X173.107 Y34.533 E.04173
G1 X173.107 Y27.275 E.22528
G1 X171.762 Y27.275 E.04173
G1 X171.762 Y34.473 E.22341
M204 S10000
G1 X171.385 Y34.91 F60000
G1 F15000
M204 S8000
G1 X173.484 Y34.91 E.06514
G1 X173.484 Y26.898 E.24868
G1 X171.385 Y26.898 E.06514
G1 X171.385 Y34.85 E.24682
M204 S10000
G1 X176.301 Y31.613 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.41512
G1 F20150.456
M204 S8000
G3 X176.739 Y30.904 I1.707 J.566 E.02577
G3 X176.301 Y30.195 I1.269 J-1.275 E.02577
G1 X176.301 Y31.553 E.0416
M204 S10000
G1 X175.911 Y32.918 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X176.45 Y32.918 E.01805
G3 X177.313 Y30.904 I2.468 J-.134 E.07609
G3 X176.584 Y29.913 I1.241 J-1.678 E.04185
; LINE_WIDTH: 0.47119
G1 F17512.317
G1 X176.513 Y29.729 E.00696
; LINE_WIDTH: 0.521816
G1 F15661.02
G3 X176.417 Y28.922 I1.137 J-.544 E.0326
G1 X175.944 Y28.922 E.01864
G1 X175.954 Y29.587 E.02621
; LINE_WIDTH: 0.51359
G1 F15934.732
G1 X175.932 Y29.809 E.00864
; LINE_WIDTH: 0.451541
G1 F18354.442
G1 X175.911 Y32.858 E.10256
M204 S10000
G1 X175.504 Y33.325 F60000
; LINE_WIDTH: 0.450024
G1 F18422.834
M204 S8000
G1 X176.857 Y33.325 E.04534
G3 X177.256 Y31.516 I2.765 J-.339 E.06329
G3 X178.138 Y30.904 I1.615 J1.385 E.03639
G3 X176.884 Y29.467 I.595 J-1.785 E.06702
G1 X176.857 Y28.482 E.03301
G1 X175.504 Y28.482 E.04534
G1 X175.504 Y33.265 E.16029
M204 S10000
G1 X175.097 Y33.733 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X177.264 Y33.733 E.07261
G3 X177.349 Y32.172 I4.444 J-.54 E.05264
G3 X177.931 Y31.451 I1.34 J.485 E.03163
; LINE_WIDTH: 0.471944
G1 F17481.567
G1 X178.14 Y31.358 E.00808
; LINE_WIDTH: 0.51585
G1 F15858.584
G1 X178.35 Y31.265 E.00891
; LINE_WIDTH: 0.574648
G1 F14104.97
G3 X178.689 Y31.17 I.282 J.354 E.01584
G1 X181.701 Y31.17 E.13184
G1 X181.701 Y30.638 E.02329
G3 X178.559 Y30.636 I-1.506 J-88.355 E.13753
; LINE_WIDTH: 0.559757
G1 F14511.355
G1 X178.35 Y30.543 E.00974
; LINE_WIDTH: 0.51585
G1 F15858.584
G1 X178.14 Y30.45 E.00891
; LINE_WIDTH: 0.450469
G1 F18402.716
G3 X177.264 Y29.151 I.517 J-1.294 E.05584
G1 X177.264 Y28.075 E.03607
G1 X175.097 Y28.075 E.0727
G1 X175.097 Y33.673 E.18778
M204 S10000
G1 X174.69 Y34.14 F60000
; LINE_WIDTH: 0.44999
G1 F18424.358
M204 S8000
G1 X177.671 Y34.14 E.09989
G1 X177.671 Y32.654 E.04978
G3 X178.689 Y31.64 I1.03 J.016 E.05328
G1 X182.006 Y31.64 E.11116
G3 X182.17 Y31.553 I.125 J.039 E.00691
G1 X182.17 Y30.255 E.04351
G3 X182.006 Y30.168 I-.039 J-.125 E.00691
G1 X178.689 Y30.168 E.11116
G3 X177.671 Y29.151 I.037 J-1.054 E.05307
G1 X177.671 Y27.668 E.04967
G1 X174.69 Y27.668 E.09989
G1 X174.69 Y34.08 E.21484
M204 S10000
G1 X174.283 Y34.547 F60000
; LINE_WIDTH: 0.44999
G1 F18424.357
M204 S8000
G1 X178.078 Y34.547 E.12718
G1 X178.078 Y32.655 E.06338
G3 X178.689 Y32.047 I.611 J.002 E.03207
G1 X182.189 Y32.047 E.11728
G1 X182.249 Y31.938 E.00417
G1 X182.575 Y31.841 E.0114
G2 X182.575 Y29.967 I-174.807 J-.937 E.06278
G1 X182.249 Y29.87 E.0114
G1 X182.189 Y29.761 E.00417
G1 X178.689 Y29.761 E.11728
G3 X178.078 Y29.151 I0 J-.611 E.03214
G1 X178.078 Y27.261 E.06331
G1 X174.283 Y27.261 E.12718
G1 X174.283 Y34.487 E.24212
M204 S10000
G1 X173.876 Y34.954 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X178.485 Y34.954 E.15446
G1 X178.485 Y32.657 E.07698
G3 X178.689 Y32.454 I.204 J.001 E.01069
G1 X182.371 Y32.454 E.1234
G1 X182.466 Y32.282 E.00658
G1 X182.984 Y32.25 E.0174
G1 X182.984 Y29.558 E.09023
G1 X182.466 Y29.526 E.0174
G1 X182.371 Y29.354 E.00658
G1 X178.689 Y29.354 E.1234
G3 X178.485 Y29.151 I0 J-.204 E.01071
G1 X178.485 Y26.854 E.07695
G1 X173.876 Y26.854 E.15446
G1 X173.876 Y34.894 E.2694
; WIPE_START
G1 X173.876 Y33.894 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I-.16 J1.206 P1  F60000
G1 X182.935 Y35.098 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43093
G1 F15000
M204 S8000
G1 X182.935 Y32.598 E.07985
M204 S10000
G1 X182.935 Y29.209 F60000
G1 F15000
M204 S8000
G1 X182.935 Y26.71 E.07985
; WIPE_START
G1 X182.935 Y27.71 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I-.004 J-1.217 P1  F60000
G1 X150.344 Y27.807 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X150.344 Y26.898 E.02822
G1 X148.525 Y26.898 E.05645
G1 X148.525 Y34.91 E.24868
G1 X150.344 Y34.91 E.05645
G1 X150.344 Y27.867 E.2186
M204 S10000
G1 X149.967 Y27.807 F60000
G1 F15000
M204 S8000
G1 X149.967 Y27.275 E.01652
G1 X148.902 Y27.275 E.03304
G1 X148.902 Y34.533 E.22528
G1 X149.967 Y34.533 E.03304
G1 X149.967 Y27.867 E.20689
M204 S10000
G1 X149.606 Y27.807 F60000
; LINE_WIDTH: 0.38661
G1 F15000
M204 S8000
G1 X149.606 Y27.636 E.00486
G1 X149.263 Y27.636 E.00972
G1 X149.263 Y34.172 E.18494
G1 X149.606 Y34.172 E.00972
G1 X149.606 Y27.867 E.17838
M204 S10000
G1 X148.133 Y29.478 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X148.133 Y26.854 E.08794
G1 X138.885 Y26.854 E.30991
G1 X138.885 Y29.154 E.07706
G1 X142.681 Y29.154 E.12722
G3 X142.885 Y29.357 I0 J.204 E.01071
G1 X142.885 Y33.351 E.13382
G3 X142.681 Y33.554 I-.204 J0 E.01071
G1 X138.885 Y33.554 E.12722
G1 X138.885 Y34.954 E.0469
G1 X148.133 Y34.954 E.30991
G1 X148.133 Y29.538 E.18146
M204 S10000
G1 X147.726 Y29.478 F60000
G1 F18424.351
M204 S8000
G1 X147.726 Y27.261 E.0743
G1 X139.292 Y27.261 E.28263
G1 X139.292 Y28.747 E.04978
G1 X142.681 Y28.747 E.11358
G3 X143.292 Y29.478 I-.06 J.671 E.03548
G1 X143.292 Y33.351 E.12976
G1 X143.17 Y33.717 E.01294
; LINE_WIDTH: 0.47399
G1 F17398.565
G1 X142.982 Y33.858 E.00832
; LINE_WIDTH: 0.538668
G1 F15128.671
G3 X142.681 Y34.006 I-.261 J-.152 E.01451
G1 X139.337 Y34.006 E.1365
G1 X139.337 Y34.502 E.02025
G1 X142.681 Y34.502 E.1365
; LINE_WIDTH: 0.51686
G1 F15824.788
G1 X143.133 Y34.524 E.01764
; LINE_WIDTH: 0.45104
G1 F18376.959
G1 X147.726 Y34.547 E.15432
G1 X147.726 Y29.538 E.16826
M204 S10000
G1 X147.319 Y29.478 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X147.319 Y27.668 E.06066
G1 X143.584 Y27.668 E.12518
; LINE_WIDTH: 0.472005
G1 F17479.054
G1 X143.283 Y27.69 E.01065
; LINE_WIDTH: 0.516035
G1 F15852.381
G1 X142.982 Y27.712 E.01174
; LINE_WIDTH: 0.581086
G1 F13936.241
G1 X139.765 Y27.734 E.14252
G1 X139.765 Y28.274 E.02389
G1 X142.681 Y28.274 E.12919
; LINE_WIDTH: 0.560065
G1 F14502.703
G1 X142.885 Y28.363 E.00947
; LINE_WIDTH: 0.516035
G1 F15852.381
G1 X143.088 Y28.453 E.00867
; LINE_WIDTH: 0.45032
G1 F18409.433
G1 X143.292 Y28.543 E.00746
G3 X143.699 Y29.478 I-.633 J.832 E.03574
G1 X143.699 Y33.351 E.12986
G1 X143.495 Y33.961 E.02159
G1 X143.205 Y34.14 E.01143
G1 X147.319 Y34.14 E.13798
G1 X147.319 Y29.538 E.15431
M204 S10000
G1 X146.912 Y29.478 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X146.912 Y28.075 E.04702
G1 X143.11 Y28.075 E.12741
G1 X143.536 Y28.217 E.01505
G1 X143.996 Y28.809 E.02512
G1 X144.106 Y29.357 E.01873
G1 X144.106 Y33.351 E.13382
G1 X143.979 Y33.733 E.01349
G1 X146.912 Y33.733 E.0983
G1 X146.912 Y29.538 E.14054
M204 S10000
G1 X146.505 Y29.478 F60000
G1 F18424.351
M204 S8000
G1 X146.505 Y28.482 E.03337
G1 X144.24 Y28.482 E.07591
G1 X144.372 Y28.653 E.00723
G1 X144.513 Y29.357 E.02408
G1 X144.513 Y33.325 E.13297
G1 X146.505 Y33.325 E.06675
G1 X146.505 Y29.538 E.1269
M204 S10000
G1 X146.098 Y29.478 F60000
G1 F18424.351
M204 S8000
G1 X146.098 Y28.89 E.01973
G1 X144.827 Y28.89 E.0426
G1 X144.92 Y29.478 E.01998
G1 X144.92 Y32.918 E.11527
G1 X146.098 Y32.918 E.03947
G1 X146.098 Y29.538 E.11326
M204 S10000
G1 X145.702 Y29.478 F60000
; LINE_WIDTH: 0.42829
G1 F19461.816
M204 S8000
G1 X145.702 Y29.286 E.00611
G1 X145.302 Y29.286 E.01268
G1 X145.316 Y32.522 E.10267
G1 X145.702 Y32.522 E.01223
G1 X145.702 Y29.538 E.09465
; WIPE_START
G1 X145.702 Y30.538 E-.38
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
    

    

    
        M9711 M0 E0 U252 V34 Z1.2 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 5/12
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
M106 S168.3
; OBJECT_ID: 423
; COOLING_NODE: 0
G1 X178.833 Y32.802 F60000
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X178.833 Y35.302 E.08378
G1 X175.537 Y35.302 E.11047
G1 X175.537 Y26.506 E.29475
G1 X178.833 Y26.506 E.11047
G1 X178.833 Y29.006 E.08378
G1 X182.538 Y29.006 E.12413
G1 X182.538 Y26.506 E.08378
G1 X183.333 Y26.506 E.02664
G1 X183.333 Y35.302 E.29475
G1 X182.538 Y35.302 E.02664
G1 X182.538 Y32.802 E.08378
G1 X178.893 Y32.802 E.12212
; COOLING_NODE: 0
M204 S250
G1 X179.225 Y33.194 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X179.225 Y35.694 E.0776
G1 X175.145 Y35.694 E.12667
G1 X175.145 Y26.114 E.29737
G1 X179.225 Y26.114 E.12667
G1 X179.225 Y28.614 E.0776
G1 X182.145 Y28.614 E.09064
G1 X182.145 Y26.114 E.0776
G1 X183.725 Y26.114 E.04902
G1 X183.725 Y35.694 E.29737
G1 X182.145 Y35.694 E.04902
G1 X182.145 Y33.194 E.0776
G1 X179.285 Y33.194 E.08878
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X179.261 Y34.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.185 J-1.203 P1  F60000
G1 X161.833 Y31.514 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X161.833 Y28.202 E.11099
G1 X165.537 Y28.202 E.12413
G1 X165.537 Y31.906 E.12413
G1 X161.833 Y31.906 E.12413
G1 X161.833 Y31.574 E.01113
; COOLING_NODE: 0
M204 S250
G1 X162.225 Y31.514 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X162.225 Y28.594 E.09064
G1 X165.145 Y28.594 E.09064
G1 X165.145 Y31.514 E.09064
G1 X162.285 Y31.514 E.08878
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X162.264 Y30.514 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.834 J-.886 P1  F60000
G1 X159.833 Y32.802 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X159.833 Y35.302 E.08378
G1 X152.537 Y35.302 E.24449
G1 X152.537 Y26.506 E.29475
G1 X169.333 Y26.506 E.56284
G1 X169.333 Y35.302 E.29475
G1 X163.537 Y35.302 E.19422
G1 X163.537 Y32.802 E.08378
G1 X159.893 Y32.802 E.12212
; COOLING_NODE: 0
M204 S250
G1 X160.225 Y33.194 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X160.225 Y35.694 E.0776
G1 X152.145 Y35.694 E.25081
G1 X152.145 Y26.114 E.29737
G1 X169.725 Y26.114 E.5457
G1 X169.725 Y35.694 E.29737
G1 X163.145 Y35.694 E.20425
G1 X163.145 Y33.194 E.0776
G1 X160.285 Y33.194 E.08878
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X160.261 Y34.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.265 J-1.188 P1  F60000
G1 X139.225 Y29.502 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X142.537 Y29.502 E.11099
G1 X142.537 Y33.206 E.12413
G1 X138.833 Y33.206 E.12413
G1 X138.833 Y29.502 E.12413
G1 X139.165 Y29.502 E.01113
; COOLING_NODE: 0
M204 S250
G1 X139.225 Y29.894 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P49 R11
G1 F6000
M204 S5000
G1 X142.145 Y29.894 E.09064
G1 X142.145 Y32.814 E.09064
G1 X139.225 Y32.814 E.09064
G1 X139.225 Y29.954 E.08878
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X140.224 Y29.933 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.191 J1.202 P1  F60000
G1 X146.333 Y30.904 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X146.333 Y35.302 E.14738
G1 X138.537 Y35.302 E.26124
G1 X138.537 Y26.506 E.29475
G1 X146.333 Y26.506 E.26124
G1 X146.333 Y30.844 E.14537
; COOLING_NODE: 0
M204 S250
G1 X146.725 Y30.904 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X146.725 Y35.694 E.14869
G1 X138.145 Y35.694 E.26633
G1 X138.145 Y26.114 E.29737
G1 X146.725 Y26.114 E.26633
G1 X146.725 Y30.844 E.14682
; WIPE_START
M204 S8000
G1 X146.725 Y31.844 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.998 J-.697 P1  F60000
G1 X144.36 Y28.458 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.4991
G1 F16440.879
M204 S8000
G2 X144.303 Y28.556 I-.021 J.053 E.00618
G1 X144.357 Y28.556 E.00203
M204 S10000
G1 X144.763 Y28.507 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X144.763 Y28.075 E.01446
G1 X143.15 Y28.075 E.05406
G1 X143.476 Y28.175 E.01142
G1 X143.948 Y28.705 E.02377
; LINE_WIDTH: 0.470827
G1 F17527.185
G1 X144.021 Y28.922 E.00809
; LINE_WIDTH: 0.5125
G1 F15971.72
G1 X144.095 Y29.14 E.00888
; LINE_WIDTH: 0.574547
G1 F14107.639
G1 X144.169 Y29.357 E.01005
G1 X144.169 Y33.351 E.17476
G1 X144.068 Y33.67 E.01464
G1 X144.7 Y33.67 E.02766
G1 X144.701 Y29.357 E.18873
; LINE_WIDTH: 0.554174
G1 F14669.832
G1 X144.72 Y29.094 E.01112
; LINE_WIDTH: 0.5125
G1 F15971.72
G1 X144.739 Y28.83 E.01021
; LINE_WIDTH: 0.470827
G1 F17527.185
G1 X144.759 Y28.567 E.00931
M204 S10000
G1 X145.17 Y28.507 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X145.17 Y27.668 E.0281
G1 X143.506 Y27.668 E.05575
; LINE_WIDTH: 0.472005
G1 F17479.054
G1 X143.231 Y27.69 E.00975
; LINE_WIDTH: 0.516035
G1 F15852.381
G1 X142.956 Y27.712 E.01075
; LINE_WIDTH: 0.581167
G1 F13934.143
G1 X139.765 Y27.734 E.1414
G1 X139.765 Y28.274 E.02389
G1 X142.681 Y28.274 E.12921
; LINE_WIDTH: 0.560065
G1 F14502.703
G1 X142.871 Y28.353 E.00874
; LINE_WIDTH: 0.516035
G1 F15852.381
G1 X143.06 Y28.433 E.008
; LINE_WIDTH: 0.450321
G1 F18409.418
G1 X143.249 Y28.513 E.00689
G3 X143.699 Y29.357 I-.568 J.845 E.03341
G1 X143.699 Y33.351 E.13393
G1 X143.481 Y33.981 E.02236
G1 X143.214 Y34.14 E.0104
G1 X145.17 Y34.14 E.06559
G1 X145.17 Y28.567 E.18689
M204 S10000
G1 X145.577 Y28.507 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X145.577 Y27.261 E.04175
G1 X139.292 Y27.261 E.21062
G1 X139.292 Y28.747 E.04978
G1 X142.681 Y28.747 E.11358
G3 X143.292 Y29.357 I-.051 J.662 E.0315
G1 X143.292 Y33.351 E.13382
G1 X143.161 Y33.729 E.0134
; LINE_WIDTH: 0.47399
G1 F17398.565
G1 X142.978 Y33.864 E.00807
; LINE_WIDTH: 0.538683
G1 F15128.195
G3 X142.681 Y34.006 I-.256 J-.155 E.01421
G1 X139.337 Y34.006 E.1365
G1 X139.337 Y34.502 E.02025
G1 X142.681 Y34.502 E.1365
; LINE_WIDTH: 0.51686
G1 F15824.788
G1 X143.12 Y34.524 E.01712
; LINE_WIDTH: 0.451149
G1 F18372.036
G2 X145.577 Y34.547 I1.448 J-24.149 E.08263
G1 X145.577 Y28.567 E.20095
M204 S10000
G1 X145.984 Y28.507 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X145.984 Y26.854 E.05539
G1 X138.885 Y26.854 E.2379
G1 X138.885 Y29.154 E.07706
G1 X142.681 Y29.154 E.12722
G3 X142.885 Y29.357 I0 J.204 E.01071
G1 X142.885 Y33.357 E.13402
G3 X142.681 Y33.554 I-.203 J-.006 E.01051
G1 X138.885 Y33.554 E.12722
G1 X138.885 Y34.954 E.0469
G1 X145.984 Y34.954 E.2379
G1 X145.984 Y28.567 E.21402
; WIPE_START
G1 X145.984 Y29.567 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.213 J1.198 P1  F60000
G1 X161.629 Y32.354 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F15000
M204 S8000
G1 X163.74 Y32.354 E.08494
M204 S10000
G1 X166.822 Y33.37 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.36016
G1 F21000
M204 S8000
G1 X167.401 Y33.37 E.01513
G1 X167.401 Y32.453 E.02396
G1 X167.115 Y33.117 E.01888
G1 X166.867 Y33.331 E.00856
M204 S10000
G1 X167.169 Y28.138 F60000
; LINE_WIDTH: 0.575422
G1 F14084.464
M204 S8000
G1 X167.153 Y32.309 E.18283
; LINE_WIDTH: 0.56524
G1 F14359.014
G1 X167.043 Y32.506 E.0097
; LINE_WIDTH: 0.51914
G1 F15749.024
G1 X166.934 Y32.704 E.00885
; LINE_WIDTH: 0.456138
G1 F18150.223
G1 X166.825 Y32.901 E.00768
G1 X166.355 Y33.306 E.0211
; LINE_WIDTH: 0.434188
G1 F19168.473
G1 X166.138 Y33.365 E.00722
; LINE_WIDTH: 0.380112
G1 F21000
G3 X165.088 Y33.438 I-.885 J-5.112 E.02929
G1 X165.069 Y33.77 E.00923
G1 X165.681 Y33.77 E.01701
; LINE_WIDTH: 0.393755
G1 X166.072 Y33.751 E.01128
; LINE_WIDTH: 0.446681
G1 F18575.383
G3 X167.763 Y33.733 I1.041 J17.605 E.05625
G1 X167.763 Y33.212 E.01731
; LINE_WIDTH: 0.47304
G1 F17436.996
G1 X167.74 Y32.926 E.01013
; LINE_WIDTH: 0.51914
G1 F15749.024
G1 X167.717 Y32.641 E.01122
; LINE_WIDTH: 0.574856
G1 F14099.456
G3 X167.701 Y32.051 I2.866 J-.375 E.02591
G1 X167.701 Y28.138 E.17133
G1 X167.229 Y28.138 E.02067
M204 S10000
G1 X166.569 Y27.668 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X166.699 Y28.057 E.01374
G1 X166.699 Y32.051 E.13382
G3 X165.857 Y33.053 I-1.018 J0 E.04765
G3 X164.819 Y33.068 I-.83 J-21.109 E.03479
G2 X164.699 Y34.14 I1.498 J.71 E.03679
G1 X168.17 Y34.14 E.11632
G1 X168.17 Y27.668 E.21685
G1 X166.629 Y27.668 E.05163
M204 S10000
G1 X165.681 Y27.354 F60000
; LINE_WIDTH: 0.612207
G1 F13174.392
M204 S8000
G1 X165.803 Y27.438 E.00695
; LINE_WIDTH: 0.565859
G1 F14342.025
G1 X165.926 Y27.522 E.00639
; LINE_WIDTH: 0.519512
G1 F15736.757
G1 X166.048 Y27.607 E.00582
; LINE_WIDTH: 0.450144
G1 F18417.401
G1 X166.17 Y27.691 E.00497
G1 X166.292 Y28.057 E.01295
G1 X166.292 Y32.051 E.13387
G3 X165.681 Y32.661 I-.649 J-.038 E.03166
G1 X164.495 Y32.661 E.03976
G1 X164.41 Y33.076 E.01419
G1 X164.292 Y33.143 E.00456
G1 X164.292 Y34.547 E.04705
G1 X168.577 Y34.547 E.14366
G1 X168.577 Y27.261 E.24422
G1 X166.385 Y27.261 E.0735
; LINE_WIDTH: 0.473164
G1 F17431.98
G1 X166.224 Y27.282 E.00575
; LINE_WIDTH: 0.519512
G1 F15736.757
G1 X166.063 Y27.304 E.00637
; LINE_WIDTH: 0.565859
G1 F14342.025
G1 X165.902 Y27.325 E.00699
; LINE_WIDTH: 0.612207
G1 F13174.392
G1 X165.741 Y27.346 E.00761
M204 S10000
G1 X161.566 Y27.359 F60000
; LINE_WIDTH: 0.621534
G1 F12962.014
M204 S8000
G1 X161.42 Y27.335 E.00701
; LINE_WIDTH: 0.572522
G1 F14161.599
G1 X161.275 Y27.31 E.00642
; LINE_WIDTH: 0.523509
G1 F15605.86
G1 X161.13 Y27.286 E.00583
; LINE_WIDTH: 0.450113
G1 F18418.796
G1 X153.292 Y27.261 E.26273
G1 X153.292 Y34.547 E.2442
G1 X159.077 Y34.547 E.19392
G1 X159.077 Y32.657 E.06333
G3 X159.688 Y32.047 I.611 J0 E.03215
G1 X160.874 Y32.047 E.03975
G1 X160.959 Y31.632 E.01419
G1 X161.077 Y31.565 E.00456
G1 X161.077 Y28.057 E.11757
G1 X161.199 Y27.691 E.01294
; LINE_WIDTH: 0.474497
G1 F17378.157
G1 X161.28 Y27.618 E.00385
; LINE_WIDTH: 0.523509
G1 F15605.86
G1 X161.36 Y27.545 E.00429
; LINE_WIDTH: 0.572522
G1 F14161.599
G1 X161.441 Y27.472 E.00473
; LINE_WIDTH: 0.621534
G1 F12962.014
G1 X161.521 Y27.4 E.00517
M204 S10000
G1 X161.566 Y27.359 F60000
; LINE_WIDTH: 0.635541
G1 F12655.643
M204 S8000
G1 X165.621 Y27.354 E.19786
M204 S10000
G1 X160.8 Y27.668 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X153.699 Y27.668 E.23795
G1 X153.699 Y34.14 E.21685
G1 X158.67 Y34.14 E.16658
G1 X158.67 Y32.657 E.04967
G3 X159.688 Y31.64 I1.067 J.049 E.05291
G1 X160.55 Y31.64 E.02889
G3 X160.67 Y31.39 I.185 J-.065 E.01032
G1 X160.67 Y28.057 E.11167
G1 X160.781 Y27.725 E.01173
M204 S10000
G1 X160.263 Y28.075 F60000
G1 F18424.351
M204 S8000
G1 X154.106 Y28.075 E.20632
G1 X154.106 Y33.733 E.18957
G1 X158.263 Y33.733 E.1393
G3 X158.33 Y32.225 I4.889 J-.538 E.05076
G3 X159.688 Y31.233 I1.381 J.464 E.06008
G1 X160.255 Y31.233 E.01899
G2 X160.263 Y28.135 I-103.105 J-1.836 E.10379
M204 S10000
G1 X159.856 Y28.482 F60000
G1 F18424.351
M204 S8000
G1 X154.513 Y28.482 E.17904
G1 X154.513 Y33.325 E.16229
G1 X157.856 Y33.325 E.11202
G3 X158.176 Y31.623 I2.862 J-.344 E.05897
G3 X159.856 Y30.825 I1.566 J1.131 E.06501
G1 X159.856 Y28.542 E.0765
M204 S10000
G1 X159.449 Y30.462 F60000
G1 F18424.351
M204 S8000
G1 X159.449 Y28.89 E.0527
G1 X154.92 Y28.89 E.15176
G1 X154.92 Y32.918 E.13501
G1 X157.449 Y32.918 E.08474
G3 X159.39 Y30.473 I2.214 J-.236 E.11594
M204 S10000
G1 X159.042 Y30.13 F60000
G1 F18424.351
M204 S8000
G1 X159.042 Y29.297 E.02793
G1 X155.327 Y29.297 E.12448
G1 X155.327 Y32.511 E.10772
G1 X157.065 Y32.511 E.05822
G3 X158.983 Y30.141 I2.516 J.074 E.10977
M204 S10000
G1 X158.601 Y29.804 F60000
G1 F18424.351
M204 S8000
G2 X158.635 Y29.704 I-.056 J-.074 E.00377
G1 X155.734 Y29.704 E.0972
G1 X155.734 Y32.104 E.08044
G1 X156.721 Y32.104 E.03305
G1 X156.779 Y31.732 E.01264
G3 X158.548 Y29.831 I2.888 J.915 E.08992
M204 S10000
G1 X157.363 Y30.111 F60000
G1 F18424.351
M204 S8000
G1 X156.141 Y30.111 E.04094
G1 X156.141 Y31.697 E.05316
G1 X156.377 Y31.697 E.00789
G1 X156.391 Y31.608 E.00302
G3 X157.317 Y30.149 I3.667 J1.302 E.05841
M204 S10000
G1 X156.542 Y30.451 F60000
; LINE_WIDTH: 0.39304
G1 F21000
M204 S8000
G1 X156.476 Y30.489 E.00218
G1 X156.528 Y30.519 E.00172
M204 S10000
G1 X161.484 Y31.74 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X161.484 Y28.057 E.1234
G3 X161.688 Y27.854 I.204 J0 E.01071
G1 X165.681 Y27.854 E.13382
G3 X165.885 Y28.057 I0 J.204 E.01071
G1 X165.885 Y32.051 E.13382
G3 X165.681 Y32.254 I-.204 J0 E.01071
G1 X164.088 Y32.254 E.05338
G3 X164.06 Y32.868 I-1.135 J.255 E.02085
G1 X163.885 Y32.968 E.00675
G1 X163.885 Y34.954 E.06654
G1 X168.984 Y34.954 E.17088
G1 X168.984 Y26.854 E.27141
G1 X152.885 Y26.854 E.53949
G1 X152.885 Y34.954 E.27141
G1 X159.484 Y34.954 E.22115
G1 X159.484 Y32.657 E.07695
G3 X159.688 Y32.454 I.204 J0 E.01071
G1 X161.281 Y32.454 E.05338
G3 X161.309 Y31.84 I1.135 J-.255 E.02085
G1 X161.432 Y31.77 E.00474
; WIPE_START
G1 X161.309 Y31.84 E-.05374
G1 X161.281 Y32.454 E-.23362
G1 X161.037 Y32.454 E-.09265
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.313 J1.176 P1  F60000
G1 X177.185 Y28.154 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.609802
G1 F13230.268
M204 S8000
G2 X177.194 Y29.352 I13.792 J.498 E.05593
M204 S10000
G1 X177.51 Y31.26 F60000
; LINE_WIDTH: 0.4427
G1 F18760.319
M204 S8000
G1 X177.51 Y30.608 E.02148
M204 S10000
G1 X177.185 Y32.657 F60000
; LINE_WIDTH: 0.588144
G1 F13755.822
M204 S8000
G1 X177.241 Y32.5 E.00748
; LINE_WIDTH: 0.548672
G1 F14829.424
G1 X177.297 Y32.343 E.00694
; LINE_WIDTH: 0.509199
G1 F16084.8
G1 X177.354 Y32.186 E.0064
; LINE_WIDTH: 0.451139
G1 F18372.514
G3 X177.913 Y31.516 I1.007 J.272 E.03026
G1 X177.913 Y30.292 E.04115
G1 X177.77 Y30.239 E.00512
G1 X177.41 Y29.779 E.01965
; LINE_WIDTH: 0.472577
G1 F17455.815
G1 X177.356 Y29.687 E.00375
; LINE_WIDTH: 0.517749
G1 F15795.167
G1 X177.303 Y29.596 E.00414
; LINE_WIDTH: 0.562922
G1 F14423.043
G1 X177.25 Y29.504 E.00454
; LINE_WIDTH: 0.608094
G1 F13270.256
G1 X177.196 Y29.412 E.00493
G1 X177.174 Y29.522 E.00519
; LINE_WIDTH: 0.562922
G1 F14423.043
G1 X177.151 Y29.631 E.00477
; LINE_WIDTH: 0.517749
G1 F15795.167
G1 X177.129 Y29.74 E.00436
; LINE_WIDTH: 0.451124
G1 F18373.176
G1 X177.106 Y31.959 E.07456
; LINE_WIDTH: 0.469727
G1 F17572.376
G1 X177.124 Y32.118 E.00565
; LINE_WIDTH: 0.509199
G1 F16084.8
G1 X177.142 Y32.278 E.00617
; LINE_WIDTH: 0.548672
G1 F14829.424
G1 X177.16 Y32.438 E.00669
; LINE_WIDTH: 0.588144
G1 F13755.822
G1 X177.178 Y32.598 E.00721
M204 S10000
G1 X177.185 Y33.654 F60000
; LINE_WIDTH: 0.60788
G1 F13275.277
M204 S8000
G1 X177.185 Y32.717 E.04354
M204 S10000
G1 X176.699 Y34.14 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X177.671 Y34.14 E.03257
G1 X177.671 Y32.657 E.04967
G3 X178.32 Y31.774 I.926 J.001 E.03929
G1 X178.32 Y30.034 E.05834
G3 X177.671 Y29.151 I.277 J-.884 E.03929
G1 X177.671 Y27.668 E.04967
G1 X176.699 Y27.668 E.03257
G1 X176.699 Y34.08 E.21484
M204 S10000
G1 X176.292 Y34.547 F60000
G1 F18424.351
M204 S8000
G1 X178.078 Y34.547 E.05985
G1 X178.078 Y32.657 E.06331
G3 X178.727 Y32.008 I.707 J.058 E.03345
G1 X178.727 Y29.761 E.0753
G1 X178.295 Y29.617 E.01527
G3 X178.078 Y29.151 I.394 J-.467 E.0178
G1 X178.078 Y27.261 E.06331
G1 X176.292 Y27.261 E.05985
G1 X176.292 Y34.487 E.24212
M204 S10000
G1 X175.885 Y34.954 F60000
G1 F18424.351
M204 S8000
G1 X178.485 Y34.954 E.08714
G1 X178.485 Y32.657 E.07695
G3 X178.689 Y32.454 I.203 J0 E.01071
G1 X179.134 Y32.454 E.01493
G1 X179.134 Y29.354 E.10386
G3 X178.557 Y29.306 I-.223 J-.813 E.0198
G1 X178.485 Y29.151 E.00575
G1 X178.485 Y26.854 E.07695
G1 X175.885 Y26.854 E.08714
G1 X175.885 Y34.894 E.2694
; WIPE_START
G1 X175.885 Y33.894 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-.205 J1.2 P1  F60000
G1 X182.935 Y35.098 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43093
G1 F15000
M204 S8000
G1 X182.935 Y32.598 E.07985
M204 S10000
G1 X182.941 Y30.026 F60000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F12000
M204 S8000
G1 X182.941 Y29.602 E.01318
G1 X182.415 Y29.572 E.01633
G1 X182.313 Y29.398 E.00628
G1 X179.526 Y29.398 E.08649
G1 X179.526 Y32.41 E.09348
G1 X182.327 Y32.41 E.08695
G1 X182.415 Y32.236 E.00606
G1 X182.941 Y32.206 E.01633
G1 X182.941 Y30.086 E.06581
M204 S10000
G1 X182.563 Y30.026 F60000
G1 F12000
M204 S8000
G1 X182.563 Y29.979 E.00147
G1 X182.214 Y29.891 E.01119
G1 X182.15 Y29.775 E.00411
G1 X179.903 Y29.775 E.06974
G1 X179.903 Y32.033 E.07008
G1 X182.15 Y32.033 E.06974
G1 X182.214 Y31.917 E.00411
G1 X182.563 Y31.829 E.01119
G1 X182.563 Y30.086 E.05411
M204 S10000
G1 X182.186 Y30.26 F60000
; Slow Down Start
G1 F3000;_EXTRUDE_SET_SPEED
M204 S8000
G1 X182.186 Y31.548 E.03996
G1 X182.012 Y31.598 E.00562
G1 X181.981 Y31.656 E.00205
G1 X180.28 Y31.656 E.05278
G1 X180.28 Y30.152 E.04667
G1 X181.981 Y30.152 E.05278
G1 X182.012 Y30.21 E.00205
G1 X182.129 Y30.244 E.00376
; Slow Down End
M204 S10000
G1 X181.809 Y30.529 F60000
; Slow Down Start
G1 F3000;_EXTRUDE_SET_SPEED
M204 S8000
G1 X181.809 Y31.279 E.02326
G1 X180.657 Y31.279 E.03576
G1 X180.657 Y30.529 E.02326
G1 X181.749 Y30.529 E.03389
; Slow Down End
M204 S10000
G1 X181.435 Y30.904 F60000
; LINE_WIDTH: 0.41518
G1 F12000
M204 S8000
G1 X181.092 Y30.904 E.0105
M204 S10000
G1 X182.935 Y29.209 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43093
G1 F15000
M204 S8000
G1 X182.935 Y26.71 E.07985
; WIPE_START
G1 X182.935 Y27.71 E-.38
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
    

    

    
        M9711 M0 E0 U252 V34 Z1.4 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

M204 S10000
G1 X169.392 Y89.877
G1 Z1
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X169.892 Y90.877  
M204 S8000
G3  X167.433 Y92.922   I-4.377 J-2.762 E0.1236 F5400
G3  X164.774 Y91.666   I0.009 J-3.462 E0.1154
G2  X162.070 Y90.877   I-2.710 J4.259 E0.1085
G2  X150.024 Y90.881   I-5.928 J318.375 E0.4578
G2  X146.077 Y92.763   I0.501 J6.129 E0.1699
G3  X143.766 Y92.330   I-0.852 J-1.839 E0.0953
G3  X140.704 Y89.059   I16.406 J-18.427 E0.1705
G3  X141.538 Y86.104   I2.026 J-1.023 E0.1282
G2  X142.392 Y82.377   I-4.001 J-2.879 E0.1492
G1 E-0.4000 F1800
M204 S10000
G1  Y79.877  F600
G1 E0.4000 F1800
M204 S8000
G2  X142.378 Y71.843   I-85.040 J-3.871 E0.3055 F5400
G2  X141.284 Y69.349   I-4.175 J0.344 E0.1054
G1 E-0.4000 F1800
M204 S10000
G1  X140.479 Y67.153   F600
G1 E0.4000 F1800
M204 S8000
G3  X140.881 Y66.475   I1.906 J0.672 E0.0302 F5400
G3  X143.999 Y63.213   I19.448 J15.469 E0.1717
G3  X147.197 Y63.871   I1.278 J1.891 E0.1383
G2  X150.214 Y64.877   I3.023 J-4.037 E0.1230
G1  X156.142  E0.2253
G1  X157.392  E0.0475
G2  X163.016 Y64.787   I2.339 J-29.659 E0.2141
G2  X166.351 Y62.929   I-2.882 J-9.098 E0.1461
G3  X168.518 Y63.424   I0.711 J1.877 E0.0895
G3  X171.580 Y66.695   I-16.399 J18.421 E0.1705
G3  X170.746 Y69.650   I-2.026 J1.023 E0.1282
G2  X169.892 Y72.183   I3.390 J2.554 E0.1033
G2  X169.895 Y83.741   I283.960 J5.694 E0.4393
G2  X171.738 Y87.306   I6.625 J-1.166 E0.1549
G3  X171.403 Y89.279   I-1.652 J0.734 E0.0806
G1  X169.892 Y90.877   E0.0836
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
G3 Z1.4 I1.217 J0 P1  F60000
G1 X143.142 Y65.627
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
G1  X169.142 Y65.627  E2.0691 F7836
G1  Y67.127  E0.1194
G1  X143.142  E2.0691
M632 S2 M N
M204 S10000
G1  Y67.877 
G1  X168.642  F3000
G1  Y66.377 
G1  X143.642 
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


M620 O6
M620 S2A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4 F1200
M632 S1 W
M400
M104 T1 S140 N0 ;Multi extruder pre heating
M633

M400
M106 P1 S0
M106 P2 S0




    M620.14 X140.892 Y68.3773



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
M73 E8

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
M73 P52 R11
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
M620 O6
M1002 gcode_claim_action : 0
M106 S255
M106 P2 S191

; filament start gcode
G1 X142.892 Y68.377 F60000
G1 Z1
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X145.892 Y68.377  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X141.392  F600
G1  X142.892  F240
G1  X143.392  F600
G1  Y68.877 
G1  X142.392 
M73 P52 R10
G1  Y67.877 
G1  X143.892 
G1  Y69.377 
G1  X141.892 
G1  Y67.377 
G1  X145.892 Y68.377   F1782
G1 E0.4000 F1800
M400
M104 T0 S230 N0
M204 S8000
G1  X169.392  E0.8931 F1782
G1  Y69.127  E0.0285
G1  X142.892  E1.0072 F2025
G1  Y69.877  E0.0285
G1  X169.392  E1.0072 F2473
G1  Y70.627  E0.0285
G1  X142.892  E1.0072 F4725
G1  Y71.377  E0.0285
G1  X169.392  E1.0072 F4775
G1  Y72.127  E0.0285
G1  X142.892  E1.0072
G1  Y72.877  E0.0285
G1  X169.392  E1.0072
G1  Y73.627  E0.0285
G1  X142.892  E1.0072
G1  Y74.377  E0.0285
G1  X169.392  E1.0072
G1  Y75.127  E0.0285
G1  X142.892  E1.0072
G1  Y75.877  E0.0285
G1  X169.392  E1.0072
G1  Y76.627  E0.0285
G1  X142.892  E1.0072
G1  Y77.377  E0.0285
G1  X169.392  E1.0072
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
G1 X168.392 Y77.377 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.217 J0 P1  F60000
; OBJECT_ID: 423
; COOLING_NODE: 0
M204 S10000
G1 X174.333 Y30.904
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X174.333 Y35.302 E.14887
G1 X170.537 Y35.302 E.12849
G1 X170.537 Y26.506 E.29773
G1 X174.333 Y26.506 E.12849
G1 X174.333 Y30.844 E.14683
; COOLING_NODE: 0
M204 S250
G1 X174.725 Y30.904 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X174.725 Y35.694 E.15019
G1 X170.145 Y35.694 E.1436
G1 X170.145 Y26.114 E.30037
G1 X174.725 Y26.114 E.1436
G1 X174.725 Y30.844 E.14831
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X174.725 Y31.844 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.049 J-1.216 P1  F60000
G1 X151.333 Y30.904 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X151.333 Y35.302 E.14887
G1 X147.537 Y35.302 E.12849
G1 X147.537 Y26.506 E.29773
G1 X151.333 Y26.506 E.12849
G1 X151.333 Y30.844 E.14683
; COOLING_NODE: 0
M204 S250
G1 X151.725 Y30.904 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X151.725 Y35.694 E.15019
G1 X147.145 Y35.694 E.1436
G1 X147.145 Y26.114 E.30037
G1 X151.725 Y26.114 E.1436
G1 X151.725 Y30.844 E.14831
; WIPE_START
M204 S8000
G1 X151.725 Y31.844 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.187 J-.27 P1  F60000
G1 X150.941 Y28.404 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F12000
M204 S8000
G1 X150.941 Y26.898 E.04721
G1 X147.929 Y26.898 E.09443
G1 X147.929 Y34.91 E.2512
G1 X150.941 Y34.91 E.09443
G1 X150.941 Y28.464 E.2021
M204 S10000
G1 X150.563 Y28.404 F60000
G1 F12000
M204 S8000
G1 X150.563 Y27.275 E.03539
G1 X148.306 Y27.275 E.07078
G1 X148.306 Y34.533 E.22755
G1 X150.563 Y34.533 E.07078
G1 X150.563 Y28.464 E.19028
M204 S10000
M73 P53 R10
G1 X150.186 Y28.404 F60000
G1 F12000
M204 S8000
G1 X150.186 Y27.652 E.02357
G1 X148.683 Y27.652 E.04714
G1 X148.683 Y34.156 E.20391
G1 X150.186 Y34.156 E.04714
G1 X150.186 Y28.464 E.17846
M204 S10000
G1 X149.809 Y28.404 F60000
G1 F12000
M204 S8000
G1 X149.809 Y28.029 E.01175
G1 X149.06 Y28.029 E.02349
G1 X149.06 Y33.779 E.18026
G1 X149.809 Y33.779 E.02349
G1 X149.809 Y28.464 E.16663
M204 S10000
G1 X149.435 Y33.404 F60000
; LINE_WIDTH: 0.41518
G1 F12000
M204 S8000
G1 X149.435 Y28.464 E.15291
; WIPE_START
G1 X149.435 Y29.464 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.053 J1.216 P1  F60000
G1 X173.941 Y28.404 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.41999
G1 F12000
M204 S8000
G1 X173.941 Y26.898 E.04721
G1 X170.929 Y26.898 E.09443
G1 X170.929 Y34.91 E.2512
G1 X173.941 Y34.91 E.09443
G1 X173.941 Y28.464 E.2021
M204 S10000
G1 X173.563 Y28.404 F60000
G1 F12000
M204 S8000
G1 X173.563 Y27.275 E.03539
G1 X171.306 Y27.275 E.07078
G1 X171.306 Y34.533 E.22755
G1 X173.563 Y34.533 E.07078
G1 X173.563 Y28.464 E.19028
M204 S10000
G1 X173.186 Y28.404 F60000
G1 F12000
M204 S8000
G1 X173.186 Y27.652 E.02357
G1 X171.683 Y27.652 E.04714
G1 X171.683 Y34.156 E.20391
G1 X173.186 Y34.156 E.04714
G1 X173.186 Y28.464 E.17846
M204 S10000
G1 X172.809 Y28.404 F60000
G1 F12000
M204 S8000
G1 X172.809 Y28.029 E.01175
G1 X172.06 Y28.029 E.02349
G1 X172.06 Y33.779 E.18026
G1 X172.809 Y33.779 E.02349
G1 X172.809 Y28.464 E.16663
M204 S10000
G1 X172.435 Y33.404 F60000
; LINE_WIDTH: 0.41516
G1 F12000
M204 S8000
G1 X172.435 Y28.464 E.1529
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
M204 S8000
G1 X172.435 Y29.464 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.217 J0 P1  F60000
G1 X143.142 Y78.377
G1 Z1
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF2 NF1 ON1 NN0
M204 S8000
G1  X169.142 Y78.377  E2.0691 F6583
G1  Y79.877  E0.1194
G1  X143.142  E2.0691
; NOZZLE_CHANGE_END OF2 NF1 ON1 NN0
M400
M104 T0 S25 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S8000
G1 X144.142 Y79.877 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S10000
G17
G3 Z1.4 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O7
M620 S1A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X140.892 Y81.1273



M620.10 A0 F419.075 L0 H0.4 T240 P230 S1



M620.10 A1 F498.898 L0 H0.4 T180 P150 S1



M620.11 P1 I2 B-1 E-14 F523.843



M620.15 P180
M620.15 C140
M620.11 O1 T18


M620.11 K1 I2 B-1 R10 F523.843


M620.15 C140

M628 S1


M620.11 S1 L0 I2 B-1 R10 D8 E-14 F523.843


M629


;M620.11 H0




T1 H-1
M73 E7

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

;VM109 S150

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F10.4167 A0.4 R2


M400

G387 Y320 J1 F10000
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4 F3000

M204 S8000


M621 S1A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y320 J1 F10000
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4 F3000

M204 S8000

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I1 H-1 W1 ;enable ams air printing detect
M620 O7
M1002 gcode_claim_action : 0
M106 S66.3
M106 P2 S102
G1 X141.135 Y94.956 F600
M204 S1000
G1 Z1
G1 X138.39 Y94.956
G17
G3 Z1.4 I1.217 J0 P1
G1 X138.39 Y81.127 Z1.4

; filament start gcode
M109 S145;
G1 X142.892 Y81.127
G1 Z1
M73 P54 R10
G1 E2.2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S25
G1  X145.892 Y81.127  E0.1140 F1782
G1 E-0.4000 F1800
M204 S1000
G1  X141.392  F600
G1  X142.892  F240
G1  X143.392  F600
G1  Y81.627 
G1  X142.392 
G1  Y80.627 
G1  X143.892 
G1  Y82.127 
G1  X141.892 
G1  Y80.127 
G1  X145.892 Y81.127   F1782
G1 E0.4000 F1800
M400
M104 T1 S150 N0
M204 S25
G1  X169.392  E0.8931 F1782
G1  Y81.877  E0.0285
G1  X142.892  E1.0072 F2025
G1  Y82.627  E0.0285
G1  X169.392  E1.0072 F2473
G1  Y83.377  E0.0285
G1  X142.892  E1.0072 F4725
G1  Y84.127  E0.0285
G1  X169.392  E1.0072 F4775
G1  Y84.877  E0.0285
G1  X142.892  E1.0072
G1  Y85.627  E0.0285
G1  X169.392  E1.0072
G1  Y86.377  E0.0285
G1  X142.892  E1.0072
G1  Y87.127  E0.0285
M73 P55 R10
G1  X169.392  E1.0072
G1  Y87.877  E0.0285
G1  X142.892  E1.0072
G1  Y88.627  E0.0285
G1  X169.392  E1.0072
G1  Y89.377  E0.0285
G1  X142.892  E1.0072
G1  Y90.127  E0.0285
G1  X169.392  E1.0072
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
G1 X168.392 Y90.127 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I1.217 J0 P1  F600
; OBJECT_ID: 423
; COOLING_NODE: 0
M204 S1000
G1 X140.037 Y30.706
G1 Z1
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
M73 P56 R10
G1 X141.303 Y30.706 E.04242
G1 X141.303 Y32.002 E.04343
G1 X140.037 Y32.002 E.04242
G1 X140.037 Y30.766 E.04141
; COOLING_NODE: 0
G1 X139.645 Y30.314
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X141.695 Y30.314 E.06363
G1 X141.695 Y32.394 E.06457
G1 X139.645 Y32.394 E.06363
G1 X139.645 Y30.374 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X140.644 Y30.345 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I-.215 J1.198 P1  F600
G1 X161.037 Y34.006 Z1.4
G1 Z1
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X162.303 Y34.006 E.04242
G1 X162.303 Y35.302 E.04343
G1 X161.037 Y35.302 E.04242
G1 X161.037 Y34.066 E.04141
; COOLING_NODE: 0
M73 P56 R9
G1 X160.645 Y33.614
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X162.695 Y33.614 E.06363
G1 X162.695 Y35.694 E.06457
G1 X160.645 Y35.694 E.06363
G1 X160.645 Y33.674 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X161.644 Y33.645 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I1.1 J.521 P1  F600
G1 X163.037 Y30.702 Z1.4
G1 Z1
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X163.037 Y29.406 E.04343
G1 X164.303 Y29.406 E.04242
G1 X164.303 Y30.702 E.04343
G1 X163.097 Y30.702 E.04041
; COOLING_NODE: 0
G1 X162.645 Y31.094
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X162.645 Y29.014 E.06457
G1 X164.695 Y29.014 E.06363
G1 X164.695 Y31.094 E.06457
G1 X162.705 Y31.094 E.06177
; COOLING_NODE: 0
; WIPE_START
G1 X162.676 Y30.094 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I.159 J1.206 P1  F600
G1 X180.038 Y27.802 Z1.4
G1 Z1
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P57 R9
G1 F600
M204 S25
G1 X180.038 Y26.506 E.04343
G1 X181.303 Y26.506 E.04242
G1 X181.303 Y27.802 E.04343
G1 X180.098 Y27.802 E.04041
; COOLING_NODE: 0
G1 X179.645 Y28.194
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X179.645 Y26.114 E.06457
G1 X181.695 Y26.114 E.06363
G1 X181.695 Y28.194 E.06457
G1 X179.705 Y28.194 E.06177
; COOLING_NODE: 0
; WIPE_START
G1 X179.677 Y27.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I-1.215 J.064 P1  F600
G1 X180.038 Y34.006 Z1.4
G1 Z1
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X181.303 Y34.006 E.04242
G1 X181.303 Y35.302 E.04343
G1 X180.038 Y35.302 E.04242
G1 X180.038 Y34.066 E.04141
; COOLING_NODE: 0
G1 X179.645 Y33.614
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X181.695 Y33.614 E.06363
G1 X181.695 Y35.694 E.06457
G1 X179.645 Y35.694 E.06363
G1 X179.645 Y33.674 E.0627
M204 S1000
G1 X180.456 Y34.424
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47232
M204 S25
G1 X180.456 Y34.884 E.01624
G1 X180.885 Y34.884 E.01518
G1 X180.885 Y34.424 E.01624
G1 X180.516 Y34.424 E.01306
; WIPE_START
G1 X180.885 Y34.424 E-.14037
G1 X180.885 Y34.884 E-.17458
G1 X180.714 Y34.884 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I1.216 J-.042 P1  F600
G1 X180.456 Y27.384 Z1.4
G1 Z1
G1 E.6 F1800
G1 F600
M204 S25
G1 X180.885 Y27.384 E.01518
G1 X180.885 Y26.924 E.01624
G1 X180.456 Y26.924 E.01518
G1 X180.456 Y27.324 E.01412
; WIPE_START
G1 X180.456 Y26.924 E-.15178
G1 X180.885 Y26.924 E-.16317
G1 X180.885 Y27.095 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I-.219 J-1.197 P1  F600
G1 X163.455 Y30.284 Z1.4
G1 Z1
G1 E.6 F1800
; LINE_WIDTH: 0.47233
G1 F600
M204 S25
G1 X163.884 Y30.284 E.01518
G1 X163.884 Y29.824 E.01624
G1 X163.455 Y29.824 E.01518
G1 X163.455 Y30.224 E.01412
; WIPE_START
G1 X163.455 Y29.824 E-.15178
G1 X163.884 Y29.824 E-.16318
G1 X163.884 Y29.995 E-.06504
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I-1.067 J-.585 P1  F600
G1 X161.455 Y34.424 Z1.4
G1 Z1
G1 E.6 F1800
G1 F600
M204 S25
G1 X161.455 Y34.884 E.01624
G1 X161.884 Y34.884 E.01518
G1 X161.884 Y34.424 E.01624
G1 X161.515 Y34.424 E.01306
; WIPE_START
G1 X161.884 Y34.424 E-.14038
G1 X161.884 Y34.884 E-.17458
G1 X161.713 Y34.884 E-.06504
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.4 I.216 J-1.198 P1  F600
G1 X140.884 Y31.124 Z1.4
G1 Z1
G1 E.6 F1800
M73 P58 R9
G1 F600
M204 S25
G1 X140.455 Y31.124 E.01518
G1 X140.455 Y31.584 E.01624
G1 X140.884 Y31.584 E.01518
G1 X140.884 Y31.184 E.01412
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 6/12
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
M106 S71.4
; OBJECT_ID: 423
; COOLING_NODE: 0
M204 S1000
G1 X140.037 Y30.706 Z1.2 F600
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
M204 S25
G1 X141.303 Y30.706 E.04242
G1 X141.303 Y32.002 E.04343
G1 X140.037 Y32.002 E.04242
G1 X140.037 Y30.766 E.04141
; COOLING_NODE: 0
G1 X139.645 Y30.314
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X141.695 Y30.314 E.06363
G1 X141.695 Y32.394 E.06457
G1 X139.645 Y32.394 E.06363
G1 X139.645 Y30.374 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X140.644 Y30.345 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I-.215 J1.198 P1  F600
G1 X161.037 Y34.006 Z1.6
G1 Z1.2
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X162.303 Y34.006 E.04242
G1 X162.303 Y35.302 E.04343
G1 X161.037 Y35.302 E.04242
G1 X161.037 Y34.066 E.04141
; COOLING_NODE: 0
G1 X160.645 Y33.614
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X162.695 Y33.614 E.06363
G1 X162.695 Y35.694 E.06457
G1 X160.645 Y35.694 E.06363
G1 X160.645 Y33.674 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X161.644 Y33.645 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I1.1 J.521 P1  F600
G1 X163.037 Y30.702 Z1.6
G1 Z1.2
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X163.037 Y29.406 E.04343
G1 X164.303 Y29.406 E.04242
G1 X164.303 Y30.702 E.04343
G1 X163.097 Y30.702 E.04041
; COOLING_NODE: 0
G1 X162.645 Y31.094
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X162.645 Y29.014 E.06457
G1 X164.695 Y29.014 E.06363
G1 X164.695 Y31.094 E.06457
G1 X162.705 Y31.094 E.06177
; COOLING_NODE: 0
; WIPE_START
G1 X162.676 Y30.094 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I.159 J1.206 P1  F600
G1 X180.038 Y27.802 Z1.6
G1 Z1.2
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
M73 P59 R9
G1 X180.038 Y26.506 E.04343
G1 X181.303 Y26.506 E.04242
G1 X181.303 Y27.802 E.04343
G1 X180.098 Y27.802 E.04041
; COOLING_NODE: 0
G1 X179.645 Y28.194
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X179.645 Y26.114 E.06457
G1 X181.695 Y26.114 E.06363
G1 X181.695 Y28.194 E.06457
G1 X179.705 Y28.194 E.06177
; COOLING_NODE: 0
; WIPE_START
G1 X179.677 Y27.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I-1.215 J.064 P1  F600
G1 X180.038 Y34.006 Z1.6
G1 Z1.2
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X181.303 Y34.006 E.04242
G1 X181.303 Y35.302 E.04343
G1 X180.038 Y35.302 E.04242
G1 X180.038 Y34.066 E.04141
; COOLING_NODE: 0
G1 X179.645 Y33.614
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X181.695 Y33.614 E.06363
G1 X181.695 Y35.694 E.06457
G1 X179.645 Y35.694 E.06363
G1 X179.645 Y33.674 E.0627
M204 S1000
G1 X180.456 Y34.424
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47232
M204 S25
G1 X180.456 Y34.884 E.01624
G1 X180.885 Y34.884 E.01518
G1 X180.885 Y34.424 E.01624
G1 X180.516 Y34.424 E.01306
; WIPE_START
G1 X180.885 Y34.424 E-.14037
G1 X180.885 Y34.884 E-.17458
G1 X180.714 Y34.884 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I1.216 J-.042 P1  F600
M632 S2 N R W
M400
M104 T0 S220 N0 ;Multi extruder pre heating
M633
G1 X180.456 Y27.384 Z1.6
G1 Z1.2
G1 E.6 F1800
G1 F600
M204 S25
G1 X180.885 Y27.384 E.01518
G1 X180.885 Y26.924 E.01624
G1 X180.456 Y26.924 E.01518
G1 X180.456 Y27.324 E.01412
; WIPE_START
G1 X180.456 Y26.924 E-.15178
G1 X180.885 Y26.924 E-.16317
G1 X180.885 Y27.095 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I-.219 J-1.197 P1  F600
G1 X163.455 Y30.284 Z1.6
G1 Z1.2
G1 E.6 F1800
; LINE_WIDTH: 0.47233
G1 F600
M204 S25
G1 X163.884 Y30.284 E.01518
G1 X163.884 Y29.824 E.01624
G1 X163.455 Y29.824 E.01518
G1 X163.455 Y30.224 E.01412
; WIPE_START
G1 X163.455 Y29.824 E-.15178
G1 X163.884 Y29.824 E-.16318
G1 X163.884 Y29.995 E-.06504
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I-1.067 J-.585 P1  F600
G1 X161.455 Y34.424 Z1.6
G1 Z1.2
G1 E.6 F1800
G1 F600
M204 S25
G1 X161.455 Y34.884 E.01624
G1 X161.884 Y34.884 E.01518
G1 X161.884 Y34.424 E.01624
G1 X161.515 Y34.424 E.01306
; WIPE_START
G1 X161.884 Y34.424 E-.14038
G1 X161.884 Y34.884 E-.17458
G1 X161.713 Y34.884 E-.06504
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I.216 J-1.198 P1  F600
G1 X140.884 Y31.124 Z1.6
G1 Z1.2
G1 E.6 F1800
G1 F600
M204 S25
M73 P60 R9
G1 X140.455 Y31.124 E.01518
G1 X140.455 Y31.584 E.01624
G1 X140.884 Y31.584 E.01518
G1 X140.884 Y31.184 E.01412
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
; WIPE_START
M204 S25
G1 X140.884 Y31.584 E-.15178
G1 X140.455 Y31.584 E-.16318
G1 X140.455 Y31.412 E-.06504
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.6 I1.217 J0 P1  F600
G1 X143.142 Y65.627
G1 Z1.2
G1 E.6 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF1 NF2 ON0 NN1
M204 S25
G1  X169.142 Y65.627  E2.0691 F7836
; NOZZLE_CHANGE_END OF1 NF2 ON0 NN1
M400
M104 T1 S25 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S25
G1 X168.142 Y65.627 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S1000
G17
G3 Z1.6 I1.217 J0 P1  F5400
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

G1 Z4.2 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X171.392 Y75.8773



M620.10 A0 F498.898 L0 H0.4 T180 P150 S1



M620.10 A1 F419.075 L0 H0.4 T240 P230 S1



M620.11 P1 I1 B-1 E-14 F623.623



M620.15 P180
M620.15 C220
M620.11 O1 T18


M620.11 K1 I1 B-1 R10 F623.623


M620.15 C220

M628 S1


M620.11 S1 L0 I1 B-1 R10 D8 E-14 F623.623


M629


;M620.11 H0




T2 H-1
M73 E6

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

G387 Y320 J1 F10000
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.2 F3000

M204 S25


M621 S2A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F8.75 A0.4 R2
M400

G387 Y320 J1 F10000
M73 P61 R8
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.2 F3000

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
G1 X173.895 Y75.877 F60000
M204 S10000
G1 Z1.2

; filament start gcode
G17
G3 Z1.6 I0 J-1.217 P1
G1 X169.392 Y75.877 Z1.6
G1 Z1.2
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X166.392 Y75.877  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X170.892  F600
G1  X169.392  F240
G1  X169.892  F600
G1  Y76.377 
G1  X168.892 
G1  Y75.377 
G1  X170.392 
G1  Y76.877 
G1  X168.392 
G1  Y74.877 
G1  X166.392 Y75.877   F1782
G1 E0.4000 F1800
M400
M104 T0 S230 N0
M204 S8000
G1  X142.892  E0.8931 F1782
G1  Y75.127  E0.0285
G1  X169.392  E1.0072 F2025
G1  Y74.377  E0.0285
G1  X142.892  E1.0072 F2473
G1  Y73.627  E0.0285
G1  X169.392  E1.0072 F4725
G1  Y72.877  E0.0285
G1  X142.892  E1.0072 F4775
G1  Y72.127  E0.0285
G1  X169.392  E1.0072
G1  Y71.377  E0.0285
G1  X142.892  E1.0072
G1  Y70.627  E0.0285
G1  X169.392  E1.0072
G1  Y69.877  E0.0285
G1  X142.892  E1.0072
G1  Y69.127  E0.0285
G1  X169.392  E1.0072
G1  Y68.377  E0.0285
G1  X142.892  E1.0072
G1  Y67.627  E0.0285
G1  X169.392  E1.0072
G1  Y66.877  E0.0285
G1  X142.892  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------



; WIPE_START
G1 F5400
M204 S8000
G1 X143.892 Y66.877 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.217 J0 P1  F60000
; OBJECT_ID: 423
; COOLING_NODE: 0
M204 S10000
G1 X177.333 Y30.904
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X177.333 Y35.302 E.14887
G1 X167.537 Y35.302 E.33158
G1 X167.537 Y26.506 E.29773
G1 X177.333 Y26.506 E.33158
G1 X177.333 Y30.844 E.14683
; COOLING_NODE: 0
M204 S250
G1 X177.725 Y30.904 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X177.725 Y35.694 E.15019
G1 X167.145 Y35.694 E.33173
G1 X167.145 Y26.114 E.30037
G1 X177.725 Y26.114 E.33173
G1 X177.725 Y30.844 E.14831
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X177.725 Y31.844 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I.034 J-1.216 P1  F60000
G1 X144.537 Y30.904 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X144.537 Y26.506 E.14887
G1 X154.333 Y26.506 E.33158
G1 X154.333 Y35.302 E.29773
G1 X144.537 Y35.302 E.33158
G1 X144.537 Y30.964 E.14683
; COOLING_NODE: 0
M204 S250
G1 X144.145 Y30.904 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X144.145 Y26.114 E.15019
G1 X154.725 Y26.114 E.33173
G1 X154.725 Y35.694 E.30037
G1 X144.145 Y35.694 E.33173
G1 X144.145 Y30.964 E.14831
; WIPE_START
M204 S8000
G1 X144.145 Y29.964 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-1.078 J.565 P1  F60000
G1 X146.116 Y33.723 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.46902
G1 F14785.261
M204 S8000
G1 X146.116 Y28.145 E.19763
M204 S10000
G1 X146.532 Y28.085 F60000
; LINE_WIDTH: 0.44999
G1 F15476.455
M204 S8000
G1 X146.532 Y27.668 E.0141
G1 X145.699 Y27.668 E.0282
G1 X145.699 Y34.14 E.21903
G1 X146.532 Y34.14 E.0282
G1 X146.532 Y28.145 E.2029
M204 S10000
G1 X146.939 Y28.085 F60000
G1 F15476.455
M204 S8000
G1 X146.939 Y27.261 E.02788
G1 X145.292 Y27.261 E.05576
G1 X145.292 Y34.547 E.24659
G1 X146.939 Y34.547 E.05576
G1 X146.939 Y28.145 E.21668
M204 S10000
G1 X147.346 Y28.085 F60000
G1 F15476.455
M204 S8000
G1 X147.346 Y26.854 E.04166
G1 X144.885 Y26.854 E.08332
G1 X144.885 Y34.954 E.27415
G1 X147.346 Y34.954 E.08332
G1 X147.346 Y28.145 E.23046
M204 S10000
G1 X149.623 Y28.594 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41932
G1 F15000
M204 S8000
G1 X149.623 Y28.406 E.00589
G1 X149.246 Y28.406 E.01178
G1 X149.246 Y33.402 E.15636
G1 X149.623 Y33.402 E.01178
G1 X149.623 Y28.654 E.14859
M204 S10000
G1 X150 Y28.594 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X150 Y28.029 E.01771
G1 X148.87 Y28.029 E.03543
G1 X148.87 Y33.779 E.18026
G1 X150 Y33.779 E.03543
G1 X150 Y28.654 E.16067
M204 S10000
G1 X150.377 Y28.594 F60000
G1 F15000
M204 S8000
G1 X150.377 Y27.652 E.02954
G1 X148.493 Y27.652 E.05907
G1 X148.493 Y34.156 E.20391
G1 X150.377 Y34.156 E.05907
G1 X150.377 Y28.654 E.17249
M204 S10000
G1 X150.754 Y28.594 F60000
G1 F15000
M204 S8000
G1 X150.754 Y27.275 E.04136
G1 X148.116 Y27.275 E.08272
G1 X148.116 Y34.533 E.22755
G1 X150.754 Y34.533 E.08272
G1 X150.754 Y28.654 E.18431
M204 S10000
G1 X151.131 Y28.594 F60000
G1 F15000
M204 S8000
G1 X151.131 Y26.898 E.05318
G1 X147.738 Y26.898 E.10636
G1 X147.738 Y34.91 E.2512
G1 X151.131 Y34.91 E.10636
G1 X151.131 Y28.654 E.19614
M204 S10000
G1 X152.754 Y33.723 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.46902
G1 F14785.261
M204 S8000
G1 X152.754 Y28.145 E.19763
M204 S10000
G1 X153.17 Y28.085 F60000
; LINE_WIDTH: 0.44999
G1 F15476.455
M204 S8000
G1 X153.17 Y27.668 E.0141
G1 X152.337 Y27.668 E.0282
G1 X152.337 Y34.14 E.21903
G1 X153.17 Y34.14 E.0282
G1 X153.17 Y28.145 E.2029
M204 S10000
G1 X153.577 Y28.085 F60000
G1 F15476.455
M204 S8000
G1 X153.577 Y27.261 E.02788
G1 X151.93 Y27.261 E.05576
G1 X151.93 Y34.547 E.24659
G1 X153.577 Y34.547 E.05576
M73 P62 R8
G1 X153.577 Y28.145 E.21668
M204 S10000
G1 X153.984 Y28.085 F60000
G1 F15476.455
M204 S8000
G1 X153.984 Y26.854 E.04166
G1 X151.523 Y26.854 E.08332
G1 X151.523 Y34.954 E.27415
G1 X153.984 Y34.954 E.08332
G1 X153.984 Y28.145 E.23046
; WIPE_START
G1 X153.984 Y29.145 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-.384 J1.155 P1  F60000
G1 X168.771 Y34.068 Z1.6
G1 Z1.2
G1 E.4 F1800
; LINE_WIDTH: 0.59307
G1 F11451.423
M204 S8000
G1 X169.321 Y34.068 E.02517
G1 X169.321 Y27.74 E.28948
G1 X168.771 Y27.74 E.02517
G1 X168.771 Y34.008 E.28673
M204 S10000
G1 X168.292 Y34.547 F60000
; LINE_WIDTH: 0.44999
G1 F15476.455
M204 S8000
G1 X169.799 Y34.547 E.05102
G1 X169.799 Y27.261 E.24659
G1 X168.292 Y27.261 E.05102
G1 X168.292 Y34.487 E.24456
M204 S10000
G1 X167.885 Y34.954 F60000
G1 F15476.455
M204 S8000
G1 X170.207 Y34.954 E.07858
G1 X170.207 Y26.854 E.27415
G1 X167.885 Y26.854 E.07858
G1 X167.885 Y34.894 E.27212
M204 S10000
G1 X172.176 Y33.332 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.55924
G1 F12201.736
M204 S8000
G1 X172.693 Y33.332 E.02217
G1 X172.693 Y28.476 E.20848
G1 X172.176 Y28.476 E.02217
G1 X172.176 Y33.272 E.2059
M204 S10000
G1 X171.73 Y33.779 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X173.14 Y33.779 E.0442
G1 X173.14 Y28.029 E.18026
G1 X171.73 Y28.029 E.0442
G1 X171.73 Y33.719 E.17838
M204 S10000
G1 X171.353 Y34.156 F60000
G1 F15000
M204 S8000
G1 X173.517 Y34.156 E.06784
G1 X173.517 Y27.652 E.20391
G1 X171.353 Y27.652 E.06784
G1 X171.353 Y34.096 E.20203
M204 S10000
G1 X170.976 Y34.533 F60000
G1 F15000
M204 S8000
G1 X173.894 Y34.533 E.09149
G1 X173.894 Y27.275 E.22755
G1 X170.976 Y27.275 E.09149
G1 X170.976 Y34.473 E.22567
M204 S10000
G1 X170.599 Y34.91 F60000
G1 F15000
M204 S8000
G1 X174.271 Y34.91 E.11513
G1 X174.271 Y26.898 E.2512
G1 X170.599 Y26.898 E.11513
G1 X170.599 Y34.85 E.24932
M204 S10000
G1 X175.548 Y34.068 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.59308
G1 F11451.214
M204 S8000
G1 X176.099 Y34.068 E.02517
G1 X176.099 Y27.74 E.28948
G1 X175.548 Y27.74 E.02517
G1 X175.548 Y34.008 E.28674
M204 S10000
G1 X175.07 Y34.547 F60000
; LINE_WIDTH: 0.44999
G1 F15476.455
M204 S8000
G1 X176.577 Y34.547 E.05102
G1 X176.577 Y27.261 E.24659
G1 X175.07 Y27.261 E.05102
G1 X175.07 Y34.487 E.24456
M204 S10000
G1 X174.663 Y34.954 F60000
G1 F15476.455
M204 S8000
G1 X176.984 Y34.954 E.07858
G1 X176.984 Y26.854 E.27415
G1 X174.663 Y26.854 E.07858
G1 X174.663 Y34.894 E.27212
; WIPE_START
G1 X174.663 Y33.894 E-.38
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
    

    

    
        M9711 M0 E0 U252 V34 Z1.6 S11 C10 O0 T3000
    

    
    
    
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
G1 X143.142 Y76.877
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
G1  X169.142 Y76.877  E2.0691 F6583
G1  Y78.377  E0.1194
G1  X143.142  E2.0691
M632 S0 M N
M204 S10000
G1  Y79.127 
G1  X168.642  F3000
G1  Y77.627 
G1  X143.642 
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




    M620.14 X171.392 Y88.6273



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
M73 E5

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
M73 P64 R8
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
M106 S173.4
M106 P2 S191

; filament start gcode
G1 X169.392 Y88.627 F60000
G1 Z1.2
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X166.392 Y88.627  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X170.892  F600
G1  X169.392  F240
G1  X169.892  F600
G1  Y89.127 
G1  X168.892 
G1  Y88.127 
G1  X170.392 
G1  Y89.627 
G1  X168.392 
G1  Y87.627 
G1  X166.392 Y88.627   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X142.892  E0.8931 F1782
G1  Y87.877  E0.0285
G1  X169.392  E1.0072 F2025
G1  Y87.127  E0.0285
G1  X142.892  E1.0072 F2473
G1  Y86.377  E0.0285
M73 P65 R8
G1  X169.392  E1.0072 F4725
G1  Y85.627  E0.0285
G1  X142.892  E1.0072 F4775
G1  Y84.877  E0.0285
G1  X169.392  E1.0072
G1  Y84.127  E0.0285
G1  X142.892  E1.0072
G1  Y83.377  E0.0285
G1  X169.392  E1.0072
G1  Y82.627  E0.0285
G1  X142.892  E1.0072
G1  Y81.877  E0.0285
G1  X169.392  E1.0072
G1  Y81.127  E0.0285
G1  X142.892  E1.0072
G1  Y80.377  E0.0285
G1  X169.392  E1.0072
G1  Y79.627  E0.0285
G1  X142.892  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y90.377   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S8000
G1  Y89.377  E0.0380
M73 P65 R7
G1  X169.392  E1.0072
G1  Y90.377  E0.0380
G1  X142.892  E1.0072
; WIPE_TOWER_END
G1  Y89.877
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X140.704 Y89.059  
M204 S8000
G3  X141.538 Y86.104   I2.026 J-1.023 E0.1282
G2  X142.392 Y83.571   I-3.390 J-2.554 E0.1033
G2  X142.389 Y72.013   I-283.960 J-5.694 E0.4393
G2  X140.546 Y68.448   I-6.625 J1.166 E0.1549
G3  X140.881 Y66.475   I1.652 J-0.734 E0.0806
G3  X143.999 Y63.213   I19.448 J15.469 E0.1717
G3  X147.197 Y63.871   I1.278 J1.891 E0.1383
G2  X150.214 Y64.877   I3.023 J-4.037 E0.1230
G1  X156.142  E0.2253
G1  X157.392  E0.0475
G2  X163.016 Y64.787   I2.339 J-29.659 E0.2141
G2  X166.351 Y62.929   I-2.882 J-9.098 E0.1461
G3  X168.518 Y63.424   I0.711 J1.877 E0.0895
G3  X171.580 Y66.695   I-16.399 J18.421 E0.1705
G3  X170.746 Y69.650   I-2.026 J1.023 E0.1282
G2  X169.892 Y72.183   I3.390 J2.554 E0.1033
G1  Y74.627  E0.0929
G1 E-0.4000 F1800
M204 S10000
G1  Y77.127  F600
G1 E0.4000 F1800
M204 S8000
G2  X169.923 Y84.080   I56.938 J3.222 E0.2644 F5400
G2  X171.738 Y87.306   I6.407 J-1.481 E0.1426
G1  X171.777 Y87.403   E0.0039
G1 E-0.4000 F1800
M204 S10000
G1  X171.071 Y89.630   F600
G1 E0.4000 F1800
M204 S8000
G1  X169.892 Y90.877   E0.0652 F5400
G3  X167.433 Y92.922   I-4.377 J-2.762 E0.1236
G3  X164.774 Y91.666   I0.009 J-3.462 E0.1154
G2  X162.070 Y90.877   I-2.710 J4.259 E0.1085
G2  X150.024 Y90.881   I-5.928 J318.375 E0.4578
G2  X146.077 Y92.763   I0.501 J6.129 E0.1699
G3  X143.766 Y92.330   I-0.852 J-1.839 E0.0953
G3  X140.704 Y89.059   I16.406 J-18.427 E0.1705
; WIPE_TOWER_END

; WIPE_START
G1 F15476.455
M204 S8000
G1 X140.789 Y89.173 E-.05374
G1 X140.882 Y89.279 E-.05373
G1 X141.374 Y89.8 E-.27253
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.217 J0 P1  F60000
; OBJECT_ID: 423
; COOLING_NODE: 0
M204 S10000
G1 X178.833 Y32.802
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X178.833 Y35.302 E.08378
G1 X178.537 Y35.302 E.00994
G1 X178.537 Y26.506 E.29475
G1 X178.833 Y26.506 E.00994
G1 X178.833 Y29.006 E.08378
G1 X182.538 Y29.006 E.12413
G1 X182.538 Y26.506 E.08378
G1 X183.333 Y26.506 E.02664
G1 X183.333 Y35.302 E.29475
G1 X182.538 Y35.302 E.02664
G1 X182.538 Y32.802 E.08378
G1 X178.893 Y32.802 E.12212
; COOLING_NODE: 0
M204 S250
G1 X179.225 Y33.194 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X179.225 Y35.694 E.0776
G1 X178.145 Y35.694 E.03355
G1 X178.145 Y26.114 E.29737
G1 X179.225 Y26.114 E.03355
G1 X179.225 Y28.614 E.0776
G1 X182.145 Y28.614 E.09064
G1 X182.145 Y26.114 E.0776
G1 X183.725 Y26.114 E.04902
G1 X183.725 Y35.694 E.29737
G1 X182.145 Y35.694 E.04902
G1 X182.145 Y33.194 E.0776
G1 X179.285 Y33.194 E.08878
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X179.261 Y34.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I.185 J-1.203 P1  F60000
G1 X161.833 Y31.514 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X161.833 Y28.202 E.11099
G1 X165.537 Y28.202 E.12413
G1 X165.537 Y31.906 E.12413
G1 X161.833 Y31.906 E.12413
G1 X161.833 Y31.574 E.01113
; COOLING_NODE: 0
M204 S250
G1 X162.225 Y31.514 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X162.225 Y28.594 E.09064
G1 X165.145 Y28.594 E.09064
G1 X165.145 Y31.514 E.09064
G1 X162.285 Y31.514 E.08878
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X162.264 Y30.514 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-.834 J-.886 P1  F60000
G1 X159.833 Y32.802 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X159.833 Y35.302 E.08378
G1 X155.537 Y35.302 E.14396
G1 X155.537 Y26.506 E.29475
G1 X166.333 Y26.506 E.36177
G1 X166.333 Y35.302 E.29475
G1 X163.537 Y35.302 E.09369
G1 X163.537 Y32.802 E.08378
G1 X159.893 Y32.802 E.12212
; COOLING_NODE: 0
M204 S250
G1 X160.225 Y33.194 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X160.225 Y35.694 E.0776
G1 X155.145 Y35.694 E.15769
G1 X155.145 Y26.114 E.29737
G1 X166.725 Y26.114 E.35945
G1 X166.725 Y35.694 E.29737
G1 X163.145 Y35.694 E.11113
G1 X163.145 Y33.194 E.0776
G1 X160.285 Y33.194 E.08878
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X160.261 Y34.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I.265 J-1.188 P1  F60000
G1 X139.225 Y29.502 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X142.537 Y29.502 E.11099
G1 X142.537 Y33.206 E.12413
G1 X138.833 Y33.206 E.12413
G1 X138.833 Y29.502 E.12413
G1 X139.165 Y29.502 E.01113
; COOLING_NODE: 0
M204 S250
G1 X139.225 Y29.894 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X142.145 Y29.894 E.09064
G1 X142.145 Y32.814 E.09064
G1 X139.225 Y32.814 E.09064
G1 X139.225 Y29.954 E.08878
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X140.224 Y29.933 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-.363 J1.162 P1  F60000
G1 X143.333 Y30.904 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X143.333 Y35.302 E.14738
G1 X138.537 Y35.302 E.16071
G1 X138.537 Y26.506 E.29475
G1 X143.333 Y26.506 E.16071
G1 X143.333 Y30.844 E.14537
; COOLING_NODE: 0
M204 S250
G1 X143.725 Y30.904 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X143.725 Y35.694 E.14869
G1 X138.145 Y35.694 E.17321
G1 X138.145 Y26.114 E.29737
G1 X143.725 Y26.114 E.17321
G1 X143.725 Y30.844 E.14682
; WIPE_START
M204 S8000
G1 X143.725 Y31.844 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.162 J-.361 P1  F60000
G1 X142.935 Y29.298 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F15000
M204 S8000
G1 X142.935 Y33.409 E.13158
M204 S10000
G1 X142.941 Y34.227 F60000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F12000
M204 S8000
G1 X142.941 Y33.802 E.0132
G1 X142.481 Y33.798 E.01426
G1 X142.392 Y33.756 E.00305
G1 X142.312 Y33.598 E.00551
G1 X138.929 Y33.598 E.10501
G1 X138.929 Y34.91 E.04072
G1 X142.941 Y34.91 E.12452
G1 X142.941 Y34.287 E.01934
M204 S10000
G1 X142.515 Y34.227 F60000
; Slow Down Start
; LINE_WIDTH: 0.510255
G1 F3000;_EXTRUDE_SET_SPEED
M204 S8000
G1 X142.518 Y34.488 E.01003
G1 X139.351 Y34.488 E.12185
G1 X139.351 Y34.02 E.01798
G1 X142.092 Y34.02 E.10544
G1 X142.118 Y34.077 E.00238
G1 X142.405 Y34.214 E.01226
G1 X142.456 Y34.22 E.00196
; Slow Down End
; WIPE_START
G1 X142.405 Y34.214 E-.01932
G1 X142.118 Y34.077 E-.12106
G1 X142.092 Y34.02 E-.02355
G1 X141.523 Y34.02 E-.21608
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.185 J.279 P1  F60000
G1 X142.941 Y27.997 Z1.6
G1 Z1.2
G1 E.4 F1800
; LINE_WIDTH: 0.41999
G1 F12000
M204 S8000
G1 X142.941 Y26.898 E.03412
G1 X138.929 Y26.898 E.12452
G1 X138.929 Y29.11 E.06865
G1 X142.327 Y29.11 E.10547
G1 X142.416 Y28.934 E.00612
G1 X142.941 Y28.906 E.01629
G1 X142.941 Y28.057 E.02635
M204 S10000
G1 X142.563 Y27.997 F60000
G1 F12000
M204 S8000
G1 X142.563 Y27.275 E.02242
G1 X139.306 Y27.275 E.10112
G1 X139.306 Y28.733 E.04524
G1 X142.148 Y28.733 E.08822
G1 X142.219 Y28.613 E.00433
G1 X142.563 Y28.529 E.011
G1 X142.563 Y28.057 E.01465
M204 S10000
G1 X142.186 Y27.997 F60000
G1 F12000
M204 S8000
G1 X142.186 Y27.652 E.01072
G1 X139.683 Y27.652 E.07771
G1 X139.683 Y28.356 E.02184
G1 X141.978 Y28.356 E.07122
G1 X142.022 Y28.292 E.00242
G1 X142.186 Y28.245 E.00531
G1 X142.186 Y28.057 E.00583
M204 S10000
G1 X141.819 Y28.004 F60000
; LINE_WIDTH: 0.3693
G1 F12000
M204 S8000
G1 X140.095 Y28.004 E.04632
; WIPE_START
G1 X141.095 Y28.004 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-.219 J1.197 P1  F60000
G1 X161.484 Y31.74 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X161.484 Y28.057 E.1234
G3 X161.688 Y27.854 I.204 J0 E.01071
M73 P66 R7
G1 X165.37 Y27.854 E.1234
G3 X165.586 Y27.65 I.204 J0 E.01113
G1 X165.984 Y27.65 E.01334
G1 X165.984 Y26.854 E.02667
G1 X155.885 Y26.854 E.33842
G1 X155.885 Y34.954 E.27141
G1 X159.484 Y34.954 E.12061
G1 X159.484 Y32.657 E.07695
G3 X159.688 Y32.454 I.204 J0 E.01071
G1 X161.281 Y32.454 E.05338
G3 X161.309 Y31.84 I1.135 J-.255 E.02085
G1 X161.432 Y31.769 E.00474
M204 S10000
G1 X158.965 Y29.374 F60000
; LINE_WIDTH: 0.60371
G1 F13373.99
M204 S8000
G1 X158.404 Y29.374 E.02589
G1 X158.404 Y30.28 E.04185
G3 X158.965 Y30.059 I.641 J.802 E.02825
G1 X158.965 Y29.434 E.02886
M204 S10000
G1 X159.449 Y28.89 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X157.92 Y28.89 E.05122
G1 X157.92 Y31.296 E.08063
G3 X159.449 Y30.459 I1.74 J1.364 E.06002
G1 X159.449 Y28.95 E.05059
M204 S10000
G1 X159.856 Y28.483 F60000
; LINE_WIDTH: 0.444271
G1 F18686.89
M204 S8000
G1 X157.513 Y28.483 E.0774
G3 X157.497 Y33.341 I-430.724 J1.004 E.16053
G1 X157.872 Y33.341 E.01239
G3 X157.967 Y32.03 I4.391 J-.342 E.04362
G3 X159.856 Y30.825 I1.78 J.709 E.07906
G1 X159.856 Y28.543 E.07542
M204 S10000
G1 X160.263 Y28.075 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X157.106 Y28.075 E.10579
G1 X157.106 Y33.732 E.18956
G1 X158.263 Y33.732 E.03877
G3 X158.349 Y32.169 I4.469 J-.538 E.05274
G3 X159.688 Y31.232 I1.338 J.488 E.0583
G1 X160.254 Y31.232 E.01899
G2 X160.263 Y28.135 I-103.098 J-1.836 E.10378
M204 S10000
G1 X160.8 Y27.668 F60000
G1 F18424.351
M204 S8000
G1 X156.699 Y27.668 E.13741
G1 X156.699 Y34.14 E.21684
G1 X158.67 Y34.14 E.06605
G1 X158.67 Y32.657 E.04967
G3 X159.688 Y31.64 I1.045 J.028 E.05319
G1 X160.55 Y31.64 E.02889
G3 X160.67 Y31.39 I.185 J-.065 E.01032
G1 X160.67 Y28.057 E.11167
G1 X160.781 Y27.725 E.01172
M204 S10000
G1 X161.565 Y27.359 F60000
; LINE_WIDTH: 0.635357
G1 F12659.591
M204 S8000
G3 X165.079 Y27.354 I1.818 J40.426 E.17142
; LINE_WIDTH: 0.614818
G1 F13114.228
G1 X165.169 Y27.336 E.00431
; LINE_WIDTH: 0.574134
G1 F14118.604
G1 X165.258 Y27.317 E.004
; LINE_WIDTH: 0.53345
G1 F15289.584
G1 X165.348 Y27.299 E.00369
; LINE_WIDTH: 0.492766
G1 F16672.372
G1 X165.438 Y27.28 E.00339
; LINE_WIDTH: 0.452082
G1 F18330.149
G1 X165.527 Y27.262 E.00308
M204 S10000
G1 X161.565 Y27.359 F60000
; LINE_WIDTH: 0.621359
G1 F12965.936
M204 S8000
G1 X161.42 Y27.335 E.00701
; LINE_WIDTH: 0.572397
G1 F14164.942
G1 X161.275 Y27.31 E.00642
; LINE_WIDTH: 0.523434
G1 F15608.294
G1 X161.13 Y27.286 E.00582
; LINE_WIDTH: 0.450144
G1 F18417.377
G1 X156.292 Y27.261 E.16218
G1 X156.292 Y34.547 E.24422
G1 X159.077 Y34.547 E.09337
G1 X159.077 Y32.657 E.06334
G3 X159.688 Y32.047 I.611 J0 E.03215
G1 X160.874 Y32.047 E.03976
G1 X160.959 Y31.632 E.01419
G1 X161.077 Y31.565 E.00456
G1 X161.077 Y28.057 E.11758
G1 X161.199 Y27.691 E.01295
; LINE_WIDTH: 0.474472
G1 F17379.164
G1 X161.28 Y27.618 E.00385
; LINE_WIDTH: 0.523434
G1 F15608.294
G1 X161.36 Y27.545 E.00429
; LINE_WIDTH: 0.572397
G1 F14164.942
G1 X161.441 Y27.472 E.00473
; LINE_WIDTH: 0.621359
G1 F12965.936
G1 X161.521 Y27.4 E.00516
M204 S10000
G1 X165.935 Y27.998 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F15000
M204 S8000
G1 X165.935 Y32.109 E.13158
M204 S10000
G1 X165.941 Y32.927 F60000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F12000
M204 S8000
G1 X165.941 Y32.502 E.0132
G1 X165.427 Y32.48 E.01595
G1 X165.312 Y32.298 E.00668
G1 X164.132 Y32.298 E.03661
G1 X164.132 Y32.823 E.01631
G1 X164.1 Y32.929 E.00342
G1 X163.929 Y33.027 E.00613
G1 X163.929 Y34.91 E.05845
G1 X165.941 Y34.91 E.06244
G1 X165.941 Y32.987 E.05969
M204 S10000
G1 X165.563 Y32.927 F60000
G1 F12000
M204 S8000
G1 X165.563 Y32.879 E.0015
G1 X165.251 Y32.813 E.00991
G3 X165.13 Y32.675 I.054 J-.169 E.00599
G1 X164.509 Y32.675 E.01927
G1 X164.485 Y32.989 E.00976
G1 X164.413 Y33.139 E.00518
G1 X164.306 Y33.196 E.00377
G1 X164.306 Y34.533 E.04149
G1 X165.563 Y34.533 E.03904
G1 X165.563 Y32.987 E.04798
M204 S10000
G1 X165.155 Y33.198 F60000
; Slow Down Start
; LINE_WIDTH: 0.483184
G1 F3000;_EXTRUDE_SET_SPEED
M204 S8000
G1 X165.155 Y34.124 E.03357
G1 X164.715 Y34.124 E.01596
G1 X164.715 Y33.387 E.0267
G1 X164.752 Y33.367 E.00154
G1 X164.876 Y33.108 E.01042
G1 X165.098 Y33.18 E.00846
; Slow Down End
M204 S10000
G1 X163.74 Y32.354 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F15000
M204 S8000
G1 X161.629 Y32.354 E.08494
; WIPE_START
G1 X162.629 Y32.354 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-.015 J1.217 P1  F60000
G1 X182.935 Y32.598 Z1.6
G1 Z1.2
G1 E.4 F1800
; LINE_WIDTH: 0.43093
G1 F15000
M204 S8000
G1 X182.935 Y35.098 E.07985
M204 S10000
G1 X182.941 Y30.026 F60000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F12000
M204 S8000
G1 X182.941 Y29.602 E.01318
G1 X182.415 Y29.572 E.01633
G1 X182.313 Y29.398 E.00628
G1 X178.929 Y29.398 E.10503
G1 X178.929 Y32.41 E.09348
G1 X182.327 Y32.41 E.10549
G1 X182.415 Y32.236 E.00606
G1 X182.941 Y32.206 E.01633
G1 X182.941 Y30.086 E.06581
M204 S10000
G1 X182.563 Y30.026 F60000
G1 F12000
M204 S8000
G1 X182.563 Y29.979 E.00147
G1 X182.214 Y29.891 E.01119
G1 X182.15 Y29.775 E.00411
G1 X179.306 Y29.775 E.08828
G1 X179.306 Y32.033 E.07008
G1 X182.15 Y32.033 E.08828
G1 X182.214 Y31.917 E.00411
G1 X182.563 Y31.829 E.01119
G1 X182.563 Y30.086 E.05411
M204 S10000
G1 X182.186 Y30.26 F60000
G1 F12000
M204 S8000
G1 X182.012 Y30.21 E.00562
G1 X181.981 Y30.152 E.00205
G1 X179.683 Y30.152 E.07132
G1 X179.683 Y31.656 E.04667
G1 X181.981 Y31.656 E.07132
G1 X182.012 Y31.598 E.00205
G1 X182.186 Y31.548 E.00562
G1 X182.186 Y30.32 E.0381
M204 S10000
G1 X181.809 Y30.529 F60000
G1 F12000
M204 S8000
G1 X180.06 Y30.529 E.0543
G1 X180.06 Y31.279 E.02326
G1 X181.809 Y31.279 E.0543
G1 X181.809 Y30.589 E.0214
M204 S10000
G1 X180.435 Y30.904 F60000
; LINE_WIDTH: 0.41518
G1 F12000
M204 S8000
G1 X181.375 Y30.904 E.02881
M204 S10000
G1 X182.935 Y29.209 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43093
G1 F15000
M204 S8000
G1 X182.935 Y26.71 E.07985
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X182.935 Y27.71 E-.38
; WIPE_END
G1 E-.02 F1800
; layer num/total_layer_count: 7/12
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
M106 S170.85
; OBJECT_ID: 423
; COOLING_NODE: 0
M204 S10000
G17
G3 Z1.6 I-.948 J-.763 P1  F60000
G1 X178.833 Y32.802 Z1.6
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X178.833 Y35.302 E.08378
G1 X178.537 Y35.302 E.00994
G1 X178.537 Y26.506 E.29475
G1 X178.833 Y26.506 E.00994
G1 X178.833 Y29.006 E.08378
G1 X182.538 Y29.006 E.12413
G1 X182.538 Y26.506 E.08378
G1 X183.333 Y26.506 E.02664
G1 X183.333 Y35.302 E.29475
G1 X182.538 Y35.302 E.02664
G1 X182.538 Y32.802 E.08378
G1 X178.893 Y32.802 E.12212
; COOLING_NODE: 0
M204 S250
G1 X179.225 Y33.194 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X179.225 Y35.694 E.0776
G1 X178.145 Y35.694 E.03355
G1 X178.145 Y26.114 E.29737
G1 X179.225 Y26.114 E.03355
G1 X179.225 Y28.614 E.0776
G1 X182.145 Y28.614 E.09064
G1 X182.145 Y26.114 E.0776
G1 X183.725 Y26.114 E.04902
G1 X183.725 Y35.694 E.29737
G1 X182.145 Y35.694 E.04902
G1 X182.145 Y33.194 E.0776
G1 X179.285 Y33.194 E.08878
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X179.261 Y34.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I.185 J-1.203 P1  F60000
G1 X161.833 Y31.514 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X161.833 Y28.202 E.11099
G1 X165.537 Y28.202 E.12413
G1 X165.537 Y31.906 E.12413
G1 X161.833 Y31.906 E.12413
G1 X161.833 Y31.574 E.01113
; COOLING_NODE: 0
M204 S250
G1 X162.225 Y31.514 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X162.225 Y28.594 E.09064
G1 X165.145 Y28.594 E.09064
G1 X165.145 Y31.514 E.09064
G1 X162.285 Y31.514 E.08878
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X162.264 Y30.514 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-.834 J-.886 P1  F60000
G1 X159.833 Y32.802 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X159.833 Y35.302 E.08378
G1 X155.537 Y35.302 E.14396
G1 X155.537 Y26.506 E.29475
G1 X166.333 Y26.506 E.36177
G1 X166.333 Y35.302 E.29475
G1 X163.537 Y35.302 E.09369
G1 X163.537 Y32.802 E.08378
G1 X159.893 Y32.802 E.12212
; COOLING_NODE: 0
M204 S250
G1 X160.225 Y33.194 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X160.225 Y35.694 E.0776
G1 X155.145 Y35.694 E.15769
G1 X155.145 Y26.114 E.29737
G1 X166.725 Y26.114 E.35945
G1 X166.725 Y35.694 E.29737
G1 X163.145 Y35.694 E.11113
G1 X163.145 Y33.194 E.0776
G1 X160.285 Y33.194 E.08878
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X160.261 Y34.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I.265 J-1.188 P1  F60000
G1 X139.225 Y29.502 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X142.537 Y29.502 E.11099
G1 X142.537 Y33.206 E.12413
G1 X138.833 Y33.206 E.12413
G1 X138.833 Y29.502 E.12413
G1 X139.165 Y29.502 E.01113
; COOLING_NODE: 0
M204 S250
G1 X139.225 Y29.894 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X142.145 Y29.894 E.09064
G1 X142.145 Y32.814 E.09064
G1 X139.225 Y32.814 E.09064
G1 X139.225 Y29.954 E.08878
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X140.224 Y29.933 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-.363 J1.162 P1  F60000
G1 X143.333 Y30.904 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X143.333 Y35.302 E.14738
G1 X138.537 Y35.302 E.16071
G1 X138.537 Y26.506 E.29475
G1 X143.333 Y26.506 E.16071
G1 X143.333 Y30.844 E.14537
; COOLING_NODE: 0
M204 S250
G1 X143.725 Y30.904 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X143.725 Y35.694 E.14869
G1 X138.145 Y35.694 E.17321
G1 X138.145 Y26.114 E.29737
G1 X143.725 Y26.114 E.17321
G1 X143.725 Y30.844 E.14682
; WIPE_START
M204 S8000
G1 X143.725 Y31.844 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.162 J-.361 P1  F60000
G1 X142.935 Y29.298 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F15000
M204 S8000
G1 X142.935 Y33.409 E.13158
M204 S10000
G1 X142.941 Y33.802 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X142.481 Y33.798 E.01426
G1 X142.392 Y33.756 E.00305
G1 X142.312 Y33.598 E.00551
G1 X138.929 Y33.598 E.10501
G1 X138.929 Y34.91 E.04072
G1 X142.941 Y34.91 E.12452
G1 X142.941 Y33.862 E.03254
M204 S10000
G1 X142.515 Y34.227 F60000
; LINE_WIDTH: 0.510255
G1 F15000
M204 S8000
G1 X142.405 Y34.214 E.00426
G1 X142.118 Y34.077 E.01226
G1 X142.092 Y34.02 E.00238
G1 X139.351 Y34.02 E.10544
G1 X139.351 Y34.488 E.01798
G1 X142.518 Y34.488 E.12185
G1 X142.516 Y34.287 E.00772
; WIPE_START
G1 X142.518 Y34.488 E-.07629
G1 X141.719 Y34.488 E-.30371
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.178 J-.306 P1  F60000
G1 X140.035 Y28.004 Z1.8
G1 Z1.4
G1 E.4 F1800
; LINE_WIDTH: 0.36931
G1 F15000
M204 S8000
G1 X141.759 Y28.004 E.04632
M204 S10000
G1 X142.186 Y28.245 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X142.186 Y27.652 E.0184
G1 X139.683 Y27.652 E.07771
G1 X139.683 Y28.356 E.02184
G1 X141.978 Y28.356 E.07122
G3 X142.129 Y28.261 I.133 J.044 E.00599
M204 S10000
G1 X142.563 Y28.529 F60000
G1 F15000
M204 S8000
G1 X142.563 Y27.275 E.03893
G1 X139.306 Y27.275 E.10112
G1 X139.306 Y28.733 E.04524
G1 X142.148 Y28.733 E.08822
G1 X142.219 Y28.613 E.00433
G1 X142.505 Y28.543 E.00914
M204 S10000
G1 X142.941 Y28.906 F60000
G1 F15000
M204 S8000
G1 X142.941 Y26.898 E.06234
G1 X138.929 Y26.898 E.12452
G1 X138.929 Y29.11 E.06865
G1 X142.327 Y29.11 E.10547
G1 X142.416 Y28.934 E.00612
G1 X142.881 Y28.91 E.01443
; WIPE_START
G1 X142.416 Y28.934 E-.17662
G1 X142.327 Y29.11 E-.07495
G1 X141.989 Y29.11 E-.12843
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-.163 J1.206 P1  F60000
G1 X161.484 Y31.74 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X161.484 Y28.057 E.1234
G3 X161.688 Y27.854 I.204 J0 E.01071
G1 X165.37 Y27.854 E.1234
G3 X165.586 Y27.65 I.204 J0 E.01113
G1 X165.984 Y27.65 E.01334
G1 X165.984 Y26.854 E.02667
G1 X155.885 Y26.854 E.33842
G1 X155.885 Y34.954 E.27141
G1 X159.484 Y34.954 E.12061
G1 X159.484 Y32.657 E.07695
G3 X159.688 Y32.454 I.204 J0 E.01071
G1 X161.281 Y32.454 E.05338
G3 X161.309 Y31.84 I1.135 J-.255 E.02085
G1 X161.432 Y31.769 E.00474
M204 S10000
G1 X158.965 Y29.374 F60000
; LINE_WIDTH: 0.60371
G1 F13373.99
M204 S8000
G1 X158.404 Y29.374 E.02589
G1 X158.404 Y30.28 E.04185
G3 X158.965 Y30.059 I.641 J.802 E.02825
G1 X158.965 Y29.434 E.02886
M204 S10000
G1 X159.449 Y28.89 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X157.92 Y28.89 E.05122
G1 X157.92 Y31.296 E.08063
G3 X159.449 Y30.459 I1.74 J1.364 E.06002
G1 X159.449 Y28.95 E.05059
M204 S10000
G1 X159.856 Y28.483 F60000
; LINE_WIDTH: 0.444271
G1 F18686.89
M204 S8000
G1 X157.513 Y28.483 E.0774
G3 X157.497 Y33.341 I-430.724 J1.004 E.16053
G1 X157.872 Y33.341 E.01239
G3 X157.967 Y32.03 I4.391 J-.342 E.04362
G3 X159.856 Y30.825 I1.78 J.709 E.07906
G1 X159.856 Y28.543 E.07542
M204 S10000
G1 X160.263 Y28.075 F60000
; LINE_WIDTH: 0.44999
G1 F18424.351
M204 S8000
G1 X157.106 Y28.075 E.10579
G1 X157.106 Y33.732 E.18956
G1 X158.263 Y33.732 E.03877
G3 X158.349 Y32.169 I4.469 J-.538 E.05274
G3 X159.688 Y31.232 I1.338 J.488 E.0583
G1 X160.254 Y31.232 E.01899
G2 X160.263 Y28.135 I-103.098 J-1.836 E.10378
M204 S10000
G1 X160.8 Y27.668 F60000
G1 F18424.351
M204 S8000
G1 X156.699 Y27.668 E.13741
G1 X156.699 Y34.14 E.21684
G1 X158.67 Y34.14 E.06605
G1 X158.67 Y32.657 E.04967
G3 X159.688 Y31.64 I1.045 J.028 E.05319
G1 X160.55 Y31.64 E.02889
G3 X160.67 Y31.39 I.185 J-.065 E.01032
G1 X160.67 Y28.057 E.11167
G1 X160.781 Y27.725 E.01172
M204 S10000
G1 X161.565 Y27.359 F60000
; LINE_WIDTH: 0.635357
G1 F12659.591
M204 S8000
G3 X165.079 Y27.354 I1.818 J40.426 E.17142
; LINE_WIDTH: 0.614818
G1 F13114.228
G1 X165.169 Y27.336 E.00431
; LINE_WIDTH: 0.574134
G1 F14118.604
G1 X165.258 Y27.317 E.004
; LINE_WIDTH: 0.53345
G1 F15289.584
G1 X165.348 Y27.299 E.00369
; LINE_WIDTH: 0.492766
G1 F16672.372
G1 X165.438 Y27.28 E.00339
; LINE_WIDTH: 0.452082
G1 F18330.149
G1 X165.527 Y27.262 E.00308
M204 S10000
G1 X161.565 Y27.359 F60000
; LINE_WIDTH: 0.621359
G1 F12965.936
M204 S8000
G1 X161.42 Y27.335 E.00701
; LINE_WIDTH: 0.572397
G1 F14164.942
G1 X161.275 Y27.31 E.00642
; LINE_WIDTH: 0.523434
G1 F15608.294
G1 X161.13 Y27.286 E.00582
; LINE_WIDTH: 0.450144
G1 F18417.377
G1 X156.292 Y27.261 E.16218
G1 X156.292 Y34.547 E.24422
G1 X159.077 Y34.547 E.09337
G1 X159.077 Y32.657 E.06334
G3 X159.688 Y32.047 I.611 J0 E.03215
G1 X160.874 Y32.047 E.03976
G1 X160.959 Y31.632 E.01419
G1 X161.077 Y31.565 E.00456
G1 X161.077 Y28.057 E.11758
G1 X161.199 Y27.691 E.01295
; LINE_WIDTH: 0.474472
G1 F17379.164
G1 X161.28 Y27.618 E.00385
; LINE_WIDTH: 0.523434
G1 F15608.294
G1 X161.36 Y27.545 E.00429
; LINE_WIDTH: 0.572397
G1 F14164.942
G1 X161.441 Y27.472 E.00473
; LINE_WIDTH: 0.621359
G1 F12965.936
G1 X161.521 Y27.4 E.00516
M204 S10000
G1 X165.935 Y27.998 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43172
G1 F15000
M204 S8000
G1 X165.935 Y32.109 E.13158
M204 S10000
G1 X164.876 Y33.108 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.483185
G1 F15000
M204 S8000
G1 X164.752 Y33.367 E.01042
G1 X164.715 Y33.387 E.00154
G1 X164.715 Y34.124 E.0267
G1 X165.155 Y34.124 E.01596
G1 X165.155 Y33.198 E.03357
G1 X164.933 Y33.126 E.00846
M204 S10000
G1 X164.509 Y32.675 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X164.485 Y32.989 E.00976
G1 X164.413 Y33.139 E.00518
G1 X164.306 Y33.196 E.00377
G1 X164.306 Y34.533 E.04149
G1 X165.563 Y34.533 E.03904
G1 X165.563 Y32.879 E.05135
G1 X165.251 Y32.813 E.00991
G3 X165.13 Y32.675 I.054 J-.169 E.00599
G1 X164.569 Y32.675 E.0174
M204 S10000
G1 X164.132 Y32.298 F60000
G1 F15000
M204 S8000
G1 X164.132 Y32.823 E.01631
G1 X164.1 Y32.929 E.00342
G1 X163.929 Y33.027 E.00613
G1 X163.929 Y34.91 E.05845
G1 X165.941 Y34.91 E.06244
G1 X165.941 Y32.502 E.07475
G1 X165.427 Y32.48 E.01595
G1 X165.312 Y32.298 E.00668
G1 X164.192 Y32.298 E.03475
M204 S10000
G1 X163.74 Y32.354 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F15000
M204 S8000
G1 X161.629 Y32.354 E.08494
; WIPE_START
G1 X162.629 Y32.354 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I.099 J1.213 P1  F60000
G1 X180.435 Y30.904 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41518
G1 F15000
M204 S8000
G1 X181.375 Y30.904 E.02881
M204 S10000
G1 X180.06 Y31.279 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X181.809 Y31.279 E.0543
G1 X181.809 Y30.529 E.02326
G1 X180.06 Y30.529 E.0543
G1 X180.06 Y31.219 E.0214
M204 S10000
G1 X179.683 Y31.656 F60000
G1 F15000
M204 S8000
G1 X181.981 Y31.656 E.07132
G1 X182.012 Y31.598 E.00205
G1 X182.186 Y31.548 E.00562
G1 X182.186 Y30.26 E.03996
G1 X182.012 Y30.21 E.00562
G1 X181.981 Y30.152 E.00205
G1 X179.683 Y30.152 E.07132
G1 X179.683 Y31.596 E.04481
M204 S10000
G1 X179.306 Y32.033 F60000
G1 F15000
M204 S8000
G1 X182.15 Y32.033 E.08828
G1 X182.214 Y31.917 E.00411
G1 X182.563 Y31.829 E.01119
G1 X182.563 Y29.979 E.05745
G1 X182.214 Y29.891 E.01119
G1 X182.15 Y29.775 E.00411
G1 X179.306 Y29.775 E.08828
G1 X179.306 Y31.973 E.06821
M204 S10000
G1 X178.929 Y32.41 F60000
G1 F15000
M204 S8000
G1 X182.327 Y32.41 E.10549
G1 X182.415 Y32.236 E.00606
G1 X182.941 Y32.206 E.01633
G1 X182.941 Y29.602 E.08086
G1 X182.415 Y29.572 E.01633
G1 X182.313 Y29.398 E.00628
G1 X178.929 Y29.398 E.10503
G1 X178.929 Y32.35 E.09162
M204 S10000
G1 X182.935 Y32.598 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43093
G1 F15000
M204 S8000
G1 X182.935 Y35.098 E.07985
M204 S10000
G1 X182.935 Y29.209 F60000
G1 F15000
M204 S8000
G1 X182.935 Y26.71 E.07985
; WIPE_START
G1 X182.935 Y27.71 E-.38
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
    

    

    
        M9711 M0 E0 U252 V34 Z1.8 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

M204 S10000
G1 X142.892 Y89.877
G1 Z1.4
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X140.704 Y89.059  
M204 S8000
G3  X141.538 Y86.104   I2.026 J-1.023 E0.1282 F5400
G2  X142.392 Y83.571   I-3.390 J-2.554 E0.1033
G2  X142.389 Y72.013   I-283.960 J-5.694 E0.4393
G2  X140.546 Y68.448   I-6.625 J1.166 E0.1549
G3  X140.881 Y66.475   I1.652 J-0.734 E0.0806
G3  X143.999 Y63.213   I19.448 J15.469 E0.1717
G3  X147.197 Y63.871   I1.278 J1.891 E0.1383
G2  X150.214 Y64.877   I3.023 J-4.037 E0.1230
G1  X156.142  E0.2253
G1  X157.392  E0.0475
G2  X163.016 Y64.787   I2.339 J-29.659 E0.2141
G2  X166.351 Y62.929   I-2.882 J-9.098 E0.1461
G3  X168.518 Y63.424   I0.711 J1.877 E0.0895
G3  X171.580 Y66.695   I-16.399 J18.421 E0.1705
G3  X171.805 Y67.153   I-2.082 J1.304 E0.0194
G1 E-0.4000 F1800
M204 S10000
G1  X171.000 Y69.349   F600
G1 E0.4000 F1800
M204 S8000
G2  X169.892 Y72.183   I3.079 J2.837 E0.1183 F5400
G1  Y79.877  E0.2924
M73 P67 R7
G1 E-0.4000 F1800
M204 S10000
G1  Y82.377  F600
G1 E0.4000 F1800
M204 S8000
G2  X171.675 Y87.180   I5.184 J0.807 E0.2034 F5400
G3  X171.403 Y89.279   I-1.610 J0.858 E0.0858
G1  X169.892 Y90.877   E0.0836
G3  X167.433 Y92.922   I-4.377 J-2.762 E0.1236
G3  X164.774 Y91.666   I0.009 J-3.462 E0.1154
G2  X162.070 Y90.877   I-2.710 J4.259 E0.1085
G2  X150.024 Y90.881   I-5.928 J318.375 E0.4578
G2  X146.077 Y92.763   I0.501 J6.129 E0.1699
G3  X143.766 Y92.330   I-0.852 J-1.839 E0.0953
G3  X140.704 Y89.059   I16.406 J-18.427 E0.1705
; WIPE_TOWER_END
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
G1 E-.4 F1800
G17
G3 Z1.8 I1.217 J0 P1  F60000
G1 X143.142 Y65.627
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
G1  X169.142 Y65.627  E2.0691 F7836
G1  Y67.127  E0.1194
G1  X143.142  E2.0691
M632 S2 M N
M204 S10000
G1  Y67.877 
G1  X168.642  F3000
G1  Y66.377 
G1  X143.642 
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


M620 O10
M620 S2A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4.4 F1200
M632 S1 W
M400
M104 T1 S140 N0 ;Multi extruder pre heating
M633

M400
M106 P1 S0
M106 P2 S0




    M620.14 X171.392 Y68.3773



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
M73 E4

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
M73 P69 R7
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
M620 O10
M1002 gcode_claim_action : 0
M106 S255
M106 P2 S191

; filament start gcode
G1 X169.392 Y68.377 F60000
G1 Z1.4
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X166.392 Y68.377  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X170.892  F600
G1  X169.392  F240
G1  X169.892  F600
G1  Y68.877 
M73 P69 R6
G1  X168.892 
G1  Y67.877 
G1  X170.392 
G1  Y69.377 
G1  X168.392 
G1  Y67.377 
G1  X166.392 Y68.377   F1782
G1 E0.4000 F1800
M400
M104 T0 S230 N0
M204 S8000
G1  X142.892  E0.8931 F1782
G1  Y69.127  E0.0285
G1  X169.392  E1.0072 F2025
G1  Y69.877  E0.0285
G1  X142.892  E1.0072 F2473
G1  Y70.627  E0.0285
G1  X169.392  E1.0072 F4725
G1  Y71.377  E0.0285
G1  X142.892  E1.0072 F4775
G1  Y72.127  E0.0285
G1  X169.392  E1.0072
G1  Y72.877  E0.0285
M73 P70 R6
G1  X142.892  E1.0072
G1  Y73.627  E0.0285
G1  X169.392  E1.0072
G1  Y74.377  E0.0285
G1  X142.892  E1.0072
G1  Y75.127  E0.0285
G1  X169.392  E1.0072
G1  Y75.877  E0.0285
G1  X142.892  E1.0072
G1  Y76.627  E0.0285
G1  X169.392  E1.0072
G1  Y77.377  E0.0285
G1  X142.892  E1.0072
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
G1 X143.892 Y77.377 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.217 J0 P1  F60000
; OBJECT_ID: 423
; COOLING_NODE: 0
M204 S10000
G1 X177.333 Y30.904
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X177.333 Y35.302 E.14887
G1 X167.537 Y35.302 E.33158
G1 X167.537 Y26.506 E.29773
G1 X177.333 Y26.506 E.33158
G1 X177.333 Y30.844 E.14683
; COOLING_NODE: 0
M204 S250
G1 X177.725 Y30.904 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X177.725 Y35.694 E.15019
G1 X167.145 Y35.694 E.33173
G1 X167.145 Y26.114 E.30037
G1 X177.725 Y26.114 E.33173
G1 X177.725 Y30.844 E.14831
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X177.725 Y31.844 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I.034 J-1.216 P1  F60000
G1 X144.537 Y30.904 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X144.537 Y26.506 E.14887
G1 X154.333 Y26.506 E.33158
G1 X154.333 Y35.302 E.29773
G1 X144.537 Y35.302 E.33158
G1 X144.537 Y30.964 E.14683
; COOLING_NODE: 0
M204 S250
G1 X144.145 Y30.904 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X144.145 Y26.114 E.15019
G1 X154.725 Y26.114 E.33173
G1 X154.725 Y35.694 E.30037
G1 X144.145 Y35.694 E.33173
G1 X144.145 Y30.964 E.14831
; WIPE_START
M204 S8000
G1 X144.145 Y29.964 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-1.078 J.565 P1  F60000
G1 X146.116 Y33.723 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.46902
G1 F14785.261
M204 S8000
G1 X146.116 Y28.145 E.19763
M204 S10000
G1 X146.532 Y28.085 F60000
; LINE_WIDTH: 0.44999
G1 F15476.455
M204 S8000
G1 X146.532 Y27.668 E.0141
G1 X145.699 Y27.668 E.0282
G1 X145.699 Y34.14 E.21903
G1 X146.532 Y34.14 E.0282
G1 X146.532 Y28.145 E.2029
M204 S10000
G1 X146.939 Y28.085 F60000
G1 F15476.455
M204 S8000
G1 X146.939 Y27.261 E.02788
G1 X145.292 Y27.261 E.05576
G1 X145.292 Y34.547 E.24659
G1 X146.939 Y34.547 E.05576
G1 X146.939 Y28.145 E.21668
M204 S10000
G1 X147.346 Y28.085 F60000
G1 F15476.455
M204 S8000
G1 X147.346 Y26.854 E.04166
G1 X144.885 Y26.854 E.08332
G1 X144.885 Y34.954 E.27415
G1 X147.346 Y34.954 E.08332
G1 X147.346 Y28.145 E.23046
M204 S10000
G1 X149.623 Y28.594 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41932
G1 F15000
M204 S8000
G1 X149.623 Y28.406 E.00589
G1 X149.246 Y28.406 E.01178
G1 X149.246 Y33.402 E.15636
G1 X149.623 Y33.402 E.01178
G1 X149.623 Y28.654 E.14859
M204 S10000
G1 X150 Y28.594 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X150 Y28.029 E.01771
G1 X148.87 Y28.029 E.03543
G1 X148.87 Y33.779 E.18026
G1 X150 Y33.779 E.03543
G1 X150 Y28.654 E.16067
M204 S10000
G1 X150.377 Y28.594 F60000
G1 F15000
M204 S8000
G1 X150.377 Y27.652 E.02954
G1 X148.493 Y27.652 E.05907
G1 X148.493 Y34.156 E.20391
G1 X150.377 Y34.156 E.05907
G1 X150.377 Y28.654 E.17249
M204 S10000
G1 X150.754 Y28.594 F60000
G1 F15000
M204 S8000
G1 X150.754 Y27.275 E.04136
G1 X148.116 Y27.275 E.08272
G1 X148.116 Y34.533 E.22755
G1 X150.754 Y34.533 E.08272
G1 X150.754 Y28.654 E.18431
M204 S10000
G1 X151.131 Y28.594 F60000
G1 F15000
M204 S8000
G1 X151.131 Y26.898 E.05318
G1 X147.738 Y26.898 E.10636
G1 X147.738 Y34.91 E.2512
G1 X151.131 Y34.91 E.10636
G1 X151.131 Y28.654 E.19614
M204 S10000
G1 X152.754 Y33.723 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.46902
G1 F14785.261
M204 S8000
G1 X152.754 Y28.145 E.19763
M204 S10000
G1 X153.17 Y28.085 F60000
; LINE_WIDTH: 0.44999
G1 F15476.455
M204 S8000
G1 X153.17 Y27.668 E.0141
G1 X152.337 Y27.668 E.0282
G1 X152.337 Y34.14 E.21903
G1 X153.17 Y34.14 E.0282
G1 X153.17 Y28.145 E.2029
M204 S10000
G1 X153.577 Y28.085 F60000
G1 F15476.455
M204 S8000
G1 X153.577 Y27.261 E.02788
G1 X151.93 Y27.261 E.05576
G1 X151.93 Y34.547 E.24659
G1 X153.577 Y34.547 E.05576
G1 X153.577 Y28.145 E.21668
M204 S10000
G1 X153.984 Y28.085 F60000
G1 F15476.455
M204 S8000
G1 X153.984 Y26.854 E.04166
G1 X151.523 Y26.854 E.08332
G1 X151.523 Y34.954 E.27415
G1 X153.984 Y34.954 E.08332
G1 X153.984 Y28.145 E.23046
; WIPE_START
G1 X153.984 Y29.145 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-.384 J1.155 P1  F60000
G1 X168.771 Y34.068 Z1.8
G1 Z1.4
G1 E.4 F1800
; LINE_WIDTH: 0.59307
G1 F11451.423
M204 S8000
G1 X169.321 Y34.068 E.02517
G1 X169.321 Y27.74 E.28948
G1 X168.771 Y27.74 E.02517
G1 X168.771 Y34.008 E.28673
M204 S10000
G1 X168.292 Y34.547 F60000
; LINE_WIDTH: 0.44999
G1 F15476.455
M204 S8000
G1 X169.799 Y34.547 E.05102
G1 X169.799 Y27.261 E.24659
G1 X168.292 Y27.261 E.05102
G1 X168.292 Y34.487 E.24456
M204 S10000
G1 X167.885 Y34.954 F60000
G1 F15476.455
M204 S8000
G1 X170.207 Y34.954 E.07858
G1 X170.207 Y26.854 E.27415
G1 X167.885 Y26.854 E.07858
G1 X167.885 Y34.894 E.27212
M204 S10000
G1 X172.176 Y33.332 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.55924
G1 F12201.736
M204 S8000
G1 X172.693 Y33.332 E.02217
G1 X172.693 Y28.476 E.20848
G1 X172.176 Y28.476 E.02217
G1 X172.176 Y33.272 E.2059
M204 S10000
G1 X171.73 Y33.779 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X173.14 Y33.779 E.0442
G1 X173.14 Y28.029 E.18026
G1 X171.73 Y28.029 E.0442
G1 X171.73 Y33.719 E.17838
M204 S10000
G1 X171.353 Y34.156 F60000
G1 F15000
M204 S8000
G1 X173.517 Y34.156 E.06784
G1 X173.517 Y27.652 E.20391
G1 X171.353 Y27.652 E.06784
G1 X171.353 Y34.096 E.20203
M204 S10000
G1 X170.976 Y34.533 F60000
G1 F15000
M204 S8000
G1 X173.894 Y34.533 E.09149
G1 X173.894 Y27.275 E.22755
G1 X170.976 Y27.275 E.09149
G1 X170.976 Y34.473 E.22567
M204 S10000
G1 X170.599 Y34.91 F60000
G1 F15000
M204 S8000
G1 X174.271 Y34.91 E.11513
G1 X174.271 Y26.898 E.2512
G1 X170.599 Y26.898 E.11513
G1 X170.599 Y34.85 E.24932
M204 S10000
G1 X175.548 Y34.068 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.59308
G1 F11451.214
M204 S8000
G1 X176.099 Y34.068 E.02517
G1 X176.099 Y27.74 E.28948
G1 X175.548 Y27.74 E.02517
G1 X175.548 Y34.008 E.28674
M204 S10000
G1 X175.07 Y34.547 F60000
; LINE_WIDTH: 0.44999
G1 F15476.455
M204 S8000
G1 X176.577 Y34.547 E.05102
G1 X176.577 Y27.261 E.24659
G1 X175.07 Y27.261 E.05102
G1 X175.07 Y34.487 E.24456
M204 S10000
G1 X174.663 Y34.954 F60000
G1 F15476.455
M204 S8000
G1 X176.984 Y34.954 E.07858
G1 X176.984 Y26.854 E.27415
G1 X174.663 Y26.854 E.07858
G1 X174.663 Y34.894 E.27212
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
M204 S8000
G1 X174.663 Y33.894 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.217 J0 P1  F60000
G1 X143.142 Y78.377
G1 Z1.4
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF2 NF1 ON1 NN0
M204 S8000
G1  X169.142 Y78.377  E2.0691 F6583
G1  Y79.877  E0.1194
G1  X143.142  E2.0691
; NOZZLE_CHANGE_END OF2 NF1 ON1 NN0
M400
M104 T0 S25 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S8000
G1 X144.142 Y79.877 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S10000
G17
G3 Z1.8 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O11
M620 S1A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4.4 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X171.392 Y81.1273



M620.10 A0 F419.075 L0 H0.4 T240 P230 S1



M620.10 A1 F498.898 L0 H0.4 T180 P150 S1



M620.11 P1 I2 B-1 E-14 F523.843



M620.15 P180
M620.15 C140
M620.11 O1 T18


M620.11 K1 I2 B-1 R10 F523.843


M620.15 C140

M628 S1


M620.11 S1 L0 I2 B-1 R10 D8 E-14 F523.843


M629


;M620.11 H0




T1 H-1
M73 E3

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

;VM109 S150

M629
M400

;prime_tower_interface

;prime_tower_interface

M983.3 F10.4167 A0.4 R2


M400

G387 Y320 J1 F10000
M73 P71 R6
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.4 F3000

M204 S8000


M621 S1A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y320 J1 F10000
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.4 F3000

M204 S8000

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I1 H-1 W1 ;enable ams air printing detect
M620 O11
M1002 gcode_claim_action : 0
M106 S68.85
M106 P2 S102
G1 X173.895 Y81.127 F600
M204 S1000
G1 Z1.4

; filament start gcode
M109 S145;
G17
G3 Z1.8 I0 J-1.217 P1
G1 X169.392 Y81.127 Z1.8
G1 Z1.4
G1 E2.2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S25
G1  X166.392 Y81.127  E0.1140 F1782
G1 E-0.4000 F1800
M204 S1000
G1  X170.892  F600
G1  X169.392  F240
G1  X169.892  F600
G1  Y81.627 
G1  X168.892 
G1  Y80.627 
G1  X170.392 
G1  Y82.127 
G1  X168.392 
G1  Y80.127 
G1  X166.392 Y81.127   F1782
G1 E0.4000 F1800
M400
M104 T1 S150 N0
M204 S25
G1  X142.892  E0.8931 F1782
G1  Y81.877  E0.0285
G1  X169.392  E1.0072 F2025
G1  Y82.627  E0.0285
G1  X142.892  E1.0072 F2473
G1  Y83.377  E0.0285
G1  X169.392  E1.0072 F4725
G1  Y84.127  E0.0285
G1  X142.892  E1.0072 F4775
G1  Y84.877  E0.0285
G1  X169.392  E1.0072
G1  Y85.627  E0.0285
M73 P72 R6
G1  X142.892  E1.0072
G1  Y86.377  E0.0285
G1  X169.392  E1.0072
G1  Y87.127  E0.0285
G1  X142.892  E1.0072
G1  Y87.877  E0.0285
G1  X169.392  E1.0072
G1  Y88.627  E0.0285
G1  X142.892  E1.0072
G1  Y89.377  E0.0285
G1  X169.392  E1.0072
G1  Y90.127  E0.0285
G1  X142.892  E1.0072
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
G1 X143.892 Y90.127 E-.38
; WIPE_END
M73 P73 R6
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I1.217 J0 P1  F600
; OBJECT_ID: 423
; COOLING_NODE: 0
M204 S1000
G1 X140.037 Y30.706
G1 Z1.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
G1 X141.303 Y30.706 E.04242
G1 X141.303 Y32.002 E.04343
G1 X140.037 Y32.002 E.04242
G1 X140.037 Y30.766 E.04141
; COOLING_NODE: 0
G1 X139.645 Y30.314
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X141.695 Y30.314 E.06363
G1 X141.695 Y32.394 E.06457
G1 X139.645 Y32.394 E.06363
G1 X139.645 Y30.374 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X140.644 Y30.345 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I-.215 J1.198 P1  F600
G1 X161.037 Y34.006 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X162.303 Y34.006 E.04242
G1 X162.303 Y35.302 E.04343
G1 X161.037 Y35.302 E.04242
G1 X161.037 Y34.066 E.04141
; COOLING_NODE: 0
G1 X160.645 Y33.614
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X162.695 Y33.614 E.06363
G1 X162.695 Y35.694 E.06457
G1 X160.645 Y35.694 E.06363
G1 X160.645 Y33.674 E.0627
; COOLING_NODE: 0
; WIPE_START
G1 X161.644 Y33.645 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I1.1 J.521 P1  F600
G1 X163.037 Y30.702 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P74 R6
G1 F600
M204 S25
M73 P74 R5
G1 X163.037 Y29.406 E.04343
G1 X164.303 Y29.406 E.04242
G1 X164.303 Y30.702 E.04343
G1 X163.097 Y30.702 E.04041
; COOLING_NODE: 0
G1 X162.645 Y31.094
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X162.645 Y29.014 E.06457
G1 X164.695 Y29.014 E.06363
G1 X164.695 Y31.094 E.06457
G1 X162.705 Y31.094 E.06177
; COOLING_NODE: 0
; WIPE_START
G1 X162.676 Y30.094 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I.159 J1.206 P1  F600
G1 X180.038 Y27.802 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X180.038 Y26.506 E.04343
G1 X181.303 Y26.506 E.04242
G1 X181.303 Y27.802 E.04343
G1 X180.098 Y27.802 E.04041
; COOLING_NODE: 0
G1 X179.645 Y28.194
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X179.645 Y26.114 E.06457
G1 X181.695 Y26.114 E.06363
G1 X181.695 Y28.194 E.06457
G1 X179.705 Y28.194 E.06177
; COOLING_NODE: 0
; WIPE_START
G1 X179.677 Y27.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I-1.215 J.064 P1  F600
G1 X180.038 Y34.006 Z1.8
G1 Z1.4
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X181.303 Y34.006 E.04242
G1 X181.303 Y35.302 E.04343
G1 X180.038 Y35.302 E.04242
G1 X180.038 Y34.066 E.04141
; COOLING_NODE: 0
G1 X179.645 Y33.614
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X181.695 Y33.614 E.06363
G1 X181.695 Y35.694 E.06457
G1 X179.645 Y35.694 E.06363
G1 X179.645 Y33.674 E.0627
M204 S1000
G1 X180.456 Y34.424
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.47232
M204 S25
G1 X180.456 Y34.884 E.01624
G1 X180.885 Y34.884 E.01518
G1 X180.885 Y34.424 E.01624
G1 X180.516 Y34.424 E.01306
; WIPE_START
G1 X180.885 Y34.424 E-.14037
G1 X180.885 Y34.884 E-.17458
G1 X180.714 Y34.884 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I1.216 J-.042 P1  F600
G1 X180.456 Y27.384 Z1.8
G1 Z1.4
G1 E.6 F1800
G1 F600
M204 S25
G1 X180.885 Y27.384 E.01518
G1 X180.885 Y26.924 E.01624
G1 X180.456 Y26.924 E.01518
G1 X180.456 Y27.324 E.01412
; WIPE_START
G1 X180.456 Y26.924 E-.15178
G1 X180.885 Y26.924 E-.16317
G1 X180.885 Y27.095 E-.06505
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I-.219 J-1.197 P1  F600
G1 X163.455 Y30.284 Z1.8
G1 Z1.4
G1 E.6 F1800
; LINE_WIDTH: 0.47233
G1 F600
M204 S25
M73 P75 R5
G1 X163.884 Y30.284 E.01518
G1 X163.884 Y29.824 E.01624
G1 X163.455 Y29.824 E.01518
G1 X163.455 Y30.224 E.01412
; WIPE_START
G1 X163.455 Y29.824 E-.15178
G1 X163.884 Y29.824 E-.16318
G1 X163.884 Y29.995 E-.06504
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I-1.067 J-.585 P1  F600
G1 X161.455 Y34.424 Z1.8
G1 Z1.4
G1 E.6 F1800
G1 F600
M204 S25
G1 X161.455 Y34.884 E.01624
G1 X161.884 Y34.884 E.01518
G1 X161.884 Y34.424 E.01624
G1 X161.515 Y34.424 E.01306
; WIPE_START
G1 X161.884 Y34.424 E-.14038
G1 X161.884 Y34.884 E-.17458
G1 X161.713 Y34.884 E-.06504
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I.216 J-1.198 P1  F600
G1 X140.884 Y31.124 Z1.8
G1 Z1.4
G1 E.6 F1800
G1 F600
M204 S25
G1 X140.455 Y31.124 E.01518
G1 X140.455 Y31.584 E.01624
G1 X140.884 Y31.584 E.01518
G1 X140.884 Y31.184 E.01412
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 8/12
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
M106 S56.1
; OBJECT_ID: 423
; COOLING_NODE: 0
; WIPE_START
G1 F600
G1 X140.884 Y31.584 E-.15178
G1 X140.455 Y31.584 E-.16318
G1 X140.455 Y31.412 E-.06504
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z1.8 I.15 J1.208 P1  F600
G1 X144.537 Y30.904 Z1.8
G1 Z1.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
G1 X144.537 Y26.506 E.14738
G1 X146.303 Y26.506 E.05917
G1 X146.303 Y35.302 E.29475
G1 X144.537 Y35.302 E.05917
G1 X144.537 Y30.964 E.14537
; COOLING_NODE: 0
G1 X144.145 Y30.904
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X144.145 Y26.114 E.14869
G1 X146.695 Y26.114 E.07915
G1 X146.695 Y35.694 E.29737
G1 X144.145 Y35.694 E.07915
G1 X144.145 Y30.964 E.14682
; WIPE_START
G1 X144.145 Y29.964 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I1.004 J.688 P1  F600
G1 X145.911 Y27.389 Z2
G1 Z1.6
G1 E.6 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F480
M204 S25
G1 X145.911 Y26.898 E.01524
G1 X144.929 Y26.898 E.03047
G1 X144.929 Y34.91 E.24868
G1 X145.911 Y34.91 E.03047
G1 X145.911 Y27.449 E.23159
M204 S1000
G1 X145.42 Y34.419 F600
; Slow Down Start
; LINE_WIDTH: 0.6476
;_EXTRUDE_SET_SPEED
M204 S25
G1 X145.42 Y27.449 E.34694
; Slow Down End
; COOLING_NODE: 0
; WIPE_START
M73 P76 R5
G1 X145.42 Y28.449 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I-.134 J1.21 P1  F600
G1 X167.537 Y30.904 Z2
G1 Z1.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X167.537 Y26.506 E.14738
G1 X169.303 Y26.506 E.05917
G1 X169.303 Y35.302 E.29475
G1 X167.537 Y35.302 E.05917
G1 X167.537 Y30.964 E.14537
; COOLING_NODE: 0
G1 X167.145 Y30.904
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X167.145 Y26.114 E.14869
G1 X169.695 Y26.114 E.07915
G1 X169.695 Y35.694 E.29737
G1 X167.145 Y35.694 E.07915
G1 X167.145 Y30.964 E.14682
; COOLING_NODE: 0
; WIPE_START
G1 X167.145 Y29.964 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I.067 J-1.215 P1  F600
G1 X157.333 Y29.425 Z2
G1 Z1.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X157.333 Y30.721 E.04343
G1 X154.303 Y30.721 E.10154
G1 X154.303 Y35.302 E.15352
G1 X152.537 Y35.302 E.05917
G1 X152.537 Y26.506 E.29475
G1 X154.303 Y26.506 E.05917
G1 X154.303 Y29.425 E.09781
G1 X157.273 Y29.425 E.09953
; COOLING_NODE: 0
M73 P77 R5
G1 X157.725 Y29.033
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X157.725 Y31.113 E.06457
G1 X154.695 Y31.113 E.09405
G1 X154.695 Y35.694 E.14221
G1 X152.145 Y35.694 E.07915
G1 X152.145 Y26.114 E.29737
G1 X154.695 Y26.114 E.07915
G1 X154.695 Y29.033 E.0906
G1 X157.665 Y29.033 E.09219
M204 S1000
G1 X156.907 Y30.073
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.488114
G1 F480
M204 S25
G1 X156.907 Y29.851 E.00814
G1 X154.08 Y29.851 E.10361
; LINE_WIDTH: 0.471763
G1 X154.005 Y29.781 E.00361
; LINE_WIDTH: 0.420212
G1 X153.93 Y29.711 E.00318
G1 X153.911 Y29.543 E.00526
G1 X153.911 Y26.898 E.08214
G1 X152.929 Y26.898 E.03049
G1 X152.929 Y34.91 E.24883
G1 X153.911 Y34.91 E.03049
G1 X153.911 Y30.517 E.13643
G1 X153.986 Y30.352 E.00565
; LINE_WIDTH: 0.486433
G1 X154.099 Y30.295 E.00461
G1 X156.907 Y30.295 E.10251
G1 X156.907 Y30.133 E.00592
M204 S1000
G1 X153.758 Y30.073 F600
; Slow Down Start
; LINE_WIDTH: 0.395045
;_EXTRUDE_SET_SPEED
M204 S25
G1 X153.42 Y30.517 E.01619
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.64759
;_EXTRUDE_SET_SPEED
G1 X153.296 Y29.939 E.02945
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.468572
;_EXTRUDE_SET_SPEED
G1 X153.42 Y29.543 E.01453
G1 X153.644 Y29.962 E.01665
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.41792
;_EXTRUDE_SET_SPEED
G1 X153.715 Y30.031 E.00307
; Slow Down End
M204 S1000
G1 X153.42 Y27.389
; Slow Down Start
; LINE_WIDTH: 0.64758
;_EXTRUDE_SET_SPEED
M204 S25
G1 X153.42 Y29.483 E.10422
; Slow Down End
M204 S1000
G1 X153.42 Y34.419
; Slow Down Start
; LINE_WIDTH: 0.6476
;_EXTRUDE_SET_SPEED
M204 S25
G1 X153.42 Y30.577 E.19123
; Slow Down End
; WIPE_START
G1 X153.42 Y31.577 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I.318 J1.175 P1  F600
G1 X168.911 Y27.389 Z2
G1 Z1.6
G1 E.6 F1800
; LINE_WIDTH: 0.41999
G1 F480
M204 S25
G1 X168.911 Y26.898 E.01524
G1 X167.929 Y26.898 E.03047
G1 X167.929 Y34.91 E.24868
G1 X168.911 Y34.91 E.03047
G1 X168.911 Y27.449 E.23159
M204 S1000
G1 X168.42 Y34.419 F600
; Slow Down Start
; LINE_WIDTH: 0.64758
;_EXTRUDE_SET_SPEED
M204 S25
G1 X168.42 Y27.449 E.34693
; Slow Down End
; COOLING_NODE: 0
; WIPE_START
G1 X168.42 Y28.449 E-.38
; WIPE_END
M73 P78 R5
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I.068 J1.215 P1  F600
G1 X180.038 Y27.802 Z2
G1 Z1.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X180.038 Y26.506 E.04343
G1 X183.303 Y26.506 E.10941
G1 X183.303 Y27.802 E.04343
G1 X180.098 Y27.802 E.1074
; COOLING_NODE: 0
G1 X179.645 Y28.194
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X179.645 Y26.114 E.06457
G1 X183.695 Y26.114 E.12569
M73 P78 R4
G1 X183.695 Y28.194 E.06457
G1 X179.705 Y28.194 E.12383
; COOLING_NODE: 0
; WIPE_START
G1 X179.677 Y27.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I-.812 J-.906 P1  F600
G1 X175.537 Y30.904 Z2
G1 Z1.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X175.537 Y26.506 E.14738
G1 X177.303 Y26.506 E.05917
G1 X177.303 Y30.256 E.12566
G1 X183.303 Y30.256 E.20106
G1 X183.303 Y31.552 E.04343
G1 X177.303 Y31.552 E.20106
G1 X177.303 Y35.302 E.12566
G1 X175.537 Y35.302 E.05917
G1 X175.537 Y30.964 E.14537
; COOLING_NODE: 0
G1 X175.145 Y30.904
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X175.145 Y26.114 E.14869
G1 X177.695 Y26.114 E.07915
G1 X177.695 Y29.864 E.1164
G1 X183.695 Y29.864 E.18624
G1 X183.695 Y31.944 E.06457
G1 X177.695 Y31.944 E.18624
G1 X177.695 Y35.694 E.1164
G1 X175.145 Y35.694 E.07915
G1 X175.145 Y30.964 E.14682
; COOLING_NODE: 0
; WIPE_START
G1 X175.145 Y29.964 E-.38
; WIPE_END
M73 P79 R4
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I-.775 J.938 P1  F600
G1 X180.038 Y34.006 Z2
G1 Z1.6
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X183.303 Y34.006 E.10941
G1 X183.303 Y35.302 E.04343
G1 X180.038 Y35.302 E.10941
G1 X180.038 Y34.066 E.04141
; COOLING_NODE: 0
G1 X179.645 Y33.614
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X183.695 Y33.614 E.12569
G1 X183.695 Y35.694 E.06457
G1 X179.645 Y35.694 E.12569
G1 X179.645 Y33.674 E.0627
M204 S1000
G1 X180.463 Y34.432
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48732
M204 S25
G1 X180.463 Y34.876 E.01626
G1 X182.877 Y34.876 E.0883
G1 X182.877 Y34.432 E.01626
G1 X180.523 Y34.432 E.0861
; WIPE_START
G1 X181.523 Y34.432 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I1.136 J.436 P1  F600
G1 X182.877 Y30.904 Z2
G1 Z1.6
G1 E.6 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.488144
G1 F480
M204 S25
G1 X182.877 Y30.682 E.00814
G1 X177.08 Y30.682 E.21247
; LINE_WIDTH: 0.471763
G1 X177.005 Y30.612 E.00361
; LINE_WIDTH: 0.420213
G1 X176.93 Y30.542 E.00318
G1 X176.911 Y30.374 E.00526
G1 X176.911 Y26.898 E.10796
G1 X175.929 Y26.898 E.03049
G1 X175.929 Y34.91 E.24883
G1 X176.911 Y34.91 E.03049
M632 S0 N R W
M400
M104 T0 S210 N0 ;Multi extruder pre heating
M633
G1 X176.911 Y31.348 E.11061
G1 X176.986 Y31.183 E.00565
; LINE_WIDTH: 0.486872
G1 X177.099 Y31.126 E.00462
G1 X182.877 Y31.126 E.21115
G1 X182.877 Y30.964 E.00593
M204 S1000
G1 X176.758 Y30.904 F600
; Slow Down Start
; LINE_WIDTH: 0.395055
;_EXTRUDE_SET_SPEED
M204 S25
G1 X176.42 Y31.348 E.01619
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.64758
;_EXTRUDE_SET_SPEED
G1 X176.296 Y30.77 E.02944
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.468572
;_EXTRUDE_SET_SPEED
G1 X176.42 Y30.374 E.01453
G1 X176.644 Y30.793 E.01665
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.41792
;_EXTRUDE_SET_SPEED
G1 X176.715 Y30.862 E.00307
; Slow Down End
M204 S1000
G1 X176.42 Y34.419
; Slow Down Start
; LINE_WIDTH: 0.64758
;_EXTRUDE_SET_SPEED
M204 S25
G1 X176.42 Y31.408 E.14985
; Slow Down End
M204 S1000
G1 X176.42 Y27.389
; Slow Down Start
;_EXTRUDE_SET_SPEED
M204 S25
G1 X176.42 Y30.314 E.1456
; Slow Down End
; WIPE_START
G1 X176.42 Y29.314 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I.526 J1.097 P1  F600
G1 X180.463 Y27.376 Z2
G1 Z1.6
G1 E.6 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.487325
G1 F600
M204 S25
M73 P80 R4
G1 X182.877 Y27.376 E.0883
G1 X182.877 Y26.932 E.01626
G1 X180.463 Y26.932 E.0883
G1 X180.463 Y27.316 E.01406
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
; WIPE_START
M204 S25
G1 X180.463 Y26.932 E-.14608
G1 X181.079 Y26.932 E-.23392
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2 I1.217 J0 P1  F600
G1 X143.142 Y72.127
G1 Z1.6
G1 E.6 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF1 NF0 ON0 NN2
M204 S25
G1  X169.142 Y72.127  E2.0691 F7836
; NOZZLE_CHANGE_END OF1 NF0 ON0 NN2
M400
M104 T1 S62 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S25
G1 X168.142 Y72.127 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S1000
G17
G3 Z2 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O12
M620 S0A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4.6 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X140.892 Y82.3773



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
M73 E2

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
M73 P83 R3
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.6 F3000

M204 S25


M621 S0A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y320 J1 F10000
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.6 F3000

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I0 H-1 W1 ;enable ams air printing detect
M620 O12
M1002 gcode_claim_action : 0
M106 S158.1
M106 P2 S191
G1 X140.904 Y94.956 F60000
M204 S10000
G1 Z1.6
G17
G3 Z2 I0 J-1.217 P1
G1 X138.39 Y94.956 Z2
G1 X138.39 Y82.377

; filament start gcode
G1 X142.892 Y82.377
G1 Z1.6
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X145.892 Y82.377  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X141.392  F600
G1  X142.892  F240
G1  X143.392  F600
G1  Y82.877 
G1  X142.392 
G1  Y81.877 
G1  X143.892 
G1  Y83.377 
G1  X141.892 
G1  Y81.377 
G1  X145.892 Y82.377   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X169.392  E0.8931 F1782
G1  Y81.627  E0.0285
G1  X142.892  E1.0072 F2025
G1  Y80.877  E0.0285
G1  X169.392  E1.0072 F2473
G1  Y80.127  E0.0285
G1  X142.892  E1.0072 F4725
G1  Y79.377  E0.0285
G1  X169.392  E1.0072 F4775
G1  Y78.627  E0.0285
G1  X142.892  E1.0072
G1  Y77.877  E0.0285
G1  X169.392  E1.0072
G1  Y77.127  E0.0285
G1  X142.892  E1.0072
G1  Y76.377  E0.0285
G1  X169.392  E1.0072
G1  Y75.627  E0.0285
G1  X142.892  E1.0072
G1  Y74.877  E0.0285
M73 P84 R3
G1  X169.392  E1.0072
G1  Y74.127  E0.0285
G1  X142.892  E1.0072
G1  Y73.377  E0.0285
G1  X169.392  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
; CP TOOLCHANGE END
;------------------


G1  Y84.127   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S8000
G1  X142.892  E1.0072
G1  Y83.127  E0.0380
G1  X169.392  E1.0072
G1  Y84.127  E0.0380
; WIPE_TOWER_END
G1  Y83.627
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X169.530 Y84.929  
M204 S8000
G1  X169.541 Y85.040   E0.0042
G3  X171.697 Y87.379   I-3.800 J5.665 E0.1220
G3  X171.266 Y89.424   I-1.926 J0.662 E0.0834
G3  X168.285 Y92.541   I-18.599 J-14.802 E0.1641
G3  X165.691 Y92.410   I-1.219 J-1.610 E0.1072
G2  X158.602 Y85.723   I-91.751 J90.161 E0.3704
G2  X153.466 Y85.912   I-2.456 J3.136 E0.2123
G3  X146.475 Y92.513   I-87.553 J-85.721 E0.3655
G3  X143.766 Y92.330   I-1.255 J-1.562 E0.1134
G3  X140.821 Y89.179   I15.816 J-17.735 E0.1641
G3  X141.097 Y86.596   I1.676 J-1.127 E0.1072
G2  X142.755 Y85.020   I-3.532 J-5.375 E0.0874
G1  X142.678 Y84.878   E0.0062
G2  X142.392 Y84.877   I-0.149 J2.412 E0.0109
G1  Y83.627  E0.0475
G1 E-0.4000 F1800
M204 S10000
G1  Y81.127  F600
G1 E0.4000 F1800
M204 S8000
G1  Y71.377  E0.3706 F5400
G2  X143.111 Y71.069   I0.276 J-0.349 E0.0363
G1  X143.097 Y71.050   E0.0009
G3  X140.715 Y68.662   I6.373 J-8.736 E0.1287
G3  X141.018 Y66.330   I1.788 J-0.953 E0.0953
G3  X143.999 Y63.213   I18.593 J14.797 E0.1641
G3  X146.593 Y63.344   I1.219 J1.610 E0.1072
G1  X151.385 Y67.875   E0.2506
G2  X154.736 Y70.981   I18.033 J-16.093 E0.1739
G2  X157.923 Y70.688   I1.399 J-2.259 E0.1305
G1  X165.691 Y63.344   E0.4063
G3  X168.518 Y63.424   I1.373 J1.475 E0.1192
G3  X171.463 Y66.575   I-15.816 J17.735 E0.1641
G3  X171.187 Y69.158   I-1.676 J1.127 E0.1072
M106 S255
G2  X169.173 Y71.069   I5.832 J8.159 E0.1059
G1  X169.317 Y71.376   E0.0129
G2  X169.892 Y71.377   I0.299 J-4.803 E0.0219
G1  Y84.877  E0.5131
G2  X169.530 Y84.929   I-0.152 J0.229 E0.0152
; WIPE_TOWER_END

; WIPE_START
M204 S8000
G1 X169.537 Y84.919 E-.00451
G1 X169.544 Y84.91 E-.00449
G1 X169.553 Y84.902 E-.0045
G1 X169.562 Y84.894 E-.00449
G1 X169.573 Y84.888 E-.0045
G1 X169.583 Y84.884 E-.00449
G1 X169.595 Y84.88 E-.00449
G1 X169.606 Y84.878 E-.00448
G1 X169.618 Y84.877 E-.00451
G1 X169.892 Y84.877 E-.10428
G1 X169.892 Y84.258 E-.23527
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I1.217 J0 P1  F60000
; OBJECT_ID: 423
; COOLING_NODE: 0
M204 S10000
G1 X143.333 Y30.904
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X143.333 Y35.302 E.14738
G1 X138.537 Y35.302 E.16071
G1 X138.537 Y26.506 E.29475
G1 X143.333 Y26.506 E.16071
G1 X143.333 Y30.844 E.14537
; COOLING_NODE: 0
M204 S250
G1 X143.725 Y30.904 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X143.725 Y35.694 E.14869
G1 X138.145 Y35.694 E.17321
G1 X138.145 Y26.114 E.29737
G1 X143.725 Y26.114 E.17321
G1 X143.725 Y30.844 E.14682
; WIPE_START
M204 S8000
G1 X143.725 Y31.844 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I1.176 J-.314 P1  F60000
G1 X142.941 Y28.904 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X142.941 Y26.898 E.06226
G1 X138.929 Y26.898 E.12452
G1 X138.929 Y34.91 E.24868
G1 X142.941 Y34.91 E.12452
G1 X142.941 Y28.964 E.18456
M204 S10000
G1 X142.563 Y28.904 F60000
G1 F15000
M204 S8000
G1 X142.563 Y27.275 E.05056
G1 X139.306 Y27.275 E.10112
G1 X139.306 Y34.533 E.22528
G1 X142.563 Y34.533 E.10112
G1 X142.563 Y28.964 E.17286
M204 S10000
G1 X142.186 Y28.904 F60000
G1 F15000
M204 S8000
G1 X142.186 Y27.652 E.03885
G1 X139.683 Y27.652 E.07771
G1 X139.683 Y34.156 E.20187
G1 X142.186 Y34.156 E.07771
G1 X142.186 Y28.964 E.16115
M204 S10000
G1 X141.809 Y28.904 F60000
G1 F15000
M204 S8000
G1 X141.809 Y28.029 E.02715
G1 X140.06 Y28.029 E.0543
G1 X140.06 Y33.779 E.17846
G1 X141.809 Y33.779 E.0543
G1 X141.809 Y28.964 E.14945
M204 S10000
G1 X141.432 Y28.904 F60000
G1 F15000
M204 S8000
G1 X141.432 Y28.406 E.01545
G1 X140.437 Y28.406 E.03089
G1 X140.437 Y33.402 E.15505
G1 X141.432 Y33.402 E.03089
G1 X141.432 Y28.964 E.13774
M204 S10000
G1 X141.089 Y28.904 F60000
; LINE_WIDTH: 0.35198
G1 F15000
M204 S8000
G1 X141.089 Y28.749 E.00393
G1 X140.78 Y28.749 E.00786
G1 X140.78 Y33.058 E.10963
G1 X141.089 Y33.058 E.00786
G1 X141.089 Y28.964 E.10417
; COOLING_NODE: 0
; WIPE_START
G1 X141.089 Y29.964 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-.107 J1.212 P1  F60000
G1 X151.725 Y30.904 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X151.725 Y35.694 E.14869
G1 X147.145 Y35.694 E.14217
G1 X147.145 Y26.114 E.29737
G1 X151.725 Y26.114 E.14217
G1 X151.725 Y30.844 E.14682
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X151.725 Y31.844 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.571 J1.074 P1  F60000
G1 X158.537 Y28.221 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X155.537 Y28.221 E.10053
G1 X155.537 Y26.506 E.05746
G1 X166.333 Y26.506 E.36177
G1 X166.333 Y32.502 E.20092
G1 X166.333 Y32.902 E.0134
G1 X166.333 Y33.302 E.0134
G1 X166.333 Y33.702 E.0134
G1 X166.333 Y34.102 E.0134
G1 X166.333 Y34.502 E.0134
G1 X166.333 Y34.902 E.0134
G1 X166.333 Y35.302 E.0134
G1 X165.917 Y35.302 E.01392
G1 X165.517 Y35.302 E.0134
G1 X165.117 Y35.302 E.0134
G1 F5389.068
G1 X164.717 Y35.302 E.0134
G1 F4517.655
G1 X164.317 Y35.302 E.0134
G1 F3723.041
G1 X163.917 Y35.302 E.0134
G1 F3005.227
G1 X163.517 Y35.302 E.0134
G1 F2364.214
G1 X163.117 Y35.302 E.0134
G1 F1800
G1 X162.722 Y35.302 E.01323
M106 S158.1
G1 F2364.214
G1 X162.322 Y35.302 E.0134
G1 F3005.227
G1 X161.922 Y35.302 E.0134
G1 F3723.041
G1 X161.522 Y35.302 E.0134
G1 F4517.655
G1 X161.122 Y35.302 E.0134
G1 F5389.068
G1 X160.722 Y35.302 E.0134
G1 F6000
G1 X160.322 Y35.302 E.0134
G1 X159.922 Y35.302 E.0134
G1 X159.522 Y35.302 E.0134
G1 X159.122 Y35.302 E.0134
G1 X158.722 Y35.302 E.0134
G1 X158.322 Y35.302 E.0134
G1 X157.922 Y35.302 E.0134
G1 X157.522 Y35.302 E.0134
G1 X157.122 Y35.302 E.0134
G1 X156.722 Y35.302 E.0134
G1 X155.537 Y35.302 E.03973
G1 X155.537 Y31.925 E.11317
G1 X158.537 Y31.925 E.10053
G1 X158.537 Y28.281 E.12212
; COOLING_NODE: 0
M204 S250
G1 X158.145 Y28.613 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X155.145 Y28.613 E.09312
G1 X155.145 Y26.114 E.07756
G1 X166.725 Y26.114 E.35945
G1 X166.725 Y34.894 E.27254
G1 X166.725 Y35.294 E.01242
G1 X166.725 Y35.694 E.01242
G1 X166.304 Y35.694 E.01307
G1 X165.904 Y35.694 E.01242
G1 X165.504 Y35.694 E.01242
G1 X165.104 Y35.694 E.01242
G1 F5595.29
G1 X164.704 Y35.694 E.01242
G1 F4706.632
G1 X164.304 Y35.694 E.01242
G1 F3894.774
G1 X163.904 Y35.694 E.01242
G1 F3159.716
G1 X163.504 Y35.694 E.01242
G1 F2501.458
G1 X163.104 Y35.694 E.01242
G1 F1920
G1 X162.736 Y35.694 E.01142
G1 F2501.458
G1 X162.336 Y35.694 E.01242
G1 F3159.716
G1 X161.936 Y35.694 E.01242
G1 F3894.774
G1 X161.536 Y35.694 E.01242
G1 F4706.632
G1 X161.136 Y35.694 E.01242
G1 F5595.29
G1 X160.736 Y35.694 E.01242
G1 F6000
G1 X160.336 Y35.694 E.01242
G1 X159.936 Y35.694 E.01242
G1 X159.536 Y35.694 E.01242
G1 X159.136 Y35.694 E.01242
G1 X158.736 Y35.694 E.01242
G1 X158.336 Y35.694 E.01242
G1 X155.145 Y35.694 E.09905
G1 X155.145 Y31.533 E.12917
G1 X158.145 Y31.533 E.09312
G1 X158.145 Y28.673 E.08878
; WIPE_START
M204 S8000
G1 X157.145 Y28.653 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I1.153 J-.388 P1  F60000
G1 X156.478 Y26.669 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42704
G1 F15000
M204 S8000
G1 X155.87 Y27.277 E.02717
G1 X155.87 Y27.82 E.01718
G1 X156.851 Y26.839 E.04388
G1 X157.394 Y26.839 E.01718
G1 X156.346 Y27.887 E.04688
G1 X156.889 Y27.887 E.01718
G1 X157.938 Y26.839 E.04688
G1 X158.481 Y26.839 E.01718
G1 X157.432 Y27.887 E.04688
G1 X157.976 Y27.887 E.01718
G1 X159.024 Y26.839 E.04688
G1 X159.567 Y26.839 E.01718
G1 X158.519 Y27.887 E.04688
G1 X158.87 Y27.887 E.0111
G1 X158.87 Y28.08 E.00608
G1 X160.11 Y26.839 E.05548
G1 X160.654 Y26.839 E.01718
G1 X158.87 Y28.623 E.07977
G1 X158.87 Y29.166 E.01718
G1 X161.197 Y26.839 E.10406
G1 X161.74 Y26.839 E.01718
G1 X158.87 Y29.709 E.12835
G1 X158.87 Y30.253 E.01718
G1 X162.283 Y26.839 E.15264
G1 X162.827 Y26.839 E.01718
G1 X158.87 Y30.796 E.17694
G1 X158.87 Y31.339 E.01718
G1 X163.37 Y26.839 E.20123
G1 X163.913 Y26.839 E.01718
G1 X158.7 Y32.052 E.23311
M204 S10000
G1 X156.491 Y32.088 F60000
G1 F15000
M204 S8000
G1 X155.87 Y32.709 E.02778
G1 X155.87 Y33.253 E.01718
G1 X156.865 Y32.258 E.04448
G1 X157.408 Y32.258 E.01718
G1 X155.87 Y33.796 E.06877
G1 X155.87 Y34.339 E.01718
G1 X157.951 Y32.258 E.09307
G1 X158.494 Y32.258 E.01718
G1 X155.87 Y34.882 E.11736
G1 X155.87 Y34.969 E.00273
G1 X156.327 Y34.969 E.01445
G1 X164.456 Y26.839 E.36354
G1 X164.999 Y26.839 E.01718
G1 X156.87 Y34.969 E.36354
G1 X157.413 Y34.969 E.01718
G1 X165.543 Y26.839 E.36354
G1 X165.999 Y26.839 E.01444
G1 X165.999 Y26.926 E.00274
G1 X157.956 Y34.969 E.35967
G1 X158.5 Y34.969 E.01718
G1 X165.999 Y27.469 E.33538
G1 X165.999 Y28.012 E.01718
M632 S1 W
M400
M104 T1 S140 N0 ;Multi extruder pre heating
M633
G1 X159.043 Y34.969 E.31108
G1 X159.586 Y34.969 E.01718
G1 X165.999 Y28.555 E.28679
G1 X165.999 Y29.099 E.01718
G1 X160.129 Y34.969 E.2625
G1 X160.673 Y34.969 E.01718
G1 X165.999 Y29.642 E.23821
G1 X165.999 Y30.185 E.01718
G1 X161.216 Y34.969 E.21392
G1 X161.759 Y34.969 E.01718
G1 X165.999 Y30.728 E.18962
G1 X165.999 Y31.272 E.01718
G1 X162.302 Y34.969 E.16533
G1 X162.845 Y34.969 E.01718
G1 X165.999 Y31.815 E.14104
G1 X165.999 Y32.358 E.01718
G1 X163.389 Y34.969 E.11675
G1 X163.932 Y34.969 E.01718
G1 X165.999 Y32.901 E.09246
G1 X165.999 Y33.444 E.01718
G1 X164.475 Y34.969 E.06816
G1 X165.018 Y34.969 E.01718
G1 X165.999 Y33.988 E.04387
G1 X165.999 Y34.531 E.01718
G1 X165.392 Y35.138 E.02717
; WIPE_START
G1 X165.999 Y34.531 E-.32649
G1 X165.999 Y34.39 E-.05351
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.59 J-1.064 P1  F60000
G1 X151.422 Y26.31 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.25525
G1 F15000
M204 S8000
G1 X151.422 Y35.498 E.16059
M204 S10000
G1 X150.753 Y35.487 F60000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F12000
M204 S2000
G1 X151.29 Y34.95 E.02358
G1 X151.423 Y34.816
G1 X151.423 Y34.283
G1 X151.29 Y34.416
G1 X150.22 Y35.487 E.04699
G1 X150.086 Y35.62
G1 X149.553 Y35.62
G1 X149.686 Y35.487
G1 X151.29 Y33.883 E.07039
G1 X151.423 Y33.749
G1 X151.423 Y33.216
G1 X151.29 Y33.35
G1 X149.153 Y35.487 E.0938
G1 X149.019 Y35.62
G1 X148.486 Y35.62
G1 X148.62 Y35.487
G1 X151.29 Y32.816 E.11721
G1 X151.423 Y32.683
G1 X151.423 Y32.15
G1 X151.29 Y32.283
G1 X148.086 Y35.487 E.14062
G1 X147.953 Y35.62
G1 X147.446 Y35.594
G1 X147.579 Y35.46
G1 X151.29 Y31.75 E.16288
G1 X151.423 Y31.616
G1 X151.423 Y31.083
G1 X151.29 Y31.217
G1 X147.579 Y34.927 E.16288
G1 X147.446 Y35.061
G1 X147.446 Y34.527
G1 X147.579 Y34.394
G1 X151.29 Y30.683 E.16288
G1 X151.423 Y30.55
G1 X151.423 Y30.017
G1 X151.29 Y30.15
G1 X147.579 Y33.861 E.16288
G1 X147.446 Y33.994
G1 X147.446 Y33.461
G1 X147.579 Y33.327
G1 X151.29 Y29.617 E.16288
G1 X151.423 Y29.483
G1 X151.423 Y28.95
G1 X151.29 Y29.084
G1 X147.579 Y32.794 E.16288
G1 X147.446 Y32.928
G1 X147.446 Y32.394
G1 X147.579 Y32.261
G1 X151.29 Y28.55 E.16288
G1 X151.423 Y28.417
G1 X151.423 Y27.884
G1 X151.29 Y28.017
G1 X147.579 Y31.728 E.16288
G1 X147.446 Y31.861
G1 X147.446 Y31.328
G1 X147.579 Y31.194
G1 X151.29 Y27.484 E.16288
G1 X151.423 Y27.35
G1 X151.423 Y26.817
G1 X151.29 Y26.951
G1 X147.579 Y30.661 E.16288
G1 X147.446 Y30.795
G1 X147.446 Y30.261
G1 X147.579 Y30.128
G1 X151.29 Y26.417 E.16288
G1 X151.423 Y26.284
G1 X150.986 Y26.188
G1 X150.853 Y26.321
G1 X147.579 Y29.594 E.14369
G1 X147.446 Y29.728
G1 X147.446 Y29.195
G1 X147.579 Y29.061
G1 X150.319 Y26.321 E.12028
G1 X150.453 Y26.188
G1 X149.92 Y26.188
G1 X149.786 Y26.321
G1 X147.579 Y28.528 E.09687
G1 X147.446 Y28.662
G1 X147.446 Y28.128
G1 X147.579 Y27.995
G1 X149.253 Y26.321 E.07346
G1 X149.386 Y26.188
G1 X148.853 Y26.188
G1 X148.72 Y26.321
G1 X147.579 Y27.461 E.05005
G1 X147.446 Y27.595
G1 X147.446 Y27.062
G1 X147.579 Y26.928
G1 X148.186 Y26.321 E.02664
M204 S10000
G1 X147.447 Y26.31 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.25526
G1 F15000
M204 S8000
G1 X147.447 Y35.498 E.1606
; COOLING_NODE: 0
; WIPE_START
G1 X147.447 Y34.498 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.159 J1.207 P1  F60000
G1 X174.725 Y30.904 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X174.725 Y35.694 E.14869
G1 X170.145 Y35.694 E.14217
G1 X170.145 Y26.114 E.29737
G1 X174.725 Y26.114 E.14217
G1 X174.725 Y30.844 E.14682
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X174.725 Y31.844 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
M73 P85 R3
G3 Z2 I.752 J.957 P1  F60000
G1 X178.833 Y28.614 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X178.833 Y29.052 E.01468
G1 X178.537 Y29.052 E.00994
G1 X178.537 Y26.506 E.08531
G1 X178.833 Y26.506 E.00994
G1 X178.833 Y28.554 E.06863
; COOLING_NODE: 0
M204 S250
G1 X179.225 Y28.614 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X183.725 Y28.614 E.13966
G1 X183.725 Y29.444 E.02576
G1 X178.145 Y29.444 E.17321
G1 X178.145 Y26.114 E.10337
G1 X179.225 Y26.114 E.03355
G1 X179.225 Y28.554 E.07574
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X180.225 Y28.567 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-1.156 J-.38 P1  F60000
G1 X178.833 Y32.802 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X178.833 Y35.302 E.08378
G1 X178.537 Y35.302 E.00994
G1 X178.537 Y32.756 E.08531
G1 X178.819 Y32.756 E.00947
; COOLING_NODE: 0
M204 S250
G1 X179.225 Y33.194 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X179.225 Y35.694 E.0776
G1 X178.145 Y35.694 E.03355
G1 X178.145 Y32.364 E.10337
G1 X183.725 Y32.364 E.17321
G1 X183.725 Y33.194 E.02576
G1 X179.285 Y33.194 E.1378
M204 S10000
G1 X179.03 Y32.779 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.48086
G1 F15000
M204 S8000
G1 X183.529 Y32.779 E.1622
; WIPE_START
G1 X182.529 Y32.779 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I1.176 J.314 P1  F60000
G1 X183.529 Y29.029 Z2
G1 Z1.6
G1 E.4 F1800
G1 F15000
M204 S8000
G1 X179.03 Y29.029 E.1622
; WIPE_START
G1 X180.03 Y29.029 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.536 J-1.092 P1  F60000
G1 X174.492 Y26.31 Z2
G1 Z1.6
G1 E.4 F1800
; LINE_WIDTH: 0.11534
G1 F15000
M204 S8000
G1 X174.492 Y35.498 E.05477
M204 S10000
G1 X174.43 Y34.74 F60000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F12000
M204 S2000
G1 X173.683 Y35.487 E.03279
G1 X173.549 Y35.62
G1 X173.016 Y35.62
G1 X173.15 Y35.487
G1 X174.43 Y34.206 E.0562
G1 X174.563 Y34.073
G1 X174.563 Y33.54
G1 X174.43 Y33.673
G1 X172.616 Y35.487 E.07961
G1 X172.483 Y35.62
G1 X171.949 Y35.62
G1 X172.083 Y35.487
G1 X174.43 Y33.14 E.10302
G1 X174.563 Y33.006
G1 X174.563 Y32.473
G1 X174.43 Y32.607
G1 X171.55 Y35.487 E.12642
G1 X171.416 Y35.62
G1 X170.883 Y35.62
G1 X171.017 Y35.487
G1 X174.43 Y32.073 E.14983
G1 X174.563 Y31.94
G1 X174.563 Y31.406
G1 X174.43 Y31.54
G1 X170.483 Y35.487 E.17324
G1 X170.35 Y35.62
G1 X170.306 Y35.131
G1 X170.44 Y34.997
G1 X174.43 Y31.007 E.17516
G1 X174.563 Y30.873
G1 X174.563 Y30.34
G1 X174.43 Y30.474
G1 X170.44 Y34.464 E.17516
G1 X170.306 Y34.597
G1 X170.306 Y34.064
G1 X170.44 Y33.931
G1 X174.43 Y29.94 E.17516
G1 X174.563 Y29.807
G1 X174.563 Y29.273
G1 X174.43 Y29.407
G1 X170.44 Y33.397 E.17516
G1 X170.306 Y33.531
G1 X170.306 Y32.998
G1 X170.44 Y32.864
G1 X174.43 Y28.874 E.17516
G1 X174.563 Y28.74
G1 X174.563 Y28.207
G1 X174.43 Y28.341
G1 X170.44 Y32.331 E.17516
G1 X170.306 Y32.464
G1 X170.306 Y31.931
G1 X170.44 Y31.798
G1 X174.43 Y27.807 E.17516
G1 X174.563 Y27.674
G1 X174.563 Y27.14
G1 X174.43 Y27.274
G1 X170.44 Y31.264 E.17516
G1 X170.306 Y31.398
G1 X170.306 Y30.865
G1 X170.44 Y30.731
G1 X174.43 Y26.741 E.17516
G1 X174.563 Y26.607
G1 X174.45 Y26.188
G1 X174.316 Y26.321
G1 X170.44 Y30.198 E.17017
G1 X170.306 Y30.331
G1 X170.306 Y29.798
G1 X170.44 Y29.664
G1 X173.783 Y26.321 E.14676
G1 X173.916 Y26.188
G1 X173.383 Y26.188
G1 X173.249 Y26.321
G1 X170.44 Y29.131 E.12335
G1 X170.306 Y29.265
G1 X170.306 Y28.732
G1 X170.44 Y28.598
G1 X172.716 Y26.321 E.09994
G1 X172.85 Y26.188
G1 X172.317 Y26.188
G1 X172.183 Y26.321
G1 X170.44 Y28.065 E.07653
G1 X170.306 Y28.198
G1 X170.306 Y27.665
G1 X170.44 Y27.531
G1 X171.65 Y26.321 E.05312
G1 X171.783 Y26.188
G1 X171.25 Y26.188
G1 X171.116 Y26.321
G1 X170.44 Y26.998 E.02971
M204 S10000
G1 X170.377 Y26.31 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.11533
G1 F15000
M204 S8000
G1 X170.377 Y35.498 E.05477
; WIPE_START
G1 X170.377 Y34.498 E-.38
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
    

    

    
        M9711 M0 E0 U252 V34 Z2 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 9/12
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
M106 S153
; OBJECT_ID: 423
; COOLING_NODE: 0
G1 X143.333 Y30.904 F60000
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X143.333 Y35.302 E.14738
G1 X138.537 Y35.302 E.16071
G1 X138.537 Y26.506 E.29475
G1 X143.333 Y26.506 E.16071
G1 X143.333 Y30.844 E.14537
; COOLING_NODE: 0
M204 S250
G1 X143.725 Y30.904 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X143.725 Y35.694 E.14869
G1 X138.145 Y35.694 E.17321
G1 X138.145 Y26.114 E.29737
G1 X143.725 Y26.114 E.17321
G1 X143.725 Y30.844 E.14682
; WIPE_START
M204 S8000
G1 X143.725 Y31.844 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I1.176 J-.314 P1  F60000
G1 X142.941 Y28.904 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X142.941 Y26.898 E.06226
G1 X138.929 Y26.898 E.12452
G1 X138.929 Y34.91 E.24868
G1 X142.941 Y34.91 E.12452
G1 X142.941 Y28.964 E.18456
M204 S10000
G1 X142.563 Y28.904 F60000
G1 F15000
M204 S8000
G1 X142.563 Y27.275 E.05056
G1 X139.306 Y27.275 E.10112
G1 X139.306 Y34.533 E.22528
G1 X142.563 Y34.533 E.10112
G1 X142.563 Y28.964 E.17286
M204 S10000
G1 X142.186 Y28.904 F60000
G1 F15000
M204 S8000
G1 X142.186 Y27.652 E.03885
G1 X139.683 Y27.652 E.07771
G1 X139.683 Y34.156 E.20187
G1 X142.186 Y34.156 E.07771
G1 X142.186 Y28.964 E.16115
M204 S10000
G1 X141.809 Y28.904 F60000
G1 F15000
M204 S8000
G1 X141.809 Y28.029 E.02715
G1 X140.06 Y28.029 E.0543
G1 X140.06 Y33.779 E.17846
G1 X141.809 Y33.779 E.0543
G1 X141.809 Y28.964 E.14945
M204 S10000
G1 X141.432 Y28.904 F60000
G1 F15000
M204 S8000
G1 X141.432 Y28.406 E.01545
G1 X140.437 Y28.406 E.03089
G1 X140.437 Y33.402 E.15505
G1 X141.432 Y33.402 E.03089
G1 X141.432 Y28.964 E.13774
M204 S10000
G1 X141.089 Y28.904 F60000
; LINE_WIDTH: 0.35198
G1 F15000
M204 S8000
G1 X141.089 Y28.749 E.00393
G1 X140.78 Y28.749 E.00786
G1 X140.78 Y33.058 E.10963
G1 X141.089 Y33.058 E.00786
G1 X141.089 Y28.964 E.10417
; COOLING_NODE: 0
; WIPE_START
G1 X141.089 Y29.964 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-.776 J.937 P1  F60000
G1 X147.537 Y35.302 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X147.537 Y26.506 E.29475
G1 X147.833 Y26.506 E.00991
G1 X147.833 Y35.302 E.29475
G1 X147.597 Y35.302 E.0079
; COOLING_NODE: 0
M204 S250
G1 X147.145 Y35.694 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X147.145 Y26.114 E.29737
G1 X148.225 Y26.114 E.03352
G1 X148.225 Y35.694 E.29737
G1 X147.205 Y35.694 E.03166
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X147.198 Y34.694 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.822 J.897 P1  F60000
G1 X151.333 Y30.904 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X151.333 Y35.302 E.14738
G1 X151.037 Y35.302 E.00991
G1 X151.037 Y26.506 E.29475
G1 X151.333 Y26.506 E.00991
G1 X151.333 Y30.844 E.14537
; COOLING_NODE: 0
M204 S250
G1 X151.725 Y30.904 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X151.725 Y35.694 E.14869
G1 X150.645 Y35.694 E.03352
G1 X150.645 Y26.114 E.29737
G1 X151.725 Y26.114 E.03352
G1 X151.725 Y30.844 E.14682
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X151.725 Y31.844 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.571 J1.074 P1  F60000
G1 X158.537 Y28.221 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X155.537 Y28.221 E.10053
G1 X155.537 Y26.506 E.05746
G1 X166.333 Y26.506 E.36177
G1 X166.333 Y35.302 E.29475
G1 X155.537 Y35.302 E.36177
G1 X155.537 Y31.925 E.11317
G1 X158.537 Y31.925 E.10053
G1 X158.537 Y28.281 E.12212
; COOLING_NODE: 0
M204 S250
G1 X158.145 Y28.613 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X155.145 Y28.613 E.09312
G1 X155.145 Y26.114 E.07756
G1 X166.725 Y26.114 E.35945
G1 X166.725 Y35.694 E.29737
G1 X155.145 Y35.694 E.35945
G1 X155.145 Y31.533 E.12917
G1 X158.145 Y31.533 E.09312
G1 X158.145 Y28.673 E.08878
; WIPE_START
M204 S8000
G1 X157.145 Y28.653 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.797 J-.919 P1  F60000
G1 X156.458 Y28.057 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42704
G1 F15000
M204 S8000
G1 X155.87 Y27.469 E.02631
G1 X155.87 Y26.926 E.01718
G1 X156.832 Y27.887 E.04302
G1 X157.375 Y27.887 E.01718
G1 X156.327 Y26.839 E.04688
G1 X156.87 Y26.839 E.01718
G1 X157.918 Y27.887 E.04688
G1 X158.461 Y27.887 E.01718
G1 X157.413 Y26.839 E.04688
G1 X157.956 Y26.839 E.01718
G1 X165.999 Y34.882 E.35967
G1 X165.999 Y34.339 E.01718
G1 X158.5 Y26.839 E.33538
G1 X159.043 Y26.839 E.01718
G1 X165.999 Y33.796 E.31108
G1 X165.999 Y33.253 E.01718
G1 X159.586 Y26.839 E.28679
G1 X160.129 Y26.839 E.01718
G1 X165.999 Y32.709 E.2625
G1 X165.999 Y32.166 E.01718
G1 X160.673 Y26.839 E.23821
G1 X161.216 Y26.839 E.01718
G1 X165.999 Y31.623 E.21392
G1 X165.999 Y31.08 E.01718
G1 X161.759 Y26.839 E.18962
G1 X162.302 Y26.839 E.01718
G1 X165.999 Y30.536 E.16533
G1 X165.999 Y29.993 E.01718
G1 X162.845 Y26.839 E.14104
G1 X163.389 Y26.839 E.01718
G1 X165.999 Y29.45 E.11675
G1 X165.999 Y28.907 E.01718
G1 X163.932 Y26.839 E.09246
G1 X164.475 Y26.839 E.01718
G1 X165.999 Y28.363 E.06816
G1 X165.999 Y27.82 E.01718
G1 X165.018 Y26.839 E.04387
G1 X165.562 Y26.839 E.01718
G1 X166.169 Y27.447 E.02717
M204 S10000
G1 X165.712 Y35.138 F60000
G1 F15000
M204 S8000
G1 X158.87 Y28.296 E.30598
G1 X158.87 Y28.839 E.01718
G1 X164.999 Y34.969 E.2741
G1 X164.456 Y34.969 E.01718
G1 X158.87 Y29.382 E.24981
G1 X158.87 Y29.926 E.01718
G1 X163.913 Y34.969 E.22552
G1 X163.37 Y34.969 E.01718
G1 X158.87 Y30.469 E.20123
G1 X158.87 Y31.012 E.01718
G1 X162.827 Y34.969 E.17694
G1 X162.283 Y34.969 E.01718
G1 X158.87 Y31.555 E.15264
G1 X158.87 Y32.098 E.01718
G1 X161.74 Y34.969 E.12835
G1 X161.197 Y34.969 E.01718
G1 X158.486 Y32.258 E.12122
G1 X157.943 Y32.258 E.01718
G1 X160.654 Y34.969 E.12122
G1 X160.11 Y34.969 E.01718
G1 X157.4 Y32.258 E.12122
G1 X156.856 Y32.258 E.01718
G1 X159.567 Y34.969 E.12122
G1 X159.024 Y34.969 E.01718
G1 X156.313 Y32.258 E.12122
G1 X155.87 Y32.258 E.01402
G1 X155.87 Y32.358 E.00316
G1 X158.481 Y34.969 E.11675
G1 X157.938 Y34.969 E.01718
G1 X155.87 Y32.901 E.09246
G1 X155.87 Y33.444 E.01718
G1 X157.394 Y34.969 E.06817
G1 X156.851 Y34.969 E.01718
G1 X155.87 Y33.988 E.04388
G1 X155.87 Y34.531 E.01718
G1 X156.478 Y35.138 E.02717
; COOLING_NODE: 0
; WIPE_START
G1 X155.87 Y34.531 E-.32657
G1 X155.87 Y34.39 E-.05344
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.61 J1.053 P1  F60000
G1 X170.145 Y26.114 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X171.085 Y26.114 E.02918
G1 X171.085 Y35.694 E.29737
G1 X170.145 Y35.694 E.02918
G1 X170.145 Y26.174 E.29551
M204 S10000
G1 X170.615 Y26.31 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.59094
G1 F13685.632
M204 S8000
G1 X170.615 Y35.498 E.41449
; COOLING_NODE: 0
; WIPE_START
G1 X170.615 Y34.498 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.801 J.916 P1  F60000
G1 X174.725 Y30.904 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X174.725 Y35.694 E.14869
G1 X173.785 Y35.694 E.02918
G1 X173.785 Y26.114 E.29737
G1 X174.725 Y26.114 E.02918
G1 X174.725 Y30.844 E.14682
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X174.725 Y31.844 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.95 J.761 P1  F60000
G1 X178.537 Y27.086 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X178.537 Y26.506 E.01944
G1 X178.833 Y26.506 E.00994
G1 X178.833 Y27.086 E.01944
G1 X178.597 Y27.086 E.00793
; COOLING_NODE: 0
; WIPE_START
G1 X178.537 Y26.506 E-.2216
G1 X178.833 Y26.506 E-.11273
G1 X178.833 Y26.626 E-.04567
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-1.194 J.236 P1  F60000
G1 X179.225 Y28.614 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X183.725 Y28.614 E.13966
G1 X183.725 Y29.444 E.02576
G1 X178.145 Y29.444 E.17321
G1 X178.145 Y26.114 E.10337
G1 X179.225 Y26.114 E.03355
G1 X179.225 Y28.554 E.07574
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X180.225 Y28.567 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-1.174 J-.322 P1  F60000
G1 X178.537 Y34.722 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X178.833 Y34.722 E.00994
G1 X178.833 Y35.302 E.01944
G1 X178.537 Y35.302 E.00994
G1 X178.537 Y34.782 E.01743
; COOLING_NODE: 0
; WIPE_START
G1 X178.833 Y34.722 E-.11501
G1 X178.833 Y35.302 E-.22043
G1 X178.716 Y35.302 E-.04456
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I1.183 J.286 P1  F60000
G1 X179.225 Y33.194 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X179.225 Y35.694 E.0776
G1 X178.145 Y35.694 E.03355
G1 X178.145 Y32.364 E.10337
G1 X183.725 Y32.364 E.17321
G1 X183.725 Y33.194 E.02576
G1 X179.285 Y33.194 E.1378
; WIPE_START
M204 S8000
M73 P86 R3
G1 X179.261 Y34.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I1.089 J-.543 P1  F60000
G1 X178.447 Y32.56 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.25604
G1 F15000
M204 S8000
G1 X178.447 Y34.526 E.03449
M204 S10000
G1 X178.823 Y34.235 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.50818
G1 F15000
M204 S8000
G2 X178.821 Y34.336 I-.029 J.05 E.0092
; WIPE_START
G1 X178.765 Y34.336 E-.09272
G1 X178.736 Y34.286 E-.09576
G1 X178.765 Y34.235 E-.09577
G1 X178.823 Y34.235 E-.09575
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.438 J1.135 P1  F60000
G1 X183.132 Y32.571 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F12000
M204 S2000
G1 X183.517 Y32.956 E.0169
G1 X183.651 Y33.09
G1 X183.148 Y33.12
G1 X183.014 Y32.987
G1 X182.599 Y32.571 E.01823
G1 X182.465 Y32.438
G1 X181.932 Y32.438
G1 X182.066 Y32.571
G1 X182.481 Y32.987 E.01823
G1 X182.615 Y33.12
G1 X182.081 Y33.12
G1 X181.948 Y32.987
G1 X181.533 Y32.571 E.01823
G1 X181.399 Y32.438
G1 X180.866 Y32.438
G1 X180.999 Y32.571
G1 X181.415 Y32.987 E.01823
G1 X181.548 Y33.12
G1 X181.015 Y33.12
G1 X180.881 Y32.987
G1 X180.466 Y32.571 E.01823
G1 X180.332 Y32.438
G1 X179.799 Y32.438
G1 X179.933 Y32.571
G1 X180.348 Y32.987 E.01823
G1 X180.482 Y33.12
G1 X179.948 Y33.12
G1 X179.815 Y32.987
G1 X179.4 Y32.571 E.01823
G1 X179.266 Y32.438
G1 X178.733 Y32.438
G1 X178.866 Y32.571
G1 X179.282 Y32.987 E.01823
G1 X179.415 Y33.12
G1 X179.152 Y33.39
G1 X179.018 Y33.256
G1 X178.58 Y32.819 E.01922
G1 X178.447 Y32.685
G1 X178.447 Y33.218
G1 X178.58 Y33.352
G1 X179.018 Y33.79 E.01922
M204 S10000
G1 X178.97 Y34.08 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.245701
G1 F15000
M204 S8000
G3 X178.561 Y33.778 I2.445 J-3.728 E.00849
M204 S10000
G1 X179.037 Y33.779 F60000
; LINE_WIDTH: 0.212769
G1 F15000
M204 S8000
G1 X178.946 Y33.991 E.00323
G1 X178.928 Y33.998 E.00026
G1 X178.561 Y33.917 E.00525
; WIPE_START
G1 X178.928 Y33.998 E-.22818
G1 X178.946 Y33.991 E-.01137
G1 X179.037 Y33.779 E-.14045
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-.412 J-1.145 P1  F60000
G1 X174.255 Y35.498 Z2.2
G1 Z1.8
G1 E.4 F1800
; LINE_WIDTH: 0.59094
G1 F13685.632
M204 S8000
G1 X174.255 Y26.31 E.41449
; WIPE_START
G1 X174.255 Y27.31 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.008 J1.217 P1  F60000
G1 X178.447 Y27.282 Z2.2
G1 Z1.8
G1 E.4 F1800
; LINE_WIDTH: 0.25604
G1 F15000
M204 S8000
G1 X178.447 Y29.248 E.03449
; WIPE_START
G1 X178.447 Y28.248 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-.148 J1.208 P1  F60000
G1 X183.115 Y28.821 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F12000
M204 S2000
G1 X183.517 Y29.223 E.01765
G1 X183.651 Y29.357
G1 X183.131 Y29.37
G1 X182.997 Y29.237
G1 X182.582 Y28.821 E.01823
G1 X182.448 Y28.688
G1 X181.915 Y28.688
G1 X182.049 Y28.821
G1 X182.464 Y29.237 E.01823
G1 X182.598 Y29.37
G1 X182.064 Y29.37
G1 X181.931 Y29.237
G1 X181.515 Y28.821 E.01823
G1 X181.382 Y28.688
G1 X180.849 Y28.688
G1 X180.982 Y28.821
G1 X181.397 Y29.237 E.01823
G1 X181.531 Y29.37
G1 X180.998 Y29.37
G1 X180.864 Y29.237
G1 X180.449 Y28.821 E.01823
G1 X180.315 Y28.688
G1 X179.782 Y28.688
G1 X179.916 Y28.821
G1 X180.331 Y29.237 E.01823
G1 X180.464 Y29.37
G1 X179.931 Y29.37
G1 X179.798 Y29.237
G1 X179.382 Y28.821 E.01823
G1 X179.018 Y28.457
G1 X178.58 Y28.019 E.01922
G1 X178.447 Y27.886
G1 X178.447 Y28.419
G1 X178.58 Y28.552
G1 X179.264 Y29.237 E.03003
; WIPE_START
M204 S8000
G1 X178.58 Y28.552 E-.36763
G1 X178.557 Y28.529 E-.01237
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
    

    

    
        M9711 M0 E0 U252 V34 Z2.2 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

M204 S10000
G1 X169.392 Y83.627
G1 Z1.8
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X169.530 Y84.929  
M204 S8000
G1  X169.541 Y85.040   E0.0042 F5400
G3  X171.697 Y87.379   I-3.800 J5.665 E0.1220
G3  X171.266 Y89.424   I-1.926 J0.662 E0.0834
G3  X168.285 Y92.541   I-18.599 J-14.802 E0.1641
G3  X165.691 Y92.410   I-1.219 J-1.610 E0.1072
G2  X158.602 Y85.723   I-91.751 J90.161 E0.3704
G2  X153.466 Y85.912   I-2.456 J3.136 E0.2123
G3  X146.475 Y92.513   I-87.553 J-85.721 E0.3655
G3  X143.766 Y92.330   I-1.255 J-1.562 E0.1134
G3  X140.821 Y89.179   I15.816 J-17.735 E0.1641
G3  X141.097 Y86.596   I1.676 J-1.127 E0.1072
G2  X142.755 Y85.020   I-3.532 J-5.375 E0.0874
G1  X142.678 Y84.878   E0.0062
G2  X142.392 Y84.877   I-0.149 J2.412 E0.0109
G1  Y76.127  E0.3326
G1 E-0.4000 F1800
M204 S10000
G1  Y73.627  F600
G1 E0.4000 F1800
M204 S8000
G1  Y71.377  E0.0855 F5400
G2  X143.111 Y71.069   I0.276 J-0.349 E0.0363
G1  X143.097 Y71.050   E0.0009
G3  X140.715 Y68.662   I6.373 J-8.736 E0.1287
G3  X141.018 Y66.330   I1.788 J-0.953 E0.0953
G3  X143.999 Y63.213   I18.593 J14.797 E0.1641
G3  X146.593 Y63.344   I1.219 J1.610 E0.1072
G1  X151.385 Y67.875   E0.2506
G2  X154.736 Y70.981   I18.033 J-16.093 E0.1739
G2  X157.923 Y70.688   I1.399 J-2.259 E0.1305
G1  X165.691 Y63.344   E0.4063
G3  X168.518 Y63.424   I1.373 J1.475 E0.1192
G3  X171.463 Y66.575   I-15.816 J17.735 E0.1641
G3  X171.187 Y69.158   I-1.676 J1.127 E0.1072
G2  X169.173 Y71.069   I5.832 J8.159 E0.1059
G1  X169.317 Y71.376   E0.0129
G2  X169.892 Y71.377   I0.299 J-4.803 E0.0219
G1  Y84.877  E0.5131
G2  X169.530 Y84.929   I-0.152 J0.229 E0.0152
; WIPE_TOWER_END
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
G1 E-.4 F1800
G17
G3 Z2.2 I1.217 J0 P1  F60000
G1 X143.142 Y72.127
G1 Z1.8
G1 E.4 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF0 NF1 ON2 NN0
M204 S8000
G1  X169.142 Y72.127  E2.0691 F7836
G1  Y73.627  E0.1194
G1  X143.142  E2.0691
; NOZZLE_CHANGE_END OF0 NF1 ON2 NN0
M400
M104 T0 S25 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S8000
G1 X144.142 Y73.627 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S10000
G17
G3 Z2.2 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O13
M620 S1A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z4.8 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X140.892 Y74.8773



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
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.8 F3000

M204 S8000


M621 S1A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y320 J1 F10000
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z4.8 F3000

M204 S8000

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I1 H-1 W1 ;enable ams air printing detect
M620 O13
M1002 gcode_claim_action : 0
M106 S51
M106 P2 S102
G1 X142.245 Y94.956 F600
M204 S1000
G1 Z1.8
G17
G3 Z2.2 I0 J-1.217 P1
G1 X138.39 Y94.956 Z2.2
M73 P87 R2
G1 X138.39 Y74.877

; filament start gcode
M109 S145;
G1 X142.892 Y74.877
G1 Z1.8
G1 E2.2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S25
G1  X145.892 Y74.877  E0.1140 F1782
G1 E-0.4000 F1800
M204 S1000
G1  X141.392  F600
G1  X142.892  F240
G1  X143.392  F600
G1  Y75.377 
G1  X142.392 
G1  Y74.377 
G1  X143.892 
G1  Y75.877 
G1  X141.892 
G1  Y73.877 
G1  X145.892 Y74.877   F1782
G1 E0.4000 F1800
M400
M104 T1 S150 N0
M204 S25
G1  X169.392  E0.8931 F1782
G1  Y75.627  E0.0285
G1  X142.892  E1.0072 F2025
G1  Y76.377  E0.0285
G1  X169.392  E1.0072 F2473
G1  Y77.127  E0.0285
G1  X142.892  E1.0072 F4725
G1  Y77.877  E0.0285
G1  X169.392  E1.0072 F4775
G1  Y78.627  E0.0285
M73 P88 R2
G1  X142.892  E1.0072
G1  Y79.377  E0.0285
G1  X169.392  E1.0072
G1  Y80.127  E0.0285
G1  X142.892  E1.0072
G1  Y80.877  E0.0285
G1  X169.392  E1.0072
G1  Y81.627  E0.0285
G1  X142.892  E1.0072
G1  Y82.377  E0.0285
G1  X169.392  E1.0072
G1  Y83.127  E0.0285
G1  X142.892  E1.0072
G1  Y83.877  E0.0285
G1  X169.392  E1.0072
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
G1 X168.392 Y83.877 E-.38
; WIPE_END
M73 P89 R2
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I1.217 J0 P1  F600
; OBJECT_ID: 423
; COOLING_NODE: 0
M204 S1000
G1 X144.537 Y30.904
G1 Z1.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F600
M204 S25
G1 X144.537 Y26.506 E.14738
G1 X146.303 Y26.506 E.05917
G1 X146.303 Y35.302 E.29475
G1 X144.537 Y35.302 E.05917
G1 X144.537 Y30.964 E.14537
; COOLING_NODE: 0
G1 X144.145 Y30.904
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X144.145 Y26.114 E.14869
G1 X146.695 Y26.114 E.07915
G1 X146.695 Y35.694 E.29737
G1 X144.145 Y35.694 E.07915
G1 X144.145 Y30.964 E.14682
; WIPE_START
G1 X144.145 Y29.964 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I1.004 J.688 P1  F600
G1 X145.911 Y27.389 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F600
M204 S25
G1 X145.911 Y26.898 E.01524
G1 X144.929 Y26.898 E.03047
G1 X144.929 Y34.91 E.24868
G1 X145.911 Y34.91 E.03047
G1 X145.911 Y27.449 E.23159
M204 S1000
G1 X145.42 Y34.419
; LINE_WIDTH: 0.6476
M204 S25
M73 P90 R2
G1 X145.42 Y27.449 E.34694
; COOLING_NODE: 0
; WIPE_START
G1 X145.42 Y28.449 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I-.134 J1.21 P1  F600
G1 X167.537 Y30.904 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X167.537 Y26.506 E.14738
G1 X169.303 Y26.506 E.05917
G1 X169.303 Y35.302 E.29475
G1 X167.537 Y35.302 E.05917
G1 X167.537 Y30.964 E.14537
; COOLING_NODE: 0
G1 X167.145 Y30.904
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X167.145 Y26.114 E.14869
G1 X169.695 Y26.114 E.07915
G1 X169.695 Y35.694 E.29737
G1 X167.145 Y35.694 E.07915
G1 X167.145 Y30.964 E.14682
; COOLING_NODE: 0
; WIPE_START
G1 X167.145 Y29.964 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I.067 J-1.215 P1  F600
G1 X157.333 Y29.425 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X157.333 Y30.721 E.04343
G1 X154.303 Y30.721 E.10154
G1 X154.303 Y35.302 E.15352
G1 X152.537 Y35.302 E.05917
G1 X152.537 Y26.506 E.29475
G1 X154.303 Y26.506 E.05917
G1 X154.303 Y29.425 E.09781
G1 X157.273 Y29.425 E.09953
; COOLING_NODE: 0
M73 P91 R2
G1 X157.725 Y29.033
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X157.725 Y31.113 E.06457
G1 X154.695 Y31.113 E.09405
G1 X154.695 Y35.694 E.14221
G1 X152.145 Y35.694 E.07915
G1 X152.145 Y26.114 E.29737
G1 X154.695 Y26.114 E.07915
G1 X154.695 Y29.033 E.0906
G1 X157.665 Y29.033 E.09219
; WIPE_START
G1 X157.693 Y30.032 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I-.872 J-.849 P1  F600
G1 X153.42 Y34.419 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.6476
M73 P91 R1
G1 F600
M204 S25
G1 X153.42 Y30.577 E.19123
M204 S1000
G1 X156.907 Y30.295
; LINE_WIDTH: 0.488061
M204 S25
G1 X156.907 Y29.851 E.01629
G1 X154.08 Y29.851 E.1036
; LINE_WIDTH: 0.471763
G1 X154.005 Y29.781 E.00361
; LINE_WIDTH: 0.420212
G1 X153.93 Y29.711 E.00318
G1 X153.911 Y29.543 E.00526
G1 X153.911 Y26.898 E.08214
G1 X152.929 Y26.898 E.03049
G1 X152.929 Y34.91 E.24883
G1 X153.911 Y34.91 E.03049
G1 X153.911 Y30.517 E.13643
G1 X153.986 Y30.352 E.00565
; LINE_WIDTH: 0.486364
G1 X154.099 Y30.295 E.00461
G1 X156.847 Y30.295 E.10031
M204 S1000
G1 X153.758 Y30.073
; LINE_WIDTH: 0.41792
M204 S25
G1 X153.644 Y29.962 E.00492
; LINE_WIDTH: 0.440886
G1 X153.599 Y29.878 E.00311
; LINE_WIDTH: 0.486818
G1 X153.554 Y29.794 E.00347
; LINE_WIDTH: 0.53275
G1 X153.509 Y29.71 E.00383
; LINE_WIDTH: 0.578682
G1 X153.464 Y29.627 E.00419
; LINE_WIDTH: 0.624614
G1 X153.42 Y29.543 E.00455
; LINE_WIDTH: 0.624629
G1 X153.399 Y29.609 E.00331
; LINE_WIDTH: 0.578728
G1 X153.378 Y29.675 E.00305
; LINE_WIDTH: 0.532826
G1 X153.358 Y29.741 E.00279
; LINE_WIDTH: 0.486925
G1 X153.337 Y29.807 E.00253
; LINE_WIDTH: 0.441023
G1 X153.316 Y29.873 E.00227
; LINE_WIDTH: 0.395121
G1 X153.296 Y29.939 E.002
; LINE_WIDTH: 0.395123
G1 X153.316 Y30.035 E.00286
; LINE_WIDTH: 0.441028
G1 X153.337 Y30.131 E.00323
; LINE_WIDTH: 0.486933
G1 X153.358 Y30.228 E.0036
; LINE_WIDTH: 0.532838
G1 X153.378 Y30.324 E.00398
; LINE_WIDTH: 0.578743
G1 X153.399 Y30.421 E.00435
; LINE_WIDTH: 0.624648
G1 X153.42 Y30.517 E.00472
; LINE_WIDTH: 0.624632
G1 X153.48 Y30.438 E.00478
; LINE_WIDTH: 0.578696
G1 X153.54 Y30.358 E.0044
; LINE_WIDTH: 0.53276
G1 X153.601 Y30.279 E.00402
; LINE_WIDTH: 0.486824
G1 X153.661 Y30.2 E.00364
; LINE_WIDTH: 0.440888
G1 X153.722 Y30.12 E.00327
M204 S1000
G1 X153.42 Y27.389
; LINE_WIDTH: 0.64758
M204 S25
G1 X153.42 Y29.483 E.10422
; WIPE_START
G1 X153.42 Y28.483 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I-.493 J1.113 P1  F600
G1 X167.929 Y34.91 Z2.2
G1 Z1.8
G1 E.6 F1800
; LINE_WIDTH: 0.41999
G1 F600
M204 S25
G1 X168.911 Y34.91 E.03047
G1 X168.911 Y26.898 E.24868
G1 X167.929 Y26.898 E.03047
G1 X167.929 Y34.85 E.24682
M204 S1000
G1 X168.42 Y34.419
; LINE_WIDTH: 0.64758
M204 S25
M73 P92 R1
G1 X168.42 Y27.449 E.34693
; COOLING_NODE: 0
; WIPE_START
G1 X168.42 Y28.449 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I.028 J1.217 P1  F600
G1 X179.645 Y28.194 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F600
M204 S25
G1 X179.645 Y26.114 E.06457
G1 X183.695 Y26.114 E.12569
G1 X183.695 Y28.194 E.06457
G1 X179.705 Y28.194 E.12383
; COOLING_NODE: 0
; WIPE_START
G1 X179.677 Y27.194 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I-.812 J-.906 P1  F600
G1 X175.537 Y30.904 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F600
M204 S25
G1 X175.537 Y26.506 E.14738
G1 X177.303 Y26.506 E.05917
G1 X177.303 Y30.256 E.12566
G1 X178.358 Y30.256 E.03536
G1 X178.358 Y31.552 E.04343
G1 X177.303 Y31.552 E.03536
G1 X177.303 Y35.302 E.12566
G1 X175.537 Y35.302 E.05917
G1 X175.537 Y30.964 E.14537
; COOLING_NODE: 0
G1 X175.145 Y30.904
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 X175.145 Y26.114 E.14869
G1 X177.695 Y26.114 E.07915
G1 X177.695 Y29.864 E.1164
G1 X183.695 Y29.864 E.18624
G1 X183.695 Y31.944 E.06457
G1 X177.695 Y31.944 E.18624
G1 X177.695 Y35.694 E.1164
G1 X175.145 Y35.694 E.07915
G1 X175.145 Y30.964 E.14682
; COOLING_NODE: 0
; WIPE_START
G1 X175.145 Y29.964 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I-.767 J.945 P1  F600
G1 X179.645 Y33.614 Z2.2
G1 Z1.8
G1 E.6 F1800
G1 F600
M204 S25
M73 P93 R1
G1 X183.695 Y33.614 E.12569
G1 X183.695 Y35.694 E.06457
G1 X179.645 Y35.694 E.12569
G1 X179.645 Y33.674 E.0627
; WIPE_START
G1 X180.645 Y33.659 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I-.092 J1.213 P1  F600
G1 X182.783 Y33.821 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Top surface
G1 F600
M204 S25
G1 X183.487 Y34.526 E.03093
G1 X183.621 Y34.66
G1 X183.621 Y35.193
G1 X183.487 Y35.059
G1 X182.249 Y33.821 E.05434
G1 X182.116 Y33.688
G1 X181.582 Y33.688
G1 X181.716 Y33.821
G1 X183.381 Y35.487 E.0731
G1 X183.515 Y35.62
G1 X182.982 Y35.62
G1 X182.848 Y35.487
G1 X181.183 Y33.821 E.0731
G1 X181.049 Y33.688
G1 X180.516 Y33.688
G1 X180.65 Y33.821
G1 X182.315 Y35.487 E.0731
G1 X182.448 Y35.62
G1 X181.915 Y35.62
G1 X181.782 Y35.487
G1 X180.116 Y33.821 E.0731
G1 X179.983 Y33.688
G1 X179.719 Y33.957
G1 X179.853 Y34.091
G1 X181.248 Y35.487 E.06126
G1 X181.382 Y35.62
G1 X180.849 Y35.62
G1 X180.715 Y35.487
G1 X179.853 Y34.624 E.03785
; WIPE_START
G1 X180.56 Y35.331 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I.262 J-1.188 P1  F600
G1 X176.42 Y34.419 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.64758
G1 F600
M204 S25
G1 X176.42 Y31.408 E.14985
M204 S1000
G1 X176.296 Y30.77
; LINE_WIDTH: 0.39514
M204 S25
G1 X176.316 Y30.866 E.00286
; LINE_WIDTH: 0.441038
G1 X176.337 Y30.963 E.00323
; LINE_WIDTH: 0.486936
G1 X176.358 Y31.059 E.0036
; LINE_WIDTH: 0.532835
G1 X176.378 Y31.156 E.00398
; LINE_WIDTH: 0.578733
G1 X176.399 Y31.252 E.00435
; LINE_WIDTH: 0.624631
G1 X176.42 Y31.348 E.00472
; LINE_WIDTH: 0.624614
G1 X176.487 Y31.259 E.00535
; LINE_WIDTH: 0.578682
G1 X176.555 Y31.171 E.00493
; LINE_WIDTH: 0.53275
G1 X176.623 Y31.082 E.00451
; LINE_WIDTH: 0.486818
G1 X176.69 Y30.993 E.00408
; LINE_WIDTH: 0.427386
G1 X176.758 Y30.904 E.00354
G1 X176.644 Y30.793 E.00504
; LINE_WIDTH: 0.440886
G1 X176.599 Y30.709 E.00311
; LINE_WIDTH: 0.486818
G1 X176.554 Y30.626 E.00347
; LINE_WIDTH: 0.53275
G1 X176.509 Y30.542 E.00383
; LINE_WIDTH: 0.578682
G1 X176.464 Y30.458 E.00419
; LINE_WIDTH: 0.624614
G1 X176.42 Y30.374 E.00455
; LINE_WIDTH: 0.624631
G1 X176.402 Y30.431 E.00283
; LINE_WIDTH: 0.578733
G1 X176.384 Y30.487 E.00261
; LINE_WIDTH: 0.532835
G1 X176.367 Y30.543 E.00238
; LINE_WIDTH: 0.486936
G1 X176.349 Y30.6 E.00216
; LINE_WIDTH: 0.441038
G1 X176.331 Y30.656 E.00194
; LINE_WIDTH: 0.39514
G1 X176.314 Y30.713 E.00171
M204 S1000
G1 X175.929 Y30.578
; LINE_WIDTH: 0.420225
M204 S25
G1 X175.929 Y34.91 E.13455
G1 X176.911 Y34.91 E.03049
G1 X176.911 Y31.348 E.11062
G1 X176.986 Y31.183 E.00565
; LINE_WIDTH: 0.484979
G1 X177.099 Y31.126 E.0046
G1 X177.932 Y31.126 E.03031
G1 X177.932 Y30.682 E.01617
G1 X177.099 Y30.682 E.03031
G1 X176.986 Y30.625 E.0046
; LINE_WIDTH: 0.420243
G1 X176.911 Y30.46 E.00565
G1 X176.911 Y26.898 E.11062
G1 X175.929 Y26.898 E.03049
G1 X175.929 Y30.518 E.11243
M204 S1000
G1 X176.42 Y27.389
; LINE_WIDTH: 0.64758
M204 S25
G1 X176.42 Y30.314 E.1456
; WIPE_START
G1 X176.42 Y29.314 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I-.249 J1.191 P1  F600
G1 X183.487 Y30.793 Z2.2
G1 Z1.8
G1 E.6 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F600
M204 S25
G1 X182.765 Y30.071 E.03169
G1 X182.632 Y29.938
G1 X182.099 Y29.938
G1 X182.232 Y30.071
G1 X183.487 Y31.326 E.0551
G1 X183.621 Y31.46
G1 X183.498 Y31.87
G1 X183.364 Y31.737
G1 X181.699 Y30.071 E.0731
G1 X181.565 Y29.938
G1 X181.032 Y29.938
G1 X181.166 Y30.071
G1 X182.831 Y31.737 E.0731
G1 X182.965 Y31.87
G1 X182.431 Y31.87
G1 X182.298 Y31.737
M632 S0 N R W
M400
M104 T0 S210 N0 ;Multi extruder pre heating
M633
G1 X180.632 Y30.071 E.0731
G1 X180.499 Y29.938
G1 X179.965 Y29.938
G1 X180.099 Y30.071
G1 X181.764 Y31.737 E.0731
G1 X181.898 Y31.87
G1 X181.365 Y31.87
G1 X181.231 Y31.737
G1 X179.566 Y30.071 E.0731
G1 X179.432 Y29.938
G1 X178.899 Y29.938
G1 X179.033 Y30.071
G1 X180.698 Y31.737 E.0731
G1 X180.831 Y31.87
G1 X180.298 Y31.87
G1 X180.165 Y31.737
G1 X178.58 Y30.152 E.06955
G1 X178.447 Y30.019
M73 P94 R1
G1 X178.447 Y30.552
G1 X178.58 Y30.686
G1 X179.631 Y31.737 E.04614
G1 X179.765 Y31.87
G1 X179.232 Y31.87
G1 X179.098 Y31.737
G1 X178.58 Y31.219 E.02273
; WIPE_START
G1 X179.098 Y31.737 E-.27828
G1 X179.232 Y31.87 E-.07182
G1 X179.31 Y31.87 E-.02991
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I1.035 J.641 P1  F600
G1 X182.748 Y26.321 Z2.2
G1 Z1.8
G1 E.6 F1800
G1 F600
M204 S25
G1 X183.487 Y27.06 E.03244
G1 X183.621 Y27.194
G1 X183.621 Y27.727
G1 X183.487 Y27.594
G1 X182.215 Y26.321 E.05585
G1 X182.081 Y26.188
G1 X181.548 Y26.188
G1 X181.682 Y26.321
G1 X183.347 Y27.987 E.0731
G1 X183.481 Y28.12
G1 X182.947 Y28.12
G1 X182.814 Y27.987
G1 X181.148 Y26.321 E.0731
G1 X181.015 Y26.188
G1 X180.482 Y26.188
G1 X180.615 Y26.321
G1 X182.28 Y27.987 E.0731
G1 X182.414 Y28.12
G1 X181.881 Y28.12
G1 X181.747 Y27.987
G1 X180.082 Y26.321 E.0731
G1 X179.948 Y26.188
G1 X179.719 Y26.492
G1 X179.853 Y26.625
G1 X181.214 Y27.987 E.05975
G1 X181.348 Y28.12
G1 X180.814 Y28.12
G1 X180.681 Y27.987
G1 X179.853 Y27.159 E.03634
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 10/12
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
M106 S89.25
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
G1 F600
M204 S25
G1 X180.56 Y27.866 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S1000
G17
G3 Z2.2 I1.217 J0 P1  F600
G1 X143.142 Y73.127
G1 Z2
G1 E.6 F1800
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 1.000000
; NOZZLE_CHANGE_START OF1 NF0 ON0 NN2
M204 S25
G1  X169.142 Y73.127  E2.0691 F7836
; NOZZLE_CHANGE_END OF1 NF0 ON0 NN2
M400
M104 T1 S25 N0 ;Multi extruder pre cooling

; WIPE_START
G1 F5400
M204 S25
G1 X168.142 Y73.127 E-1.9
; WIPE_END
G1 E-.1 F1800
M204 S1000
G17
G3 Z2.4 I1.217 J0 P1  F5400
; filament end gcode 

;======== H2C filament_change ========
;===== 20260409 =====
M993 A2 B2 C2 ; nozzle cam detection allow status save.
M993 A0 B0 C0 ; nozzle cam detection not allowed.


M1015.4 S1 K0 ;disable E air printing detect


M620 O14
M620 S0A H-1
M1002 gcode_claim_action : 4
M204 S9000

G1 Z5 F1200

M400
M106 P1 S0
M106 P2 S0




    M620.14 X171.392 Y83.3773



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
M73 P95 R1
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z5 F3000

M204 S25


M621 S0A

M622.1 S0 ;for prev version, default skip
M1002 judge_flag powerloss_resume_flag
M622 J1
M983.3 F10.4167 A0.4 R2
M400

G387 Y320 J1 F10000
G1 X174.895 F30000

G387 Y295 J1 F30000
G387 Y265 J1 F18000
G1 Z5 F3000

M204 S25

M1002 set_flag powerloss_resume_flag=0
M623

M993 A3 B3 C3 ; nozzle cam detection allow status restore.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I0 H-1 W1 ;enable ams air printing detect
M620 O14
M1002 gcode_claim_action : 0
M106 S191.25
M106 P2 S191
G1 X173.895 Y83.377 F60000
M204 S10000
G1 Z2

; filament start gcode
G17
G3 Z2.4 I0 J-1.217 P1
G1 X169.392 Y83.377 Z2.4
G1 Z2
G1 E2 F1800

G4 S0
; CP_TOOLCHANGE_WIPE CT0 FL0
; LINE_WIDTH: 0.500000
M204 S8000
G1  X166.392 Y83.377  E0.1140 F1782
G1 E-0.4000 F1800
M204 S10000
G1  X170.892  F600
G1  X169.392  F240
G1  X169.892  F600
G1  Y83.877 
G1  X168.892 
G1  Y82.877 
G1  X170.392 
G1  Y84.377 
G1  X168.392 
G1  Y82.377 
G1  X166.392 Y83.377   F1782
G1 E0.4000 F1800
M400
M104 T0 S220 N0
M204 S8000
G1  X142.892  E0.8931 F1782
G1  Y82.627  E0.0285
G1  X169.392  E1.0072 F2025
G1  Y81.877  E0.0285
G1  X142.892  E1.0072 F2473
M73 P95 R0
G1  Y81.127  E0.0285
G1  X169.392  E1.0072 F4725
G1  Y80.377  E0.0285
G1  X142.892  E1.0072 F4775
G1  Y79.627  E0.0285
G1  X169.392  E1.0072
G1  Y78.877  E0.0285
G1  X142.892  E1.0072
G1  Y78.127  E0.0285
G1  X169.392  E1.0072
G1  Y77.377  E0.0285
G1  X142.892  E1.0072
G1  Y76.627  E0.0285
G1  X169.392  E1.0072
G1  Y75.877  E0.0285
G1  X142.892  E1.0072
G1  Y75.127  E0.0285
G1  X169.392  E1.0072
G1  Y74.377  E0.0285
M73 P96 R0
G1  X142.892  E1.0072
; WIPE_TOWER_END
M220 R
G1 F60000
G4 S0
G92 E0
M106 S255
; CP TOOLCHANGE END
;------------------


G1  Y83.127   F5400.000000
; LAYER_HEIGHT: 0.200000
; FEATURE: Prime tower
; LINE_WIDTH: 0.500000
; WIPE_TOWER_START
M204 S10000
G1  X142.967 Y84.378  
M204 S8000
G2  X142.392 Y84.377   I-0.299 J4.803 E0.0219
G1  Y72.377  E0.4561
G2  X143.794 Y72.246   I0.553 J-1.647 E0.0551
G2  X143.772 Y71.687   I-0.299 J-0.268 E0.0235
G3  X140.796 Y68.797   I10.719 J-14.017 E0.1580
G3  X141.018 Y66.330   I1.682 J-1.092 E0.1014
G3  X143.999 Y63.213   I18.593 J14.797 E0.1641
G3  X146.593 Y63.344   I1.219 J1.610 E0.1072
G1  X151.549 Y68.030   E0.2592
G2  X154.937 Y71.200   I19.728 J-17.690 E0.1766
G2  X157.595 Y70.998   I1.203 J-1.766 E0.1094
G1  X165.691 Y63.344   E0.4234
G3  X168.518 Y63.424   I1.373 J1.475 E0.1192
G3  X171.463 Y66.575   I-15.816 J17.735 E0.1641
G3  X171.187 Y69.158   I-1.676 J1.127 E0.1072
G2  X168.479 Y71.721   I20.164 J24.007 E0.1418
G2  X168.787 Y72.377   I0.308 J0.255 E0.0344
G1  X169.892  E0.0420
G1  Y82.127  E0.3706
G1 E-0.4000 F1800
M204 S10000
G1  X169.642 Y84.377   F600
G1 E0.4000 F1800
M204 S8000
G2  X169.143 Y84.549   I-0.187 J0.267 E0.0234 F5400
G1  X169.187 Y84.704   E0.0061
G3  X171.569 Y87.092   I-6.374 J8.738 E0.1287
G3  X171.266 Y89.424   I-1.788 J0.953 E0.0953
G3  X168.285 Y92.541   I-18.599 J-14.802 E0.1641
G3  X165.691 Y92.410   I-1.219 J-1.610 E0.1072
G2  X157.780 Y84.940   I-102.603 J100.743 E0.4136
G2  X154.361 Y85.066   I-1.635 J2.088 E0.1413
G1  X146.593 Y92.410   E0.4063
G3  X143.766 Y92.330   I-1.373 J-1.475 E0.1192
G3  X140.821 Y89.179   I15.823 J-17.741 E0.1641
G3  X141.097 Y86.596   I1.676 J-1.127 E0.1072
G2  X143.111 Y84.685   I-5.832 J-8.159 E0.1059
G1  X142.967 Y84.378   E0.0129
; WIPE_TOWER_END

; WIPE_START
M204 S8000
G1 X142.991 Y84.383 E-.00903
G1 X143.014 Y84.39 E-.00905
G1 X143.035 Y84.4 E-.00901
G1 X143.056 Y84.412 E-.00904
G1 X143.075 Y84.426 E-.00901
G1 X143.092 Y84.443 E-.00903
G1 X143.106 Y84.461 E-.00903
G1 X143.119 Y84.482 E-.00902
G1 X143.129 Y84.503 E-.00905
G1 X143.137 Y84.526 E-.00902
G1 X143.141 Y84.549 E-.00903
G1 X143.143 Y84.573 E-.00903
G1 X143.142 Y84.596 E-.00903
G1 X143.139 Y84.62 E-.00903
G1 X143.132 Y84.643 E-.00903
G1 X143.123 Y84.665 E-.00902
G1 X143.111 Y84.685 E-.00903
G1 X143.097 Y84.704 E-.00903
G1 X143.081 Y84.722 E-.00903
G1 X142.682 Y85.099 E-.20844
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I1.217 J0 P1  F60000
; OBJECT_ID: 423
; COOLING_NODE: 0
M204 S10000
G1 X147.833 Y26.506
G1 Z2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X147.833 Y29.702 E.10709
G1 X147.833 Y30.102 E.0134
G1 X147.833 Y30.502 E.0134
G1 X147.833 Y30.902 E.0134
G1 X147.833 Y31.302 E.0134
G1 X147.833 Y31.702 E.0134
G1 X147.833 Y32.102 E.0134
G1 X147.833 Y32.502 E.0134
G1 X147.833 Y32.902 E.0134
G1 X147.833 Y33.302 E.0134
G1 X147.833 Y33.702 E.0134
G1 X147.833 Y34.102 E.0134
G1 F5198.651
G1 X147.833 Y34.502 E.0134
G1 F4343.455
G1 X147.833 Y34.902 E.0134
G1 F3565.06
G1 X147.833 Y35.302 E.0134
G1 F2863.465
G1 X147.517 Y35.302 E.01057
G1 F2364.214
G1 X147.117 Y35.302 E.0134
G1 F1800
G1 X146.722 Y35.302 E.01323
M106 S191.25
M106 S255
G1 F2364.214
G1 X146.322 Y35.302 E.0134
G1 F3005.227
G1 X145.922 Y35.302 E.0134
G1 F3723.041
G1 X145.522 Y35.302 E.0134
G1 F4517.655
G1 X145.122 Y35.302 E.0134
G1 F5389.068
G1 X144.722 Y35.302 E.0134
G1 F6000
G1 X144.322 Y35.302 E.0134
G1 X143.922 Y35.302 E.0134
G1 X143.522 Y35.302 E.0134
G1 X143.122 Y35.302 E.0134
G1 X142.722 Y35.302 E.0134
G1 X142.322 Y35.302 E.0134
G1 X141.922 Y35.302 E.0134
G1 X141.522 Y35.302 E.0134
G1 X141.122 Y35.302 E.0134
G1 X140.722 Y35.302 E.0134
G1 X138.537 Y35.302 E.07324
G1 X138.537 Y26.506 E.29475
G1 X140.722 Y26.506 E.07324
G1 X141.122 Y26.506 E.0134
G1 X141.522 Y26.506 E.0134
G1 X141.922 Y26.506 E.0134
G1 X142.322 Y26.506 E.0134
G1 X142.722 Y26.506 E.0134
G1 X143.122 Y26.506 E.0134
G1 X143.522 Y26.506 E.0134
G1 X143.922 Y26.506 E.0134
G1 X144.322 Y26.506 E.0134
G1 X144.722 Y26.506 E.0134
G1 F5389.068
G1 X145.122 Y26.506 E.0134
G1 F4517.655
G1 X145.522 Y26.506 E.0134
G1 F3723.041
G1 X145.922 Y26.506 E.0134
G1 F3005.227
G1 X146.322 Y26.506 E.0134
G1 F2364.214
G1 X146.722 Y26.506 E.0134
G1 F1800
G1 X147.117 Y26.506 E.01323
M106 S191.25
M106 S255
G1 F2364.214
G1 X147.517 Y26.506 E.0134
G1 F2764.849
G1 X147.773 Y26.506 E.00856
; COOLING_NODE: 0
M204 S250
G1 X148.225 Y26.114 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X148.225 Y32.494 E.19804
G1 X148.225 Y32.894 E.01242
G1 X148.225 Y33.294 E.01242
G1 X148.225 Y33.694 E.01242
G1 X148.225 Y34.094 E.01242
G1 X148.225 Y34.494 E.01242
G1 X148.225 Y34.894 E.01242
G1 F5413.922
G1 X148.225 Y35.294 E.01242
G1 F4540.413
G1 X148.225 Y35.694 E.01242
G1 F3743.703
G1 X147.904 Y35.694 E.00997
G1 F3159.716
G1 X147.504 Y35.694 E.01242
G1 F2501.458
G1 X147.104 Y35.694 E.01242
G1 F1920
G1 X146.736 Y35.694 E.01142
G1 F2501.458
G1 X146.336 Y35.694 E.01242
G1 F3159.716
G1 X145.936 Y35.694 E.01242
G1 F3894.774
G1 X145.536 Y35.694 E.01242
G1 F4706.632
G1 X145.136 Y35.694 E.01242
G1 F5595.29
G1 X144.736 Y35.694 E.01242
G1 F6000
G1 X144.336 Y35.694 E.01242
G1 X143.936 Y35.694 E.01242
G1 X143.536 Y35.694 E.01242
G1 X143.136 Y35.694 E.01242
G1 X142.736 Y35.694 E.01242
G1 X142.336 Y35.694 E.01242
G1 X138.145 Y35.694 E.1301
G1 X138.145 Y26.114 E.29737
G1 X142.336 Y26.114 E.1301
G1 X142.736 Y26.114 E.01242
G1 X143.136 Y26.114 E.01242
G1 X143.536 Y26.114 E.01242
G1 X143.936 Y26.114 E.01242
G1 X144.336 Y26.114 E.01242
G1 X144.736 Y26.114 E.01242
G1 F5595.29
G1 X145.136 Y26.114 E.01242
G1 F4706.632
G1 X145.536 Y26.114 E.01242
G1 F3894.774
G1 X145.936 Y26.114 E.01242
G1 F3159.716
G1 X146.336 Y26.114 E.01242
G1 F2501.458
G1 X146.736 Y26.114 E.01242
G1 F1920
G1 X147.104 Y26.114 E.01142
G1 F2501.458
G1 X147.504 Y26.114 E.01242
G1 F3159.716
G1 X147.904 Y26.114 E.01242
G1 F3630.821
G1 X148.165 Y26.114 E.0081
; WIPE_START
M204 S8000
G1 X148.174 Y27.114 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I-1.202 J-.193 P1  F60000
G1 X146.886 Y35.138 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42991
G1 F15000
M204 S8000
G1 X147.499 Y34.525 E.02764
G1 X147.499 Y33.978 E.01743
G1 X146.508 Y34.969 E.04466
G1 X145.961 Y34.969 E.01743
G1 X147.499 Y33.43 E.06931
G1 X147.499 Y32.883 E.01743
G1 X145.414 Y34.969 E.09397
G1 X144.866 Y34.969 E.01743
G1 X147.499 Y32.336 E.11863
G1 X147.499 Y31.788 E.01743
G1 X144.319 Y34.969 E.14328
G1 X143.772 Y34.969 E.01743
G1 X147.499 Y31.241 E.16794
G1 X147.499 Y30.694 E.01743
G1 X143.224 Y34.969 E.19259
G1 X142.677 Y34.969 E.01743
G1 X147.499 Y30.147 E.21725
G1 X147.499 Y29.599 E.01743
G1 X142.13 Y34.969 E.24191
G1 X141.583 Y34.969 E.01743
G1 X147.499 Y29.052 E.26656
G1 X147.499 Y28.505 E.01743
G1 X141.035 Y34.969 E.29122
G1 X140.488 Y34.969 E.01743
G1 X147.499 Y27.957 E.31588
G1 X147.499 Y27.41 E.01743
G1 X139.941 Y34.969 E.34053
G1 X139.393 Y34.969 E.01743
G1 X147.499 Y26.863 E.36519
G1 X147.499 Y26.839 E.00075
G1 X146.976 Y26.839 E.01668
G1 X138.87 Y34.945 E.36519
G1 X138.87 Y34.398 E.01743
G1 X146.428 Y26.839 E.34053
G1 X145.881 Y26.839 E.01743
G1 X138.87 Y33.85 E.31587
G1 X138.87 Y33.303 E.01743
G1 X145.334 Y26.839 E.29122
G1 X144.787 Y26.839 E.01743
G1 X138.87 Y32.756 E.26656
G1 X138.87 Y32.209 E.01743
G1 X144.239 Y26.839 E.2419
G1 X143.692 Y26.839 E.01743
G1 X138.87 Y31.661 E.21725
G1 X138.87 Y31.114 E.01743
G1 X143.145 Y26.839 E.19259
G1 X142.597 Y26.839 E.01743
G1 X138.87 Y30.567 E.16794
G1 X138.87 Y30.019 E.01743
G1 X142.05 Y26.839 E.14328
G1 X141.503 Y26.839 E.01743
G1 X138.87 Y29.472 E.11862
G1 X138.87 Y28.925 E.01743
G1 X140.956 Y26.839 E.09397
G1 X140.408 Y26.839 E.01743
G1 X138.87 Y28.378 E.06931
G1 X138.87 Y27.83 E.01743
G1 X139.861 Y26.839 E.04465
G1 X139.314 Y26.839 E.01743
G1 X138.7 Y27.453 E.02764
; COOLING_NODE: 0
; WIPE_START
G1 X139.314 Y26.839 E-.32973
G1 X139.446 Y26.839 E-.05028
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I.035 J1.216 P1  F60000
G1 X151.037 Y26.506 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X151.522 Y26.506 E.01627
G1 X151.922 Y26.506 E.0134
G1 X152.322 Y26.506 E.0134
G1 X152.722 Y26.506 E.0134
G1 F5389.068
G1 X153.122 Y26.506 E.0134
G1 F4517.655
G1 X153.522 Y26.506 E.0134
G1 F3723.041
G1 X153.922 Y26.506 E.0134
G1 F3005.227
G1 X154.322 Y26.506 E.0134
G1 F2364.214
G1 X154.722 Y26.506 E.0134
G1 F1800
G1 X155.117 Y26.506 E.01323
M106 S191.25
M106 S255
G1 F2364.214
G1 X155.517 Y26.506 E.0134
G1 F3005.227
G1 X155.917 Y26.506 E.0134
G1 F3723.041
G1 X156.317 Y26.506 E.0134
G1 F4517.655
G1 X156.717 Y26.506 E.0134
G1 F5389.068
G1 X157.117 Y26.506 E.0134
G1 F6000
G1 X157.517 Y26.506 E.0134
G1 X157.917 Y26.506 E.0134
G1 X158.317 Y26.506 E.0134
G1 X158.717 Y26.506 E.0134
G1 X159.117 Y26.506 E.0134
G1 X159.517 Y26.506 E.0134
G1 X159.917 Y26.506 E.0134
G1 X160.317 Y26.506 E.0134
G1 X160.717 Y26.506 E.0134
G1 X161.117 Y26.506 E.0134
G1 X163.722 Y26.506 E.0873
G1 X164.122 Y26.506 E.0134
G1 X164.522 Y26.506 E.0134
G1 X164.922 Y26.506 E.0134
G1 X165.322 Y26.506 E.0134
G1 X165.722 Y26.506 E.0134
G1 X166.122 Y26.506 E.0134
G1 X166.522 Y26.506 E.0134
G1 X166.922 Y26.506 E.0134
G1 X167.322 Y26.506 E.0134
G1 X167.722 Y26.506 E.0134
G1 F5389.068
G1 X168.122 Y26.506 E.0134
G1 F4517.655
G1 X168.522 Y26.506 E.0134
G1 F3723.041
G1 X168.922 Y26.506 E.0134
G1 F3005.227
G1 X169.322 Y26.506 E.0134
G1 F2364.214
G1 X169.722 Y26.506 E.0134
G1 F1800
G1 X170.117 Y26.506 E.01323
M106 S191.25
M106 S255
G1 F2636.193
G1 X170.693 Y26.506 E.01929
G1 F3310.926
G1 X170.693 Y26.906 E.0134
G1 F4062.459
G1 X170.693 Y27.306 E.0134
G1 F4890.791
G1 X170.693 Y27.706 E.0134
G1 F5795.924
G1 X170.693 Y28.106 E.0134
G1 F6000
G1 X170.693 Y28.506 E.0134
G1 X170.693 Y28.906 E.0134
G1 X170.693 Y29.306 E.0134
G1 X170.693 Y29.706 E.0134
G1 X170.693 Y30.106 E.0134
G1 X170.693 Y30.506 E.0134
G1 X170.693 Y30.906 E.0134
G1 X170.693 Y31.302 E.01327
G1 X170.693 Y31.702 E.0134
G1 X170.693 Y32.102 E.0134
G1 X170.693 Y32.502 E.0134
G1 X170.693 Y32.902 E.0134
G1 X170.693 Y33.302 E.0134
G1 X170.693 Y33.702 E.0134
G1 F5795.924
G1 X170.693 Y34.102 E.0134
G1 F4890.791
G1 X170.693 Y34.502 E.0134
G1 F4062.459
G1 X170.693 Y34.902 E.0134
G1 F3310.926
G1 X170.693 Y35.302 E.0134
G1 F2636.193
G1 X170.117 Y35.302 E.01929
G1 F1800
G1 X169.722 Y35.302 E.01323
M106 S191.25
M106 S255
G1 F2364.214
G1 X169.322 Y35.302 E.0134
G1 F3005.227
G1 X168.922 Y35.302 E.0134
G1 F3723.041
G1 X168.522 Y35.302 E.0134
G1 F4517.655
G1 X168.122 Y35.302 E.0134
G1 F5389.068
G1 X167.722 Y35.302 E.0134
G1 F6000
G1 X167.322 Y35.302 E.0134
G1 X166.922 Y35.302 E.0134
G1 X166.522 Y35.302 E.0134
G1 X166.122 Y35.302 E.0134
G1 X165.722 Y35.302 E.0134
G1 X165.322 Y35.302 E.0134
G1 X164.922 Y35.302 E.0134
G1 X164.522 Y35.302 E.0134
G1 X164.122 Y35.302 E.0134
G1 X163.722 Y35.302 E.0134
G1 X161.117 Y35.302 E.0873
G1 X160.717 Y35.302 E.0134
G1 X160.317 Y35.302 E.0134
G1 X159.917 Y35.302 E.0134
G1 X159.517 Y35.302 E.0134
G1 X159.117 Y35.302 E.0134
G1 X158.717 Y35.302 E.0134
G1 X158.317 Y35.302 E.0134
G1 X157.917 Y35.302 E.0134
G1 X157.517 Y35.302 E.0134
G1 X157.117 Y35.302 E.0134
G1 F5389.068
G1 X156.717 Y35.302 E.0134
G1 F4517.655
G1 X156.317 Y35.302 E.0134
G1 F3723.041
G1 X155.917 Y35.302 E.0134
G1 F3005.227
G1 X155.517 Y35.302 E.0134
G1 F2364.214
G1 X155.117 Y35.302 E.0134
G1 F1800
G1 X154.722 Y35.302 E.01323
M106 S191.25
G1 F2364.214
G1 X154.322 Y35.302 E.0134
G1 F3005.227
G1 X153.922 Y35.302 E.0134
G1 F3723.041
G1 X153.522 Y35.302 E.0134
G1 F4517.655
G1 X153.122 Y35.302 E.0134
G1 F5389.068
G1 X152.722 Y35.302 E.0134
G1 F6000
G1 X152.322 Y35.302 E.0134
G1 X151.922 Y35.302 E.0134
G1 X151.522 Y35.302 E.0134
G1 X151.037 Y35.302 E.01627
G1 X151.037 Y34.902 E.0134
G1 X151.037 Y34.502 E.0134
G1 X151.037 Y34.102 E.0134
G1 X151.037 Y33.702 E.0134
G1 X151.037 Y33.302 E.0134
G1 X151.037 Y32.902 E.0134
G1 X151.037 Y26.566 E.21232
; COOLING_NODE: 0
M204 S250
G1 X150.645 Y26.114 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X151.136 Y26.114 E.01524
G1 X151.536 Y26.114 E.01242
G1 X151.936 Y26.114 E.01242
G1 X152.336 Y26.114 E.01242
G1 X152.736 Y26.114 E.01242
G1 F5595.29
G1 X153.136 Y26.114 E.01242
G1 F4706.632
G1 X153.536 Y26.114 E.01242
G1 F3894.774
G1 X153.936 Y26.114 E.01242
G1 F3159.716
G1 X154.336 Y26.114 E.01242
G1 F2501.458
G1 X154.736 Y26.114 E.01242
G1 F1920
G1 X155.104 Y26.114 E.01142
G1 F2501.458
G1 X155.504 Y26.114 E.01242
G1 F3159.716
G1 X155.904 Y26.114 E.01242
G1 F3894.774
G1 X156.304 Y26.114 E.01242
G1 F4706.632
G1 X156.704 Y26.114 E.01242
G1 F5595.29
G1 X157.104 Y26.114 E.01242
G1 F6000
G1 X157.504 Y26.114 E.01242
G1 X157.904 Y26.114 E.01242
G1 X158.304 Y26.114 E.01242
G1 X158.704 Y26.114 E.01242
G1 X159.104 Y26.114 E.01242
G1 X159.504 Y26.114 E.01242
G1 X165.336 Y26.114 E.18104
G1 X165.736 Y26.114 E.01242
G1 X166.136 Y26.114 E.01242
G1 X166.536 Y26.114 E.01242
G1 X166.936 Y26.114 E.01242
G1 X167.336 Y26.114 E.01242
G1 X167.736 Y26.114 E.01242
G1 F5595.29
G1 X168.136 Y26.114 E.01242
G1 F4706.632
G1 X168.536 Y26.114 E.01242
G1 F3894.774
G1 X168.936 Y26.114 E.01242
G1 F3159.716
G1 X169.336 Y26.114 E.01242
G1 F2501.458
G1 X169.736 Y26.114 E.01242
G1 F1920
G1 X170.104 Y26.114 E.01142
G1 F2501.458
G1 X170.504 Y26.114 E.01242
G1 F3483.164
G1 X171.085 Y26.114 E.01804
G1 F4253.01
G1 X171.085 Y26.514 E.01242
G1 F5099.657
G1 X171.085 Y26.914 E.01242
G1 F6000
G1 X171.085 Y27.314 E.01242
G1 X171.085 Y27.714 E.01242
G1 X171.085 Y28.114 E.01242
G1 X171.085 Y28.514 E.01242
G1 X171.085 Y28.914 E.01242
G1 X171.085 Y29.314 E.01242
G1 X171.085 Y29.714 E.01242
G1 X171.085 Y32.094 E.07388
G1 X171.085 Y32.494 E.01242
G1 X171.085 Y32.894 E.01242
G1 X171.085 Y33.294 E.01242
G1 X171.085 Y33.694 E.01242
G1 X171.085 Y34.094 E.01242
G1 X171.085 Y34.494 E.01242
G1 X171.085 Y34.894 E.01242
G1 F5099.657
G1 X171.085 Y35.294 E.01242
G1 F4253.01
G1 X171.085 Y35.694 E.01242
G1 F3483.164
G1 X170.504 Y35.694 E.01804
G1 F2501.458
G1 X170.104 Y35.694 E.01242
G1 F1920
G1 X169.736 Y35.694 E.01142
G1 F2501.458
G1 X169.336 Y35.694 E.01242
G1 F3159.716
G1 X168.936 Y35.694 E.01242
G1 F3894.774
G1 X168.536 Y35.694 E.01242
G1 F4706.632
G1 X168.136 Y35.694 E.01242
G1 F5595.29
G1 X167.736 Y35.694 E.01242
G1 F6000
G1 X167.336 Y35.694 E.01242
G1 X166.936 Y35.694 E.01242
G1 X166.536 Y35.694 E.01242
G1 X166.136 Y35.694 E.01242
G1 X165.736 Y35.694 E.01242
G1 X165.336 Y35.694 E.01242
G1 X159.504 Y35.694 E.18104
G1 X159.104 Y35.694 E.01242
G1 X158.704 Y35.694 E.01242
G1 X158.304 Y35.694 E.01242
G1 X157.904 Y35.694 E.01242
G1 X157.504 Y35.694 E.01242
G1 X157.104 Y35.694 E.01242
G1 F5595.29
G1 X156.704 Y35.694 E.01242
G1 F4706.632
G1 X156.304 Y35.694 E.01242
G1 F3894.774
G1 X155.904 Y35.694 E.01242
G1 F3159.716
G1 X155.504 Y35.694 E.01242
G1 F2501.458
G1 X155.104 Y35.694 E.01242
G1 F1920
G1 X154.736 Y35.694 E.01142
G1 F2501.458
G1 X154.336 Y35.694 E.01242
G1 F3159.716
G1 X153.936 Y35.694 E.01242
G1 F3894.774
G1 X153.536 Y35.694 E.01242
M106 S255
G1 F4706.632
G1 X153.136 Y35.694 E.01242
G1 F5595.29
G1 X152.736 Y35.694 E.01242
G1 F6000
G1 X152.336 Y35.694 E.01242
G1 X151.936 Y35.694 E.01242
G1 X151.536 Y35.694 E.01242
G1 X151.136 Y35.694 E.01242
G1 X150.645 Y35.694 E.01524
G1 X150.645 Y35.294 E.01242
G1 X150.645 Y26.174 E.28309
; WIPE_START
M204 S8000
G1 X151.136 Y26.114 E-.18801
G1 X151.536 Y26.114 E-.152
G1 X151.641 Y26.114 E-.03999
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I-1.155 J-.385 P1  F60000
G1 X151.2 Y27.436 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42194
G1 F15000
M204 S8000
G1 X151.797 Y26.839 E.02635
G1 X152.333 Y26.839 E.01672
G1 X151.37 Y27.803 E.04251
G1 X151.37 Y28.339 E.01672
G1 X152.869 Y26.839 E.06616
G1 X153.405 Y26.839 E.01672
G1 X151.37 Y28.875 E.08981
G1 X151.37 Y29.411 E.01672
G1 X153.941 Y26.839 E.11347
G1 X154.477 Y26.839 E.01672
G1 X151.37 Y29.947 E.13712
G1 X151.37 Y30.483 E.01672
G1 X155.013 Y26.839 E.16077
G1 X155.549 Y26.839 E.01672
G1 X151.37 Y31.019 E.18442
G1 X151.37 Y31.555 E.01672
G1 X156.085 Y26.839 E.20807
G1 X156.621 Y26.839 E.01672
G1 X151.37 Y32.091 E.23172
G1 X151.37 Y32.627 E.01672
G1 X157.157 Y26.839 E.25537
G1 X157.693 Y26.839 E.01672
G1 X151.37 Y33.163 E.27902
G1 X151.37 Y33.699 E.01672
G1 X158.229 Y26.839 E.30267
G1 X158.765 Y26.839 E.01672
G1 X151.37 Y34.235 E.32633
G1 X151.37 Y34.771 E.01672
G1 X159.302 Y26.839 E.34998
G1 X159.838 Y26.839 E.01672
G1 X151.708 Y34.969 E.35871
G1 X152.244 Y34.969 E.01672
G1 X160.374 Y26.839 E.35871
G1 X160.91 Y26.839 E.01672
G1 X152.78 Y34.969 E.35871
G1 X153.316 Y34.969 E.01672
G1 X161.446 Y26.839 E.35871
G1 X161.982 Y26.839 E.01672
G1 X153.852 Y34.969 E.35871
G1 X154.388 Y34.969 E.01672
G1 X162.518 Y26.839 E.35871
G1 X163.054 Y26.839 E.01672
G1 X154.924 Y34.969 E.35871
G1 X155.46 Y34.969 E.01672
G1 X163.59 Y26.839 E.35871
G1 X164.126 Y26.839 E.01672
G1 X155.996 Y34.969 E.35871
G1 X156.532 Y34.969 E.01672
G1 X164.662 Y26.839 E.35871
G1 X165.198 Y26.839 E.01672
G1 X157.068 Y34.969 E.35871
G1 X157.604 Y34.969 E.01672
G1 X165.734 Y26.839 E.35871
G1 X166.27 Y26.839 E.01672
G1 X158.14 Y34.969 E.35871
G1 X158.676 Y34.969 E.01672
G1 X166.806 Y26.839 E.35871
G1 X167.342 Y26.839 E.01672
G1 X159.212 Y34.969 E.35871
G1 X159.748 Y34.969 E.01672
G1 X167.878 Y26.839 E.35871
G1 X168.414 Y26.839 E.01672
G1 X160.284 Y34.969 E.35871
G1 X160.82 Y34.969 E.01672
G1 X168.95 Y26.839 E.35871
G1 X169.486 Y26.839 E.01672
G1 X161.356 Y34.969 E.35871
G1 X161.892 Y34.969 E.01672
G1 X170.022 Y26.839 E.35871
G1 X170.36 Y26.839 E.01054
G1 X170.36 Y27.037 E.00619
G1 X162.428 Y34.969 E.34996
G1 X162.964 Y34.969 E.01672
G1 X170.36 Y27.574 E.32631
G1 X170.36 Y28.11 E.01672
G1 X163.5 Y34.969 E.30266
G1 X164.036 Y34.969 E.01672
G1 X170.36 Y28.646 E.27901
G1 X170.36 Y29.182 E.01672
G1 X164.572 Y34.969 E.25535
G1 X165.108 Y34.969 E.01672
G1 X170.36 Y29.718 E.2317
G1 X170.36 Y30.254 E.01672
G1 X165.644 Y34.969 E.20805
G1 X166.18 Y34.969 E.01672
G1 X170.36 Y30.79 E.1844
G1 X170.36 Y31.326 E.01672
G1 X166.716 Y34.969 E.16075
G1 X167.252 Y34.969 E.01672
G1 X170.36 Y31.862 E.1371
G1 X170.36 Y32.398 E.01672
G1 X167.788 Y34.969 E.11345
G1 X168.324 Y34.969 E.01672
G1 X170.36 Y32.934 E.0898
G1 X170.36 Y33.47 E.01672
G1 X168.86 Y34.969 E.06614
G1 X169.396 Y34.969 E.01672
G1 X170.36 Y34.006 E.04249
G1 X170.36 Y34.542 E.01672
G1 X169.763 Y35.138 E.02633
; COOLING_NODE: 0
; WIPE_START
G1 X170.36 Y34.542 E-.32067
G1 X170.36 Y34.386 E-.05933
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I1.095 J.531 P1  F60000
G1 X174.177 Y26.506 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X174.522 Y26.506 E.01158
G1 X174.922 Y26.506 E.0134
G1 X175.322 Y26.506 E.0134
G1 X175.722 Y26.506 E.0134
G1 F5389.068
G1 X176.122 Y26.506 E.0134
G1 F4517.655
G1 X176.522 Y26.506 E.0134
G1 F3723.041
G1 X176.922 Y26.506 E.0134
G1 F3005.227
G1 X177.322 Y26.506 E.0134
G1 F2364.214
G1 X177.722 Y26.506 E.0134
G1 F1800
G1 X178.117 Y26.506 E.01323
M106 S191.25
M106 S255
G1 F2364.214
G1 X178.517 Y26.506 E.0134
G1 F2864.791
G1 X178.833 Y26.506 E.0106
G1 F3566.54
G1 X178.833 Y26.906 E.0134
G1 F4345.089
G1 X178.833 Y27.306 E.0134
G1 F5200.438
G1 X178.833 Y27.706 E.0134
G1 F6000
G1 X178.833 Y28.106 E.0134
G1 X178.833 Y28.506 E.0134
G1 X178.833 Y28.906 E.0134
G1 X178.833 Y29.306 E.0134
G1 X178.833 Y29.706 E.0134
G1 X178.833 Y30.106 E.0134
G1 X178.833 Y30.506 E.0134
G1 X178.833 Y30.906 E.0134
G1 X178.833 Y31.302 E.01327
G1 X178.833 Y31.702 E.0134
G1 X178.833 Y32.102 E.0134
G1 X178.833 Y32.502 E.0134
G1 X178.833 Y32.902 E.0134
G1 X178.833 Y33.302 E.0134
G1 X178.833 Y33.702 E.0134
G1 X178.833 Y34.102 E.0134
G1 F5200.438
G1 X178.833 Y34.502 E.0134
G1 F4345.089
G1 X178.833 Y34.902 E.0134
G1 F3566.54
G1 X178.833 Y35.302 E.0134
G1 F2864.791
G1 X178.517 Y35.302 E.0106
G1 F2364.214
G1 X178.117 Y35.302 E.0134
G1 F1800
G1 X177.722 Y35.302 E.01323
M106 S191.25
G1 F2364.214
G1 X177.322 Y35.302 E.0134
G1 F3005.227
G1 X176.922 Y35.302 E.0134
G1 F3723.041
G1 X176.522 Y35.302 E.0134
G1 F4517.655
G1 X176.122 Y35.302 E.0134
G1 F5389.068
G1 X175.722 Y35.302 E.0134
G1 F6000
G1 X175.322 Y35.302 E.0134
G1 X174.922 Y35.302 E.0134
G1 X174.522 Y35.302 E.0134
G1 X174.177 Y35.302 E.01158
G1 X174.177 Y34.902 E.0134
G1 X174.177 Y34.502 E.0134
G1 X174.177 Y34.102 E.0134
G1 X174.177 Y33.702 E.0134
G1 X174.177 Y33.302 E.0134
G1 X174.177 Y32.902 E.0134
G1 X174.177 Y26.566 E.21232
; COOLING_NODE: 0
M204 S250
G1 X173.785 Y26.114 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X174.136 Y26.114 E.0109
G1 X174.536 Y26.114 E.01242
G1 X174.936 Y26.114 E.01242
G1 X175.336 Y26.114 E.01242
G1 X175.736 Y26.114 E.01242
G1 F5595.29
G1 X176.136 Y26.114 E.01242
G1 F4706.632
G1 X176.536 Y26.114 E.01242
G1 F3894.774
G1 X176.936 Y26.114 E.01242
G1 F3159.716
G1 X177.336 Y26.114 E.01242
G1 F2501.458
G1 X177.736 Y26.114 E.01242
G1 F1920
G1 X178.104 Y26.114 E.01142
G1 F2501.458
G1 X178.504 Y26.114 E.01242
G1 F3159.716
G1 X178.904 Y26.114 E.01242
G1 F3745.22
G1 X179.225 Y26.114 E.00999
G1 F4542.083
G1 X179.225 Y26.514 E.01242
G1 F5415.746
G1 X179.225 Y26.914 E.01242
G1 F6000
G1 X179.225 Y27.314 E.01242
G1 X179.225 Y27.714 E.01242
G1 X179.225 Y28.114 E.01242
G1 X179.225 Y28.514 E.01242
G1 X179.225 Y28.914 E.01242
G1 X179.225 Y29.314 E.01242
G1 X179.225 Y32.494 E.09871
G1 X179.225 Y32.894 E.01242
G1 X179.225 Y33.294 E.01242
G1 X179.225 Y33.694 E.01242
G1 X179.225 Y34.094 E.01242
G1 X179.225 Y34.494 E.01242
G1 X179.225 Y34.894 E.01242
G1 F5415.746
G1 X179.225 Y35.294 E.01242
G1 F4542.083
G1 X179.225 Y35.694 E.01242
G1 F3745.22
G1 X178.904 Y35.694 E.00999
G1 F3159.716
G1 X178.504 Y35.694 E.01242
G1 F2501.458
G1 X178.104 Y35.694 E.01242
G1 F1920
G1 X177.736 Y35.694 E.01142
G1 F2501.458
G1 X177.336 Y35.694 E.01242
G1 F3159.716
G1 X176.936 Y35.694 E.01242
G1 F3894.774
G1 X176.536 Y35.694 E.01242
G1 F4706.632
G1 X176.136 Y35.694 E.01242
G1 F5595.29
G1 X175.736 Y35.694 E.01242
G1 F6000
G1 X175.336 Y35.694 E.01242
G1 X174.936 Y35.694 E.01242
G1 X174.536 Y35.694 E.01242
G1 X174.136 Y35.694 E.01242
G1 X173.785 Y35.694 E.0109
G1 X173.785 Y35.294 E.01242
G1 X173.785 Y26.174 E.28309
; WIPE_START
M204 S8000
G1 X174.136 Y26.114 E-.13538
G1 X174.536 Y26.114 E-.152
G1 X174.779 Y26.114 E-.09262
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I-1.18 J.297 P1  F60000
G1 X176.505 Y32.974 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.5219
G1 F15000
M204 S8000
G1 X176.505 Y28.894 E.16084
M204 S10000
G1 X176.077 Y33.402 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X176.933 Y33.402 E.02657
G1 X176.933 Y28.406 E.15505
G1 X176.077 Y28.406 E.02657
G1 X176.077 Y33.342 E.15319
M204 S10000
G1 X175.7 Y33.779 F60000
G1 F15000
M204 S8000
G1 X177.31 Y33.779 E.04998
G1 X177.31 Y28.029 E.17846
G1 X175.7 Y28.029 E.04998
G1 X175.7 Y33.719 E.1766
M204 S10000
G1 X175.323 Y34.156 F60000
G1 F15000
M204 S8000
G1 X177.687 Y34.156 E.07339
G1 X177.687 Y27.652 E.20187
G1 X175.323 Y27.652 E.07339
G1 X175.323 Y34.096 E.20001
M204 S10000
G1 X174.946 Y34.533 F60000
G1 F15000
M204 S8000
G1 X178.064 Y34.533 E.0968
G1 X178.064 Y27.275 E.22528
G1 X174.946 Y27.275 E.0968
G1 X174.946 Y34.473 E.22341
M204 S10000
M73 P97 R0
G1 X174.569 Y34.91 F60000
G1 F15000
M204 S8000
G1 X178.441 Y34.91 E.12021
G1 X178.441 Y26.898 E.24868
G1 X174.569 Y26.898 E.12021
G1 X174.569 Y34.85 E.24682
; WIPE_START
G1 X174.569 Y33.85 E-.38
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
    

    

    
        M9711 M0 E0 U252 V34 Z2.4 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 11/12
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
M106 S201.45
; OBJECT_ID: 423
; COOLING_NODE: 0
G1 X147.833 Y26.506 F60000
G1 Z2.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F6000
M204 S8000
G1 X147.833 Y35.302 E.29475
G1 X138.537 Y35.302 E.31151
G1 X138.537 Y26.506 E.29475
G1 X147.773 Y26.506 E.3095
; COOLING_NODE: 0
M204 S250
G1 X148.225 Y26.114 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X148.225 Y35.694 E.29737
G1 X138.145 Y35.694 E.31289
G1 X138.145 Y26.114 E.29737
G1 X148.165 Y26.114 E.31103
; WIPE_START
M204 S8000
G1 X148.171 Y27.114 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-.681 J-1.009 P1  F60000
G1 X147.669 Y27.453 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42991
G1 F15000
M204 S8000
G1 X147.055 Y26.839 E.02764
G1 X146.508 Y26.839 E.01743
G1 X147.499 Y27.83 E.04466
G1 X147.499 Y28.378 E.01743
G1 X145.961 Y26.839 E.06931
G1 X145.414 Y26.839 E.01743
G1 X147.499 Y28.925 E.09397
G1 X147.499 Y29.472 E.01743
G1 X144.866 Y26.839 E.11863
G1 X144.319 Y26.839 E.01743
G1 X147.499 Y30.02 E.14328
G1 X147.499 Y30.567 E.01743
G1 X143.772 Y26.839 E.16794
G1 X143.224 Y26.839 E.01743
G1 X147.499 Y31.114 E.19259
G1 X147.499 Y31.661 E.01743
G1 X142.677 Y26.839 E.21725
G1 X142.13 Y26.839 E.01743
G1 X147.499 Y32.209 E.24191
G1 X147.499 Y32.756 E.01743
G1 X141.583 Y26.839 E.26656
G1 X141.035 Y26.839 E.01743
G1 X147.499 Y33.303 E.29122
G1 X147.499 Y33.851 E.01743
G1 X140.488 Y26.839 E.31588
G1 X139.941 Y26.839 E.01743
G1 X147.499 Y34.398 E.34053
G1 X147.499 Y34.945 E.01743
G1 X139.393 Y26.839 E.36519
G1 X138.87 Y26.839 E.01668
G1 X138.87 Y26.863 E.00075
G1 X146.976 Y34.969 E.36519
G1 X146.428 Y34.969 E.01743
G1 X138.87 Y27.41 E.34053
G1 X138.87 Y27.957 E.01743
G1 X145.881 Y34.969 E.31587
G1 X145.334 Y34.969 E.01743
G1 X138.87 Y28.505 E.29122
G1 X138.87 Y29.052 E.01743
G1 X144.787 Y34.969 E.26656
G1 X144.239 Y34.969 E.01743
G1 X138.87 Y29.599 E.2419
G1 X138.87 Y30.147 E.01743
G1 X143.692 Y34.969 E.21725
G1 X143.145 Y34.969 E.01743
G1 X138.87 Y30.694 E.19259
G1 X138.87 Y31.241 E.01743
G1 X142.597 Y34.969 E.16793
G1 X142.05 Y34.969 E.01743
G1 X138.87 Y31.788 E.14328
G1 X138.87 Y32.336 E.01743
G1 X141.503 Y34.969 E.11862
G1 X140.956 Y34.969 E.01743
G1 X138.87 Y32.883 E.09397
G1 X138.87 Y33.43 E.01743
G1 X140.408 Y34.969 E.06931
G1 X139.861 Y34.969 E.01743
G1 X138.87 Y33.978 E.04465
G1 X138.87 Y34.525 E.01743
G1 X139.483 Y35.138 E.02764
; COOLING_NODE: 0
; WIPE_START
G1 X138.87 Y34.525 E-.32972
G1 X138.87 Y34.393 E-.05029
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I.662 J1.021 P1  F60000
G1 X151.037 Y26.506 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X170.693 Y26.506 E.65868
G1 X170.693 Y35.302 E.29475
G1 X151.037 Y35.302 E.65868
G1 X151.037 Y26.566 E.29274
; COOLING_NODE: 0
M204 S250
G1 X150.645 Y26.114 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X171.085 Y26.114 E.63448
G1 X171.085 Y35.694 E.29737
G1 X150.645 Y35.694 E.63448
G1 X150.645 Y26.174 E.29551
; WIPE_START
M204 S8000
G1 X151.645 Y26.171 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-1.216 J.044 P1  F60000
G1 X151.967 Y35.138 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42194
G1 F15000
M204 S8000
G1 X151.37 Y34.541 E.02635
G1 X151.37 Y34.005 E.01672
G1 X152.333 Y34.969 E.04251
G1 X152.869 Y34.969 E.01672
G1 X151.37 Y33.469 E.06616
G1 X151.37 Y32.933 E.01672
G1 X153.405 Y34.969 E.08981
G1 X153.941 Y34.969 E.01672
G1 X151.37 Y32.397 E.11346
G1 X151.37 Y31.861 E.01672
G1 X154.477 Y34.969 E.13712
G1 X155.013 Y34.969 E.01672
G1 X151.37 Y31.325 E.16077
G1 X151.37 Y30.789 E.01672
G1 X155.549 Y34.969 E.18442
G1 X156.085 Y34.969 E.01672
G1 X151.37 Y30.253 E.20807
G1 X151.37 Y29.717 E.01672
G1 X156.621 Y34.969 E.23172
G1 X157.157 Y34.969 E.01672
G1 X151.37 Y29.181 E.25537
G1 X151.37 Y28.645 E.01672
G1 X157.693 Y34.969 E.27902
G1 X158.229 Y34.969 E.01672
G1 X151.37 Y28.109 E.30267
G1 X151.37 Y27.573 E.01672
G1 X158.765 Y34.969 E.32633
G1 X159.302 Y34.969 E.01672
G1 X151.37 Y27.037 E.34998
G1 X151.37 Y26.839 E.00618
G1 X151.708 Y26.839 E.01055
G1 X159.838 Y34.969 E.35871
G1 X160.374 Y34.969 E.01672
G1 X152.244 Y26.839 E.35871
G1 X152.78 Y26.839 E.01672
G1 X160.91 Y34.969 E.35871
G1 X161.446 Y34.969 E.01672
G1 X153.316 Y26.839 E.35871
G1 X153.852 Y26.839 E.01672
G1 X161.982 Y34.969 E.35871
G1 X162.518 Y34.969 E.01672
G1 X154.388 Y26.839 E.35871
G1 X154.924 Y26.839 E.01672
G1 X163.054 Y34.969 E.35871
G1 X163.59 Y34.969 E.01672
G1 X155.46 Y26.839 E.35871
G1 X155.996 Y26.839 E.01672
G1 X164.126 Y34.969 E.35871
G1 X164.662 Y34.969 E.01672
G1 X156.532 Y26.839 E.35871
G1 X157.068 Y26.839 E.01672
G1 X165.198 Y34.969 E.35871
G1 X165.734 Y34.969 E.01672
G1 X157.604 Y26.839 E.35871
G1 X158.14 Y26.839 E.01672
G1 X166.27 Y34.969 E.35871
G1 X166.806 Y34.969 E.01672
G1 X158.676 Y26.839 E.35871
G1 X159.212 Y26.839 E.01672
G1 X167.342 Y34.969 E.35871
G1 X167.878 Y34.969 E.01672
G1 X159.748 Y26.839 E.35871
G1 X160.284 Y26.839 E.01672
G1 X168.414 Y34.969 E.35871
G1 X168.95 Y34.969 E.01672
G1 X160.82 Y26.839 E.35871
G1 X161.356 Y26.839 E.01672
G1 X169.486 Y34.969 E.35871
G1 X170.022 Y34.969 E.01672
G1 X161.892 Y26.839 E.35871
G1 X162.428 Y26.839 E.01672
G1 X170.36 Y34.77 E.34996
G1 X170.36 Y34.234 E.01672
G1 X162.964 Y26.839 E.32631
G1 X163.5 Y26.839 E.01672
G1 X170.36 Y33.698 E.30266
G1 X170.36 Y33.162 E.01672
G1 X164.036 Y26.839 E.27901
G1 X164.572 Y26.839 E.01672
G1 X170.36 Y32.626 E.25535
G1 X170.36 Y32.09 E.01672
G1 X165.108 Y26.839 E.2317
G1 X165.644 Y26.839 E.01672
G1 X170.36 Y31.554 E.20805
G1 X170.36 Y31.018 E.01672
G1 X166.18 Y26.839 E.1844
G1 X166.716 Y26.839 E.01672
G1 X170.36 Y30.482 E.16075
G1 X170.36 Y29.946 E.01672
G1 X167.252 Y26.839 E.1371
G1 X167.788 Y26.839 E.01672
G1 X170.36 Y29.41 E.11345
G1 X170.36 Y28.874 E.01672
G1 X168.324 Y26.839 E.0898
G1 X168.86 Y26.839 E.01672
G1 X170.36 Y28.338 E.06614
G1 X170.36 Y27.802 E.01672
G1 X169.396 Y26.839 E.04249
G1 X169.932 Y26.839 E.01672
G1 X170.529 Y27.436 E.02633
; COOLING_NODE: 0
; WIPE_START
G1 X169.932 Y26.839 E-.32067
G1 X169.776 Y26.839 E-.05933
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I.092 J1.213 P1  F60000
G1 X174.177 Y26.506 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6000
M204 S8000
G1 X178.833 Y26.506 E.15605
G1 X178.833 Y35.302 E.29475
G1 X174.177 Y35.302 E.15605
G1 X174.177 Y26.566 E.29274
; COOLING_NODE: 0
M204 S250
G1 X173.785 Y26.114 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X179.225 Y26.114 E.16889
G1 X179.225 Y35.694 E.29737
G1 X173.785 Y35.694 E.16889
G1 X173.785 Y26.174 E.29551
; WIPE_START
M204 S8000
G1 X174.784 Y26.163 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-1.18 J.298 P1  F60000
G1 X176.505 Y32.974 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.5219
G1 F15000
M204 S8000
G1 X176.505 Y28.894 E.16084
M204 S10000
G1 X176.077 Y33.402 F60000
; LINE_WIDTH: 0.41999
G1 F15000
M204 S8000
G1 X176.933 Y33.402 E.02657
G1 X176.933 Y28.406 E.15505
G1 X176.077 Y28.406 E.02657
G1 X176.077 Y33.342 E.15319
M204 S10000
G1 X175.7 Y33.779 F60000
G1 F15000
M204 S8000
G1 X177.31 Y33.779 E.04998
G1 X177.31 Y28.029 E.17846
G1 X175.7 Y28.029 E.04998
G1 X175.7 Y33.719 E.1766
M204 S10000
G1 X175.323 Y34.156 F60000
G1 F15000
M204 S8000
G1 X177.687 Y34.156 E.07339
G1 X177.687 Y27.652 E.20187
G1 X175.323 Y27.652 E.07339
G1 X175.323 Y34.096 E.20001
M204 S10000
G1 X174.946 Y34.533 F60000
G1 F15000
M204 S8000
G1 X178.064 Y34.533 E.0968
G1 X178.064 Y27.275 E.22528
G1 X174.946 Y27.275 E.0968
G1 X174.946 Y34.473 E.22341
M204 S10000
G1 X174.569 Y34.91 F60000
G1 F15000
M204 S8000
G1 X178.441 Y34.91 E.12021
G1 X178.441 Y26.898 E.24868
G1 X174.569 Y26.898 E.12021
G1 X174.569 Y34.85 E.24682
; WIPE_START
G1 X174.569 Y33.85 E-.38
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
    

    

    
        M9711 M0 E0 U252 V34 Z2.6 S11 C10 O0 T3000
    

    
    
    
        M993 A3 B3 C3
    
M623
; SKIPPABLE_END

; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 12/12
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
; OBJECT_ID: 423
; COOLING_NODE: 0
G1 X148.225 Y26.114 F60000
G1 Z2.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6000
M204 S5000
G1 X148.225 Y35.694 E.29737
G1 X138.145 Y35.694 E.31289
G1 X138.145 Y26.114 E.29737
G1 X148.165 Y26.114 E.31103
; WIPE_START
M204 S8000
G1 X148.171 Y27.114 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I-1.214 J-.09 P1  F60000
G1 X147.553 Y35.487 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X148.017 Y35.023 E.02037
G1 X148.151 Y34.889
G1 X148.151 Y34.356
G1 X148.017 Y34.489
G1 X147.02 Y35.487 E.04378
G1 X146.886 Y35.62
G1 X146.353 Y35.62
G1 X146.487 Y35.487
G1 X148.017 Y33.956 E.06719
G1 X148.151 Y33.822
G1 X148.151 Y33.289
G1 X148.017 Y33.423
G1 X145.953 Y35.487 E.0906
G1 X145.82 Y35.62
G1 X145.287 Y35.62
G1 X145.42 Y35.487
G1 X148.017 Y32.89 E.11401
G1 X148.151 Y32.756
G1 X148.151 Y32.223
G1 X148.017 Y32.356
G1 X144.887 Y35.487 E.13742
G1 X144.753 Y35.62
G1 X144.22 Y35.62
G1 X144.354 Y35.487
G1 X148.017 Y31.823 E.16083
G1 X148.151 Y31.689
G1 X148.151 Y31.156
G1 X148.017 Y31.29
G1 X143.82 Y35.487 E.18423
G1 X143.687 Y35.62
G1 X143.154 Y35.62
G1 X143.287 Y35.487
G1 X148.017 Y30.756 E.20764
G1 X148.151 Y30.623
G1 X148.151 Y30.09
G1 X148.017 Y30.223
G1 X142.754 Y35.487 E.23105
G1 X142.62 Y35.62
G1 X142.087 Y35.62
G1 X142.221 Y35.487
G1 X148.017 Y29.69 E.25446
G1 X148.151 Y29.556
G1 X148.151 Y29.023
G1 X148.017 Y29.157
G1 X141.687 Y35.487 E.27787
G1 X141.554 Y35.62
G1 X141.02 Y35.62
G1 X141.154 Y35.487
G1 X148.017 Y28.623 E.30128
G1 X148.151 Y28.49
G1 X148.151 Y27.957
G1 X148.017 Y28.09
G1 X140.621 Y35.487 E.32469
G1 X140.487 Y35.62
G1 X139.954 Y35.62
G1 X140.088 Y35.487
G1 X148.017 Y27.557 E.3481
G1 X148.151 Y27.423
G1 X148.151 Y26.89
G1 X148.017 Y27.024
G1 X139.554 Y35.487 E.37151
G1 X139.421 Y35.62
G1 X138.887 Y35.62
G1 X139.021 Y35.487
G1 X148.017 Y26.49 E.39492
G1 X148.151 Y26.357
G1 X147.787 Y26.188
G1 X147.653 Y26.321
M73 P98 R0
G1 X138.488 Y35.487 E.40234
G1 X138.354 Y35.62
G1 X138.218 Y35.223
G1 X138.352 Y35.089
G1 X147.12 Y26.321 E.38489
G1 X147.253 Y26.188
G1 X146.72 Y26.188
G1 X146.587 Y26.321
G1 X138.352 Y34.556 E.36148
G1 X138.218 Y34.69
G1 X138.218 Y34.156
G1 X138.352 Y34.023
G1 X146.053 Y26.321 E.33807
G1 X146.187 Y26.188
G1 X145.654 Y26.188
G1 X145.52 Y26.321
G1 X138.352 Y33.489 E.31466
G1 X138.218 Y33.623
G1 X138.218 Y33.09
G1 X138.352 Y32.956
G1 X144.987 Y26.321 E.29126
G1 X145.12 Y26.188
G1 X144.587 Y26.188
G1 X144.454 Y26.321
G1 X138.352 Y32.423 E.26785
G1 X138.218 Y32.556
G1 X138.218 Y32.023
G1 X138.352 Y31.89
G1 X143.92 Y26.321 E.24444
G1 X144.054 Y26.188
G1 X143.521 Y26.188
G1 X143.387 Y26.321
G1 X138.352 Y31.356 E.22103
G1 X138.218 Y31.49
G1 X138.218 Y30.957
G1 X138.352 Y30.823
G1 X142.854 Y26.321 E.19762
G1 X142.987 Y26.188
G1 X142.454 Y26.188
G1 X142.321 Y26.321
G1 X138.352 Y30.29 E.17421
G1 X138.218 Y30.423
G1 X138.218 Y29.89
G1 X138.352 Y29.757
G1 X141.787 Y26.321 E.1508
G1 X141.921 Y26.188
G1 X141.388 Y26.188
G1 X141.254 Y26.321
G1 X138.352 Y29.223 E.12739
G1 X138.218 Y29.357
G1 X138.218 Y28.824
G1 X138.352 Y28.69
G1 X140.721 Y26.321 E.10398
G1 X140.854 Y26.188
G1 X140.321 Y26.188
G1 X140.187 Y26.321
G1 X138.352 Y28.157 E.08057
G1 X138.218 Y28.29
G1 X138.218 Y27.757
G1 X138.352 Y27.624
G1 X139.654 Y26.321 E.05716
G1 X139.788 Y26.188
G1 X139.255 Y26.188
G1 X139.121 Y26.321
G1 X138.352 Y27.09 E.03376
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X139.059 Y26.383 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I.028 J1.217 P1  F60000
G1 X150.645 Y26.114 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Outer wall
G1 F6000
M204 S5000
G1 X171.085 Y26.114 E.63448
G1 X171.085 Y35.694 E.29737
G1 X150.645 Y35.694 E.63448
G1 X150.645 Y26.174 E.29551
; WIPE_START
M204 S8000
G1 X151.645 Y26.171 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I-.539 J1.091 P1  F60000
G1 X170.483 Y35.487 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X170.877 Y35.093 E.0173
G1 X171.011 Y34.959
G1 X171.011 Y34.426
G1 X170.877 Y34.559
G1 X169.95 Y35.487 E.04071
G1 X169.816 Y35.62
G1 X169.283 Y35.62
G1 X169.417 Y35.487
G1 X170.877 Y34.026 E.06412
G1 X171.011 Y33.892
G1 X171.011 Y33.359
G1 X170.877 Y33.493
G1 X168.884 Y35.487 E.08753
G1 X168.75 Y35.62
G1 X168.217 Y35.62
G1 X168.35 Y35.487
G1 X170.877 Y32.959 E.11094
G1 X171.011 Y32.826
G1 X171.011 Y32.293
G1 X170.877 Y32.426
G1 X167.817 Y35.487 E.13434
G1 X167.683 Y35.62
G1 X167.15 Y35.62
G1 X167.284 Y35.487
G1 X170.877 Y31.893 E.15775
G1 X171.011 Y31.759
G1 X171.011 Y31.226
G1 X170.877 Y31.36
G1 X166.75 Y35.487 E.18116
G1 X166.617 Y35.62
G1 X166.084 Y35.62
G1 X166.217 Y35.487
G1 X170.877 Y30.826 E.20457
G1 X171.011 Y30.693
G1 X171.011 Y30.16
G1 X170.877 Y30.293
G1 X165.684 Y35.487 E.22798
G1 X165.55 Y35.62
G1 X165.017 Y35.62
G1 X165.151 Y35.487
G1 X170.877 Y29.76 E.25139
G1 X171.011 Y29.626
G1 X171.011 Y29.093
G1 X170.877 Y29.227
G1 X164.617 Y35.487 E.2748
G1 X164.484 Y35.62
G1 X163.951 Y35.62
G1 X164.084 Y35.487
G1 X170.877 Y28.693 E.29821
G1 X171.011 Y28.56
G1 X171.011 Y28.027
G1 X170.877 Y28.16
G1 X163.551 Y35.487 E.32162
G1 X163.417 Y35.62
G1 X162.884 Y35.62
G1 X163.018 Y35.487
G1 X170.877 Y27.627 E.34503
G1 X171.011 Y27.493
G1 X171.011 Y26.96
G1 X170.877 Y27.094
G1 X162.484 Y35.487 E.36844
G1 X162.351 Y35.62
G1 X161.818 Y35.62
G1 X161.951 Y35.487
G1 X170.877 Y26.56 E.39184
G1 X171.011 Y26.427
G1 X170.717 Y26.188
G1 X170.583 Y26.321
G1 X161.418 Y35.487 E.40234
G1 X161.284 Y35.62
G1 X160.751 Y35.62
G1 X160.885 Y35.487
G1 X170.05 Y26.321 E.40234
G1 X170.184 Y26.188
G1 X169.65 Y26.188
G1 X169.517 Y26.321
G1 X160.351 Y35.487 E.40234
G1 X160.218 Y35.62
G1 X159.684 Y35.62
G1 X159.818 Y35.487
G1 X168.983 Y26.321 E.40234
G1 X169.117 Y26.188
G1 X168.584 Y26.188
G1 X168.45 Y26.321
G1 X159.285 Y35.487 E.40234
G1 X159.151 Y35.62
G1 X158.618 Y35.62
G1 X158.752 Y35.487
G1 X167.917 Y26.321 E.40234
G1 X168.051 Y26.188
G1 X167.517 Y26.188
G1 X167.384 Y26.321
G1 X158.218 Y35.487 E.40234
G1 X158.085 Y35.62
G1 X157.551 Y35.62
G1 X157.685 Y35.487
G1 X166.85 Y26.321 E.40234
G1 X166.984 Y26.188
G1 X166.451 Y26.188
G1 X166.317 Y26.321
G1 X157.152 Y35.487 E.40234
G1 X157.018 Y35.62
G1 X156.485 Y35.62
G1 X156.619 Y35.487
G1 X165.784 Y26.321 E.40234
G1 X165.917 Y26.188
G1 X165.384 Y26.188
G1 X165.251 Y26.321
G1 X156.085 Y35.487 E.40234
G1 X155.952 Y35.62
G1 X155.418 Y35.62
G1 X155.552 Y35.487
G1 X164.717 Y26.321 E.40234
G1 X164.851 Y26.188
G1 X164.318 Y26.188
G1 X164.184 Y26.321
G1 X155.019 Y35.487 E.40234
G1 X154.885 Y35.62
G1 X154.352 Y35.62
G1 X154.486 Y35.487
G1 X163.651 Y26.321 E.40234
G1 X163.784 Y26.188
G1 X163.251 Y26.188
G1 X163.118 Y26.321
G1 X153.952 Y35.487 E.40234
G1 X153.819 Y35.62
G1 X153.285 Y35.62
G1 X153.419 Y35.487
G1 X162.584 Y26.321 E.40234
G1 X162.718 Y26.188
G1 X162.185 Y26.188
G1 X162.051 Y26.321
G1 X152.886 Y35.487 E.40234
G1 X152.752 Y35.62
G1 X152.219 Y35.62
G1 X152.353 Y35.487
G1 X161.518 Y26.321 E.40234
G1 X161.651 Y26.188
G1 X161.118 Y26.188
G1 X160.985 Y26.321
G1 X151.819 Y35.487 E.40234
G1 X151.686 Y35.62
G1 X151.152 Y35.62
G1 X151.286 Y35.487
G1 X160.451 Y26.321 E.40234
G1 X160.585 Y26.188
G1 X160.052 Y26.188
G1 X159.918 Y26.321
G1 X150.852 Y35.387 E.39798
G1 X150.718 Y35.521
G1 X150.718 Y34.988
G1 X150.852 Y34.854
G1 X159.385 Y26.321 E.37457
G1 X159.518 Y26.188
G1 X158.985 Y26.188
G1 X158.851 Y26.321
G1 X150.852 Y34.321 E.35116
G1 X150.718 Y34.454
G1 X150.718 Y33.921
G1 X150.852 Y33.788
G1 X158.318 Y26.321 E.32775
G1 X158.452 Y26.188
G1 X157.919 Y26.188
G1 X157.785 Y26.321
G1 X150.852 Y33.254 E.30434
G1 X150.718 Y33.388
G1 X150.718 Y32.855
G1 X150.852 Y32.721
G1 X157.252 Y26.321 E.28094
G1 X157.385 Y26.188
G1 X156.852 Y26.188
G1 X156.718 Y26.321
G1 X150.852 Y32.188 E.25753
G1 X150.718 Y32.321
G1 X150.718 Y31.788
G1 X150.852 Y31.655
G1 X156.185 Y26.321 E.23412
G1 X156.319 Y26.188
G1 X155.786 Y26.188
G1 X155.652 Y26.321
G1 X150.852 Y31.121 E.21071
G1 X150.718 Y31.255
G1 X150.718 Y30.722
G1 X150.852 Y30.588
G1 X155.119 Y26.321 E.1873
G1 X155.252 Y26.188
G1 X154.719 Y26.188
G1 X154.585 Y26.321
G1 X150.852 Y30.055 E.16389
G1 X150.718 Y30.188
G1 X150.718 Y29.655
G1 X150.852 Y29.521
G1 X154.052 Y26.321 E.14048
G1 X154.186 Y26.188
G1 X153.653 Y26.188
G1 X153.519 Y26.321
G1 X150.852 Y28.988 E.11707
G1 X150.718 Y29.122
G1 X150.718 Y28.589
G1 X150.852 Y28.455
G1 X152.986 Y26.321 E.09366
G1 X153.119 Y26.188
G1 X152.586 Y26.188
G1 X152.452 Y26.321
G1 X150.852 Y27.922 E.07025
G1 X150.718 Y28.055
G1 X150.718 Y27.522
G1 X150.852 Y27.388
G1 X151.919 Y26.321 E.04684
G1 X152.053 Y26.188
G1 X151.52 Y26.188
G1 X151.386 Y26.321
G1 X150.852 Y26.855 E.02344
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X151.386 Y26.321 E-.28689
G1 X151.52 Y26.188 E-.07182
G1 X151.576 Y26.188 E-.02129
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I-.479 J1.119 P1  F60000
G1 X173.785 Y35.694 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Outer wall
G1 F6000
M204 S5000
G1 X173.785 Y26.114 E.29737
G1 X179.225 Y26.114 E.16889
G1 X179.225 Y35.694 E.29737
G1 X173.845 Y35.694 E.16703
; WIPE_START
M204 S8000
G1 X173.838 Y34.694 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I-.06 J1.215 P1  F60000
G1 X179.018 Y34.951 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X178.482 Y35.487 E.02353
G1 X178.349 Y35.62
G1 X177.815 Y35.62
G1 X177.949 Y35.487
G1 X179.018 Y34.417 E.04693
G1 X179.152 Y34.284
G1 X179.152 Y33.751
G1 X179.018 Y33.884
G1 X177.416 Y35.487 E.07034
G1 X177.282 Y35.62
G1 X176.749 Y35.62
G1 X176.882 Y35.487
G1 X179.018 Y33.351 E.09375
G1 X179.152 Y33.217
M73 P99 R0
G1 X179.152 Y32.684
G1 X179.018 Y32.818
G1 X176.349 Y35.487 E.11716
G1 X176.215 Y35.62
G1 X175.682 Y35.62
G1 X175.816 Y35.487
G1 X179.018 Y32.284 E.14057
G1 X179.152 Y32.151
G1 X179.152 Y31.617
G1 X179.018 Y31.751
G1 X175.283 Y35.487 E.16398
G1 X175.149 Y35.62
G1 X174.616 Y35.62
G1 X174.749 Y35.487
G1 X179.018 Y31.218 E.18739
G1 X179.152 Y31.084
G1 X179.152 Y30.551
G1 X179.018 Y30.685
G1 X174.216 Y35.487 E.2108
G1 X174.082 Y35.62
G1 X173.858 Y35.311
G1 X173.992 Y35.177
G1 X179.018 Y30.151 E.22064
G1 X179.152 Y30.018
G1 X179.152 Y29.484
G1 X179.018 Y29.618
G1 X173.992 Y34.644 E.22064
G1 X173.858 Y34.778
G1 X173.858 Y34.245
G1 X173.992 Y34.111
G1 X179.018 Y29.085 E.22064
G1 X179.152 Y28.951
G1 X179.152 Y28.418
G1 X179.018 Y28.552
G1 X173.992 Y33.578 E.22064
G1 X173.858 Y33.711
G1 X173.858 Y33.178
G1 X173.992 Y33.044
G1 X179.018 Y28.018 E.22064
G1 X179.152 Y27.885
G1 X179.152 Y27.351
G1 X179.018 Y27.485
G1 X173.992 Y32.511 E.22064
G1 X173.858 Y32.645
G1 X173.858 Y32.112
G1 X173.992 Y31.978
G1 X179.018 Y26.952 E.22064
G1 X179.152 Y26.818
G1 X179.152 Y26.285
G1 X179.018 Y26.419
G1 X173.992 Y31.445 E.22064
G1 X173.858 Y31.578
G1 X173.858 Y31.045
G1 X173.992 Y30.911
G1 X178.582 Y26.321 E.2015
G1 X178.716 Y26.188
G1 X178.182 Y26.188
G1 X178.049 Y26.321
G1 X173.992 Y30.378 E.17809
G1 X173.858 Y30.512
G1 X173.858 Y29.979
G1 X173.992 Y29.845
G1 X177.516 Y26.321 E.15468
G1 X177.649 Y26.188
G1 X177.116 Y26.188
G1 X176.982 Y26.321
G1 X173.992 Y29.312 E.13127
G1 X173.858 Y29.445
G1 X173.858 Y28.912
G1 X173.992 Y28.778
G1 X176.449 Y26.321 E.10786
G1 X176.583 Y26.188
G1 X176.049 Y26.188
G1 X175.916 Y26.321
G1 X173.992 Y28.245 E.08445
G1 X173.858 Y28.379
G1 X173.858 Y27.845
G1 X173.992 Y27.712
G1 X175.382 Y26.321 E.06104
G1 X175.516 Y26.188
G1 X174.983 Y26.188
G1 X174.849 Y26.321
G1 X173.992 Y27.179 E.03763
; WIPE_START
M204 S8000
G1 X174.699 Y26.471 E-.38
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
    

    

    
        M9711 M0 E0 U252 V34 Z2.8 S11 C10 O0 T3000
    

    
    
    
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
G1 Z2.8 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z12.4 F900 ; lower z a little

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

    
        G1 Z101.2 F600
        G1 Z99.2
    

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

