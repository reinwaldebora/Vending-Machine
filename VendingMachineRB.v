/* 	-Make sure final design of CU in the implementation is clear.
	-Intermediate  results and states should be clearly shown in 
	the simulations
	-number of item in the vending machine should be at least 3
	-vending machince should count number of product left
	-should issue change or require user input exact amount 
	*/



module vendingmachine(clk,nRst,p1,p5,item1,item2,item3,dispense,change);
	input clk,nRst,p1,p5,item1,item2,item3;
	output reg dispense,change;
	
	reg [2:0] cstate,nstate;
	
	parameter a = 3'b000;
	parameter b = 3'b001;
	parameter c = 3'b010;
	parameter d = 3'b011;
	parameter e = 3'b100;
	parameter f = 3'b101;
	
	always @ (negedge clk)
	begin
		if(!nRst)
			cstate<=a;
		else
			cstate<=nstate;
	end
	
	always @(*) begin
		case (cstate)
			a: case({p1,p5,item1,item2,item3})
				5'b00000: nstate<=a;
				5'b10001: nstate<=b;
				5'b10010: nstate<=b;
				5'b10100: nstate<=b;
				5'b01001: nstate<=a;
				5'b01010: nstate<=f;
			endcase
			b: case({p1,p5,item1,item2,item3})
				5'b00000: nstate<=b;
				5'b10000: nstate<=a;
				5'b01001: nstate<=a;
				5'b10001: nstate<=a;
				5'b10010: nstate<=c;
				5'b10100: nstate<=c;
				5'b01001: nstate<=d;
				5'b01010: nstate<=a;
				5'b01100: nstate<=a;
			endcase
			c: case({p1,p5,item1,item2,item3})
				5'b00000: nstate<=c;
				5'b10000: nstate<=d;
				5'b10100: nstate<=d;
				5'b01100: nstate<=e;
			endcase
			d: case({p1,p5,item1,item2,item3})
				5'b00000: nstate<=e;
				// 5'b00000: nstate<=a;
			endcase
			e: case({p1,p5,item1,item2,item3})
				5'b00000: nstate<=f;
			endcase
			f: case({p1,p5,item1,item2,item3})
				5'b00000: nstate<=a;
			endcase
		default: nstate<=a;
		endcase
	end
	
	always@(*) begin
		case (cstate)
			a: case({p1,p5,item1,item2,item3})
				5'b00000,5'b10001,5'b10010,5'b10100,5'b01100: {dispense,change}<=2'b00;
				5'b01010: {dispense,change}<=2'b10;
			endcase
			b: case({p1,p5,item1,item2,item3})
				5'b10010,5'b10100: {dispense,change}<=2'b00;
				5'b01001,5'b10000,5'b00000,5'b10001,5'b01010: {dispense,change}<=2'b10;
				5'b10001: {dispense,change}<=2'b01;
			endcase
			c: case({p1,p5,item1,item2,item3})
				5'b00000,5'b10000,5'b10100: {dispense,change}<=2'b00;
				5'b01100: {dispense,change}<=2'b01;
			endcase
			d: case({p1,p5,item1,item2,item3})
				5'b00000: {dispense,change}<=2'b01;
			endcase
			e: case({p1,p5,item1,item2,item3})
				5'b00000: {dispense,change}<=2'b01;
			endcase
			f: case({p1,p5,item1,item2,item3})
				5'b00000: {dispense,change}<=2'b01;
				endcase
		default: {dispense,change}<=2'b00;
		endcase
	end
endmodule
	
				
			
	
module stimulus_generator(clk,nRst,p1,p5,item1,item2,item3);

output reg clk,nRst,p1,p5,item1,item2,item3;
	
	initial 
	begin

		$dumpfile("vending.vcd");
		$dumpvars;
	end
	
	initial
		clk<=0;
		
	always
		#1 clk=~clk;
		
	initial begin
		nRst<=0;
		#5
		nRst<=1;
		#5

		//Item 1
		p1<=1;
		p5<=0;
		item1<=1;
		item2<=0;
		item3<=0;
		#2
		p1<=1;
		p5<=0;
		item1<=0;
		item2<=0;
		item3<=0;
		#2

		p1<=0;
		p5<=0;
		item1<=0;
		item2<=0;
		item3<=0;
		#5

		//Item 2
		p1<=0;
		p5<=1;
		item1<=0;
		item2<=1;
		item3<=0;
		#2

		p1<=0;
		p5<=0;
		item1<=0;
		item2<=0;
		item3<=0;
		#5

		//Item 3
		p1<=1;
		p5<=0;
		item1<=0;
		item2<=0;
		item3<=1;
		#2
		p1<=0;
		p5<=1;
		item1<=0;
		item2<=0;
		item3<=0;
		#2
		p1<=0;
		p5<=0;
		item1<=0;
		item2<=0;
		item3<=0;
		#5
		


		$finish;
	end
endmodule


module testbench_VM();

wire clk,nRst,p1,p5,item1,item2,item3,dispense,change;


	vendingmachine	mainmodule(clk,nRst,p1,p5,item1,item2,item3,dispense,change);
	stimulus_generator	stimulusmodule(clk,nRst,p1,p5,item1,item2,item3);

endmodule
