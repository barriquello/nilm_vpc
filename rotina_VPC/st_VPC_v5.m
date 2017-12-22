%% S-TRANSFORM VPC IMPLEMENTATION
% Vinicius Pozzobon Borin
% Federal University of Santa Maria

clear all;
close all;
clc;

Signature = 'P';

VPC_cont = 1;
for number_of_network_cycles=8:8
for k=0.8:0.05:0.8
file_flag = 1;    
    
for num_program_times=1:5

random_loads = randperm(30,30);   

for number_of_signatures=1:2
    
clearvars -except k VPC num_program_times number_of_signatures Signature ...
    VPC_cont random_loads file_flag number_of_network_cycles;
%clear all;
clc;

addpath('./libraries');
addpath('./RandomLoadsDatabase');
rehash();

%% VARIABLES 'THAT THE USER CAN CHANGE:
% number_of_network_cycles = 11; %FROM 2 TO 23
points_by_cycle = 128; %16,32,64,128
network_frequency = 60;
Li_fill = 1;
number_of_training_samples = 10; %FROM 1 TO 29

save_results_in_file = 0;

%% DELETE FILES FROM FOLDER

RandomLoadsDatabase = dir('./RandomLoadsDatabase/');

list = dir(['RandomLoadsDatabase', '\*.txt']); 
for rm=1:size(list)
  delete(strcat('./RandomLoadsDatabase/',list(rm).name));    
end
rehash();

