import Ehr::*;

interface LedOutput;
   (* result="LED", always_ready *)
   method Bit#(4) ledOutput();
endinterface

interface Led;
   interface LedOutput ledout;
      method Action setLed(Bit#(4) d);
endinterface

module mkLed(Led);
   Ehr#(2,Bit#(4)) data <- mkEhr(0);

   method Action setLed(Bit#(4) d);
      data[0] <= d;
   endmethod

   interface LedOutput ledout;
      method Bit#(4) ledOutput();
         return data[1];
      endmethod
   endinterface

endmodule
