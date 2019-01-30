classdef OutputManager < handle
    %OUTPUTMANAGER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fighandles % array of figure handles
        TargetFolder
    end
    
    methods(Access = public)
        
        function obj.OutputManager(TargetFolder);
            if nargin ==1
                obj.TargetFolder=TargetFolder;
            end
        end
        
        function AddFigure(obj,fh)
            obj.fighandles=cat(1,obj.fighandles,fh);
            fh.WindowKeyPressFcn=@obj.MemberKeyPress;
        end
        
        function ChangeName(obj,figid,name)
            if ~isnumeric(figid)
                figid=find(obj.fighandles == figid);
            end
            obj.fighandles(figid).NumberTitle='Off';
            obj.fighandles(figid).Name=name;
        end
        
        function PickTargetFolder(obj);
            upath=uigetdir;
            %Do not change path if Selection is closed with 'X'
            if upath ~= 0
                obj.TargetFolder=upath;
            end
        end
        
        function SaveAllPDF(obj,figindex)
                for i=1:length(obj.fighandles)
                obj.SavePDF(i);
                end  
        end
        
        function SavePDF(obj,figindex)
             if exist(obj.TargetFolder) == 7               
                fighan=obj.fighandles(figindex);
                fname=obj.GenerateFileName(fighan);
                fighan.PaperPositionMode = 'auto';
                f1h_pos = fighan.PaperPosition;
                fighan.PaperSize = [f1h_pos(3) f1h_pos(4)];
                print(fighan,fname,'-dpdf','-r300');
            end    
        end
        
        function fname=GenerateFileName(obj,fighan)
            if strcmp(fighan.Name,'')
                figname=['Figure',num2str(fighan.Number)];
            else 
                figname=fighan.Name;
            end
            fname=[obj.TargetFolder,'\',figname,'.pdf'];
        end
        
        function Cascade(obj,figindex)
            hs=obj.fighandles(figindex).Position(1);
            vs=obj.fighandles(figindex).Position(2);
            for i=1:length(obj.fighandles)
                obj.fighandles(i).Position(1)=hs+i*10;
                obj.fighandles(i).Position(2)=vs+i*10;
            end
            obj.BringPlotsFront(figindex);
        end
            
        
        
        
        function CloseAll(obj)
            for i=1:length(obj.fighandles)
               obj.CloseOne(i);       
            end
        end        
        
        function CloseOne(obj,figindex)
            obj.fighandles(figindex).delete;
            obj.fighandles(figindex)= [];
        end
        
        function BringPlotsFront(obj,figindex)
            for i=1:length(obj.fighandles)
                %Just call figure with all handles
                figure(obj.fighandles(i))
            end
            %and lastly the one it's been called from
            figure(obj.fighandles(figindex));
        end
        
        function MakeAllThisSize(obj,figindex)
            hs=obj.fighandles(figindex).Position(3);
            vs=obj.fighandles(figindex).Position(4);
            for i=1:length(obj.fighandles)
                obj.fighandles(i).Position(3)=hs;
                obj.fighandles(i).Position(4)=vs;
            end
            drawnow            
        end
        
        function ShowPos(obj,figindex)
            obj.fighandles(figindex).Position
        end
        
        function SpreadFigures(obj)
            spreadfigures(obj.fighandles,'square');
        end
        
        function UpAll(obj)
            for i=1:length(obj.fighandles)
                obj.fighandles(i).Position(2)= ...
                    obj.fighandles(i).Position(2) + 10;                
            end
            drawnow            
        end
            
        function RightAll(obj)
            for i=1:length(obj.fighandles)
                obj.fighandles(i).Position(1)= ...
                    obj.fighandles(i).Position(1) + 10;                
            end
            drawnow            
        end
        
        function LeftAll(obj)
            for i=1:length(obj.fighandles)
                obj.fighandles(i).Position(1)= ...
                    obj.fighandles(i).Position(1) - 10;                
            end
            drawnow            
        end
        
         function DownAll(obj)
            for i=1:length(obj.fighandles)
                obj.fighandles(i).Position(2)= ...
                    obj.fighandles(i).Position(2) - 10;                
            end
            drawnow            
         end
       
         function ManageExisting(obj)
            obj.fighandles(~ishandle(obj.fighandles))=[];
         end
               
        
        function MemberKeyPress(obj,src,evt)
           obj.ManageExisting();
           figindex=find(obj.fighandles == src);
           if isempty(evt.Modifier)
                    switch evt.Key
                       case 'k'
                           obj.CloseOne(figindex);        
                        case 'p'
                            obj.ShowPos(figindex);
                        case 'f'
                            obj.BringPlotsFront(figindex);
                        case 's'
                            obj.SpreadFigures()
                        case 'uparrow'
                            obj.UpAll();
                        case 'downarrow'
                            obj.DownAll();
                        case 'leftarrow'
                            obj.LeftAll();
                        case 'rightarrow'
                            obj.RightAll();
                        case 'm'
                            obj.SavePDF(figindex);
                        case 'c'
                            obj.Cascade(figindex);
                   end
           else
               switch evt.Modifier{1}
               case 'control'
                   switch evt.Key
                       case 'k'
                           obj.CloseAll();
                       case 'r'
                           obj.MakeAllThisSize(figindex);
                       case 'n'
                           obj.PickTargetFolder();
                       case 'm'
                           obj.SaveAllPDF();
                   end
               end
           end
            
        end
    
        
    end
    
    

       
    
end

