
addpath(genpath('src'));

% setup

options = [];
options.reduce = 'random';
options.dim = 50;

options.alm = [];
options.alm.n_components = 20;

options.gen = [];
options.gen.tie_adjs = 1;

options.minFunc = [];
options.minFunc.DerivativeCheck = 0;
options.minFunc.MaxIter = 5;

% load data

if ~exist('vectors', 'var')
    %load('data/vectors/tTest/matrix.txt');
    load('data/vectors/freq/matrix.txt');
    matrix(:,1:2) = matrix(:,1:2) + 1;
    raw_vectors = spconvert(matrix);
    
    if strcmp(options.reduce, 'svd')
        [vectors, ~, ~] = svds(raw_vectors, options.dim);
    elseif strcmp(options.reduce, 'random')
        chosen = randperm(size(raw_vectors,2)) <= options.dim;
        vectors = raw_vectors(:,chosen);
    else
        vectors = raw_vectors;
    end
    clear matrix raw_vectors;

    load('data/eval/train_dist_pairs.mat');
    load('data/eval/train_sim_pairs.mat');
    simdata = load('data/eval/sim10.mat');
    
    %dist_pairs = dist_pairs(1:10,:);

    [pdist_pairs, psim_pairs, pvectors, psimdata] = ...
        partition_vectors(dist_pairs, sim_pairs, vectors, simdata);
end

% vector-only models

% eval_sim10('noun', @analyze_noun, simdata, vectors);
% eval_sim10('sum', @analyze_sum, simdata, vectors);
% eval_sim10('product', @analyze_prod, simdata, vectors);

% distributionally-trained models

% model_alm = train_alm(vectors, pairs, options);
% eval_sim10('ALM', @analyze_alm, vectors, model_alm);

%model_gen_dist = train_gen_dist(pvectors, pdist_pairs, options);
eval_sim10('gen-dist', @analyze_gen, psimdata, model_gen_dist, options);

% pair-trained models

% model_gen_pair = train_gen_pair(pvectors, sim_pairs, options);