clc;%clears the command window
clear all;%clears the workspace 
close all;%closes all the plots 
k=3.1.*10^1;%hendry'sconstant
fs=1;%sampling frequency 
temp=0:1/fs:50%Temperature from 0(degree celsius)to 50(degree celsius) with increment of 1.
l=length(temp);% length of the no of temperature values 
for i=1:l
    sol(i)=k*(1/temp(i));%calculating the value of the solubility of the co2 with respect to temperature 
end
figure(1)
plot(temp,sol,'m')%plot the relation between the temperature and solubility of co2 ,verifying as it follows non-linear characteristics
xlabel('temperature');
ylabel('solubility of co2 in g/1000g of water');
legend('solubility');
figure(2)
stem(temp,sol,'r')%plot the relation between the temperature and solubility of co2 ,verifying as it follows non-linear characteristics
xlabel('temperature');
ylabel('solubility of co2 in g/1000g of water');
legend('solubility');
title('sampled data')
n1=4;%assigning number of bits per sample
L=2^n1;%length
xmax=32;%maximum value in the range
xmin=0;%minimum value in the range
del=(xmax-xmin)/L; %calculating the delta value 
partition=xmin:del:xmax% partition is used to define the range for the Quantization levels
codebook=xmin-(del/2):del:xmax+(del/2); % The vector of output assigned to each partition
[index,quants]=quantiz(sol,partition,codebook);%quantiz is inbuilt function which is used to quantize the signal
% gives rounded off values of the samples
%The quantized value is represented by its assigned decimal value given by index from the quantiz function.
figure(3)
stem(quants,"color",'g');%plotting of quantized signal for quants values
title('QUANTIZED SIGNAL');
xlabel('Temperature');
ylabel('solubility of co2 in g/1000g of water');
legend('Quantized');
% NORMALIZATION  OF THE QUANTIZED SIGNAL
l1=length(index); % to convert 1 to n as 0 to n-1 indicies
for i=1:l1
if (index(i)~=0)
index(i)=index(i)-1;
end
end
l2=length(quants);
for i=1:l2 % to convert the end representation levels within the range.
if(quants(i)==xmin-(del/2))
quants(i)=xmin+(del/2);
end
if(quants(i)==xmax+(del/2))
quants(i)=xmax-(del/2);
end
end
% ENCODING THE NORMALIZED QUANTS SIGNAL
code=de2bi(quants,'left-msb'); % DECIMAL TO BINANRY CONV OF INDICIES
%The output of de2bi can be formatted to have the MSB of the binary code either to the right or the left. This is set as a flag in the usage.
%Always use the Always use the 'left-msb' flag  as it is the more easily recognized representationleft-msb’ flag in our lab as it is the more easily recognized representation
k=1;
for i=1:l1 % to convert column vector to row vector
for j=1:n1
coded(k)=code(i,j);
j=j+1;
k=k+1;
end
i=i+1;
end
figure(4);
stairs(coded);%plot of digitalized signal
xlim([0,70])% limiting the range upto the values
ylim([-2,2])%limiting the y-axis range in between -2 to 2
title('DIGITALIZED SIGNAL');
xlabel('Temperature');
ylabel('solubility of co2 in g/1000g of water');
legend('digital');
%Demodulation
code1=reshape(coded,n1,(length(coded)/n1));
index1=bi2de(code1,'left-msb');
demod=del*index+xmin+(del/2);
figure(5);
plot(demod,'r');
title('DEMODULATAED SIGNAL');
xlabel('Temperature');
ylabel('solubility of co2 in g/1000g of water');
legend('demodulated signal');

