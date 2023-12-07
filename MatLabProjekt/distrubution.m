CL=1.4e-5;
CD=0.1*CL;
L=0.31*(1/sqrt(2));
A=[(CL*L) (CL*L) -(CL*L) -(CL*L)
   (CL*L) -(CL*L) -(CL*L) (CL*L)
   (CD) -(CD) (CD) -(CD)
   (CL) (CL) (CL) (CL)];
tau=[-0.0000 -0.0009 0.0003 0.0004]';
omega=(inv(A)*tau + ((2600*0.9)/4))*0.32
inv(A);