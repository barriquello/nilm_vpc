% Vinicius Pozzobon Borin
% Federal University of Santa Maria

clear all;
close all;
clc;

addpath('../libraries');
addpath('./Signature_Power');
addpath('./Signature_Current');


%% PLOT POWER SIGNATURE


Database_Power = dir('./Signature_Power/');

s = size(Database_Power);

for i=1:s(1)
    
    tf = strncmp('database',Database_Power(i).name,8);
    if (tf == 1)
        


     %   Dir_Cycles = dir(strcat('./Signature_Power/',Database_Power(i).name,'/'));
      %  s2 = size(Dir_Cycles);
        s2 = 20;  
      
        for j=1:s2
           
            Cycles(j).number = j;
            Cycles(j).verbete = strcat(num2str(j),'cycles');
 
        end       
        
        for j=1:s2
                   
                k_Cycles = dir(strcat('./Signature_Power/',Database_Power(i).name,'/',Cycles(j).verbete,'/'));
                s3 = size(k_Cycles);
                
                
                for w=3:s3(1)
                   
                    abrir = fopen(['./Signature_Power/',Database_Power(i).name,'/',Cycles(j).verbete,'/',k_Cycles(w).name],'r'); %open the appliance file
                    data = fscanf(abrir, '%f');
                    fclose(abrir);
                    s4 = size(data);
                    
                    if (s4(1) == 10)
                    %    Results_Power.(Database_Power(i).name).cycles  = Dir_Cycles(j).name;
                        Results_Power.(Database_Power(i).name)(w-2,j) = mean(data)*100;                         
                    else
                        errordlg(['The file does not have 10 result values. File Path: ',...
                            './Signature_Power/',Database_Power(i).name,'/',Cycles(j).verbete,'/',k_Cycles(w).name],'VPC File Error');                        
                    end
                        
                end
                
                Cycles(j).(Database_Power(i).name) = max(Results_Power.(Database_Power(i).name)(:,j));

            
        end
        
        
    end
    
end

k=0:0.05:1;
plot_color = ['r';'m';'c';'y';'g';'b';'k'];
cc = 1;

