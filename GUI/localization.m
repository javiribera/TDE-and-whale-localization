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
function localization_OpeningFcn(hObject, ~, handles, varargin)

    % Choose default command line output for localization
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes localization wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    addpath('utils');

 
% --- Outputs from this function are returned to the command line.
function varargout = localization_OutputFcn(~, ~, handles)
    % Get default command line output from handles structure
    varargout{1} = handles.output;


function localize_button_Callback(~, ~, handles)
    % get the TDEs from the GUI
    delay = [str2num(get(handles.delay1, 'String'))
             str2num(get(handles.delay2, 'String'))
             str2num(get(handles.delay3, 'String'))
             str2num(get(handles.delay4, 'String'))
             str2num(get(handles.delay5, 'String'))
             str2num(get(handles.delay6, 'String'))];
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
    % % in km.
    sensors_pos = [ sensor1;
                    sensor2;
                    sensor3;
                    sensor4;
                    sensor5;
                    sensor6;
                    sensor7;
                  ];
              
    % which axis to fix
    if get(handles.fix_axis_x_option,'Value')
        fix_axis = 'x';
    elseif get(handles.fix_axis_y_option,'Value')
        fix_axis = 'y';
    elseif get(handles.fix_axis_z_option,'Value')
        fix_axis = 'z';
    end
          
    % plot sensors as points and label them
    plot(handles.axes_localization,sensors_pos(:,1),sensors_pos(:,2),'.');
    text(sensors_pos(1,1),sensors_pos(1,2),'  1');
    text(sensors_pos(2,1),sensors_pos(2,2),'  2');
    text(sensors_pos(3,1),sensors_pos(3,2),'  3');
    text(sensors_pos(4,1),sensors_pos(4,2),'  4');
    text(sensors_pos(5,1),sensors_pos(5,2),'  5');
    text(sensors_pos(6,1),sensors_pos(6,2),'  6');
    text(sensors_pos(7,1),sensors_pos(7,2),'  7');
    
    % get reference sensor from GUI
    menu_options = cellstr(get(handles.reference_micro_menu,'String'));
    reference = str2double(menu_options{get(handles.reference_micro_menu,'Value')});

    % plot beautify
    combination_sensors=[];
    l=0;
    for d=1:6
        l=l+1;
        if d==reference
            l=l+1;
        end
        combination_sensors{d}=[num2str(reference), '-',num2str(l)];
    end
    title(['TDOA. blue ',combination_sensors{1},'   ',...
           'red ',combination_sensors{2}, '   ',...
           'green ', combination_sensors{3},'   ',...
           'yellow ', combination_sensors{4},'   ',...
           'black ', combination_sensors{5},'   ',...
           'magenta ', combination_sensors{6}]);
    ylabel('y(m)');  xlabel('x(m)');
    axis(3*[min(sensors_pos(:,1)) max(sensors_pos(:,1)) min(sensors_pos(:,2)) max(sensors_pos(:,2))]);

    % plot hyperbolas of TDEs
    hold on;
    colors={'b','r','g','y','k','m'};
    s=0;
    for d=1:6
        s=s+1;
        if d==reference
           s=s+1;
        end
        plot_hyp(sensors_pos(reference,1), sensors_pos(reference,2), ...
                sensors_pos(s,1), sensors_pos(s,2), ...
                -delay(d)*sound_speed/2,colors{d});
    end
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

function import_file_Callback(~, ~, handles)
    % select file and load its name and path
    [results_FileName,results_PathName,~] = uigetfile({'*.mat','MATLAB file (*.mat)'},...
                                                    'Select a file with results');
    % warn filename and first parent folder
    for i=length(results_PathName)-1:-1:1
        if(strcmp(results_PathName(i),filesep))
            break
        end
    end
    set(handles.file_text,'String',[results_PathName(i+1:end),results_FileName]);

    % import results from file
    global T1;
    load([results_PathName, results_FileName]);

function reference_micro_menu_Callback(hObject, ~, handles)
    menu_options = cellstr(get(hObject,'String'));
    reference = str2double(menu_options{get(hObject,'Value')});
    
    % change labels in GUI
    labels = [handles.delay1_label, handles.delay2_label, handles.delay3_label,...
              handles.delay4_label, handles.delay5_label, handles.delay6_label ];
    l=0;
    for d=1:6
        l=l+1;
        if d==reference
            l=l+1;
        end
        set(labels(d),'String', [num2str(reference), '-',num2str(l)]);
    end
    
    % place delays in the GUI's textfields if not in manual case
    global T1;
    if ~isempty(T1)
        event = get(handles.event_set_menu,'Value') - 1 ;
        delay_textfields_upload(T1.event(event).delay, reference, handles)
    end
    
function event_set_menu_Callback(hObject, ~, handles)
    global T1;
    
    % selected event
    event = get(hObject,'Value') - 1 ;
    if ~strcmp(event,'Custom (manual)') && isempty(T1)
        msgbox('Import a file with  precomputed TDEs before selecting an event',...
            'Import a file first','warn')
    end
    
    % selected reference sensor
    references_menu_options = cellstr(get(handles.reference_micro_menu,'String'));
    reference = str2double(references_menu_options{get(handles.reference_micro_menu,'Value')});
    
    % place delays in the GUI's textfields
    delay_textfields_upload(T1.event(event).delay, reference, handles)
    
function delay_textfields_upload(delays, reference, handles)
    textfields = [handles.delay1, handles.delay2, handles.delay3,...
                  handles.delay4, handles.delay5, handles.delay6 ];
    t=0;
    for d=1:length(textfields)
        t=t+1;
        if d==reference
            t=t+1;
        end
        set(textfields(d),'String', delays(reference,t).seconds)
    end

function fix_axis_x_option_Callback(hObject, ~, handles)
    fix_x_enabled = get(hObject,'Value');
    if fix_x_enabled
        set(handles.fix_axis_y_option,'Value',0);
        set(handles.fix_axis_z_option,'Value',0);
    end

% --- Executes on button press in fix_axis_y_option.
function fix_axis_y_option_Callback(hObject, ~, handles)
    fix_y_enabled = get(hObject,'Value');
    if fix_y_enabled
        set(handles.fix_axis_x_option,'Value',0);
        set(handles.fix_axis_z_option,'Value',0);
    end


% --- Executes on button press in fix_axis_z_option.
function fix_axis_z_option_Callback(hObject, ~, handles)
    fix_z_enabled = get(hObject,'Value');
    if fix_z_enabled
        set(handles.fix_axis_x_option,'Value',0);
        set(handles.fix_axis_y_option,'Value',0);
    end
