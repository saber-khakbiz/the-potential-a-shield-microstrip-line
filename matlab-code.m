%**************************************************************
% Using the finite difference method
% This program calculates the potential distribution of the shield microstrip line
% line shown in Figure 3.56.
%**************************************************************
tic
clc; clear ;close all
format compact;
h= 0.5;
H=0.05;
LOOP = 100000;  %resolution{ Super Extra=400000, Extra=200000, Very High=100000, High= 50000, Normal=10000, Low=5000, Very Low=1000, Extra Low=500}  
A = 100*h; B = 80*h; D = 40*h; G=40*h; WG=(40+6)*h ;F=(40+6+8)*h; WF = (40+8+6+6)*h; 
er=3.5;
e0=8.81E-12;
%Nodes
NX = A/H;
NY = B/H;
ND = D/H;
NWF = WF/H;
NWG = WG/H;
NF=F/H;
NG=G/H;
VD = 100.0;
V0 = 0.0 ;
% CALCULATE CHARGE WITH AND WITHOUT DIELECTRIC
e1 = e0;
e2 = e0*er;
% INITIALIZATION
V = zeros(NX+2,NY+2);
% SET POTENTIAL ON INNER CONDUCTOR (FIXED NODES) EQUAL TO VD and V0
V(2+NF:NWF+2,ND+2) = VD;
V(2+NG:NWG+2,ND+2) = V0;
% CALCULATE POTENTIAL AT FREE NODES
P1 = e1/(2*(e1 + e2));
P2 = e2/(2*(e1 + e2));
for K=1:LOOP
    for I=0:NX-1
        for J=0:NY-1
            if(( (J==ND)&&(I>=NF && I<=NWF)) || ((J==ND) &&(I>=NG && I<=NWG)))
                %do nothing
            elseif (J==ND)
                 % IMPOSE BOUNDARY CONDITION AT THE INTERFACE
                 V(I+2,J+2) = 0.25*(V(I+3,J+2) + V(I+1,J+2)) + P1*V(I+2,J+3) + P2*V(I+2,J+1);
            else
                %formula to be applied to all free nodes in the free space and dielectric region
                  V(I+2,J+2) = (V(I+3,J+2)+V(I+1,J+2)+V(I+2,J+3)+V(I+2,J+1))/4.0;  
            end
        end
    end    
end
toc
%Plot 
 figure(1),imagesc(V),colormap('jet'),colorbar('location', 'WestOutside' ) , title('Potential Distribution ')
 xlabel('Y [mm]'), ylabel('X [mm]')
 camroll(+90)
 