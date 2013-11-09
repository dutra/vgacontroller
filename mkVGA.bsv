import Ehr::*;
import Led::*;
import Vga::*;

interface SocKit;
   (* prefix="" *)
   interface LedOutput ledout;
   (* prefix="" *)
   interface VgaOutput vgaout;
endinterface

typedef 628 LinesN; // 628*1056
typedef UInt#(TAdd#(1,TLog#(LinesN))) SZLinesN;
typedef 1056 PixelsN;
typedef UInt#(TAdd#(1,TLog#(PixelsN))) SZPixelsN;


(* clock_prefix="OSC_50_B5B", reset_prefix="RESET_n" *)
module mkSocKit(SocKit);
   Led led <- mkLed;
   Vga vga <- mkVga;
   Reg#(Bit#(1)) ledState <- mkReg(0);
   Reg#(Bit#(8)) frameCounter <- mkReg(0);
   Reg#(SZPixelsN) pixelCount <- mkReg(0);
   Reg#(SZLinesN) lineCount <- mkReg(0);
   
   rule doLed if ( lineCount == 628 );
      if (frameCounter == 0) begin
	 if (ledState == 0 )
   	    ledState <= 1;
	 if (ledState == 1)
   	    ledState <= 0;
	 led.setLed({0,ledState});
      end
      if (frameCounter < 60)
	 frameCounter <= frameCounter + 1;
      if (frameCounter == 60)
	 frameCounter <= 0;
   endrule
   
   /* Vertical Timing */
   rule doVSync if ( lineCount >= 0 && lineCount <  4 );
      vga.setVerticalSync(0);
   endrule

   rule doVBackPorch if (lineCount >= 4 && lineCount < 27 );
      vga.setVerticalSync(1);
   endrule

   rule doVVisible if (lineCount >= 27 && lineCount < 627 );
      vga.setVerticalSync(1);
   endrule

   rule doVFrontPorch if (lineCount >= 627 && lineCount < 628 );
      vga.setVerticalSync(1);
   endrule
   rule doVUpdate if (pixelCount == 0);
      if (lineCount == 628)
	 lineCount <= 0;
      else
	 lineCount <= lineCount + 1;
   endrule

   /* Horizontal Timing */
   rule doHSync if ( pixelCount >= 0 && pixelCount <=  127 && lineCount >= 27 && lineCount < 627 );
      vga.setHorizontalSync(0);
      vga.setRed(0);
      vga.setGreen(0);
      vga.setBlue(0);
   endrule

   rule doHBackPorch if (pixelCount >= 128 && pixelCount < 215 && lineCount >= 27 && lineCount < 627 );
      vga.setHorizontalSync(1);
      vga.setRed(0);
      vga.setGreen(0);
      vga.setBlue(0);
   endrule

   rule doHVisible if (pixelCount >= 216 && pixelCount <= 1015 && lineCount >= 27 && lineCount < 627 );
      if ( lineCount >= 27 && lineCount < 227 ) begin
	 vga.setRed(255);
	 vga.setGreen(0);
	 vga.setBlue(0);
      end
      if ( lineCount >= 227 && lineCount < 427 ) begin
	 vga.setRed(0);
	 vga.setGreen(255);
	 vga.setBlue(0);
      end
      if ( lineCount >= 427 && lineCount < 627 ) begin
	 vga.setRed(0);
	 vga.setGreen(0);
	 vga.setBlue(255);
      end
   endrule

   rule doHFrontPorch if (pixelCount >= 1016 && pixelCount <= 1055 && lineCount >= 27 && lineCount < 627 );
      vga.setHorizontalSync(1);
      vga.setRed(0);
      vga.setGreen(0);
      vga.setBlue(0);
   endrule
   rule doHUpdate;
      if (pixelCount == 1056 )
	 pixelCount <= 0;
      else
	 pixelCount <= pixelCount + 1;
   endrule


   interface LedOutput ledout = led.ledout;
   interface VgaOutput vgaout = vga.vgaout;
endmodule