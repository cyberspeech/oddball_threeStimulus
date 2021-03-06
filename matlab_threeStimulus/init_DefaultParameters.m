function parameters = init_DefaultParameters(handles)

    % Try to put all the parameters here, i.e. variables that have an
    % effect of the outcome of the calculations. This way everything is
    % centralized and with a "one glance" you can figure out all the
    % parameters affecting the relatively large amount of code
    
    % in the init_DefaultSettings, you can define variables such as
    % locations of the folders, etc., while one can argue that some
    % variables could be placed to either subfunction

    %% BIOSEMI Channel Definitions
    
        parameters.BioSemi.chName{1} = 'Ref_RightEar'; 
        parameters.BioSemi.chName{2} = 'Ref_LeftEar'; 
        parameters.BioSemi.chName{3} = 'Fz'; % ch3 - EX3: Fz
        parameters.BioSemi.chName{4} = 'Cz'; % ch4 - EX4: Cz
        parameters.BioSemi.chName{5} = 'Pz'; % ch5 - EX5: Pz
        parameters.BioSemi.chName{6} = 'Oz'; % ch6 - EX6: Oz
        parameters.BioSemi.chName{7} = 'EOG'; % ch7 - EX7: EOG (was put below the right eye)
        parameters.BioSemi.chName{8} = 'HR'; % ch8 - EX8: Heart Rate (was put on the chest)   
        parameters.BioSemi.chOffset = 2; % number of channels to omit (i.e. the reference channels)
        parameters.BioSemi.channelLocationsFile = 'centralChannelLocations.ced'; % needed for some EEGLAB functions/plugins

            % The input trigger signals are saved in an extra channel (the status channel), with the same sample rate as the electrode channels.
            % http://www.biosemi.com/faq/trigger_signals.htm
            parameters.BioSemi.chName{9} = 'Status/Trigger';            

        % Inverse polarity (if P300 is negative and N2 is positive)
        parameters.EEG.invertPolarity = 0;

        % Defines the signals to be read from the BDF file   
        parameters.SignalsToRead = [1 2 3 4 5 6 7 8 9]; % Channels 1-8 and 9 is the Trigger

        % Define triggers

            % Button 1 & 2
            % Standard Tone
            % Oddball Tone
            % Irregular Cycle
            % Recording start 

            % http://www.biosemi.com/faq/trigger_signals.htm
            parameters.triggerSignals.buttons = [1 2];
            parameters.triggerSignals.oddTone = 9;
            parameters.triggerSignals.stdTone = 10;            
            parameters.triggerSignals.distracterTone = 11;
            parameters.triggerSignals.recON = 12;  
            
            parameters.triggerSignals.audioON = 5;

                % if audio trigger is not found (e.g. hardware failure),
                % use the following mean delay from Python trigger onset,
                % empirical estimate (depends on your hardware and OS)
                parameters.triggerSignals.meanAudioDurationFromPythonTrigger = 622; % [in samples]

            parameters.triggerPrecision = 24; % 24 bits, http://www.biosemi.com/faq/trigger_signals.htm

        % General EEG Parameters
        % parameters.EEG.srate - read automatically during import of individual BDF file
        parameters.EEG.nrOfChannels = 4; % number of EEG channels
        parameters.EEG.downsampledRate = 4096; % Hz
                                           % There wil be problems with the
                                           % next steps in the algorithm
                                           % with changing this from the
                                           % original sample rate (namely
                                           % pre_deconcatenateEpochs.m),
                                           % change later if you wanna have
                                           % a working downsampling to cut
                                           % a bit the processing time               
    
            
    %% Band-pass filter parameters
    
        % for discussion of the filter limits, you can see for example:
        
            % Acunzo DJ, MacKenzie G, van Rossum MCW. 2012. 
            % Systematic biases in early ERP and ERF components as a result of high-pass filtering. 
            % Journal of Neuroscience Methods 209:212–218. 
            % http://dx.doi.org/10.1016/j.jneumeth.2012.06.011.
            
            % Widmann A, Schröger E. 2012. 
            % Filter effects and filter artifacts in the analysis of electrophysiological data. 
            % Frontiers in Perception Science:233. 
            % http://dx.doi.org/10.3389/fpsyg.2012.00233.
    
        % Flags for filtering (not implemented very well, correct for code)
        parameters.filter.filterForCNV = 1;
        parameters.filter.filterForAlpha = 1;

        % GENERAL
        parameters.filter.bandPass_loFreq = 0.01;
        parameters.filter.bandPass_hiFreq = 55;
        parameters.filterOrder = 6; % filter order   
        parameters.filterOrderSteep = 100; % additional pass of filtering with steeper cut
        parameters.applySteepBandPass = 0;        
        
            % 0.01 Hz recommended as low-cut off frequency for ERP by:
            % * Acunzo et al. (2012), http://dx.doi.org/10.1016/j.jneumeth.2012.06.011
            % * Luck SJ. 2005. An introduction to the event-related potential technique. Cambridge, Mass.: MIT Press.
        
        % ALPHA, see Barry et al. (2000), http://dx.doi.org/10.1016/S0167-8760(00)00114-8        
        parameters.filter.bandPass_Alpha_loFreq = 8;
        parameters.filter.bandPass_Alpha_hiFreq = 13;
        parameters.filterOrder_Alpha = 10; % filter order   
    
        % ERP
        parameters.filter.bandPass_ERP_loFreq = 0.1;
        parameters.filter.bandPass_ERP_hiFreq = 20;
        parameters.filterOrder_ERP = parameters.filterOrder; % filter order   
        
            % ERP smooth1
            parameters.filter.bandPass_ERPsmooth1_loFreq = 0.1;
            parameters.filter.bandPass_ERPsmooth1_hiFreq = 14;
            parameters.filterOrder_ERPsmooth1 = parameters.filterOrder; % filter order
            
            % ERP smooth2
            parameters.filter.bandPass_ERPsmooth2_loFreq = 0.1;
            parameters.filter.bandPass_ERPsmooth2_hiFreq = 10;
            parameters.filterOrder_ERPsmooth2 = parameters.filterOrder; % filter order
    
        % parameters for re-bandbass filtering for extracting the CNV
        parameters.filter.bandPass_CNV_loFreq = 0.1;
        parameters.filter.bandPass_CNV_hiFreq = 6;
        parameters.filterOrder_CNV = parameters.filterOrder; % filter order   
        
        % You could test a P300 specific filtering either between 0-4 Hz or
        % 0.001 - 4 Hz (to remove DC bias), this band is however mostly used in 
        % BCI application and this filtering will deform the "typical shape" of P300
        parameters.filter.bandPass_P300_loFreq = 0.1;
        parameters.filter.bandPass_P300_hiFreq = 4;
        parameters.filterOrder_P300 = parameters.filterOrder; % filter order   
        
            % see short discussion in:        
            % Ghaderi F, Kim SK, Kirchner EA. 2014. 
            % Effects of eye artifact removal methods on single trial P300 detection, a comparative study. 
            % Journal of Neuroscience Methods 221:41–47. 
            % http://dx.doi.org/10.1016/j.jneumeth.2013.08.025   
        
        
    
    %% Artifact rejection parameters    
    
        % Fixed thresholds
        parameters.artifacts.fixedThr = 170; % fixed threshold (uV) of artifacts    
                                             % 100 uV in Molnar et al. (2008), http://dx.doi.org/10.1111/j.1469-8986.2008.00648.x
        parameters.artifacts.fixedThrEOG = 120; % fixed threshold (uV) of EOG artifacts
                                               % 70 uV in e.g. Acunzo et al. (2012), http://dx.doi.org/10.1016/j.jneumeth.2012.06.011
        parameters.artifacts.applyFixedThrRemoval = 1; % convert values above threshold to NaN
        parameters.artifacts.applyFixedThrEOGRemoval = 1; % convert values above threshold to NaN
                        
            % fixed threshold "detrending parameters"
            % not that crucial if some distortion is introduced by too
            % aggressive low cut of 1 Hz for example, but without
            % detrending, finding threshold exceeding samples would be
            % rather impossible due to possible DC drifts and trends
            parameters.artifacts.fixedDetrendingLowCut = parameters.filter.bandPass_loFreq;
            parameters.artifacts.fixedDetrendingHighCut = 300;
            parameters.artifacts.fixedDetrendingOrder = parameters.filterOrder;
        
        % "Advanced artifact removal"
        parameters.artifacts.applyRegressEOG = 1; % apply regress_eog from BioSig to eliminate EOG/ECG-based artifacts
        parameters.artifacts.applyRegressECG = 0; % apply regress_eog from BioSig to eliminate EOG/ECG-based artifacts
            %parameters.artifacts.epochByEpochRemoveBaseline = 0; % use rmbase() to remove baseline before ICA
            %parameters.artifacts.useICA = 0; % otherwise use the regress_eog
            %parameters.artifacts.show_ICA_verbose = 1;
            
            parameters.artifacts.regressBirectContamCutoffs = [0 7.5];
                % EOG channel itself is contaminated by brain activity and
                % we need to try to mitigate this by removing high
                % frequencies from the EOG signal
                % see e.g. Ghaderi et al. (2014), http://dx.doi.org/10.1016/j.jneumeth.2013.08.025
                %          Romero et al. (2009), http://dx.doi.org/10.1007/s10439-008-9589-6
            
        
        % FASTER
        parameters.artifacts.useFASTER = 1;
        
            parameters.artifacts.FASTER_lpf_wFreq = 95;
            parameters.artifacts.FASTER_lpf_bandwidth = 2.5;            
            parameters.artifacts.FASTER_zThreshold_step2 = 1.45; % default is 3 (for high-density EEG), the default value does
                                                           % not reject much of artifacts so the smaller value is empirically
                                                           % set for "better" performance
            parameters.artifacts.FASTER_zThreshold_step3 = parameters.artifacts.FASTER_zThreshold_step2;
            parameters.artifacts.FASTER_zThreshold_step4 = 1.2; % use tighter rejection, 1.2 set empirically 
            
            parameters.artifacts.FASTER_icaMethod = 'runica'; % 'runica' or 'fastica'
            parameters.artifacts.FASTER_skipICA = 0; % with our four EEG channels, there is typically no artifact channels, 
                                                     % and this part just
                                                     % is computationally
                                                     % heavy for nothing
                                                     
            % correct the artifacts using the regress_eog from BioSig
            % not advised to correct epoch-by-epoch
            parameters.artifacts.FASTER_regressEOG_asStep3 = 0;
            parameters.artifacts.FASTER_applyRegressionEOG = 0;
            parameters.artifacts.FASTER_applyRegressionECG = 0;
            
            % rejection threshold of whole channel as ratio. In other words
            % if only 4 trials out of 40 are spared after the rejection
            % routine, one might say that the channel is rather bad quality
            parameters.artifacts.FASTER_chRejectionRatio = 0.15;
            
            % for continuous 
            parameters.artifacts.continuousFASTER = 1;
                parameters.artifacts.continuousEpochLength = 0.05; % seconds
                
                % in the current version of the script, the continuous
                % artifact rejection is only used for the timeSeries
                % analysis of EEG (IAF and fractal EEG), and this rejection
                % is not propagated to the epoch analysis, where the
                % FASTER+CRAP+FIXED rejection is done again:
                parameters.artifacts.rejectContinuousFromEpochs = 0;
            
        
        % CRAP of ERPLAB
        % http://erpinfo.org/erplab/erplab-documentation/documentation-archive-for-previous-versions/v3.x-documentation/tutorial/Artifact_Detection.html
        % http://erpinfo.org/erplab/erplab-documentation/manual_4/Artifact_Detection.html               
        parameters.artifacts.applyContinuousCRAP = 1;
        parameters.artifacts.CRAP.continuous_ampth = [-120 120];
        parameters.artifacts.CRAP.continuous_windowWidth = 2000;
        parameters.artifacts.CRAP.continuous_windowStep = 1000;
        
            % Epoch correction in "pre_artifactFASTER_fixedThresholds_ERPLAB"
            parameters.artifacts.CRAP.step_ampTh = 10;
            parameters.artifacts.CRAP.step_windowWidth = 50;
            parameters.artifacts.CRAP.step_windowStep = 15;

            parameters.artifacts.CRAP.movWindEOG_ampTh = [-60 60]*1;
            parameters.artifacts.CRAP.movWindEOG_windowWidth = 25;
            parameters.artifacts.CRAP.movWindEOG_windowStep = 20;

            parameters.artifacts.CRAP.movWind_ampTh = [-60 60]*1;
            parameters.artifacts.CRAP.movWind_windowWidth = 25;
            parameters.artifacts.CRAP.movWind_windowStep = 20;    
                                                     
        % DETECT
        parameters.artifacts.useDETECT = 0;
        
        % ADJUST
        parameters.artifacts.useADJUST = 0;
        
    
    %% Power spectrum analysis parameters
    
        parameters.powerAnalysis.tukeyWindowR = 0.10; % 0.10 equals to 10% cosine window
        parameters.powerAnalysis.segmentLength = 4.0; % xx second segment lengths for PWELCH
        parameters.powerAnalysis.nOverlap = 50; % overlap [%] between successive segments
        
        chOffset = 2; %EX1 and EX2 for earlobes
        parameters.powerAnalysis.alphaRange = [parameters.filter.bandPass_Alpha_loFreq parameters.filter.bandPass_Alpha_hiFreq];
        parameters.powerAnalysis.alphaCh = [5 6] - chOffset; % Pz and Oz (-2 for ref channels)
                
        parameters.powerAnalysis.eegBins.freqs{1} = [-1.5 1.5];
        parameters.powerAnalysis.eegBins.label{1} = 'alpha'; % on Pz and Oz
        parameters.powerAnalysis.eegBins.ch{1} = [5 6] - chOffset; % from what channel(s) are calculated

        parameters.powerAnalysis.eegBins.freqs{2} = [-1.5 0];
        parameters.powerAnalysis.eegBins.label{2} = 'lowAlpha'; % on Pz and Oz
        parameters.powerAnalysis.eegBins.ch{2} = [5 6] - chOffset; 
        
        parameters.powerAnalysis.eegBins.freqs{3} = [0 1.5];
        parameters.powerAnalysis.eegBins.label{3} = 'highAlpha'; % on Pz and Oz
        parameters.powerAnalysis.eegBins.ch{3} = [5 6] - chOffset; 

        parameters.powerAnalysis.eegBins.freqs{4} = [13 30];
        parameters.powerAnalysis.eegBins.label{4} = 'beta'; % Fz and Cz
        parameters.powerAnalysis.eegBins.ch{4} = [3 4] - chOffset; 

        parameters.powerAnalysis.eegBins.freqs{5} = [5 7];
        parameters.powerAnalysis.eegBins.label{5} = 'theta'; % Fz and Cz
        parameters.powerAnalysis.eegBins.ch{5} = [3 4] - chOffset; 
        
        % Bands used in Lockley et al. 2006 (check abstract)
        % http://www.ncbi.nlm.nih.gov/pubmed/16494083
        parameters.powerAnalysis.eegBins.freqs{6} = [0.5 5.5];
        parameters.powerAnalysis.eegBins.label{6} = 'deltaThetaLockley';
        parameters.powerAnalysis.eegBins.ch{6} = [3 4] - chOffset;
        
        % Total band power, used for calculating the ratios
        parameters.powerAnalysis.eegBins.freqs{7} = [0.5 parameters.filter.bandPass_hiFreq];
        parameters.powerAnalysis.eegBins.label{7} = 'totalFzCz';
        parameters.powerAnalysis.eegBins.ch{7} = [3 4] - chOffset;
        
        parameters.powerAnalysis.eegBins.freqs{8} = [0.5 parameters.filter.bandPass_hiFreq];
        parameters.powerAnalysis.eegBins.label{8} = 'totalOzPz';
        parameters.powerAnalysis.eegBins.ch{8} = [5 6] - chOffset;
        
            % for more details see: http://www.mathworks.com/help/signal/ref/pwelch.html
            

    %% EEG FRACTAL ANALYSIS
    
        parameters.eegFractal.compute_MFDFA = 0;
    
    %% ECG ANALYSIS       
    
        parameters.heart.downsampleFactor = 8;
    
        parameters.heart.detrendMethod = 'ougp'; % 'linear' / 'constant' /'ougp'
        parameters.heart.filterWindow = 'hanning'; % 'hanning' / 'hamming' / 'blackman' / 'bartlett'
        parameters.heart.noOfFFTPoints = 'auto'; % 'auto' / '512' / '1024'
        parameters.heart.spectralAlgorithm = 'FFT'; % 'FFT' / 'AR model'
        parameters.heart.rrTimeSeriesUpsampleRate = 4; % [Hz], see e.g. http://dx.doi.org/10.1007/s11517-012-0928-2

        parameters.heart.freqBins.ULF = [0.0005 0.003]; % [Hz]
        parameters.heart.freqBins.ULFStar = [0.002 0.01]; % [Hz]
        parameters.heart.freqBins.VLF = [0.003 0.01]; % [Hz]
        parameters.heart.freqBins.LF = [0.04 0.15]; % [Hz]
        parameters.heart.freqBins.HF = [0.15 0.40]; % [Hz]
        parameters.heart.freqBins.TOTAL = [0.005 2]; % [Hz]

        parameters.heart.freqResolution = 0.005;
        parameters.heart.freqRange = [parameters.heart.freqBins.TOTAL(1) parameters.heart.freqBins.TOTAL(2)+parameters.heart.freqResolution];
        parameters.heart.ougpBinByBin = 0;

        if parameters.heart.freqRange(1) == 0
            warning('Low cutoff for HRV analysis can''t be zero, use the freqResolution for example! Script will work but PSD will be full of NaNs')
        end
        
        % Outlier detection (from HRVAS)        
        parameters.heart.ectopicOutlierMethod = 'median'; % 'percent', 'median', 'sd'
        parameters.heart.ectopicPercentParam = 20; % def 20, from HRVAS
        parameters.heart.ectopicSdParam = 3; % def 3, from HRVAS
        parameters.heart.ectopicMedianParam = 4; % def 4, from HRVAS        

        parameters.heart.outlierReplaceMethod = 'remove'; % 'mean' / 'median' / 'cubic' / 'remove'
        
            
    %% Time-Frequency Analysis
    
        parameters.timeFreq.computeTF = 0;
        parameters.timeFreq.logFrq = 0; % whether you use linear or log frequency scale        
        parameters.timeFreq.plotEpochs = 1;
                
        % Scales is the parameter a
        % scale factor a is defined as the inverse of frequency (a=1/ƒ)
        % in general. ERPWaveLab wants the scales to be a list of
        % frequencies that you want to analyze       
        parameters.timeFreq.scaleLimits = [1 30];
        parameters.timeFreq.numberOfFreqs = 2*(parameters.timeFreq.scaleLimits(2) - parameters.timeFreq.scaleLimits(1)) + 1;
        parameters.timeFreq.windowEpochs = 1; % window with Tukey window (r = 0.10, 10% cosine window) 
        parameters.timeFreq.tukeyWindowR = 0.05;
                
        parameters.timeFreq.bandwidthParameter = 2;
        parameters.timeFreq.waveletResol = 12;
        parameters.timeFreq.timeResolutionDivider = 16;
            % e.g. with 8,  freqRange: [3.8721 495.6228], freqResolution: 0.0422
            % e.g. with 16, freqRange: [1.9360 247.8114], freqResolution: 0.0211
            % e.g. with 32, freqRange: [0.9680 123.9057], freqResolution: 0.0105. timeRes: 7.8125 ms
        
        % If you wanna reject values under the Cone-Of-Influcence (COI)
        parameters.timeFreq.rejectUnderCOI = 1; 

            
    %% 3-Stimulus Oddball parameters
    
        parameters.oddballTask.numberOfTrialsPerCycle = 8;
        parameters.oddballTask.repeatsOfCycle = 40; % e.g. 8 x 40 = 320 trials
        parameters.oddballTask.nrOfStandardsPerCycle = 6; % 75% of the tones in other words
        
        parameters.oddballTask.targetFreq = 1000;
        parameters.oddballTask.distractFreq = [500 5000];
        parameters.oddballTask.standardFreq = 500;
        
        parameters.oddballTask.triggerDuration = 0.2; % [s]
        parameters.oddballTask.SOA_duration = 2.0; % [s], 
        parameters.oddballTask.ERP_duration = 0.9; % 0.50; % [s]
        parameters.oddballTask.ERP_baseline = 0.5; % [s], needed e.g. for ep_den
         
        % [s], for removing baseline
        parameters.oddballTask.ERP_baselineCorrection = -[parameters.oddballTask.ERP_baseline 0.1];
            % typically is the same as the baseline but you could make it
            % shorter like for example preceding 100 ms before the
            % stimulus, or the -500ms to -100ms to avoid possible
            % artifacting effect of anticipatory response such as CNV
        
        parameters.oddballTask.ERP_denoisingEP_epochLimits = [-0.5 0.5];
            % baseline and duration need to be same, and if we would use
            % the 0.9 needed for timeFrequency limits we might have more
            % epochs with artifacts 

            
            % DC Offset / Detrend correction (pre_epochToERPs --> )
            %{
            parameters.epochERP.detrendingLowCut = parameters.artifacts.fixedDetrendingLowCut;
            parameters.epochERP.detrendingHighCut = parameters.artifacts.fixedDetrendingHighCut;
            parameters.epochERP.detrendingOrder = 4;
            %}
            
            % Epoch baseline removel (remove the mean of the pre-stimulus
            % baseline period for example)            
            %parameters.oddballTask.baselineRemove_index1 = 1;
            %parameters.oddballTask.baselineRemove_index2 = 0 - (-parameters.oddballTask.ERP_baselineCorrection); % 500 ms

            % for pre-stimulus power analysis
            % see e.g. Barry et al. (2000), http://dx.doi.org/10.1016/S0167-8760(00)00114-8
            parameters.oddballTask.preERP_power_segmentLength = parameters.oddballTask.ERP_baseline; % [s]
            parameters.oddballTask.preERP_power_tukeyWindowR = parameters.powerAnalysis.tukeyWindowR;
            parameters.oddballTask.preERP_power_nOverlap = parameters.powerAnalysis.nOverlap;
            parameters.oddballTask.preERP_IAF_range = [-4 1.5]; % from Klimesch 1999, or more tight [-3.5 1.0]

        % Fixed time windows for the ERP components (see. Jongsma 2006,
        % 2013), http://dx.doi.org/10.1016/j.clinph.2006.05.012 and
        % http://dx.doi.org/10.1016/j.clinph.2012.09.009

            % -300 to 0 ms both in Jongsma 2006 and 2013
            parameters.oddballTask.timeWindows.CNV = [-0.3 0];
                    % [-110 -10] ms in Molnar et al. (2008), http://dx.doi.org/10.1111/j.1469-8986.2008.00648.x

            % 150 ms to 250 ms in Min 2013 (http://dx.doi.org/10.1016/j.brainres.2013.09.031)
            parameters.oddballTask.timeWindows.N1 = [0.150 0.250];            
                                    
            % 180 ms to 220 ms in Jongsma 2006, 180ms to 280 ms in Jongsma 2013
            parameters.oddballTask.timeWindows.N2 = [0.180 0.270]; 
                % 400 to 600 ms in Min 2013

            % 350 ms to 430 ms in Jongsma 2006, 280 to 480 ms in Jongsma 2013
            parameters.oddballTask.timeWindows.P3 = [0.280 0.480];

    %% EP_DEN Parameters
    
        % parameters.ep_den.sr = 512; % sampling rate
        % parameters.ep_den.stim = 513; % stim
        % parameters.ep_den.samples = 1024; % number of samples

        % Jongsma et al. denoised the epoch twice, first for extracting the CNV
        % with a different scale setting, and then second time for the
        % remaining components    
        parameters.ep_den.denoiseWithEP = 1;
        parameters.ep_den.scales_postStim = 8; % number of scales
        parameters.ep_den.scales_preStim = 10; % number of scales

        parameters.ep_den.plot_type ='coeff';  % 'coeff', 'bands', 'single', 'contour'
        parameters.ep_den.den_type = 'do_den'; %' do_den' or 'load_den_coeff' 
        parameters.ep_den.auto_den_type = 'NZT';  % 'Neigh' or 'NZT'

        
    %% PLOTTING
    
        handles.parameters.plot.ComponentAveragedSamples = 10; % for component trend plot
        handles.parameters.plot.timeFreq_contourLevels = 64;
        

    %% BATCH ANALYSIS
    
        % number of different intensities
        handles.parameters.batch.noOfIntensities = 3;
        handles.parameters.batch.noOfSessions = 4;
