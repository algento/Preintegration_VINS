%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% e = f(X) - Zobs
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e = fnCalcPredictionError( X )

    global InertialDelta_options Data_config
    
    addpath(genpath('IMU'));
    load( [ Data_config.TEMP_DIR 'consts.mat' ]); 
    %%%%
    %%%% Zobs is loaded
    %%%%
    
    %load('bAddZg.mat');% Use the latest value
    %load('bAddZau2c.mat');
    %load('bAddZtu2c.mat');
    %load('bAddZbf.mat');
    %load('bAddZbw.mat');
    %load('bUVonly.mat');
    %load('bVarBias.mat');
    
    load( [ Data_config.TEMP_DIR 'RptFeatureObs.mat' ] );%obsfeatures
    
    if(InertialDelta_options.bUVonly == 0)
        load( [ Data_config.TEMP_DIR 'ImuTimestamps.mat' ] );
        load( [ Data_config.TEMP_DIR 'dtIMU.mat' ] );
    else
        ImuTimestamps = [];
        dtIMU = [];
    end

    %e = zeros(size(Zobs));
    e = Zobs;

    % 1. UVD error:
    %[e, nUV] = fnUVDErr_C1U_genral(RptFeatureObs, K, X, Zobs, nPoseNew, nPts, ImuTimestamps );
    % 2. IMU dlt error:
    %[e((nUV+1):end,1)] = fnIMUdltErr_general(X, Zobs((nUV+1):end,1), nPoseNew, nPts, bf0, ...
    %    bw0, dtIMU, Jd, nIMUrate, ImuTimestamps );
    
    %ZobsPIDelta = struct ( ...
    %    'preInt',   Zobs.preInt, ...
    %    'Au2c',     Zobs.Au2c, ...
    %    'Tu2c',     Zobs.Tu2c, ...
    %    'Bf',       Zobs.Bf, ...
    %    'Bw',       Zobs.Bw ...
    %    );
    %[e((nUV+1):end,1)] = fnIMUdltErr_general(X, Zobs, nPoseNew, nPts, bf0, ...
    %    bw0, dtIMU, Jd, nIMUrate, ImuTimestamps );
    
    % 1. UVD error:
    e  = fnCalcPredictionError_Zuv(RptFeatureObs, K, X, Zobs, nPoseNew, nPts, ImuTimestamps );

    % 2. IMU dlt error:
    ePreInt = fnCalcPredictionError_ZintlDelta(X, Zobs, nPoseNew, nPts, SLAM_Params.bf0, ...
                            SLAM_Params.bw0, dtIMU, Jd, nIMUrate, ImuTimestamps );
    
    e.intlDelta =  ePreInt.intlDelta;
    e.Au2c      =  ePreInt.Au2c;
    e.Tu2c      =  ePreInt.Tu2c;
    e.Bf        =  ePreInt.Bf;
    e.Bw        =  ePreInt.Bw;
    
    


