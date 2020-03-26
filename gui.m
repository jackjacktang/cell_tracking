function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 23-Mar-2017 11:12:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% % eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

handles.currentCellNo = 0;
newIcon = javax.swing.ImageIcon('logo.png');
figFrame = get(hObject,'JavaFrame');
figFrame.setFigureIcon(newIcon);

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(~, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;


% --------------------------------------------------------------------
function System_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)

% --- Executes on slider movement.
function imageNavigator_Callback(hObject, eventdata, handles)
currentPos = round(get(handles.imageNavigator,'Value'));
name = handles.fileNames{currentPos};
set(handles.fileName,'String',name)
set(handles.fileIndex,'String',strcat(num2str(currentPos),'/',num2str(handles.imgAmount)));
showSuper = get(handles.showSuperpixel,'Value');
axes(handles.originalFrame)

% show/hide superpixel segmentation result
if showSuper == 0
    imshow(handles.images{currentPos})
elseif showSuper == 1
    imshow(handles.contourImg{currentPos})
else
    h = msgbox('Error');
end

% show avialable tracking results of the current image
if (isfield(handles,'positionGraph') == true && get(handles.showLabel,'Value') == 1)
    cellLength = size(handles.positionGraph);
    for i = 1:cellLength(2)
        positionLength = size(handles.positionGraph{i});
        if positionLength(1) >= currentPos 
            j = currentPos;
            x = handles.positionGraph{i}(j,1);
            y = handles.positionGraph{i}(j,2);
            text = insertText(getimage(handles.originalFrame),[x,y],strcat(num2str(i),'/',num2str(x),'/',num2str(y)),'TextColor','red','FontSize',30);
            axes(handles.originalFrame);
            imshow(text);
        end
    end
end

% --- Executes during object creation, after setting all properties.
function imageNavigator_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in openFolder.
function openFolder_Callback(hObject, eventdata, handles)
if isfield(hObject.UserData, 'default')
%     disp(hObject.UserData.default)
end
if ~isfield(hObject.UserData, 'default') || ~ischar(hObject.UserData.default)
    hObject.UserData.default = '.';
end

% trace the current filepath
folderpath = uigetdir(hObject.UserData.default,'Select Input Folder');
% if no paths selected
if(folderpath == 0)
    return;
