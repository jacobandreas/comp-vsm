function [ model ] = train_gen_dist( vectors, pairs, options )
%TRAIN_GEN_DISTRIBUTIONALLY Summary of this function goes here
%   Detailed explanation goes here

n_adjs = size(vectors.adjs, 1);
n_nouns = size(vectors.nouns, 1);
n_pairs = size(pairs, 1);

% initialization

params = [];
if options.gen.tie_adjs
    params.adjs = zeros(options.dim, options.dim);
else
    params.adjs = zeros(options.dim, options.dim, n_adjs);
    for i=1:n_adjs
        params.adjs(:,:,i) = eye(options.dim);
    end
end
params.noise = 0.1;
params.theta_adj = rand(options.dim, n_adjs);
params.theta_noun = rand(options.dim, n_nouns);

consts = [];
consts.vectors = vectors;
consts.pairs = pairs;
consts.n_adjs = n_adjs;
consts.n_nouns = n_nouns;
consts.n_pairs = n_pairs;

uw_params = unwrap(params);
uw_opt_params = minFunc(@gen_likelihood_dist, uw_params, options.minFunc, ...
                        consts, options, params);
opt_params = rewrap(params, uw_opt_params);
                    
model = [];
model.vectors = vectors;
model.adjs = opt_params.adjs;
model.theta_adj = opt_params.theta_adj;
model.theta_noun = opt_params.theta_noun;

end

