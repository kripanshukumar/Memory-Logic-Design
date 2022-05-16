module ram_tb ();

parameter RAM_WIDTH = 8;
parameter RAM_DEPTH = 16;

reg clk,wr_enb,rd_enb,rst;
reg [3:0] rd_addr,wr_addr; 
reg [RAM_WIDTH - 1:0] data_in;
wire [RAM_WIDTH - 1: 0] data_out;

dp_ram_16x8 DUT (clk, wr_enb, rd_enb, rst, rd_addr, wr_addr, data_in, data_out);

integer i = 0;
integer data = 0;

initial begin
    {clk,wr_enb,rd_enb,rst,rd_addr,wr_addr} = 0;
end

always
begin
    #5 clk <= ~clk;
end

initial begin
    $display("======================WR_ENB=========================");
    for(i = 0; i<RAM_DEPTH; i = i+1)
    begin
        wr_addr <= i;
        data_in = $random%255;
        wr_enb = 1'b1;
        #10;
        wr_enb = 1'b0;
        $display("WR_ADDR: %d, DATA_IN: %d",wr_addr,data_in);
    end
    #40;
    $display("=======================RD_ENB========================");
    for(i = 0; i<RAM_DEPTH; i = i+1)
    begin
        rd_addr <= i;
        rd_enb = 1'b1;
        #10;
        rd_enb = 1'b0;
        $display("RD_ADDR: %d, DATA_UT: %d",rd_addr,data_out);
    end
    #40
    rst = 1'b1;
    #10 rst = 1'b0;
    $display("===================RESET PRESSED=======================");
    for(i = 0; i<RAM_DEPTH; i = i+1)
    begin
        rd_addr <= i;
        rd_enb = 1'b1;
        #10;
        rd_enb = 1'b0;
        $display("WR_ADDR: %d, DATA_UT: %d",rd_addr,data_out);
    end
    #20 $finish;
end

endmodule



