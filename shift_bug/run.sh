#stereo WV02_10JUN212132555-P1BS-103001000513E500.ntf WV02_10JUN212134096-P1BS-1030010006271A00.ntf WV02_10JUN212132555-P1BS-103001000513E500.xml WV02_10JUN212134096-P1BS-1030010006271A00.xml -s stereo.default --alignment-method homography res1/res --left-image-crop-win 2048 9216 2048 2048

dg_mosaic W*500.ntf --reduce-percent 50 --output-prefix left
dg_mosaic W*A00.ntf --reduce-percent 50 --output-prefix right
