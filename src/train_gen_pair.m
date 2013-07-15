function [ model ] = train_gen_pair( vectors, sims, options )
%TRAIN_GEN_DISTRIBUTIONALLY Summary of this function goes here
%   Detailed explanation goes here

n_vectors = size(vectors, 1);
n_sims = size(sims, 1);

% initialization

params = [];
params.adjs = zeros(options.dim, options.dim, n_vectors);
for i=1:n_vectors
    params.adjs(:,:,i) = eye(options.dim);
end
params.pairs = zeros(n_sims, options.dim);
params.noise = 0.1;
params.theta_adj = rand(options.dim, n_vectors);
params.theta_noun = rand(options.dim, n_vectors);

consts = [];
consts.vectors = vectors;
consts.sims = sims;
consts.n_vectors = n_vectors;
consts.n_sims = n_sims;

uw_params = unwrap(params);
uw_opt_params = minFunc(@gen_likelihood_pair, uw_params, options.minFunc, ...
                        consts, options, params);
opt_params = rewrap(params, uw_opt_params);
                    
model = [];
model.vectors = vectors;
model.adjs = opt_params.adjs;
model.theta_adj = opt_params.theta_adj;
model.theta_noun = opt_params.theta_noun;

end

