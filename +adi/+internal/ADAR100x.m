classdef (Abstract) ADAR100x < adi.common.Attribute & ...
        adi.common.DebugAttribute & adi.common.Rx & ...
        matlabshared.libiio.base
    properties (Constant, Hidden)
        BIAS_CODE_TO_VOLTAGE_SCALE = -0.018824
    end
    
    properties(Abstract, Nontunable, Hidden)
        ArrayMapInternal
        deviceNames
    end
    
    properties(Nontunable, Hidden)
        kernelBuffersCount = 0;
        dataTypeStr = 'int16';
        iioDriverName = 'adar1000';
        devName = 'adar1000';
        SamplesPerFrame = 0;
    end
    
    properties (Hidden)
        iioDevices
    end
    
    properties (Hidden, Constant, Logical)
        ComplexData = false;
    end
    
    properties(Nontunable, Hidden, Constant)
        Type = 'Rx';
    end
    
    properties (Hidden, Nontunable, Access = protected)
        isOutput = false;
    end
    
    properties
        %Mode Mode
        %   Options are 'Rx', 'Tx', or 'disabled'
        Mode = {'Rx'}
        %StateTxOrRx Set state to Rx or Tx via tr_spi bit
        %   Options are 'Rx', or 'Tx'
        StateTxOrRx = {'Rx'}
        %RxEnable Enable Rx channel subcircuits when under SPI control
        RxEnable = true
        %TxEnable Enable Tx channel subcircuits when under SPI control
        TxEnable = false
        %LNABiasOutEnable Enables output of LNA bias DAC
        LNABiasOutEnable = false
        %LNABiasOn External Bias for External LNAs
        LNABiasOn = -0.8
        %BeamMemEnable Beam Memory Enable
        BeamMemEnable = false
        %BiasDACEnable Enables PA and LNA bias DACs
        BiasDACEnable = true
        %BiasDACMode External Am plifier Bias Control
        BiasDACMode = {'On'}
        %BiasMemEnable Bias Memory Enable
        BiasMemEnable = false
        %CommonMemEnable Common Memory Enable
        CommonMemEnable = false
        %CommonRxBeamState Static Rx Beam Position Load
        CommonRxBeamState = 0
        %CommonTxBeamState Static Tx Beam Position Load
        CommonTxBeamState = 0
        %ExternalTRPin Tx/Rx Output Driver Select
        ExternalTRPin = {'Pos'}
        %ExternalTRPolarity Controls Sense of Tx/Rx Switch Driver Output
        ExternalTRPolarity = true
        %LNABiasOff External Bias for External LNAs
        LNABiasOff = -2
        %PolState Control for External Polarity Switch Drivers
        PolState = false
        %PolSwitchEnable Enables Switch Driver for External Polarization Switch
        PolSwitchEnable = false
        %RxLNABiasCurrent LNA Bias Current Setting
        RxLNABiasCurrent = 8
        %RxLNAEnable Rx LNA Enable
        RxLNAEnable = true
        %RxToTxDelay1 LNA Bias off to TR Switch Delay
        RxToTxDelay1 = 0
        %RxToTxDelay2 TR Switch to PA Bias on Delay
        RxToTxDelay2 = 0
        %RxVGAEnable Enables the Rx Channel VGAs
        RxVGAEnable = true
        %RxVGABiasCurrentVM Rx Bias Current
        RxVGABiasCurrentVM = 85
        %RxVMEnable Enables the Rx Channel Vector Modulators
        RxVMEnable = true
        %SequencerEnable Sequencer Enable
        SequencerEnable = false
        %TRSwitchEnable Enables Switch Driver for External Tx/Rx Switch
        TRSwitchEnable = true
        %TxPABiasCurrent Tx Driver Bias Current Setting
        TxPABiasCurrent = 6
        %TxPAEnable Enables the Tx Channel Drivers
        TxPAEnable = false
        %TxToRxDelay1 PA Bias off to TR Switch Delay
        TxToRxDelay1 = 0
        %TxToRxDelay2 TR Switch to LNA Bias on Delay
        TxToRxDelay2 = 0
        %TxVGAEnable Enables the Tx Channel VGAs
        TxVGAEnable = true
        %TxVGABiasCurrentVM Tx Bias Current
        TxVGABiasCurrentVM = 45
        %TxVMEnable Enables the Tx Channel Vector Modulators
        TxVMEnable = true
        
        %DetectorEnable Detector Enable
        DetectorEnable = true(1, 4)
        %DetectorPower Detector Power
        DetectorPower = 255*ones(1, 4)
        %PABiasOff External Bias for External PA 
        PABiasOff = -2.484*ones(1, 4)
        %PABiasOn External Bias for External PA  
        PABiasOn = -2.484*ones(1, 4)
        %RxAttn Rx Attenuation
        RxAttn = true(1, 4)
        %RxBeamState Load Rx Position
        RxBeamState = zeros(1, 4)
        %RxPowerDown Rx Powerdown
        RxPowerDown = false(1, 4)
        %RxGain Rx Gain
        RxGain = ones(1, 4)
        %RxPhase Rx Phase
        RxPhase = zeros(1, 4)
        %TxAttn Tx Attenuation
        TxAttn = true(1, 4)
        %TxBeamState Load Tx Position
        TxBeamState = zeros(1, 4)
        %TxPowerDown Tx Powerdown
        TxPowerDown = false(1, 4)
        %TxGain Tx Gain
        TxGain = ones(1, 4)
        %TxPhase Tx Phase
        TxPhase = zeros(1, 4)
        % RxBiasState = zeros(1, 4)
        %RxSequencerStart Rx Sequencer Start
        RxSequencerStart = false(1, 4)
        %RxSequencerStop Rx Sequencer Stop
        RxSequencerStop = false(1, 4)
        % TxBiasState = zeros(1, 4)
        %TxSequencerStart Tx Sequencer Start
        TxSequencerStart = false(1, 4)
        %TxSequencerStop Tx Sequencer Stop
        TxSequencerStop = false(1, 4)
        %Temp ADAR1000 Temperature
        Temp = 0
    end
    
    properties
        %Frequency ADAR1000 Frequency
        Frequency = 10e9
        %ElementSpacing ADAR1000 Element Spacing
        ElementSpacing = 0.015
    end
    
    properties (Hidden, Access = private)
        %RxAzimuth Rx Azimuth
        RxAzimuth = 0
        %RxAzimuthPhi Rx Azimuth Phi
        RxAzimuthPhi = 0
        %RxElevation Rx Elevation
        RxElevation = 0
        %RxElevationPhi Rx Elevation Phi
        RxElevationPhi = 0
        %TxAzimuth Tx Azimuth
        TxAzimuth = 0
        %TxAzimuthPhi Tx Azimuth Phi
        TxAzimuthPhi = 0
        %TxElevation Tx Elevation
        TxElevation = 0
        %TxElevationPhi Tx Elevation Phi
        TxElevationPhi = 0
    end
    
    methods
        % Constructor
        function obj = ADAR100x(varargin)
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});
            % Check that the number of chips matches for all the inputs
            if ((numel(obj.deviceNames)*4) ~= numel(obj.ArrayMapInternal))
                error('Expected equal number of elements in ArrayMapInternal and 4*numel(ChipIDs)');
            end
            obj.updateDefaultProps();
        end
        
        % Destructor
        function delete(obj)
        end
        
        function updateDefaultProps(obj)
            DeviceProps = {'Mode', 'LNABiasOutEnable', 'LNABiasOn', ...
                'BeamMemEnable', 'BiasDACEnable', ...
                'BiasDACMode', 'BiasMemEnable', ...
                'CommonMemEnable', 'CommonRxBeamState', 'CommonTxBeamState', ...
                'ExternalTRPin', 'ExternalTRPolarity', 'LNABiasOff', ...
                'PolState', 'PolSwitchEnable', 'RxLNABiasCurrent', ...
                'RxLNAEnable', 'RxToTxDelay1', 'RxToTxDelay2', ...
                'RxVGAEnable', 'RxVGABiasCurrentVM', 'RxVMEnable', ...
                'SequencerEnable', 'TRSwitchEnable', 'TxPABiasCurrent', ...
                'TxPAEnable', 'TxToRxDelay1', 'TxToRxDelay2', ...
                'TxVGAEnable', 'TxVGABiasCurrentVM', 'TxVMEnable'
            };
            ChannelProps = {
                'DetectorEnable', ...% 'DetectorPower', 
                'PABiasOff', 'PABiasOn', 'RxAttn', ...
                'RxBeamState', 'RxPowerDown', 'RxGain', ...
                'RxPhase', 'TxAttn', 'TxBeamState', ...
                'TxPowerDown', 'TxGain', ...
                'TxPhase', ...% RxBiasState = zeros(1, 4)
                'RxSequencerStart', 'RxSequencerStop', ...% 'TxBiasState', 
                'TxSequencerStart', 'TxSequencerStop'
            };
            
            % Device Properties
            for ii = 1:numel(DeviceProps)
                obj.(DeviceProps{ii}) = repmat(obj.(DeviceProps{ii}), [1, size(obj.ArrayMapInternal, 1)]);
            end
            % Channel Properties
            for ii = 1:numel(ChannelProps)
                obj.(ChannelProps{ii}) = repmat(obj.(ChannelProps{ii}), [size(obj.ArrayMapInternal, 1), 1]);
            end
        end
        
        function result = getAllChipsChannelAttribute(obj, attr, isOutput, AttrClass)
            if strcmpi(AttrClass, 'logical')
                result = false(size(obj.ArrayMapInternal));
            elseif strcmpi(AttrClass, 'raw')
                result = zeros(size(obj.ArrayMapInternal));
            elseif strcmpi(AttrClass, 'int32') || strcmpi(AttrClass, 'int64')
                result = zeros(size(obj.ArrayMapInternal));
            elseif strcmpi(AttrClass, 'double')
                result = zeros(size(obj.ArrayMapInternal));
            end
            for d = 1:numel(obj.iioDevices)
                for c = 0:3
                    channel = sprintf('voltage%d', c);
                    if strcmpi(AttrClass, 'logical')
                        result(d, c+1) = obj.getAttributeBool(channel, attr, isOutput, obj.iioDevices{d});
                    elseif strcmpi(AttrClass, 'raw')
                        result(d, c+1) = str2double(obj.getAttributeRAW(channel, attr, isOutput, obj.iioDevices{d}));
                    elseif strcmpi(AttrClass, 'int32') || strcmpi(AttrClass, 'int64')
                        result(d, c+1) = obj.getAttributeLongLong(channel, attr, isOutput, obj.iioDevices{d});
                    elseif strcmpi(AttrClass, 'double')
                        result(d, c+1) = obj.getAttributeDouble(channel, attr, isOutput, obj.iioDevices{d});
                    end
                end
            end
        end
        
        function setAllChipsChannelAttribute(obj, values, attr, isOutput, AttrClass, varargin)
            if (nargin == 6)
                Tol = varargin{1};
            else
                Tol = 0;
            end
            if strcmpi(AttrClass, 'logical')
                validateattributes(values, {'logical'},...
                    {'size', size(obj.ArrayMapInternal)});
            elseif strcmpi(AttrClass, 'raw') || ...
                    strcmpi(AttrClass, 'int32') || strcmpi(AttrClass, 'int64')
                validateattributes(values, {'numeric', 'uint32'},...
                    {'size', size(obj.ArrayMapInternal)});
            elseif strcmpi(AttrClass, 'double')
                validateattributes(values, {'numeric', 'double'},...
                    {'size', size(obj.ArrayMapInternal)});
            end
            
            if obj.ConnectedToDevice
                for dev = 1:numel(obj.deviceNames)
                    for ch = 1:4
                        channel = sprintf('voltage%d', ch-1);
                        if strcmpi(AttrClass, 'logical')
                            obj.setAttributeBool(channel, attr, ...
                                values(dev, ch), isOutput, obj.iioDevices{dev});
                        elseif strcmpi(AttrClass, 'raw')
                            obj.setAttributeRAW(channel, attr, ...
                                values(dev, ch), isOutput, obj.iioDevices{dev});
                        elseif strcmpi(AttrClass, 'int32') || strcmpi(AttrClass, 'int64')
                            obj.setAttributeLongLong(channel, attr, ...
                                values(dev, ch), isOutput, Tol, obj.iioDevices{dev});
                        elseif strcmpi(AttrClass, 'double')
                            obj.setAttributeDouble(channel, attr, ...
                                values(dev, ch), isOutput, Tol, obj.iioDevices{dev});
                        end
                    end
                end
            end
        end
        
        function result = getAllChipsDeviceAttributeRAW(obj, attr, isBooleanAttr)
            if isBooleanAttr
                temp = false(size(obj.deviceNames));
            else
                temp = zeros(size(obj.deviceNames));
            end
            for ii = 1:numel(obj.deviceNames)
                if isBooleanAttr
                    temp(ii) = logical(str2num(obj.getDeviceAttributeRAW(attr, 128, obj.iioDevices{ii})));
                else
                    temp(ii) = str2num(obj.getDeviceAttributeRAW(attr, 128, obj.iioDevices{ii}));
                end
            end
            if isBooleanAttr
                result = logical(temp);
            else
                result = temp;
            end
        end
        
        function setAllChipsDeviceAttributeRAW(obj, attr, values, isBooleanAttr)
            if isBooleanAttr
                temp = char(ones(size(obj.deviceNames)) * '1');
                for ii = 1:size(values, 1)
                    temp(ii, :) = strrep(values(ii, :), ' ', '');
                end
                values = temp;
                validateattributes(values, {'char'}, {'size', size(obj.deviceNames)});
            end
            
            if obj.ConnectedToDevice
                for ii = 1:numel(obj.deviceNames)
                    if isBooleanAttr
                        obj.setDeviceAttributeRAW(attr, values(ii), obj.iioDevices{ii});
                    else
                        obj.setDeviceAttributeRAW(attr, values{ii}, obj.iioDevices{ii});
                    end
                end
            end
        end        
    end
    
    methods
        function TaperTx(obj, window, MaxGain, varargin)
            % TaperTx Taper Stingray Tx gain.
            % Inputs:
            %   window: Options - "none", "bartlett", "blackmann",
            %   "hamming", "hanning"
            %   MaxGain: Maximum gain (0-127) of the Tx VGA
            if (nargin == 3)
                Offset = zeros(size(obj.ArrayMapInternal));
            elseif (nargin == 4)
                Offset = varargin{1};
            end
            obj.Taper("Tx", window, MaxGain, Offset);
        end

        function TaperRx(obj, window, MaxGain, varargin)
            % TaperRx Taper Stingray Rx gain.
            % Inputs:
            %   window: Options - "none", "bartlett", "blackmann",
            %   "hamming", "hanning"
            %   MaxGain: Maximum gain (0-127) of the Rx VGA
            if (nargin == 3)
                Offset = zeros(size(obj.ArrayMapInternal));
            elseif (nargin == 4)
                Offset = varargin{1};
            end
            obj.Taper("Rx", window, MaxGain, Offset);
        end

        function SteerRx(obj, Azimuth, Elevation, varargin)
            % SteerRx Steer the Rx array in a particular direction. This method assumes that the entire array is one analog beam.
            if (nargin == 3)
                Offset = zeros(size(obj.ArrayMapInternal));
            elseif (nargin == 4)
                Offset = varargin{1};
            end
            obj.Steer("Rx", Azimuth, Elevation, Offset);
        end
        
        function SteerTx(obj, Azimuth, Elevation, varargin)
            % SteerTx Steer the Tx array in a particular direction. This method assumes that the entire array is one analog beam.
            if (nargin == 3)
                Offset = zeros(size(obj.ArrayMapInternal));
            elseif (nargin == 4)
                Offset = varargin{1};
            end
            obj.Steer("Tx", Azimuth, Elevation, Offset)
        end
    end
    
    methods (Access = private)
        function Taper(obj, RxOrTx, window, MaxGain, Offset)
            rLen = size(obj.ArrayMapInternal, 1);
            cLen = size(obj.ArrayMapInternal, 2);

            switch lower(window)
                case "none"
                    rWin = ones(rLen+2);
                    cWin = ones(cLen+2);
                case "bartlett"
                    rWin = bartlett(rLen+2);
                    cWin = bartlett(cLen+2);
                case "blackman"
                    rWin = blackman(rLen+2);
                    cWin = blackman(cLen+2);
                case "hamming"
                    rWin = hamming(rLen+2);
                    cWin = hamming(cLen+2);
                case "hanning"
                    rWin = hann(rLen+2);
                    cWin = hann(cLen+2);
                otherwise
                    error('window type unsupported for tapering');
            end
            rWin = rWin(2:end-1);
            cWin = cWin(2:end-1);
            rWin = rWin/max(rWin);
            cWin = cWin/max(cWin);

            Array = 1:numel(obj.ArrayMapInternal);
            Array = reshape(Array, size(obj.ArrayMapInternal.')).';

            r = zeros(size(Array));
            c = zeros(size(Array));
            for ii = 1:size(obj.ArrayMapInternal, 1)
                for jj = 1:size(obj.ArrayMapInternal, 2)
                    [r(ii, jj), c(ii, jj)] = find(Array == obj.ArrayMapInternal(ii, jj));
                end
            end
            ColumnWin = cWin(c);
            RowWin = rWin(r);
            gain = MaxGain*ColumnWin.*RowWin;
            gain = round(gain);

            if strcmpi(RxOrTx, 'Rx')
                obj.RxGain = gain + Offset(obj.ArrayMapInternal);
                obj.LatchRxSettings();
            elseif strcmpi(RxOrTx, 'Tx')
                obj.TxGain = gain + Offset(obj.ArrayMapInternal);
                obj.LatchTxSettings();
            end
        end

        function Steer(obj, RxOrTx, Azimuth, Elevation, Offset)
            [AzimuthPhi, ElevationPhi] = obj.CalculatePhi(Azimuth, Elevation);
            
            % Update the class variables
            if strcmpi(RxOrTx, 'Rx')
                obj.RxAzimuth = Azimuth;
                obj.RxElevation = Elevation;
                obj.RxAzimuthPhi = AzimuthPhi;
                obj.RxElevationPhi = ElevationPhi;
            else
                obj.TxAzimuth = Azimuth;
                obj.TxElevation = Elevation;
                obj.TxAzimuthPhi = AzimuthPhi;
                obj.TxElevationPhi = ElevationPhi;
            end
            
            % Steer the elements in the array and Latch in the new phases
            Array = 1:numel(obj.ArrayMapInternal);
            Array = reshape(Array, size(obj.ArrayMapInternal.')).';

            r = zeros(size(Array));
            c = zeros(size(Array));
            for ii = 1:size(obj.ArrayMapInternal, 1)
                for jj = 1:size(obj.ArrayMapInternal, 2)
                    [r(ii, jj), c(ii, jj)] = find(Array == obj.ArrayMapInternal(ii, jj));
                end
            end
            ColumnPhase = (c-1)*ElevationPhi;
            RowPhase = (r-1)*AzimuthPhi;
            if strcmpi(RxOrTx, 'Rx')
                obj.RxPhase = wrapTo360(ColumnPhase + RowPhase + Offset(obj.ArrayMapInternal));
                obj.LatchRxSettings();
            elseif strcmpi(RxOrTx, 'Tx')
                obj.TxPhase = wrapTo360(ColumnPhase + RowPhase + Offset(obj.ArrayMapInternal));
                obj.LatchTxSettings();
            end
        end
        
        function [AzPhi, ElPhi] = CalculatePhi(obj, Azimuth, Elevation)
            % CalculatePhi Calculate the Φ angles to steer the array in a particular direction.             
            % Convert the input angles to radians
            AzR = Azimuth * pi / 180;
            ElR = Elevation * pi / 180;

            % Calculate the phase increment (Φ) for each element in the array in both directions (in degrees)
            AzPhi = 2 * obj.Frequency * obj.ElementSpacing * sin(AzR) * 180 / 3e8;
            ElPhi = 2 * obj.Frequency * obj.ElementSpacing * sin(ElR) * 180 / 3e8;
        end
    end
    
    methods        
        function set.Mode(obj, values)
            RxEnableMat = char(ones(size(values)) * '0');
            TxEnableMat = char(ones(size(values)) * '0');
            StateTxOrRxMat = cell(size(values));
            StateTxOrRxMat(:) = {'Rx'};
            for ii = 1:numel(values)
                if ~(strcmpi(values{ii}, 'Tx') || strcmpi(values{ii}, 'Rx') ...
                         || strcmpi(values{ii}, 'Disabled'))
                    error('Expected ''Tx'' or ''Rx'' or ''Disabled'' for property, Mode');
                end
                if strcmpi(values{ii}, 'Disabled')
                    RxEnableMat(ii) = '0';
                    TxEnableMat(ii) = '0';
                else
                    StateTxOrRxMat{ii} = values{ii};
                    if strcmpi(values(ii), 'Tx')
                        RxEnableMat(ii) = '0';
                        TxEnableMat(ii) = '1';                        
                    else
                        RxEnableMat(ii) = '1';
                        TxEnableMat(ii) = '0';
                    end
                end
            end
            obj.RxEnable = RxEnableMat;
            obj.TxEnable = TxEnableMat;
            obj.StateTxOrRx = StateTxOrRxMat;
            obj.Mode = values;
        end
                
        function set.RxEnable(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'rx_en', num2str(values), true);
            if ischar(values) && (numel(values)==size(obj.ArrayMapInternal, 1))
                for ii = 1:numel(values)
                    if (values(ii)=='1')
                        obj.RxEnable(ii) = true;
                    elseif (values(ii)=='0')
                        obj.RxEnable(ii) = false;
                    end
                end
            else
                obj.RxEnable = values;
            end
        end
        
        function set.TxEnable(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'tx_en', num2str(values), true);            
            if ischar(values) && (numel(values)==size(obj.ArrayMapInternal, 1))
                for ii = 1:numel(values)
                    if (values(ii)=='1')
                        obj.TxEnable(ii) = true;
                    elseif (values(ii)=='0')
                        obj.TxEnable(ii) = false;
                    end
                end
            else
                obj.TxEnable = values;
            end
        end
        
        function set.LNABiasOutEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_out_enable', num2str(values), true);
            obj.LNABiasOutEnable = values;
        end
        
        function set.LNABiasOn(obj, values)
            dac_codes = int32(values / obj.BIAS_CODE_TO_VOLTAGE_SCALE);
            dac_codes = convertStringsToChars(string(dac_codes));
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_on', dac_codes, false);
            obj.LNABiasOn = values;
        end
        
        function set.StateTxOrRx(obj, values)
            ivalues = char(ones(size(values)) * '0');
            for ii = 1:numel(values)
                if ~(strcmpi(values(ii), 'Tx') || strcmpi(values(ii), 'Rx'))
                    error('Expected ''Tx'' or ''Rx'' for property, StateTxOrRx');
                end
                if strcmpi(values(ii), 'Tx')
                    ivalues(ii) = '1';
                else
                    ivalues(ii) = '0';
                end
            end
            setAllChipsDeviceAttributeRAW(obj, 'tr_spi', ivalues, true);
            obj.StateTxOrRx = values;
        end
        
        function set.BeamMemEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'beam_mem_enable', num2str(values), true);
            obj.BeamMemEnable = values;
        end

        function set.BiasDACEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'bias_enable', num2str(values), true);
            obj.BiasDACEnable = values;
        end
        
        function set.BiasDACMode(obj, values)
            ivalues = char(ones(size(values)) * '0');
            for ii = 1:numel(values)
                if ~(strcmpi(values(ii), 'Toggle') || strcmpi(values(ii), 'On'))
                    error('Expected ''Toggle'' or ''On'' for property, BiasDACMode');
                end
                if strcmpi(values(ii), 'Toggle')
                    ivalues(ii) = '1';
                else
                    ivalues(ii) = '0';
                end
            end
            setAllChipsDeviceAttributeRAW(obj, 'bias_ctrl', ivalues, true);
            obj.BiasDACMode = values;
        end

        function set.BiasMemEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'bias_mem_enable', num2str(values), true);
            obj.BiasMemEnable = values;
        end
        
        function set.CommonMemEnable(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'common_mem_enable', num2str(values), true);
            obj.CommonMemEnable = values;
        end
        
        function set.CommonRxBeamState(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'static_rx_beam_pos_load', values, false);
            obj.CommonRxBeamState = cellfun(@str2num, values);
        end
        
        function set.CommonTxBeamState(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'static_tx_beam_pos_load', values, false);
            obj.CommonTxBeamState = cellfun(@str2num, values);
        end
        
        function set.ExternalTRPin(obj, values)
            ivalues = char(ones(size(values)) * '0');
            for ii = 1:numel(values)
                if ~(strcmpi(values(ii), 'Pos') || strcmpi(values(ii), 'Neg'))
                    error('Expected ''Pos'' or ''Neg'' for property, ExternalTRPin');
                end
                if strcmpi(values(ii), 'Neg')
                    ivalues(ii) = '1';
                else
                    ivalues(ii) = '0';
                end
            end
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_tr_mode_sel', ivalues, true);
            obj.ExternalTRPin = values;
        end
        
        function set.ExternalTRPolarity(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_tr_state', num2str(values), true);
            obj.ExternalTRPolarity = values;
        end
        
        function set.LNABiasOff(obj, values)
            dac_codes = int32(values / obj.BIAS_CODE_TO_VOLTAGE_SCALE);
            dac_codes = convertStringsToChars(string(dac_codes));
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_off', dac_codes, false);
            obj.LNABiasOff = values;
        end
        
        function set.PolState(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'pol', num2str(values), true);
            obj.PolState = values;
        end
        
        function set.PolSwitchEnable(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_en_pol', num2str(values), true);
            obj.PolSwitchEnable = values;
        end
        
        function set.RxLNABiasCurrent(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_rx_lna', values, false);
            obj.RxLNABiasCurrent = cellfun(@str2num, values);
        end
        
        function set.RxLNAEnable(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'rx_lna_enable', num2str(values), true);
            obj.RxLNAEnable = values;
        end
        
        function set.RxToTxDelay1(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'rx_to_tx_delay_1', values, false);
            obj.RxToTxDelay1 = cellfun(@str2num, values);
        end
        
        function set.RxToTxDelay2(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'rx_to_tx_delay_2', values, false);
            obj.RxToTxDelay2 = cellfun(@str2num, values);
        end
        
        function set.RxVGAEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'rx_vga_enable', num2str(values), true);
            obj.RxVGAEnable = values;
        end
        
        function set.RxVGABiasCurrentVM(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_rx', values, false);
            obj.RxVGABiasCurrentVM = cellfun(@str2num, values);
        end
        
        function set.RxVMEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'rx_vm_enable', num2str(values), true);
            obj.RxVMEnable = values;
        end
        
        function set.SequencerEnable(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'sequencer_enable', num2str(values), true);
            obj.SequencerEnable = values;
        end
        
        function set.TRSwitchEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_en_tr', num2str(values), true);
            obj.TRSwitchEnable = values;
        end
        
        function set.TxPABiasCurrent(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_tx_drv', values, false);
            obj.TxPABiasCurrent = cellfun(@str2num, values);
        end
        
        function set.TxPAEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'tx_drv_enable', num2str(values), true);
            obj.TxPAEnable = values;
        end
        
        function set.TxToRxDelay1(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'tx_to_rx_delay_1', values, false);
            obj.TxToRxDelay1 = cellfun(@str2num, values);
        end
        
        function set.TxToRxDelay2(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'tx_to_rx_delay_2', values, false);
            obj.TxToRxDelay2 = cellfun(@str2num, values);
        end
        
        function set.TxVGAEnable(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'tx_vga_enable', num2str(values), true);
            obj.TxVGAEnable = values;
        end
        
        function set.TxVGABiasCurrentVM(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_tx', values, false);
            obj.TxVGABiasCurrentVM = cellfun(@str2num, values);
        end
        
        function set.TxVMEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'tx_vm_enable', num2str(values), true);
            obj.TxVMEnable = values;
        end
        
        function Reset(obj)
            values = true(size(obj.deviceNames));
            setAllChipsDeviceAttributeRAW(obj, 'reset', num2str(values), true);
        end
        
        function Initialize(obj, PAOff, PAOn, LNAOff, LNAOn)
            % Put the part in a known state
            obj.Reset();
            
            % Set the bias currents to nominal
            obj.RxLNABiasCurrent = hex2dec('0x08')*ones(size(obj.deviceNames));
            obj.RxVGABiasCurrentVM = hex2dec('0x55')*ones(size(obj.deviceNames));
            obj.TxVGABiasCurrentVM = hex2dec('0x2D')*ones(size(obj.deviceNames));
            obj.TxPABiasCurrent = hex2dec('0x06')*ones(size(obj.deviceNames));
            
            % Disable RAM control
            obj.BeamMemEnable = false(size(obj.deviceNames));
            obj.BiasMemEnable = false(size(obj.deviceNames));
            obj.CommonMemEnable = false(size(obj.deviceNames));
            
            % Enable all internal amplifiers
            obj.RxVGAEnable = true(size(obj.deviceNames)); 
            obj.RxVMEnable = true(size(obj.deviceNames));
            obj.RxLNAEnable = true(size(obj.deviceNames));
            obj.TxVGAEnable = true(size(obj.deviceNames));
            obj.TxVMEnable = true(size(obj.deviceNames));
            obj.TxPAEnable = true(size(obj.deviceNames));
            
            % Disable Tx/Rx paths for the device
            TempMode = cell(size(obj.deviceNames));
            TempMode(:) = {'disabled'};
            obj.Mode = TempMode;

            % Enable the PA/LNA bias DACs
            obj.LNABiasOutEnable = true(size(obj.deviceNames));
            obj.BiasDACEnable = true(size(obj.deviceNames));
            TempBiasDACMode = cell(size(obj.deviceNames));
            TempBiasDACMode(:) = {'Toggle'};
            obj.BiasDACMode = TempBiasDACMode;
            
            % Configure the external switch control
            obj.ExternalTRPolarity = true(size(obj.deviceNames));
            obj.TRSwitchEnable = true(size(obj.deviceNames));

            % Set the default LNA bias
            obj.LNABiasOff = LNAOff*ones(size(obj.deviceNames));
            obj.LNABiasOn = LNAOn*ones(size(obj.deviceNames));
            
            % Default channel enable
            obj.RxPowerDown = zeros(size(obj.ArrayMapInternal));
            obj.TxPowerDown = zeros(size(obj.ArrayMapInternal));

            % Default PA bias
            obj.PABiasOff = PAOff*ones(size(obj.ArrayMapInternal));
            obj.PABiasOn = PAOn*ones(size(obj.ArrayMapInternal));

            % Default attenuator, gain, and phase
            obj.RxAttn = false(size(obj.ArrayMapInternal));
            obj.RxGain = hex2dec('0x7F')*ones(size(obj.ArrayMapInternal));
            obj.RxPhase = zeros(size(obj.ArrayMapInternal));
            obj.TxAttn = false(size(obj.ArrayMapInternal));
            obj.TxGain = hex2dec('0x7F')*ones(size(obj.ArrayMapInternal));
            obj.TxPhase = zeros(size(obj.ArrayMapInternal));
            
            % Latch in the new settings
            obj.LatchRxSettings();
            obj.LatchTxSettings();
        end
    end
    
    methods
        function LatchRxSettings(obj)
            setAllChipsDeviceAttributeRAW(obj, 'rx_load_spi', num2str(true(size(obj.deviceNames))), true);
        end
        
        function LatchTxSettings(obj)
            setAllChipsDeviceAttributeRAW(obj, 'tx_load_spi', num2str(true(size(obj.deviceNames))), true);
        end
    end
    
    % Get/Set Methods for Channel Attributes
    methods
        function set.DetectorEnable(obj, values)
            setAllChipsChannelAttribute(obj, values, 'detector_en', true, 'logical');
            obj.DetectorEnable = values;
        end
        
        function result = get.DetectorPower(obj)
            result = zeros(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                obj.DetectorEnable = true(size(obj.ArrayMapInternal));
                result = getAllChipsChannelAttribute(obj, 'raw', true, 'raw');
                obj.DetectorEnable = false(size(obj.ArrayMapInternal));
            end
        end
        
        function set.PABiasOff(obj, values)
            dac_codes = int64(values / obj.BIAS_CODE_TO_VOLTAGE_SCALE);
            setAllChipsChannelAttribute(obj, dac_codes, 'pa_bias_off', true, 'int64');
            obj.PABiasOff = values;
        end
        
        function set.PABiasOn(obj, values)
            dac_codes = int64(values / obj.BIAS_CODE_TO_VOLTAGE_SCALE);
            setAllChipsChannelAttribute(obj, dac_codes, 'pa_bias_on', true, 'int32');
            obj.PABiasOn = values;
        end
                
        function set.RxAttn(obj, values)
            setAllChipsChannelAttribute(obj, values, 'attenuation', false, 'logical');
            obj.RxAttn = values;
        end
        
        function set.RxBeamState(obj, values)
            validateattributes( values, { 'double', 'single', 'uint32'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',120}, ...
                '', 'RxBeamState');
            setAllChipsChannelAttribute(obj, values, 'beam_pos_load', false, 'int32');
            obj.RxBeamState = values;
        end
        
        function set.RxPowerDown(obj, values)
            setAllChipsChannelAttribute(obj, ~values, 'powerdown', false, 'logical');
            obj.RxPowerDown = values;
        end

        function set.RxGain(obj, values)
            validateattributes( values, { 'double', 'single', 'uint32'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',127}, ...
                '', 'RxGain');
            setAllChipsChannelAttribute(obj, values, 'hardwaregain', false, 'double');
            obj.RxGain = values;
        end
        
        function set.RxPhase(obj, values)
            validateattributes( values, { 'double'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','>=',0,'<=',360}, ...
                '', 'RxPhase');
            for ii = size(values, 1)
                for jj = size(values, 2)
                    if (values > 357)
                        values(ii, jj) = 0;
                    end
                end
            end
            setAllChipsChannelAttribute(obj, values, 'phase', false, 'double', 4);
            obj.RxPhase = values;
        end
        
        function set.TxAttn(obj, values)
            setAllChipsChannelAttribute(obj, values, 'attenuation', true, 'logical');
            obj.TxAttn = values;
        end
        
        function set.TxBeamState(obj, values)
            validateattributes( values, { 'double', 'single', 'uint32'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',120}, ...
                '', 'TxBeamState');
            setAllChipsChannelAttribute(obj, values, 'beam_pos_load', true, 'int32');
            obj.TxBeamState = values;
        end
        
        function set.TxPowerDown(obj, values)
            setAllChipsChannelAttribute(obj, ~values, 'powerdown', true, 'logical');
            obj.TxPowerDown = values;
        end
        
        function set.TxGain(obj, values)
            validateattributes( values, { 'double', 'single', 'uint32'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',127}, ...
                '', 'TxGain');
            setAllChipsChannelAttribute(obj, values, 'hardwaregain', true, 'double');
            obj.TxGain = values;
        end
        
        function set.TxPhase(obj, values)
            validateattributes( values, { 'double'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','>=',0,'<=',360}, ...
                '', 'TxPhase');
            for ii = size(values, 1)
                for jj = size(values, 2)
                    if (values > 357)
                        values(ii, jj) = 0;
                    end
                end
            end
            setAllChipsChannelAttribute(obj, values, 'phase', true, 'double', 4);
            obj.TxPhase = values;
        end
        
%         function result = get.RxBiasState(obj)
%             result = zeros(size(obj.ArrayMapInternal));
%             if ~isempty(obj.iioDevices)
%                 result = getAllChipsChannelAttribute(obj, 'bias_set_load', false, 'logical');
%             end
%         end
%         
%         function set.RxBiasState(obj, values)
%             setAllChipsChannelAttribute(obj, values, 'bias_set_load', false, 'logical');
%         end
        
        function set.RxSequencerStart(obj, values)
            setAllChipsChannelAttribute(obj, values, 'sequence_start', false, 'logical');
            obj.RxSequencerStart = values;
        end
        
        function set.RxSequencerStop(obj, values)
            setAllChipsChannelAttribute(obj, values, 'sequence_end', false, 'logical');
            obj.RxSequencerStop = values;
        end
        
%         function result = get.TxBiasState(obj)
%             result = zeros(size(obj.ArrayMapInternal));
%             if ~isempty(obj.iioDevices)
%                 result = ~getAllChipsChannelAttribute(obj, 'bias_set_load', true, 'logical');
%             end
%         end
%         
%         function set.TxBiasState(obj, values)
%             setAllChipsChannelAttribute(obj, values, 'bias_set_load', true, 'logical');
%         end
        
        function set.TxSequencerStart(obj, values)
            setAllChipsChannelAttribute(obj, ~values, 'sequence_start', true, 'logical');
            obj.TxSequencerStart = values;
        end
        
        function set.TxSequencerStop(obj, values)
            setAllChipsChannelAttribute(obj, ~values, 'sequence_end', true, 'logical');
            obj.TxSequencerStop = values;
        end
        
        function result = get.Temp(obj)
            result = zeros(numel(obj.deviceNames), 1);
            for d = 1:numel(obj.iioDevices)
                result(d) = str2double(obj.getAttributeRAW('temp0', 'raw', false, obj.iioDevices{d}));
            end            
        end
    end
    
    methods    
        function SaveRxBeam(obj, ChipIDIndx, ChIndx, State, Attn, Gain, Phase)
             validateattributes( State, { 'double','single', 'uint32' }, ...
                { 'real', 'nonnegative','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',120}, ...
                '', 'State');
             validateattributes( Gain, { 'double','single', 'uint32' }, ...
                { 'real', 'nonnegative','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',127}, ...
                '', 'Gain');             
            obj.setAttributeRAW(sprintf('voltage%d', ChIndx), ...
                'beam_pos_save', sprintf('%d, %d, %d, %f', State, Attn, Gain, Phase), false, obj.iioDevices{ChipIDIndx});
        end
        
        function SaveTxBeam(obj, ChipIDIndx, ChIndx, State, Attn, Gain, Phase)
             validateattributes( State, { 'double','single', 'uint32' }, ...
                { 'real', 'nonnegative','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',120}, ...
                '', 'State');
             validateattributes( Gain, { 'double','single', 'uint32' }, ...
                { 'real', 'nonnegative','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',127}, ...
                '', 'Gain');             
            obj.setAttributeRAW(sprintf('voltage%d', ChIndx), ...
                'beam_pos_save', sprintf('%d, %d, %d, %f', State, Attn, Gain, Phase), true, obj.iioDevices{ChipIDIndx});
        end
    end
    
    methods (Hidden, Access = protected)
        function setupInit(obj)
            numDevs = obj.iio_context_get_devices_count(obj.iioCtx);
            obj.iioDevices = cell(1,length(obj.deviceNames));
            for dn = 1:length(obj.deviceNames)
                for k = 1:numDevs
                    devPtr = obj.iio_context_get_device(obj.iioCtx, k-1);
                    name = obj.iio_device_get_name(devPtr);
                    if strcmpi(obj.deviceNames{dn},name)
                        obj.iioDevices{dn} = devPtr;
                    end
                end
                if isempty(obj.iioDevices{dn})
                   error('%s not found',obj.deviceNames{dn});
                end
            end

            % Write device attributes
            setAllChipsDeviceAttributeRAW(obj, 'rx_en', num2str(obj.RxEnable), true);
            setAllChipsDeviceAttributeRAW(obj, 'tx_en', num2str(obj.TxEnable), true);
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_out_enable', num2str(obj.LNABiasOutEnable), true);
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_on', convertStringsToChars(string(int32(obj.LNABiasOn / obj.BIAS_CODE_TO_VOLTAGE_SCALE))), false);
            values = obj.StateTxOrRx;
            ivalues = char(ones(size(values)) * '0');
            for ii = 1:numel(values)
                if ~(strcmpi(values(ii), 'Tx') || strcmpi(values(ii), 'Rx'))
                    error('Expected ''Tx'' or ''Rx'' for property, StateTxOrRx');
                end
                if strcmpi(values(ii), 'Tx')
                    ivalues(ii) = '1';
                else
                    ivalues(ii) = '0';
                end
            end
            setAllChipsDeviceAttributeRAW(obj, 'tr_spi', ivalues, true);
            setAllChipsDeviceAttributeRAW(obj, 'beam_mem_enable', num2str(obj.BeamMemEnable), true);
            ivalues = char(ones(size(obj.BiasDACMode)) * '0');
            for ii = 1:numel(obj.BiasDACMode)
                if ~(strcmpi(obj.BiasDACMode(ii), 'Toggle') || strcmpi(obj.BiasDACMode(ii), 'On'))
                    error('Expected ''Toggle'' or ''On'' for property, BiasDACMode');
                end
                if strcmpi(obj.BiasDACMode(ii), 'Toggle')
                    ivalues(ii) = '1';
                else
                    ivalues(ii) = '0';
                end
            end
            setAllChipsDeviceAttributeRAW(obj, 'bias_ctrl', ivalues, true);
            setAllChipsDeviceAttributeRAW(obj, 'common_mem_enable', num2str(obj.CommonMemEnable), true);
            setAllChipsDeviceAttributeRAW(obj, 'static_rx_beam_pos_load', convertStringsToChars(string(int32(obj.CommonRxBeamState))), false);
            setAllChipsDeviceAttributeRAW(obj, 'static_tx_beam_pos_load', convertStringsToChars(string(int32(obj.CommonTxBeamState))), false);
            ivalues = char(ones(size(obj.ExternalTRPin)) * '0');
            for ii = 1:numel(obj.ExternalTRPin)
                if ~(strcmpi(obj.ExternalTRPin(ii), 'Pos') || strcmpi(obj.ExternalTRPin(ii), 'Neg'))
                    error('Expected ''Pos'' or ''Neg'' for property, ExternalTRPin');
                end
                if strcmpi(obj.ExternalTRPin(ii), 'Neg')
                    ivalues(ii) = '1';
                else
                    ivalues(ii) = '0';
                end
            end
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_tr_mode_sel', ivalues, true);
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_tr_state', num2str(obj.ExternalTRPolarity), true);
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_off', convertStringsToChars(string(int32(obj.LNABiasOff / obj.BIAS_CODE_TO_VOLTAGE_SCALE))), false);
            setAllChipsDeviceAttributeRAW(obj, 'pol', num2str(obj.PolState), true);
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_en_pol', num2str(obj.PolSwitchEnable), true);
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_rx_lna', convertStringsToChars(string(int32(obj.RxLNABiasCurrent))), false);
            setAllChipsDeviceAttributeRAW(obj, 'rx_lna_enable', num2str(obj.RxLNAEnable), true);
            setAllChipsDeviceAttributeRAW(obj, 'rx_to_tx_delay_1', convertStringsToChars(string(int32(obj.RxToTxDelay1))), false);
            setAllChipsDeviceAttributeRAW(obj, 'rx_to_tx_delay_2', convertStringsToChars(string(int32(obj.RxToTxDelay2))), false);
            setAllChipsDeviceAttributeRAW(obj, 'rx_vga_enable', num2str(obj.RxVGAEnable), true);
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_rx', convertStringsToChars(string(int32(obj.RxVGABiasCurrentVM))), false);
            setAllChipsDeviceAttributeRAW(obj, 'rx_vm_enable', num2str(obj.RxVMEnable), true);
            setAllChipsDeviceAttributeRAW(obj, 'sequencer_enable', num2str(obj.SequencerEnable), true);
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_en_tr', num2str(obj.TRSwitchEnable), true);
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_tx_drv', convertStringsToChars(string(int32(obj.TxPABiasCurrent))), false);
            setAllChipsDeviceAttributeRAW(obj, 'tx_drv_enable', num2str(obj.TxPAEnable), true);
            setAllChipsDeviceAttributeRAW(obj, 'tx_to_rx_delay_1', convertStringsToChars(string(int32(obj.TxToRxDelay1))), false);
            setAllChipsDeviceAttributeRAW(obj, 'tx_to_rx_delay_2', convertStringsToChars(string(int32(obj.TxToRxDelay2))), false);
            setAllChipsDeviceAttributeRAW(obj, 'tx_vga_enable', num2str(obj.TxVGAEnable), true);
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_tx', convertStringsToChars(string(int32(obj.TxVGABiasCurrentVM))), false);
            setAllChipsDeviceAttributeRAW(obj, 'tx_vm_enable', num2str(obj.TxVMEnable), true);

            % Write channel attributes
            setAllChipsChannelAttribute(obj, int64(obj.PABiasOff / obj.BIAS_CODE_TO_VOLTAGE_SCALE), 'pa_bias_off', true, 'int64');
            setAllChipsChannelAttribute(obj, int64(obj.PABiasOn / obj.BIAS_CODE_TO_VOLTAGE_SCALE), 'pa_bias_on', true, 'int32');
            setAllChipsChannelAttribute(obj, obj.RxAttn, 'attenuation', false, 'logical');
            setAllChipsChannelAttribute(obj, obj.RxBeamState, 'beam_pos_load', false, 'int32');
            setAllChipsChannelAttribute(obj, ~obj.RxPowerDown, 'powerdown', false, 'logical');
            setAllChipsChannelAttribute(obj, obj.RxGain, 'hardwaregain', false, 'double');
            setAllChipsChannelAttribute(obj, obj.RxPhase, 'phase', false, 'double', 4);
            setAllChipsChannelAttribute(obj, obj.TxAttn, 'attenuation', true, 'logical');
            setAllChipsChannelAttribute(obj, obj.TxBeamState, 'beam_pos_load', true, 'int32');
            setAllChipsChannelAttribute(obj, ~obj.TxPowerDown, 'powerdown', true, 'logical');
            setAllChipsChannelAttribute(obj, obj.TxGain, 'hardwaregain', true, 'double');
            setAllChipsChannelAttribute(obj, obj.TxPhase, 'phase', true, 'double', 4);
            setAllChipsChannelAttribute(obj, obj.RxSequencerStart, 'sequence_start', false, 'logical');
            setAllChipsChannelAttribute(obj, obj.RxSequencerStop, 'sequence_end', false, 'logical');
            setAllChipsChannelAttribute(obj, obj.TxSequencerStart, 'sequence_start', true, 'logical');
            setAllChipsChannelAttribute(obj, obj.TxSequencerStop, 'sequence_end', true, 'logical');

            % Latch settings
            obj.LatchRxSettings();
            obj.LatchTxSettings();
        end
        
        function setupImpl(obj)
            setupLib(obj);
            initPointers(obj);
            getContext(obj);
            setContextTimeout(obj);
            obj.needsTeardown = true;
            obj.ConnectedToDevice = true;
            setupInit(obj);
        end
        
        function [data,valid] = stepImpl(~)
            data = 0;
            valid = false;
        end
    end
end