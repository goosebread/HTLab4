%Alex Yeh 4/5/2021
%HT Lab 4

%Converts BITalino raw digital data(ECG)to mV
%transfer function available on BITalino website
%https://bitalino.com/storage/uploads/media/revolution-ecg-sensor-datasheet-revb-1.pdf
function m=adcTomV(value)
    %default parameters
    n=10;%10 bit sampling resolution
    VCC=3.3;%3.3V operating voltage for bitalino
    GECG=1100;%gain
    
    %this equation is written to be easy to read
    %it could be optimized for better computing time
    m=(1000*VCC/GECG)*(value/pow2(n)-0.5);    
end