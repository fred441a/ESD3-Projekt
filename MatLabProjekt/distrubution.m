CL=1e-2;
CD=CL/2;
L=0.2;
A=[CL*L CL*L -CL*L -CL*L
   CL*L -CL*L -CL*L CL*L
   CD -CD CD -CD
   CL CL CL CL];
tau=[0 0 1 0]';
omega=inv(A)*tau
inv(A)