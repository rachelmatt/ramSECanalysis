%% ramSECanalysis.m
%% Final project Nens 230
% Rachel Matt
% Analysis of size exclusion chromatography traces
% generation of figures for summarizing protein purification
%% load data from Akta instrument
% export in ascii format both UV trace and Fractions collected
% the exported ascii should have the following columns:
% 1-mL  2-mAU 3-mL 4-F ractions
secInputName=input('Make sure file is in a MatLab path folder. Type file name with asc extension here, for example, mySECtrace.asc :','s')
% branch loading depending on Akta or BioRad output
if secInputName=='*.asc',
formatSpec='%f%f%f%s';
secInput=fopen(secInputName);
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
fraction.name=strrep(fraction.name,'"',''); % remove quotes which are standard Akta outputs
%%
elseif secInputName=='*.csv',
   secInput=fopen(secInputName);
else
    fprintf('The file could not be read.')
end
%% prompt for fraction collection
fracQueryIndex=0; %the first instance of fraction collection will be stored at position 1 in an array
continueFrac=input('Are there collected fractions? (y/n) ','s'); %jump-start the while loop
fracStart={'placeholder'}; %make a character array
fracEnd={'placeholder'};
while continueFrac=='y' 
    fracQueryIndex=fracQueryIndex+1;
    fracStart{fracQueryIndex}=input('List first collected fraction, for example, A10 : ','s');
    fracEnd{fracQueryIndex}=input('List last collected fraction, for example, B4 : ','s');
    % find the indices of the starting and ending fractions
% use string compare, strcmp, to test equivalence between input and strings
% in fraction name array. Find command returns the index where the input
% string matches. Yes. This was so satisfyingly elegant.
    fracStartIndex(fracQueryIndex)=find(strcmp(fracStart{fracQueryIndex},fraction.name));%  
    fracEndIndex(fracQueryIndex)=find(strcmp(fracEnd{fracQueryIndex},fraction.name));%
    continueFrac=input('Are there additional collected fractions? (y/n) ','s');
end
%% select fractions to label and plot data
%create arrays for axis labels (fractions)
axismL=[]; %placeholder arrays
axisName=[];
for idx=1:fracQueryIndex
    axismL=[axismL; fraction.mL(fracStartIndex(idx):fracEndIndex(idx))]; % take the range of collected fractions
    axisName=[axisName; fraction.name(fracStartIndex(idx):fracEndIndex(idx))];
end

x = trace.mL;
y1 = trace.mAU;
y2 = trace.mAU;

figure;
% axis 1 is the mL axis
ax1 = gca;
get(ax1,'Position')
set(ax1,'XColor','k',...
    'YColor','k');
line(x, y1, 'Color', 'k', 'LineStyle', '-', 'Marker', '.', 'Parent', ax1)
xlim([0,trace.mL(size(trace.mL,1))]); %adjust x-axis to max mL recorded
xlabel('Elution(mL)')
ylabel('Absorbance(mAU');
% axis 2 is the fraction axis
ax2 = axes('Position',get(ax1,'Position'),...
           'XAxisLocation','top',... % place the fraction label on top
           'YAxisLocation','left',...
           'Color','none',...
           'XColor','k',...
           'XTick',[axismL],'XTickLabel',[axisName]);
       xlabel('Fractions');
line(x, y2, 'Color', 'k', 'LineStyle', '-', 'Marker', '.', 'Parent', ax2)
xlim([0,trace.mL(size(trace.mL,1))]); %adjust x-axis to max mL recorded
%% Title prompt
fileTitle=input('Use file name as chart title? (y/n):','s');
if fileTitle=='y',
    gcf
    title(sprintf('SEC %s',secInputName));
else
    gcf
    titleText=input('Input title name : ','s');
    title(sprintf('%s',titleText));
end
%% Export figure
  
