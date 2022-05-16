module router_fifo (clock, resetn, write_enb, soft_reset, read_enb, data_in, lfd_state,
                empty, data_out, full);

parameter MEM_WIDTH = 9;
parameter MEM_DEPTH = 16;
parameter ADD_WIDTH = 4;

input clock, 
      resetn, 
      write_enb, 
      soft_reset, 
      read_enb,
      lfd_state;
input wire [MEM_WIDTH - 2: 0] data_in;

output wire [MEM_WIDTH - 2:0] data_out;
output wire empty;
output wire full;

wire [MEM_WIDTH-1:0] bus;

assign bus = {lfd_state,data_in};

reg [MEM_WIDTH - 1:0] mem [MEM_DEPTH - 1:0];
reg [MEM_WIDTH - 2:0] temp = 0;

reg [5:0] counter = 0;

reg [ADD_WIDTH :0] write_pointer = 0;
reg [ADD_WIDTH :0] read_pointer = 0;
wire last_bit_comp;
wire pointer_comp;

assign last_bit_comp = write_pointer[4] ~^ read_pointer[4];
assign pointer_equal = (write_pointer[0] ~^ read_pointer[0])&
                        (write_pointer[1] ~^ read_pointer[1])&
                        (write_pointer[2] ~^ read_pointer[2])&
                        (write_pointer[3] ~^ read_pointer[3]);
                        
assign empty = last_bit_comp & pointer_equal;
assign full = (~last_bit_comp) & pointer_equal;

assign data_out = (soft_reset| ~(|counter))?'hz:temp;
reg [ADD_WIDTH:0] itr =0;

initial begin
    $monitor("FULL: %d",full);
end

always @(posedge clock, negedge resetn) begin
    //$display($time,"  last_bit_comp: %d, pointer_equal : %d, write pointer: %d, read_pointer: %d",last_bit_comp,pointer_equal,write_pointer, read_pointer);
    if(!resetn)begin
        for(itr = 0; itr < MEM_DEPTH; itr = itr + 1)
            mem[itr] <= 0;
    end
    else if((write_enb) && (~full)) begin
        mem[write_pointer[3:0]] <= bus;
        write_pointer <= write_pointer + 1;
    end
    else if(~empty)begin
        if(read_enb)begin
            if(mem[read_pointer[3:0]][8] == 1'b1) begin
                counter <= mem[read_pointer[3:0]][7:2] + 1'b1;
            end
            else begin
                counter <= counter - 1;
            end
            temp <= mem[read_pointer[3:0]][7:0];
            read_pointer <= read_pointer + 1;
        end
    end
end

endmodule


