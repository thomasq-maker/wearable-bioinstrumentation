clear 
clc
close all

%% Connect Arduino

a = arduino();

%% Collect and Save Data

% define variables and call pressureSensor function
sampleTime = 300;
thresh = 0;
livePlot = false;
pauseTime = 0;

%disp('No Object: Sample 1')
%data1 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
%pause(5)
%disp('No Object: Sample 2')
%data2 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
%pause(5)
%disp('Cell Phone: Sample 1')
%data3 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
%pause(5)
%disp('Cell Phone: Sample 2')
%data4 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
%pause(5)
%disp('Headphones: Sample 1')
%data5 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
%pause(5)
%disp('Headphones: Sample 2')
%data6 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);

%disp('1 resistor')
%data1 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
%pause(100)
%disp('2 resistor series')
%data2 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
%pause(100)
%disp('2 resistor parallel')
%data3 = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);

%data = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime)

% calcuate data acqusition rate
% dt = diff(data1.time); % time between samples
% fs = 1/mean(dt) % average sampling frequency (Hz)

% calculate R2 using R1, Vin, and Vout
Vin = 5;
R1 = 100
R2 = 0;
Vout = mean(data.voltage)

% save pressureSensor output table to a study array, table, or structure
study = data;

% save pressureSensor output table to a csv in your data folder
writetable(data, fullfile(pwd,'pressuresensordata.csv'))

%% Figure 1. Calculate Resistance

% Vout = [mean(data1.voltage); mean(data2.voltage); mean(data3.voltage); mean(data4.voltage); mean(data5.voltage); mean(data6.voltage)]
% R2 = R1.*Vout./(Vin - Vout)

%figure
%plot(data1.time,data1.voltage, 'DisplayName',['No Object: Sample 1: R2' num2str(R2(1))])
%hold on 
%plot(data2.time,data2.voltage, 'DisplayName',['No Object: Sample 2: R2' num2str(R2(2))])
%hold on 
%plot(data3.time,data3.voltage, 'DisplayName',['Cell Phone: Sample 1: R2' num2str(R2(3))])
%hold on 
%plot(data4.time,data4.voltage, 'DisplayName',['Cell Phone: Sample 2: R2' num2str(R2(4))])
%hold on 
%plot(data5.time,data5.voltage, 'DisplayName',['Headphones: Sample 1: R2' num2str(R2(5))])
%hold on 
%plot(data6.time,data6.voltage, 'DisplayName',['Headphones: Sample 2: R2' num2str(R2(6))])
%legend('show')
%xlabel('Elapsed Time (Seconds)')
%ylabel('Voltage (V)')
%title('Figure 1. Calculate Resistance')

%% Figure 2. Changing R1

%Vout = [mean(data1.voltage); mean(data2.voltage); mean(data3.voltage)]

%figure
%plot(data1.time,data1.voltage, 'DisplayName',['Single Resistor: Vout' num2str(Vout(1))])
%hold on 
%plot(data2.time,data2.voltage, 'DisplayName',['Two Resistors in Series: Vout' num2str(Vout(2))])
%hold on 
%plot(data3.time,data3.voltage, 'DisplayName',['Two Resistors in Parallel: Vout' num2str(Vout(3))])
%hold on 
%legend('show')
%xlabel('Elapsed Time (Seconds)')
%ylabel('Voltage (V)')
%title('Figure 2. Changing R1')

%% Figure 3. Respiration

%figure
%plot(data.time,data.voltage)
%xlabel('Elapsed Time (Seconds)')
%ylabel('Voltage (V)')
%title('Figure 3. Thomas Respiration')