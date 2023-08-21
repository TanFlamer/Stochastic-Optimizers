addpath('..');  % point to fgeneric.m etc.
datapath = '..\results';  % different folder for each experiment
opt.algName = 'DEAE';
opt.comments = 'Population size = 20; Crossover Probability = 0.7; CCOVFAC OF AE = 8';
maxfunevals = '5000';
minfunevals = '1000';
maxrestarts = 1e4;

more off;  % in octave pagination is on by default

t0 = clock;
rand('state', 20313854);

for dim = [2,3,5,10,20]  % small dimensions first, for CPU reasons
  for ifun = benchmarks('FunctionIndices')
    for iinstance = [1:15]  % first 15 function instances
      fgeneric('initialize', ifun, iinstance, datapath, opt); 

      % independent restarts until maxfunevals or ftarget is reached
      for restarts = 0:maxrestarts
        DEAE('fgeneric', dim, fgeneric('ftarget'), ...
                     eval(maxfunevals) - fgeneric('evaluations'));
        if fgeneric('fbest') < fgeneric('ftarget') || ...
           fgeneric('evaluations') + eval(minfunevals) > eval(maxfunevals)
          break;
        end  
      end

      disp(sprintf(['  f%d in %d-D, instance %d: FEs=%d with %d restarts,' ...
                    ' fbest-ftarget=%.4e, elapsed time [h]: %.2f'], ...
                   ifun, dim, iinstance, ...
                   fgeneric('evaluations'), ...
                   restarts, ...
                   fgeneric('fbest') - fgeneric('ftarget'), ...
                   etime(clock, t0)/60/60));

      fgeneric('finalize');
    end
    disp(['      date and time: ' num2str(clock, ' %.0f')]);
  end
  disp(sprintf('---- dimension %d-D done ----', dim));
end

