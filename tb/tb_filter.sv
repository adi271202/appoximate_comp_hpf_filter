`timescale 1ns / 1ps
//`define size 512
`define headerSize 1080
`define imageSize 256*256

module tb(

    );
    
 parameter DEPTH      =512;
 parameter DATA_WIDTH =8; 
 logic clk;
 logic rst;
 logic [7:0] imgData;
 integer file,file1;
 logic imgDataValid;
 logic imgDataValid_d;
 integer sentSize;
 logic [7:0] outData;
 logic [7:0] temp; 
 logic outDataValid;
 logic o_ready; 
 logic start_data;
 integer receivedData=0;
 logic count_state; 
 logic [`headerSize-1:0][7:0] header;
 logic [$clog2(DEPTH)-1:0] rowCounter;
always #5 clk=~clk;
 
 initial
 begin
    clk=0; rowCounter=0; 
    rst = 1;
//    sentSize = 0;
//    imgDataValid = 0;
    #100;
    rst = 0;
//    #10;
//    start_data = 1;
    file  = $fopen("../../../../../Matlab/imageProcessMatlabScripts-master/cameraman_bin.bin","rb");
    file1 = $fopen("../../../../../Matlab/imageProcessMatlabScripts-master/cameraman_out_bin.bin","wb");  
//    file  = $fopen("../../../../../../../Matlab/imageProcessMatlabScripts-master/2_bin.bin","rb");
//    file1 = $fopen("../../../../../../../Matlab/imageProcessMatlabScripts-master/2_afa3_out_bin.bin","wb");
    #95;
    
    if(start_data) begin 
       for(int i=0; i<DEPTH; i++) begin 
          for (int j=0; j<DEPTH; j++) begin 
             @(posedge clk) 
             imgDataValid <= 1; 
             $fscanf(file,"%c",imgData); 
          end 
          for(int k=0; k<DEPTH; k++) begin 
             @(posedge clk) 
             imgDataValid <= 0; 
          end 
       end
       for(int p=0; p<2; p++) begin 
          for (int j=0; j<DEPTH; j++) begin 
             @(posedge clk) 
             imgDataValid <= 1; 
//             $fscanf(file,"%c",imgData); 
             imgData <= 'd0;
          end 
          for(int k=0; k<DEPTH; k++) begin 
             @(posedge clk) 
             imgDataValid <= 0; 
          end 
       end
    end
    
 end
 
//always @(posedge clk) begin 
//   if(rst) begin 
//      imgDataValid<= 'd0; 
//   end
//   else begin
//      if(start_data && o_ready && sentSize>=`headerSize) begin  
//         imgDataValid <= 'd1;
//      end
//      else begin 
//         imgDataValid <= 'd0; 
//      end
//   end
//end

logic [$clog2(3*DEPTH)-1:0] dataCounter;

always @(posedge clk) begin 
   if(rst) begin 
      dataCounter <= 'd0; 
   end
   else begin 
      if(start_data && (dataCounter<2*DEPTH)) begin 
         dataCounter <= dataCounter + 1; 
      end
      else begin 
         dataCounter <= 'd0; 
      end
   end
end
 
always @(posedge clk) begin 
   if(rst) begin 
//     imgDataValid   <= 'd0;
     imgDataValid_d <= 'd0;
   end
   else begin 
      imgDataValid_d <= imgDataValid;
//      if(start_data && o_ready ) begin  
//      if(start_data && dataCounter< DEPTH ) begin  
//         imgDataValid <= 'd1;
//      end
//      else begin 
//         imgDataValid <= 'd0; 
//      end
   end
end
 
localparam FIRST_3=0, REST=1;
 
always @(posedge clk) begin 
   if(rst) begin 
      sentSize <= 'd0; 
      count_state <= REST; 
   end
   else begin 
      case(count_state) 
         FIRST_3: begin 
            sentSize <= sentSize +1;
            if((sentSize >= `headerSize)) begin 
               count_state <= REST; 
            end
         end 
         REST: begin 
            if(imgDataValid_d && o_ready) begin 
               sentSize <= sentSize + 1;
            end
         end
      endcase
   end
end 

always @(posedge clk) begin 
   if(rst) begin 
      start_data <= 'd0; 
   end
   else 
      start_data <= 'd1;
      if(sentSize==(DEPTH*DEPTH+DEPTH*2)) begin 
         start_data <= 'd1;
      end 
end

logic [7:0] imgData_d;

always @(posedge clk) begin 
   imgData_d <= imgData; 
end

//always_ff @(posedge clk) begin 
//    if(rst) begin 
//       imgData <= 'd0; 
//    end 
//    else begin 
////       if (sentSize<=`headerSize) begin
////           $fscanf(file,"%c ",imgData);
////       end
//       if(!$feof(file)  && imgDataValid) begin 
//          $fscanf(file,"%c ",imgData);
//       end 
//       else begin 
////          imgData <= 'd0; 
////          if(sentSize==(DEPTH*DEPTH+`headerSize+DEPTH*2)) begin 
////             imgDataValid <= 'd0;
////          end
//       end
//    end 
//end



always @(posedge imgDataValid) begin 
   rowCounter <= rowCounter +1;   
end

logic state; 
localparam HEADER=0, CONV=1;

always @(posedge clk) begin 
   if(rst) begin 
      state <= CONV; 
   end
   else begin 
      case(state) 
         HEADER : begin 
            if(sentSize<`headerSize) begin 
               $fwrite(file1,"%c",imgData);
               header[sentSize] <= imgData;
            end
            else begin 
               state <= CONV;
            end
         end
         CONV : begin 
            if(outDataValid)
               begin
                   $fwrite(file1,"%c",outData);
//                   temp <= outData;
//                   receivedData = receivedData+1;
               end 
               if(receivedData == `imageSize)
               begin
                  $fclose(file1);
                  $stop;
               end
            end
      endcase
   end
end

//assign temp = outData;
always @(posedge clk) begin 
   temp <= outData;
end

 always @(posedge clk)
 begin
     if(outDataValid)
     begin
         receivedData = receivedData+1;
     end 
 end

filter #(
   .DATA_WIDTH(DATA_WIDTH), 
   .DEPTH     (DEPTH     )   
)dut(
   .clk          (clk           ), 
   .rst          (rst           ), 
   .i_valid      (imgDataValid  ), 
   .i_image_pixel(imgData_d     ),
   .o_ready      (o_ready       ), 
   .o_valid      (outDataValid  ), 
   .o_conv_pixel (outData       )
    );
    
endmodule