%Alex Yeh 4/5/2021
%HT Lab 4 Part 2d

%clipping in chest data while doing jump squats. This may be due to muscle
%activity or movement artifacts. 


dataFiles=["hand_2d.txt","chest_2d.txt"];
n=2;
sr=1000;
time=60;
t2=45;%resting after 45s

titles=["Hand Jump","Chest Jump"];


datamV=zeros(time*sr,n);%time*sr points per set, n sets of data
for i=1:n
    %open file
    fid=fopen(dataFiles(i));
    
    %loop through file
    r=1;
    while (~feof(fid)&&r<=time*sr)
        txtLine = fgetl(fid);
        
        %ignore headers that start with '#'
        if ~strncmpi(txtLine,'#',1)
            C=strsplit(txtLine);
            %bitalino raw data on 6th col
            %converts from raw data to mV
            datamV(r,i)=adcTomV(str2double(C(6)));
            r=r+1;
        end
    end
    fclose(fid);
    
end

%hand and chest electrodes were connected with the opposite polarity
datamV=-datamV;

%time in seconds
time_s = (0:time*sr-1)./sr;

%figures
recg_f=figure('NumberTitle', 'off', 'Name', "Raw ECG");  

for i=1:n
    figure(recg_f);  
    hold on
    subplot(n,1,i)
    plot(time_s, datamV(:,i)), hold on
    title(titles(i));
    ylabel('Voltage (mV)')
    xlabel('Time (s)')
    grid on
end

recg2_f=figure('NumberTitle', 'off', 'Name', "Raw ECG (45-60)");  
for i=1:n
%peak finder from lab 3
    max_pulse = 180;
    %use valleys are easier to detect in this case
    [ecg_pks,ecg_pks_loc] = find_peaks(-datamV(t2*sr:end,i), time_s(t2*sr:end), sr,max_pulse); 
    heart_rate = 60*numel(ecg_pks)/(time-t2);
    
    %plot ecg in time domain
    figure(recg2_f);  
    hold on
    subplot(n,1,i)
    plot(time_s(t2*sr:end), datamV(t2*sr:end,i)), hold on
    plot(ecg_pks_loc, -ecg_pks, 'r*')
    title(titles(i));
    ylabel('Voltage (mV)')
    xlabel('Time (s)')
    grid on
    legend(['Heart Rate = ' num2str(heart_rate) ' beats/min'])
    
end    
    
%Code from Lab 3
%Provided by Professor Ostadabbas

function [data_pks,data_pks_loc] = find_peaks(data, time, sampl_rate,max_pulse)
[pks,pks_loc] = findpeaks(data,'MINPEAKDISTANCE',sampl_rate/(max_pulse/60));
data_pks = pks;
data_pks_loc = time(pks_loc);
end