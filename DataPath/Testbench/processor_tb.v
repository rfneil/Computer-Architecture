module processor_tb;

reg clk, reset;
processor nottatti(clk, reset);

always #10 clk = ~clk;

initial begin
clk = 1;
reset = 0;
#10;
reset = 1;
#300;
$finish;
end 
endmodule
