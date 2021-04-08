%Alex Yeh 4/5/2021
%HT Lab 4 Part 2a

%the peak finding algorithm works well. movement occured about every 5
%seconds. The artifacts can be clearly seen on the chest. The artifacts
%appear as more noise in the hand ECG. While the hands moved along with the
%rest of the body, the elbows worked to stabilize any sudden changes. 

dataFiles=["hand_2a.txt","chest_2a.txt"];
n=2;
sr=1000;
time=60;%120 seconds is 2 minutes
titles=["Hand Sit/Stand","Chest Sit/Stand"];


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

%chest electrodes were connected with the opposite polarity
datamV(:,2)=-datamV(:,2);


%time in seconds
time_s = (0:time*sr-1)./sr;


ecg_f=figure('NumberTitle', 'off', 'Name', "ECG Alternating Sitting and Standing");  

for i=1:n
    
    max_pulse = 140;
    [ecg_pks,ecg_pks_loc] = find_peaks(datamV(:,i), time_s, sr,max_pulse); %from lab 3
    heart_rate = 60*numel(ecg_pks)/(time);
    
    figure(ecg_f);  
    hold on
    subplot(n,1,i)
    plot(time_s, datamV(:,i)), hold on
    plot(ecg_pks_loc, ecg_pks, 'r*')
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