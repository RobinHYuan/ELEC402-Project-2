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
Simpler_Cipher_Decryption tb( clk, reset, next, okay, mode, msg_length_byte, encode_key_shift, key_caesar_shift ,halt, done,pt_mem,ct_mem ) ;

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