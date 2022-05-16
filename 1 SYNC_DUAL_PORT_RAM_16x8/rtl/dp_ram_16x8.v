module dp_ram_16x8 (clk,
                    wr_enb,
                    rd_enb,
                    rst,
                    rd_addr,
                    wr_addr,
                    data_in,
                    data_out);
    
    parameter RAM_WIDTH =  8;
    parameter RAM_DEPTH =  16;
    parameter ADDR_SIZE =  4;

    input clk,wr_enb,rd_enb,rst;
    input [3:0] rd_addr,wr_addr;
    input [RAM_WIDTH - 1:0] data_in;
    output reg [RAM_WIDTH - 1: 0] data_out;

    reg [RAM_WIDTH - 1: 0]mem[RAM_DEPTH-1:0];

    integer i;

    always @(posedge clk)
    begin
        if(rst)
            begin
                for(i=0; i<RAM_DEPTH; i = i+1)
                    mem[i] = 0;
            end
        else
            begin
                if(wr_enb)
                    mem[wr_addr] <= data_in;
                if(rd_enb)
                    data_out <= mem[rd_addr];
            end
    end
endmodule