 %% Analyse Glasgow Data 
 % first perform sanity check and check for general performance levels
data_path='D:\data\';
subjs={'L18_P01';'L18_P02';'L18_P03';'L18_P04';'L18_P05';'L18_P06';'L18_P07';'L18_P08';...
    'L18_P09';'L18_P10';'L18_P11';'L18_P12';'L18_P13';'L18_P14';'L18_P15';'L18_P16';...
    'L18_P17';'L18_P18';'L18_P19';'L18_P20';'L18_P21';'L18_P22'};
conditions={'*_A_*', '*_B_*', '*_C_*', '*_Sh_*'};
perm=1000;

figure;
for s = 1:length(subjs)
    s
    % load the data
    curr_data = tACSChallenge_SortData(data_path, subjs{s}, conditions);
    % and analyse it
    %[all_ps(:,s), all_bs(:,s), all_hit_probs(:,:,s),all_bs_perm(:,s,:),all_pfs(:,s)] = tACSChallenge_EvalData(curr_data,perm,s);
    for c=1:length(conditions)
        ntrls(s,c)=length(curr_data{c,1}(:,2));
        all_hits(s,c)=sum(curr_data{c,1}(:,2))/ntrls(s,c);
        
    end
end

figure;
bar(mean(all_hits,1));


hold on
plot([1 2 3 4],all_hits,'*');


%% Now test for entrainment

[all_ps,all_bs,all_hit_probs,all_bs_perm,all_pfs,group_level_p,group_level_comp,pf_p, all_hits] = tACSChallenge_AnalyseData(data_path, subjs, conditions, perm);