function varargout = interactive_TDE_real_data(varargin)
    %      INTERACTIVE_TDE_REAL_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in INTERACTIVE_TDE_REAL_DATA.M with the given input arguments.
    
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
                       'gui_OpeningFcn', @interactive_TDE_real_data_OpeningFcn, ...
                       'gui_OutputFcn',  @interactive_TDE_real_data_OutputFcn, ...
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


% --- Executes just before interactive_TDE_real_data is made visible.
function interactive_TDE_real_data_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for interactive_TDE_real_data
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes interactive_TDE_real_data wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interactive_TDE_real_data_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles;


function select_hydrophone1_Callback(hObject, eventdata, handles)
    % select file and load its name and path
    global data1_FileName data1_PathName;
    [data1_FileName,data1_PathName,FilterIndex] = uigetfile({'*.wav','Raw samples (*.wav)'},...
                                                    'Select the recording of hydrophone 1');
    % warn filename and first parent folder
    for i=length(data1_PathName)-1:-1:1
        if(strcmp(data1_PathName(i),filesep))
            break
        end
    end
    set(handles.selected_file1_text,'String',[data1_PathName(i+1:end),data1_FileName]);
    
function select_hydrophone2_Callback(hObject, eventdata, handles)
    % select file and load its name and path
    global data2_FileName data2_PathName;
    [data2_FileName,data2_PathName,FilterIndex] = uigetfile({'*.wav','Raw samples'},...
                                                    'Select the recording of hydrophone 2');
    % warn filename and first parent folder
    for i=length(data2_PathName)-1:-1:1
        if(strcmp(data2_PathName(i),filesep))
            break
        end
    end
    set(handles.selected_file2_text,'String',[data2_PathName(i+1:end),data2_FileName]);
    
    
        

function Ti_minutes_edit_Callback(hObject, eventdata, handles)
    global Ti_minutes;
    Ti_minutes = str2double(get(hObject,'String'));

function Tf_minutes_edit_Callback(hObject, eventdata, handles)
    global Tf_minutes;
    Tf_minutes = str2double(get(hObject,'String'));

function Ti_seconds_edit_Callback(hObject, eventdata, handles)
    global Ti_seconds;
    Ti_seconds = str2double(get(hObject,'String'));

function Tf_seconds_edit_Callback(hObject, eventdata, handles)
    global Tf_seconds;
    Tf_seconds = str2double(get(hObject,'String'));


function load_data_Callback(hObject, eventdata, handles)
    % Warn loading
    set(handles.in_progress_text,'String','Loading... hold on a sec.');

    % Compute the time periods
    global Ti_minutes Tf_minutes Ti_seconds Tf_seconds;
    global Ti Tf;
    Ti = Ti_minutes*60 + Ti_seconds;
    Tf = Tf_minutes*60 + Tf_seconds;
    
    % Load the data
    global data1_FileName data1_PathName;
    global data2_FileName data2_PathName;
    global data1 data2 Fs;
    [data1,Fs]=wavread([data1_PathName,data1_FileName]);
    [data2,Fs]=wavread([data2_PathName,data2_FileName]);
    data1 = data1(Ti*Fs :  Tf*Fs);
    data2 = data2(Ti*Fs :  Tf*Fs);
    
    % Warn loaded
    set(handles.in_progress_text,'String','Loaded :)');
    set(handles.sampling_frequency_text,'String',[num2str(Fs/1000), ' KHz']);
    

    
function visualize_plot_button_Callback(hObject, eventdata, handles)
    global data1 data2 Fs;

    options = cellstr(get(handles.plot_options,'String'));
    selected = options{get(handles.plot_options,'Value')};
    switch selected
        case 'Time domain'
            plot(handles.axes_data1,data1);
            plot(handles.axes_data2,data2);
        case 'Spectrogram'
            [S,F,T,P] = spectrogram(data1,256,250,256,Fs);
            surf(handles.axes_data1,T,F,10*log10(P),'edgecolor','none'); axis tight; 
            view(handles.axes_data1,0,90);
            xlabel('Time (Seconds)'); ylabel('Hz');
            
            [S,F,T,P] = spectrogram(data2,256,250,256,Fs);
            surf(handles.axes_data2,T,F,10*log10(P),'edgecolor','none'); axis tight; 
            view(handles.axes_data2,0,90);
            xlabel('Time (Seconds)'); ylabel('Hz');
    end

