function [ vec ] = analyze_alm( adj, noun, vectors, model )
%ANALYZE_ALM Summary of this function goes here
%   Detailed explanation goes here

vec = [1, vectors(noun, :)] * model(:,:,adj);
vec = vec';

end