function [ vec ] = analyze_sum( adj, noun, vectors )
%VSM_SUM Summary of this function goes here
%   Detailed explanation goes here

vec = vectors(adj,:)' + vectors(noun,:)';

end