%% Final project Nens 230
% Analysis of size exclusion chromatography traces
% generation of figures for summarizing protein purification
%% load data from Akta instrument
% export in ascii format both UV trace and Fractions collected
% the exported ascii should have the following columns:
% 1-mL  2-mAU 3-mL 4-F ractions
secInput=input('Make sure file is in a MatLab path folder. Type file name with asc extension here, for example, mySECtrace.asc :','s')
formatSpec='%f%f%f%s';
secInput=fopen(secInput);
secTrace=textscan(secInput,formatSpec,'Delimiter','\t','HeaderLines',3);%start importing from the 4th line, tab-delimited. This is the best importer for mixed data.
trace.mL=secTrace{1}; % load x data for trace
trace.mL=trace.mL(isfinite(trace.mL)); %get rid of NaNs
trace.mAU=secTrace{2}; % load y date for trace
trace.mAU=trace.mAU(isfinite(trace.mAU)); % get rid of NaNs
%% load data from BioRad instrument

%% organize fraction labels
tempArray=secTrace{3};
fraction.mL=tempArray(isfinite(tempArray)); % get rid of NaNs
fractionSize=size(fraction.mL,1); % find the total number of fractions
fraction.name=secTrace{4}(1:fractionSize); % get rid of empty cells
fraction.name=strrep(fraction.name,'"',''); % remove quotes which are standard outputs from our SEC program
%determine collected fractions
%fracStart=input('List first collected fraction, for example, A10 : ','s');
%fracEnd=input('List last collected fraction, for example, B4 : ','s');
%continueFrac=input('Are there additional collected peaks? (Y/N) ','s');

%if continueFrac=='Y'
    
% find the indices of the starting and ending fractions
% use string compare, strcmp, to test equivalence between input and strings
% in fraction name array. Find command returns the index where the input
% string matches. Yes. This was so satisfyingly elegant.
%fracStartIndex=find(strcmp(fracStart,fraction.name));%  
%fracEndIndex=find(strcmp(fracEnd,fraction.name));%
%%
% prompt, then continue prompting for more fractions
fracQueryIndex=0; %the first instance of fraction collection will be stored at position 1 in an array
continueFrac=input('Are there collected fractions? (y/n) ','s'); %jump-start the while loop
fracStart={'placeholder'}; %make a character array
fracEnd={'placeholder'};
while continueFrac=='y' 
    fracQueryIndex=fracQueryIndex+1;
    fracStart{fracQueryIndex}=input('List first collected fraction, for example, A10 : ','s');
    fracEnd{fracQueryIndex}=input('List last collected fraction, for example, B4 : ','s');
    fracStartIndex(fracQueryIndex)=find(strcmp(fracStart{fracQueryIndex},fraction.name));%  
    fracEndIndex(fracQueryIndex)=find(strcmp(fracEnd{fracQueryIndex},fraction.name));%
    continueFrac=input('Are there additional collected fractions? (y/n) ','s');
end
%% select fractions to label and plot data
%figure
%plot(trace.mL,trace.mAU)
%xlim([0,trace.mL(size(trace.mL,1))]); %adjust x-axis to max mL recorded
%xlabel('Elution (mL)');
%ylabel('Absorbance (mAu)');
%concatenate axis tick labels
axismL=[]; %placeholder arrays
axisName=[];
for idx=1:fracQueryIndex
    axismL=[axismL; fraction.mL(fracStartIndex(idx):fracEndIndex(idx))]; % take the range of collected fractions
    axisName=[axisName; fraction.name(fracStartIndex(idx):fracEndIndex(idx))];
end
%create x tick labels for mL
%axismLstd=[5;10;15;20;25;30];
%axismL=[axismL; axismLstd];
%axisNameStd={'5 mL';'10 mL';'15 mL';'20 mL';'25 mL';'30 mL'}
%axisName=[axisName; axisNameStd];
set(gca,'XTick', axismL,'XTickLabel',axisName)
% need to figure out how to overlay the normal mL axis
%%
for idx=1:2
  plot(trace.mL,trace.mAU)
  axis(idx+1)=gca
  
set(axis(idx+1),'XTick', fraction.mL(fracStartIndex(idx):fracEndIndex(idx)))
set(axis(idx+1),'XTickLabel',fraction.name(fracStartIndex(idx):fracEndIndex(idx)))%only label collected fractions
end
%%
%xlabels{1}=axisName
%xlabels{2}=['5';'10';'15';'20';'25';'30']
%ylabels={'mAU' 'mAU'}
%plotxx(axismL,trace.mAU,trace.mL,trace.mAU,xlabels,ylabels)
%%
h_ax = gca;
h_ax_line = axes('position', get(h_ax, 'position')); % Create a new axes in the same position as the first one, overlaid on top
plot(trace.mL,trace.mAU,'r-');
set(h_ax_line, 'XAxisLocation', 'bottom', 'xlim', get(h_ax, 'xlim'), 'color', 'none');

%% plot and visualize SEC trace, fractions
x = trace.mL;
y1 = trace.mAU;
y2 = trace.mAU;

figure;
ax1 = gca;
get(ax1,'Position')
set(ax1,'XColor','k',...
    'YColor','b');
line(x, y1, 'Color', 'b', 'LineStyle', '-', 'Marker', '.', 'Parent', ax1)
xlim([0,trace.mL(size(trace.mL,1))]); %adjust x-axis to max mL recorded
xlabel('Elution(mL)')
ylabel('Absorbance(mAU');
ax2 = axes('Position',get(ax1,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','left',...
           'Color','none',...
           'XColor','k',...
           'XTick',[axismL],'XTickLabel',[axisName]);
       xlabel('Fractions');
line(x, y2, 'Color', 'r', 'LineStyle', '-', 'Marker', '.', 'Parent', ax2)
xlim([0,trace.mL(size(trace.mL,1))]); %adjust x-axis to max mL recorded