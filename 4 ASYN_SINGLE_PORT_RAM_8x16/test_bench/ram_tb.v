module ram_tb ();

parameter RAM_WIDTH = 16;
parameter RAM_DEPTH = 8;
parameter ADDR_SIZE = 3;

reg we,en,oe,rst;
reg [ADDR_SIZE-1:0] addr; 
reg [RAM_WIDTH - 1:0] data_in;
wire [RAM_WIDTH - 1: 0] data_port;

assign data_port = !oe? data_in: 'hz;

sp_ram_8x16 DUT (we, en, oe,rst, addr, data_port);

integer i = 0;
integer data = 0;

initial begin
    {we,en,oe,rst,addr,data_in} = 0;
end


initial begin
    $display("======================WR_ENB=========================");
    for(i = 0; i<RAM_DEPTH; i = i+1)
    begin
        addr <= i;
        data_in <= $random%65535;
        we <= 1'b1;
        #5 en <= ~en;
        #5 en <= ~en;
        we <= 1'b0;
        $display("WR_ADDR: %d, DATA_IN: %d",addr,data_port);
    end
    #40;
    $display("=======================RD_ENB========================");
    for(i = 0; i<RAM_DEPTH; i = i+1)
    begin
        addr = i;
        we <= 1'b0;
        oe <= 1'b1;
        #5 en <= ~en;
        #5 en <= ~en;
        $display("RD_ADDR: %d, DATA_OUT: %d",addr,data_port);
    end
    #40
    rst = 1'b1;
    #10 rst = 1'b0;
    $display("===================RESET PRESSED=======================");
    for(i = 0; i<RAM_DEPTH; i = i+1)
    begin
        addr = i;
        we <= 1'b0;
        oe <= 1'b1;
        #5 en <= ~en;
        #5 en <= ~en;
        $display("WR_ADDR: %d, DATA_OUT: %d",addr,data_port);
    end
    #20 $finish;
end

endmodule



