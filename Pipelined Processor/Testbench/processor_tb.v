module processor_tb_2;

reg clk, reset;

processor p(clk, reset);

always #5 clk=~clk;
initial
begin 
clk=1;
reset = 0;
#20;
reset=1;
#1000 $finish;
end
endmodule