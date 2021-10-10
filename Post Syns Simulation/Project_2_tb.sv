/*
THIS IS A SIMPLE TESTBENCH FOR PROJECT 1 WHERE THREE INDIVIDUAL TESTS ARE INCLUDED
DATE: SEPY, 2021
AUTHOR: ROBIN YUAN
*/

`timescale 100 ps / 1 ps
module tb_Simpler_Cipher_Decryption();

logic clk, reset;
logic next, okay;
  
logic [1:0] mode;
logic [7:0] msg_length_byte;
  
logic [4:0] key_caesar_shift, encode_key_shift;
logic halt, done;
logic [7:0] pt_mem [0:255];
logic [7:0] ct_mem [0:255];

Simpler_Cipher_Decryption tb( clk, reset, next, okay, mode, msg_length_byte, encode_key_shift, key_caesar_shift ,halt, done,pt_mem[255] ,
     pt_mem[254] , pt_mem[253] , pt_mem[252] , pt_mem[251] ,
     pt_mem[250] , pt_mem[249] , pt_mem[248] , pt_mem[247] ,
     pt_mem[246] , pt_mem[245] , pt_mem[244] , pt_mem[243] ,
     pt_mem[242] , pt_mem[241] , pt_mem[240] , pt_mem[239] ,
     pt_mem[238] , pt_mem[237] , pt_mem[236] , pt_mem[235] ,
     pt_mem[234] , pt_mem[233] , pt_mem[232] , pt_mem[231] ,
     pt_mem[230] , pt_mem[229] , pt_mem[228] , pt_mem[227] ,
     pt_mem[226] , pt_mem[225] , pt_mem[224] , pt_mem[223] ,
     pt_mem[222] , pt_mem[221] , pt_mem[220] , pt_mem[219] ,
     pt_mem[218] , pt_mem[217] , pt_mem[216] , pt_mem[215] ,
     pt_mem[214] , pt_mem[213] , pt_mem[212] , pt_mem[211] ,
     pt_mem[210] , pt_mem[209] , pt_mem[208] , pt_mem[207] ,
     pt_mem[206] , pt_mem[205] , pt_mem[204] , pt_mem[203] ,
     pt_mem[202] , pt_mem[201] , pt_mem[200] , pt_mem[199] ,
     pt_mem[198] , pt_mem[197] , pt_mem[196] , pt_mem[195] ,
     pt_mem[194] , pt_mem[193] , pt_mem[192] , pt_mem[191] ,
     pt_mem[190] , pt_mem[189] , pt_mem[188] , pt_mem[187] ,
     pt_mem[186] , pt_mem[185] , pt_mem[184] , pt_mem[183] ,
     pt_mem[182] , pt_mem[181] , pt_mem[180] , pt_mem[179] ,
     pt_mem[178] , pt_mem[177] , pt_mem[176] , pt_mem[175] ,
     pt_mem[174] , pt_mem[173] , pt_mem[172] , pt_mem[171] ,
     pt_mem[170] , pt_mem[169] , pt_mem[168] , pt_mem[167] ,
     pt_mem[166] , pt_mem[165] , pt_mem[164] , pt_mem[163] ,
     pt_mem[162] , pt_mem[161] , pt_mem[160] , pt_mem[159] ,
     pt_mem[158] , pt_mem[157] , pt_mem[156] , pt_mem[155] ,
     pt_mem[154] , pt_mem[153] , pt_mem[152] , pt_mem[151] ,
     pt_mem[150] , pt_mem[149] , pt_mem[148] , pt_mem[147] ,
     pt_mem[146] , pt_mem[145] , pt_mem[144] , pt_mem[143] ,
     pt_mem[142] , pt_mem[141] , pt_mem[140] , pt_mem[139] ,
     pt_mem[138] , pt_mem[137] , pt_mem[136] , pt_mem[135] ,
     pt_mem[134] , pt_mem[133] , pt_mem[132] , pt_mem[131] ,
     pt_mem[130] , pt_mem[129] , pt_mem[128] , pt_mem[127] ,
     pt_mem[126] , pt_mem[125] , pt_mem[124] , pt_mem[123] ,
     pt_mem[122] , pt_mem[121] , pt_mem[120] , pt_mem[119] ,
     pt_mem[118] , pt_mem[117] , pt_mem[116] , pt_mem[115] ,
     pt_mem[114] , pt_mem[113] , pt_mem[112] , pt_mem[111] ,
     pt_mem[110] , pt_mem[109] , pt_mem[108] , pt_mem[107] ,
     pt_mem[106] , pt_mem[105] , pt_mem[104] , pt_mem[103] ,
     pt_mem[102] , pt_mem[101] , pt_mem[100] , pt_mem[99] ,
     pt_mem[98] , pt_mem[97] , pt_mem[96] , pt_mem[95] ,
     pt_mem[94] , pt_mem[93] , pt_mem[92] , pt_mem[91] ,
     pt_mem[90] , pt_mem[89] , pt_mem[88] , pt_mem[87] ,
     pt_mem[86] , pt_mem[85] , pt_mem[84] , pt_mem[83] ,
     pt_mem[82] , pt_mem[81] , pt_mem[80] , pt_mem[79] ,
     pt_mem[78] , pt_mem[77] , pt_mem[76] , pt_mem[75] ,
     pt_mem[74] , pt_mem[73] , pt_mem[72] , pt_mem[71] ,
     pt_mem[70] , pt_mem[69] , pt_mem[68] , pt_mem[67] ,
     pt_mem[66] , pt_mem[65] , pt_mem[64] , pt_mem[63] ,
     pt_mem[62] , pt_mem[61] , pt_mem[60] , pt_mem[59] ,
     pt_mem[58] , pt_mem[57] , pt_mem[56] , pt_mem[55] ,
     pt_mem[54] , pt_mem[53] , pt_mem[52] , pt_mem[51] ,
     pt_mem[50] , pt_mem[49] , pt_mem[48] , pt_mem[47] ,
     pt_mem[46] , pt_mem[45] , pt_mem[44] , pt_mem[43] ,
     pt_mem[42] , pt_mem[41] , pt_mem[40] , pt_mem[39] ,
     pt_mem[38] , pt_mem[37] , pt_mem[36] , pt_mem[35] ,
     pt_mem[34] , pt_mem[33] , pt_mem[32] , pt_mem[31] ,
     pt_mem[30] , pt_mem[29] , pt_mem[28] , pt_mem[27] ,
     pt_mem[26] , pt_mem[25] , pt_mem[24] , pt_mem[23] ,
     pt_mem[22] , pt_mem[21] , pt_mem[20] , pt_mem[19] ,
     pt_mem[18] , pt_mem[17] , pt_mem[16] , pt_mem[15] ,
     pt_mem[14] , pt_mem[13] , pt_mem[12] , pt_mem[11] ,
     pt_mem[10] , pt_mem[9] , pt_mem[8] , pt_mem[7] , pt_mem[6] ,
     pt_mem[5] , pt_mem[4] , pt_mem[3] , pt_mem[2] , pt_mem[1] ,
     pt_mem[0] , ct_mem[255] , ct_mem[254] , ct_mem[253] ,
     ct_mem[252] , ct_mem[251] , ct_mem[250] , ct_mem[249] ,
     ct_mem[248] , ct_mem[247] , ct_mem[246] , ct_mem[245] ,
     ct_mem[244] , ct_mem[243] , ct_mem[242] , ct_mem[241] ,
     ct_mem[240] , ct_mem[239] , ct_mem[238] , ct_mem[237] ,
     ct_mem[236] , ct_mem[235] , ct_mem[234] , ct_mem[233] ,
     ct_mem[232] , ct_mem[231] , ct_mem[230] , ct_mem[229] ,
     ct_mem[228] , ct_mem[227] , ct_mem[226] , ct_mem[225] ,
     ct_mem[224] , ct_mem[223] , ct_mem[222] , ct_mem[221] ,
     ct_mem[220] , ct_mem[219] , ct_mem[218] , ct_mem[217] ,
     ct_mem[216] , ct_mem[215] , ct_mem[214] , ct_mem[213] ,
     ct_mem[212] , ct_mem[211] , ct_mem[210] , ct_mem[209] ,
     ct_mem[208] , ct_mem[207] , ct_mem[206] , ct_mem[205] ,
     ct_mem[204] , ct_mem[203] , ct_mem[202] , ct_mem[201] ,
     ct_mem[200] , ct_mem[199] , ct_mem[198] , ct_mem[197] ,
     ct_mem[196] , ct_mem[195] , ct_mem[194] , ct_mem[193] ,
     ct_mem[192] , ct_mem[191] , ct_mem[190] , ct_mem[189] ,
     ct_mem[188] , ct_mem[187] , ct_mem[186] , ct_mem[185] ,
     ct_mem[184] , ct_mem[183] , ct_mem[182] , ct_mem[181] ,
     ct_mem[180] , ct_mem[179] , ct_mem[178] , ct_mem[177] ,
     ct_mem[176] , ct_mem[175] , ct_mem[174] , ct_mem[173] ,
     ct_mem[172] , ct_mem[171] , ct_mem[170] , ct_mem[169] ,
     ct_mem[168] , ct_mem[167] , ct_mem[166] , ct_mem[165] ,
     ct_mem[164] , ct_mem[163] , ct_mem[162] , ct_mem[161] ,
     ct_mem[160] , ct_mem[159] , ct_mem[158] , ct_mem[157] ,
     ct_mem[156] , ct_mem[155] , ct_mem[154] , ct_mem[153] ,
     ct_mem[152] , ct_mem[151] , ct_mem[150] , ct_mem[149] ,
     ct_mem[148] , ct_mem[147] , ct_mem[146] , ct_mem[145] ,
     ct_mem[144] , ct_mem[143] , ct_mem[142] , ct_mem[141] ,
     ct_mem[140] , ct_mem[139] , ct_mem[138] , ct_mem[137] ,
     ct_mem[136] , ct_mem[135] , ct_mem[134] , ct_mem[133] ,
     ct_mem[132] , ct_mem[131] , ct_mem[130] , ct_mem[129] ,
     ct_mem[128] , ct_mem[127] , ct_mem[126] , ct_mem[125] ,
     ct_mem[124] , ct_mem[123] , ct_mem[122] , ct_mem[121] ,
     ct_mem[120] , ct_mem[119] , ct_mem[118] , ct_mem[117] ,
     ct_mem[116] , ct_mem[115] , ct_mem[114] , ct_mem[113] ,
     ct_mem[112] , ct_mem[111] , ct_mem[110] , ct_mem[109] ,
     ct_mem[108] , ct_mem[107] , ct_mem[106] , ct_mem[105] ,
     ct_mem[104] , ct_mem[103] , ct_mem[102] , ct_mem[101] ,
     ct_mem[100] , ct_mem[99] , ct_mem[98] , ct_mem[97] ,
     ct_mem[96] , ct_mem[95] , ct_mem[94] , ct_mem[93] ,
     ct_mem[92] , ct_mem[91] , ct_mem[90] , ct_mem[89] ,
     ct_mem[88] , ct_mem[87] , ct_mem[86] , ct_mem[85] ,
     ct_mem[84] , ct_mem[83] , ct_mem[82] , ct_mem[81] ,
     ct_mem[80] , ct_mem[79] , ct_mem[78] , ct_mem[77] ,
     ct_mem[76] , ct_mem[75] , ct_mem[74] , ct_mem[73] ,
     ct_mem[72] , ct_mem[71] , ct_mem[70] , ct_mem[69] ,
     ct_mem[68] , ct_mem[67] , ct_mem[66] , ct_mem[65] ,
     ct_mem[64] , ct_mem[63] , ct_mem[62] , ct_mem[61] ,
     ct_mem[60] , ct_mem[59] , ct_mem[58] , ct_mem[57] ,
     ct_mem[56] , ct_mem[55] , ct_mem[54] , ct_mem[53] ,
     ct_mem[52] , ct_mem[51] , ct_mem[50] , ct_mem[49] ,
     ct_mem[48] , ct_mem[47] , ct_mem[46] , ct_mem[45] ,
     ct_mem[44] , ct_mem[43] , ct_mem[42] , ct_mem[41] ,
     ct_mem[40] , ct_mem[39] , ct_mem[38] , ct_mem[37] ,
     ct_mem[36] , ct_mem[35] , ct_mem[34] , ct_mem[33] ,
     ct_mem[32] , ct_mem[31] , ct_mem[30] , ct_mem[29] ,
     ct_mem[28] , ct_mem[27] , ct_mem[26] , ct_mem[25] ,
     ct_mem[24] , ct_mem[23] , ct_mem[22] , ct_mem[21] ,
     ct_mem[20] , ct_mem[19] , ct_mem[18] , ct_mem[17] ,
     ct_mem[16] , ct_mem[15] , ct_mem[14] , ct_mem[13] ,
     ct_mem[12] , ct_mem[11] , ct_mem[10] , ct_mem[9] , ct_mem[8]
     , ct_mem[7] , ct_mem[6] , ct_mem[5] , ct_mem[4] , ct_mem[3] ,
     ct_mem[2] , ct_mem[1] , ct_mem[0] ) ;

initial forever #1 clk = ! clk;
/*
THE TESTBECH IS VERY INTUITIVE WHERE THREE SEPARETE TESTS ARE INCLUDED.
THEY ARE USED TO TEST OUT THE CASESAR CIPHER DECRYPTION, ENCRYPTION 
AND ROT13 DECRYPTION FUNCTIONS RESPECTIVELY. THE PROCEDURES ARR ALIKE 
AS WELL. LOAD MEMH FILES-> CLEAR MEMORY RESET AND SET OTHER REQUIRED SIGNALS
-> WAIT FOR COMPUTATION -> (CHECK THE NEXT KEY/ASSERT NEXT) [TEST1 ONLY] <->
EHCK MEMORY RESULT -> ASSERT OKAY TO END

TEST 1 EXPECTED RESULT: PT[The quick brown fox jumps over the lazy dog] WITH KEY 3
TEST 2 EXPECTED RESULT :CT[Wkh txlfn eurzq ira mxpsv ryhu wkh odcb grj] 
TEST 3 EXPECTED RESULT: PT[Matou Sakura is the best girl] WITH KEY 13

*/
initial begin
    //The quick brown fox jumps over the lazy dog_shift_by 3.memh
    $readmemh("The quick brown fox jumps over the lazy dog_shift_by 3.memh", ct_mem);

    clk =  0; reset = 1;
    next = 0; okay  = 0;
    mode = 1; msg_length_byte = 43; #15;
    reset = 0; #15;

    repeat(2) #15 okay = ! okay;
    #5000;

    repeat(23) begin
        next = 1; #15; next = 0; 
        #5000;
    end 
    repeat(2) #15 okay = ! okay;

    #2500;
    $readmemh("blank.memh", ct_mem);
    $readmemh("blank.memh", pt_mem);
    #100;$readmemh("The quick brown fox jumps over the lazy dog_original.memh", pt_mem);
    repeat (2) #15 reset = ! reset; msg_length_byte = 43;
    encode_key_shift = 3; #15 mode = 3;
    repeat(2) #15 okay = ! okay;
    #5000;
    repeat(2) #15 okay = ! okay;

    $readmemh("blank.memh", ct_mem);
    $readmemh("blank.memh", pt_mem);
    #100;$readmemh("ROT13-29.memh", ct_mem);
    repeat (2) #15 reset = ! reset; 
     #15 mode = 0;msg_length_byte = 29;
    repeat(2) #15 okay = ! okay;
    #12000;
    repeat(2) #15 okay = ! okay;
    #2500;
    $stop;

end
endmodule