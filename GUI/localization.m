function varargout = localization(varargin)
    % LOCALIZATION MATLAB code for localization.fig
    %      LOCALIZATION, by itself, creates a new LOCALIZATION or raises the existing
    %      singleton*.
    %
    %      H = LOCALIZATION returns the handle to a new LOCALIZATION or the handle to
    %      the existing singleton*.
    %
    %      LOCALIZATION('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in LOCALIZATION.M with the given input arguments.
    %
    %      LOCALIZATION('Property','Value',...) creates a new LOCALIZATION or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before localization_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to localization_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help localization

    
    % Change always to root folder
    currentpath=pwd;
    if(strcmp(currentpath(end-2:end),'GUI'))
        cd ..
        addpath('GUI')
    end

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @localization_OpeningFcn, ...
                       'gui_OutputFcn',  @localization_OutputFcn, ...
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


% --- Executes just before localization is made visible.
function localization_OpeningFcn(hObject, eventdata, handles, varargin)

    % Choose default command line output for localization
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes localization wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    addpath('utils');

 
% --- Outputs from this function are returned to the command line.
function varargout = localization_OutputFcn(hObject, eventdata, handles)
    % Get default command line output from handles structure
    varargout{1} = handles.output;


function localize_button_Callback(~, ~, handles)
    % get the TDEs from the GUI
    delay12 = str2num(get(handles.delay12, 'String'));
    delay13 = str2num(get(handles.delay13, 'String'));
    delay14 = str2num(get(handles.delay14, 'String'));
    delay15 = str2num(get(handles.delay15, 'String'));
    delay16 = str2num(get(handles.delay16, 'String'));
    delay17 = str2num(get(handles.delay17, 'String'));
    % in secs.
    
    % get the speed of sound from the GUI
    if (isempty(get(handles.sound_speed,'String')))
        msgbox('Type the speed of sound in the textfield of the GUI',...
            'Speed of sound?','warn')
        return
    end    
    sound_speed=str2num(get(handles.sound_speed,'String')); % m/s
    
    % position of the sensors in an array
    sensor1 = [6566 -9617 -4500];%/1000;
    sensor2 = [6635 -2132 -4500];%/1000;
    sensor3 = [6520 5240 -4650];%/1000;
    sensor4 = [6865 12844 -4750];%/1000;
    sensor5 = [-6163 -12402 -4600];%/1000;
    sensor6 = [-6183 -4874 -4650];%/1000;
    sensor7 = [-6129 9784 -4750];%/1000;
    % in km.
    sensors_pos = [ sensor1;
                    sensor2;
                    sensor3;
                    sensor4;
                    sensor5;
                    sensor6;
                    sensor7;
                  ];
          
    % plot sensors as points and label them
    plot(handles.axes_localization,sensors_pos(:,1),sensors_pos(:,2),'.');
    text(sensors_pos(1,1),sensors_pos(1,2),'  1');
    text(sensors_pos(2,1),sensors_pos(2,2),'  2');
    text(sensors_pos(3,1),sensors_pos(3,2),'  3');
    text(sensors_pos(4,1),sensors_pos(4,2),'  4');
    text(sensors_pos(5,1),sensors_pos(5,2),'  5');
    text(sensors_pos(6,1),sensors_pos(6,2),'  6');
    text(sensors_pos(7,1),sensors_pos(7,2),'  7');
    
    % plot beautify
    title('TDOA. blue 1-2   red 1-3    green 1-4   yellow 1-5   black 1-6    magenta  1-7')
    ylabel('y(m)');  xlabel('x(m)');
    axis(3*[min(sensors_pos(:,1)) max(sensors_pos(:,1)) min(sensors_pos(:,2)) max(sensors_pos(:,2))]);

    % plot hyperbolas of TDEs
    hold on;
    plot_hyp(sensors_pos(1,1), sensors_pos(1,2), ...
            sensors_pos(2,1), sensors_pos(2,2), ...
            -delay12*sound_speed/2,'b');
    plot_hyp(sensors_pos(1,1), sensors_pos(1,2), ...
            sensors_pos(3,1), sensors_pos(3,2), ...
            -delay13*sound_speed/2,'r');
        plot_hyp(sensors_pos(1,1), sensors_pos(1,2), ...
            sensors_pos(4,1), sensors_pos(4,2), ...
            -delay14*sound_speed/2,'g');
        plot_hyp(sensors_pos(1,1), sensors_pos(1,2), ...
            sensors_pos(5,1), sensors_pos(5,2), ...
            -delay15*sound_speed/2,'y');
        plot_hyp(sensors_pos(1,1), sensors_pos(1,2), ...
            sensors_pos(6,1), sensors_pos(6,2), ...
            -delay16*sound_speed/2,'k');
        plot_hyp(sensors_pos(1,1), sensors_pos(1,2), ...
            sensors_pos(7,1), sensors_pos(7,2), ...
            -delay17*sound_speed/2,'m');
    hold off;

function toogle_debug_Callback(hObject, ~, ~)
    global DEBUG;
    if DEBUG
        DEBUG = 0;
        set(hObject,'Label', 'Enable DEBUG')
    else
        DEBUG = 1;
        set(hObject,'Label', 'Disable DEBUG')
    end
    
function toolbar_Callback(hObject, ~, handles)
    if(strcmp(get(hObject,'Label'), 'Show Toolbar'))
        set(hObject,'Label', 'Hide Toolbar')
        set(handles.figure1,'Toolbar','figure')
    else
        set(hObject,'Label', 'Show Toolbar')
        set(handles.figure1,'Toolbar','none')
    end
        
function plot_3D_sensors_Callback(~, ~, ~)
    addpath 'utils'
    plot3Dsensors
