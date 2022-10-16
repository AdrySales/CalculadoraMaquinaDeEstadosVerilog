module decodificadorONOFF (number,display);

input [3:0] number;
output reg [0:6] display;

always @ (number) begin
   case (number)
     1: display <= 7'b1111110;
     0: display <= 7'b0000001;
     endcase
end     
endmodule