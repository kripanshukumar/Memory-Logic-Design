module sp_ram_8x16 (wr,
                    en,
                    oe,
                    rst,
                    addr,
                    data);

    parameter RAM_WIDTH =  16;
    parameter RAM_DEPTH =  8;
    parameter ADDR_SIZE =  3;

    input wr,en,oe,rst;
    input [ADDR_SIZE-1:0] addr;
    inout wire [RAM_WIDTH-1:0] data;

    reg [RAM_WIDTH - 1: 0] tmp_data;
    reg [RAM_WIDTH - 1: 0] mem [RAM_DEPTH - 1: 0];

    integer i =0;

    always @(posedge en, posedge rst)
    begin
        if(rst)
            begin
                for(i=0; i<RAM_DEPTH; i = i+1)
                    mem[i] = 0;
            end
        if(en)
            begin
                if(wr) 
                begin
                    mem[addr] <= data;
                end
                else 
                begin
                    tmp_data <= mem[addr];
                end
            end
    end

    assign data = en & oe & !wr? tmp_data : 'hz;

endmodule