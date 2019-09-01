module control(a,b,exp_diff,sel0,sel1,selE,carryout,shiftAmt,shiftMantissa,incdec);
input [31:0] a,b;
input [7:0] exp_diff;
output reg sel0,sel1,selE;
output reg [7:0] shiftAmt, shiftMantissa;
input [7:0] carryout;
output reg [7:0] incdec; 

always @ *
begin
shiftAmt = exp_diff;
shiftMantissa = carryout;
incdec = carryout;

if(a[30:23]>b[30:23])
begin
	sel0 = 0;
	sel1 = 1;
	selE = 0;
end

else
begin
	sel0 = 1;
	sel1 = 0;
	selE = 1;
end

if(exp_diff<0)
begin
shiftAmt = 0 -shiftAmt ;
end

end
endmodule
