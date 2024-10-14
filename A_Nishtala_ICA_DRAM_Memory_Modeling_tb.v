`timescale 1ns/100ps
module DRAM_Memory_Modeling_tb;

	// Inputs to Device Under Test (DUT)
	reg [2:0] addr;  // 3-bit address
	wire [3:0] data;  // inout data bus
	reg clk;          // Clock input
	reg we;           // Write enable control input
	reg [3:0] tb_data_write;  // Data to write
	integer i;        // For loop variable
	
	// Instantiate the DRAM module
	DRAM_Memory_Modeling dram(
		.addr(addr),
		.data(data),  // inout connection
		.clk(clk),
		.we(we)
	);

	// Control logic for driving `data` when writing
	assign data = (we == 0) ? tb_data_write : 4'bz;  // Drive data on write, high-Z during read

	// Clock generation
	initial begin
		clk = 0;
		forever #5 clk = ~clk;  // 10ns clock period
	end

	// Main test procedure
	initial begin
		// Initialize the DRAM with values 0 to 7 (write mode)
		we = 0;  // Set to write mode
		for(i = 0; i < 8; i = i + 1) begin
			addr = i;          // Set address
			tb_data_write = i;  // Write value same as the address
			#10;               // Wait for one clock cycle
		end
		
		// Switch to read mode and verify values
		we = 1;  // Set to read mode
		for(i = 0; i < 8; i = i + 1) begin
			addr = i;  // Set address
			#10;       // Wait for data to be read
			if (data != i) begin  // Compare read data with expected value
				$display("Error at address %d: Expected %d, got %d", i, i, data);  // Display error
			end else begin
				$display("Read successful at address %d: data = %d", i, data);  // Display success
			end
		end
		
		$stop;  // End simulation
	end

endmodule

