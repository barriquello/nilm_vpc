%% S-TRANSFORM VPC IMPLEMENTATION
% Vinicius Pozzobon Borin
% Federal University of Santa Maria

clear all;
close all;
clc;

Signature = 'P';

addpath('../libraries');

databaseV = dir('./V/');
databaseI = dir('./I/');

network_frequency = 60;
points_by_cycle = 128; %16,32,64,128
number_of_diff_loads = size(databaseV);

network_period = (1/network_frequency); 
sample_rate = points_by_cycle/network_period;

for ii=3:number_of_diff_loads(1) %start from 3 because the first two are useless 
 
        
     if (strcmp(Signature,'P'))

        list_load = dir([strcat('./V/',databaseV(ii).name), '\*.txt']);   %load all the files from the directory
        [f1 f2]=size(list_load);
        addpath(strcat('./V/',databaseV(ii).name,'/'));
        addpath(strcat('./I/',databaseI(ii).name,'/'));
        
        for jj=1:f1
                database_samples(jj).name = list_load(jj).name;  
                
                abrir = fopen(['./V/',databaseV(ii).name,'/',database_samples(jj).name],'r'); %open the appliance file
                dataV = fscanf(abrir, '%f');
                fclose(abrir);
                
                abrir = fopen(['./I/',databaseI(ii).name,'/',database_samples(jj).name],'r'); %open the appliance file
                dataI = fscanf(abrir, '%f');
                fclose(abrir);
                
                dataP(:,jj) = dataV.*dataI; 
                all_data(jj+30*(ii-3),1) = max(dataP)/rms (dataP); %CF
                all_data(jj+30*(ii-3),2) = rms(dataP)/mean(dataP); %FF
                                
                [st_matrix_distinct,st_times,st_frequencies] = st(dataP(:,jj),0,1000,1/sample_rate,10); %s-transform
                STx = st_matrix_distinct(2:end,:); %s-transform complex values
                
                for xxx=1:(128*23)
                    maxfreq(xxx) = max(abs(STx(:,xxx))); %find the maximum frequency of each column
                end 
                all_data(jj+30*(ii-3),3) = sum(maxfreq.*maxfreq)/(128*23); %MAX FREQUENCIES
             %   all_data(jj+30*(ii-3),3) = all_data(jj+30*(ii-3),3)./norm(all_data(jj+30*(ii-3),3));
                
                ST(:,jj) = abs(STx(:));
                
                
                if jj == 30
                    
                    dataPmean = mean(ST,2);
                    if ii == 3
                        figure;
                    end
                    h = scatter(all_data((30*(ii-3)+1):(jj+30*(ii-3)),1),all_data((30*(ii-3)+1):(jj+30*(ii-3)),2));
                    switch ii
                        case 3
                            set(h,'Marker','*','MarkerEdgeColor',[0 1 1]);
                        case 4
                            set(h,'Marker','v','MarkerEdgeColor',[0 1 1]);
                        case 5
                            set(h,'Marker','*','MarkerEdgeColor',[1 0 1]);
                        case 6
                            set(h,'Marker','v','MarkerEdgeColor',[1 0 1]);
                        case 7
                            set(h,'Marker','*','MarkerEdgeColor',[1 1 0]);
                        case 8
                            set(h,'Marker','v','MarkerEdgeColor',[1 1 0]);
                        case 9
                            set(h,'Marker','*','MarkerEdgeColor',[1 0 0]);
                        case 10
                            set(h,'Marker','v','MarkerEdgeColor',[1 0 0]);
                        case 11
                            set(h,'Marker','*','MarkerEdgeColor',[0 0 1]);
                        case 12
                            set(h,'Marker','v','MarkerEdgeColor',[0 0 1]);
                        case 13
                            set(h,'Marker','*','MarkerEdgeColor',[0 1 0]);
                        case 14
                            set(h,'Marker','v','MarkerEdgeColor',[0 1 0]);
                        case 15
                            set(h,'Marker','*','MarkerEdgeColor',[0.5 0.5 0.5]);
                        case 16
                            set(h,'Marker','v','MarkerEdgeColor',[0.5 0.5 0.5]);
                        case 17
                            set(h,'Marker','*','MarkerEdgeColor',[1 1 1]);
                        case 18
                            set(h,'Marker','v','MarkerEdgeColor',[1 1 1]');
                    end            
                    hold on;
                end
                
        end
        
     end
   
end