function tdoa_plot_button_Callback(hObject, eventdata, handles)
    set(handles.working_go,'String','Working...'); drawnow;
    tdoa(handles,'in_guide');
    set(handles.working_go,'String','Done :)');

function plot_tdoa_separate_window_Callback(hObject, eventdata, handles)
    set(handles.working_window,'String','Working...'); drawnow;
    tdoa(handles,'separate_window');
    set(handles.working_window,'String','Done :)');
   
function tdoa(handles,where)
    global data1 data2 Fs;
    
    % get preprocessing methods selected in the GUI
    preprocessing_methods = {};
    if(get(handles.band_pass_option,'Value')==1)
        preprocessing_methods{end+1} = 'band_pass';
    end
    if(get(handles.time_gain_option,'Value')==1)
        preprocessing_methods{end+1} = 'time_gain';
    end
    if(get(handles.spectral_substraction_option,'Value')==1)
        preprocessing_methods{end+1} = 'spectral_substraction';
        spectral_substraction_params = struct('alpha',str2num(get(handles.alpha_text,'String')),...
                                    'beta',str2num(get(handles.beta_text,'String')));
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
    preprocessed_signal1 = clean_signal(data1, preprocessing_methods, percentile_params, spectral_substraction_params);
    preprocessed_signal2 = clean_signal(data2, preprocessing_methods, percentile_params, spectral_substraction_params);

    % get selected method in the GUI
    method_options = cellstr(get(handles.tdoa_options,'String'));
    method_selected = method_options{get(handles.tdoa_options,'Value')};
    if(strcmp(where,'separate_window'))
        figure
    end
    
    % compute tdoa by selection
    switch method_selected
        case 'Cross-correlation (xcorr)'
            delay_samples = delay_xcorr(preprocessed_signal1,preprocessed_signal2);
            if(strcmp(where,'separate_window'))
                plot(xcorr(preprocessed_signal1,preprocessed_signal2));
            else
                plot(handles.axes_tdoa,xcorr(preprocessed_signal1,preprocessed_signal2));
            end
        case 'GCC Phat (Generalized cross-correlation, phase transform)'
            delay_samples = delay_gcc(preprocessed_signal1,preprocessed_signal2,'phat');
            if(strcmp(where,'separate_window'))
                plot(gcc(preprocessed_signal1, preprocessed_signal2, 'phat'));
            else
                plot(handles.axes_tdoa,gcc(preprocessed_signal1, preprocessed_signal2, 'phat'));
            end
        case 'GCC Scot (Generalized cross-correlation, smoothed coherence transform)'
            delay_samples = delay_gcc(preprocessed_signal1,preprocessed_signal2,'scot');
            if(strcmp(where,'separate_window'))
                plot(gcc(preprocessed_signal1, preprocessed_signal2, 'scot'));
            else
                plot(handles.axes_tdoa,gcc(preprocessed_signal1, preprocessed_signal2, 'scot'));
            end
    end
    delay_seconds = delay_samples / Fs;
    set(handles.estimation_samples, 'String', [num2str(delay_samples), ' samples']);
    set(handles.estimation_seconds, 'String', [num2str(delay_seconds), ' seconds']);
    true_delay_seconds = str2num(get(handles.true_delay_text, 'String'));
    delay_error_seconds = delay_seconds - true_delay_seconds;
    delay_error_samples = delay_samples - true_delay_seconds*Fs;
    set(handles.error_seconds, 'String', [num2str(delay_error_seconds), ' seconds']);
    set(handles.error_samples, 'String', [num2str(delay_error_samples), ' samples']);
    delay_error_relative = 100*(delay_error_samples/(true_delay_seconds*Fs));
    set(handles.error_percentatge, 'String', [num2str(delay_error_relative), '%']);

function sound_1_Callback(hObject, eventdata, handles)
    global data1 Fs;
    soundsc(data1,Fs);

function sound_2_button_Callback(hObject, eventdata, handles)
    global data2 Fs;
    soundsc(data2,Fs);
