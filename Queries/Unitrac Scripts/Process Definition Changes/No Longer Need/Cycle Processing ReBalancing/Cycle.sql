UPDATE  PROCESS_DEFINITION
SET     SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/TargetServiceList/TargetService/text())[1] with "UnitracBusinessServiceCycle"') ,
        LOCK_ID = LOCK_ID + 1
WHERE   PROCESS_TYPE_CD = 'CYCLEPRC'
        AND ID IN ( 29359, 10846, 5955, 5957, 103612, 103614, 13665, 38505,
                    77117, 307, 1228, 637, 1263, 1323, 1333, 10853, 91369,
                    8889, 10849, 81778, 83658, 71037, 81604, 85517, 81601,
                    77129, 77085, 81780, 81781, 80982, 77082, 71057, 14588,
                    10861, 6048, 1273, 1260, 328, 8901, 51812, 1298, 1293, 254,
                    2246, 531, 1313, 221, 2179, 2185, 13823, 2182, 2093, 2095,
                    13827, 59024, 12448, 3301, 2251, 2207, 41058, 2224, 41887,
                    50938, 2206, 44726, 7147, 8785, 88615, 104300, 1133, 1136,
                    1139, 13671, 13838, 8906, 8914, 22008, 3440, 89684, 132143,
                    132144, 12150, 12152, 10433, 10454, 4558, 762, 5245, 6250,
                    6251, 1110, 1115, 1117, 4018, 7177, 10447, 8931, 108404,
                    108407, 13843, 8937, 13658, 8943, 112, 8951, 13856, 13994,
                    4577, 12459, 14003, 31831, 31832, 31840, 31844, 31845,
                    8949, 14013, 14014, 2295, 5332, 5334, 15267, 8965, 12465,
                    12469, 12470, 12471, 115930, 10489, 12477, 12478, 10482,
                    8979, 8982, 13682, 10486, 4002, 7211, 34385, 13676, 8973,
                    7222, 1111, 1114, 10493, 60222, 106083, 106084, 9002,
                    17573, 14025, 10505, 8980, 139086, 4034, 13692, 13693,
                    13868, 13870, 12492, 12493, 708, 12501, 7232, 4580, 13705,
                    4600, 10518, 5321, 1552, 1554, 14041, 33033, 33035, 10525,
                    91937, 10523, 4541, 14592, 105023, 105024, 13872, 5318,
                    7247, 7252, 13695, 61373, 61374, 8996, 13887, 7250, 14060,
                    12538, 12542, 9007, 10547, 10550, 10545, 113065, 9021,
                    1109, 14047, 14048, 14049, 14052, 10556, 6064, 9036, 9037,
                    12531, 12534, 12521, 9052, 10554, 5842, 13697, 9040, 12540,
                    12541, 13879, 13880, 107510, 107511, 13875, 7012, 13882,
                    16730, 9049, 122064, 85449, 107924, 14553, 9054, 10573,
                    13238, 104563, 14063, 7318, 9048, 14552, 12558, 37963,
                    9059, 9060, 9067, 12550, 2313, 14067, 14071, 9061, 9066,
                    119144, 12679, 14103, 7278, 15279, 9068, 9069, 9082, 10594,
                    9091, 13903, 15289, 15290, 9090, 83871, 116450, 9094, 9097,
                    10630, 2279, 2286, 141766, 9106, 5329, 16060, 16062, 16063,
                    10603, 51141, 133217, 133218, 17943, 18075, 42479, 67306,
                    6000, 6002, 70058, 79437, 79438, 88598, 124126, 131052,
                    131054, 131057, 18335, 18336, 94305, 7269, 100095, 100096,
                    100097, 131739, 131741, 134679, 134681, 134682, 9308, 4048,
                    86297, 111238, 111239, 134237, 134240, 134244, 134245,
                    134247, 134249, 81654, 81660, 81661, 81663, 7274, 14077,
                    10618, 56829, 7275, 63124, 13891, 10623, 104305, 104306,
                    559, 6034, 5260, 2303, 13715, 13725, 13726, 77877, 77879,
                    14100, 1101, 5324, 4058, 10047, 2312, 13895, 13259, 13260,
                    10669, 106943, 106945, 106946, 9114, 9313, 10635, 9126,
                    10637, 1537, 13906, 9136, 7300, 9144, 139026, 139028, 9145,
                    1534, 9153, 1542, 9150, 5977, 3443, 12135, 4486, 138366,
                    138368, 4489, 10662, 10668, 14558, 14559, 273, 12581,
                    10272, 81257, 58979, 58980, 13734, 13739, 24004, 96487,
                    96488, 15269, 14094, 14096, 24776, 131075, 5282, 5284,
                    15301, 96493, 61381, 10673, 121757, 7339, 838, 10684,
                    10685, 18333, 106804, 106806, 112196, 12588, 778, 13911,
                    9166, 9168, 108887, 108889, 51714, 44815, 44818, 116470,
                    19005, 36156, 39438, 13913, 14108, 299, 1155, 543, 39430,
                    15284, 15287, 122570, 141967, 141968, 8645, 13926, 10703,
                    5341, 5343, 13730, 10699, 10700, 10707, 15305, 1851, 9201,
                    13736, 6037, 10709, 112119, 16736, 13759, 13762, 13764,
                    13933, 142120, 1513, 7352, 7355, 641, 9210, 4499, 10738,
                    132305, 11176, 13958, 12606, 139230, 2271, 12635, 10725,
                    10726, 7363, 7367, 5933, 69843, 12629, 12630, 14128, 14134,
                    13748, 13749, 10758, 15316, 9217, 68818, 9232, 10756,
                    14151, 13757, 12625, 12626, 16726, 15313, 10763, 13776,
                    142, 9233, 733, 13774, 7401, 12642, 69350, 10784, 9242,
                    7418, 9240, 69822, 7437, 9245, 14139, 14142, 9246, 7431,
                    9252, 7446, 9267, 9270, 141027, 9275, 12665, 10805, 9268,
                    10802, 10804, 121680, 139609, 1529, 2231, 3983, 10800,
                    110853, 10828, 10820, 10821, 10822, 5274, 14153, 4522,
                    5924, 10827, 10835, 10837, 13978, 5309, 51362, 75920,
                    75929, 13785, 4507, 13798, 13808, 13810, 6686, 6690, 5993,
                    16727, 113669, 13969, 13975, 41894, 106087, 106088, 17927,
                    17930, 99591, 12646, 41227, 51563, 51527, 50373, 50374,
                    51048, 40902, 40905, 41773, 41784, 51051, 84237, 51245,
                    50403, 41828, 51579, 51277, 88578, 51284, 131986, 41866,
                    42169, 42171, 46896, 51077, 42198, 42199, 42482, 51564,
                    51576, 51255, 51236, 51305, 51314, 51566, 50408, 50410,
                    51571, 50413, 50439, 51265, 51176, 50429, 50430, 50433,
                    51577, 51307, 51309, 50452, 50453, 51316, 51317, 106541,
                    42763, 52495, 104722, 44176, 44167, 113626, 103083, 84652,
                    84648, 84659, 81790, 84662, 108380, 108381, 10866, 10870,
                    10871, 13813, 13984, 9304, 520, 95, 12656, 54, 10624,
                    15310, 51657 )