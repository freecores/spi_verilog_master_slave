//////////////////////////////////////////////////////////////////////////////////	
// Design Name: SPI SLAVE MODULE
// Module Name: SPI_slave 
// Project Name: SPI
// Target Devices: Spartan 3E
// Designed by: Santhosh G
// Version: 1.1
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
//////////////////////////////////////////////////////////////////////////////////	
module SPI_slave (rstb,ten,tdata,mlb,ss,sck,sdin, sdout,done,rdata);
  input rstb,mlb;  	//control signals rstb-> active low, mlb=0-> lsb 1st, =1-> MSB 1st
  input ten;  		//slave data out enable if 1, else tri-state 
  input ss,sck; 	//SPI interface signals (SS,SCK)
  input sdin; 		//slave in-master out (MOSI)
  input [7:0] tdata;//data to be transmitted
  output sdout;     //slave out-master in (MISO) 
  output done;		//signals transmission completed
  output reg [7:0] rdata; //received data

  reg [7:0] treg,rreg;
  reg [3:0] nb; //bit count
  wire sout,clr;
  reg dw;
  
  assign done= dw & ss;
  assign sout= mlb?treg[7]:treg[0]; //select MSB or LSB
  assign sdout= ( (!ss)&&ten )?sout:1'bz; //if 1=> send data  else TRI-STATE ‘sdout’

//read from sdin (MOSI)
always @(posedge sck or negedge rstb)
  begin
    if (rstb==0)
		begin rreg = 8'hFF;  rdata = 8'h00; dw = 0; nb = 0; end   
	else if (!ss) begin 
			if(mlb==0)  //LSB first, in@msb -> right shift
				begin rreg ={sdin,rreg[7:1]}; end
			else     //MSB first, in@lsb -> left shift
				begin rreg ={rreg[6:0],sdin}; end  
		//increment bit count
			nb=nb+1;
			if(nb!=8) dw=0;
			else  begin rdata=rreg; dw=1; nb=0; end
		end	 
  end

//send to  sdout (MISO)
always @(negedge sck or negedge rstb or negedge ss)  begin
	if (rstb==0)
		begin treg = 8'hFF; end
	else begin
		if(!ss) begin			
			if(nb==0) 	
				begin treg=tdata; end
			else begin
			   if(mlb==0) //LSB first, out=lsb -> right shift
					begin treg = {1'b1,treg[7:1]}; end
			   else     //MSB first, out=msb -> left shift
					begin treg = {treg[6:0],1'b1}; end	
			end
		end //!ss
	 end //rstb	
  end //always


endmodule

