function varargout = stats(varargin)
% STATS MATLAB code for stats.fig
%      STATS, by itself, creates a new STATS or raises the existing
%      singleton*.
%
%      H = STATS returns the handle to a new STATS or the handle to
%      the existing singleton*.
%
%      STATS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STATS.M with the given input arguments.
%
%      STATS('Property','Value',...) creates a new STATS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stats_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stats_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stats

% Last Modified by GUIDE v2.5 22-Mar-2017 04:34:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stats_OpeningFcn, ...
                   'gui_OutputFcn',  @stats_OutputFcn, ...
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


% --- Executes just before stats is made visible.
function stats_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stats (see VARARGIN)

% Choose default command line output for stats
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stats wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stats_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in saveTable.
function saveTable_Callback(hObject, eventdata, handles)
currentHandles = guihandles;
[f,p]=uiputfile({'*.xlsx'},'Save file name');
str=strcat(p,f);
tableHeader = get(currentHandles.statsTable,'ColumnName');
tableData = get(currentHandles.statsTable,'data');
disp(tableHeader);
disp(tableData);
A = [tableHeader.';tableData];
xlswrite(str,A);


% --- Executes on button press in closeStats.
function closeStats_Callback(hObject, eventdata, handles)
close;
