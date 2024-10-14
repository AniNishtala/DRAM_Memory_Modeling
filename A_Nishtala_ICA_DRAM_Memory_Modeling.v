`timescale 1ns/100ps
module DRAM_Memory_Modeling (
	input [2:0] addr, //3 bit address
	inout [3:0] data, //4 bit data
	input clk, //  clk input
	input we // we input
);
	reg [3:0] DRAM_array [7:0]; // DRAM_array 4x8
	
	//define trireg I/O operations
	trireg [3:0] #(3,2,60) read; //read trireg
	trireg [3:0] #(3,2,60) write; //write trireg
	
	//assign tristate buffer for I/O operation with specified timings. Timing = 3ns rise, 2ns fall, 60ns hold
	assign #(3,2,60) read = DRAM_array[addr]; //Read operation with specified timings
	assign data = (we == 1) ? read : 4'bz; // invert and assign data in read operations
	assign write = (we == 0) ? data : 4'bz; // if we = 0, allow write operation to DRAM with specified timings

	
	always @(posedge clk)
	begin
		if(we == 0)
		begin
			DRAM_array[addr] <= data; //write data to selected addr
		end
	end

// will need a second tri state buffer for inout. resolved issue
endmodule