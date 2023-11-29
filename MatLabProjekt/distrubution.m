CL=1.4e-5;
CD=CL/10;
L=0.31;
A=[CL*L CL*L -CL*L -CL*L
   CL*L -CL*L -CL*L CL*L
   CD -CD CD -CD
   CL CL CL CL];
tau=[0 0 1 0]';
omega=inv(A)*tau;
dis=inv(A)
A