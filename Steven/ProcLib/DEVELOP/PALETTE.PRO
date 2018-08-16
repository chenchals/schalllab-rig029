// PALETTE.PRO - Test VideoSYNC PC (palette change) command
//
// Test protocol to verify that the PC VideoSYNC command functions as expected.
// 18Jan17 sh   Initial edit

process main() enabled
{
index = 0;                 // Starting index to change 0 -> 255

dsendf("ca\n");             // Initialize everything


// Save the current (default) hardware palette to palette 0 and 1.
// Palette 0 will remain the original default colors.
// We use the PC command to change 3 consecutive color indexs on palette 1.

dsendf("ps 0\n");
dsendf("ps 1\n");
dsendf("pc 1, %d, %d\n", index, 0x0000FF); // Change index color to 255,255,255


// Draw 5 squares, each using a unique color index.
// The 3 middle squares are the ones whose colors should change when we
// flip between palettes.

// screen dims
screen_width = 1024;
screen_height = 768;
//KXOB22-12x1F: sensing area 22mm x 7 mm
pdWidth = 1024;
pdHeight = 9;
// pd top left screen: 1024 x 768 x 256, Mode 261
dsendf("co %d; rf %d,%d,%d,%d\n", index, 0, 0, 20, 9);
// pd bottom right screen: 1024 x 768 x 256, Mode 261
//dsendf("co %d; rf %d,%d,%d,%d\n", index, 0, screen_height-pdHeight, screen_width, screen_height);


// Now flip between the two palettes and display a title at the
// top of the VS screen telling us which palette we're looking at.
// The only colors that should change are for the middle 3 boxes.

while (1)
    {
    printf("Palette 0 - Original Colors\n");
    //dsendf("co 0; rf %d,5,%d,15\n", x, x+200);      // Erase text area
    //dsendf("mv %d,5; co 15; tx ORIGINAL COLORS (0)\n", x);
    dsendf("pr 0\n");


    wait 250;


    printf("Palette 1 - RED GREEN BLUE\n");
    //dsendf("co 0; rf %d,5,%d,15\n", x, x+200);      // Erase text area
    //dsendf("mv %d,5; co 15; tx RED GREEN BLUE (1) \n", x);
    dsendf("pr 1\n");

    wait 250;
    }
}
