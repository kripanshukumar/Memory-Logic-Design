module dp_ram_8x16 (rst,
                    rd_en,
                    rd_addr,
                    rd_clk,
                    wr_en,
                    wr_addr,
                    wr_clk,
                    data_in,
                    data_out);
    
    parameter RAM_WIDTH =  16;
    parameter RAM_DEPTH =  8;
    parameter ADDR_SIZE =  3;

    input rd_en, wr_en,rst, rd_clk, wr_clk;
    input [ADDR_SIZE - 1:0] rd_addr,wr_addr;
    input [RAM_WIDTH - 1:0] data_in;
    output wire [RAM_WIDTH - 1: 0] data_out;

    reg [RAM_WIDTH- 1: 0] temp;
    reg [RAM_WIDTH - 1: 0]mem[RAM_DEPTH-1:0];

    assign data_out = (rd_en)?temp:'hz;

    integer i;   

    always @(posedge wr_clk,posedge rd_clk, posedge rst)
    begin
        if(rst)
            begin
                for(i=0; i<RAM_DEPTH; i = i+1)
                    mem[i] <= 0;
            end
        if(wr_clk && wr_en)
            begin
                mem[wr_addr] <= data_in;
            end
        if(rd_clk && rd_en) begin
            temp <= mem[rd_addr];
            end
    end
endmodule