end
folderpath = strcat(folderpath,'\');
imagefiles = dir(strcat(folderpath,'\*.*'));
nfiles = length(imagefiles);

h = msgbox('Loading');

index = 1;
% load files
for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   fileNames{index} = currentfilename;
   % avoid to open the current directory or parent directory as files
   if strcmp(currentfilename,'.') == 1 || strcmp(currentfilename,'..') == 1
       continue
   end
   currentimage = imread(strcat(folderpath,currentfilename));
   [d1,d2,d3] = size(currentimage);
   if d3 ~= 1
       currentimage = rgb2gray(currentimage);
   end
   images{index} = currentimage;
   groundTruth{index} = [];
   superNo{index} = [];
   index = index+1;
   % TODO: reset the cellno/cell to track no
end
delete(h)
handles.images = images;
handles.fileNames = fileNames;
handles.groundTruth = groundTruth;
handles.superNo = superNo;
handles.imgAmount = index-1;
guidata(hObject,handles);
set(handles.imageNavigator,'Max',index-1);
set(handles.imageNavigator,'SliderStep',[1/(index-1),10/(index-1)]);
set(handles.fileName,'String',fileNames{1});
set(handles.fileIndex,'String',strcat(num2str(1),' / ',num2str(index-1)));
axes(handles.originalFrame);
imshow(images{1});

% --- Executes on button press in showSuperpixel.
function showSuperpixel_Callback(hObject, eventdata, handles)
value = get(handles.showSuperpixel,'Value');
currentPos = round(get(handles.imageNavigator,'Value'));

% show/hide superpixel segmentation result
if value == 1
    contourImg = handles.contourImg;
    axes(handles.originalFrame);
    imshow(contourImg{currentPos});
    set(handles.showSuperpixel,'Value',1);
elseif value == 0
    cla(handles.originalFrame);
    axes(handles.originalFrame);
    imshow(handles.images{currentPos});
    set(handles.showSuperpixel,'Value',0);
end

% show avialable tracking results of the current image
if (isfield(handles,'positionGraph') == true && get(handles.showLabel,'Value') == 1)
    cell_length = size(handles.positionGraph);
    for i = 1:cell_length(2)
        positionSize = size(handles.positionGraph{i});
        if positionSize(1) < currentPos
            continue;
        end
        x = handles.positionGraph{i}(currentPos,1);
        y = handles.positionGraph{i}(currentPos,2);
        text = insertText(getimage(handles.originalFrame),[x,y],strcat(num2str(i),'/',num2str(x),'/',num2str(y)),'TextColor','red','FontSize',30);
        axes(handles.originalFrame);
        imshow(text);
    end
end

% --- Executes on button press in showLabel.
function showLabel_Callback(hObject, eventdata, handles)
value = get(handles.showLabel,'Value');
showSuper = get(handles.showSuperpixel,'Value');
currentPos = round(get(handles.imageNavigator,'Value'));

% show/hide label
if value == 1
    if (isfield(handles,'positionGraph') == true)
    cell_length = size(handles.positionGraph);
        for i = 1:cell_length(2)
            positionSize = size(handles.positionGraph{i});
            if positionSize(1) < currentPos
                continue;
            end
            x = handles.positionGraph{i}(currentPos,1);
            y = handles.positionGraph{i}(currentPos,2);
            text = insertText(getimage(handles.originalFrame),[x,y],strcat(num2str(i),'/',num2str(x),'/',num2str(y)),'TextColor','red','FontSize',30);
            axes(handles.originalFrame);
            imshow(text);
        end
    end
elseif value == 0
    if showSuper == 1
        contourImg = handles.contourImg;
        axes(handles.originalFrame);
        imshow(contourImg{currentPos});
    elseif showSuper == 0
        cla(handles.originalFrame);
        axes(handles.originalFrame);
        imshow(handles.images{currentPos});
    end
end

% --- Executes on button press in applySLIC.
function applySLIC_Callback(hObject, eventdata, handles)
images = handles.images;
index = 1;
h = msgbox('Applying Superpixel Segmentation...');
for i = 1:handles.imgAmount
%     h = msgbox(strcat('Applying Superpixel Segmentation on ',int2str(i),'/',int2str(handles.imgAmount)));
    j = adapthisteq(images{i});
    segments{index} = vl_slic(im2single(cat(3,j,j,j)),30,0.005);
    contourImg{index} = draw_contours(segments{index}, im2single(cat(3,j,j,j)));
    index = index + 1;
end
delete(h);
handles.contourImg = contourImg;
handles.segments = segments;
guidata(hObject,handles);
axes(handles.originalFrame);
imshow(contourImg{1});
set(handles.showSuperpixel,'Enable','on');
set(handles.showSuperpixel,'Value',1);
h = msgbox('Superpixel Segmentation finished');

    


% --- Executes on slider movement.
function segmentsNo_Callback(hObject, eventdata, handles)
currentPos = round(get(handles.segmentsNo,'Value'))
set(handles.currentSegmentsNo,'String',currentPos)

% --- Executes during object creation, after setting all properties.
function segmentsNo_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in markGroundTruth.
function markGroundTruth_Callback(hObject, eventdata, handles)
try
if (isfield(handles,'images') == false)
    h = msgbox('No images found!');
    return;
end
if (isfield(handles,'segments') == false)
    h = msgbox('No segments found! Please Apply SLIC!');
    return;
end
currentPos = round(get(handles.imageNavigator,'Value'));
set(handles.markGroundTruth,'Enable','inactive');
axes(handles.originalFrame);
[x,y] = ginput(1);
super = handles.segments{currentPos};
superNo = super(round(y),round(x));
handles.superNo{currentPos} = [handles.superNo{currentPos};superNo] ;
[locx,locy] = find(handles.segments{currentPos} == superNo);
x = round(mean(locy));
y = round(mean(locx));
handles.groundTruth{currentPos} = [handles.groundTruth{currentPos};[x,y]];
if handles.currentCellNo == 0
    handles.currentCellNo = 1;
else
    handles.currentCellNo = handles.currentCellNo + 1;
end
guidata(hObject,handles);
handles.positionGraph{handles.currentCellNo} = [x,y,1];
guidata(hObject,handles);
set(handles.cellNoToTrack,'String',[get(handles.cellNoToTrack,'String');num2str(handles.currentCellNo)]);
set(handles.manualNo,'String',[get(handles.manualNo,'String');num2str(handles.currentCellNo)]);
h = msgbox('Adding into ground truth.');
text = insertText(getimage(handles.originalFrame),[x,y],strcat(num2str(handles.currentCellNo),'/',num2str(x),'/',num2str(y)),'TextColor','red','FontSize',30);
delete(h);
axes(handles.originalFrame);
imshow(text);
set(handles.markGroundTruth,'Enable','on');
set(handles.showLabel,'Enable','on');
set(handles.showLabel,'Value',1);
catch
    set(handles.markGroundTruth,'Enable','on');
end

% --- Executes on button press in generatePositionGraph.
function generatePositionGraph_Callback(hObject, eventdata, handles)
cellNo = get(handles.cellNoToTrack,'Value');
temp = handles.positionGraph{cellNo};
handles.positionGraph{cellNo} = handles.positionGraph{cellNo}(1,:);
guidata(hObject, handles);

% Original cell intensity histogram
originalHistogram = getIntensityStats(hObject, eventdata, handles,1,handles.superNo{1}(cellNo),cellNo);
allItems = get(handles.trackingRadius,'string');
selectedIndex = get(handles.trackingRadius,'Value');
trackingRadius = allItems{selectedIndex};

for imgNo = 2:handles.imgAmount
    loc = handles.positionGraph{cellNo}(imgNo-1,:);
    tempSize = size(temp);
    if (tempSize(1,1)>= imgNo) && (temp(imgNo,3) == 1)
        locx = round(temp(imgNo,1));
        locy = round(temp(imgNo,2));
        handles.positionGraph{cellNo} = [handles.positionGraph{cellNo};[locx,locy,1]];
        segNo = handles.segments{imgNo}(locy,locx);
        originalHistogram = getIntensityStats(hObject, eventdata, handles,imgNo,segNo,cellNo);
    else
    radius = handles.segments{imgNo}(loc(2)-trackingRadius:loc(2)+trackingRadius,loc(1)-trackingRadius:loc(1)+trackingRadius);
    radius = unique(radius);

    % Extract candidate cell intensity histograms
    for i= 1:size(radius)
        candidate = getIntensityStats(hObject, eventdata, handles,imgNo,radius(i),cellNo);
        minIntensity = getMinIntensity(hObject, eventdata, handles,imgNo,radius(i),cellNo);
        difference(i) = norm(originalHistogram-candidate);
    end
    % find the index of superpixel with the minimum difference index I
    [M,I] = min(difference);
    [locx,locy] = find(handles.segments{imgNo} == radius(I));
    handles.positionGraph{cellNo} = [handles.positionGraph{cellNo};[round(mean(locy)),round(mean(locx)),0]];
    originalHistogram = getIntensityStats(hObject, eventdata, handles,imgNo,radius(I),cellNo);
    end
    guidata(hObject, handles);
end
axes(handles.resultFrame);
for i = 2:handles.imgAmount
    dp = handles.positionGraph{cellNo}(i,:)-handles.positionGraph{cellNo}(i-1,:);
    quiver(handles.positionGraph{cellNo}(i-1,1),handles.positionGraph{cellNo}(i-1,2),dp(1),dp(2),'AutoScale','off');
    hold on;
end
set(handles.resultFrame,'YDir','Reverse');


% --- Executes on selection change in cellNoToTrack.
function cellNoToTrack_Callback(hObject, eventdata, handles)
% hObject    handle to cellNoToTrack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function cellNoToTrack_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Calculate the average intensity histogram stats for a superpixel
function histogram = getIntensityStats(hObject, eventdata,handles,imageNo,superNo,cellNo)
[row,col] = find(handles.segments{imageNo} == superNo);
superSize = size(row);
histogram = zeros(1,256);
for i = 1:superSize(1)
    index = handles.images{imageNo}(row(i),col(i));
    histogram(index+1) = histogram(index+1) + 1;
end
for i = 1:256
    histogram(i) = histogram(i)/superSize(1);
end
    
function minIntensity = getMinIntensity(hObject, eventdata,handles,imageNo,superNo,cellNo)
[row,col] = find(handles.segments{imageNo} == superNo);
superSize = size(row);
minIntensity = handles.images{1}(row(1),col(1));
for i = 2:superSize(1)
    if (handles.images{1}(row(i),col(i)) < minIntensity)
        minIntensity = handles.images{1}(row(i),col(i));
    end
end

% --- Executes on button press in saveResult.
function saveResult_Callback(hObject, eventdata, handles)
open('result.fig');
resultHandler = guihandles;
r = get(handles.resultFrame,'children');
copyobj(r,resultHandler.result);
set(resultHandler.result,'YDir','Reverse');


% --- Executes on button press in clearGraph.
function clearGraph_Callback(hObject, eventdata, handles)
cla(handles.resultFrame,'reset')

% --- Executes on button press in generateStats.
function generateStats_Callback(hObject, eventdata, handles)
open('stats.fig');
statsHandler = guihandles;
d={};
for i=1:handles.currentCellNo
    graph = handles.positionGraph{i};
    max = size(graph);
    d{i,1} = i;
    tol = 0;
    for j=1:max(1)-1
        distance = norm(graph(j,:)-graph(j+1,:));
        d{i,j+3} = distance;
        tol = tol + distance;
    end
    d{i,2} = tol/(max(1)-1);
    d{i,3} = tol;
end

colName = {};
for i=1:handles.imgAmount-1
    colName = cat(2,colName,{strcat(num2str(i),'~',num2str(i+1))});
end
colName = cat(2,{'Cell No.','Average Speed','Total Distance Travelled'},colName);
statsHandler.statsTable.ColumnWidth{2} = 130;
statsHandler.statsTable.ColumnWidth{3} = 130;
set(statsHandler.statsTable,'Data',d);
set(statsHandler.statsTable,'ColumnName',colName);



% --- Executes on selection change in trackingRadius.
function trackingRadius_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns trackingRadius contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trackingRadius


% --- Executes during object creation, after setting all properties.
function trackingRadius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trackingRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [contourImg] = draw_contours(labels, img)
% function [contourImg] = draw_contours(labels, img)
%
% David Stutz <david.stutz@rwth-aachen.de>

    rows = size(img, 1);
    cols = size(img, 2);

    contourImg = img;
    for i = 1: rows
        for j = 1: cols
            label = labels(i, j);
            labelTop = 0;
            labelBottom = 0;
            labelLeft = 0;
            labelRight = 0;

            if i > 1
                labelTop = labels(i - 1, j);
            end;
            if j > 1
                labelLeft = labels(i, j - 1);
            end;
            if i < rows
                labelBottom = labels(i + 1, j);
            end;
            if j < cols
                labelRight = labels(i, j + 1);
            end;

            if labelTop ~= 0 && labelTop ~= label
                contourImg(i, j, 1) = 0;
                contourImg(i, j, 2) = 0;
                contourImg(i, j, 3) = 0;
            end;
            if labelLeft ~= 0 && labelLeft ~= label
                contourImg(i, j, 1) = 0;
                contourImg(i, j, 2) = 0;
                contourImg(i, j, 3) = 0;
            end;
            if labelBottom ~= 0 && labelBottom ~= label
                contourImg(i, j, 1) = 0;
                contourImg(i, j, 2) = 0;
                contourImg(i, j, 3) = 0;
            end;
            if labelRight ~= 0 && labelRight ~= label
                contourImg(i, j, 1) = 0;
                contourImg(i, j, 2) = 0;
                contourImg(i, j, 3) = 0;
            end;
        end;
    end;


% --- Executes on selection change in manualNo.
function manualNo_Callback(hObject, eventdata, handles)
% hObject    handle to manualNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns manualNo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from manualNo


% --- Executes during object creation, after setting all properties.
function manualNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to manualNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in manualCorrect.
function manualCorrect_Callback(hObject, eventdata, handles)
try
[x,y] = ginput(1);
currentCellNo = get(handles.cellNoToTrack,'Value');
currentPos = round(get(handles.imageNavigator,'Value'));
handles.positionGraph{currentCellNo}(currentPos,1) = round(x);
handles.positionGraph{currentCellNo}(currentPos,2) = round(y);
handles.positionGraph{currentCellNo}(currentPos,3) = 1;
set(handles.markGroundTruth,'Enable','inactive');
guidata(hObject, handles);

% show avialable tracking results of the current image
if (isfield(handles,'positionGraph') == true)
    cellLength = size(handles.positionGraph);
    for i = 1:cellLength(2)
        positionLength = size(handles.positionGraph{i});
        if positionLength(1) >= currentPos 
            j = currentPos;
            x = handles.positionGraph{i}(j,1);
            y = handles.positionGraph{i}(j,2);
            text = insertText(getimage(handles.originalFrame),[x,y],strcat(num2str(i),'/',num2str(x),'/',num2str(y)),'TextColor','red','FontSize',30);
            axes(handles.originalFrame);
            imshow(text);
        end
    end
end
set(handles.markGroundTruth,'Enable','on');
catch
    set(handles.markGroundTruth,'Enable','on');
end


% --------------------------------------------------------------------
function AboutInformation_Callback(hObject, eventdata, handles)
open('about.fig');
aboutHandler = guihandles;
axes(aboutHandler.logo);
imshow('logo.png');
set(aboutHandler.logo,'Visible','On');
axis off;

% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
close all;
