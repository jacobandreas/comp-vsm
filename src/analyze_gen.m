function [ vec ] = analyze_gen( adj, noun, model, options )
%ANALYZE_ALM Summary of this function goes here
%   Detailed explanation goes here

myoptions = [];
%myoptions.DerivativeCheck = 1;

init = zeros(2*options.dim, 1);
combined_vec = minFunc(@gen_prob_adj_noun, init, myoptions, adj, noun, model, options);
vec = combined_vec(size(combined_vec)/2+1:end);

end