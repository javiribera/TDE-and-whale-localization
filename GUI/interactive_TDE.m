function varargout = interactive_TDE(varargin)
    %      interactive_TDE('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in interactive_TDE.M with the given input arguments.
    
    % Change always to root folder
    currentpath=pwd;
    if(strcmp(currentpath(end-2:end),'GUI'))
        cd ..
        addpath('GUI')
    end
    
    % DO NOT EDIT (cosas xungas de MATLAB)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @interactive_TDE_OpeningFcn, ...
                       'gui_OutputFcn',  @interactive_TDE_OutputFcn, ...
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
    % End  DO NOT EDIT


% --- Executes just before interactive_TDE is made visible.
function interactive_TDE_OpeningFcn(hObject, ~, handles, varargin)
    % Choose default command line output for interactive_TDE
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes interactive_TDE wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    % plot indications for the user
    set(get(0,'CurrentFigure'),'CurrentAxes',handles.axes_data1)
    text(0.25,0.5,'Select an hydrophone 1 and plot it')
    set(get(0,'CurrentFigure'),'CurrentAxes',handles.axes_data2)
    text(0.25,0.5,'Select an hydrophone 2 and plot it')
    
    % reset global variables
    clear all; clc;


% --- Outputs from this function are returned to the command line.
function varargout = interactive_TDE_OutputFcn(~, ~, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles;


function select_hydrophone1_Callback(hObject, ~, handles)
    % select file and load its name and path
    global data1_FileName data1_PathName;
    [data1_FileName,data1_PathName,~] = uigetfile({'*.wav','Raw samples (*.wav)'},...
                                                    'Select the recording of hydrophone 1');
    % warn filename and first parent folder
    for i=length(data1_PathName)-1:-1:1
        if(strcmp(data1_PathName(i),filesep))
            break
        end
    end
    set(handles.selected_file1_text,'String',[data1_PathName(i+1:end),data1_FileName]);
    
function select_hydrophone2_Callback(~, ~, handles)
    % select file and load its name and path
    global data2_FileName data2_PathName;
    [data2_FileName,data2_PathName,~] = uigetfile({'*.wav','Raw samples'},...
                                                    'Select the recording of hydrophone 2');
    % warn filename and first parent folder
    for i=length(data2_PathName)-1:-1:1
        if(strcmp(data2_PathName(i),filesep))
            break
        end
    end
    set(handles.selected_file2_text,'String',[data2_PathName(i+1:end),data2_FileName]);
    

function load_data_Callback(~, ~, handles)
    % Warn loading
    set(handles.in_progress_text,'String','Loading... hold on a sec.'); drawnow

    % Compute the time periods
    if(~get(handles.all_signal_select,'Value'))
        Ti_minutes = str2double(get(handles.Ti_minutes_edit,'String'));
        Tf_minutes = str2double(get(handles.Tf_minutes_edit,'String'));
        Ti_seconds = str2double(get(handles.Ti_seconds_edit,'String'));
        Tf_seconds = str2double(get(handles.Tf_seconds_edit,'String'));    
        Ti = Ti_minutes*60 + Ti_seconds;
        Tf = Tf_minutes*60 + Tf_seconds;
    end
    
    % Load the data
    global data1_FileName data1_PathName;
    global data2_FileName data2_PathName;
    global data1 data2 Fs;
    [data1,Fs]=wavread([data1_PathName,data1_FileName]);
    [data2,~]=wavread([data2_PathName,data2_FileName]);
    if(~get(handles.all_signal_select,'Value'))
        data1 = data1(Ti*Fs :  Tf*Fs);
        data2 = data2(Ti*Fs :  Tf*Fs);
    end
    
    % create players
    global data1_player data2_player;
    addpath 'utils'
    data1_player = audioplayer(scale_signal(data1,-1,1),Fs);
    data2_player = audioplayer(scale_signal(data2,-1,1),Fs);
    
    % Warn loaded
    set(handles.in_progress_text,'String','Loaded :)');
    set(handles.sampling_frequency_text,'String',[num2str(Fs/1000), ' KHz']);
    
function visualize_plot_button_Callback(~, ~, handles)
    global data1 data2 Fs;
    
    % warn user starting
    set(handles.plotting, 'String', 'Plotting...')
    set(handles.plotting, 'Visible', 'on')
    set(get(0,'CurrentFigure'),'CurrentAxes',handles.axes_data1)
    cla; text(0.4,0.5,'In progress...')
    set(get(0,'CurrentFigure'),'CurrentAxes',handles.axes_data2)
    cla; text(0.4,0.5,'In progress...')
    drawnow

    options = cellstr(get(handles.plot_options,'String'));
    selected = options{get(handles.plot_options,'Value')};
    switch selected
        case 'Time domain'
            plot(handles.axes_data1,data1);
            plot(handles.axes_data2,data2);
        case 'Spectrogram'
            N=str2double(get(handles.points_dft,'String'));
            win_length=str2double(get(handles.win_length,'String'));
            
            [S,F,T,P] = spectrogram(data1,win_length,floor(250/256)*N,N,Fs);
            surf(handles.axes_data1,T,F/1000,10*log10(P),'edgecolor','none'); 
            view(handles.axes_data1,0,90);
            ylabel('KHz'); axis tight
            drawnow
                        
            [S,F,T,P] = spectrogram(data1,win_length,floor(250/256)*N,N,Fs);
            surf(handles.axes_data2,T,F/1000,10*log10(P),'edgecolor','none');
            view(handles.axes_data2,0,90);
            ylabel('KHz'); axis tight
            drawnow
    end
    
    % warn user end
    set(handles.plotting, 'String', 'Plotted')

function tdoa_plot_button_Callback(~, ~, handles)
    % warn user starting
    set(handles.working_go,'String','Working...')
    set(get(0,'CurrentFigure'),'CurrentAxes',handles.axes_tdoa)
    cla; text(0.4,0.5,'In progress...')
    drawnow
    
    tdoa(handles,'in_guide');
    
    % warn user work done
    set(handles.working_go,'String','Done :)');

function plot_tdoa_separate_window_Callback(~, ~, handles)
    set(handles.working_window,'String','Working...'); drawnow;
    tdoa(handles,'separate_window');
    set(handles.working_window,'String','Done :)');
   
function tdoa(handles,where)
    global data1 data2 Fs;
    
    % get preprocessing methods selected in the GUI
    preprocessing_methods = {};
    if(get(handles.remove_mean_option,'Value')==1)
        preprocessing_methods{end+1} = 'remove_mean';
    end
    if(get(handles.band_pass_option,'Value')==1)
        preprocessing_methods{end+1} = 'band_pass';
    end
    if(get(handles.time_gain_option,'Value')==1)
        preprocessing_methods{end+1} = 'time_gain';
        time_gain_params = struct('alpha',str2num(get(handles.alpha_tg_text,'String')),...
                                    'r',str2num(get(handles.r_text,'String')));
    else
        time_gain_params = [];
    end
    if(get(handles.spectral_substraction_option,'Value')==1)
        preprocessing_methods{end+1} = 'spectral_substraction';
        spectral_substraction_params = struct('alpha',str2num(get(handles.alpha_ss_text,'String')),...
                                    'beta',str2num(get(handles.beta_ss_text,'String')));
    else
        spectral_substraction_params = [];
    end
    if(get(handles.percentile_option,'Value')==1)
        preprocessing_methods{end+1} = 'percentile';
        percentile_params = struct('percentil',str2num(get(handles.percentil_text,'String')),...
                                    'c',str2num(get(handles.c_text,'String')));
    else
        percentile_params = [];
    end
    
    % preprocess signals
    preprocessed_signal1 = clean_signal(data1, preprocessing_methods, percentile_params, spectral_substraction_params, time_gain_params);
    preprocessed_signal2 = clean_signal(data2, preprocessing_methods, percentile_params, spectral_substraction_params, time_gain_params);

    % get selected method in the GUI
    method_options = cellstr(get(handles.tdoa_options,'String'));
    method_selected = method_options{get(handles.tdoa_options,'Value')};
    if(strcmp(where,'separate_window'))
        figure
    end
    
    % compute tdoa by selection
    switch method_selected
        case 'Cross-correlation (xcorr)'
            % warn label
            set(handles.plot_label, 'String', 'CC (xcorr) result')
            set(handles.plot_label, 'Visible', 'on')
            
            delay_samples = delay_xcorr(preprocessed_signal1,preprocessed_signal2);
            
            if(strcmp(where,'separate_window'))
                plot(xcorr(preprocessed_signal1,preprocessed_signal2));
            else
                plot(handles.axes_tdoa,xcorr(preprocessed_signal1,preprocessed_signal2));
            end
            
        case 'GCC Phat (Generalized cross-correlation, phase transform)'
            % warn label
            set(handles.plot_label, 'String', 'GCC Phat result')
            set(handles.plot_label, 'Visible', 'on')
            
            delay_samples = delay_gcc(preprocessed_signal1,preprocessed_signal2,'phat');
            
            if(strcmp(where,'separate_window'))
                plot(gcc(preprocessed_signal1, preprocessed_signal2, 'phat'));
            else
                plot(handles.axes_tdoa,gcc(preprocessed_signal1, preprocessed_signal2, 'phat'));
            end
            
        case 'GCC Scot (Generalized cross-correlation, smoothed coherence transform)'
            % warn label
            set(handles.plot_label, 'String', 'GCC Scot result')
            set(handles.plot_label, 'Visible', 'on')
            
            delay_samples = delay_gcc(preprocessed_signal1,preprocessed_signal2,'scot');
            
            if(strcmp(where,'separate_window'))
                plot(gcc(preprocessed_signal1, preprocessed_signal2, 'scot'));
            else
                plot(handles.axes_tdoa,gcc(preprocessed_signal1, preprocessed_signal2, 'scot'));
            end
            
        case 'LMS (Least Mean Squares)'
            % warn label
            set(handles.plot_label, 'String', 'Estimated Filter Impulse response')
            set(handles.plot_label, 'Visible', 'on')
            
            beta = str2num(get(handles.beta_lms_text,'String'));
            max_delay = str2num(get(handles.true_delay_samples_text, 'String'));
            length_signal = str2num(get(handles.length_desired_samples, 'String'));
            
            plot(handles.axes_tdoa,0)
            [delay_samples,h,e] = delay_lms(preprocessed_signal1, preprocessed_signal2, max_delay, length_signal, beta, handles);
            plot(handles.axes_tdoa, h)
    end
    delay_seconds = delay_samples / Fs;
    set(handles.estimation_samples, 'String', [num2str(delay_samples), ' samples']);
    set(handles.estimation_seconds, 'String', [num2str(delay_seconds), ' seconds']);
    
    true_delay_samples = str2num(get(handles.true_delay_samples_text, 'String'));
    true_delay_seconds = true_delay_samples/Fs;
    delay_error_seconds = delay_seconds - true_delay_seconds;
    delay_error_samples = delay_samples - true_delay_samples;
    set(handles.error_seconds, 'String', [num2str(delay_error_seconds), ' seconds']);
    set(handles.error_samples, 'String', [num2str(delay_error_samples), ' samples']);
    delay_error_relative = 100*(delay_error_samples/true_delay_samples);
    set(handles.error_percentatge, 'String', [num2str(delay_error_relative), '%']);
    
    drawnow

function play_sound_1_Callback(~, ~, ~)
    global data1_player;
    play(data1_player)

function play_sound_2_button_Callback(~, ~, ~)
    global data2_player;
    play(data2_player)

function stop_sound_1_Callback(hObject, eventdata, handles)
    global data1_player;
    stop(data1_player)

function stop_sound_2_Callback(hObject, eventdata, handles)
    global data2_player;
    stop(data2_player)


function tdoa_options_Callback(hObject, ~, handles)
    % show option for beta (smoothing factor)
    method_options = cellstr(get(hObject,'String'));
    method_selected = method_options{get(hObject,'Value')};
    if(strcmp(method_selected,'LMS (Least Mean Squares)'))
        set(handles.beta_lms_text,'Visible', 'on')
        set(handles.text40,'Visible', 'on')
        set(handles.text46,'Visible', 'on')
        set(handles.length_desired_samples,'Visible', 'on')
        set(handles.length_desired_seconds,'Visible', 'on')
        set(handles.text47,'Visible', 'on')
        set(handles.text48,'Visible', 'on')
    else
        set(handles.beta_lms_text,'Visible', 'off')
        set(handles.text40,'Visible', 'off')
        set(handles.text46,'Visible', 'off')
        set(handles.length_desired_samples,'Visible', 'off')
        set(handles.length_desired_seconds,'Visible', 'off')
        set(handles.text47,'Visible', 'off')
        set(handles.text48,'Visible', 'off')
    end
        
function plot_3D_sensors_Callback(~, ~, ~)
    addpath 'utils'
    plot3Dsensors

function all_signal_select_Callback(hObject, ~, handles)
    % deactivate all Time inputs
    if(get(hObject,'Value'))
        set(handles.Ti_minutes_edit,'Enable', 'off')
        set(handles.Tf_minutes_edit,'Enable', 'off')
        set(handles.Ti_seconds_edit,'Enable', 'off')
        set(handles.Tf_seconds_edit,'Enable', 'off')
    else
        set(handles.Ti_minutes_edit,'Enable', 'on')
        set(handles.Tf_minutes_edit,'Enable', 'on')
        set(handles.Ti_seconds_edit,'Enable', 'on')
        set(handles.Tf_seconds_edit,'Enable', 'on')
    end



function true_delay_seconds_text_Callback(hObject, ~, handles)
    global Fs;
    if isempty(Fs)
        msgbox('Whats the frequency sample (Fs)? Seconds by themselves have no sense. Import first some data',...
            'You forgot Fs','warn')
        return
    end
    % show samples for the chosen true delay in seconds
    seconds = str2num(get(hObject, 'String'));
    samples = floor(seconds*Fs);
    set(handles.true_delay_samples_text,'String', num2str(samples));


function true_delay_samples_text_Callback(hObject, ~, handles)
    % show seconds for the chosen true delay in samples
    global Fs;
    samples = str2num(get(hObject, 'String'));
    seconds = samples/Fs;
    set(handles.true_delay_seconds_text,'String', num2str(seconds));

function toogle_debug_Callback(hObject, ~, ~)
    global DEBUG;
    if DEBUG
        DEBUG = 0;
        set(hObject,'Label', 'Enable DEBUG')
    else
        DEBUG = 1;
        set(hObject,'Label', 'Disable DEBUG')
    end
    
function length_desired_seconds_Callback(hObject, ~, handles)
    global Fs;
    if isempty(Fs)
        msgbox('Whats the frequency sample (Fs)? Seconds by themselves have no sense. Import first some data',...
            'You forgot Fs','warn')
        return
    end
    % show samples for the chosen true delay in seconds
    seconds = str2num(get(hObject, 'String'));
    samples = floor(seconds*Fs);
    set(handles.length_desired_samples,'String', num2str(samples));


function length_desired_samples_Callback(hObject, ~, handles)
    % show seconds for the chosen true delay in samples
    global Fs;
    samples = str2num(get(hObject, 'String'));
    seconds = samples/Fs;
    set(handles.length_desired_seconds,'String', num2str(seconds));


function toolbar_Callback(hObject, ~, handles)
    if(strcmp(get(hObject,'Label'), 'Show Toolbar'))
        set(hObject,'Label', 'Hide Toolbar')
        set(handles.figure1,'Toolbar','figure')
    else
        set(hObject,'Label', 'Show Toolbar')
        set(handles.figure1,'Toolbar','none')
    end

function plot_options_Callback(hObject, eventdata, handles)
    % show 'DFT points' option when spectrogram is selected
    menu_options = cellstr(get(hObject,'String'));
    selected_option = menu_options{get(hObject,'Value')};
    if strcmp(selected_option ,'Spectrogram')
        set(handles.points_dft_text,'Visible','on')
        set(handles.points_dft,'Visible','on')
        set(handles.win_length,'Visible','on')
        set(handles.win_length_text,'Visible','on')
    else
        set(handles.points_dft_text,'Visible','off')
        set(handles.points_dft,'Visible','off')
        set(handles.win_length_text,'Visible','off')
        set(handles.win_length,'Visible','off')
    end
