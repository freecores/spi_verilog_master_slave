/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* Design Name: SPI MASTER-SLAVE TESTBENCH
* Module Name: TB_SPI_MasSlv
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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

`timescale 1ns/10ps
module TB_SPI_MasSlv;
//mas
    reg rstb;
    reg clk;
    reg mlb;
    reg start;
    reg [7:0] M_trans;
    reg [1:0] cdiv;
    wire miso;
    wire ss;
    wire sck;
    wire mosi;
    wire M_done;
    wire [7:0] M_rec;

	reg ten;
    reg [7:0] s_tdata;
    wire s_done;
    wire [7:0] s_receive;

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

initial #5100 $stop;

    spi_master MAS (
        .rstb(rstb),
        .clk(clk),
        .mlb(mlb),
        .start(start),
        .tdat(M_trans),
        .cdiv(cdiv),
        .din(miso),
        .ss(ss),
        .sck(sck),
        .dout(mosi),
        .done(M_done),
        .rdata(M_rec));

	SPI_slave SLV (
        .rstb(rstb),
        .ten(ten),
        .tdata(s_tdata),
        .mlb(mlb),
        .ss(ss),
        .sck(sck),
        .sdin(mosi),
        .sdout(miso),
        .done(s_done),
        .rdata(s_receive));

initial begin
	#15 rstb = 1'b0;
	#50 rstb = 1'b1;start = 1'b0;
		 cdiv = 2'b00; ten=1; mlb = 1'b0;
         M_trans = 8'hFE; 	//        M_trans = 8'h7C; 
		 s_tdata=8'h01;	//s_tdata=8'hAC; 8'b11110000
	#125  start = 1'b1;
	#100  start = 1'b0;
 
	#1200 mlb = 1'b1; cdiv=2'b01; M_trans=8'h1C;s_tdata=8'h64;
	#100  start = 1'b1;
	#100  start = 1'b0;
	#1500;
	
	#1500;
	
	#1000;
end

endmodule
