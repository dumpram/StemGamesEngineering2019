clear all;

%% Task 2
fprintf('Building test files for Task 2...\n');

% Data generator - elementary stream
Ncoords = 100;
dataset_string = '';
for ii=1:Ncoords
    dataset_string = sprintf( ...
        '%s%03d,%03d,%03d;', ...
        dataset_string, ...
        round(rand*100),round(rand*100),round(rand*100) ...
    );
end

dataset_tmp = double(dataset_string);
dataset_tmp = de2bi(dataset_tmp, 8);
dataset_tmp = fliplr(dataset_tmp);
dataset_tmp = reshape(dataset_tmp', [], 1);
dataset = dataset_tmp';

% Data generator - Additional stream
Ncoords = 1000;
dataset_additional_string = '';
for ii=1:Ncoords
    dataset_additional_string = sprintf( ...
        '%s%03d,%03d,%03d;', ...
        dataset_additional_string, ...
        round(rand*100),round(rand*100),round(rand*100) ...
    );
end

dataset_additional_tmp = double(dataset_additional_string);
dataset_additional_tmp = de2bi(dataset_additional_tmp, 8);
dataset_additional_tmp = fliplr(dataset_additional_tmp);
dataset_additional_tmp = reshape(dataset_additional_tmp', [], 1);
dataset_additional = dataset_additional_tmp';

%% Frame builder - elementary stream

preamble_hex = {'a','5','a','5','a','5','a','5','a','5','a','5','a','5','a','5'};
preamble_tmp = hex2dec(preamble_hex)';
preamble_tmp = de2bi(preamble_tmp);
preamble_tmp = fliplr(preamble_tmp);
preamble_tmp = reshape(preamble_tmp',[],1);
preamble = preamble_tmp';

postamble_hex = {'5','a','5','a','5','a','5','a','5','a','5','a','5','a','5','a'};
postamble_tmp = hex2dec(postamble_hex)';
postamble_tmp = de2bi(postamble_tmp);
postamble_tmp = fliplr(postamble_tmp);
postamble_tmp = reshape(postamble_tmp,[],1);
postamble = postamble_tmp';

data_length_min = 64;
data_length_max = 248;

frame_size_min = 32+8+data_length_min+32;

frames = [];
noOfFrames = 0;
while 1
    % Zero padding
    if length(dataset) < data_length_min
        tmp = zeros(1,data_length_min);
        tmp(1,1:length(dataset)) = dataset;
        dataset = tmp;
        data_length = data_length_min;
    else
        % Random frame size
        data_length = round(data_length_min/8 + (data_length_max/8-data_length_min/8).*rand);
        data_length = data_length*8;

        % Floor if too large
        if length(dataset) < data_length
            data_length = length(dataset);
        end
    end

    % Header
    header = de2bi(data_length, 8);

    % CRC hash
    hash_tmp = reshape(dataset(1,1:data_length),8,[]);
    hash_tmp = fliplr(hash_tmp');
    hash_tmp = bi2de(hash_tmp);
    hash_string = CRC_16_CCITT(hash_tmp);
    hash_tmp2 = double(hash_string);
    hash_tmp2 = de2bi(hash_tmp2, 8);
    hash_tmp2 = fliplr(hash_tmp2);
    hash_tmp2 = reshape(hash_tmp2', [], 1);
    hash = hash_tmp2';

    % Create frame
    frame = [preamble header dataset(1,1:data_length) hash postamble];
    frames = [frames frame];
    noOfFrames = noOfFrames + 1;
    
    % Cut the rest of the dataset
    if length(dataset) > data_length
        dataset = dataset(1,data_length+1:end);
    else
        clear dataset;
        break;
    end
end
fprintf('Generated %d frames.\n', noOfFrames);

% Unwrap frames
frames_reshape = reshape(frames',[],1);

%% Frame builder - additional stream

preamble_hex = {'a','5','a','5','a','5','a','5','a','5','a','5','a','5','a','5'};
preamble_tmp = hex2dec(preamble_hex)';
preamble_tmp = de2bi(preamble_tmp);
preamble_tmp = fliplr(preamble_tmp);
preamble_tmp = reshape(preamble_tmp',[],1);
preamble = preamble_tmp';

postamble_hex = {'5','a','5','a','5','a','5','a','5','a','5','a','5','a','5','a'};
postamble_tmp = hex2dec(postamble_hex)';
postamble_tmp = de2bi(postamble_tmp);
postamble_tmp = fliplr(postamble_tmp);
postamble_tmp = reshape(postamble_tmp,[],1);
postamble = postamble_tmp';

data_length_min = 64;
data_length_max = 248;

frame_size_min = 32+8+data_length_min+32;

frames_additional = [];
noOfFrames = 0;
while 1
    % Zero padding
    if length(dataset_additional) < data_length_min
        tmp = zeros(1,data_length_min);
        tmp(1,1:length(dataset_additional)) = dataset_additional;
        dataset_additional = tmp;
        data_length = data_length_min;
    else
        % Random frame size
        data_length = round(data_length_min/8 + (data_length_max/8-data_length_min/8).*rand);
        data_length = data_length*8;

        % Floor if too large
        if length(dataset_additional) < data_length
            data_length = length(dataset_additional);
        end
    end

    % Header
    header = de2bi(data_length, 8);

    % CRC hash
    hash_tmp = reshape(dataset_additional(1,1:data_length),8,[]);
    hash_tmp = fliplr(hash_tmp');
    hash_tmp = bi2de(hash_tmp);
    hash_string = CRC_16_CCITT(hash_tmp);
    hash_tmp2 = double(hash_string);
    hash_tmp2 = de2bi(hash_tmp2, 8);
    hash_tmp2 = fliplr(hash_tmp2);
    hash_tmp2 = reshape(hash_tmp2', [], 1);
    hash = hash_tmp2';

    % Create frame
    frame = [preamble header dataset_additional(1,1:data_length) hash postamble];
    frames_additional = [frames_additional frame];
    noOfFrames = noOfFrames + 1;
    
    % Cut the rest of the dataset
    if length(dataset_additional) > data_length
        dataset_additional = dataset_additional(1,data_length+1:end);
    else
        clear dataset_additional;
        break;
    end
end
fprintf('Generated %d frames.\n', noOfFrames);

% Unwrap frames
frames_additional_reshape = reshape(frames_additional',[],1);

%% Frame distribution

noSubcarriers = 10;

% Zero pad for OFDM multiplexing
if (mod(length(frames_additional_reshape),2*noSubcarriers) ~= 0)
    frames_additional_reshape_tmp = zeros(length(frames_additional_reshape)+2*noSubcarriers-mod(length(frames_additional_reshape),2*noSubcarriers),1);
    frames_additional_reshape_tmp(1:length(frames_additional_reshape)) = frames_additional_reshape;
    frames_additional_reshape = frames_additional_reshape_tmp;
end

subcarrierStreamLength = length(frames_additional_reshape)/noSubcarriers;
subcarrierStream = zeros(noSubcarriers,subcarrierStreamLength);
for pos=1:2:subcarrierStreamLength-1
    for ii=1:noSubcarriers
        originalPos = (pos-1)*noSubcarriers+(ii-1)*2+1;
        subcarrierStream(ii,pos:pos+1) = frames_additional_reshape(originalPos:originalPos+1,1)';
    end
end

%% Snip stream lengths
% so that the signal ends simultaneously for both streams
if (size(subcarrierStream,2) < length(frames_reshape))
    frames_reshape = frames_reshape(1:size(subcarrierStream,2));
else
    subcarrierStream = subcarrierStream(:,length(frames_reshape));
end

%% QPSK modulator

qpskmod = comm.QPSKModulator('BitInput',true);

% Elementary stream
qpsk_modulated = step(qpskmod,frames_reshape);

% Additional streams
qpsk_additional_modulated = [];
for ii=1:noSubcarriers
    qpsk_additional_modulated(:,ii) = step(qpskmod,subcarrierStream(ii,:)');
end

return;

%% Modulate to carrier

close all;

% fs is high because we are in continuous domain
fs = 192e3;
% number of samples per symbol
N = 20;
fprintf('Rs = %2.00f baud\n', fs/N);
% Time scale
t = 0:1/fs:(N - 1) * 1/fs;
% carrier frequency
fc = 12.8e3;
fprintf('fc = %2.00f Hz\n', fc);

modulated_output = [];
for ii=1:length(qpsk_modulated)
    carrier = abs(qpsk_modulated(ii)) .* cos(2 * pi * fc .* t + angle(qpsk_modulated(ii)));
    modulated_output = [modulated_output carrier];
end