matrix_k = repmat(k',1,20);
matrix_cycles = repmat(1:20,21,1);

for ii=1:5
    
    Cyclesfields = fieldnames(Cycles);
    Cyclescell = struct2cell(Cycles);
    sz = size(Cyclescell);

    % Convert to a matrix
    Cyclescell = reshape(Cyclescell, sz(1), []);      % Px(MxN)

    % Make each field a column
    Cyclescell = Cyclescell';                         % (MxN)xP

    % Sort by first field "name"
    Cyclescell = sortrows(Cyclescell, -(2+ii));
    
    figure('units','normalized','outerposition',[0 0 1 1])

    surf(matrix_cycles,matrix_k,Results_Power.(Database_Power(ii+2).name));
  %  colormap(flipud(hot));
    colormap(jet);
   % colormap(flipud(pink));
    caxis([30,100]);
   % shading interp;
    

%     plot(k,Results_Power.(Database_Power(ii+2).name)(:,cell2mat(Cyclescell(1,1))),[plot_color(1),'-o'],'MarkerFaceColor',plot_color(1));
%     plot(k,Results_Power.(Database_Power(ii+2).name)(:,cell2mat(Cyclescell(2,1))),[plot_color(2),'-o'],'MarkerFaceColor',plot_color(2));
%     plot(k,Results_Power.(Database_Power(ii+2).name)(:,cell2mat(Cyclescell(3,1))),[plot_color(3),'-o'],'MarkerFaceColor',plot_color(3));
%     plot(k,Results_Power.(Database_Power(ii+2).name)(:,cell2mat(Cyclescell(4,1))),[plot_color(4),'-o'],'MarkerFaceColor',plot_color(4));
%     plot(k,Results_Power.(Database_Power(ii+2).name)(:,cell2mat(Cyclescell(5,1))),[plot_color(5),'-o'],'MarkerFaceColor',plot_color(5));
%     plot(k,Results_Power.(Database_Power(ii+2).name)(:,cell2mat(Cyclescell(6,1))),[plot_color(6),'-o'],'MarkerFaceColor',plot_color(6));
%     plot(k,Results_Power.(Database_Power(ii+2).name)(:,cell2mat(Cyclescell(7,1))),[plot_color(7),'-o'],'MarkerFaceColor',plot_color(7));
%     
%     plot(k,Results_Power.(Database_Power(ii+2).name)(:,cell2mat(Cyclescell(8,1))),[plot_color(1),'-*'],'MarkerFaceColor',plot_color(1));
%     plot(k,Results_Power.(Database_Power(ii+2).name)(:,cell2mat(Cyclescell(9,1))),[plot_color(2),'-*'],'MarkerFaceColor',plot_color(2));
%     plot(k,Results_Power.(Database_Power(ii+2).name)(:,cell2mat(Cyclescell(10,1))),[plot_color(3),'-*'],'MarkerFaceColor',plot_color(3));
%     plot(k,Results_Power.(Database_Power(ii+2).name)(:,cell2mat(Cyclescell(11,1))),[plot_color(4),'-*'],'MarkerFaceColor',plot_color(4));
%     plot(k,Results_Power.(Database_Power(ii+2).name)(:,cell2mat(Cyclescell(12,1))),[plot_color(5),'-*'],'MarkerFaceColor',plot_color(5));
%     plot(k,Results_Power.(Database_Power(ii+2).name)(:,cell2mat(Cyclescell(13,1))),[plot_color(6),'-*'],'MarkerFaceColor',plot_color(6));
%     plot(k,Results_Power.(Database_Power(ii+2).name)(:,cell2mat(Cyclescell(14,1))),[plot_color(7),'-*'],'MarkerFaceColor',plot_color(7));
    
    h = gca;
    switch (Database_Power(ii+2).name)
        case 'database_1x29'
            title('\fontsize{10}Signature: Power. Number of Training Samples by Load: 01');
        case 'database_5x25'
            title('\fontsize{10}Signature: Power. Number of Training Samples by Load: 05');
        case 'database_10x20'
            title('\fontsize{10}Signature: Power. Number of Training Samples by Load: 10');
        case 'database_15x15'
            title('\fontsize{10}Signature: Power. Number of Training Samples by Load: 15');
        case 'database_20x10'
            title('\fontsize{10}Signature: Power. Number of Training Samples by Load: 20');
    end

    
    dd = xlabel('\fontsize{10}Number of Cycles');
  %  dd.HorizontalAlignment = 'center';
  %  dd.VerticalAlignment = 'bottom';
    dd.Rotation = 0;
    dd = ylabel('\fontsize{10}Variation of k (0 ~ 1)');
  %  dd.HorizontalAlignment = 'center';
    dd = zlabel(sprintf('Loads Identified (%%) \nCutting Plane: 90%%'));
    dd.FontSize = 10;
    dd.HorizontalAlignment = 'center';
         
    grid on;
    set(h,'XTick',1:1:20);
    set(h,'YTick',0:0.1:1);
    set(h,'ZLim',[30 100]);
    
     hold on;
     max_point = max(Results_Power.(Database_Power(ii+2).name)(:));
     p = fill3([1 1 20 20],[0 1 1 0],[90 90 90 90],1);
     set(p,'facealpha',0.5);
     set(p,'edgealpha',0.5);
    
    [maxval maxloc] = max(Results_Power.(Database_Power(ii+2).name)(:));
    [idxrow, idxcol] = find(Results_Power.(Database_Power(ii+2).name)==maxval);

    p_idxrow(1) = idxrow(1);
    p_idxcol(1) = idxcol(1);
    p_maxval(1) = maxval;

    hold on;
    gg = scatter3(matrix_cycles(idxrow(1),idxcol(1)),matrix_k(idxrow(1),idxcol(1)),...
        Results_Power.(Database_Power(ii+2).name)(idxrow(1),idxcol(1)),80,'filled','k','MarkerEdgeColor','k');

    %text(training_cycles(idxrow,idxcol),training_set(idxrow,idxcol),Results_by_training_k8(idxrow,idxcol), '\downarrow');
    t = text(matrix_cycles(idxrow(1),idxcol(1))-1,matrix_k(idxrow(1),idxcol(1))-0.05,...
        Results_Power.(Database_Power(ii+2).name)(idxrow(1),idxcol(1)),'P1');

    t.Color = 'w';

%     Results_Power.(Database_Power(ii+2).name)(idxrow,idxcol) = 0;
% 
%     [maxval maxloc] = max(Results_Power.(Database_Power(ii+2).name)(:));
%     [idxrow, idxcol] = find(Results_Power.(Database_Power(ii+2).name)==maxval);
% 
%     p_idxrow(2) = idxrow(1);
%     p_idxcol(2) = idxcol(1);
%     p_maxval(2) = maxval;
% 
%     hold on;
%     gg = scatter3(matrix_cycles(idxrow(1),idxcol(1)),matrix_k(idxrow(1),idxcol(1)),...
%         Results_Power.(Database_Power(ii+2).name)(idxrow(1),idxcol(1)),80,'filled','k','MarkerEdgeColor','k');
% 
%     %text(training_cycles(idxrow,idxcol),training_set(idxrow,idxcol),Results_by_training_k8(idxrow,idxcol), '\downarrow');
%     t = text(matrix_cycles(idxrow(1),idxcol(1))-1,matrix_k(idxrow(1),idxcol(1))-0.05,...
%         Results_Power.(Database_Power(ii+2).name)(idxrow(1),idxcol(1)),'P2');
% 
%     t.Color = 'w';
% 
%     Results_Power.(Database_Power(ii+2).name)(idxrow,idxcol) = 0; 
%     
%         [maxval maxloc] = max(Results_Power.(Database_Power(ii+2).name)(:));
%     [idxrow, idxcol] = find(Results_Power.(Database_Power(ii+2).name)==maxval);
% 
%     p_idxrow(3) = idxrow(1);
%     p_idxcol(3) = idxcol(1);
%     p_maxval(3) = maxval;
% 
%     hold on;
%     gg = scatter3(matrix_cycles(idxrow(1),idxcol(1)),matrix_k(idxrow(1),idxcol(1)),...
%         Results_Power.(Database_Power(ii+2).name)(idxrow(1),idxcol(1)),80,'filled','k','MarkerEdgeColor','k');
% 
%     %text(training_cycles(idxrow,idxcol),training_set(idxrow,idxcol),Results_by_training_k8(idxrow,idxcol), '\downarrow');
%     t = text(matrix_cycles(idxrow(1),idxcol(1))-1,matrix_k(idxrow(1),idxcol(1))-0.05,...
%         Results_Power.(Database_Power(ii+2).name)(idxrow(1),idxcol(1)),'P3');
% 
%     t.Color = 'w';
% 
%     Results_Power.(Database_Power(ii+2).name)(idxrow,idxcol) = 0;
%     
%     [maxval maxloc] = max(Results_Power.(Database_Power(ii+2).name)(:));
%     [idxrow, idxcol] = find(Results_Power.(Database_Power(ii+2).name)==maxval);
% 
%     p_idxrow(4) = idxrow(1);
%     p_idxcol(4) = idxcol(1);
%     p_maxval(4) = maxval;
% 
%     hold on;
%     gg = scatter3(matrix_cycles(idxrow(1),idxcol(1)),matrix_k(idxrow(1),idxcol(1)),...
%         Results_Power.(Database_Power(ii+2).name)(idxrow(1),idxcol(1)),80,'filled','k','MarkerEdgeColor','k');
% 
%     %text(training_cycles(idxrow,idxcol),training_set(idxrow,idxcol),Results_by_training_k8(idxrow,idxcol), '\downarrow');
%     t = text(matrix_cycles(idxrow(1),idxcol(1))-1,matrix_k(idxrow(1),idxcol(1))-0.05,...
%         Results_Power.(Database_Power(ii+2).name)(idxrow(1),idxcol(1)),'P4');
% 
%     t.Color = 'w';
% 
%     Results_Power.(Database_Power(ii+2).name)(idxrow,idxcol) = 0;
%     
%     [maxval maxloc] = max(Results_Power.(Database_Power(ii+2).name)(:));
%     [idxrow, idxcol] = find(Results_Power.(Database_Power(ii+2).name)==maxval);
% 
%     p_idxrow(5) = idxrow(1);
%     p_idxcol(5) = idxcol(1);
%     p_maxval(5) = maxval;
% 
%     hold on;
%     gg = scatter3(matrix_cycles(idxrow(1),idxcol(1)),matrix_k(idxrow(1),idxcol(1)),...
%         Results_Power.(Database_Power(ii+2).name)(idxrow(1),idxcol(1)),80,'filled','k','MarkerEdgeColor','k');
% 
%     %text(training_cycles(idxrow,idxcol),training_set(idxrow,idxcol),Results_by_training_k8(idxrow,idxcol), '\downarrow');
%     t = text(matrix_cycles(idxrow(1),idxcol(1))-1,matrix_k(idxrow(1),idxcol(1))-0.05,...
%         Results_Power.(Database_Power(ii+2).name)(idxrow(1),idxcol(1)),'P5');
% 
%     t.Color = 'w';

    h = get(gca,'Children');
    set(gca,'Children',flipud(h));

%     bb = legend(                   strcat('P1 (',mat2str(matrix_cycles(p_idxrow(1),p_idxcol(1))),',',mat2str(matrix_k(p_idxrow(1),p_idxcol(1))),',',...
%         mat2str(p_maxval(1)),'%)'),strcat('P2 (',mat2str(matrix_cycles(p_idxrow(2),p_idxcol(2))),',',mat2str(matrix_k(p_idxrow(2),p_idxcol(2))),',',...
%         mat2str(p_maxval(2)),'%)'),strcat('P3 (',mat2str(matrix_cycles(p_idxrow(3),p_idxcol(3))),',',mat2str(matrix_k(p_idxrow(3),p_idxcol(3))),',',...
%         mat2str(p_maxval(3)),'%)'),strcat('P4 (',mat2str(matrix_cycles(p_idxrow(4),p_idxcol(4))),',',mat2str(matrix_k(p_idxrow(4),p_idxcol(4))),',',...
%         mat2str(p_maxval(4)),'%)'),strcat('P5 (',mat2str(matrix_cycles(p_idxrow(5),p_idxcol(5))),',',mat2str(matrix_k(p_idxrow(5),p_idxcol(5))),',',...
%         mat2str(p_maxval(5)),'%)'));
    
        bb = legend(                   strcat('P1 (',mat2str(matrix_cycles(p_idxrow(1),p_idxcol(1))),',',mat2str(matrix_k(p_idxrow(1),p_idxcol(1))),',',...
        mat2str(p_maxval(1)),'%)'));

    bb.Location = 'southeast';
    
    
       
%     tt = text(19, 0.1, 89, sprintf('Cutting Plane: 90%%')); 
%     set(tt,'Color','w');
%     set(tt,'HorizontalAlignment','center');
    
    
   % legend(cellstr(Cyclescell(1:14,2)));
    

end

%% PLOT CURRENT SIGNATURE


Database_Current = dir('./Signature_Current/');

s = size(Database_Current);

for i=1:s(1)
    
    tf = strncmp('database',Database_Current(i).name,8);
    if (tf == 1)
        
        s2 = 20;  
      
        for j=1:s2
           
            Cycles(j).number = j;
            Cycles(j).verbete = strcat(num2str(j),'cycles');
 
        end        
        
        for j=1:s2
                   
                k_Cycles = dir(strcat('./Signature_Current/',Database_Current(i).name,'/',Cycles(j).verbete,'/'));
                s3 = size(k_Cycles);
                
                
                for w=3:s3(1)
                   
                    abrir = fopen(['./Signature_Current/',Database_Current(i).name,'/',Cycles(j).verbete,'/',k_Cycles(w).name],'r'); %open the appliance file
                    data = fscanf(abrir, '%f');
                    fclose(abrir);
                    s4 = size(data);
                    
                    if (s4(1) == 10)
                    %    Results_Power.(Database_Power(i).name).cycles  = Dir_Cycles(j).name;
                        Results_Current.(Database_Current(i).name)(w-2,j) = mean(data)*100;                         
                    else
                        errordlg(['The file does not have 10 result values. File Path: ',...
                            './Signature_Current/',Database_Current(i).name,'/',Cycles(j).verbete,'/',k_Cycles(w).name],'VPC File Error');                        
                    end
                        
                end
                
                Cycles(j).(Database_Current(i).name) = max(Results_Current.(Database_Current(i).name)(:,j));

            
        end
        
        
    end
    
end

for ii=1:5
    
    Cyclesfields = fieldnames(Cycles);
    Cyclescell = struct2cell(Cycles);
    sz = size(Cyclescell);

    % Convert to a matrix
    Cyclescell = reshape(Cyclescell, sz(1), []);      % Px(MxN)

    % Make each field a column
    Cyclescell = Cyclescell';                         % (MxN)xP

    % Sort by first field "name"
    Cyclescell = sortrows(Cyclescell, -(2+ii));
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    
    surf(matrix_cycles,matrix_k,Results_Current.(Database_Power(ii+2).name));
  %  colormap(flipud(hot));
    colormap(jet);
  %  colormap(flipud(pink));
    caxis([30,100]);

    
%     plot(k,Results_Current.(Database_Current(ii+2).name)(:,cell2mat(Cyclescell(1,1))),[plot_color(1),'-o'],'MarkerFaceColor',plot_color(1));
%     plot(k,Results_Current.(Database_Current(ii+2).name)(:,cell2mat(Cyclescell(2,1))),[plot_color(2),'-o'],'MarkerFaceColor',plot_color(2));
%     plot(k,Results_Current.(Database_Current(ii+2).name)(:,cell2mat(Cyclescell(3,1))),[plot_color(3),'-o'],'MarkerFaceColor',plot_color(3));
%     plot(k,Results_Current.(Database_Current(ii+2).name)(:,cell2mat(Cyclescell(4,1))),[plot_color(4),'-o'],'MarkerFaceColor',plot_color(4));
%     plot(k,Results_Current.(Database_Current(ii+2).name)(:,cell2mat(Cyclescell(5,1))),[plot_color(5),'-o'],'MarkerFaceColor',plot_color(5));
%     plot(k,Results_Current.(Database_Current(ii+2).name)(:,cell2mat(Cyclescell(6,1))),[plot_color(6),'-o'],'MarkerFaceColor',plot_color(6));
%     plot(k,Results_Current.(Database_Current(ii+2).name)(:,cell2mat(Cyclescell(7,1))),[plot_color(7),'-o'],'MarkerFaceColor',plot_color(7));
%     
%     plot(k,Results_Current.(Database_Current(ii+2).name)(:,cell2mat(Cyclescell(8,1))),[plot_color(1),'-*'],'MarkerFaceColor',plot_color(1));
%     plot(k,Results_Current.(Database_Current(ii+2).name)(:,cell2mat(Cyclescell(9,1))),[plot_color(2),'-*'],'MarkerFaceColor',plot_color(2));
%     plot(k,Results_Current.(Database_Current(ii+2).name)(:,cell2mat(Cyclescell(10,1))),[plot_color(3),'-*'],'MarkerFaceColor',plot_color(3));
%     plot(k,Results_Current.(Database_Current(ii+2).name)(:,cell2mat(Cyclescell(11,1))),[plot_color(4),'-*'],'MarkerFaceColor',plot_color(4));
%     plot(k,Results_Current.(Database_Current(ii+2).name)(:,cell2mat(Cyclescell(12,1))),[plot_color(5),'-*'],'MarkerFaceColor',plot_color(5));
%     plot(k,Results_Current.(Database_Current(ii+2).name)(:,cell2mat(Cyclescell(13,1))),[plot_color(6),'-*'],'MarkerFaceColor',plot_color(6));
%     plot(k,Results_Current.(Database_Current(ii+2).name)(:,cell2mat(Cyclescell(14,1))),[plot_color(7),'-*'],'MarkerFaceColor',plot_color(7));
    
    h = gca;
    switch (Database_Current(ii+2).name)
        case 'database_1x29'
            title('\fontsize{10}Signature: Current. Number of Training Samples by Load: 01');
        case 'database_5x25'
            title('\fontsize{10}Signature: Current. Number of Training Samples by Load: 05');
        case 'database_10x20'
            title('\fontsize{10}Signature: Current. Number of Training Samples by Load: 10');
        case 'database_15x15'
            title('\fontsize{10}Signature: Current. Number of Training Samples by Load: 15');
        case 'database_20x10'
            title('\fontsize{10}Signature: Current. Number of Training Samples by Load: 20');
    end
    
    xlabel('\fontsize{10}Number of Cycles');
    ylabel('\fontsize{10}Variation of k (0 ~ 1)');
    %zlabel('\fontsize{10}Loads Identified (%)');
    dd = zlabel(sprintf('Loads Identified (%%) \nCutting Plane: 90%%'));
    dd.FontSize = 10;
    dd.HorizontalAlignment = 'center';     
    
    grid on;
    set(h,'XTick',1:1:20);
    set(h,'YTick',0:0.1:1);
    set(h,'ZLim',[30 100]);
                     
     hold on;
     max_point = max(Results_Current.(Database_Current(ii+2).name)(:));
     p = fill3([1 1 20 20],[0 1 1 0],[90 90 90 90],1);
     set(p,'facealpha',0.5);
     set(p,'edgealpha',0.5);
    
    [maxval maxloc] = max(Results_Current.(Database_Current(ii+2).name)(:));
    [idxrow, idxcol] = find(Results_Current.(Database_Current(ii+2).name)==maxval);

    p_idxrow(1) = idxrow(1);
    p_idxcol(1) = idxcol(1);
    p_maxval(1) = maxval;

    hold on;
    gg = scatter3(matrix_cycles(idxrow(1),idxcol(1)),matrix_k(idxrow(1),idxcol(1)),...
        Results_Current.(Database_Current(ii+2).name)(idxrow(1),idxcol(1)),80,'filled','k','MarkerEdgeColor','k');

    %text(training_cycles(idxrow,idxcol),training_set(idxrow,idxcol),Results_by_training_k8(idxrow,idxcol), '\downarrow');
    t = text(matrix_cycles(idxrow(1),idxcol(1))-1,matrix_k(idxrow(1),idxcol(1))-0.05,...
        Results_Current.(Database_Current(ii+2).name)(idxrow(1),idxcol(1)),'P1');

    t.Color = 'w';

%     Results_Current.(Database_Current(ii+2).name)(idxrow,idxcol) = 0;
%     
%         [maxval maxloc] = max(Results_Current.(Database_Current(ii+2).name)(:));
%     [idxrow, idxcol] = find(Results_Current.(Database_Current(ii+2).name)==maxval);
% 
%     p_idxrow(2) = idxrow(1);
%     p_idxcol(2) = idxcol(1);
%     p_maxval(2) = maxval;
% 
%     hold on;
%     gg = scatter3(matrix_cycles(idxrow(1),idxcol(1)),matrix_k(idxrow(1),idxcol(1)),...
%         Results_Current.(Database_Current(ii+2).name)(idxrow(1),idxcol(1)),80,'filled','k','MarkerEdgeColor','k');
% 
%     %text(training_cycles(idxrow,idxcol),training_set(idxrow,idxcol),Results_by_training_k8(idxrow,idxcol), '\downarrow');
%     t = text(matrix_cycles(idxrow(1),idxcol(1))-1,matrix_k(idxrow(1),idxcol(1))-0.05,...
%         Results_Current.(Database_Current(ii+2).name)(idxrow(1),idxcol(1)),'P2');
% 
%     t.Color = 'w';
% 
%     Results_Current.(Database_Current(ii+2).name)(idxrow,idxcol) = 0;
%     
%         [maxval maxloc] = max(Results_Current.(Database_Current(ii+2).name)(:));
%     [idxrow, idxcol] = find(Results_Current.(Database_Current(ii+2).name)==maxval);
% 
%     p_idxrow(3) = idxrow(1);
%     p_idxcol(3) = idxcol(1);
%     p_maxval(3) = maxval;
% 
%     hold on;
%     gg = scatter3(matrix_cycles(idxrow(1),idxcol(1)),matrix_k(idxrow(1),idxcol(1)),...
%         Results_Current.(Database_Current(ii+2).name)(idxrow(1),idxcol(1)),80,'filled','k','MarkerEdgeColor','k');
% 
%     %text(training_cycles(idxrow,idxcol),training_set(idxrow,idxcol),Results_by_training_k8(idxrow,idxcol), '\downarrow');
%     t = text(matrix_cycles(idxrow(1),idxcol(1))-1,matrix_k(idxrow(1),idxcol(1))-0.05,...
%         Results_Current.(Database_Current(ii+2).name)(idxrow(1),idxcol(1)),'P3');
% 
%     t.Color = 'w';
% 
%     Results_Current.(Database_Current(ii+2).name)(idxrow,idxcol) = 0;
%     
%         [maxval maxloc] = max(Results_Current.(Database_Current(ii+2).name)(:));
%     [idxrow, idxcol] = find(Results_Current.(Database_Current(ii+2).name)==maxval);
% 
%     p_idxrow(4) = idxrow(1);
%     p_idxcol(4) = idxcol(1);
%     p_maxval(4) = maxval;
% 
%     hold on;
%     gg = scatter3(matrix_cycles(idxrow(1),idxcol(1)),matrix_k(idxrow(1),idxcol(1)),...
%         Results_Current.(Database_Current(ii+2).name)(idxrow(1),idxcol(1)),80,'filled','k','MarkerEdgeColor','k');
% 
%     %text(training_cycles(idxrow,idxcol),training_set(idxrow,idxcol),Results_by_training_k8(idxrow,idxcol), '\downarrow');
%     t = text(matrix_cycles(idxrow(1),idxcol(1))-1,matrix_k(idxrow(1),idxcol(1))-0.05,...
%         Results_Current.(Database_Current(ii+2).name)(idxrow(1),idxcol(1)),'P4');
% 
%     t.Color = 'w';
% 
%     Results_Current.(Database_Current(ii+2).name)(idxrow,idxcol) = 0;
%     
%         [maxval maxloc] = max(Results_Current.(Database_Current(ii+2).name)(:));
%     [idxrow, idxcol] = find(Results_Current.(Database_Current(ii+2).name)==maxval);
% 
%     p_idxrow(5) = idxrow(1);
%     p_idxcol(5) = idxcol(1);
%     p_maxval(5) = maxval;
% 
%     hold on;
%     gg = scatter3(matrix_cycles(idxrow(1),idxcol(1)),matrix_k(idxrow(1),idxcol(1)),...
%         Results_Current.(Database_Current(ii+2).name)(idxrow(1),idxcol(1)),80,'filled','k','MarkerEdgeColor','k');
% 
%     %text(training_cycles(idxrow,idxcol),training_set(idxrow,idxcol),Results_by_training_k8(idxrow,idxcol), '\downarrow');
%     t = text(matrix_cycles(idxrow(1),idxcol(1))-1,matrix_k(idxrow(1),idxcol(1))-0.05,...
%         Results_Current.(Database_Current(ii+2).name)(idxrow(1),idxcol(1)),'P5');
% 
%     t.Color = 'w';

    h = get(gca,'Children');
    set(gca,'Children',flipud(h));

%     bb = legend(                   strcat('P1 (',mat2str(matrix_cycles(p_idxrow(1),p_idxcol(1))),',',mat2str(matrix_k(p_idxrow(1),p_idxcol(1))),',',...
%         mat2str(p_maxval(1)),'%)'),strcat('P2 (',mat2str(matrix_cycles(p_idxrow(2),p_idxcol(2))),',',mat2str(matrix_k(p_idxrow(2),p_idxcol(2))),',',...
%         mat2str(p_maxval(2)),'%)'),strcat('P3 (',mat2str(matrix_cycles(p_idxrow(3),p_idxcol(3))),',',mat2str(matrix_k(p_idxrow(3),p_idxcol(3))),',',...
%         mat2str(p_maxval(3)),'%)'),strcat('P4 (',mat2str(matrix_cycles(p_idxrow(4),p_idxcol(4))),',',mat2str(matrix_k(p_idxrow(4),p_idxcol(4))),',',...
%         mat2str(p_maxval(4)),'%)'),strcat('P5 (',mat2str(matrix_cycles(p_idxrow(5),p_idxcol(5))),',',mat2str(matrix_k(p_idxrow(5),p_idxcol(5))),',',...
%         mat2str(p_maxval(5)),'%)'));
    
    bb = legend(                   strcat('P1 (',mat2str(matrix_cycles(p_idxrow(1),p_idxcol(1))),',',mat2str(matrix_k(p_idxrow(1),p_idxcol(1))),',',...
        mat2str(p_maxval(1)),'%)'));

    bb.Location = 'southeast';
    
%     tt = text(19, 0.1, 89, sprintf('Cutting Plane: 90%%')); 
%     set(tt,'HorizontalAlignment','center');
    
    
           
  %legend(cellstr(Cyclescell(1:14,2)));
    

end

%%
pos = 15;

for asd=0.7:0.05:1

    
    training_set = [1 5 10 15 20];
    training_set = repmat(training_set',1,20);

    training_cycles = repmat(1:20,5,1);

    Results_by_training_k8(1,:) = Results_Power.database_1x29 (pos,:);
    Results_by_training_k8(2,:) = Results_Power.database_5x25 (pos,:);
    Results_by_training_k8(3,:) = Results_Power.database_10x20(pos,:);
    Results_by_training_k8(4,:) = Results_Power.database_15x15(pos,:);
    Results_by_training_k8(5,:) = Results_Power.database_20x10(pos,:);

    figure('units','normalized','outerposition',[0 0 1 1])

    surf(training_cycles,training_set,Results_by_training_k8);
    colormap(jet);
    caxis([0,100]);

    h = gca;

    dd = title(sprintf('Signature: Power. Fixed k = %.2f.',asd));
    dd.FontSize = 10;
    dd.HorizontalAlignment = 'center';   

    xlabel('\fontsize{10}Number of Cycles');
    ylabel('\fontsize{10}Training Set Variation');
        dd = zlabel(sprintf('Loads Identified (%%) \nCutting Plane: 90%%'));
        dd.FontSize = 10;
        dd.HorizontalAlignment = 'center';    

    grid on;
    set(h,'XTick',1:1:20);
    set(h,'YTick',[1:4:5 10:5:20]);
    set(h,'ZLim',[30 100]);
    
    hold on;
    max_point = max(Results_by_training_k8(:));
    p = fill3([1 1 20 20],[1 20 20 1],[90 90 90 90],1);
    set(p,'facealpha',0.5);
    set(p,'edgealpha',0.5);
    
    [maxval maxloc] = max(Results_by_training_k8(:));
    [idxrow, idxcol] = find(Results_by_training_k8==maxval);
 
    p_idxrow(1) = idxrow(1);
    p_idxcol(1) = idxcol(1);
    p_maxval(1) = maxval;
 
    hold on;
    gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
         80,'filled','k','MarkerEdgeColor','k');
 
 
    t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
         'P1');
 
    t.Color = 'w';
 
    Results_by_training_k8(idxrow,idxcol) = 0;
    
    bb = legend(strcat('P1 (',mat2str(training_cycles(p_idxrow(1),p_idxcol(1))),',',mat2str(training_set(p_idxrow(1),p_idxcol(1))),',',...
     mat2str(p_maxval(1)),'%)'));
 
    bb.Location = 'southeast';
    
     [maxval maxloc] = max(Results_by_training_k8(:));
 [idxrow, idxcol] = find(Results_by_training_k8==maxval);
 
 p_idxrow(1) = idxrow(1);
 p_idxcol(1) = idxcol(1);
 p_maxval(1) = maxval;
 
 hold on;
 gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
     80,'filled','k','MarkerEdgeColor','k');
 
 
 t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
     'P1');
 
 t.Color = 'w';
 
 Results_by_training_k8(idxrow,idxcol) = 0;
 
 [maxval maxloc] = max(Results_by_training_k8(:));
 [idxrow, idxcol] = find(Results_by_training_k8==maxval);
 
 p_idxrow(2) = idxrow(1);
 p_idxcol(2) = idxcol(1);
 p_maxval(2) = maxval;
 
 hold on;
 gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
     80,'filled','k','MarkerEdgeColor','k');
 
 t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
     'P2');
 
 t.Color = 'w';
 
 
 Results_by_training_k8(idxrow,idxcol) = 0;
 
 [maxval maxloc] = max(Results_by_training_k8(:));
 [idxrow, idxcol] = find(Results_by_training_k8==maxval);
 
 p_idxrow(3) = idxrow(1);
 p_idxcol(3) = idxcol(1);
 p_maxval(3) = maxval;
 
 hold on;
 gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
     80,'filled','k','MarkerEdgeColor','k');
 
 t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
     'P3');
 
 t.Color = 'w';
 
 Results_by_training_k8(idxrow,idxcol) = 0;
 
 [maxval maxloc] = max(Results_by_training_k8(:));
 [idxrow, idxcol] = find(Results_by_training_k8==maxval);
 
 p_idxrow(4) = idxrow(1);
 p_idxcol(4) = idxcol(1);
 p_maxval(4) = maxval;
 
 hold on;
 gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
     80,'filled','k','MarkerEdgeColor','k');
 
 t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
     'P4');
 
 t.Color = 'w';
 
 Results_by_training_k8(idxrow,idxcol) = 0;
 
 [maxval maxloc] = max(Results_by_training_k8(:));
 [idxrow, idxcol] = find(Results_by_training_k8==maxval);
 
 p_idxrow(5) = idxrow(1);
 p_idxcol(5) = idxcol(1);
 p_maxval(5) = maxval;
 
 hold on;
 gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
     80,'filled','k','MarkerEdgeColor','k');
 
 t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
     'P5');
 
 t.Color = 'w';
 
 h = get(gca,'Children');
 set(gca,'Children',flipud(h));
 
 bb = legend(strcat('P1 (',mat2str(training_cycles(p_idxrow(1),p_idxcol(1))),',',mat2str(training_set(p_idxrow(1),p_idxcol(1))),',',...
     mat2str(p_maxval(1)),'%)'),strcat('P2 (',mat2str(training_cycles(p_idxrow(2),p_idxcol(2))),',',mat2str(training_set(p_idxrow(2),p_idxcol(2))),',',...
     mat2str(p_maxval(2)),'%)'),strcat('P3 (',mat2str(training_cycles(p_idxrow(3),p_idxcol(3))),',',mat2str(training_set(p_idxrow(3),p_idxcol(3))),',',...
     mat2str(p_maxval(3)),'%)'),strcat('P4 (',mat2str(training_cycles(p_idxrow(4),p_idxcol(4))),',',mat2str(training_set(p_idxrow(4),p_idxcol(4))),',',...
     mat2str(p_maxval(4)),'%)'),strcat('P5 (',mat2str(training_cycles(p_idxrow(5),p_idxcol(5))),',',mat2str(training_set(p_idxrow(5),p_idxcol(5))),',',...
     mat2str(p_maxval(5)),'%)'));
 
 bb.Location = 'southeast';


    %%

    Results_by_training_k8(1,:) = Results_Current.database_1x29 (pos,:);
    Results_by_training_k8(2,:) = Results_Current.database_5x25 (pos,:);
    Results_by_training_k8(3,:) = Results_Current.database_10x20(pos,:);
    Results_by_training_k8(4,:) = Results_Current.database_15x15(pos,:);
    Results_by_training_k8(5,:) = Results_Current.database_20x10(pos,:);

    figure('units','normalized','outerposition',[0 0 1 1]);

    surf(training_cycles,training_set,Results_by_training_k8);
    colormap(jet);

    caxis([0,100]);

    h = gca;

    dd = title(sprintf('Signature: Current. Fixed k = %.2f.',asd));
    dd.FontSize = 10;
    dd.HorizontalAlignment = 'center';   

    xlabel('\fontsize{10}Number of Cycles');
    ylabel('\fontsize{10}Training Set Variation');
        dd = zlabel(sprintf('Loads Identified (%%) \nCutting Plane: 90%%'));
        dd.FontSize = 10;
        dd.HorizontalAlignment = 'center';    

    grid on;
    set(h,'XTick',1:1:20);
    set(h,'YTick',[1:4:5 10:5:20]);
    set(h,'ZLim',[30 100]);
    
    hold on;
    max_point = max(Results_by_training_k8(:));
    p = fill3([1 1 20 20],[1 20 20 1],[90 90 90 90],1);
    set(p,'facealpha',0.5);
    set(p,'edgealpha',0.5);
     
 [maxval maxloc] = max(Results_by_training_k8(:));
 [idxrow, idxcol] = find(Results_by_training_k8==maxval);
 
 p_idxrow(1) = idxrow(1);
 p_idxcol(1) = idxcol(1);
 p_maxval(1) = maxval;
 
 hold on;
 gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
     80,'filled','k','MarkerEdgeColor','k');
 
 
 t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
     'P1');
 
 t.Color = 'w';
 
 Results_by_training_k8(idxrow,idxcol) = 0;
 
 [maxval maxloc] = max(Results_by_training_k8(:));
 [idxrow, idxcol] = find(Results_by_training_k8==maxval);
 
 p_idxrow(2) = idxrow(1);
 p_idxcol(2) = idxcol(1);
 p_maxval(2) = maxval;
 
 hold on;
 gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
     80,'filled','k','MarkerEdgeColor','k');
 
 t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
     'P2');
 
 t.Color = 'w';
 
 
 Results_by_training_k8(idxrow,idxcol) = 0;
 
 [maxval maxloc] = max(Results_by_training_k8(:));
 [idxrow, idxcol] = find(Results_by_training_k8==maxval);
 
 p_idxrow(3) = idxrow(1);
 p_idxcol(3) = idxcol(1);
 p_maxval(3) = maxval;
 
 hold on;
 gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
     80,'filled','k','MarkerEdgeColor','k');
 
 t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
     'P3');
 
 t.Color = 'w';
 
 Results_by_training_k8(idxrow,idxcol) = 0;
 
 [maxval maxloc] = max(Results_by_training_k8(:));
 [idxrow, idxcol] = find(Results_by_training_k8==maxval);
 
 p_idxrow(4) = idxrow(1);
 p_idxcol(4) = idxcol(1);
 p_maxval(4) = maxval;
 
 hold on;
 gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
     80,'filled','k','MarkerEdgeColor','k');
 
 t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
     'P4');
 
 t.Color = 'w';
 
 Results_by_training_k8(idxrow,idxcol) = 0;
 
 [maxval maxloc] = max(Results_by_training_k8(:));
 [idxrow, idxcol] = find(Results_by_training_k8==maxval);
 
 p_idxrow(5) = idxrow(1);
 p_idxcol(5) = idxcol(1);
 p_maxval(5) = maxval;
 
 hold on;
 gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
     80,'filled','k','MarkerEdgeColor','k');
 
 t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
     'P5');
 
 t.Color = 'w';
 
 h = get(gca,'Children');
 set(gca,'Children',flipud(h));
 
 bb = legend(strcat('P1 (',mat2str(training_cycles(p_idxrow(1),p_idxcol(1))),',',mat2str(training_set(p_idxrow(1),p_idxcol(1))),',',...
     mat2str(p_maxval(1)),'%)'),strcat('P2 (',mat2str(training_cycles(p_idxrow(2),p_idxcol(2))),',',mat2str(training_set(p_idxrow(2),p_idxcol(2))),',',...
     mat2str(p_maxval(2)),'%)'),strcat('P3 (',mat2str(training_cycles(p_idxrow(3),p_idxcol(3))),',',mat2str(training_set(p_idxrow(3),p_idxcol(3))),',',...
     mat2str(p_maxval(3)),'%)'),strcat('P4 (',mat2str(training_cycles(p_idxrow(4),p_idxcol(4))),',',mat2str(training_set(p_idxrow(4),p_idxcol(4))),',',...
     mat2str(p_maxval(4)),'%)'),strcat('P5 (',mat2str(training_cycles(p_idxrow(5),p_idxcol(5))),',',mat2str(training_set(p_idxrow(5),p_idxcol(5))),',',...
     mat2str(p_maxval(5)),'%)'));
 
 bb.Location = 'southeast';

    
      
     pos = pos + 1;

