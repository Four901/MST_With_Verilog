`timescale 1ns / 1ps

module QueueSwap(clk,rst,shunt,shuntin,q,qin,deq_req,pq);
output [31:0]shunt,q;
input [31:0]shuntin,qin;
input clk,rst,deq_req,pq;
reg [31:0]shunt,q;
wire [31:0]shuntin,qin;
wire clk,rst,deq_req,pq;

initial
begin
shunt=0;
q=0;
end

always @(rst)
begin
shunt=0;
q=0;
end

always @(negedge clk)
begin
if(shunt!=0&&pq==0&&q!=0&&q[23:0]>shunt[23:0])
begin
{q[31:0],shunt[31:0]}={shunt[31:0],q[31:0]};
end
if(shunt!=0&&q==0)
begin
{q[31:0],shunt[31:0]}={shunt[31:0],q[31:0]};
end
if(shunt!=0&&pq==1&&q!=0&&q[23:0]<shunt[23:0])
begin
{q[31:0],shunt[31:0]}={shunt[31:0],q[31:0]};
end
if(shunt!=0&&q==0)
begin
{q[31:0],shunt[31:0]}={shunt[31:0],q[31:0]};
end
end

always @(posedge clk)
begin
if(deq_req==0)
begin
shunt=shuntin;
end
if(deq_req==1)
begin
q=qin;
end
end
endmodule

module priorityq(clk,rst,enq_req,q_empty,deq_req,q_full,deq_data,enq_data,pq,store);
output q_empty,q_full;
output [31:0]deq_data;
output [0:15]store;
input clk,rst;
input [31:0]enq_data;
input enq_req,deq_req,pq;
reg q_empty,q_full;
reg [31:0]deq_data;
wire clk,rst,pq;
wire [31:0]enq_data;
wire enq_req,deq_req;
reg [0:15]store;
parameter Q_MAX_SIZE=16;
integer q_size;
wire [31:0]shuntin[0:Q_MAX_SIZE-1];
wire [31:0]qin[0:Q_MAX_SIZE-1];
wire [31:0]deq_data_store;
initial
begin
store=16'b0;
end
genvar i;
generate
for (i=0; i<=0; i=i+1)
begin
 QueueSwap slice(clk,rst,shuntin[i+1],enq_data,deq_data_store,qin[i],deq_req,pq);
 end
for (i=1; i<=Q_MAX_SIZE-2; i=i+1)
begin
 QueueSwap slice(clk,rst,shuntin[i+1],shuntin[i],qin[i-1],qin[i],deq_req,pq);
 end
for (i=Q_MAX_SIZE-1; i<=Q_MAX_SIZE-1; i=i+1)
begin
 QueueSwap slice(clk,rst,shuntin[i],shuntin[i],qin[i-1],,deq_req,pq);
 end
endgenerate

initial
begin
q_empty=1;
q_full=1;
deq_data=0;
q_size=0;
end
always @(rst)
begin
q_empty=1;
q_full=1;
deq_data=0;
q_size=0;
end

always @(q_size)
begin
if(q_size==0)
begin
q_empty=1;
q_full=0;
end
else if(q_size==Q_MAX_SIZE)
begin
q_empty=0;  
q_full=1;
end
else
begin
q_empty=0;
q_full=0;
end
end

always @(posedge clk)
begin
if(enq_req==1&&deq_req==0&&q_size<Q_MAX_SIZE&&enq_data!=0)
begin
q_size=q_size+1;
end
end
integer temp;
initial
begin
temp=0;
end

always @(posedge clk)
begin
if(enq_req==0&&deq_req==1&&q_size>0)
begin
if ((deq_data_store[31:28]==store[0:3] || deq_data_store[31:28]==store[4:7] || deq_data_store[31:28]==store[8:11] || deq_data_store[31:28]==store[12:15]) && (deq_data_store[27:24]==store[0:3] ||deq_data_store[27:24]==store[4:7] || deq_data_store[27:24]==store[8:11] || deq_data_store[27:24]==store[12:15]))
begin
deq_data=32'hxxxxx;
q_size=q_size-1;
end
else
begin
if ((deq_data_store[31:28]!=store[0:3] && deq_data_store[31:28]!=store[4:7] && deq_data_store[31:28]!=store[8:11] && deq_data_store[31:28]!=store[12:15]))
begin


if(store[0:3]==4'b0000)
begin
store[0:3]=deq_data_store[31:28];
end
else if(store[4:7]==4'b0000)
begin
store[4:7]=deq_data_store[31:28];
end
else if(store[8:11]==4'b0000)
begin
store[8:11]=deq_data_store[31:28];
end
else if(store[12:15]==4'b0000)
begin
store[12:15]=deq_data_store[31:28];
end


//store[temp]=deq_data_store[31:28];
//temp=temp+1;
end
if ((deq_data_store[27:24]!=store[0:3] && deq_data_store[27:24]!=store[4:7] && deq_data_store[27:24]!=store[8:11] && deq_data_store[27:24]!=store[12:15]))
begin


if(store[0:3]==4'b0000)
begin
store[0:3]=deq_data_store[27:24];
end
else if(store[4:7]==4'b0000)
begin
store[4:7]=deq_data_store[27:24];
end
else if(store[8:11]==4'b0000)
begin
store[8:11]=deq_data_store[27:24];
end
else if(store[12:15]==4'b0000)
begin
store[12:15]=deq_data_store[27:24];
end

//store[temp]=deq_data_store[27:24];
//temp=temp+1;
end
deq_data=deq_data_store;
q_size=q_size-1;
end
end
end
endmodule