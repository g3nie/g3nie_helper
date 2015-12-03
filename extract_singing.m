startup;

% fprintf('compiling the code...');
% compile;
% fprintf('done.\n\n');

%% Define all folders
PROJECT_ROOT = '/h/u14/g4/00/g3nie/CSC420/Project/singing/';
CROPPED = [PROJECT_ROOT 'cropped/'];

folder = dir(PROJECT_ROOT);
folder_size = size(PROJECT_ROOT, 2);


%% Load face_final ONCE
load('../face_final.mat'); % Loads model variable with goodies
model.vis = @() visualizemodel(model, 1:2:length(model.rules{model.start}));
thresh = -0.3;

how_many = 1;
for i = 1:folder_size
	if folder(i).isdir 
		continue
	end

	current_filename = [PROJECT_ROOT folder(i).name];

	fprintf('///// Running for: %s \n', current_filename);
	%% Get detection
	current_im = imread(current_filename);
	[height, width, ~] = size(current_im);
	cls = model.class;

	%% Detect objects
	[ds, bs] = imgdetect(current_im, model, thresh);
	top = nms(ds, 0.4);
	clf;

	%% Interested in ds(top,:)
	%% showboxes(im, ds(top,:));
	ds = ds(top,:);
	ds_size = size(ds, 1);

	for faces = 1:ds_size
		%% Really bad log score, skip under neg ones
		%% Skip non-reals log score
		%% Match with respect to the best one
		current_ds = ds(faces,:);
		if ~isreal(log(current_ds(6))) || (log(current_ds(6)) < -1.1)
			continue;
		end

		%% Make sure valid indices
		x1 = max(1, floor(current_ds(1)));
		y1 = max(1, floor(current_ds(2)));
		x2 = min(width, floor(current_ds(3)));
		y2 = min(height, floor(current_ds(4)));

		face_filename = [CROPPED 'singing' int2str(how_many) '.png'];
		imwrite(imresize(current_im(y1:y2,x1:x2,:), [32 32]), face_filename);
		how_many = how_many + 1;
	end
	fprintf('Done \n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
