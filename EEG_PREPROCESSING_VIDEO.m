name_var = '40'; %set unique identifier of the current subject
experiment_var = 'Video';
addpath /Applications/fieldtrip-20230118;
load('CHANS.mat','chans'); %load names of EEG sensors

%----------------dataset-------------------------
dataset='40_video_raw.edf' %name of the current dataset


%------------------------protocol--------------------------
protocol_name='protocol_40_Video.xlsx' %name of the protocol file

%------------------------Import EDF-----------------------------
%addpath /Users/maksimenko/Dropbox/!Hein/!FINAL_DATA %add path to the folder contaiting edf-file
cfg            = [];
cfg.dataset    = dataset;
cfg.continuous = 'yes';
cfg.channel    = [1:8 11:16 19 20 23 24 25];
data = ft_preprocessing(cfg);

%------------------------referencing-----------------------------
cfg = [];
cfg.channel = 'all'; % this is the default
cfg.reref = 'yes';
cfg.refmethod = 'avg';
cfg.refchannel = 'all';
data_ref = ft_preprocessing(cfg, data);

%-----------------------filtering---------------------------------
cfg = [];
cfg.lpfilter = 'yes';
cfg.hpfilter = 'yes';
cfg.lpfreq = 30;
cfg.hpfreq = 4;
data_filt = ft_preprocessing(cfg, data_ref);

%----------------------ICA decomposition---------------------------
cfg        = [];
cfg.method = 'runica';
cfg.channel = [1:18];

data_ica = ft_componentanalysis(cfg, data_filt);
data_ica.topolabel = chans

figure;
cfg = [];
cfg.component = 1:18;
cfg.layout    = 'EEG1010.lay';
cfg.comment   = 'no';
%ft_topoplotIC(cfg, data_ica)
ft_databrowser(cfg, data_ica)

cfg = [];
cfg.component = [1]; % to be removed component(s)
data_removed = ft_rejectcomponent(cfg, data_ica);

%-------------------------------------------------------
%T = readtable('ss.txt');
T = readtable(protocol_name,'ReadVariableNames',false);
trls1 =table2array(T);
trls=int64(trls1);

cfg = [];
cfg.trl = trls;
data_trials = ft_redefinetrial(cfg, data_removed);

%cfg = [];
%cfg.layout = 'EEG1020.lay';
%cfg.viewmode = 'vertical';
%ft_databrowser(cfg, data_trials);


%------------------preparing neighbour EEG channels----------------------
cfg = [];
cfg.method = 'triangulation';
cfg.layout = 'EEG1010.lay';
neighbours = ft_prepare_neighbours(cfg, data_trials);

neighbours(11).neighblabel = {'F7'; 'C3'; 'T5'}.';
neighbours(12).neighblabel = {'T3'; 'P3'; 'O1'}.';
neighbours(17).neighblabel = {'T4'; 'P4'; 'O2'}.';
neighbours(18).neighblabel = {'F8'; 'C4'; 'T6'}.';

%----------------------trial rejection----------------------
cfg          = [];
cfg.method   = 'summary';
%cfg.ylim     = [-1e-12 1e-12];
dummy        = ft_rejectvisual(cfg, data_trials);

cfg = [];
cfg.badchannel    = {'T3','F7','F8', 'Fp1'};
cfg.method = 'weighted';
cfg.neighbours = neighbours;
cfg.senstype = 'eeg';
cfg.elec = 'standard_1020.elc';
data_fixed = ft_channelrepair(cfg,data_trials);


data_fixed = data_trials %if no channels to repair

cfg          = [];
cfg.method   = 'summary';
%cfg.ylim     = [-1e-12 1e-12];
dummy        = ft_rejectvisual(cfg, data_fixed);

%cfg = [];
%cfg.layout = 'EEG1020.lay';
%cfg.viewmode = 'vertical';
%ft_databrowser(cfg, dummy);

%---------------------wavelet transform----------------------
cfg = [];
cfg.channel    = 'all';
cfg.method     = 'wavelet';
%cfg.trials     = 1;
cfg.foi        = 4:0.25:30;
cfg.toi        = 0.5:0.003:13.5; %set time for video and text
cfg.width      = cfg.foi;
cfg.output     = 'pow';
cfg.keeptrials = 'yes';
data_wavelet = ft_freqanalysis(cfg, data_fixed);

%---------------------baseline correction----------------------
cfg              = [];
cfg.baseline     = [0.5 4];
cfg.baselinetype = 'relchange';
cfg.keeptrials = 'yes';
data_baseline = ft_freqbaseline(cfg, data_wavelet);

cfg = [];
cfg.layout = 'EEG1010.lay';
figure;
ft_singleplotTFR(cfg, data_baseline);


%-----------------Forming datasets------------------

%-----------------theta--------------------
cfg = [];
cfg.frequency = [4 8];
cfg.latency = [4 13.5];
cfg.avgoverfreq = 'yes';
cfg.nanmean = 'no';
cfg.parameter    = 'powspctrm';
cfg.keepfreqdim    = 'no'
theta = ft_selectdata(cfg,data_baseline);
theta_=[theta.powspctrm];

%filepath = '/Users/maksimenko/Dropbox/!Hein/!FINAL_DATA/MATLAB_OUTPUT/'; %set path to the folder to save output
filename = strcat(name_var,'_','theta','_Video','.mat');
save(filename,'theta_')

%-----------------alpha--------------------
cfg = [];
cfg.frequency = [8 12];
cfg.latency = [4 13.5];
cfg.avgoverfreq = 'yes';
cfg.nanmean = 'no';
cfg.parameter    = 'powspctrm';
cfg.keepfreqdim    = 'no'
alpha = ft_selectdata(cfg,data_baseline);
alpha_=[alpha.powspctrm];

filename = strcat(name_var,'_','alpha','_Video','.mat');
save(filename,'alpha_')

%-----------------beta--------------------
cfg = [];
cfg.frequency = [15 30];
cfg.latency = [4 13.5];
cfg.avgoverfreq = 'yes';
cfg.nanmean = 'no';
cfg.parameter    = 'powspctrm';
cfg.keepfreqdim    = 'no'
beta = ft_selectdata(cfg,data_baseline);
beta_=[beta.powspctrm];

filename = strcat(name_var,'_','beta','_Video','.mat');
save(filename,'beta_')

%----------------------------------------------------------------
