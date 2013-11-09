module topWrapper(OSC_50_B5B,
                  RESET_n,

                  LED,

                  VGA_R,

                  VGA_G,

                  VGA_B,

                  VGA_BLANK_n,

                  VGA_SYNC_n,

                  VGA_HS,

                  VGA_VS,

                  VGA_CLK
                  );

   input  OSC_50_B5B;

   input  RESET_n;

   output VGA_CLK;

   // value method ledout_ledOutput
   output [3 : 0] LED;


   // value method vgaout_redOut
   output [7 : 0] VGA_R;


   // value method vgaout_greenOut
   output [7 : 0] VGA_G;


   // value method vgaout_blueOut
   output [7 : 0] VGA_B;


   // value method vgaout_blankOut
   output         VGA_BLANK_n;


   // value method vgaout_syncOut
   output         VGA_SYNC_n;


   // value method vgaout_horizontalSyncOut
   output         VGA_HS;


   // value method vgaout_verticalSyncOut
   output         VGA_VS;

   wire           CLK_40M;

   pll pll0 (
             .refclk(OSC_50_B5B),
             .rst(!RESET_n),
             .outclk_0 (CLK_40M)
             );

   mkVgaClock(
              .CLK(CLK_40M),
              .RST_N(RESET_n),
              .CLK_clock_vga(VGA_CLK)
              );


   mkSocKit sockit(
                   .CLK(CLK_40M),
                   .RST_N(RESET_n),

                   .LED(LED),

                   .VGA_R(VGA_R),

                   .VGA_G(VGA_G),

                   .VGA_B(VGA_B),

                   .VGA_BLANK_n(VGA_BLANK_n),

                   .VGA_SYNC_n(VGA_SYNC_n),

                   .VGA_HS(VGA_HS),

                   .VGA_VS(VGA_VS),
                   );
endmodule
