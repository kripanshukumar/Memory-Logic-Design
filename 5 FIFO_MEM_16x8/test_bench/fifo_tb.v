module fifo_tb();
    parameter MEM_WIDTH = 9;
    parameter MEM_DEPTH = 16;
    parameter ADD_WIDTH = 4;

    wire [MEM_WIDTH - 2:0] data_out;
    wire empty;
    wire full;

    reg [MEM_WIDTH - 2:0] data_in;
    reg clock, resetn, write_enb, soft_reset, read_enb, lfd_state;

    reg[6:0] k = 0;

    router_fifo DUT(clock, resetn, write_enb, soft_reset, read_enb, data_in, lfd_state,
                        empty, data_out, full);
    
    initial begin
        {clock, write_enb, soft_reset, read_enb, data_in, lfd_state} = 0;
        resetn = 1;
    end

    task write;
    reg[7:0] payload_data, parity, header;
    reg[5:0] payload_len;
    reg[1:0] addr;
        begin
            @(negedge clock);
            payload_len = $random%64;
            addr = $random%3;
            header = {payload_len,addr};
            data_in = header;
            lfd_state = 1'b1;
            write_enb = 1'b1;
            for(k = 0; k< payload_len; k= k+1)begin
                @(negedge clock)
                lfd_state = 1'b0;
                payload_data = $random%256;
                data_in = payload_data;
            end
            @(negedge clock);
            parity = $random%256;
            data_in = parity;
            #10
            write_enb = 1'b0;
        end
    endtask

    task read;
        begin
            @(negedge clock);
            read_enb = 1'b1;
        end
    endtask

    always
        #5 clock <= ~clock;
    
    initial begin
        repeat(1) begin
            $display($time,"Runnings..");
            #10 write;
        end
        repeat(20) begin
        #10 read;
        end
        $finish;
    end
   
endmodule