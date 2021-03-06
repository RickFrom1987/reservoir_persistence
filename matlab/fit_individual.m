% data to fit

clc; clear;

data_individual() %loads up the data

dflag=0; %0=DNA 1=Hosmane

if dflag==0
    %DNA Reservoir parameters
    L0=1e9;
    data_array={WB_1,WB_7,WB_12,WL_1,WL_4,WL_12,WR_2,...
                WR_8,WR_12,M1_0,M1_5,M1_11,M2_13,M3_0,M3_7,M4_12,M5_14};
    fn={'WB-1','WB-7','WB-12','WL-1','WL-4','WL-12','WR-2',...
        'WR-8','WR-12','M1-0','M1-5','M1-11','M2-13','M3-0',...
        'M3-7','M4-12','M5-14'};
elseif dflag==1
    %Replication competent Reservoir parameters
    L0=1e7;
    data_array={S03,S06,S09,S10,S11}; %only good ones with N>20 [2,5,8,9,10]
    fn={'S03','S06','S09','S10','S11'};
end

best_params=zeros(length(data_array),2);

%% loop over data sets
for dd=1:length(data_array)

    data=-sort(-data_array{dd}); %make sure correctly ranked

    %calculate a few things with data
    data_pa  = data/sum(data);
    data_cpa = cumsum(data_pa);
    data_r   = 1:length(data);
    num_samples = sum(data); %number of experimental samplings

    % general model parameters
    num_param=50; num_R=50; num_fits=num_param*num_R;
    R=logspace(3,6,num_R); %richness range
    al=linspace(0.5,2,num_param); %alpha range
    
 
    %% the fitting loop
    ins=1; %score index
    score_mat=zeros([num_param,num_R]); %initialize score
    models=zeros([num_fits,3]); %initialize model list
    tic
    for j=1:num_R
        for i=1:num_param
            r=1:R(j); %ranks
            f_r=r.^(-al(i)); %pwl1
            rms_score=calcscore(f_r,data_pa,num_samples);
            score_mat(i,j)=rms_score;
            models(ins,:)=[rms_score al(i) R(j)];
            ins=ins+1;
        end
    %disp(j)
    end
    
    toc

    %% plot best fits
    filename=fn{dd};
    best_al(dd)=plotter(R,L0,al,score_mat,models,...
                                num_samples,data_r,data,data_cpa,filename);


end