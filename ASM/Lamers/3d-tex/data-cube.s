      cnop 0,4
points3d_tex
      dc.w -50,-50,50
      dc.w 50,-50,50
      dc.w -50,50,50
      dc.w 50,50,50
      dc.w -50,50,-50
      dc.w 50,50,-50
      dc.w -50,-50,-50
      dc.w 50,-50,-50
      cnop 0,4
texFaces3d
      dc.w 0,1,2
      dc.w 2,1,3
      dc.w 2,3,4
      dc.w 4,3,5
      dc.w 4,5,6
      dc.w 6,5,7
      dc.w 6,7,0
      dc.w 0,7,1
      dc.w 1,7,3
      dc.w 3,7,5
      dc.w 6,0,4
      dc.w 4,0,2
      cnop 0,4
texUV3d
      dc.w -127<<8,-127<<8,0<<8,-127<<8,-127<<8,0<<8,0,0
      dc.w -127<<8,0<<8,0<<8,-127<<8,0<<8,0<<8,0,0
      dc.w 0<<8,-127<<8,127<<8,-127<<8,0<<8,0<<8,0,0
      dc.w 0<<8,0<<8,127<<8,-127<<8,127<<8,0<<8,0,0
      dc.w 0<<8,127<<8,-127<<8,127<<8,0<<8,0<<8,0,0
      dc.w 0<<8,0<<8,-127<<8,127<<8,-127<<8,0<<8,0,0
      dc.w 0<<8,0<<8,127<<8,0<<8,0<<8,127<<8,0,0
      dc.w 0<<8,127<<8,127<<8,0<<8,127<<8,127<<8,0,0
      dc.w -127<<8,-127<<8,0<<8,-127<<8,-127<<8,0<<8,0,0
      dc.w -127<<8,0<<8,0<<8,-127<<8,0<<8,0<<8,0,0
      dc.w 0<<8,-127<<8,127<<8,-127<<8,0<<8,0<<8,0,0
      dc.w 0<<8,0<<8,127<<8,-127<<8,127<<8,0<<8,0,0
texPoints3dCnt dc.l 8-1
texFaces3dCnt dc.l 12-1
      cnop 0,4