`timescale 1ns / 1ps


module priorityq_tb();
wire q_empty,q_full;
reg clk,rst,enq_req,deq_req,pq;
reg [31:0]enq_data;
wire [31:0]deq_data;
// initializing the module from priorityq
priorityq q1(clk,rst,enq_req,q_empty,deq_req,q_full,deq_data,enq_data,pq);
// resetting the registers to initial value 0.
initial
begin
clk = 1'b0;
rst=1'b0;
enq_req=1'b0;
deq_req=1'b0;
enq_data=0;
forever
begin
pq=0;
#5 clk =~clk;
end
#800 $finish;
end
// Sending the test data inputs.
initial
begin
#5 enq_req=1'b1;

#10 enq_data=32'h12000007;
#10 enq_data=32'h13000002;
#10 enq_data=32'h14000005;
#10 enq_data=32'h21000007;
#10 enq_data=32'h23000003;
#10 enq_data=32'h24000006;
#10 enq_data=32'h31000002;
#10 enq_data=32'h32000003;
#10 enq_data=32'h34000004;
#10 enq_data=32'h41000005;
#10 enq_data=32'h42000006;
#10 enq_data=32'h43000004;
#10 enq_data=32'hffffffff;
#5 enq_req=1'b0;
#5 deq_req=1'b1;
end
endmodule