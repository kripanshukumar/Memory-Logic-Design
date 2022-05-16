module clock_buf_tb ();

    reg in = 0;
    wire out;

    clock_buf DUT(out,in);

    real time0, timeDiff, timeperiod, PHASE;
    

    always begin
        #36 in <= ~in;
        timeperiod = 2*($time - time0);
        time0 = $time;
        
    end

    always @(out) begin
        timeDiff = $time - time0;
        PHASE = (timeDiff/timeperiod)*360;
        $display("TIMEPERIOD: %d, TIME: %d, TIME_DIFFERENCE: %d, IN: %d, PHASE: %d",timeperiod, time0, timeDiff,in, PHASE);
    end

endmodule
        