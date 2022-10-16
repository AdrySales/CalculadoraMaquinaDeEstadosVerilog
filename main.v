module main (number0,number1, dis0,dis1,dis2,dis3,     clk,btnSoma,btnSub,btnMult,btnOO   ,saida1,saida2,saida3,saida4);



//________________________________________________ENTRADA 1

input [6:0] number0;
//displays de 7 segmentos da primeira entrada
output [0:6] dis0,dis1; //display de 7 segmentos
reg [3:0] num0,num1; //divisão da parte da dezenas e unidades
reg [6:0] numberEntrada0; //valor da entrada (number0)



//_______________________________________________ENTRADA 2

input [6:0] number1;
//displays de 7 segmentos da segunda entrada
output [0:6] dis2,dis3;//display de 7 segmentos
reg [3:0] num2,num3; //divisão da parte da dezena e unidade
reg [6:0] numberEntrada1; //valor da entrada (number0)



//_______________________________________________OPERAÇÕES
reg on=0;
input clk,btnSoma,btnSub,btnMult,btnOO; //entradas do clock e dos botões
reg pressedSoma=0, pressedSub=0, pressedMult=0, pressedOO=0,pressedAux=0; //variaveis que salvam o estado 1 quando o botão for apertado
reg [1:0] state=0; //





//_______________________________________________SAIDA
reg [0:13] resultado; //reg que armazena resultado das operações, num max (99x99) precisa de 14 bits
reg [3:0] result1,result2,result3,result4;//divisão da parte da milhar,centena,dezena e unidade
output [0:6] saida1,saida2,saida3,saida4;//led de 7 das saidas






//_______________________________MAQUINA DE ESTADOS___________________________________//

always @ (negedge clk ) begin //faça tudo que está dentro deo always toda vez que clk estiver em borda de descida


//____________________________Estado de espera
	if(pressedOO == 0)begin
		num0 <= 10; //unidade
		num1 <= 10; //dezena
		num2 <= 10; //unidade
		num3 <= 10; //dezena
		result1 <=10;
		result2 <=10;
		result3 <=10;
		result4 <=10;
	end
//___________________________Ligar e desligar 

    if(!btnOO)begin //só permite que o if só ative quando o botão for despressionado
    pressedAux<=1;
    end
     if(btnOO)begin
     pressedAux<=0;
    end

    //ligar
    if( btnOO && pressedAux && pressedOO == 0)begin
		pressedOO <=1;
		resultado<=14'd9803;
		 pressedSub<=0;
         pressedMult<=0;
		pressedSoma <=0;
	end
		
    //desligar
	if(btnOO && pressedOO && pressedAux ) begin
        resultado<=14'd9802;
		pressedOO <=0;	
    end	

//____________________________Entrada1

   numberEntrada1<=number1;
 //caso o numero seja maior que 99 ele atribui 99 a numberEntrada1
   if(number1>7'd99 )begin 
	numberEntrada1<=7'd99;
   end
   

   
//________________________________Entrada2

	numberEntrada0<=number0;
	//caso o numero seja maior que 99 ele atribui 99 a numberEntrada1
	if(number0 > 7'd99 && pressedOO)begin 
		numberEntrada0<=7'd99;
	end



//_____________________________________Divisão das dezenas e unidades

  if( pressedOO)begin
	num2 <= numberEntrada1 % 10; //unidade
	num3 <= numberEntrada1 / 10; //dezena
	
	 num0 <= numberEntrada0 % 10; //unidade
    num1 <= numberEntrada0 / 10; //dezena
    

   end
   
   



//____________________________Chamada dos botões
	if(!btnSoma) begin
		 pressedSub<=0;
         pressedMult<=0;
		pressedSoma <=1;
		end
	if(!btnSub ) begin
		pressedSoma<=0;
	    pressedMult<=0;
		pressedSub  <=1;
	end
    if(!btnMult) begin
		pressedSub<=0;
		pressedSoma<=0;
		pressedMult <=1;
	end
    
		
   //função soma
   if(pressedSoma && btnSoma && pressedOO ) begin //se pressedSoma==1 && btnSoma==1 && pressedOO==1 roda oq tem dentro do if
    state<=0;
    resultado<=numberEntrada0+numberEntrada1;
   
   end
  
  
   //função sub
   else if(pressedSub && btnSub && pressedOO) begin 
        /*caso a primeira entrada for maior que a segunda o resultado é possitivo e state fica em 0 sinalizando 
        que o resultado é positivo caso contrario state vai para 0 sinalizando que resultado é negativo*/
		if(numberEntrada0>=numberEntrada1)begin
			state<=0;
			resultado<=numberEntrada0-numberEntrada1;
		end
		if(numberEntrada0<numberEntrada1)begin
			resultado<=numberEntrada1-numberEntrada0;
			state<=1;
		end
	
   end
    
    
   //função mult
   else if(pressedMult && btnMult && pressedOO) begin
	 state<=0;
     resultado<=numberEntrada0*numberEntrada1;
  
    
   end
  
  
  
  
  //_______________________________________________SAIDA
  
  
  //se resultado for igual a 9802 o sistema desliga (10 é desligado)
		if(resultado==14'd9802)begin
            result1 <=10;
			result2 <=10;
			result3 <=10;
			result4 <=10;
			num0 <= 10; //unidade
			num1 <= 10; //dezena
			num2 <= 10; //unidade
			num3 <= 10; //dezena
        end
        
  //se resultado for igual a 9803 o sistema liga em 0 (11 é ligado)
        if(resultado==14'd9803)begin
            result1 <=11; //milhar
			result2 <=11; //centena
			result3 <=11; //dezena 
			result4 <=11; //unidade
        end
    
  /*se o resultado for menor que 9802 ele vem para esse 
    if,que é de fato o if que vai separar os digitos*/
		if(resultado<14'd9802 && state==0 && pressedOO )begin
			result1 <= resultado/1000; //mil
			result2 <=(resultado%1000)/100; //cen
			result3 <=((resultado%1000)%100)/10; //dez
			result4 <=((resultado%1000)%100)%10; //uni
		end
		if(resultado<=14'd9801 && state==1 && pressedOO)begin
			result1 <= 12; //sinal de menos
			result2 <=(resultado%1000)/100; //cen
			result3 <=((resultado%1000)%100)/10; //dez
			result4 <=((resultado%1000)%100)%10; //uni
			
			
		end
	
    
	  
end


//__________________Decodificadores de entrada

decodificador(.number(num2),.display(dis2)); //unidade
decodificador(.number(num3),.display(dis3)); //dezena

decodificador(.number(num0),.display(dis0)); //unidade
decodificador(.number(num1),.display(dis1)); //dezena





//__________________Decodificadores de saida
decodificador(.number(result1),.display(saida1)); //mil
decodificador(.number(result2),.display(saida2)); //cen
decodificador(.number(result3),.display(saida3)); //dez
decodificador(.number(result4),.display(saida4)); //uni




endmodule