/* 
Author: Robin Yuan (Student #: 88011879)
Date:   Sept, 2020
Library Used:
    altera_mf_ver
Memorry Module by Quartus: One Port - 8bit width/ 256 words(8-bit) - Output Unregistered
Description:
    This is a simple encryption/decryption module, which can be used to encrypt a block of text using caesar/ROT 13 
    encryption or to brute force attack the caesar/ROT13 ciphertext. We have two memory modules, CT and PT that are 
    resiponsible for saving the ciphertext and plaintext respectively. When encrypting/decrypting the date, 
    we read from the corresponding memorry module letter by letter then encrypt/decrpty and we finally store the 
    result in the opposite memorry module we read from. 
Coding Style:
    I dont like if statements; sorry
General Operation Procedure:
     a) Reset;
     b) Select Mode: [1] 2'b01-> Decrypt Caesar CT; [2] 2'b00/2'b10 -> Decrypt ROT 13 CT; [3] 2'b11-> Encrypt Caesar PT
        Press okay to continue
    c[1]) The ROT13 encryption is symmetric; therefore, it is very easy to decrpt. The module will set the eky shift unit 
          to 13 letters. Then, each letter in the ciphertext memorry is shifted accordingly. Press okay to finish      
    c[2])     
          The module will try to decrypt the ciphertext using brute force, namely attempt all possible keys.
          The user is required to check the PT memorry content constantly. Whenever the module finishes one 
          decryption cycle, the user need to check and see if the memorry content makes snese; if not, press next
          to try the next potenial key until the user find the PT text makes sense. When the user has confirmed 
          that the current key is correct, he should press okay to indicate a key has been foud; otherwise, the moudle 
          will be in halt state waiting for the next instruction.

     c/[3]) The module will automatcially encrypt your plaintext and save the ciphertext in the CT module.
     d) Finished
I/O Lists:
    clk:                1-bit  Clock Signal
    reset:              1-bit  Reset Signal (Synchronous)
    next:               1-bit  Press next to continue to decrypt ciphertext 
                               using next possible key combination; otherwise, halt
    okay:               1-bit  Press okay to confirm mode or key selection
    mode:               2-bit  To indicate the current operating mode
    msg_length_byte:    8-bit  2^8 == 256; Maximum 256 letters/spaces allowed for cipher/plain texts
    encode_key_shift:   5-bit  2^5 >= 26;  To indicate the key for encrypting the plaintext
    key_decode:         5-bit  the number of letters shifted to find the correct plaint text
    halt:               1-bit  To indicate the module is waitng for the next instruction; halting
    done:               1-bit  To indicae the current taks is finished 
*/

