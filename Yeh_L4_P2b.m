%Alex Yeh 4/5/2021
%HT Lab 4 Part 2b

%The peak finding algorithm performs poorly on this one. both data sets are
%extremely messy due to movement artifacts and the peak of the QRS complex
%is sometimes indistinguishable from the peak due to the T wave. 


dataFiles=["hand_2b.txt","chest_2b.txt"];
n=2;
sr=1000;
time=60;%120 seconds is 2 minutes
titles=["Hand Running","Chest Running"];


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


ecg_f=figure('NumberTitle', 'off', 'Name', "ECG Running in Place");  

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