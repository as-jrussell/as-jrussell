UPDATE  PROCESS_DEFINITION
SET     SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/TargetServiceList/TargetService/text())[1] with "UnitracBusinessServiceCycle2"') ,
        LOCK_ID = LOCK_ID + 1
WHERE   PROCESS_TYPE_CD = 'CYCLEPRC'
        AND ID IN ( 6016, 5965, 13661, 38507, 82233, 279, 1328, 1285, 10852,
                    8890, 8896, 91370, 5298, 77120, 83897, 81793, 6011, 6013,
                    77100, 77102, 77103, 77097, 77092, 77080, 77106, 77088,
                    10860, 10863, 81174, 71041, 71051, 6044, 1253, 319, 332,
                    287, 291, 631, 169, 2234, 1183, 1158, 1320, 743, 2192,
                    13821, 2238, 2215, 13828, 3297, 53398, 10428, 10429, 2259,
                    2205, 41888, 50935, 50987, 10425, 2208, 63114, 5988, 13986,
                    13988, 14578, 14581, 7141, 88603, 7174, 10418, 8909, 44562,
                    44565, 8915, 89683, 40634, 2320, 5306, 7150, 12154, 15243,
                    10432, 7161, 7155, 15244, 10445, 6005, 768, 4014, 10450,
                    15253, 18342, 8934, 10456, 12456, 12457, 15248, 15250,
                    16067, 4551, 10460, 13997, 13659, 4574, 7171, 10469, 10472,
                    12460, 12461, 12486, 12488, 14004, 6008, 8940, 12463,
                    31841, 31847, 31848, 31852, 8950, 14017, 14019, 2292,
                    10478, 12475, 13804, 4591, 4593, 112702, 112703, 8964,
                    8966, 13841, 7180, 7187, 7185, 7193, 12479, 10480, 13684,
                    13685, 8963, 10484, 10485, 244, 248, 34383, 13677, 13678,
                    4571, 13687, 6054, 10491, 1436, 14024, 10504, 8978, 7224,
                    7226, 13849, 13850, 13851, 10498, 14011, 101520, 4494,
                    12502, 15246, 8985, 4548, 10501, 1519, 12509, 4596, 4598,
                    13866, 10519, 14038, 14043, 10526, 53329, 10533, 14591,
                    15259, 15260, 15261, 10535, 12513, 12514, 10538, 14031,
                    9015, 9016, 9023, 12539, 9006, 9008, 1501, 1503, 12525,
                    68856, 14541, 1129, 15257, 14050, 6060, 6062, 817, 14057,
                    6027, 6031, 10564, 16073, 36274, 5840, 5844, 9042, 13878,
                    7018, 13883, 14065, 2328, 2332, 4063, 4067, 12529, 13425,
                    96401, 12545, 14547, 14551, 15263, 9047, 10568, 9062, 9065,
                    12548, 12680, 12681, 4007, 4009, 7282, 7287, 15275, 15278,
                    9081, 9071, 9073, 9093, 9096, 13901, 5248, 15276, 10582,
                    15291, 9087, 13711, 10587, 2278, 2283, 2287, 16061, 16065,
                    18074, 17982, 18070, 5998, 9101, 94301, 14074, 81254,
                    10598, 4055, 583, 10608, 10610, 10605, 13719, 10619, 10620,
                    10613, 7283, 7286, 7289, 10622, 5251, 9120, 12552, 2307,
                    4078, 14084, 7317, 2344, 14098, 5326, 4054, 10051, 66834,
                    2315, 1094, 10644, 10646, 10664, 2306, 36546, 10633, 10634,
                    10639, 13723, 13897, 9135, 5918, 1532, 9157, 7314, 5979,
                    44567, 44568, 12129, 12130, 12134, 12136, 12138, 12140,
                    12141, 4491, 14089, 14560, 33071, 197, 1574, 750, 12575,
                    44179, 13737, 13740, 13743, 24006, 46343, 14097, 15298,
                    15300, 96495, 10672, 7335, 836, 10681, 10676, 12333, 12334,
                    14117, 14119, 10781, 51717, 44820, 1215, 217, 5943, 15293,
                    15299, 36157, 6220, 7343, 14110, 1245, 186, 192, 245, 7342,
                    10717, 8649, 9189, 7347, 7350, 15306, 15307, 1849, 7360,
                    13738, 96391, 9190, 9191, 15304, 10708, 10712, 9192, 14121,
                    13455, 13763, 13765, 13940, 12604, 4027, 4029, 10720, 4502,
                    10737, 61127, 61128, 13257, 7366, 12633, 13745, 64398,
                    91238, 30462, 12610, 12611, 5929, 10730, 4527, 4531, 10740,
                    10741, 4512, 12631, 9213, 7391, 13747, 13750, 13751, 10759,
                    12619, 9215, 12639, 12622, 13758, 16728, 15312, 2216, 2223,
                    13768, 7393, 13775, 34833, 4475, 7405, 7409, 12643, 1498,
                    12661, 7410, 4517, 14144, 1516, 3985, 3987, 47778, 14569,
                    10772, 7442, 9247, 12652, 721, 10812, 10813, 7454, 7460,
                    10795, 13964, 13965, 10787, 9276, 10807, 4561, 4565, 3993,
                    9271, 10806, 9274, 2244, 9296, 10809, 9293, 5921, 13980,
                    9290, 4524, 4072, 4074, 10825, 10836, 82798, 13799, 13807,
                    13812, 9301, 10831, 124, 5995, 2293, 16725, 13972, 64730,
                    15309, 17928, 17929, 18331, 51559, 41740, 51522, 51525,
                    50377, 41762, 51246, 51247, 51585, 51586, 51242, 51251,
                    50381, 51058, 51059, 41795, 41816, 41827, 41833, 41838,
                    51636, 51278, 41859, 41870, 42129, 42132, 42140, 42172,
                    42174, 42186, 42188, 42485, 42499, 51537, 51538, 53511,
                    51237, 51343, 51079, 42740, 50443, 50451, 51179, 51361,
                    42764, 44168, 52757, 78440, 51656, 52530, 81773, 81774,
                    81795, 81798, 84650, 84646, 81789, 81799, 13811, 12654,
                    9306, 275, 10867, 10868, 10869, 51581, 52756, 52513, 71056,
                    81783, 81784, 10872, 13801, 13815, 13817, 9299, 32324,
                    10858, 84236, 10777 )