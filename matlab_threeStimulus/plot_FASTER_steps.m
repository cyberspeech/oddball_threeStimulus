function [sp_i, sp] = plot_FASTER_steps(fig, sp, sp_i, leg, rows, cols, zs_st2, indelec_st3, zs_st3, num_pca, ...
            activData, blinkData, zs_st4, epochPerChannelIsArtifacted, epochPerChannelStep2Corrected, artifacts_CRAP, subplotIndices, parameters, handles)

    % STEP 2
    sp_i = sp_i + 1;
    sp(sp_i) = subplot(rows,cols, subplotIndices(1));

        hold on
        plot(zs_st2,'linewidth',1)

        % Thresholds
        plot(1:length(epochPerChannelStep2Corrected),parameters.artifacts.FASTER_zThreshold_step2*ones(1,length(epochPerChannelStep2Corrected)),'k-.','linewidth',2)
        plot(1:length(epochPerChannelStep2Corrected),-parameters.artifacts.FASTER_zThreshold_step2*ones(1,length(epochPerChannelStep2Corrected)),'k-.','linewidth',2)
        leg(2) = legend('mean dev. from ch.', 'Ep Var', 'Max \DeltaAmplitude', 'Location', 'Best');
        legend('boxoff')
        lab(1,1) = xlabel('Epochs');
        lab(1,2) = ylabel(['Z-score (thr = ', num2str(parameters.artifacts.FASTER_zThreshold_step2), ')']);
        tit(1) = title('STEP 2: EPOCHS');
        grid off
        axis tight
        drawnow

    % STEP 3
    %{
    sp_i = sp_i + 1;
    sp(sp_i) = subplot(rows,cols, subplotIndices(2));

        plot(activData, blinkData, 'ko', 'MarkerSize', 2)
        xlabel('ICA Activation')
        ylabel('EOG channel ("blinks")')            
        tit(1) = title('STEP 3: Corrcoef()')
        grid off
        axis square
    %}

    sp_i = sp_i + 1;
    sp(sp_i) = subplot(rows,cols, subplotIndices(2));       

        if ~isnan(num_pca)
            x = linspace(1,num_pca,num_pca);

            hold on
            if size(zs_st3,3) > 1
                for ica = 1 : size(zs_st3,1)
                    y = squeeze(zs_st3(ica,:,:));                
                    plot(x,y,'o')
                end
            else
                plot(x,zs_st3,'o')
            end

            % Thresholds
            plot(1:length(indelec_st3),parameters.artifacts.FASTER_zThreshold_step3*ones(1,length(indelec_st3)),'k-.','linewidth',2)
            plot(1:length(indelec_st3),-parameters.artifacts.FASTER_zThreshold_step3*ones(1,length(indelec_st3)),'k-.','linewidth',2)
            leg(3) = legend('Median gradient', 'Mean slope', 'Kurtosis', 'Hurst', 'Blink', 'Location', 'Best');
            legend('boxoff')
            lab(2,1) = xlabel('ICA components');
            lab(2,2) = ylabel(['Z-score (thr = ', num2str(parameters.artifacts.FASTER_zThreshold_step3), ')']);
            
            if parameters.artifacts.FASTER_skipICA == 0
                titStr = 'Step 3: ICA';
            elseif parameters.artifacts.FASTER_regressEOG_asStep3 == 1
                titStr = 'Step 3: regressEOG';
            else
                titStr = 'Step 3: ICA and regressEOG skipped';
            end
                
            tit(2) = title(titStr);
            grid off
            axis tight
            set(gca, 'XTick', x, 'XLim', [min(x)-0.5 max(x)+0.5])      
        else
            plot(0, 0)                
            leg(3) = legend('nothing plotted');                    
                legend('hide')                    
                axis off
                tit(2) = title('STEP 3: ICA');
                lab(2,1) = xlabel(' ');
                lab(2,2) = ylabel([' ']);
        end
        drawnow


    % STEP 4: SINGLE-CHANNEL, SINGLE-EPOCH ARTIFACTS    
    sp_i = sp_i + 1;
    sp(sp_i) = subplot(rows,cols, subplotIndices(3));

        hold on
        plot(zs_st4,'linewidth',1)

        % Thresholds
        plot(1:length(epochPerChannelStep2Corrected),parameters.artifacts.FASTER_zThreshold_step4*ones(1,length(epochPerChannelStep2Corrected)), 'k-.', 'linewidth', 2)
        plot(1:length(epochPerChannelStep2Corrected),-parameters.artifacts.FASTER_zThreshold_step4*ones(1,length(epochPerChannelStep2Corrected)), 'k-.', 'linewidth', 2)
        leg(4) = legend('Variance', 'Median slope', 'Ampl. range', 'Electr. Drift', 'Location', 'Best');        
            if isnan(num_pca)
                set(leg(4), 'Position',[0.584376133152028 0.52722931680673 0.0704887218045113 0.0659294512877939])
                legend('boxoff')
            end
        lab(3,1) = xlabel('Epochs');
        lab(3,2) = ylabel(['Z-score (thr = ', num2str(parameters.artifacts.FASTER_zThreshold_step4), ')']);
        tit(3) = title('STEP 4: SINGLE-Ch, SINGLE-Ep (abs mean of chs)');
        grid off
        % axis tight
        xlim([1 length(zs_st4)])
        drawnow

    % CONCLUSION
    sp_i = sp_i + 1;
    sp(sp_i) = subplot(rows,cols, subplotIndices(4));

        hold on        
        step2 = 0.5*sum(epochPerChannelStep2Corrected,2);
        step4 = sum(epochPerChannelIsArtifacted,2)/parameters.EEG.nrOfChannels;
        CRAP = sum(artifacts_CRAP,2)/parameters.EEG.nrOfChannels;        
        allArtifacts = (step2 + step4 + CRAP) / 3;
        noOfAll = sum(allArtifacts);
        
        
        b(1) = bar(step2, 0.5, 'b', 'EdgeColor', 'none');
        b(2) = bar(step4, 0.5,'r', 'EdgeColor', 'none');
        b(3) = bar(allArtifacts, 0.5, 'k', 'EdgeColor', 'none');

        hold off

        % change alpha of bars (transparency)
        alpha = .75;
        ch = get(b(1),'child');
            set(ch,'facea',alpha)
        alpha = .55;
        ch = get(b(2),'child');
            set(ch,'facea',alpha)

            lab(4,1) = xlabel('Epochs');
            lab(4,2) = ylabel('Artifact (ON/OFF)');
            tit(4) = title('FASTER Artifacts');
            set(gca, 'XLim', [1-0.5 length(epochPerChannelStep2Corrected)+0.5], 'YLim', [0 1.2]) 

            leg(5) = legend(['Step2, n=', num2str(sum(epochPerChannelStep2Corrected == 1), '%3.0f')],...
                            ['Step4, n=', num2str(sum(sum(epochPerChannelIsArtifacted))/parameters.EEG.nrOfChannels, '%3.2f')], ...
                            ['All, n=', num2str(noOfAll, '%3.2f')]);    
                set(leg(5), 'Position', [0.657424812030075 0.26553751399776 0.0736215538847118 0.0354143337066069])
                legend('boxoff')

            ch = get(b(1),'child');
                uistack(ch, 'top')
        drawnow

    % STEP 5: GRAND AVERAGE (skip)
    %sp(5) = subplot(rows,cols, subplotIndices(4));
    
    set(leg, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-2) 
    set(sp, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-1) 
    set(tit, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-1, 'FontWeight', 'bold') 
    set(lab, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-2, 'FontWeight', 'bold') 



