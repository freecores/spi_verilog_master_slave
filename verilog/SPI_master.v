////////////////////////////////////////////////////////////////////////////////////
// Design Name: SPI MASTER MODULE
// Module Name: spi_master
// Project Name: SPI
// Target Devices: Spartan 3E
//
// Designed by: Santhosh G
// Version: 1.2
// Description: for www.elecdude.com
//	SPI MODE-3
//		CHANGE DATA (sdout) @ NEGEDGE SCK 
//		read data (sdin) @posedge SCK 
//
// DISCLAIMER:
// ```````````
// Author:  Santhosh G
// 			santhoshg90@gmail.com                                
//
// Copyright - 2014 - Santhosh G
// 			 - OpenCores.org
//
// THIS SOURCE FILE MAY BE USED AND DISTRIBUTED WITHOUT        
// RESTRICTION PROVIDED THAT THIS COPYRIGHT STATEMENT IS NOT   
// REMOVED FROM THE FILE AND THAT ANY DERIVATIVE WORK CONTAINS 
// THE ORIGINAL COPYRIGHT NOTICE AND THE ASSOCIATED DISCLAIMER.
// 
//
// This source file is free software; you can redistribute it 
// and/or modify it under the terms of the GNU Lesser General 
// Public License as published by the Free Software Foundation; 
// either version 2.1 of the License, or (at your option) any 
// later version. 
//
// This source is distributed in the hope that it will be 
// useful, but WITHOUT ANY WARRANTY; without even the implied 
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
// PURPOSE. See the GNU Lesser General Public License for more 
// details. 
//
// You should have received a copy of the GNU Lesser General 
// Public License along with this source; if not, download it 
// from http://www.opencores.org/lgpl.shtml 
//
////////////////////////////////////////////////////////////////////////////////////

module spi_master(rstb,clk,mlb,start,tdat,cdiv,din, ss,sck,dout,done,rdata);
input rstb,clk,mlb,start; 
	 //RSTB-active low asyn reset & CLK-clock & mlb=0->LSB 1st, 1->msb 1st
	 //START=1- starts data transmission 
input [7:0] tdat;  //transmit data
input [1:0] cdiv;  //clock divider   0=clk/2,  1=clk/4,   2=clk/8,  3=clk/16
input din; //Master in-slave out (MISO)
output reg ss; //slave select
output reg sck; //clock
output reg dout; //Master out-slave in (MOSI)
output done; //ass_werted 1 when transmiss_wion complete
output reg [7:0] rdata; //received data

	parameter idle=2'b00;			
	parameter send=2'b10; 
	parameter finish=2'b11; 
	reg [1:0] cur,nxt; //state registers
	reg [7:0] treg,rreg; //Transmit & receive registers
	reg [3:0] nbit; //bit count
	reg [4:0] mid,cnt; //for SPI clock generation
	reg shift,clr;

assign done = ss & (~shift);
//state transistion
always@(negedge clk or negedge rstb) begin
 if(rstb==0) 
   cur<=finish;
 else 
   cur<=nxt;
 end
 
always@(rstb or cur) begin
	if(rstb==0)
		rdata<=8'hFF;
	else if(cur==finish)
		    rdata<=rreg;
end

//FSM input & outputs
always @(start or cur or nbit) begin
		 nxt=cur;
		 clr=0;  
		 shift=0;
		 case(cur)
			idle:begin
				clr=1;
				if(start==1)
		               begin 
						case (cdiv)
							2'b00: mid=2;
							2'b01: mid=4;
							2'b10: mid=8;
							2'b11: mid=16;
 						 endcase
						shift=1;	//done=1'b0;
						nxt=send;	 
						end
		        end //idle_ends
			send:begin
				ss=0;
				if(nbit!=8)
					begin shift=1; end
				else begin
						nxt=finish; //rdata=rreg;
					end
				end//send_ends
			finish:begin
					shift=0;	clr=1; 
					ss=1;	//done=1'b1; 
					nxt=idle;
				 end//finish_ends
			default: nxt=finish;
      endcase
end//always ends here

//clock generation
always@(negedge clk or posedge clr) begin
  if(clr==1) 
		begin cnt<=0; //sck=1; 
		sck<=1; 
		end
  else begin
	if(shift==1) begin
		//cnt=cnt+1; 
	  // if(cnt==mid) begin
	  	// sck=~sck;	  	//sck=~sck;
		// cnt=0;
		// end //mid
		if(cnt<mid-1)
			cnt<=cnt+1;
		else 
			cnt<=0;
		if(cnt<mid/2)
			sck<=1;
		else
			sck<=0;
	end //shift
 end //rst ends here
end //always ends here

//sample @ rising edge (read din)
always@(posedge sck or posedge clr ) begin 
    if(clr==1)  begin
			nbit<=0;  rreg<=8'hFF;  end
    else begin 
		  if(mlb==0) //LSB first, din@msb -> right shift
			begin  rreg<={din,rreg[7:1]};  end 
		  else  //MSB first, din@lsb -> left shift
			begin  rreg<={rreg[6:0],din};  end
		  nbit<=nbit+1;
 end //rst ends here
end //always ends here


//setup @ falling edge (send dout)
always@(negedge sck or posedge clr) begin
 if(clr==1) begin
		treg=8'hFF;  dout=1;  
	end  
 else begin
		if(nbit==0) begin //load data into TREG
			treg=tdat; dout=mlb?treg[7]:treg[0];
		end //nbit_if
		else begin
			if(mlb==0) //LSB first, shift right
			  begin treg={1'b1,treg[7:1]}; dout=treg[0]; end
			else//MSB first shift LEFT
			  begin treg={treg[6:0],1'b1}; dout=treg[7]; end
		end //nbit_else ends here
 end //rst ends here
end //always ends here

endmodule