%empty_folder = length([RandomLoadsDatabase(:).name]');
% if (empty_folder>3)
%   %list_bad_dir = dir('RandomLoadsDatabase/*.txt');
%   
%   list = dir(['RandomLoadsDatabase', '\*.txt']); 
%   for rm=1:size(list)
%    delete(strcat('./RandomLoadsDatabase/',list(rm).name));    
%   end
%   list = dir(['RandomLoadsDatabase', '\*.txt']); 
%   pause(10);
%   for rm=1:size(list)
%    delete(strcat('./RandomLoadsDatabase/',list(rm).name));    
%   end
%   pause(10);
%   rmdir('./RandomLoadsDatabase');
%   rehash();
% end
% if isequal(exist('RandomLoadsDatabase','dir'),7) % 2 means it's a folder. 
%       addpath('./RandomLoadsDatabase');
% else
%       mkdir('RandomLoadsDatabase'); %se não existir o arquivo, cria
%       rehash();
%       addpath('./RandomLoadsDatabase');
% end

%% INCLUDE DATABASE FOLDER AND FORM THE DATABASE


databaseV = dir('./database/V/');
databaseI = dir('./database/I/');




number_of_diff_loads = size(databaseV);
kk = 1;
new_load_number = 1;
for ii=3:number_of_diff_loads(1) %start from 3 because the first two are useless 

        
     if (strcmp(Signature,'P'))

        list_load = dir([strcat('./database/V/',databaseV(ii).name), '\*.txt']);   %load all the files from the directory
        [f1 f2]=size(list_load);
        addpath(strcat('./database/V/',databaseV(ii).name,'/'));
        addpath(strcat('./database/I/',databaseI(ii).name,'/'));
        
        for jj=1:f1
                database_samples(kk).name = list_load(random_loads(jj)).name;  
                
                abrir = fopen(['./database/V/',databaseV(ii).name,'/',database_samples(kk).name],'r'); %open the appliance file
                dataV = fscanf(abrir, '%f');
                fclose(abrir);
                
                abrir = fopen(['./database/I/',databaseI(ii).name,'/',database_samples(kk).name],'r'); %open the appliance file
                dataI = fscanf(abrir, '%f');
                fclose(abrir);
                
                dataP = dataV.*dataI; 
                
            if jj<(number_of_training_samples+1)                    
                copyfile(strcat('./database/V/',databaseV(ii).name,'/',database_samples(kk).name),'./RandomLoadsDatabase/');            
                abrir = fopen(['RandomLoadsDatabase/',database_samples(kk).name],'wt'); %open the appliance file
                fprintf(abrir, '%f\n',dataP);
                fclose(abrir);  %close appliance data file
            else
                database_samples(kk).name = strcat('new',list_load(random_loads(jj)).name);
                copyfile(strcat('./database/V/',databaseV(ii).name,'/',list_load(random_loads(jj)).name),'./RandomLoadsDatabase/');
                movefile(strcat('./RandomLoadsDatabase/',list_load(random_loads(jj)).name),...
                    strcat('./RandomLoadsDatabase/new',list_load(random_loads(jj)).name));
                
                abrir = fopen(['RandomLoadsDatabase/',database_samples(kk).name],'wt'); %open the appliance file
                fprintf(abrir, '%f\n',dataP);
                fclose(abrir);  %close appliance data file
                
                new_load_number  = new_load_number + 1;
            end
            kk = kk + 1;  
        end
     else
         
        list_load = dir([strcat('./database/I/',databaseI(ii).name), '\*.txt']);   %load all the files from the directory
        [f1 f2]=size(list_load);
        addpath(strcat('./database/I/',databaseI(ii).name,'/'));
        
        for jj=1:f1
            if jj<(number_of_training_samples+1)
                database_samples(kk).name = list_load(random_loads(jj)).name;  
                copyfile(strcat('./database/I/',databaseI(ii).name,'/',database_samples(kk).name),'./RandomLoadsDatabase/');            
            else
                database_samples(kk).name = strcat('new',list_load(random_loads(jj)).name);
                copyfile(strcat('./database/I/',databaseI(ii).name,'/',list_load(random_loads(jj)).name),'./RandomLoadsDatabase/');
                movefile(strcat('./RandomLoadsDatabase/',list_load(random_loads(jj)).name),...
                    strcat('./RandomLoadsDatabase/new',list_load(random_loads(jj)).name));
                new_load_number  = new_load_number + 1;
            end
            kk = kk + 1;  
        end   
         
     end
     
  

     
%     if (ii==10)
%         database_samples(kk).name = list_load(random_loads(11)).name; %load to be identified
%         copyfile(strcat('./database/',database(ii).name,'/',database_samples(kk).name),'./RandomLoadsDatabase/');
%         movefile(strcat('./RandomLoadsDatabase/',database_samples(kk).name),'./RandomLoadsDatabase/new.txt')
%         kk = kk + 1;
%     end
    
end
    
%% BEGIN

list = dir(['RandomLoadsDatabase', '\*.txt']);   %load all the files from the directory
network_period = (1/network_frequency); 

VPC(VPC_cont).hits = 0;
sample_rate = points_by_cycle/network_period;
total_of_samples = ceil(points_by_cycle * number_of_network_cycles);

%% PREALLOCATE THE APPLIANCES VARIABLE FOR SPEED AND MEMORY OPTIMIZATION
% for ii=1:2
%     varname=['X',num2str(ii)];
%     assignin('caller',varname,zeros(640,1));
%     
% end

% appliances = struct('data',{X1,X2},'stran',{zeros(321,640)},...
%     'abs',{zeros(321,640)},'times',{zeros(1,640)},...
%     'frequencies',{zeros(1,321)});

aa = 1;
bb = 1;
cc = 1;

for ii=1:size(list) 
  
    mostrar = sprintf('\n k = %.2f/%d cycles/%s Signature/VPC %d: Working on appliance %d/%d \n\n',k,number_of_network_cycles-1,...
        Signature,num_program_times,ii,kk-1);
    disp(mostrar);
    
    
  if (strncmpi(list(ii).name,'new',3) == 0)  
      
      appliances(aa).name = list(ii).name; %takes the appliances names
   %  appliances(aa).name = strrep(appliances(aa).name,'_',' '); %takes the appliances names
      abrir = fopen(['RandomLoadsDatabase/',list(ii).name],'r'); %open the appliance file
      data = fscanf(abrir, '%f');
      
%       [B,A] = butter(2,960/3840); %butter(order,cutoff_freq/(sample_freq/2))
%       filtro = filtfilt(B,A,data);
%       data = filtro;
      
   %  appliances(aa).data =  data(((sample_rate*network_period)/4+1):total_of_samples-(sample_rate*network_period)*3/4); %load appliance data point to a variable
      appliances(aa).data = data(1:total_of_samples);
   %   appliances(aa).data = data(points_by_cycle*5+1:total_of_samples);
      appliances(aa).data = appliances(aa).data(((sample_rate*network_period)/4+1):...
         total_of_samples-(sample_rate*network_period)*3/4);
   %   appliances(aa).data = cast(appliances(aa).data,'single');
      fclose(abrir);  %close appliance data file

      %appliances(ii).norm = (appliances(ii).data / mean(appliances(ii).data)); %means normalization
      %appliances(ii).norm = (appliances(ii).data - min(appliances(ii).data)) /(max(appliances(ii).data) - min(appliances(ii).data)); %0 e 1 normalization
      %appliances(ii).norm = 10*(appliances(ii).data - mean(appliances(ii).data))/(total_of_samples); %normalization being used
      
      [r,harmpow,harmfreq] = thd(appliances(aa).data,sample_rate,17);
      appliances(aa).THD_Harmonics = db2mag(harmpow);
      %appliances(aa).THD_Total = sqrt(sum(appliances(aa).THD_Harmonics(2:end).^2))/appliances(aa).THD_Harmonics(1);
      appliances(aa).THD_Total = db2mag(r);
      appliances(aa).Frequencies = harmfreq;
      
      appliancesRMS(aa) = rms(appliances(aa).data);
      appliancesTHD(aa) = appliances(aa).THD_Total;
        
      mff = size(appliances(aa).data);
      if (Li_fill == 1) || (Li_fill == 2) || (Li_fill == 3) || (Li_fill == 4) || (Li_fill == 5)
          %[st_matrix_distinct,st_times,st_frequencies] = st(appliances(aa).data,0,mff(1)/8,1/sample_rate,2);
          tic;
          [st_matrix_distinct,st_times,st_frequencies] = st(appliances(aa).data,0,1000,1/sample_rate,10); %s-transform
          toc;
          appliances(aa).stran   = st_matrix_distinct(2:end,:); %s-transform complex values
          appliances(aa).abs     = abs(appliances(aa).stran);  %absolute value of s-transform
          appliances(aa).stran   = cast(appliances(aa).stran,'uint32');
          appliances(aa).stran   = [];
          
      end
      
   %   appliances(aa).times         = st_times; %time values of s-transform
   %   appliances(aa).frequencies   = st_frequencies(:,1:end); %frequencies values of s-transform
      

      switch Li_fill
          case 1
            Li = appliances(aa).abs(:);
          case 2
            appliances(aa).half_abs    = appliances(aa).abs(1:128/2,:);
            Li = appliances(aa).half_abs(:);
          case 3
            appliances(aa).quarter_abs = appliances(aa).abs(1:128/4,:);
            Li = appliances(aa).quarter_abs(:);
          case 4
            Li = appliances(aa).quarter_n_from6_abs(:);
          case 5
            Li = appliances(aa).abs_DOST(:);
          case 6 
            Li = appliances(aa).data(:);
      end
      
      if (Li_fill == 1) || (Li_fill == 2) || (Li_fill == 3) || (Li_fill == 4) || (Li_fill == 5)
        appliances(aa).abs   = cast(appliances(aa).abs,'uint32');
        appliances(aa).abs   = [];
      end
 
      group_letter = appliances(aa).name(1:end-6);
      switch group_letter
           case 'AirConditioning'
             database_groups(cc).AirConditioning = Li;
             Vi.AirConditioning(:,cc)            = abs(database_groups(cc).AirConditioning(:));
             database_groups(cc).AirConditioning(:) = [];
             Vi.AirConditioning(:,cc)            = Vi.AirConditioning(:,cc)./norm(Vi.AirConditioning(:,cc));
             
             mean_Vi_VPC.AirConditioning         = mean(Vi.AirConditioning,2);
          case 'AirFryer'
            database_groups(cc).AirFryer = Li;
            Vi.AirFryer(:,cc)            = abs(database_groups(cc).AirFryer(:));
            database_groups(cc).AirFryer(:) = [];
            Vi.AirFryer(:,cc)            = Vi.AirFryer(:,cc)./norm(Vi.AirFryer(:,cc));
            
            mean_Vi_VPC.AirFryer         = mean(Vi.AirFryer,2);
          case 'Blender'
            database_groups(cc).Blender = Li;
            Vi.Blender(:,cc)            = abs(database_groups(cc).Blender(:));
            database_groups(cc).Blender(:) = [];
            Vi.Blender(:,cc)            = Vi.Blender(:,cc)./norm(Vi.Blender(:,cc));
            
            mean_Vi_VPC.Blender                        = mean(Vi.Blender,2);
          case 'FluorescentLamp_OSRAM'
            database_groups(cc).FluorescentLamp_OSRAM = Li;
            Vi.FluorescentLamp_OSRAM(:,cc)            = abs(database_groups(cc).FluorescentLamp_OSRAM(:));
            database_groups(cc).FluorescentLamp_OSRAM(:) = [];
            Vi.FluorescentLamp_OSRAM(:,cc)            = Vi.FluorescentLamp_OSRAM(:,cc)./norm(Vi.FluorescentLamp_OSRAM(:,cc));
            
            mean_Vi_VPC.FluorescentLamp_OSRAM  = mean(Vi.FluorescentLamp_OSRAM,2);
%           case 'FluorescentLamp_EMPALUX'
%             database_groups(cc).FluorescentLamp_EMPALUX = Li;
%             Vi.FluorescentLamp_EMPALUX(:,cc)            = abs(database_groups(cc).FluorescentLamp_EMPALUX(:));
%             database_groups(cc).FluorescentLamp_EMPALUX(:) = [];
%             Vi.FluorescentLamp_EMPALUX(:,cc)            = Vi.FluorescentLamp_EMPALUX(:,cc)./norm(Vi.FluorescentLamp_EMPALUX(:,cc));
%             
%             mean_Vi_VPC.FluorescentLamp_EMPALUX = mean(Vi.FluorescentLamp_EMPALUX,2);
          case 'DVDPlayer'
            database_groups(cc).DVDPlayer = Li;
            Vi.DVDPlayer(:,cc)            = abs(database_groups(cc).DVDPlayer(:));
            database_groups(cc).DVDPlayer(:) = [];
            Vi.DVDPlayer(:,cc)            = Vi.DVDPlayer(:,cc)./norm(Vi.DVDPlayer(:,cc));
            
            mean_Vi_VPC.DVDPlayer                      = mean(Vi.DVDPlayer,2);
%           case 'ElectronicSolder'
%             database_groups(cc).ElectronicSolder = Li;
%             Vi.ElectronicSolder(:,cc)            = abs(database_groups(cc).ElectronicSolder(:));
%             database_groups(cc).ElectronicSolder(:) = [];
%             Vi.ElectronicSolder(:,cc)            = Vi.ElectronicSolder(:,cc)./norm(Vi.ElectronicSolder(:,cc));
%             
%             mean_Vi_VPC.ElectronicSolder               = mean(Vi.ElectronicSolder,2);
          case 'Fan'
            database_groups(cc).Fan = Li;
            Vi.Fan(:,cc)            = abs(database_groups(cc).Fan(:));
            database_groups(cc).Fan(:) = [];
            Vi.Fan(:,cc)            = Vi.Fan(:,cc)./norm(Vi.Fan(:,cc));
            
            mean_Vi_VPC.Fan                            = mean(Vi.Fan,2);
          case 'Heater'
            database_groups(cc).Heater = Li;
            Vi.Heater(:,cc)            = abs(database_groups(cc).Heater(:));
            database_groups(cc).Heater(:) = [];
            Vi.Heater(:,cc)            = Vi.Heater(:,cc)./norm(Vi.Heater(:,cc));
            
            mean_Vi_VPC.Heater                         = mean(Vi.Heater,2);
          case 'IncandescentLamp'
            database_groups(cc).IncandescentLamp = Li;
            Vi.IncandescentLamp(:,cc)            = abs(database_groups(cc).IncandescentLamp(:));
            database_groups(cc).IncandescentLamp(:) = [];
            Vi.IncandescentLamp(:,cc)            = Vi.IncandescentLamp(:,cc)./norm(Vi.IncandescentLamp(:,cc));
            
            mean_Vi_VPC.IncandescentLamp               = mean(Vi.IncandescentLamp,2);
          case 'Laptop'
            database_groups(cc).Laptop = Li;
            Vi.Laptop(:,cc)            = abs(database_groups(cc).Laptop(:));
            database_groups(cc).Laptop(:) = [];
            Vi.Laptop(:,cc)            = Vi.Laptop(:,cc)./norm(Vi.Laptop(:,cc));
            
            mean_Vi_VPC.Laptop                         = mean(Vi.Laptop,2);
          case 'Microwaves'
            database_groups(cc).Microwaves = Li;
            Vi.Microwaves(:,cc)            = abs(database_groups(cc).Microwaves(:));
            database_groups(cc).Microwaves(:) = [];
            Vi.Microwaves(:,cc)            = Vi.Microwaves(:,cc)./norm(Vi.Microwaves(:,cc));
            
            mean_Vi_VPC.Microwaves                     = mean(Vi.Microwaves,2);
          case 'Mixer'
            database_groups(cc).Mixer = Li;
            Vi.Mixer(:,cc)            = abs(database_groups(cc).Mixer(:));
            database_groups(cc).Mixer(:) = [];
            Vi.Mixer(:,cc)            = Vi.Mixer(:,cc)./norm(Vi.Mixer(:,cc));
            
            mean_Vi_VPC.Mixer                          = mean(Vi.Mixer,2);
          case 'MonitorLCD'
            database_groups(cc).MonitorLCD = Li;
            Vi.MonitorLCD(:,cc)            = abs(database_groups(cc).MonitorLCD(:));
            database_groups(cc).MonitorLCD(:) = [];
            Vi.MonitorLCD(:,cc)            = Vi.MonitorLCD(:,cc)./norm(Vi.MonitorLCD(:,cc));
            
            mean_Vi_VPC.MonitorLCD                     = mean(Vi.MonitorLCD,2);
          case 'MonitorLED'
            database_groups(cc).MonitorLED = Li;
            Vi.MonitorLED(:,cc)            = abs(database_groups(cc).MonitorLED(:));
            database_groups(cc).MonitorLED(:) = [];
            Vi.MonitorLED(:,cc)            = Vi.MonitorLED(:,cc)./norm(Vi.MonitorLED(:,cc));
            
            mean_Vi_VPC.MonitorLED         = mean(Vi.MonitorLED,2);
          case 'PS4'
            database_groups(cc).PS4 = Li;
            Vi.PS4(:,cc)            = abs(database_groups(cc).PS4(:));
            database_groups(cc).PS4(:) = [];
            Vi.PS4(:,cc)            = Vi.PS4(:,cc)./norm(Vi.PS4(:,cc));
            
            mean_Vi_VPC.PS4         = mean(Vi.PS4,2);
          case 'Projector'
            database_groups(cc).Projector = Li;
            Vi.Projector(:,cc)            = abs(database_groups(cc).Projector(:));
            database_groups(cc).Projector(:) = [];
            Vi.Projector(:,cc)            = Vi.Projector(:,cc)./norm(Vi.Projector(:,cc));
            
            mean_Vi_VPC.Projector         = mean(Vi.Projector,2);
          case 'Solder' 
            database_groups(cc).Solder = Li;
            Vi.Solder(:,cc)            = abs(database_groups(cc).Solder(:));
            database_groups(cc).Solder(:) = [];
            Vi.Solder(:,cc)            = Vi.Solder(:,cc)./norm(Vi.Solder(:,cc));
            
            mean_Vi_VPC.Solder         = mean(Vi.Solder,2);
          case 'VacuumCleaner'
            database_groups(cc).VacuumCleaner = Li;
            Vi.VacuumCleaner(:,cc)            = abs(database_groups(cc).VacuumCleaner(:));
            database_groups(cc).VacuumCleaner(:) = [];
            Vi.VacuumCleaner(:,cc)            = Vi.VacuumCleaner(:,cc)./norm(Vi.VacuumCleaner(:,cc));
            
            mean_Vi_VPC.VacuumCleaner         = mean(Vi.VacuumCleaner,2);
              
              
      end
      
      Li   = cast(Li,'uint32');
      Li = [];
      
      aa = aa + 1;
      
      if cc == number_of_training_samples
          cc = 0;
      end
      cc =  cc + 1;
            
  else
%% Variance Calculation

% for gg=0:18
%     for ss=1:10 
%         A(:,ss) = appliances(ss+(gg*10)).data;
%     end
%         variance_matrix(gg+1,1).name = appliances(gg*10+1).name;
%         variance_matrix(gg+1,1).var = var(A(:));
% end
% vartestn(variance_matrix);
% variance(:) = var(appliances(:).data);

      
%% Algorithm Continued     
      if bb == 1
        clear appliances database_samples database_groups st_matrix_distinct;
        
%         appliancesRMS = appliancesRMS';
%         gg = 1;
%         for ss=1:10:((number_of_diff_loads(1)-2)*10) 
%             AppliancesMeanRMS(gg) = mean(appliancesRMS(ss:(gg*10)));
%             gg = gg + 1;
%         end
%         AppliancesMeanRMS = AppliancesMeanRMS';
%         
%         appliancesTHD = appliancesTHD';
%         gg = 1;
%         for ss=1:10:((number_of_diff_loads(1)-2)*10) 
%             AppliancesMeanTHD(gg) = mean(appliancesTHD(ss:(gg*10)));
%             gg = gg + 1;
%         end
%         AppliancesMeanTHD = AppliancesMeanTHD';
        
        Vi.AirConditioning = cast(Vi.AirConditioning,'single');
        Vi.AirFryer = cast(Vi.AirFryer,'single');
        Vi.Blender = cast(Vi.Blender,'single');
        Vi.FluorescentLamp_OSRAM = cast(Vi.FluorescentLamp_OSRAM,'single');
   %    Vi.FluorescentLamp_EMPALUX = cast(Vi.FluorescentLamp_EMPALUX,'single');
        Vi.DVDPlayer = cast(Vi.DVDPlayer,'single');
  %     Vi.ElectronicSolder = cast(Vi.ElectronicSolder,'single');
        Vi.Fan = cast(Vi.Fan,'single');
        Vi.Heater = cast(Vi.Heater,'single');
        Vi.IncandescentLamp = cast(Vi.IncandescentLamp,'single');
        Vi.Laptop = cast(Vi.Laptop,'single');
        Vi.Microwaves = cast(Vi.Microwaves,'single');
        Vi.Mixer = cast(Vi.Mixer,'single');
        Vi.MonitorLCD = cast(Vi.MonitorLCD,'single');
        Vi.MonitorLED = cast(Vi.MonitorLED,'single');
        Vi.Projector = cast(Vi.Projector,'single');
        Vi.PS4 = cast(Vi.PS4,'single');
   %    Vi.Solder = cast(Vi.Solder,'single');
        Vi.VacuumCleaner = cast(Vi.VacuumCleaner,'single');
        
      end
      
      abrir = fopen(['RandomLoadsDatabase/',list(ii).name],'r'); %open the appliance file
      data = fscanf(abrir, '%f');
      appliances_new(bb).name = list(ii).name(1:end-6);
      appliances_new(bb).name = strrep(appliances_new(bb).name,'new','');
      appliances_new(bb).identified  = [];
     % appliances_new(bb).data = data(((sample_rate*network_period)/4+1):total_of_samples-(sample_rate*network_period)*3/4);
      appliances_new(bb).data = data(1:total_of_samples);
      appliances_new(bb).data = appliances_new(bb).data(((sample_rate*network_period)/4+1):...
         total_of_samples-(sample_rate*network_period)*3/4);
     % appliances_new(bb).data = data(points_by_cycle*5+1:total_of_samples);
      fclose(abrir);
      
      [r,harmpow,harmfreq] = thd(appliances_new(bb).data,sample_rate,17);
      appliances_new(bb).THD_Harmonics = db2mag(harmpow);
      %appliances(aa).THD_Total = sqrt(sum(appliances(aa).THD_Harmonics(2:end).^2))/appliances(aa).THD_Harmonics(1);
      appliances_new(bb).THD = db2mag(r);
      appliances_new(bb).Frequencies = harmfreq;
      
     appliances_new(bb).rms = rms(appliances_new(bb).data);
      
      if (Li_fill == 1) || (Li_fill == 2) || (Li_fill == 3) || (Li_fill == 4) || (Li_fill == 5)
          [st_matrix_distinct,st_times,st_frequencies] = st(appliances_new(bb).data,0,1000,1/sample_rate,10);
          appliances_new(bb).stran    = st_matrix_distinct(2:end,:); %s-transform complex values
          appliances_new(bb).abs      = abs(appliances_new(bb).stran);  %absolute value of s-transform
          appliances_new(bb).stran    = cast(appliances_new(bb).stran,'uint32');
          appliances_new(bb).stran    = [];
      end
     
  %    appliances_new(bb).times         = st_times; %time values of s-transform
 %     appliances_new(bb).frequencies   = st_frequencies(:,1:end); %frequencies values of s-transform
      
      switch Li_fill
          case 1
            Li_newload = appliances_new(bb).abs(:);
          case 2
            Li_newload = appliances_new(bb).abs(1:128/2,:);
          %  Li_newload = appliances_new(bb).half_abs(:);
          case 3
             Li_newload = appliances_new(bb).abs(1:128/4,:);
            %Li_newload = appliances_new(bb).quarter_abs(:);
          case 4
            Li_newload = appliances_new(bb).quarter_n_from6_abs(:);
          case 5
            Li_newload = appliances_new(bb).abs_DOST(:);
          case 6 
            Li_newload = appliances_new(bb).data(:);
      end
      
      if (Li_fill == 1) || (Li_fill == 2) || (Li_fill == 3) || (Li_fill == 4) || (Li_fill == 5)
        appliances_new(bb).abs(:)   = cast(appliances_new(bb).abs(:),'uint32');
        appliances_new(bb).abs(:) = [];
      end
      
      y_newload  = Li_newload ./ norm(Li_newload);
      y_newload  = cast(y_newload,'single');
      
      Li_newload = cast(Li_newload,'uint32');
      Li_newload = [];
 
%% VPC               
     Projection.AirConditioning                = k*(y_newload(:)'*Vi.AirConditioning)+(1-k)*(y_newload(:)'*mean_Vi_VPC.AirConditioning);
     Projection.AirFryer                       = k*(y_newload(:)'*Vi.AirFryer)+(1-k)*(y_newload(:)'*mean_Vi_VPC.AirFryer);
      Projection.Blender                        = k*(y_newload(:)'*Vi.Blender)+(1-k)*(y_newload(:)'*mean_Vi_VPC.Blender);
      Projection.FluorescentLamp_OSRAM          = k*(y_newload(:)'*Vi.FluorescentLamp_OSRAM)+(1-k)*(y_newload(:)'*mean_Vi_VPC.FluorescentLamp_OSRAM);
  % Projection.FluorescentLamp_EMPALUX        = k*(y_newload(:)'*Vi.FluorescentLamp_EMPALUX)+(1-k)*(y_newload(:)'*mean_Vi_VPC.FluorescentLamp_EMPALUX);
      Projection.DVDPlayer                      = k*(y_newload(:)'*Vi.DVDPlayer)+(1-k)*(y_newload(:)'*mean_Vi_VPC.DVDPlayer);
  % Projection.ElectronicSolder               = k*(y_newload(:)'*Vi.ElectronicSolder)+(1-k)*(y_newload(:)'*mean_Vi_VPC.ElectronicSolder);
    Projection.Fan                            = k*(y_newload(:)'*Vi.Fan)+(1-k)*(y_newload(:)'*mean_Vi_VPC.Fan);
    Projection.Heater                         = k*(y_newload(:)'*Vi.Heater)+(1-k)*(y_newload(:)'*mean_Vi_VPC.Heater);
    Projection.IncandescentLamp               = k*(y_newload(:)'*Vi.IncandescentLamp)+(1-k)*(y_newload(:)'*mean_Vi_VPC.IncandescentLamp);
     Projection.Laptop                         = k*(y_newload(:)'*Vi.Laptop)+(1-k)*(y_newload(:)'*mean_Vi_VPC.Laptop);
     Projection.Microwaves                     = k*(y_newload(:)'*Vi.Microwaves)+(1-k)*(y_newload(:)'*mean_Vi_VPC.Microwaves);
     Projection.Mixer                          = k*(y_newload(:)'*Vi.Mixer)+(1-k)*(y_newload(:)'*mean_Vi_VPC.Mixer);
     Projection.MonitorLCD                     = k*(y_newload(:)'*Vi.MonitorLCD)+(1-k)*(y_newload(:)'*mean_Vi_VPC.MonitorLCD);
     Projection.MonitorLED                     = k*(y_newload(:)'*Vi.MonitorLED)+(1-k)*(y_newload(:)'*mean_Vi_VPC.MonitorLED);
     Projection.PS4                            = k*(y_newload(:)'*Vi.PS4)+(1-k)*(y_newload(:)'*mean_Vi_VPC.PS4);
    Projection.Projector                      = k*(y_newload(:)'*Vi.Projector)+(1-k)*(y_newload(:)'*mean_Vi_VPC.Projector);
  %  Projection.Solder                         = k*(y_newload(:)'*Vi.Solder)+(1-k)*(y_newload(:)'*mean_Vi_VPC.Solder);
     Projection.VacuumCleaner                  = k*(y_newload(:)'*Vi.VacuumCleaner)+(1-k)*(y_newload(:)'*mean_Vi_VPC.VacuumCleaner);

     VPC(VPC_cont).results(1,bb)  = max(Projection.AirConditioning);
     VPC(VPC_cont).results(2,bb)  = max(Projection.AirFryer);
     VPC(VPC_cont).results(3,bb)  = max(Projection.Blender);
     VPC(VPC_cont).results(4,bb)  = max(Projection.FluorescentLamp_OSRAM);
 %  VPC(VPC_cont).results(5,bb)  = max(Projection.FluorescentLamp_EMPALUX);
     VPC(VPC_cont).results(5,bb)  = max(Projection.DVDPlayer);
 %  VPC(VPC_cont).results(6,bb)  = max(Projection.ElectronicSolder);
     VPC(VPC_cont).results(6,bb)  = max(Projection.Fan);
     VPC(VPC_cont).results(7,bb)  = max(Projection.Heater);
     VPC(VPC_cont).results(8,bb)  = max(Projection.IncandescentLamp);
     VPC(VPC_cont).results(9,bb) = max(Projection.Laptop);
     VPC(VPC_cont).results(10,bb) = max(Projection.Microwaves);
     VPC(VPC_cont).results(11,bb) = max(Projection.Mixer);
     VPC(VPC_cont).results(12,bb) = max(Projection.MonitorLCD);
     VPC(VPC_cont).results(13,bb) = max(Projection.MonitorLED);
     VPC(VPC_cont).results(14,bb) = max(Projection.PS4);
     VPC(VPC_cont).results(15,bb) = max(Projection.Projector);
 %   VPC(VPC_cont).results(16,bb) = max(Projection.Solder);
     VPC(VPC_cont).results(16,bb) = max(Projection.VacuumCleaner);

    [VPC(VPC_cont).final_results(bb) VPC(VPC_cont).idx(bb)] = max(VPC(VPC_cont).results(:,bb));
%          [sortedValues,sortIndex] = sort(VPC(VPC_cont).results(:,bb),'descend');
%          MaxPowers(1) = AppliancesMeanRMS(sortIndex(1));
%          MaxPowers(2) = AppliancesMeanRMS(sortIndex(2));
%          MaxPowers(3) = AppliancesMeanRMS(sortIndex(3));
%          MaxPowers = MaxPowers';
%           
%           diff_powers(1) = abs(MaxPowers(1) - appliances_new(bb).rms);
%           diff_powers(2) = abs(MaxPowers(2) - appliances_new(bb).rms);
%           diff_powers(3) = abs(MaxPowers(3) - appliances_new(bb).rms);
%           
%           [MinDiffPowersValue MinDiffPowersIndex] = min(diff_powers); 
%       
%            switch MinDiffPowersIndex
%                case 1
%                   VPC(VPC_cont).idx(bb) = sortIndex(1);
%                case 2
%                   VPC(VPC_cont).idx(bb) = sortIndex(2);  
%                case 3
%                   VPC(VPC_cont).idx(bb) = sortIndex(3);  
%            end

%           [sortedValues,sortIndex] = sort(VPC(VPC_cont).results(:,bb),'descend');
%           MaxTHD(1) = AppliancesMeanTHD(sortIndex(1));
%           MaxTHD(2) = AppliancesMeanTHD(sortIndex(2));
%           MaxTHD(3) = AppliancesMeanTHD(sortIndex(3));
%           MaxTHD = MaxTHD';
%            
%            diff_THD(1) = abs(MaxTHD(1) - appliances_new(bb).THD);
%            diff_THD(2) = abs(MaxTHD(2) - appliances_new(bb).THD);
%            diff_THD(3) = abs(MaxTHD(3) - appliances_new(bb).THD);
%            
%            [MinDiffTHDValue MinDiffTHDIndex] = min(diff_THD); 
%        
%             switch MinDiffTHDIndex
%                 case 1
%                    VPC(VPC_cont).idx(bb) = sortIndex(1);
%                 case 2
%                    VPC(VPC_cont).idx(bb) = sortIndex(2);  
%                 case 3
%                    VPC(VPC_cont).idx(bb) = sortIndex(3);  
%             end
    
    
    switch VPC(VPC_cont).idx(bb)
        case 1
            appliances_new(bb).identified = 'AirConditioning';
        case 2
            appliances_new(bb).identified = 'AirFryer';
        case 3
            appliances_new(bb).identified = 'Blender';
        case 4
            appliances_new(bb).identified = 'FluorescentLamp_OSRAM';  
%         case 5
%             appliances_new(bb).identified = 'FluorescentLamp_EMPALUX';              
        case 5
            appliances_new(bb).identified = 'DVDPlayer';               
%       case 6
%           appliances_new(bb).identified = 'ElectronicSolder';                              
        case 6
            appliances_new(bb).identified = 'Fan';
        case 7
            appliances_new(bb).identified = 'Heater';
        case 8
            appliances_new(bb).identified = 'IncandescentLamp';            
        case 9
            appliances_new(bb).identified = 'Laptop';
        case 10
            appliances_new(bb).identified = 'Microwaves';
        case 11
            appliances_new(bb).identified = 'Mixer';     
        case 12
            appliances_new(bb).identified = 'MonitorLCD';  
        case 13
            appliances_new(bb).identified = 'MonitorLED';  
        case 14
            appliances_new(bb).identified = 'PS4';  
        case 15
            appliances_new(bb).identified = 'Projector';  
 %       case 16
 %           appliances_new(bb).identified = 'Solder';              
        case 16
            appliances_new(bb).identified = 'VacuumCleaner';                      
    end

    if (strcmp(appliances_new(bb).name,appliances_new(bb).identified))
        VPC(VPC_cont).hits = VPC(VPC_cont).hits + 1;
    end 
    VPC(VPC_cont).matches(bb,1) = {appliances_new(bb).name};
    VPC(VPC_cont).matches(bb,2) = {appliances_new(bb).identified};
    VPC(VPC_cont).matches(bb,3) = {Projection};
    VPC(VPC_cont).matches(bb,4) = {VPC(VPC_cont).results(:,bb)};
           
    bb = bb + 1;
               
  end
    
end


VPC(VPC_cont).cycles   = number_of_network_cycles-1;
VPC(VPC_cont).k        = k;
VPC(VPC_cont).training = number_of_training_samples;
VPC(VPC_cont).total_loads_tested = bb-1;
VPC(VPC_cont).percent = VPC(VPC_cont).hits/(bb-1);

if (strcmp(Signature,'P'))
    VPC(VPC_cont).Signature = 'P';
    
    if (save_results_in_file == 1)
        
        save_file_P = sprintf('./results/Signature_Power/database_%dx%d/%dcycles/k=%.2f.txt',...
            number_of_training_samples,30-number_of_training_samples,number_of_network_cycles-1,k);

        if (file_flag == 1)
            fileID = fopen(save_file_P,'wt'); %abre arquivo e cria-o caso nao exista
            fprintf(fileID,'%f',VPC(VPC_cont).percent);
            fclose(fileID);                     
        else            
            fileID = fopen(save_file_P,'at'); %abre arquivo e cria-o caso nao exista
            fprintf(fileID,'\n%f',VPC(VPC_cont).percent);
            fclose(fileID);           
        end     
    end
    
    Signature = 'C';
else
    VPC(VPC_cont).Signature = 'C';
    
    if (save_results_in_file == 1)
        
        save_file_I = sprintf('./results/Signature_Current/database_%dx%d/%dcycles/k=%.2f.txt',...
            number_of_training_samples,30-number_of_training_samples,number_of_network_cycles-1,k);
        
        if (file_flag == 1)
            file_flag = 0;
            fileID = fopen(save_file_I,'wt'); %abre arquivo e cria-o caso nao exista
            fprintf(fileID,'%f',VPC(VPC_cont).percent);
            fclose(fileID);  
        else           
            fileID = fopen(save_file_I,'at'); %abre arquivo e cria-o caso nao exista
            fprintf(fileID,'\n%f',VPC(VPC_cont).percent);
            fclose(fileID);            
        end   
    end     
    
    Signature = 'P';
end

VPC_cont = VPC_cont + 1;

fclose('all');

end

%VPC_P_only = strcmp('P',VPC.Signature);
%VPC_I_only = strcmp('C',VPC.Signature);

end
end
end
