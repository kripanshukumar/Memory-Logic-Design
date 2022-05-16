module ram_tb ();

parameter RAM_WIDTH = 16;
parameter RAM_DEPTH = 8;

reg rst;
reg rd_clk = 0;
reg wr_clk = 0;
reg rd_en = 1;
reg wr_en = 1;
reg [2:0] rd_addr,wr_addr; 
reg [RAM_WIDTH - 1:0] data_in;
wire [RAM_WIDTH - 1: 0] data_out;

dp_ram_8x16 DUT (rst, rd_en,rd_addr, rd_clk,wr_en, wr_addr, wr_clk, data_in, data_out);

integer i = 0;
integer data = 0;

initial begin
    {rst,rd_addr,wr_addr} = 0;
end

always
    #5 rd_clk <= ~rd_clk;
always
    #7 wr_clk <= ~wr_clk;

initial begin
    $monitor($time," READ ADDRESS: %d, DATA READ: %d, WRITE ADDRESS: %d, DATA WRITTEN: %d",rd_addr,data_out,wr_addr,data_in);
end

initial begin
    repeat(50)begin
        rd_addr <= $random % 8;
        wr_addr <= $random % 8;
        data_in <= $random % 256;
        #15;
    end
    wr_addr <= 0;
    data_in <= 0;
    #40;
    rst = 1'b1;
    #10 rst = 1'b0;
    $display("===================RESET PRESSED=======================");
    for(i = 0; i<RAM_DEPTH; i = i+1)
    begin
        rd_addr = i;
        #10;
    end
    #20 $finish;
end

endmodule



