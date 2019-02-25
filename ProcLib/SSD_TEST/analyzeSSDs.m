fName = 'stopSig_2019_02_24.csv';
%ssdTable = csvread(fName,1);

ssdTable = readtable(fName,'ReadVariableNames',true);
refreshRate = 1000/60;
% varNames: TRL_NUMBER, TRL_STOP_SIGNAL_DELAY, TRL_TARG_SSD_VRT_RFRSH_COUNT, TRL_TARG_ON_TIME, TRL_STOP_SIGNAL_TIME, TRL_STOP_SIGNAL_DURATION
ssdTable.ssdTimeExpected = (ssdTable.TRL_STOP_SIGNAL_DELAY)* refreshRate;
ssdTable.ssdTimeFromVRCount = (ssdTable.TRL_TARG_SSD_VRT_RFRSH_COUNT)* refreshRate;
ssdTable.ssdTimeFromTickCount = ssdTable.TRL_STOP_SIGNAL_DURATION;
ssdTable.ssdTimeFromTargOnSSOn = ssdTable.TRL_STOP_SIGNAL_TIME - ssdTable.TRL_TARG_ON_TIME;


varNames = ssdTable.Properties.VariableNames;

ssdStats = grpstats(ssdTable,{'TRL_STOP_SIGNAL_DELAY'},{'min','median','mean','max','std'},...
                              'DataVars',{'ssdTimeExpected', 'ssdTimeFromVRCount',...
                                          'ssdTimeFromTickCount','ssdTimeFromTargOnSSOn'});
% get distributions:
relTimeMs = -100:100;
relTimeMsEdges = -100-0.5:100+0.5;


    uniqSsd = unique(ssdTable.TRL_STOP_SIGNAL_DELAY);
    ssdByRfrsh = arrayfun(@(x) ssdTable(ssdTable.TRL_STOP_SIGNAL_DELAY == x,:),uniqSsd,'UniformOutput',false);
    ssdDistFromVRCount = arrayfun(@(x) histcounts(ssdTable{ssdTable.TRL_STOP_SIGNAL_DELAY == x,'ssdTimeFromVRCount'}- x*16.67,relTimeMsEdges),...
       uniqSsd,'UniformOutput',false);
    ssdDistFromTickCount = arrayfun(@(x) histcounts(ssdTable{ssdTable.TRL_STOP_SIGNAL_DELAY == x,'ssdTimeFromTickCount'}- x*16.67,relTimeMsEdges),...
       uniqSsd,'UniformOutput',false);
    ssdDistFromTargOnSSOn = arrayfun(@(x) histcounts(ssdTable{ssdTable.TRL_STOP_SIGNAL_DELAY == x,'ssdTimeFromTargOnSSOn'}- x*16.67,relTimeMsEdges),...
       uniqSsd,'UniformOutput',false);

figure
for ii=1:numel(uniqSsd)
    expectedSsd = uniqSsd(ii)*16.67;
    subplot(3,1,1)
    bar(relTimeMs,ssdDistFromVRCount{ii,1});
    ylabel('ssdDistFromVRCount (ms)');
    xlabel('Rel. time (SSD - Expected SSD) (ms)')
    title(['SSD_{expected} [#' num2str(uniqSsd(ii),'%d] = [') num2str(round(expectedSsd),'%d ms]')])
    subplot(3,1,2)
    bar(relTimeMs,ssdDistFromTickCount{ii,1});
    ylabel('ssdDistFromTickCount (tics=ms)');
    xlabel('Rel. time (SSD - Expected SSD) (ms)')
    title(['SSD_{expected} [#' num2str(uniqSsd(ii),'%d] = [') num2str(round(expectedSsd),'%d ms]')])
    subplot(3,1,3)
    bar(relTimeMs,ssdDistFromTargOnSSOn{ii,1});
    ylabel('ssdDistFromTargOnSSOn (ms)');
    xlabel('Rel. time (SSD - Expected SSD) (ms)')
    title(['SSD_{expected} [#' num2str(uniqSsd(ii),'%d] = [') num2str(round(expectedSsd),'%d ms]')])
    drawnow
    %pause
end

% for boxplot?
figure;
subplot(1,3,1)
ssdTimeFromVRCountCount = ssdTable{:, {'TRL_STOP_SIGNAL_DELAY','ssdTimeFromVRCount'}};
boxplot(ssdTimeFromVRCountCount(:,2),round(ssdTimeFromVRCountCount(:,1).*16.67))
set(gca,'XTickLabelRotation',45);
xlabel('SSD time Expected (ms)');
ylabel('SSD Time: PD VR Count (ms)');
yticksVals = round([2:2:60].*16.67);
yticks(yticksVals)
grid on

subplot(1,3,2)
ssdTimeFromTickCount = ssdTable{:, {'TRL_STOP_SIGNAL_DELAY','ssdTimeFromTickCount'}};
boxplot(ssdTimeFromTickCount(:,2),round(ssdTimeFromTickCount(:,1).*16.67))
set(gca,'XTickLabelRotation',45);
xlabel('SSD time Expected (ms)');
ylabel('SSD Time: Tick Count (ms)');
yticksVals = round([2:2:60].*16.67);
yticks(yticksVals)
grid on
title('SSD time comaprision');

subplot(1,3,3)
ssdTimeFromTargOnSSOn = ssdTable{:, {'TRL_STOP_SIGNAL_DELAY','ssdTimeFromTargOnSSOn'}};
boxplot(ssdTimeFromTargOnSSOn(:,2),round(ssdTimeFromTargOnSSOn(:,1).*16.67))
set(gca,'XTickLabelRotation',45);
xlabel('SSD time Expected (ms)');
ylabel('SSD Time: StopSignalOnTime - TargOnTime (ms)');
yticksVals = round([2:2:60].*16.67);
yticks(yticksVals)
grid on
