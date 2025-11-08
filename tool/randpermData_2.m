function [A,gnd]=randpermData_2(A,gnd,C,n,l)
B=[];
D=[];
gndB=[];
gndD=[];
for i=2:C + 1
    index=randperm(n/C);
%     size(A)
%     (i-1)*(n/C)+index(1:l/C)
    if i <= C
        Btemp=A(:,(i-1)*(n/C)+index(1:l/C));
        B=[B,Btemp];
        gndBtemp=gnd((i-1)*(n/C)+1:(i-1)*(n/C)+(l/C));
        gndB=[gndB;gndBtemp];
        Dtemp=A(:,(i-1)*(n/C)+index(l/C+1:end));
        D=[D,Dtemp];
    %     i
        gndDtemp=gnd((i-1)*(n/C)+(l/C)+1:i*(n/C));
        gndD=[gndD;gndDtemp];
    else
        Btemp=A(:,index(1:l/C));
        B=[B,Btemp];
        gndBtemp=gnd(1:(l/C));
        gndB=[gndB;gndBtemp];
        Dtemp=A(:,index(l/C+1:end));
        D=[D,Dtemp];
    %     i
        gndDtemp=gnd((l/C)+1:mod(C+2,i)*(n/C));
        gndD=[gndD;gndDtemp];
    end
end

clear A
A=[B,D];
clear gnd
gnd=[gndB;gndD];