end



% [maxval maxloc] = max(Results_by_training_k8(:));
% [idxrow, idxcol] = find(Results_by_training_k8==maxval);
% 
% p_idxrow(1) = idxrow(1);
% p_idxcol(1) = idxcol(1);
% p_maxval(1) = maxval;
% 
% hold on;
% gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
%     80,'filled','k','MarkerEdgeColor','k');
% 
% 
% t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
%     'P1');
% 
% t.Color = 'w';
% 
% Results_by_training_k8(idxrow,idxcol) = 0;
% 
% [maxval maxloc] = max(Results_by_training_k8(:));
% [idxrow, idxcol] = find(Results_by_training_k8==maxval);
% 
% p_idxrow(2) = idxrow(1);
% p_idxcol(2) = idxcol(1);
% p_maxval(2) = maxval;
% 
% hold on;
% gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
%     80,'filled','k','MarkerEdgeColor','k');
% 
% t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
%     'P2');
% 
% t.Color = 'w';
% 
% 
% Results_by_training_k8(idxrow,idxcol) = 0;
% 
% [maxval maxloc] = max(Results_by_training_k8(:));
% [idxrow, idxcol] = find(Results_by_training_k8==maxval);
% 
% p_idxrow(3) = idxrow(1);
% p_idxcol(3) = idxcol(1);
% p_maxval(3) = maxval;
% 
% hold on;
% gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
%     80,'filled','k','MarkerEdgeColor','k');
% 
% t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
%     'P3');
% 
% t.Color = 'w';
% 
% Results_by_training_k8(idxrow,idxcol) = 0;
% 
% [maxval maxloc] = max(Results_by_training_k8(:));
% [idxrow, idxcol] = find(Results_by_training_k8==maxval);
% 
% p_idxrow(4) = idxrow(1);
% p_idxcol(4) = idxcol(1);
% p_maxval(4) = maxval;
% 
% hold on;
% gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
%     80,'filled','k','MarkerEdgeColor','k');
% 
% t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
%     'P4');
% 
% t.Color = 'w';
% 
% Results_by_training_k8(idxrow,idxcol) = 0;
% 
% [maxval maxloc] = max(Results_by_training_k8(:));
% [idxrow, idxcol] = find(Results_by_training_k8==maxval);
% 
% p_idxrow(5) = idxrow(1);
% p_idxcol(5) = idxcol(1);
% p_maxval(5) = maxval;
% 
% hold on;
% gg = scatter3(training_cycles(idxrow(1),idxcol(1)),training_set(idxrow(1),idxcol(1)),Results_by_training_k8(idxrow(1),idxcol(1)),...
%     80,'filled','k','MarkerEdgeColor','k');
% 
% t = text(training_cycles(idxrow(1),idxcol(1))-1,training_set(idxrow(1),idxcol(1))-1,Results_by_training_k8(idxrow(1),idxcol(1)), ...
%     'P5');
% 
% t.Color = 'w';
% 
% h = get(gca,'Children');
% set(gca,'Children',flipud(h));
% 
% bb = legend(strcat('P1 (',mat2str(training_cycles(p_idxrow(1),p_idxcol(1))),',',mat2str(training_set(p_idxrow(1),p_idxcol(1))),',',...
%     mat2str(p_maxval(1)),'%)'),strcat('P2 (',mat2str(training_cycles(p_idxrow(2),p_idxcol(2))),',',mat2str(training_set(p_idxrow(2),p_idxcol(2))),',',...
%     mat2str(p_maxval(2)),'%)'),strcat('P3 (',mat2str(training_cycles(p_idxrow(3),p_idxcol(3))),',',mat2str(training_set(p_idxrow(3),p_idxcol(3))),',',...
%     mat2str(p_maxval(3)),'%)'),strcat('P4 (',mat2str(training_cycles(p_idxrow(4),p_idxcol(4))),',',mat2str(training_set(p_idxrow(4),p_idxcol(4))),',',...
%     mat2str(p_maxval(4)),'%)'),strcat('P5 (',mat2str(training_cycles(p_idxrow(5),p_idxcol(5))),',',mat2str(training_set(p_idxrow(5),p_idxcol(5))),',',...
%     mat2str(p_maxval(5)),'%)'));
% 
% bb.Location = 'southeast';


