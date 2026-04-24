`timescale 1ns / 1ps

module TopLevelProcessor_tb;

    reg clk;
    reg rst;
    reg [15:0] switches;
    reg reset_btn;
    wire [31:0] display_out;

    TopLevelProcessor uut (
        .clk(clk),
        .rst(rst),
        .switches(switches),
        .reset_btn(reset_btn),
        .display_out(display_out)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    // Monitor display changes
    reg [31:0] prev_display;
    integer fib_count;

    always @(posedge clk) begin
        if (display_out !== prev_display) begin
            $display("Time=%0t ns | display_out = %0d (0x%04H) | Fib #%0d",
                     $time, display_out, display_out[15:0], fib_count);
            prev_display <= display_out;
            fib_count <= fib_count + 1;
        end
    end

    initial begin
        // --- Initialize ---
        clk = 0;
        rst = 1;
        switches = 16'd0;
        reset_btn = 0;
        prev_display = 32'hDEADBEEF;
        fib_count = 0;

        // Hold reset
        #100;
        rst = 0;

        $display("=== Task C: Fibonacci Sequence Test ===");
        $display("NOTE: Delay loops set to 2000. For full sim,");
        $display("      change rom[27-28] to 0x002 and run 5000ns.");
        $display("");

        // Run long enough to see first display value (before delay loop)
        #100;

        $display("");
        $display("--- First Fibonacci value check ---");
        $display("  display_out = %0d (expect 0 = first Fibonacci)", display_out);
        if (display_out == 32'd0)
            $display("  >> FIBONACCI INIT PASSED <<");
        else
            $display("  >> CHECK FAILED << (got %0d)", display_out);

        $display("");
        $display("For full sequence verification:");
        $display("  1. Change rom[27]=00200313, rom[28]=00200393");
        $display("  2. Re-run simulation for 5000 ns");
        $display("  3. Expected: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34...");

        #500;
        $finish;
    end

endmodule
