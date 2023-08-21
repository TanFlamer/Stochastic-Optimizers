% runs an entire experiment for benchmarking bipopcmaes.m
% on the noise-free testbed. fgeneric.m and benchmarks.m
% must be in the path of Matlab/Octave
% CAPITALIZATION indicates code adaptations to be made

% Need to change both of the path names.
addpath('..');  % should point to fgeneric.m etc.
datapath = '..\results';  % different folder for each experiment
opt.algName = 'BIPOPCMA-ES';
opt.comments = ['More details has been hidden out when running the code from the original version to make compiling the FSMap easier.' ...
    'Line 1769 - 1772 has been commented out.' ...
    'Line 1747 - 1749 has been commented out.' ...
    'Line 1740 - 1745 has been commented out.' ...
    'Line 882 - 887 has been commented out.' ...
    'Line 1730 - 1733 has been commented out.' ...
    'defpots.MaxFunEvals is set to 5000' ...
    'defopts.Seed = sum(20313854)'];

maxfunevals = '5000'; % 10*dim is a short test-experiment taking a few minutes 
                          % INCREMENT maxfunevals successively to larger value(s)
minfunevals = '1000';  % PUT MINIMAL SENSIBLE NUMBER OF EVALUATIONS for a restart
maxrestarts = 1e4;        % SET to zero for an entirely deterministic algorithm


more off;  % in octave pagination is on by default

t0 = clock;
rand('state', 20313854);

for dim = [2,3,5,10,20]  % small dimensions first, for CPU reasons
  for ifun = benchmarks('FunctionIndices')  % or benchmarksnoisy(...)
    for iinstance = 1:15  % first 15 function instances

      opts.stopfit = fgeneric('initialize', ifun, iinstance, datapath,opt); 

      bipopcmaes('fgeneric', ['8 * rand(' num2str(dim) ', 1) - 4'], 2, opts);

      
      disp(sprintf(['  f%d in %d-D, instance %d: FEs=%d with %.4e fbest,' ...
                    ' fbest-ftarget=%.4e, elapsed time [h]: %.2f'], ...
                   ifun, dim, iinstance, ...
                   fgeneric('evaluations'), ...
                   fgeneric('fbest'), ...
                   fgeneric('fbest') - fgeneric('ftarget'), ...
                   etime(clock, t0)/60/60));   

      fgeneric('finalize');

    end
    disp(['      date and time: ' num2str(clock, ' %.0f')]);
  end
  disp(sprintf('---- dimension %d-D done ----', dim));
 end

