/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* Design Name: SPI MASTER TESTBENCH
* Module Name: tb_MASTER
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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

`timescale 1ns/10ps
module tb_MASTER;
    reg rstb;
    reg clk = 1'b0; 
    reg mlb = 1'b0;
    reg start = 1'b0;
    reg [7:0] tdat = 8'b00000000;
    reg [1:0] cdiv = 0;
    reg din=1'b0;
    wire ss;
    wire sck;
    wire dout;
    wire done;
    wire [7:0] rdata;


	initial #7000 $stop;

	
    parameter PERIOD = 50;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 100;
    initial    // Clock process for clk
    begin
        #OFFSET;
        forever
        begin
            clk = 1'b0;
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
            #(PERIOD*DUTY_CYCLE);
        end
    end

    spi_master UUT (
        .rstb(rstb),
        .clk(clk),
        .mlb(mlb),
        .start(start),
        .tdat(tdat),
        .cdiv(cdiv),
        .din(din),
        .ss(ss),
        .sck(sck),
        .dout(dout),
        .done(done),
        .rdata(rdata));

//	$dumpfile("vcd_spi_master.vcd");  	$dumpvars;


initial begin

        #10 rstb = 1'b0;
        #100;
        rstb = 1'b1;start = 1'b0;
        tdat = 8'b01111100;
        cdiv = 2'b00;
   
        #100  start = 1'b1;
        #100  start = 1'b0;
		#100
		
        #1800 mlb = 1'b1; cdiv=2'b00; tdat=8'b01111100; din=1'b1;
        #100  start = 1'b1;
		#100  start = 1'b0;
		#100		
        
		#1200 mlb = 1'b1; cdiv=2'b01; tdat=8'b00011100; din=1'b1;
        #100  start = 1'b1;
		#100  start = 1'b0;
		#2000;
		

   end

endmodule


