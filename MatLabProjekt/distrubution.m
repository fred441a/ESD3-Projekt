CL=1.4e-5;
CD=CL/2;
L=0.31;
A=[sqrt(CL*L) sqrt(CL*L) -sqrt(CL*L) -sqrt(CL*L)
   sqrt(CL*L) -sqrt(CL*L) -sqrt(CL*L) sqrt(CL*L)
   sqrt(CD) -sqrt(CD) sqrt(CD) -sqrt(CD)
   sqrt(CL) sqrt(CL) sqrt(CL) sqrt(CL)];
tau=[0 0 1 0]';
omega=inv(A)*tau;
inv(A)