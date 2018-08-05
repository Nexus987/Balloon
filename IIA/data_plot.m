%% Clear everything
clear all;
close all;
clc;

start = 11;
runmean_length = 10;
%% Read data from files
temp_fid = fopen('TEMP.txt');
temp = fscanf(temp_fid,'%d\t%d',[2 inf])';
fclose(temp_fid);
for i=1:length(temp)
    temp(i,2) = temp(i,2)/1000;
end

temp2_fid = fopen('TEMP2.txt');
temp2 = fscanf(temp2_fid, '%d\t%d',[2 inf])';
fclose(temp2_fid);
for i=1:length(temp2)
    temp2(i,2) = temp2(i,2)/256;
end

press_fid = fopen('PRESS.txt');
press = fscanf(press_fid,'%d\t%d',[2 inf])';
fclose(press_fid);
alt = zeros(size(press));
ascent_rate = zeros(size(press));
for i=1:length(press)
    press(i,2) = press(i,2)/100;
    alt(i,1) = press(i,1);
    ascent_rate(i,1) = press(i,1);
    alt(i,2) = 44.330*(1-(press(i,2)/1007)^(1/5.255));
    if (i>1)
        ascent_rate(i,2) = (alt(i,2) - alt(i-1,2))*1000/(ascent_rate(i,1) - ascent_rate(i-1,1));
  
    end
end
%filename = 'ascent_rate.xlsx'
%writetable(ascent_rate,filename,'Sheet',1,'Range','D1')

hum_fid = fopen('HUM.txt');
hum = fscanf(hum_fid,'%d\t%d',[2 inf])';
fclose(hum_fid);

%% Plot data

% Plot temperature data
len = length(temp);
figure;
plot(temp(start:len,1)/3600,temp(start:len,2),'LineWidth',2); hold on;
len = length(temp2);
plot(temp2(start:len,1)/3600,temp2(start:len,2),'r','LineWidth',2);
grid on; axis tight; 
title('Temperatures'); xlabel('Time (Hrs)'); ylabel('Temperature (C)');

% Plot pressure data
len = length(press);
figure; 
plot(press(start:len,1)/3600,press(start:len,2),'LineWidth',2); hold on;
grid on; axis tight; 
title('Pressure'); xlabel('Time (Hrs)'); ylabel('Pressure (mbar)');

% Plot altitude data
len = length(alt);
figure; 
plot(alt(start:len,1)/3600,alt(start:len,2),'LineWidth',2); hold on;
grid on; axis tight;
title('Altitude'); xlabel('Time (Hrs)'); ylabel('Altitude (km)');

% Plot ascent rate data
len = length(ascent_rate);
figure; 
% plot(ascent_rate(start:len,1)/3600,ascent_rate(start:len,2),'LineWidth',2); hold on;
plot(ascent_rate(start:len,1)/3600,runmean(ascent_rate(start:len,2),runmean_length),'r','LineWidth',2);
grid on; axis tight; 
title('Ascent rate'); xlabel('Time (Hrs)'); ylabel('Ascent rate(m/s)');

% Plot humidity data
len = length(hum);
figure; 
plot(hum(start:len,1)/3600,hum(start:len,2),'LineWidth',2); hold on;
grid on; axis tight; 
title('Humidity'); xlabel('Time (Hrs)'); ylabel('Humidity');

%% Co plot 2 data sets
% len_temp = length(temp2);
% len_alt = length(alt);
% figure; 
% plotyy(temp(start:len_temp,1)/3600,temp2(start:len_temp,2),alt(start:len_alt,1)/3600, alt(start:len_alt,2));  grid on; axis tight; 
% 
% plot(temp2(start:len_temp,1)/3600,temp2(start:len_temp,2),'r');
% 
% hold on;
% % Create second Y axes on the right.
% a2 = axes('YAxisLocation', 'Right');
% % Hide second plot.
% set(a2, 'color', 'none');
% set(a2, 'XTick', []);
% set(a2, 'YLim', [0 30]);
% plot(alt(start:len_alt,1)/3600,alt(start:len_alt,2),'b');

% figure; 
% len_temp = length(temp2);
% len_alt = length(alt);
% [a,h1,h2] = plotyy(temp2(start:len_temp,1)/3600,temp2(start:len_temp,2), alt(start:len_alt,1)/3600, alt(start:len_alt,2));
% grid on;
% set(a(2),'ycolor', 'red');
% set(a(2),'FontSize',12); set(a(2),'FontWeight','Bold');
% set(a(1),'FontSize',12); set(a(1),'FontWeight','Bold');
% set(a(2),'ylabel','Altitude');