module Simpler_Cipher_Decryption (      
                                        input  logic clk, reset,
                                        input  logic next, okay,
                                        
                                        input  logic [1:0] mode  ,
                                        input  logic [7:0] msg_length_byte,
                                        input  logic [4:0] encode_key_shift,

                                        output logic [4:0] key,
                                        output logic halt,done,

                                        output logic [7:0] pt_mem [0:255],
                                        output logic [7:0] ct_mem [0:255]
                                 ) ;


    // Signals used to control the memorries
    logic [7:0] CT_address, PT_address;
    logic [7:0] CT_data_in, PT_data_in;
    logic [7:0] CT_q_out, PT_q_out;
    logic CT_wren, PT_wren;

    //Input Registers; in case the user unintenionally changes the input during computation 
    logic ROT_13_reg, Encode_reg;
    logic [4:0] input_key_reg;
    logic [4:0] key_decode;

    //overflow flags; helper signal make sure the resulted letter will stay in a-z or A-Z after decryption
    logic   Upper_Overflow_flag,Lower_Overflow_flag;
    assign  Upper_Overflow_flag = Encode_reg ? (((PT_q_out + encode_key_shift) >8'h5A) ? 1:0) : (((CT_q_out + key_decode) >8'h5A) ? 1:0);
    assign  Lower_Overflow_flag = Encode_reg ? (((PT_q_out + encode_key_shift) >8'h7A) ? 1:0) : (((CT_q_out + key_decode) >8'h7A) ? 1:0);

    //Memorry Module Instantiations
    RAM CT (CT_address, clk, CT_data_in, CT_wren, CT_q_out, ct_mem);
    RAM  PT (PT_address, clk, PT_data_in, PT_wren, PT_q_out, pt_mem);

    //Internal helper signals
    logic [3:0] state;
    
    // State Macros  
    `define Reset           4'b0000  
    `define Select_Mode     4'b0001  
    `define Mem_Read        4'b0010
    `define Mem_Wait        4'b0011
    `define PT_Write        4'b0100
    `define Decode_Inc      4'b0101
    `define Encode_Inc      4'b0111
    `define ROT_13          4'b1011
    `define Encode          4'b1001
    `define CT_Write        4'b1110
    `define Halt            4'b1100
    `define Wait            4'b1101
    `define End             4'b1111

// Finite State Machine 
    always_ff @( posedge clk ) begin 
        if (reset == 1) // Synchronous Reset; Set Important SIgnals to a known value
            {key_decode, CT_address, PT_address, CT_data_in, PT_data_in, CT_wren, PT_wren, state, halt, done,ROT_13_reg, Encode_reg, input_key_reg} 
                <= {5'b0, 16'b0, 16'b0, 2'b0, `Reset, 2'b0, 2'b0, 5'b0};
        else 
            casex (state) // State Transition
                 `Reset:        state <= `Select_Mode;
                 `Select_Mode:  state <=  okay ? (mode[0] ? (mode[1] ? `Encode : `Mem_Read ) : `ROT_13 ) : `Select_Mode;
                  4'b10x1:      state <= `Mem_Read; //4'b10x1 includes ROT_13 and Encode states
                 `Mem_Read:     state <= `Mem_Wait;
                 `Mem_Wait:     state <= `Wait;
                 `Wait:         state <= (Encode_reg) ? `CT_Write: `PT_Write;
                 `PT_Write:     state <= `Decode_Inc;
                 `CT_Write:     state <= `Encode_Inc;
                  4'b01x1  :    state <= (CT_address === msg_length_byte -1'b1) ? `Halt: `Mem_Read;//4'b01x1 include Decode_Inc and Encode_Inc
                 `Halt:         state <= (next && (!Encode_reg) ) ? `Mem_Read: (okay? `End : `Halt);
                 `End:          state <= `End;
                 default:       state <= `End;

                 /*
                    Reset:          Reset State;
                    Select Mode:    1) The user will set the mode using the input signal mode[1:0], which can be controlled by two slider switches in real life;
                                    2) The encodings are: [1] 2'b01-> Decrypt Caesar CT; [2] 2'b00/2'b10 -> Decrypt ROT 13 CT; [3] 2'b11-> Encrypt Caesar PT
                                    3) If the user has finished setting the mode nad the key if the user wish to encrypt messages, one should press okay to continue;
                                    4) The state will transit to Encode, Mem_Read, ROT_13 or itself only if the user hasnt pressed okay yet
                    Encode:         1) The module will register the input key and set mode flag just in case the user unintenionally changes the input during computation 
                                    2) Automatically shift to Mem_Read
                    ROT_13:         1) The module will lock the output key shift to 5'd13 and set mode flag just 
                                    2) Automatically shift to Mem_Read
                    Mem_Read:       1) Resiponsible for reading memorry content from PT or CT depending on the flag
                                    2) First state after Select_Mode for decrypting Ceasar ciphertext; Second State for decrypting rot13/ encrypting plaintext
                                    3) Set all wren signals to zeros; indicating reading operation 
                                    4) Other signals remain unchanged
                                
                    Mem_Wait:       1) This memoryy module requires two clock cycles for the memorry content of the indicated address to be presented at the output
                                    2) All signals reamin unchanged
                                    3) Depending on the Encode mode flag, the state will either go to CT_Write(1) or PT_Write(0)
                    PT_Write:       1) Now the module will try to decrypt the module by shifting the letter by key_decode;
                                    2) key_decode was set to 0 at the begining; then, it will increment every time when user presses next when the module is halting
                                    3) To decrypt rot13, we know that the shift will always be 13 
                                    4) We are using ASCII encoding, so all enlish letters will be in the intervals of (0x40, 0x5b) or (0x60, 0x7b)
                                       If the number we read from the memorry, CT_q_out is out of this bound, we leav it as it is;
                                       otherwise, we add key_decode to CT_q_out; it is possible for the resulted number to go out of bound after this addition;
                                       so we use modulus and overflow flags to prevent this from happening and to make sure the result wraps around the alpahbet;
                                       for example, 'z' shift by 3 === 'c'; NOT '}';
                                    5) Then the state will go to Decode_Inc
                    CT_Write:       1) Similiary ideas as PT_Write since the encryption/decryption method is rather similar; involving shifting the letters by a certain unit
                                       according to the alpahbet;
                                    2) The only difference is PT_Write writes to the plaintext/PT memorry and CT_Write writes to the ciphertext/CT memorry
                                    3) Then the state will go to Encode_Inc
                    Decode_Inc:     1) Increase the CT_adddress/PT_address or key_decode
                                    2) If we have decoded all letters in the CT mem and written them into PT mem; then, we increment key and then halt
                                       if the user press next, we then start dercypting the message using the new key
                                    3) otherwise, we increment the PT/CT address so we can read, decrypt and write the next letter in the message
                                    4) Halt
                    Encode_Inc:     1) Similary operation but we perform them in different memory modules
                                    2) Halt
                    Halt:           1) if the user presses next, then we start decrypting the module using the new key
                                    2) if the user presses okay, then go the end state
                                    3) otherwise, keep halting
                                    4) set halt flag
                    End:            1) Set finished flag
                                    2) Output key if it is on decryption modes
                                    3) Stay in this state unless reset is pressed 
                 */
            endcase

        casex(state)
            `Reset:         {key_decode, CT_address, PT_address, CT_data_in, PT_data_in, CT_wren, PT_wren, halt, done}  <= {0};
            `Select_Mode:   {key_decode, CT_address, PT_address, CT_data_in, PT_data_in, CT_wren, PT_wren, halt, done, ROT_13_reg, Encode_reg}  <= {0};

            `ROT_13:         {key_decode, ROT_13_reg} <= {5'd13, 1'b1};

            `Encode:         {input_key_reg, Encode_reg, PT_address, PT_data_in, PT_wren} <= {encode_key_shift, 1'b1, PT_address, 8'b0, 1'b0}; 

             4'b001x:       {CT_address, CT_data_in, CT_wren, PT_address, PT_data_in, PT_wren} <= {CT_address, 8'b0, 1'b0, PT_address, 8'b0, 1'b0} ; //includes mem_read and mem_Write
            
            `Wait:           {CT_address, CT_data_in, CT_wren, PT_address, PT_data_in, PT_wren} <= {CT_address, CT_data_in, CT_wren, PT_address, PT_data_in, PT_wren};

            `PT_Write:       {PT_address, PT_data_in, PT_wren} <= (CT_q_out >8'h40 && CT_q_out <8'h5B) ? {PT_address, (CT_q_out + key_decode) %8'h5b + Upper_Overflow_flag *8'h41, 1'b1}  : 
                                                                  ((CT_q_out >8'h60 && CT_q_out <8'h7b) ? {PT_address, (CT_q_out + key_decode) %8'h7b + Lower_Overflow_flag* 8'h61, 1'b1} : {PT_address, CT_q_out, 1'b1});
            
            `CT_Write:      {CT_address, CT_data_in, CT_wren} <= (PT_q_out >8'h40 && PT_q_out <8'h5B) ? {CT_address, (PT_q_out + input_key_reg) %8'h5b + Upper_Overflow_flag *8'h41, 1'b1}  : 
                                                                  ((PT_q_out >8'h60 && PT_q_out <8'h7b) ? {CT_address, (PT_q_out + input_key_reg) %8'h7b + Lower_Overflow_flag* 8'h61, 1'b1} : {CT_address, PT_q_out, 1'b1});

            `Decode_Inc:     {CT_address, PT_address, key_decode, PT_wren} <= (ROT_13_reg && (CT_address !== msg_length_byte-1'b1)) ? {CT_address+8'b1, PT_address+8'b1, key_decode, 1'b0} : 
                                                                                                   (CT_address === msg_length_byte-1'b1  ) ? {9'b0, 9'b0, key_decode + 5'b1, 1'b0}:
                                                                                                   {CT_address+8'b1, PT_address+8'b1, key_decode, 1'b0};

            `Encode_Inc:     {PT_address, CT_address, CT_wren} <= (PT_address!== (msg_length_byte-1'b1)) ? {PT_address+8'b1, CT_address+8'b1, 1'b0} : {PT_address,CT_address, 1'b0};
            `Halt:           {halt, PT_wren, CT_wren} <= {1'b1, 2'b0};
            `End:            {done, halt, PT_wren, CT_wren, key} <= (Encode_reg )? {1'b1, 3'b0, encode_key_shift}: {1'b1, 3'b0, (5'd26-(key_decode-1'b1))};
            
            default:       {key_decode, CT_address, PT_address, CT_data_in, PT_data_in, CT_wren, PT_wren, halt, done} 
                                <= {5'b0, 16'b0, 16'b0, 2'b0, 2'b0};
        endcase 
    end


endmodule