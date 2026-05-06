
module register_tb #(
    parameter WIDTH = 32
)(
	reg_if regif
);

	logic [WIDTH-1:0] expected;

	always @(posedge regif.clk) begin : golden_model_reference
		if(!regif.rst)
			expected <= 0;
		else if(regif.load)
			expected <= regif.data_in;
		else
			expected <= regif.data_out;
	end

	task exp;
		if(regif.data_out !== expected) begin
			$display("Error at a time: %0d, rst = %b, load = %b, data_in = %b, data_out = %b",
					$time, regif.rst, regif.load, regif.data_in, regif.data_out );
			$display("Data_out should be %b", expected);
			$finish;
		end
		else begin
			$display("At a time: %0d, rst = %b, load = %b, data_in = %b, data_out = %b",
					$time, regif.rst, regif.load, regif.data_in, regif.data_out);
		end
	endtask

	initial begin
		regif.rst = 1'b0;
		regif.load = 1'b0;
		regif.data_in = 0;

		repeat (2) @(posedge regif.clk);

		regif.rst = 1'b1;

		repeat (20) begin
			@(negedge regif.clk);

			regif.load 		= $urandom_range(0,1);
			regif.data_in 	= $urandom; 
			
			@(negedge regif.clk);
			exp();
		end

		$display("Test Passed");
		$finish;
	end

endmodule