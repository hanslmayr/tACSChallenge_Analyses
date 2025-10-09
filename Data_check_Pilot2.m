% import and plot data for checking purposes
addpath('D:\code\tACSChallenge_Analyses-main');
datpth='D:\data\Pilot2\';
cd(datpth);
conds={'CU';'OC';'RE';'SH'};
mont='PlanA';
lp_filt=1;%if 1 then filter, if 0 then no filter
fn=dir(['L18_pilot02_staircase_*.tsv']);
plot_staircase(fn(1,1).name); 
for k=1:length(conds)
    % plot staircase result
    fn=dir(['L18_Pilot02_B*_', conds{k,1}, '*' mont '*.tsv']);    
    %figure;
    pltidx1=1:2:8;
    pltidx2=2:2:8;
    for j=1:numel(fn)
        dat{1,j}=tACSChallenge_ImportData(fn(j,1).name);
        nsamples=numel(dat{1,j}.tACS);
        % Example time series vector (replace this with your own data)
        fs = 1000;                    % Sampling frequency (Hz) fixed at 1000 Hz; Ugly fix!
        dt=1/fs;
        time=0:dt:(nsamples*dt)-dt; 
        signal2plt=dat{1,j}.tACS;
        
        % perform butterworth low pass filter at 40 Hz
        signal_filt=bw_lp_filt(signal2plt,fs,40,time);
        if lp_filt == 1
            signal2plt = signal_filt;
            x = signal_filt;
        else
            x = signal2plt;
        end
        t = time;            % Time vector (1 second duration)
        % Compute FFT
        N = length(x);                % Number of samples
        X = fft(x);                   % Compute FFT
        f = (0:N-1)*(fs/N);           % Frequency vector
        % Only plot the first half of the spectrum
        half_N = floor(N/2)+1;
        X_magnitude = abs(X(1:half_N)) / N;    % Magnitude
        f_plot = f(1:half_N);                  % Frequencies
        
        % Plot the result
        
            
        subplot(4,2,pltidx1(k));
        plot(time,signal2plt);
        xlim([100 102]);
        title([conds{k} '--' mont 'Fs=' num2str(fs)]);
        subplot(4,2,pltidx2(k))
        plot(f_plot, X_magnitude);
        xlim([1 60]);
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        switch mont
            case 'PlanA'
                mont2disp='Cz-POz'
            case 'PlanB'
                mont2disp='AFz - POz'
            case 'PlanC'
                mont2disp='AFz - Cz'
        end
        
               
        title(['FFT of ' conds{k} '--' mont2disp]);
        grid on;
        
    end
end

function plot_staircase(filename)

%% check staircase data
data=tACSChallenge_ImportData(filename);
%data2 = tACSChallenge_ImportData(' /Users/floriankasten/ownCloud/Home-Cloud/tACSChallange/Piloting/P01/SUBJ01-1-Staircase_2021_09_28_15_05_56.tsv');

%% get onsets of button presses
respOnsets = diff(data.L_Button);
respOnsets(respOnsets < 0) = 0;

data.LEDs = data.LEDs - repmat(data.LEDs(:,1), 1, size(data.LEDs,2));

%% merge LED signals into one
LED = max(data.LEDs, [], 2);

%% get onsets of target LED
LED = diff(LED);
LED(LED < 0) = 0;

LEDLat=find(LED>0);
RespLat = find(respOnsets>0);

lastLED = LED(LED>0);
lastLED = lastLED(end-9:end);
stairResult = mean(lastLED)+0.2;

% Extract LED intensity and Hits/Misses for plotting results of
% Staircase
LEDintens=LED(LEDLat);
ntrls=numel(LEDLat);
figure;
plot([1:ntrls],LEDintens);
hold on
for i=1:ntrls
    trials(i,1) = LEDLat(i);
    trials(i,2)= LEDintens(i);
    if any(RespLat > trials(i,1) & RespLat < trials(i,1) + 2000)
        
        trials(i,3) = 1;
        RTs=RespLat(RespLat > trials(i,1) & RespLat < trials(i,1) + 2000);
        trials(i,4) = min(RTs) - trials(i,1);
        plot(i, trials(i,2), '*', 'color', [0 0 1]);
        hold on
    else
        plot(i, trials(i,2), '+', 'color', [1 0 0]);
    end
    
    
end
title('Staircase');
hold off
end