/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* Design Name: SPI SLAVE TESTBENCH
* Module Name: tbslave
* Project Name: SPI
* Target Devices: Spartan 3E
* Designed by: Santhosh G
* 
* 
* Author: Santhosh
*         santhoshg90@gmail.com                                
*
* Copyright - 2014 - Santhosh G
* 			 - OpenCores.org
* 
* THIS SOURCE FILE MAY BE USED AND DISTRIBUTED WITHOUT        
* RESTRICTION PROVIDED THAT THIS COPYRIGHT STATEMENT IS NOT   
* REMOVED FROM THE FILE AND THAT ANY DERIVATIVE WORK CONTAINS 
* THE ORIGINAL COPYRIGHT NOTICE AND THE ASSOCIATED DISCLAIMER.
*  
* THIS IS PROVIDED WITHOUT ANY  EXPRESS OR IMPLIED WARRANTIES, 
* INCLUDING, BUT NOT LIMITED  TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
* AND FITNESSFOR A PARTICULAR PURPOSE. IN CASE THE AUTHOR IS RESPONSIBEL FOR 
* THE DAMAGES CAUSED BY USE OF THIS. FOR EDUCATIONAL PURPOSE ONLY.
* 
* THIS SOURCE FILE MAY BE USED AND DISTRIBUTED WITHOUT        
* RESTRICTION PROVIDED THAT THIS COPYRIGHT STATEMENT IS NOT   
* REMOVED FROM THE FILE AND THAT ANY DERIVATIVE WORK CONTAINS 
* THE ORIGINAL COPYRIGHT NOTICE AND THE ASSOCIATED DISCLAIMER.
* 
* This source file is free software; you can redistribute it 
* * and/or modify it under the terms of the GNU Lesser General 
* Public License as published by the Free Software Foundation; 
* either version 2.1 of the License, or (at your option) any 
* later version. 
* 
* You should have received a copy of the GNU Lesser General 
* Public License along with this source; if not, download it 
* from http://www.opencores.org/lgpl.shtml 
* 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

`timescale 1ns/10ps
module tbslave;
    reg rstb = 1'b0;
    reg ten = 1'b0;
    reg [7:0] tdata = 8'b00000000;
    reg mlb = 1'b0;
    reg ss = 1'b0;
    reg sck = 1'b0;
    reg sdin = 1'b0;
    wire sdout;
    wire done;
    wire [7:0] rdata;

	initial #1200 $stop;

    SPI_slave UUT (
        .rstb(rstb),
        .ten(ten),
        .tdata(tdata),
        .mlb(mlb),
        .ss(ss),
        .sck(sck),
        .sdin(sdin),
        .sdout(sdout),
        .done(done),
        .rdata(rdata));

wire [3:0] nbit;	
assign nbit=UUT.nb;

    initial begin
        #100;
        ss = 1'b1;
        sck = 1'b1;
        sdin = 1'b1;
        #20;
        rstb = 1'b1;
         #20;
        ten = 1'b1;
        mlb = 1'b1;
        tdata = 8'b01111100;
         #20;
        ss = 1'b0;
        #20;
        sck = 1'b0;
        sdin = 1'b0;
        #20;
        sck = 1'b1;
        #20;
        sck = 1'b0;
        sdin = 1'b1;
       #20;
        sck = 1'b1;
        #20;
        sck = 1'b0;
        sdin = 1'b0;
        #20;
        sck = 1'b1;
        #20;
        sck = 1'b0;
        sdin = 1'b1;
        #20;
        sck = 1'b1;
        #20;
        sck = 1'b0;
        sdin = 1'b0;
       #20;
        sck = 1'b1;
        #20;
        sck = 1'b0;
        sdin = 1'b1;
        #20;
        sck = 1'b1;
         #20;
        sck = 1'b0;
        sdin = 1'b0;
         #20;
        sck = 1'b1;
       #20;
        sck = 1'b0;
        sdin = 1'b1;
        #20;
        sck = 1'b1;
        #20;
        ss = 1'b1;
         #20;
        ten = 1'b0;
		
		#100  ten = 1'b0;        mlb = 1'b0;         tdata = 8'b01110000;
        #20        ss = 1'b0;
        #20       sck = 1'b0;
        sdin = 1'b0;
        #20        sck = 1'b1;
        #20        sck = 1'b0;
        sdin = 1'b1;
        #20        sck = 1'b1;

        #20        sck = 1'b0;
        sdin = 1'b0;
        #20        sck = 1'b1;
        #20        sck = 1'b0;
        sdin = 1'b1;
        #20        sck = 1'b1;
        #20        sck = 1'b0;
        sdin = 1'b0;
        #20        sck = 1'b1;
        #20        sck = 1'b0;
        sdin = 1'b1;
        #20        sck = 1'b1;
        #20        sck = 1'b0;
        sdin = 1'b0;
        #20        sck = 1'b1;
        #20        sck = 1'b0;
        sdin = 1'b1;
        #20        sck = 1'b1;
        #20         ss = 1'b1;
        #20         ten = 1'b0;
		#100;

	end

endmodule

